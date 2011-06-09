Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4696 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1FIOpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:19 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 21/21] staging: brcm80211: change wl_cfg80211_suspend
 corresponding to cfg80211
Date: Thu, 9 Jun 2011 16:45:01 +0200
Message-ID: <1307630701-9170-22-git-send-email-rvossen@broadcom.com> (sfid-20110609_164603_144386_9DB1B344)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change wl_cfg80211_suspend in fullmac to meet cfg80211 interface update.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 235cc59..63e2173 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -101,7 +101,8 @@ static s32 wl_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 						 struct net_device *dev,
 						 u8 key_idx);
 static s32 wl_cfg80211_resume(struct wiphy *wiphy);
-static s32 wl_cfg80211_suspend(struct wiphy *wiphy);
+static s32 wl_cfg80211_suspend(struct wiphy *wiphy,
+				 struct cfg80211_wowlan *wow);
 static s32 wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_pmksa *pmksa);
 static s32 wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
@@ -2092,7 +2093,7 @@ static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 	return 0;
 }
 
-static s32 wl_cfg80211_suspend(struct wiphy *wiphy)
+static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct net_device *ndev = wl_to_ndev(wl);
-- 
1.7.4.1


