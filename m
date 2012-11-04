Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55036 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab2KDWN0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 17:13:26 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, frankyl@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmfmac: fix typo in CONFIG_BRCMISCAN
Date: Sun,  4 Nov 2012 23:13:09 +0100
Message-Id: <1352067189-29017-1-git-send-email-hauke@hauke-m.de> (sfid-20121104_231338_597791_66D5C6F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old ifdef CONFIG_BRCMFISCAN looks wrong to me and it makes more
sense when CONFIG_BRCMISCAN is used.
This patch was just compile tested by me, but not runtime tested.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index cb30fea..6d55424 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4197,7 +4197,7 @@ static s32 brcmf_mode_to_nl80211_iftype(s32 mode)
 
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 {
-#ifndef CONFIG_BRCMFISCAN
+#ifndef CONFIG_BRCMISCAN
 	/* scheduled scan settings */
 	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
-- 
1.7.10.4

