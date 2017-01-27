Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37855 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932752AbdA0M14 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:27:56 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 4/5] brcmfmac: allow wowlan support to be per device
Date: Fri, 27 Jan 2017 12:27:47 +0000
Message-Id: <1485520068-5807-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170127_133137_960393_E12D28A3)
In-Reply-To: <1485520068-5807-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1485520068-5807-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wowlan support is (partially) determined dynamic by checking the
device/firmware capabilities. So they can differ per device. So it
is not possible to use a static global. Instead use the global as a
template and use kmemdup(). When kmemdup() fails the template is used
unmodified.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 V2: fix checkpatch error, ie. line over 80 characters.
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 26 ++++++++++++++++------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c81d78f..ab1f9f2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6339,7 +6339,7 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 }

 #ifdef CONFIG_PM
-static struct wiphy_wowlan_support brcmf_wowlan_support = {
+static const struct wiphy_wowlan_support brcmf_wowlan_support = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
 	.n_patterns = BRCMF_WOWL_MAXPATTERNS,
 	.pattern_max_len = BRCMF_WOWL_MAXPATTERNSIZE,
@@ -6352,21 +6352,29 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 #ifdef CONFIG_PM
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct wiphy_wowlan_support *wowl;
+
+	wowl = kmemdup(&brcmf_wowlan_support, sizeof(brcmf_wowlan_support),
+		       GFP_KERNEL);
+	if (!wowl) {
+		brcmf_err("only support basic wowlan features\n");
+		wiphy->wowlan = &brcmf_wowlan_support;
+		return;
+	}

 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO)) {
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_ND)) {
-			brcmf_wowlan_support.flags |= WIPHY_WOWLAN_NET_DETECT;
-			brcmf_wowlan_support.max_nd_match_sets =
-				BRCMF_PNO_MAX_PFN_COUNT;
+			wowl->flags |= WIPHY_WOWLAN_NET_DETECT;
+			wowl->max_nd_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
 			init_waitqueue_head(&cfg->wowl.nd_data_wait);
 		}
 	}
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_GTK)) {
-		brcmf_wowlan_support.flags |= WIPHY_WOWLAN_SUPPORTS_GTK_REKEY;
-		brcmf_wowlan_support.flags |= WIPHY_WOWLAN_GTK_REKEY_FAILURE;
+		wowl->flags |= WIPHY_WOWLAN_SUPPORTS_GTK_REKEY;
+		wowl->flags |= WIPHY_WOWLAN_GTK_REKEY_FAILURE;
 	}

-	wiphy->wowlan = &brcmf_wowlan_support;
+	wiphy->wowlan = wowl;
 #endif
 }

@@ -6747,6 +6755,10 @@ static void brcmf_free_wiphy(struct wiphy *wiphy)
 		kfree(wiphy->bands[NL80211_BAND_5GHZ]->channels);
 		kfree(wiphy->bands[NL80211_BAND_5GHZ]);
 	}
+#if IS_ENABLED(CONFIG_PM)
+	if (wiphy->wowlan != &brcmf_wowlan_support)
+		kfree(wiphy->wowlan);
+#endif
 	wiphy_free(wiphy);
 }

--
1.9.1
