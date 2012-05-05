Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1333 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab2EEB1p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:45 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] brcmfmac: decouple set_sbaddr_window from
 register write interface
Date: Fri, 4 May 2012 18:27:30 -0700
Message-ID: <1336181258-7305-4-git-send-email-frankyl@broadcom.com> (sfid-20120505_032824_192799_857A83E5)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdcard_set_sbaddr_window configures 3 registers on SDIO
function misc bank to change current silicon backplane programming
window. This patch makes it call brcmf_sdioh_request_byte directly
in order to prepare for the write register interface unification.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   37 ++++++++++++++--------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 7c9bc2b..f971fa8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -205,19 +205,30 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 int
 brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
-	int err = 0;
-	brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
-			 (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
-	if (!err)
-		brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_SBADDRMID,
-				       (address >> 16) & SBSDIO_SBADDRMID_MASK,
-				       &err);
-	if (!err)
-		brcmf_sdcard_cfg_write(sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_SBADDRHIGH,
-				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
-				       &err);
+	int err = 0, i;
+	u8 addr[3];
+	s32 retry;
+
+	addr[0] = (address >> 8) & SBSDIO_SBADDRLOW_MASK;
+	addr[1] = (address >> 16) & SBSDIO_SBADDRMID_MASK;
+	addr[2] = (address >> 24) & SBSDIO_SBADDRHIGH_MASK;
+
+	for (i = 0; i < 3; i++) {
+		retry = 0;
+		do {
+			if (retry)
+				usleep_range(1000, 2000);
+			err = brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE,
+					SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW + i,
+					&addr[i]);
+		} while (err != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
+
+		if (err) {
+			brcmf_dbg(ERROR, "failed at addr:0x%0x\n",
+				  SBSDIO_FUNC1_SBADDRLOW + i);
+			break;
+		}
+	}
 
 	return err;
 }
-- 
1.7.9.5


