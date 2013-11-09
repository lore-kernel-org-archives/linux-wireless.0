Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56932 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3KIN6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Nov 2013 08:58:04 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] cfg80211: fix reporting 5/10 MHz support to user space
Date: Sat,  9 Nov 2013 14:57:54 +0100
Message-Id: <1384005474-86844-1-git-send-email-nbd@openwrt.org> (sfid-20131109_145825_163586_A89AAF73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nla_put_flag needs a real nl80211 attribute id, not a wiphy flag bit

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/uapi/linux/nl80211.h | 5 +++++
 net/wireless/nl80211.c       | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f752e98..9126544 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1508,6 +1508,9 @@ enum nl80211_commands {
  *	to react to radar events, e.g. initiate a channel switch or leave the
  *	IBSS network.
  *
+ * @NL80211_ATTR_SUPPORT_5_10_MHZ: A flag indicating that the device supports
+ *	5 MHz and 10 MHz channel bandwidth.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1824,6 +1827,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HANDLE_DFS,
 
+	NL80211_ATTR_SUPPORT_5_10_MHZ,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a7f4e79..5d17f86 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1229,7 +1229,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
 		if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ) &&
-		    nla_put_flag(msg, WIPHY_FLAG_SUPPORTS_5_10_MHZ))
+		    nla_put_flag(msg, NL80211_ATTR_SUPPORT_5_10_MHZ))
 			goto nla_put_failure;
 
 		state->split_start++;
-- 
1.8.3.4 (Apple Git-47)

