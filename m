Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:25036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYJ1IEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 04:04:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] mac80211: print reason code for deauth/dissoc frames
Date: Tue, 28 Oct 2008 15:58:31 +0800
Message-Id: <1225180711-5204-1-git-send-email-yi.zhu@intel.com> (sfid-20081028_090432_399434_02E86D17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch prints reason code for deauth/dissoc frames to give users
more ideas what's happened for the disconnection.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/mlme.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d5006b2..0752e09 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1134,7 +1134,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
-		printk(KERN_DEBUG "%s: deauthenticated\n", sdata->dev->name);
+		printk(KERN_DEBUG "%s: deauthenticated (Reason: %u)\n",
+				sdata->dev->name, reason_code);
 
 	if (ifsta->state == IEEE80211_STA_MLME_AUTHENTICATE ||
 	    ifsta->state == IEEE80211_STA_MLME_ASSOCIATE ||
@@ -1166,7 +1167,8 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
 	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
-		printk(KERN_DEBUG "%s: disassociated\n", sdata->dev->name);
+		printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
+				sdata->dev->name, reason_code);
 
 	if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED) {
 		ifsta->state = IEEE80211_STA_MLME_ASSOCIATE;
-- 
1.5.3.6

