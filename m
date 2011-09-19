Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4573 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab1ISV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:31 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 20/20] staging: brcm80211: reduced checkpatch warnings
 to zero
Date: Mon, 19 Sep 2011 14:26:08 -0700
Message-ID: <1316467568-27683-21-git-send-email-frankyl@broadcom.com> (sfid-20110919_232834_412775_63A6372C)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Both community and Broadcom patches introduced checkpatch warnings.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   27 ++-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   10 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   23 ++-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   15 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  215 ++++++++++++---------
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |   14 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |    3 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c       |    3 +-
 drivers/staging/brcm80211/brcmsmac/srom.c         |    3 +-
 9 files changed, 177 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1cbdb80..bff5066 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -96,7 +96,8 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 						    (sdiodev->func[2]);
 						if (err_ret)
 							brcmf_dbg(ERROR,
-								  "enable F2 failed:%d\n",
+								  "enable F2 "
+								  "failed:%d\n",
 								  err_ret);
 					} else {
 						/* Disable Function 2 */
@@ -105,7 +106,8 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 						    (sdiodev->func[2]);
 						if (err_ret)
 							brcmf_dbg(ERROR,
-								  "Disable F2 failed:%d\n",
+								  "Disable F2 "
+								  "failed:%d\n",
 								  err_ret);
 					}
 					sdio_release_host(sdiodev->func[2]);
@@ -124,8 +126,8 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 					    regaddr, &err_ret);
 				sdio_release_host(sdiodev->func[func]);
 			} else if (regaddr < 0xF0) {
-				brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n",
-					  regaddr);
+				brcmf_dbg(ERROR, "F0 Wr:0x%02x: write "
+					  "disallowed\n", regaddr);
 			} else {
 				/* Claim host controller, perform F0 write,
 				 and release */
@@ -160,7 +162,8 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	}
 
 	if (err_ret)
-		brcmf_dbg(ERROR, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
+		brcmf_dbg(ERROR, "Failed to %s byte F%d:@0x%05x=%02x, "
+			  "Err: %d\n",
 			  rw ? "write" : "read", func, regaddr, *byte, err_ret);
 
 	return err_ret;
@@ -260,11 +263,13 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 		}
 
 		if (err_ret) {
-			brcmf_dbg(ERROR, "%s FAILED %p[%d], addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
+			brcmf_dbg(ERROR, "%s FAILED %p[%d], addr=0x%05x, "
+				  "pkt_len=%d, ERR=0x%08x\n",
 				  write ? "TX" : "RX", pnext, SGCount, addr,
 				  pkt_len, err_ret);
 		} else {
-			brcmf_dbg(TRACE, "%s xfr'd %p[%d], addr=0x%05x, len=%d\n",
+			brcmf_dbg(TRACE, "%s xfr'd %p[%d], addr=0x%05x, "
+				  "len=%d\n",
 				  write ? "TX" : "RX", pnext, SGCount, addr,
 				  pkt_len);
 		}
@@ -316,8 +321,8 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			  write ? "TX" : "RX", buflen_u);
 		mypkt = brcmu_pkt_buf_get_skb(buflen_u);
 		if (!mypkt) {
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
-				  buflen_u);
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len "
+				  "%d\n", buflen_u);
 			return -EIO;
 		}
 
@@ -342,8 +347,8 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			  write ? "TX" : "RX", pkt->len);
 		mypkt = brcmu_pkt_buf_get_skb(pkt->len);
 		if (!mypkt) {
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
-				  pkt->len);
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: "
+				  "len %d\n", pkt->len);
 			return -EIO;
 		}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 4c171a3..f9dfd72 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -290,7 +290,8 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 		goto done;
 
 	if (prot->pending == true) {
-		brcmf_dbg(TRACE, "CDC packet is pending!!!! cmd=0x%x (%lu) lastcmd=0x%x (%lu)\n",
+		brcmf_dbg(TRACE, "CDC packet is pending!!!! cmd=0x%x (%lu) "
+			  "lastcmd=0x%x (%lu)\n",
 			  ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
 			  (unsigned long)prot->lastcmd);
 		if ((ioc->cmd == BRCMF_C_SET_VAR) ||
@@ -405,8 +406,8 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
-		brcmf_dbg(INFO, "%s: BDC packet received with good rx-csum, flags 0x%x\n",
-			  brcmf_ifname(drvr, *ifidx), h->flags);
+		brcmf_dbg(INFO, "%s: BDC packet received with good rx-csum, "
+			  "flags 0x%x\n", brcmf_ifname(drvr, *ifidx), h->flags);
 		pkt_set_sum_good(pktbuf, true);
 	}
 
@@ -427,7 +428,8 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
-		brcmf_dbg(ERROR, "struct brcmf_proto is not correctly defined\n");
+		brcmf_dbg(ERROR,
+			  "struct brcmf_proto is not correctly defined\n");
 		goto fail;
 	}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 963d1a9..ee49688 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -219,7 +219,8 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 	}
 
 	brcmf_dbg(EVENT, "EVENT: %s, event ID = %d\n", event_name, event_type);
