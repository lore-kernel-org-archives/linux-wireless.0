Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab0LNQy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 11:54:29 -0500
Subject: [PATCH] nl80211: advertise maximum remain-on-channel duration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 17:54:28 +0100
Message-ID: <1292345668.3569.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the upcoming hardware offload implementation,
some devices will have a different maximum duration
for the remain-on-channel command. Advertise the
maximum duration in mac80211, and make mac80211 set
it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I'm working on the HW offload implementation, need to
get it tested. Does anyone mind that I mentioned it in
the commit log anyway? This is useful by itself since
it allows cfg80211 drivers to specify it, and wpa_s to
discover it ...

 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    5 +++++
 net/mac80211/main.c     |    2 ++
 net/wireless/nl80211.c  |    7 ++++++-
 4 files changed, 18 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-12-14 16:54:01.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2010-12-14 16:55:59.000000000 +0100
@@ -773,6 +773,9 @@ enum nl80211_commands {
  *	cache, a wiphy attribute.
  *
  * @NL80211_ATTR_DURATION: Duration of an operation in milliseconds, u32.
+ * @NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION: Device attribute that
+ *	specifies the maximum duration that can be requested with the
+ *	remain-on-channel operation, in milliseconds, u32.
  *
  * @NL80211_ATTR_COOKIE: Generic 64-bit cookie to identify objects.
  *
@@ -1035,6 +1038,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_KEY_DEFAULT_TYPES,
 
+	NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2010-12-14 16:51:28.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-12-14 16:53:15.000000000 +0100
@@ -1474,6 +1474,9 @@ struct ieee80211_txrx_stypes {
  *
  * @available_antennas: bitmap of antennas which are available to configure.
  *	antenna configuration commands will be rejected unless this is set.
+ *
+ * @max_remain_on_channel_duration: Maximum time a remain-on-channel operation
+ *	may request, if implemented.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1511,6 +1514,8 @@ struct wiphy {
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 	u32 hw_version;
 
+	u16 max_remain_on_channel_duration;
+
 	u8 max_num_pmkids;
 
 	u32 available_antennas;
--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-14 16:53:29.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-12-14 16:58:53.000000000 +0100
@@ -755,6 +755,10 @@ static int nl80211_send_wiphy(struct sk_
 
 	nla_nest_end(msg, nl_cmds);
 
+	if (dev->ops->remain_on_channel)
+		NLA_PUT_U32(msg, NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
+			    dev->wiphy.max_remain_on_channel_duration);
+
 	/* for now at least assume all drivers have it */
 	if (dev->ops->mgmt_tx)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_OFFCHANNEL_TX_OK);
@@ -4228,7 +4232,8 @@ static int nl80211_remain_on_channel(str
 	 * We should be on that channel for at least one jiffie,
 	 * and more than 5 seconds seems excessive.
 	 */
-	if (!duration || !msecs_to_jiffies(duration) || duration > 5000)
+	if (!duration || !msecs_to_jiffies(duration) ||
+	    duration > rdev->wiphy.max_remain_on_channel_duration)
 		return -EINVAL;
 
 	if (!rdev->ops->remain_on_channel)
--- wireless-testing.orig/net/mac80211/main.c	2010-12-14 17:04:34.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2010-12-14 17:06:55.000000000 +0100
@@ -747,6 +747,8 @@ int ieee80211_register_hw(struct ieee802
 		}
 	}
 
+	local->hw.wiphy->max_remain_on_channel_duration = 5000;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;


