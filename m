Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:12285 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbbCKPLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:11:40 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/7] brcmfmac: take save&restore memory into account for SDIO shared info
Date: Wed, 11 Mar 2015 16:11:32 +0100
Message-ID: <1426086693-13876-7-git-send-email-arend@broadcom.com> (sfid-20150311_161153_421260_98D11E8E)
In-Reply-To: <1426086693-13876-1-git-send-email-arend@broadcom.com>
References: <1426086693-13876-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware provides pointer to SDIO shared information at end of
RAM during firmware initialization. End of RAM is obviously determined
by the actual ram size, but part of that may be used for save&restore
memory. In that case another location in RAM will hold the pointer.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 40 +++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index c783c25..5202e76 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -1067,44 +1067,47 @@ static inline bool brcmf_sdio_valid_shared_address(u32 addr)
 static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 				 struct sdpcm_shared *sh)
 {
-	u32 addr;
+	u32 addr = 0;
 	int rv;
 	u32 shaddr = 0;
 	struct sdpcm_shared_le sh_le;
 	__le32 addr_le;
 
-	shaddr = bus->ci->rambase + bus->ci->ramsize - 4;
+	sdio_claim_host(bus->sdiodev->func[1]);
+	brcmf_sdio_bus_sleep(bus, false, false);
 
 	/*
 	 * Read last word in socram to determine
 	 * address of sdpcm_shared structure
 	 */
-	sdio_claim_host(bus->sdiodev->func[1]);
-	brcmf_sdio_bus_sleep(bus, false, false);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, shaddr, (u8 *)&addr_le, 4);
-	sdio_release_host(bus->sdiodev->func[1]);
+	shaddr = bus->ci->rambase + bus->ci->ramsize - 4;
+	if (!bus->ci->rambase && brcmf_chip_sr_capable(bus->ci))
+		shaddr -= bus->ci->srsize;
+	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, shaddr,
+			       (u8 *)&addr_le, 4);
 	if (rv < 0)
-		return rv;
-
-	addr = le32_to_cpu(addr_le);
-
-	brcmf_dbg(SDIO, "sdpcm_shared address 0x%08X\n", addr);
+		goto fail;
 
 	/*
 	 * Check if addr is valid.
 	 * NVRAM length at the end of memory should have been overwritten.
 	 */
+	addr = le32_to_cpu(addr_le);
 	if (!brcmf_sdio_valid_shared_address(addr)) {
-			brcmf_err("invalid sdpcm_shared address 0x%08X\n",
-				  addr);
-			return -EINVAL;
+		brcmf_err("invalid sdpcm_shared address 0x%08X\n", addr);
+		rv = -EINVAL;
+		goto fail;
 	}
 
+	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
+
 	/* Read hndrte_shared structure */
 	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, (u8 *)&sh_le,
 			       sizeof(struct sdpcm_shared_le));
 	if (rv < 0)
-		return rv;
+		goto fail;
+
+	sdio_release_host(bus->sdiodev->func[1]);
 
 	/* Endianness */
 	sh->flags = le32_to_cpu(sh_le.flags);
@@ -1121,8 +1124,13 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 			  sh->flags & SDPCM_SHARED_VERSION_MASK);
 		return -EPROTO;
 	}
-
 	return 0;
+
+fail:
+	brcmf_err("unable to obtain sdpcm_shared info: rv=%d (addr=0x%x)\n",
+		  rv, addr);
+	sdio_release_host(bus->sdiodev->func[1]);
+	return rv;
 }
 
 static void brcmf_sdio_get_console_addr(struct brcmf_sdio *bus)
-- 
1.9.1

