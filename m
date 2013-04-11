Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4946 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/15] brcmfmac: aggregate dongle ram access interface
Date: Thu, 11 Apr 2013 13:28:47 +0200
Message-ID: <1365679740-25679-3-git-send-email-arend@broadcom.com> (sfid-20130411_132944_584346_A614AA0C)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

For fullmac chips host driver can access to dongle RAM through SDIO function 1.
Introduce brcmf_sdio_ramrw and place it at bcmsdh.c with other interface
functions.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   88 ++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  120 +++++---------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +
 3 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index f3149de..aa51f37 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -457,36 +457,80 @@ done:
 	return err;
 }
 
-int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
-			u8 *buf, uint nbytes)
+int
+brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
+		 u8 *data, uint size)
 {
-	struct sk_buff *mypkt;
-	bool write = rw ? SDIOH_WRITE : SDIOH_READ;
-	int err;
+	int bcmerror = 0;
+	struct sk_buff *pkt;
+	u32 sdaddr;
+	uint dsize;
+
+	dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
+	pkt = dev_alloc_skb(dsize);
+	if (!pkt) {
+		brcmf_err("dev_alloc_skb failed: len %d\n", dsize);
+		return -EIO;
+	}
+	pkt->priority = 0;
 
-	addr &= SBSDIO_SB_OFT_ADDR_MASK;
-	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	/* Determine initial transfer parameters */
+	sdaddr = address & SBSDIO_SB_OFT_ADDR_MASK;
+	if ((sdaddr + size) & SBSDIO_SBWINDOW_MASK)
+		dsize = (SBSDIO_SB_OFT_ADDR_LIMIT - sdaddr);
+	else
+		dsize = size;
 
-	mypkt = brcmu_pkt_buf_get_skb(nbytes);
-	if (!mypkt) {
-		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
-			  nbytes);
-		return -EIO;
+	sdio_claim_host(sdiodev->func[1]);
+
+	/* Do the transfer(s) */
+	while (size) {
+		/* Set the backplane window to include the start address */
+		bcmerror = brcmf_sdcard_set_sbaddr_window(sdiodev, address);
+		if (bcmerror)
+			break;
+
+		brcmf_dbg(SDIO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
+			  write ? "write" : "read", dsize,
+			  sdaddr, address & SBSDIO_SBWINDOW_MASK);
+
+		sdaddr &= SBSDIO_SB_OFT_ADDR_MASK;
+		sdaddr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+
+		skb_put(pkt, dsize);
+		if (write)
+			memcpy(pkt->data, data, dsize);
+		bcmerror = brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_INC,
+						      write, SDIO_FUNC_1,
+						      sdaddr, pkt);
+		if (bcmerror) {
+			brcmf_err("membytes transfer failed\n");
+			break;
+		}
+		if (!write)
+			memcpy(data, pkt->data, dsize);
+		skb_trim(pkt, dsize);
+
+		/* Adjust for next transfer (if any) */
+		size -= dsize;
+		if (size) {
+			data += dsize;
+			address += dsize;
+			sdaddr = 0;
+			dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
+		}
 	}
 
-	/* For a write, copy the buffer data into the packet. */
-	if (write)
-		memcpy(mypkt->data, buf, nbytes);
+	dev_kfree_skb(pkt);
 
-	err = brcmf_sdioh_request_buffer(sdiodev, SDIOH_DATA_INC, write,
-					 SDIO_FUNC_1, addr, mypkt);
+	/* Return the window to backplane enumeration space for core access */
+	if (brcmf_sdcard_set_sbaddr_window(sdiodev, sdiodev->sbwad))
+		brcmf_err("FAILED to set window back to 0x%x\n",
+			  sdiodev->sbwad);
 
-	/* For a read, copy the packet data back to the buffer. */
-	if (!err && !write)
-		memcpy(buf, mypkt->data, nbytes);
+	sdio_release_host(sdiodev->func[1]);
 
-	brcmu_pkt_buf_free_skb(mypkt);
-	return err;
+	return bcmerror;
 }
 
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index fb4ff91..26e34b6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2486,69 +2486,6 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	return ret;
 }
 
