Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3437 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029Ab3DBTGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:06:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.9 4/4] brcmfmac: do not proceed if fail to
 download nvram to dongle
Date: Tue, 2 Apr 2013 21:06:20 +0200
Message-ID: <1364929580-6206-5-git-send-email-arend@broadcom.com> (sfid-20130402_210656_530417_215A541F)
In-Reply-To: <1364929580-6206-1-git-send-email-arend@broadcom.com>
References: <1364929580-6206-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Nvram contains critical initialization parameter for firmware to run. Host
driver should not proceed if nvram fails to be downloaded to dongle.

Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4469321..35fc68b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3317,15 +3317,15 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 		goto err;
 	}
 
-	/* External image takes precedence if specified */
 	if (brcmf_sdbrcm_download_code_file(bus)) {
 		brcmf_err("dongle image file download failed\n");
 		goto err;
 	}
 
-	/* External nvram takes precedence if specified */
-	if (brcmf_sdbrcm_download_nvram(bus))
+	if (brcmf_sdbrcm_download_nvram(bus)) {
 		brcmf_err("dongle nvram file download failed\n");
+		goto err;
+	}
 
 	/* Take arm out of reset */
 	if (brcmf_sdbrcm_download_state(bus, false)) {
-- 
1.7.10.4


