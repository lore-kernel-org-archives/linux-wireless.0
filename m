Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYKTAid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 19:38:33 -0500
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH] mac80211 : Fix setting ad-hoc mode and non-ibss channel
Date: Wed, 19 Nov 2008 16:38:32 -0800
Message-Id: <1227141512-5636-1-git-send-email-abhijeet.kolekar@intel.com> (sfid-20081120_013837_745962_A235554D)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes the kernel trace when user tries to set
ad-hoc mode on non IBSS channel.
e.g iwconfig wlan0 chan 36 mode ad-hoc

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 net/mac80211/wext.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 63f36e9..5a9bc8c 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -271,6 +271,7 @@ static int ieee80211_ioctl_siwmode(struct net_device *dev,
 				   __u32 *mode, char *extra)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	int type;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -281,6 +282,15 @@ static int ieee80211_ioctl_siwmode(struct net_device *dev,
 		type = NL80211_IFTYPE_STATION;
 		break;
 	case IW_MODE_ADHOC:
+		/* Following check added to avoid misconfiguration if
+		 * you set mode and frequency at the same time.
+		 */
+		if (local->oper_channel && local->oper_channel->flags &
+					IEEE80211_CHAN_NO_IBSS) {
+			printk(KERN_DEBUG "Not a valid IBSS channel\n");
+			return -EOPNOTSUPP;
+		}
+
 		type = NL80211_IFTYPE_ADHOC;
 		break;
 	case IW_MODE_REPEAT:
-- 
1.5.4.3

