Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3108 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab1JUNzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/17] brcm80211: smac: changed check to confirm STA
 only support
Date: Fri, 21 Oct 2011 15:55:13 +0200
Message-ID: <1319205319-16891-12-git-send-email-arend@broadcom.com> (sfid-20111021_161149_186906_D2EE2EC0)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

The driver currently only supports STA operation. However, in
brcms_ops_add_interface() also AP and SSID mode were accepted.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
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


