Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbZDAB2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 21:28:18 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2] cfg80211: send regulatory beacon hint events to userspace
Date: Tue, 31 Mar 2009 21:28:14 -0400
Message-Id: <1238549294-29168-1-git-send-email-lrodriguez@atheros.com> (sfid-20090401_032821_384708_793C2DE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This informs userspace when a change has occured on a world
roaming wiphy's channel which has lifted some restrictions
due to a regulatory beacon hint.

Because this is now sent to userspace through the regulatory
multicast group we remove the debug prints we used to use as
they are no longer necessary.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This v2 takes a cleaner approach, with nl80211 its better to think of
objects not in terms of the contents they serve but instead of the purpose
they serve. Doing this with this patch adds a few new attributes as cost
but the code is a lot cleaner and easier to read.

 include/linux/nl80211.h |   34 ++++++++++++++++++++-
 net/wireless/nl80211.c  |   76 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 ++
 net/wireless/reg.c      |   28 ++++++++--------
 4 files changed, 127 insertions(+), 15 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index cbe8ce3..9838f99 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -7,7 +7,7 @@
  * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
  * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
  * Copyright 2008 Michael Buesch <mb@bu3sch.de>
- * Copyright 2008 Luis R. Rodriguez <lrodriguez@atheros.com>
+ * Copyright 2008, 2009 Luis R. Rodriguez <lrodriguez@atheros.com>
  * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
  * Copyright 2008 Colin McCabe <colin@cozybit.com>
  *
@@ -166,6 +166,22 @@
  * 	set (%NL80211_ATTR_REG_TYPE), if the type of regulatory domain is
  * 	%NL80211_REG_TYPE_COUNTRY the alpha2 to which we have moved on
  * 	to (%NL80211_ATTR_REG_ALPHA2).
+ * @NL80211_CMD_REG_BEACON_HINT: indicates to userspace that an AP beacon
+ * 	has been found while world roaming thus enabling active scan or
+ * 	any mode of operation that initiates TX (beacons) on a channel
+ * 	where we would not have been able to do either before. As an example
+ * 	if you are world roaming (regulatory domain set to world or if your
+ * 	driver is using a custom world roaming regulatory domain) and while
+ * 	doing a passive scan on the 5 GHz band you find an AP there (if not
+ * 	on a DFS channel) you will now be able to actively scan for that AP
+ * 	or use AP mode on your card on that same channel. Note that this will
+ * 	never be used for channels 1-11 on the 2 GHz band as they are always
+ * 	enabled world wide. This beacon hint is only sent if your device had
+ * 	either disabled active scanning or beaconing on a channel. We send to
+ * 	userspace the wiphy on which we removed a restriction from
+ * 	(%NL80211_ATTR_WIPHY) and the channel on which this occurred
+ * 	before (%NL80211_ATTR_FREQ_BEFORE) and after (%NL80211_ATTR_FREQ_AFTER)
+ * 	the beacon hint was processed.
  *
  * @NL80211_CMD_AUTHENTICATE: authentication request and notification.
  *	This command is used both as a command (request to authenticate) and
@@ -260,6 +276,8 @@ enum nl80211_commands {
 	NL80211_CMD_DEAUTHENTICATE,
 	NL80211_CMD_DISASSOCIATE,
 
+	NL80211_CMD_REG_BEACON_HINT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -278,6 +296,7 @@ enum nl80211_commands {
 #define NL80211_CMD_ASSOCIATE NL80211_CMD_ASSOCIATE
 #define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
+#define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -408,6 +427,17 @@ enum nl80211_commands {
  * @NL80211_ATTR_REASON_CODE: ReasonCode for %NL80211_CMD_DEAUTHENTICATE and
  *	%NL80211_CMD_DISASSOCIATE, u16
  *
+ * @NL80211_ATTR_FREQ_BEFORE: A channel which has suffered a regulatory change
+ * 	due to considerations from a beacon hint. This attribute reflects
+ * 	the state of the channel _before_ the beacon hint processing. This
+ * 	attributes consists of a nested attribute containing
+ * 	NL80211_FREQUENCY_ATTR_*
+ * @NL80211_ATTR_FREQ_AFTER: A channel which has suffered a regulatory change
+ * 	due to considerations from a beacon hint. This attribute reflects
+ * 	the state of the channel _after_ the beacon hint processing. This
+ * 	attributes consists of a nested attribute containing
+ * 	NL80211_FREQUENCY_ATTR_*
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -492,6 +522,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_AUTH_TYPE,
 	NL80211_ATTR_REASON_CODE,
 
+	NL80211_ATTR_FREQ_BEFORE,
+	NL80211_ATTR_FREQ_AFTER,
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 353e1a4..ba7ac4a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3391,6 +3391,82 @@ void nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
 				NL80211_CMD_DISASSOCIATE);
 }
 
+static int nl80211_put_beacon_hint_channel(void *hdr,
+					   struct sk_buff *msg,
+					   enum nl80211_attrs attribute,
+					   struct ieee80211_channel *chan)
+{
+	struct nlattr *nl_freq;
+
+	nl_freq = nla_nest_start(msg, attribute);
+	if (!nl_freq)
+		goto nla_put_failure;
+
+	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
+		    chan->center_freq);
+
+	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
+	if (chan->flags & IEEE80211_CHAN_NO_IBSS)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
+
+	nla_nest_end(msg, nl_freq);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+	return -EINVAL;
+}
+
+void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
+				    struct ieee80211_channel *channel_before,
+				    struct ieee80211_channel *channel_after)
+{
+#define NL80211_PUT_BC_CHAN(_attr, _chan) do { \
+	r = nl80211_put_beacon_hint_channel(hdr, msg, _attr, _chan); \
+	if (r) \
+		return; \
+} while (0)
+	struct sk_buff *msg;
+	void *hdr;
+	int r;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_REG_BEACON_HINT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	/*
+	 * Since we are applying the beacon hint to a wiphy we know its
+	 * wiphy_idx is valid
+	 */
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy));
+
+	NL80211_PUT_BC_CHAN(NL80211_ATTR_FREQ_BEFORE, channel_before);
+	NL80211_PUT_BC_CHAN(NL80211_ATTR_FREQ_AFTER, channel_after);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_regulatory_mcgrp.id, GFP_ATOMIC);
+
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+#undef NL80211_PUT_BC_CHAN
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index b77af4a..9496eff 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -23,5 +23,9 @@ extern void nl80211_send_rx_deauth(struct cfg80211_registered_device *rdev,
 extern void nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev,
 				     const u8 *buf, size_t len);
