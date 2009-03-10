Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41665 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZCJCsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:48:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] cfg80211: send regulatory beacon hint events to userspace
Date: Mon,  9 Mar 2009 22:48:52 -0400
Message-Id: <1236653332-3515-1-git-send-email-lrodriguez@atheros.com> (sfid-20090310_034907_186594_31F15C39)
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

There is something awefully wrong with this patch and after some
good review I cannot determine what is wrong with it. The issue is
I end up following bug complaint saying I'm sleeping while I'm atomic..
but this is all from a workqueue so what gives?

I have to be missing something obvious or could this be another issue?

[14462.644500] cfg80211: Found new beacon on frequency: 5200 MHz (Ch 40) on phy1
[14462.644530] BUG: sleeping function called from invalid context at mm/slub.c:1599
[14462.644534] in_atomic(): 1, irqs_disabled(): 0, pid: 17, name: events/0
[14462.644538] 4 locks held by events/0/17:
[14462.644541]  #0:  (events){--..}, at: [<ffffffff80255073>] run_workqueue+0xb3/0x250
[14462.644557]  #1:  (reg_work){--..}, at: [<ffffffff80255073>] run_workqueue+0xb3/0x250
[14462.644569]  #2:  (cfg80211_mutex){--..}, at: [<ffffffffa05126eb>] reg_todo+0x1eb/0x5c0 [cfg80211]
[14462.644588]  #3:  (&reg_pending_beacons_lock){-+..}, at: [<ffffffffa05126f7>] reg_todo+0x1f7/0x5c0 [cfg80211]
[14462.644606] Pid: 17, comm: events/0 Not tainted 2.6.29-rc7-wl #21
[14462.644610] Call Trace:
[14462.644620]  [<ffffffff8026acf3>] ? __debug_show_held_locks+0x13/0x30
[14462.644627]  [<ffffffff80235505>] __might_sleep+0x105/0x140
[14462.644633]  [<ffffffff802dc7b1>] kmem_cache_alloc+0xd1/0x100
[14462.644641]  [<ffffffff804a40c4>] __alloc_skb+0x44/0x140
[14462.644652]  [<ffffffffa051a8b3>] nl80211_send_beacon_hint_event+0x33/0x370 [cfg80211]
[14462.644660]  [<ffffffff8026960e>] ? put_lock_stats+0xe/0x30
[14462.644671]  [<ffffffffa0511f19>] handle_reg_beacon+0xa9/0xc0 [cfg80211]
[14462.644685]  [<ffffffffa0512500>] ? reg_todo+0x0/0x5c0 [cfg80211]
[14462.644696]  [<ffffffff80541a1d>] ? _spin_lock_bh+0x6d/0x80
[14462.644706]  [<ffffffffa05126f7>] ? reg_todo+0x1f7/0x5c0 [cfg80211]
[14462.644720]  [<ffffffffa05127a5>] reg_todo+0x2a5/0x5c0 [cfg80211]
[14462.644745]  [<ffffffffa0512500>] ? reg_todo+0x0/0x5c0 [cfg80211]
[14462.644756]  [<ffffffffa0512500>] ? reg_todo+0x0/0x5c0 [cfg80211]
[14462.644762]  [<ffffffff802550c5>] run_workqueue+0x105/0x250
[14462.644766]  [<ffffffff80255073>] ? run_workqueue+0xb3/0x250
[14462.644778]  [<ffffffff802552bf>] worker_thread+0xaf/0x130
[14462.644785]  [<ffffffff80259c20>] ? autoremove_wake_function+0x0/0x40
[14462.644790]  [<ffffffff80255210>] ? worker_thread+0x0/0x130
[14462.644795]  [<ffffffff80259769>] kthread+0x49/0x90
[14462.644801]  [<ffffffff8020d8fa>] child_rip+0xa/0x20
[14462.644806]  [<ffffffff8020d2c0>] ? restore_args+0x0/0x30
[14462.644811]  [<ffffffff80259720>] ? kthread+0x0/0x90
[14462.644818]  [<ffffffff8020d8f0>] ? child_rip+0x0/0x20

 include/linux/nl80211.h |   23 ++++++++++++++-
 net/wireless/nl80211.c  |   71 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    9 ++++++
 net/wireless/reg.c      |   22 ++++++--------
 4 files changed, 111 insertions(+), 14 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9118460..d8b2467 100644
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
@@ -160,6 +160,25 @@
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
+ * 	(%NL80211_ATTR_WIPHY) and the channel on which this occured
+ * 	(%NL80211_ATTR_WIPHY_FREQ) before and after the beacon hint was applied.
+ * 	We send the two channels on a frequency nestered attribute
+ * 	(%NL80211_BAND_ATTR_FREQS) the first being the channel prior to the
+ * 	beacon hint processing. We only send these events if something _did_
+ * 	change to the channel.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -216,6 +235,7 @@ enum nl80211_commands {
 	NL80211_CMD_SCAN_ABORTED,
 
 	NL80211_CMD_REG_CHANGE,
+	NL80211_CMD_REG_BEACON_HINT,
 
 	/* add new commands above here */
 
@@ -232,6 +252,7 @@ enum nl80211_commands {
 #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
 
 #define NL80211_CMD_REG_CHANGE NL80211_CMD_REG_CHANGE
+#define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index eab5f6a..4974ee8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2883,6 +2883,77 @@ nla_put_failure:
 	nlmsg_free(msg);
 }
 
+void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
+					   struct ieee80211_channel *channel_before,
+					   struct ieee80211_channel *channel_after)
+{
+	struct sk_buff *msg;
+	void *hdr;
+	struct nlattr *nl_freqs, *nl_freq;
+	struct ieee80211_channel *chan;
+	unsigned int i;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
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
+	nl_freqs = nla_nest_start(msg, NL80211_BAND_ATTR_FREQS);
+	if (!nl_freqs)
+		goto nla_put_failure;
+
+	for (i = 0; i <= 1; i++) {
+		nl_freq = nla_nest_start(msg, i);
+		if (!nl_freq)
+			goto nla_put_failure;
+
+		chan = (i == 0) ? channel_before : channel_after;
+
+		NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
+			    chan->center_freq);
+
+		if (chan->flags & IEEE80211_CHAN_DISABLED)
+			NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_DISABLED);
+		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
+		if (chan->flags & IEEE80211_CHAN_NO_IBSS)
+			NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
+		if (chan->flags & IEEE80211_CHAN_RADAR)
+			NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
+
+		NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+			    DBM_TO_MBM(chan->max_power));
+
+		nla_nest_end(msg, nl_freq);
+	}
+
+	nla_nest_end(msg, nl_freqs);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_regulatory_mcgrp.id, GFP_KERNEL);
+
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e65a3c3..5fe8ac6 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -12,6 +12,9 @@ extern void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev);
 extern void nl80211_send_reg_change_event(struct regulatory_request *request);
+extern void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
+					   struct ieee80211_channel *channel_before,
+					   struct ieee80211_channel *channel_after);
 #else
 static inline int nl80211_init(void)
 {
@@ -36,6 +39,12 @@ static inline void
 nl80211_send_reg_change_event(struct regulatory_request *request)
 {
 }
+static inline void
+nl80211_send_beacon_hint_event(struct wiphy *wiphy,
+			       struct ieee80211_channel *channel_before,
+			       struct ieee80211_channel *channel_after)
+{
+}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index eb8b8ed..134549c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1044,18 +1044,10 @@ static void handle_reg_beacon(struct wiphy *wiphy,
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
 
@@ -1065,18 +1057,22 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 	if (likely(chan->center_freq != reg_beacon->chan.center_freq))
 		return;
 
+	memcpy(&chan_before, chan, sizeof(chan));
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
 
 	chan->beacon_found = true;
-#undef REG_DEBUG_BEACON_FLAG
+
+	if (channel_changed)
+		nl80211_send_beacon_hint_event(wiphy, &chan_before, chan);
 }
 
 /*
-- 
1.6.0.6

