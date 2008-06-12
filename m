Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21679 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYFLBuD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:50:03 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH 26/29] mac80211 : fix for iwconfig in ad-hoc mode
Date: Thu, 12 Jun 2008 09:47:16 +0800
Message-Id: <1213235239-2954-27-git-send-email-yi.zhu@intel.com> (sfid-20080612_041917_431325_ED9684E7)
In-Reply-To: <1213235239-2954-26-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-23-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-24-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-25-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-26-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch checks interface status, if it is in IBSS_JOINED mode
show cell id it is associated with.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 net/mac80211/wext.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 4806d96..5af3862 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -508,7 +508,8 @@ static int ieee80211_ioctl_giwap(struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		if (sdata->u.sta.state == IEEE80211_ASSOCIATED) {
+		if (sdata->u.sta.state == IEEE80211_ASSOCIATED ||
+		    sdata->u.sta.state == IEEE80211_IBSS_JOINED) {
 			ap_addr->sa_family = ARPHRD_ETHER;
 			memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
 			return 0;
-- 
1.5.3.6