-	brcmf_dbg(EVENT, "flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
+	brcmf_dbg(EVENT,
+		  "flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
 		  flags, status, reason, auth_type, eabuf);
 
 	if (flags & BRCMF_EVENT_MSG_LINK)
@@ -250,10 +251,12 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, TIMEOUT\n",
 				  event_name, eabuf);
 		else if (status == BRCMF_E_STATUS_FAIL)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, FAILURE, reason %d\n",
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, FAILURE, "
+				  "reason %d\n",
 				  event_name, eabuf, (int)reason);
 		else
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, unexpected status %d\n",
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, unexpected "
+				  "status %d\n",
 				  event_name, eabuf, (int)status);
 		break;
 
@@ -283,7 +286,8 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
 				  event_name, eabuf, auth_str);
 		else if (status == BRCMF_E_STATUS_FAIL) {
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, FAILURE, reason %d\n",
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, FAILURE, "
+				  "reason %d\n",
 				  event_name, eabuf, auth_str, (int)reason);
 		}
 
@@ -524,7 +528,8 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 {
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		brcmf_dbg(ERROR, "Mask invalid format. Needs to start with 0x\n");
+		brcmf_dbg(ERROR,
+			  "Mask invalid format. Needs to start with 0x\n");
 		return -EINVAL;
 	}
 	src = src + 2;		/* Skip past 0x */
@@ -759,8 +764,8 @@ static void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, retcode = %d\n",
-			  arp_mode, retcode);
+		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, "
+			  "retcode = %d\n", arp_mode, retcode);
 	else
 		brcmf_dbg(TRACE, "successfully set ARP offload mode to 0x%x\n",
 			  arp_mode);
@@ -776,8 +781,8 @@ static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		brcmf_dbg(TRACE, "failed to enable ARP offload to %d, retcode = %d\n",
-			  arp_enable, retcode);
+		brcmf_dbg(TRACE, "failed to enable ARP offload to %d, "
+			  "retcode = %d\n", arp_enable, retcode);
 	else
 		brcmf_dbg(TRACE, "successfully enabled ARP offload to %d\n",
 			  arp_enable);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 3ae0d43..4c63d22 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -207,8 +207,8 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	if (!brcmu_mkiovar
 	    ("allmulti", (void *)&allmulti_le,
 	    sizeof(allmulti_le), buf, buflen)) {
-		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
-			  brcmf_ifname(&drvr_priv->pub, 0),
+		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d "
+			  "buflen %u\n", brcmf_ifname(&drvr_priv->pub, 0),
 			  (int)sizeof(allmulti), buflen);
 		kfree(buf);
 		return;
@@ -300,8 +300,8 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		 * in case we missed the BRCMF_E_IF_DEL event.
 		 */
 		if (ifp->ndev != NULL) {
-			brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
-				  ifp->ndev->name);
+			brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try "
+				  "free & unregister\n", ifp->ndev->name);
 			netif_stop_queue(ifp->ndev);
 			unregister_netdev(ifp->ndev);
 			free_netdev(ifp->ndev);
