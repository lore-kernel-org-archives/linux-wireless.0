Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55943 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab2LFXgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 18:36:08 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmsmac: add support for cores with revision 17
Date: Fri,  7 Dec 2012 00:35:53 +0100
Message-Id: <1354836953-11628-1-git-send-email-hauke@hauke-m.de> (sfid-20121207_003617_978287_71F52F17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for bcma wifi core revision 17 which is found on
BCM4716/4717/4718 SoCs. The firmware version 610.812 for brcmsmac found
in linux-firmware does not support these cores, but a firmware
generated with b43-fwcutter from the proprietary broadcom wireless
driver works with these chips. This wifi core contains a revision 5
N-PHY and a revision 7 radio of type 0x2056.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 02d27ea..1fbd8ec 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -93,6 +93,7 @@ MODULE_FIRMWARE("brcm/bcm43xx_hdr-0.fw");
 
 /* recognized BCMA Core IDs */
 static struct bcma_device_id brcms_coreid_table[] = {
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 17, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 23, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 24, BCMA_ANY_CLASS),
 	BCMA_CORETABLE_END
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8fce687..cb48fc4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -717,7 +717,7 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 	brcms_c_write_mhf(wlc_hw, wlc_hw->band->mhfs);
 
 	/* do band-specific ucode IHR, SHM, and SCR inits */
-	if (D11REV_IS(wlc_hw->corerev, 23)) {
+	if (D11REV_IS(wlc_hw->corerev, 17) || D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, ucode->d11n0bsinitvals16);
 		else
@@ -2264,7 +2264,7 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 	if (wlc_hw->ucode_loaded)
 		return;
 
-	if (D11REV_IS(wlc_hw->corerev, 23)) {
+	if (D11REV_IS(wlc_hw->corerev, 17) || D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band)) {
 			brcms_ucode_write(wlc_hw, ucode->bcm43xx_16_mimo,
 					  ucode->bcm43xx_16_mimosz);
@@ -3216,7 +3216,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 
 	sflags = bcma_aread32(core, BCMA_IOST);
 
-	if (D11REV_IS(wlc_hw->corerev, 23)) {
+	if (D11REV_IS(wlc_hw->corerev, 17) || D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, ucode->d11n0initvals16);
 		else
-- 
1.7.10.4

