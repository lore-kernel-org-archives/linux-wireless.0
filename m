Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45638 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab3KYVXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 16:23:50 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] nl80211: split 5 and 10 mhz capability flags
Date: Mon, 25 Nov 2013 22:23:45 +0100
Message-Id: <1385414625-53124-1-git-send-email-nbd@openwrt.org> (sfid-20131125_222354_410569_2D5FE72D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps in case we need to support hardware that can only do one of
the two.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/uapi/linux/nl80211.h | 10 +++++++---
 net/wireless/nl80211.c       |  3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4bb8289..27caeff 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1515,8 +1515,11 @@ enum nl80211_commands {
  *	to react to radar events, e.g. initiate a channel switch or leave the
  *	IBSS network.
  *
- * @NL80211_ATTR_SUPPORT_5_10_MHZ: A flag indicating that the device supports
- *	5 MHz and 10 MHz channel bandwidth.
+ * @NL80211_ATTR_SUPPORT_5_MHZ: A flag indicating that the device supports
+ *	5 MHz channel bandwidth.
+ *
+ * @NL80211_ATTR_SUPPORT_10_MHZ: A flag indicating that the device supports
+ *	10 MHz channel bandwidth.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1834,7 +1837,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HANDLE_DFS,
 
-	NL80211_ATTR_SUPPORT_5_10_MHZ,
+	NL80211_ATTR_SUPPORT_5_MHZ,
+	NL80211_ATTR_SUPPORT_10_MHZ,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 10a596f..1eadea0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1229,7 +1229,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
 		if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ) &&
-		    nla_put_flag(msg, NL80211_ATTR_SUPPORT_5_10_MHZ))
+		    (nla_put_flag(msg, NL80211_ATTR_SUPPORT_5_MHZ) ||
+		     nla_put_flag(msg, NL80211_ATTR_SUPPORT_10_MHZ)))
 			goto nla_put_failure;
 
 		state->split_start++;
-- 
1.8.3.4 (Apple Git-47)

