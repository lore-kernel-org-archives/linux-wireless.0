Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1353 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab1JUOQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:48 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 11/17] brcm80211: smac: changed check to confirm STA
 only support
Date: Fri, 21 Oct 2011 16:16:29 +0200
Message-ID: <1319206595-17138-12-git-send-email-arend@broadcom.com> (sfid-20111021_161728_847487_632952E7)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

The driver currently only supports STA operation. However, in
brcms_ops_add_interface() also AP and SSID mode were accepted.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 824c608..8e35c62 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -341,11 +341,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct brcms_info *wl = hw->priv;
 
 	/* Just STA for now */
-	if (vif->type != NL80211_IFTYPE_AP &&
-	    vif->type != NL80211_IFTYPE_MESH_POINT &&
-	    vif->type != NL80211_IFTYPE_STATION &&
-	    vif->type != NL80211_IFTYPE_WDS &&
-	    vif->type != NL80211_IFTYPE_ADHOC) {
+	if (vif->type != NL80211_IFTYPE_STATION) {
 		wiphy_err(hw->wiphy, "%s: Attempt to add type %d, only"
 			  " STA for now\n", __func__, vif->type);
 		return -EOPNOTSUPP;
-- 
1.7.4.1