@@ -319,11 +319,12 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 			       sizeof(drvr_priv));
 			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
 			if (err != 0) {
-				brcmf_dbg(ERROR, "brcmf_net_attach failed, err %d\n",
-					  err);
+				brcmf_dbg(ERROR, "brcmf_net_attach failed, "
+					  "err %d\n", err);
 				ret = -EOPNOTSUPP;
 			} else {
-				brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
+				brcmf_dbg(TRACE, " ==== pid:%x, net_device for "
+					  "if:%s created ===\n",
 					  current->pid, ifp->ndev->name);
 				ifp->state = 0;
 			}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9f8bcb3..2ebbe9b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -900,8 +900,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 					SDIO_FUNC_1,
 					SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				brcmf_dbg(ERROR, "Devctl error setting CA: %d\n",
-					  err);
+				brcmf_dbg(ERROR, "Devctl error setting CA: "
+					  "%d\n", err);
 				return -EBADE;
 			}
 
@@ -940,8 +940,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 			return -EBADE;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			brcmf_dbg(ERROR, "HT Avail timeout (%d): clkctl 0x%02x\n",
-				  PMU_MAX_TRANSITION_DLY, clkctl);
+			brcmf_dbg(ERROR, "HT Avail timeout (%d): clkctl "
+				  "0x%02x\n", PMU_MAX_TRANSITION_DLY, clkctl);
 			return -EBADE;
 		}
 
@@ -975,8 +975,8 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 			SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		brcmf_dbg(INFO, "CLKCTL: turned OFF\n");
 		if (err) {
-			brcmf_dbg(ERROR, "Failed access turning clock off: %d\n",
-				  err);
+			brcmf_dbg(ERROR,
+				  "Failed access turning clock off: %d\n", err);
 			return -EBADE;
 		}
 	}
@@ -1078,7 +1078,8 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		w_sdreg32(bus, SMB_USE_OOB,
 			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
 		if (retries > retry_limit)
-			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n");
+			brcmf_dbg(ERROR,
+				  "CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n");
 
 		/* Turn off our contribution to the HT clock request */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -1122,7 +1123,8 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 				  &retries);
 
 		if (retries > retry_limit)
-			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP TO CLEAR OOB!!\n");
+			brcmf_dbg(ERROR,
+				  "CANNOT SIGNAL CHIP TO CLEAR OOB!!\n");
 
 		/* Make sure we have SD bus access */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -1160,8 +1162,8 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
-		brcmf_dbg(INFO, "Dongle reports NAK handled, expect rtx of %d\n",
-			  bus->rx_seq);
+		brcmf_dbg(INFO, "Dongle reports NAK handled, expect rtx of "
+			  "%d\n", bus->rx_seq);
 		if (!bus->rxskip)
 			brcmf_dbg(ERROR, "unexpected NAKHANDLED!\n");
 
@@ -1247,8 +1249,8 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 			break;
 
 		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
-			brcmf_dbg(ERROR, "count growing: last 0x%04x now 0x%04x\n",
-				  lastrbc, (hi << 8) + lo);
+			brcmf_dbg(ERROR, "count growing: last 0x%04x now "
+				  "0x%04x\n", lastrbc, (hi << 8) + lo);
 		}
 		lastrbc = (hi << 8) + lo;
 	}
@@ -1302,8 +1304,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
 		if (!dlen || (dlen & 1)) {
-			brcmf_dbg(ERROR, "bad glomd len(%d), ignore descriptor\n",
-				  dlen);
+			brcmf_dbg(ERROR, "bad glomd len(%d), ignore "
+				  "descriptor\n", dlen);
 			dlen = 0;
 		}
 
@@ -1320,8 +1322,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				break;
 			}
 			if (sublen % BRCMF_SDALIGN) {
-				brcmf_dbg(ERROR, "sublen %d not multiple of %d\n",
-					  sublen, BRCMF_SDALIGN);
+				brcmf_dbg(ERROR, "sublen %d not multiple of "
+					  "%d\n", sublen, BRCMF_SDALIGN);
 				usechain = false;
 			}
 			totlen += sublen;