-static int
-brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
-		 uint size)
-{
-	int bcmerror = 0;
-	u32 sdaddr;
-	uint dsize;
-
-	/* Determine initial transfer parameters */
-	sdaddr = address & SBSDIO_SB_OFT_ADDR_MASK;
-	if ((sdaddr + size) & SBSDIO_SBWINDOW_MASK)
-		dsize = (SBSDIO_SB_OFT_ADDR_LIMIT - sdaddr);
-	else
-		dsize = size;
-
-	sdio_claim_host(bus->sdiodev->func[1]);
-
-	/* Set the backplane window to include the start address */
-	bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev, address);
-	if (bcmerror) {
-		brcmf_err("window change failed\n");
-		goto xfer_done;
-	}
-
-	/* Do the transfer(s) */
-	while (size) {
-		brcmf_dbg(SDIO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
-			  write ? "write" : "read", dsize,
-			  sdaddr, address & SBSDIO_SBWINDOW_MASK);
-		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
-					       sdaddr, data, dsize);
-		if (bcmerror) {
-			brcmf_err("membytes transfer failed\n");
-			break;
-		}
-
-		/* Adjust for next transfer (if any) */
-		size -= dsize;
-		if (size) {
-			data += dsize;
-			address += dsize;
-			bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev,
-								  address);
-			if (bcmerror) {
-				brcmf_err("window change failed\n");
-				break;
-			}
-			sdaddr = 0;
-			dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
-		}
-	}
-
-xfer_done:
-	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, bus->sdiodev->sbwad))
-		brcmf_err("FAILED to set window back to 0x%x\n",
-			  bus->sdiodev->sbwad);
-
-	sdio_release_host(bus->sdiodev->func[1]);
-
-	return bcmerror;
-}
-
 #ifdef DEBUG
 #define CONSOLE_LINE_MAX	192
 
@@ -2565,8 +2502,8 @@ static int brcmf_sdbrcm_readconsole(struct brcmf_sdio *bus)
 
 	/* Read console log struct */
 	addr = bus->console_addr + offsetof(struct rte_console, log_le);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&c->log_le,
-				   sizeof(c->log_le));
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr, (u8 *)&c->log_le,
+			      sizeof(c->log_le));
 	if (rv < 0)
 		return rv;
 
@@ -2591,7 +2528,7 @@ static int brcmf_sdbrcm_readconsole(struct brcmf_sdio *bus)
 
 	/* Read the console buffer */
 	addr = le32_to_cpu(c->log_le.buf);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, c->buf, c->bufsize);
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr, c->buf, c->bufsize);
 	if (rv < 0)
 		return rv;
 
@@ -2812,8 +2749,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 */
 	sdio_claim_host(bus->sdiodev->func[1]);
 	brcmf_sdbrcm_bus_sleep(bus, false, false);
-	rv = brcmf_sdbrcm_membytes(bus, false, shaddr,
-				   (u8 *)&addr_le, 4);
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, shaddr, (u8 *)&addr_le, 4);
 	sdio_release_host(bus->sdiodev->func[1]);
 	if (rv < 0)
 		return rv;
@@ -2833,8 +2769,8 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	}
 
 	/* Read hndrte_shared structure */
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&sh_le,
-				   sizeof(struct sdpcm_shared_le));
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr, (u8 *)&sh_le,
+			      sizeof(struct sdpcm_shared_le));
 	if (rv < 0)
 		return rv;
 
