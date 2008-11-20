Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6412 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbYKTSUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 13:20:37 -0500
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH V2] mac80211 : Fix setting ad-hoc mode and non-ibss channel
Date: Thu, 20 Nov 2008 10:20:31 -0800
Message-Id: <1227205231-7045-1-git-send-email-abhijeet.kolekar@intel.com> (sfid-20081120_192056_419850_2EC347B0)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes the kernel trace when user tries to set
ad-hoc mode on non IBSS channel.
e.g iwconfig wlan0 chan 36 mode ad-hoc

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 net/mac80211/wext.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 63f36e9..b3ce28d 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -271,6 +271,7 @@ static int ieee80211_ioctl_siwmode(struct net_device *dev,
 				   __u32 *mode, char *extra)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	int type;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -281,6 +282,13 @@ static int ieee80211_ioctl_siwmode(struct net_device *dev,
 		type = NL80211_IFTYPE_STATION;
 		break;
 	case IW_MODE_ADHOC:
+		/* Setting ad-hoc mode on non ibss channel is not
+		 * supported.
+		 */
+		if (local->oper_channel &&
+		    (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS))
+			return -EOPNOTSUPP;
+
 		type = NL80211_IFTYPE_ADHOC;
 		break;
 	case IW_MODE_REPEAT:
-- 
1.5.4.3