@@ -1337,8 +1339,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			/* Allocate/chain packet for next subframe */
 			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
 			if (pnext == NULL) {
-				brcmf_dbg(ERROR, "bcm_pkt_buf_get_skb failed, num %d len %d\n",
-					  num, sublen);
+				brcmf_dbg(ERROR, "bcm_pkt_buf_get_skb failed, "
+					  "num %d len %d\n", num, sublen);
 				break;
 			}
 			if (!pfirst) {
@@ -1355,11 +1357,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		/* If all allocations succeeded, save packet chain
 			 in bus structure */
 		if (pnext) {
-			brcmf_dbg(GLOM, "allocated %d-byte packet chain for %d subframes\n",
-				  totlen, num);
+			brcmf_dbg(GLOM, "allocated %d-byte packet chain for %d "
+				  "subframes\n", totlen, num);
 			if (BRCMF_GLOM_ON() && bus->nextlen) {
 				if (totlen != bus->nextlen) {
-					brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
+					brcmf_dbg(GLOM, "glomdesc mismatch: "
+						  "nextlen %d glomdesc %d "
+						  "rxseq %d\n",
 						  bus->nextlen, totlen, rxseq);
 				}
 			}
@@ -1412,14 +1416,14 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
 						bus->dataptr);
 			if (sublen != dlen) {
-				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d sublen %d\n",
-					  dlen, sublen);
+				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d "
+					  "sublen %d\n", dlen, sublen);
 				errcode = -1;
 			}
 			pnext = NULL;
 		} else {
-			brcmf_dbg(ERROR, "COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
-				  dlen);
+			brcmf_dbg(ERROR, "COULDN'T ALLOC %d-BYTE GLOM, FORCE "
+				  "FAILURE\n", dlen);
 			errcode = -1;
 		}
 		bus->f2rxdata++;
