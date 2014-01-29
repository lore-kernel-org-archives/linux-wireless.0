Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9426 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaA2Ocg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:36 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/14] brcmfmac: simplify sdio code download routine.
Date: Wed, 29 Jan 2014 15:32:17 +0100
Message-ID: <1391005944-3220-8-git-send-email-arend@broadcom.com> (sfid-20140129_153248_451050_1BFB6B3B)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_sdio_download_code_file is using a loop to send small blobs
of data. This is unnecessarily complex and was simplified with this
patch.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   31 +++++---------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d78fffb..be2ec8a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3291,32 +3291,17 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
 					 const struct firmware *fw)
 {
 	int err;
-	int offset;
-	int address;
-	int len;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	err = 0;
-	offset = 0;
-	address = bus->ci->rambase;
-	while (offset < fw->size) {
-		len = ((offset + MEMBLOCK) < fw->size) ? MEMBLOCK :
-		      fw->size - offset;
-		err = brcmf_sdiod_ramrw(bus->sdiodev, true, address,
-					(u8 *)&fw->data[offset], len);
-		if (err) {
-			brcmf_err("error %d on writing %d membytes at 0x%08x\n",
-				  err, len, address);
-			return err;
-		}
-		offset += len;
-		address += len;
-	}
-	if (!err)
-		if (!brcmf_sdio_verifymemory(bus->sdiodev, bus->ci->rambase,
-					     (u8 *)fw->data, fw->size))
-			err = -EIO;
+	err = brcmf_sdiod_ramrw(bus->sdiodev, true, bus->ci->rambase,
+				(u8 *)fw->data, fw->size);
+	if (err)
+		brcmf_err("error %d on writing %d membytes at 0x%08x\n",
+			  err, (int)fw->size, bus->ci->rambase);
+	else if (!brcmf_sdio_verifymemory(bus->sdiodev, bus->ci->rambase,
+					  (u8 *)fw->data, fw->size))
+		err = -EIO;
 
 	return err;
 }
-- 
1.7.10.4

