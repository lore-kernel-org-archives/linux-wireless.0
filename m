Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:24316 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaA2Ocg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:36 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/14] brcmfmac: enable firmware console logging functionality
Date: Wed, 29 Jan 2014 15:32:13 +0100
Message-ID: <1391005944-3220-4-git-send-email-arend@broadcom.com> (sfid-20140129_153246_634105_C79B17C8)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

Address of rte console was not initialized and so console logging
functionality didn't kick in. This patch fixes it and makes console
polling interval a debugfs variable.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  154 +++++++++++---------
 1 file changed, 88 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3e99189..98d0784 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -953,6 +953,86 @@ end:
 
 }
 
+#ifdef DEBUG
+static inline bool brcmf_sdio_valid_shared_address(u32 addr)
+{
+	return !(addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff));
+}
+
+static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
+				 struct sdpcm_shared *sh)
+{
+	u32 addr;
+	int rv;
+	u32 shaddr = 0;
+	struct sdpcm_shared_le sh_le;
+	__le32 addr_le;
+
+	shaddr = bus->ci->rambase + bus->ramsize - 4;
+
+	/*
+	 * Read last word in socram to determine
+	 * address of sdpcm_shared structure
+	 */
+	sdio_claim_host(bus->sdiodev->func[1]);
+	brcmf_sdio_bus_sleep(bus, false, false);
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, shaddr, (u8 *)&addr_le, 4);
+	sdio_release_host(bus->sdiodev->func[1]);
+	if (rv < 0)
+		return rv;
+
+	addr = le32_to_cpu(addr_le);
+
+	brcmf_dbg(SDIO, "sdpcm_shared address 0x%08X\n", addr);
+
+	/*
+	 * Check if addr is valid.
+	 * NVRAM length at the end of memory should have been overwritten.
+	 */
+	if (!brcmf_sdio_valid_shared_address(addr)) {
+			brcmf_err("invalid sdpcm_shared address 0x%08X\n",
+				  addr);
+			return -EINVAL;
+	}
+
+	/* Read hndrte_shared structure */
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, (u8 *)&sh_le,
+			       sizeof(struct sdpcm_shared_le));
+	if (rv < 0)
+		return rv;
+
+	/* Endianness */
+	sh->flags = le32_to_cpu(sh_le.flags);
+	sh->trap_addr = le32_to_cpu(sh_le.trap_addr);
+	sh->assert_exp_addr = le32_to_cpu(sh_le.assert_exp_addr);
+	sh->assert_file_addr = le32_to_cpu(sh_le.assert_file_addr);
+	sh->assert_line = le32_to_cpu(sh_le.assert_line);
+	sh->console_addr = le32_to_cpu(sh_le.console_addr);
+	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
+
+	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) > SDPCM_SHARED_VERSION) {
+		brcmf_err("sdpcm shared version unsupported: dhd %d dongle %d\n",
+			  SDPCM_SHARED_VERSION,
+			  sh->flags & SDPCM_SHARED_VERSION_MASK);
+		return -EPROTO;
+	}
+
+	return 0;
+}
+
+static void brcmf_sdio_get_console_addr(struct brcmf_sdio *bus)
+{
+	struct sdpcm_shared sh;
+
+	if (brcmf_sdio_readshared(bus, &sh) == 0)
+		bus->console_addr = sh.console_addr;
+}
+#else
+static void brcmf_sdio_get_console_addr(struct brcmf_sdio *bus)
+{
+}
+#endif /* DEBUG */
+
 static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 {
 	u32 intstatus = 0;
@@ -996,6 +1076,12 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 		else
 			brcmf_dbg(SDIO, "Dongle ready, protocol version %d\n",
 				  bus->sdpcm_ver);
+
+		/*
+		 * Retrieve console state address now that firmware should have
+		 * updated it.
+		 */
+		brcmf_sdio_get_console_addr(bus);
 	}
 
 	/*
@@ -2810,72 +2896,6 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 }
 
 #ifdef DEBUG
-static inline bool brcmf_sdio_valid_shared_address(u32 addr)
-{
-	return !(addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff));
-}
-
-static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
-				 struct sdpcm_shared *sh)
-{
-	u32 addr;
-	int rv;
-	u32 shaddr = 0;
-	struct sdpcm_shared_le sh_le;
-	__le32 addr_le;
-
-	shaddr = bus->ci->rambase + bus->ramsize - 4;
-
-	/*
-	 * Read last word in socram to determine
-	 * address of sdpcm_shared structure
-	 */
-	sdio_claim_host(bus->sdiodev->func[1]);
-	brcmf_sdio_bus_sleep(bus, false, false);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, shaddr, (u8 *)&addr_le, 4);
-	sdio_release_host(bus->sdiodev->func[1]);
-	if (rv < 0)
-		return rv;
-
-	addr = le32_to_cpu(addr_le);
-
-	brcmf_dbg(SDIO, "sdpcm_shared address 0x%08X\n", addr);
-
-	/*
-	 * Check if addr is valid.
-	 * NVRAM length at the end of memory should have been overwritten.
-	 */
-	if (!brcmf_sdio_valid_shared_address(addr)) {
-			brcmf_err("invalid sdpcm_shared address 0x%08X\n",
-				  addr);
-			return -EINVAL;
-	}
-
-	/* Read hndrte_shared structure */
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, (u8 *)&sh_le,
-			       sizeof(struct sdpcm_shared_le));
-	if (rv < 0)
-		return rv;
-
-	/* Endianness */
-	sh->flags = le32_to_cpu(sh_le.flags);
-	sh->trap_addr = le32_to_cpu(sh_le.trap_addr);
-	sh->assert_exp_addr = le32_to_cpu(sh_le.assert_exp_addr);
-	sh->assert_file_addr = le32_to_cpu(sh_le.assert_file_addr);
-	sh->assert_line = le32_to_cpu(sh_le.assert_line);
-	sh->console_addr = le32_to_cpu(sh_le.console_addr);
-	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
-
-	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) > SDPCM_SHARED_VERSION) {
-		brcmf_err("sdpcm shared version unsupported: dhd %d dongle %d\n",
-			  SDPCM_SHARED_VERSION,
-			  sh->flags & SDPCM_SHARED_VERSION_MASK);
-		return -EPROTO;
-	}
-
-	return 0;
-}
-
 static int brcmf_sdio_dump_console(struct brcmf_sdio *bus,
 				   struct sdpcm_shared *sh, char __user *data,
 				   size_t count)
@@ -3105,6 +3125,8 @@ static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
 	debugfs_create_file("forensics", S_IRUGO, dentry, bus,
 			    &brcmf_sdio_forensic_ops);
 	brcmf_debugfs_create_sdio_count(drvr, &bus->sdcnt);
+	debugfs_create_u32("console_interval", 0644, dentry,
+			   &bus->console_interval);
 }
 #else
 static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
-- 
1.7.10.4