@@ -2870,22 +2806,22 @@ static int brcmf_sdio_dump_console(struct brcmf_sdio *bus,
 
 	/* obtain console information from device memory */
 	addr = sh->console_addr + offsetof(struct rte_console, log_le);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr,
-			(u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr,
+			      (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_ptr = le32_to_cpu(sh_val);
 
 	addr = sh->console_addr + offsetof(struct rte_console, log_le.buf_size);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr,
-			(u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr,
+			      (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_size = le32_to_cpu(sh_val);
 
 	addr = sh->console_addr + offsetof(struct rte_console, log_le.idx);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr,
-			(u8 *)&sh_val, sizeof(u32));
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, addr,
+			      (u8 *)&sh_val, sizeof(u32));
 	if (rv < 0)
 		return rv;
 	console_index = le32_to_cpu(sh_val);
@@ -2899,8 +2835,8 @@ static int brcmf_sdio_dump_console(struct brcmf_sdio *bus,
 
 	/* obtain the console data from device */
 	conbuf[console_size] = '\0';
-	rv = brcmf_sdbrcm_membytes(bus, false, console_ptr, (u8 *)conbuf,
-				   console_size);
+	rv = brcmf_sdio_ramrw(bus->sdiodev, false, console_ptr, (u8 *)conbuf,
+			      console_size);
 	if (rv < 0)
 		goto done;
 
@@ -2937,8 +2873,8 @@ static int brcmf_sdio_trap_info(struct brcmf_sdio *bus, struct sdpcm_shared *sh,
 		return 0;
 	}
 
-	error = brcmf_sdbrcm_membytes(bus, false, sh->trap_addr, (u8 *)&tr,
-				      sizeof(struct brcmf_trap_info));
+	error = brcmf_sdio_ramrw(bus->sdiodev, false, sh->trap_addr, (u8 *)&tr,
+				 sizeof(struct brcmf_trap_info));
 	if (error < 0)
 		return error;
 
@@ -2981,14 +2917,14 @@ static int brcmf_sdio_assert_info(struct brcmf_sdio *bus,
 
 	sdio_claim_host(bus->sdiodev->func[1]);
 	if (sh->assert_file_addr != 0) {
-		error = brcmf_sdbrcm_membytes(bus, false, sh->assert_file_addr,
-					      (u8 *)file, 80);
+		error = brcmf_sdio_ramrw(bus->sdiodev, false,
+					 sh->assert_file_addr, (u8 *)file, 80);
 		if (error < 0)
 			return error;
 	}
 	if (sh->assert_exp_addr != 0) {
-		error = brcmf_sdbrcm_membytes(bus, false, sh->assert_exp_addr,
-					      (u8 *)expr, 80);
+		error = brcmf_sdio_ramrw(bus->sdiodev, false,
+					 sh->assert_exp_addr, (u8 *)expr, 80);
 		if (error < 0)
 			return error;
 	}
@@ -3162,8 +3098,8 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 
 	if (bus->vars) {
 		/* Write the vars list */
-		bcmerror = brcmf_sdbrcm_membytes(bus, true, varaddr,
-						 bus->vars, bus->varsz);
+		bcmerror = brcmf_sdio_ramrw(bus->sdiodev, true, varaddr,
+					    bus->vars, bus->varsz);
 #ifdef DEBUG
 		/* Verify NVRAM bytes */
 		brcmf_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n",
@@ -3176,8 +3112,8 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 		memset(nvram_ularray, 0xaa, bus->varsz);
 
 		/* Read the vars list to temp buffer for comparison */
-		bcmerror = brcmf_sdbrcm_membytes(bus, false, varaddr,
-						 nvram_ularray, bus->varsz);
+		bcmerror = brcmf_sdio_ramrw(bus->sdiodev, false, varaddr,
+					    nvram_ularray, bus->varsz);
 		if (bcmerror) {
 			brcmf_err("error %d on reading %d nvram bytes at 0x%08x\n",
 				  bcmerror, bus->varsz, varaddr);
@@ -3215,8 +3151,8 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 		  bus->varsz, varsizew);
 
 	/* Write the length token to the last word */
-	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->ramsize - 4),
-					 (u8 *)&varsizew_le, 4);
+	bcmerror = brcmf_sdio_ramrw(bus->sdiodev, true, (bus->ramsize - 4),
+				    (u8 *)&varsizew_le, 4);
 
 	return bcmerror;
 }
@@ -3239,7 +3175,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
 			u32 zeros = 0;
-			brcmf_sdbrcm_membytes(bus, true, bus->ramsize - 4,
+			brcmf_sdio_ramrw(bus->sdiodev, true, bus->ramsize - 4,
 					 (u8 *)&zeros, 4);
 		}
 	} else {
@@ -3308,7 +3244,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 	/* Download image */
 	while ((len =
 		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
-		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
+		ret = brcmf_sdio_ramrw(bus->sdiodev, true, offset, memptr, len);
 		if (ret) {
 			brcmf_err("error %d on writing %d membytes at 0x%08x\n",
 				  ret, MEMBLOCK, offset);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 4e681ae..b9b397b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -242,6 +242,8 @@ brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
  */
 extern int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw,
 			       u32 addr, u8 *buf, uint nbytes);
+extern int brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write,
+			    u32 address, u8 *data, uint size);
 
 /* Issue an abort to the specified function */
 extern int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
-- 
1.7.10.4