@@ -1467,11 +1471,12 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 		errcode = 0;
 		if ((u16)~(sublen ^ check)) {
-			brcmf_dbg(ERROR, "(superframe): HW hdr error: len/check 0x%04x/0x%04x\n",
-				  sublen, check);
+			brcmf_dbg(ERROR, "(superframe): HW hdr error: len/check"
+				  " 0x%04x/0x%04x\n", sublen, check);
 			errcode = -1;
 		} else if (roundup(sublen, bus->blocksize) != dlen) {
-			brcmf_dbg(ERROR, "(superframe): len 0x%04x, rounded 0x%04x, expect 0x%04x\n",
+			brcmf_dbg(ERROR, "(superframe): len 0x%04x, rounded "
+				  "0x%04x, expect 0x%04x\n",
 				  sublen, roundup(sublen, bus->blocksize),
 				  dlen);
 			errcode = -1;
@@ -1486,7 +1491,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			errcode = -1;
 		} else if ((doff < SDPCM_HDRLEN) ||
 			   (doff > (pfirst->len - SDPCM_HDRLEN))) {
-			brcmf_dbg(ERROR, "(superframe): Bad data offset %d: HW %d pkt %d min %d\n",
+			brcmf_dbg(ERROR, "(superframe): Bad data offset %d: "
+				  "HW %d pkt %d min %d\n",
 				  doff, sublen, pfirst->len, SDPCM_HDRLEN);
 			errcode = -1;
 		}
@@ -1529,20 +1535,23 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 #endif
 
 			if ((u16)~(sublen ^ check)) {
-				brcmf_dbg(ERROR, "(subframe %d): HW hdr error: len/check 0x%04x/0x%04x\n",
+				brcmf_dbg(ERROR, "(subframe %d): HW hdr error: "
+					  "len/check 0x%04x/0x%04x\n",
 					  num, sublen, check);
 				errcode = -1;
 			} else if ((sublen > dlen) || (sublen < SDPCM_HDRLEN)) {
-				brcmf_dbg(ERROR, "(subframe %d): length mismatch: len 0x%04x, expect 0x%04x\n",
-					  num, sublen, dlen);
+				brcmf_dbg(ERROR, "(subframe %d): length "
+					  "mismatch: len 0x%04x, expect "
+					  "0x%04x\n", num, sublen, dlen);
 				errcode = -1;
 			} else if ((chan != SDPCM_DATA_CHANNEL) &&
 				   (chan != SDPCM_EVENT_CHANNEL)) {
-				brcmf_dbg(ERROR, "(subframe %d): bad channel %d\n",
-					  num, chan);
+				brcmf_dbg(ERROR, "(subframe %d): bad channel "
+					  "%d\n", num, chan);
 				errcode = -1;
 			} else if ((doff < SDPCM_HDRLEN) || (doff > sublen)) {
-				brcmf_dbg(ERROR, "(subframe %d): Bad data offset %d: HW %d min %d\n",
+				brcmf_dbg(ERROR, "(subframe %d): Bad data "
+					  "offset %d: HW %d min %d\n",
 					  num, doff, sublen, SDPCM_HDRLEN);
 				errcode = -1;
 			}
@@ -1581,7 +1590,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
-			brcmf_dbg(GLOM, "Get subframe %d, %p(%p/%d), sublen %d chan %d seq %d\n",
+			brcmf_dbg(GLOM, "Get subframe %d, %p(%p/%d), sublen %d "
+				  "chan %d seq %d\n",
 				  num, pfirst, pfirst->data,
 				  pfirst->len, sublen, chan, seq);
 
@@ -1634,7 +1644,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 #ifdef BCMDBG
 			if (BRCMF_GLOM_ON()) {
-				brcmf_dbg(GLOM, "subframe %d to stack, %p (%p/%d) nxt/lnk %p/%p\n",
+				brcmf_dbg(GLOM, "subframe %d to stack, %p "
+					  "(%p/%d) nxt/lnk %p/%p\n",
 					  num, pfirst, pfirst->data,
 					  pfirst->len, pfirst->next,
 					  pfirst->prev);
@@ -1724,15 +1735,16 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	/* Drop if the read is too big or it exceeds our maximum */
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->drvr->maxctl) {
-		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
-			  rdlen, bus->drvr->maxctl);
+		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte "
+			  "buffer\n", rdlen, bus->drvr->maxctl);
 		bus->drvr->rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
 
 	if ((len - doff) > bus->drvr->maxctl) {
-		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
+		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds "
+			  "%d-byte limit\n",
 			  len, len - doff, bus->drvr->maxctl);
 		bus->drvr->rx_errors++;
 		bus->rx_toolong++;
@@ -1854,7 +1866,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
 			if (!pkt) {
 				/* Give up on data, request rtx of events */
-				brcmf_dbg(ERROR, "(nextlen): brcmu_pkt_buf_get_skb failed: len %d rdlen %d expected rxseq %d\n",
+				brcmf_dbg(ERROR, "(nextlen): brcmu_pkt_buf_get"
+					  "_skb failed: len %d rdlen %d "
+					  "expected rxseq %d\n",
 					  len, rdlen, rxseq);
 				continue;
 			} else {
@@ -1869,7 +1883,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				bus->f2rxdata++;
 
 				if (sdret < 0) {
-					brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
+					brcmf_dbg(ERROR, "(nextlen): read %d "
+						  "bytes failed: %d\n",
 						  rdlen, sdret);
 					brcmu_pkt_buf_free_skb(pkt);
 					bus->drvr->rx_errors++;
@@ -1891,15 +1906,17 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* All zeros means readahead info was bad */
 			if (!(len | check)) {
-				brcmf_dbg(INFO, "(nextlen): read zeros in HW header???\n");
+				brcmf_dbg(INFO, "(nextlen): read zeros in HW "
+					  "header???\n");
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
 			/* Validate check bytes */
 			if ((u16)~(len ^ check)) {
-				brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
-					  nextlen, len, check);
+				brcmf_dbg(ERROR, "(nextlen): HW hdr error: "
+					  "nextlen/len/check 0x%04x/0x%04x/"
+					  "0x%04x\n", nextlen, len, check);
 				bus->rx_badhdr++;
 				brcmf_sdbrcm_rxfail(bus, false, false);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
@@ -1908,8 +1925,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Validate frame length */
 			if (len < SDPCM_HDRLEN) {
-				brcmf_dbg(ERROR, "(nextlen): HW hdr length invalid: %d\n",
-					  len);
+				brcmf_dbg(ERROR, "(nextlen): HW hdr length "
+					  "invalid: %d\n", len);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
@@ -1919,9 +1936,10 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			if (len_consistent) {
 				/* Mismatch, force retry w/normal
 					header (may be >4K) */
-				brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
-					  nextlen, len, roundup(len, 16),
-					  rxseq);
+				brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen "
+					  "%d len %d rnd %d; expected rxseq"
+					  " %d\n", nextlen, len,
+					  roundup(len, 16), rxseq);
 				brcmf_sdbrcm_rxfail(bus, true, true);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
@@ -1941,7 +1959,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			    bus->rxhdr[SDPCM_FRAMETAG_LEN +
 				       SDPCM_NEXTLEN_OFFSET];
 			if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-				brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
+				brcmf_dbg(INFO, "(nextlen): got frame w/nextlen"
+					  " too large (%d), seq %d\n",
 					  bus->nextlen, seq);
 				bus->nextlen = 0;
 			}
@@ -1965,16 +1984,16 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Check and update sequence number */
 			if (rxseq != seq) {
-				brcmf_dbg(INFO, "(nextlen): rx_seq %d, expected %d\n",
-					  seq, rxseq);
+				brcmf_dbg(INFO, "(nextlen): rx_seq %d, expected"
+					  " %d\n", seq, rxseq);
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
 
 			/* Check window for sanity */
 			if ((u8) (txmax - bus->tx_seq) > 0x40) {
-				brcmf_dbg(ERROR, "got unlikely tx max %d with tx_seq %d\n",
-					  txmax, bus->tx_seq);
+				brcmf_dbg(ERROR, "got unlikely tx max %d with "
+					  "tx_seq %d\n", txmax, bus->tx_seq);
 				txmax = bus->tx_seq + 2;
 			}
 			bus->tx_max = txmax;
@@ -1992,7 +2011,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 #endif
 
 			if (chan == SDPCM_CONTROL_CHANNEL) {
-				brcmf_dbg(ERROR, "(nextlen): readahead on control packet %d?\n",
+				brcmf_dbg(ERROR, "(nextlen): readahead on "
+					  "control packet %d?\n",
 					  seq);
 				/* Force retry w/normal header read */
 				bus->nextlen = 0;
@@ -2003,7 +2023,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Validate data offset */
 			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-				brcmf_dbg(ERROR, "(nextlen): bad data offset %d: HW len %d min %d\n",
+				brcmf_dbg(ERROR, "(nextlen): bad data offset "
+					  "%d: HW len %d min %d\n",
 					  doff, len, SDPCM_HDRLEN);
 				brcmf_sdbrcm_rxfail(bus, false, false);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
@@ -2046,7 +2067,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate check bytes */
 		if ((u16) ~(len ^ check)) {
-			brcmf_dbg(ERROR, "HW hdr err: len/check 0x%04x/0x%04x\n",
+			brcmf_dbg(ERROR,
+				  "HW hdr err: len/check 0x%04x/0x%04x\n",
 				  len, check);
 			bus->rx_badhdr++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
@@ -2067,8 +2089,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate data offset */
 		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-			brcmf_dbg(ERROR, "Bad data offset %d: HW len %d, min %d seq %d\n",
-				  doff, len, SDPCM_HDRLEN, seq);
+			brcmf_dbg(ERROR, "Bad data offset %d: HW len %d, min %d"
+				  " seq %d\n", doff, len, SDPCM_HDRLEN, seq);
 			bus->rx_badhdr++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
@@ -2078,8 +2100,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		bus->nextlen =
 		    bus->rxhdr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
-				  bus->nextlen, seq);
+			brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too "
+				  "large (%d), seq %d\n", bus->nextlen, seq);
 			bus->nextlen = 0;
 		}
 
@@ -2154,8 +2176,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					    BRCMF_FIRSTREAD + BRCMF_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
-				  rdlen, chan);
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: "
+				  "rdlen %d chan %d\n", rdlen, chan);
 			bus->drvr->rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
@@ -2311,7 +2333,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 			bus->drvr->tx_realloc++;
 			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
 			if (!new) {
-				brcmf_dbg(ERROR, "couldn't allocate new %d-byte packet\n",
+				brcmf_dbg(ERROR, "couldn't allocate new %d-byte"
+					  " packet\n",
 					  pkt->len + BRCMF_SDALIGN);
 				ret = -ENOMEM;
 				goto done;
@@ -2384,7 +2407,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 
 	if (ret < 0) {
 		/* On failure, abort the command and terminate the frame */
-		brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+		brcmf_dbg(INFO,
+			  "sdio error %d, abort command and terminate frame\n",
 			  ret);
 		bus->tx_sderrs++;
 
@@ -2649,8 +2673,8 @@ clkwait:
 		if (ret < 0) {
 			/* On failure, abort the command and
 				terminate the frame */
-			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-				  ret);
+			brcmf_dbg(INFO, "sdio error %d, abort command and "
+				  "terminate frame\n", ret);
 			bus->tx_sderrs++;
 
 			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
@@ -2698,12 +2722,13 @@ clkwait:
 		 no resched or interrupts */
 	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
 	    brcmf_sdcard_regfail(bus->sdiodev)) {
-		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation %d\n",
-			  brcmf_sdcard_regfail(bus->sdiodev));
+		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting "
+			  "operation %d\n", brcmf_sdcard_regfail(bus->sdiodev));
 		bus->drvr->busstate = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
-		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
+		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting "
+			  "I_CHIPACTIVE interrupt\n");
 		resched = true;
 	} else if (bus->intstatus || bus->ipend ||
 		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
@@ -2854,7 +2879,8 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 
 	/* Do the transfer(s) */
 	while (size) {
-		brcmf_dbg(INFO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
+		brcmf_dbg(INFO,
+			  "%s %d bytes at offset 0x%08x in window 0x%08x\n",
 			  write ? "write" : "read", dsize,
 			  sdaddr, address & SBSDIO_SBWINDOW_MASK);
 		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
@@ -2936,7 +2962,8 @@ brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 	memcpy(sh->tag, sh_le.tag, sizeof(sh->tag));
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		brcmf_dbg(ERROR, "sdpcm_shared version %d in brcmf is different than sdpcm_shared version %d in dongle\n",
+		brcmf_dbg(ERROR, "sdpcm_shared version %d in brcmf is different"
+			  " than sdpcm_shared version %d in dongle\n",
 			  SDPCM_SHARED_VERSION,
 			  sh->flags & SDPCM_SHARED_VERSION_MASK);
 		return -EBADE;
@@ -3262,7 +3289,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
 	if (!data_ok(bus)) {
-		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
+		brcmf_dbg(INFO,
+			  "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
 			  bus->tx_max, bus->tx_seq);
 		bus->ctrl_frame_stat = true;
 		/* Send from dpc */
@@ -3301,8 +3329,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 			if (ret < 0) {
 				/* On failure, abort the command and
 				 terminate the frame */
-				brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-					  ret);
+				brcmf_dbg(INFO, "sdio error %d, abort command "
+					  "and terminate frame\n", ret);
 				bus->tx_sderrs++;
 
 				brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
@@ -3477,14 +3505,16 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		    brcmf_sdbrcm_membytes(bus, false, varaddr, nvram_ularray,
 				     varsize);
 		if (bcmerror) {
-			brcmf_dbg(ERROR, "error %d on reading %d nvram bytes at 0x%08x\n",
-				  bcmerror, varsize, varaddr);
+			brcmf_dbg(ERROR, "error %d on reading %d nvram bytes at"
+				  " 0x%08x\n", bcmerror, varsize, varaddr);
 		}
 		/* Compare the org NVRAM with the one read from RAM */
 		if (memcmp(vbuffer, nvram_ularray, varsize))
-			brcmf_dbg(ERROR, "Downloaded NVRAM image is corrupted\n");
+			brcmf_dbg(ERROR,
+				  "Downloaded NVRAM image is corrupted\n");
 		else
-			brcmf_dbg(ERROR, "Download/Upload/Compare of NVRAM ok\n");
+			brcmf_dbg(ERROR,
+				  "Download/Upload/Compare of NVRAM ok\n");
 
 		kfree(nvram_ularray);
 #endif				/* BCMDBG */
@@ -3745,8 +3775,8 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
 		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
 		if (ret) {
-			brcmf_dbg(ERROR, "error %d on writing %d membytes at 0x%08x\n",
-				  ret, MEMBLOCK, offset);
+			brcmf_dbg(ERROR, "error %d on writing %d membytes at "
+				  "0x%08x\n", ret, MEMBLOCK, offset);
 			goto err;
 		}
 
@@ -4342,7 +4372,8 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 		str_shift = 11;
 		break;
 	default:
-		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
+		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s"
+			  " rev %d pmurev %d\n",
 			  brcmu_chipname(bus->ci->chip, chn, 8),
 			  bus->ci->chiprev, bus->ci->pmurev);
 		break;
@@ -4372,7 +4403,8 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, cc_data_temp);
 
-		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
+		brcmf_dbg(INFO,
+			  "SDIO: %dmA drive strength selected, set to 0x%08x\n",
 			  drivestrength, cc_data_temp);
 	}
 }
@@ -4469,8 +4501,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 				!SBSDIO_ALPAV(clkval)),
 				PMU_MAX_TRANSITION_DLY);
 		if (!SBSDIO_ALPAV(clkval)) {
-			brcmf_dbg(ERROR, "timeout on ALPAV wait, clkval 0x%02x\n",
-				  clkval);
+			brcmf_dbg(ERROR, "timeout on ALPAV wait, clkval "
+				  "0x%02x\n", clkval);
 			err = -EBUSY;
 			goto fail;
 		}
@@ -4481,8 +4513,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 				clkset, &err);
 		udelay(65);
 	} else {
-		brcmf_dbg(ERROR, "ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
-			  clkset, clkval);
+		brcmf_dbg(ERROR, "ChipClkCSR access: wrote 0x%02x read "
+			  "0x%02x\n", clkset, clkval);
 		err = -EACCES;
 		goto fail;
 	}
@@ -4560,8 +4592,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
-		brcmf_dbg(ERROR, "ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
-			  err, BRCMF_INIT_CLKCTL1, clkctl);
+		brcmf_dbg(ERROR, "ChipClkCSR access: err %d wrote 0x%02x read "
+			  "0x%02x\n", err, BRCMF_INIT_CLKCTL1, clkctl);
 		goto fail;
 	}
 
@@ -4982,7 +5014,8 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 				bcmerror = -EIO;
 		} else {
 			bcmerror = -EISCONN;
-			brcmf_dbg(ERROR, "Set DEVRESET=false invoked when device is on\n");
+			brcmf_dbg(ERROR, "Set DEVRESET=false invoked when "
+				  "device is on\n");
 			bcmerror = -EIO;
 		}
 		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index b7b0bdf..f0c5639 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1054,9 +1054,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	cc = (struct chipcregs *) regs;
 
 	/* bus/core/clk setup for register access */
-	if (!ai_buscore_prep(sii)) {
+	if (!ai_buscore_prep(sii))
 		return NULL;
-	}
 
 	/*
 	 * ChipID recognition.
@@ -1084,19 +1083,18 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		return NULL;
 	}
 	/* no cores found, bail out */
-	if (sii->numcores == 0) {
+	if (sii->numcores == 0)
 		return NULL;
-	}
+
 	/* bus/core/clk setup */
 	origidx = SI_CC_IDX;
-	if (!ai_buscore_setup(sii, savewin, &origidx)) {
+	if (!ai_buscore_setup(sii, savewin, &origidx))
 		goto exit;
-	}
 
 	/* Init nvram from sprom/otp if they exist */
-	if (srom_var_init(&sii->pub, cc, vars, varsz)) {
+	if (srom_var_init(&sii->pub, cc, vars, varsz))
 		goto exit;
-	}
+
 	pvars = vars ? *vars : NULL;
 	ai_nvram_process(sii, pvars);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 2c9ac6d..959e90c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5951,9 +5951,8 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	 * If we are switching to gmode == GMODE_LEGACY_B,
 	 * clean up rate info that may refer to OFDM rates.
 	 */
-	if ((gmode == GMODE_LEGACY_B) && (band->gmode != GMODE_LEGACY_B)) {
+	if (gmode == GMODE_LEGACY_B && band->gmode != GMODE_LEGACY_B)
 		band->gmode = gmode;
-	}
 
 	band->gmode = gmode;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index f5a2695..df39afe 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -394,9 +394,8 @@ static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 		i++;
 	}
 
-	if (i >= pcie_serdes_spinwait) {
+	if (i >= pcie_serdes_spinwait)
 		return false;
-	}
 
 	return true;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 5bf0732..ece81ad 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1169,8 +1169,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 			if (sromrev == 0x10)
 				sromrev = 1;
 		}
-	}
-	else {
+	} else {
 		/* Use OTP if SPROM not available */
 		err = otp_read_pci(sih, srom, SROM_MAX);
 		if (err == 0)
-- 
1.7.1