+extern void
+nl80211_send_beacon_hint_event(struct wiphy *wiphy,
+			       struct ieee80211_channel *channel_before,
+			       struct ieee80211_channel *channel_after);
 
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6327e16..60ef1e9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1049,18 +1049,10 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 			      unsigned int chan_idx,
 			      struct reg_beacon *reg_beacon)
 {
-#ifdef CONFIG_CFG80211_REG_DEBUG
-#define REG_DEBUG_BEACON_FLAG(desc) \
-	printk(KERN_DEBUG "cfg80211: Enabling " desc " on " \
-		"frequency: %d MHz (Ch %d) on %s\n", \
-		reg_beacon->chan.center_freq, \
-		ieee80211_frequency_to_channel(reg_beacon->chan.center_freq), \
-		wiphy_name(wiphy));
-#else
-#define REG_DEBUG_BEACON_FLAG(desc) do {} while (0)
-#endif
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
+	bool channel_changed = false;
+	struct ieee80211_channel chan_before;
 
 	assert_cfg80211_lock();
 
@@ -1070,18 +1062,26 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 	if (likely(chan->center_freq != reg_beacon->chan.center_freq))
 		return;
 
+	if (chan->beacon_found)
+		return;
+
+	chan->beacon_found = true;
+
+	chan_before.center_freq = chan->center_freq;
+	chan_before.flags = chan->flags;
+
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) {
 		chan->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
-		REG_DEBUG_BEACON_FLAG("active scanning");
+		channel_changed = true;
 	}
 
 	if (chan->flags & IEEE80211_CHAN_NO_IBSS) {
 		chan->flags &= ~IEEE80211_CHAN_NO_IBSS;
-		REG_DEBUG_BEACON_FLAG("beaconing");
+		channel_changed = true;
 	}
 
-	chan->beacon_found = true;
-#undef REG_DEBUG_BEACON_FLAG
+	if (channel_changed)
+		nl80211_send_beacon_hint_event(wiphy, &chan_before, chan);
 }
 
 /*
-- 
1.6.0.6

