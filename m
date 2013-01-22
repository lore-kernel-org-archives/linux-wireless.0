Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3AVM4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 07:56:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] cfg80211/mac80211: support reporting wakeup reason
Date: Tue, 22 Jan 2013 13:56:30 +0100
Message-Id: <1358859390-22617-1-git-send-email-johannes@sipsolutions.net> (sfid-20130122_135614_662448_AAD00569)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When waking up from WoWLAN, it is useful to know
what triggered the wakeup. Support reporting the
wakeup reason(s) in cfg80211 (and a pass-through
in mac80211) to allow userspace to know.

Change-Id: I7766f071273f3e31020395cc74eabcc6d165fa3a
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 39 ++++++++++++++++++++
 include/net/mac80211.h       | 12 ++++++
 include/uapi/linux/nl80211.h | 23 ++++++++++++
 net/mac80211/pm.c            | 10 +++++
 net/wireless/nl80211.c       | 88 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         | 35 ++++++++++++++++++
 6 files changed, 207 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 242eaa3..386e252 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1541,6 +1541,30 @@ struct cfg80211_wowlan {
 };
 
 /**
+ * struct cfg80211_wowlan_wakeup - wakeup report
+ * @disconnect: woke up by getting disconnected
+ * @magic_pkt: woke up by receiving magic packet
+ * @gtk_rekey_failure: woke up by GTK rekey failure
+ * @eap_identity_req: woke up by EAP identity request packet
+ * @four_way_handshake: woke up by 4-way handshake
+ * @rfkill_release: woke up by rfkill being released
+ * @pattern_idx: pattern that caused wakeup, -1 if not due to pattern
+ * @packet_present_len: copied wakeup packet data
+ * @packet_len: original wakeup packet length
+ * @packet: The packet causing the wakeup, if any. For pattern match
+ *	and magic packet this should be an 802.3 frame, for disconnect
+ *	it should be an 802.11 frame.
+ */
+struct cfg80211_wowlan_wakeup {
+	bool disconnect, magic_pkt, gtk_rekey_failure,
+	     eap_identity_req, four_way_handshake,
+	     rfkill_release;
+	s32 pattern_idx;
+	u32 packet_present_len, packet_len;
+	const void *packet;
+};
+
+/**
  * struct cfg80211_gtk_rekey_data - rekey data
  * @kek: key encryption key
  * @kck: key confirmation key
@@ -3761,6 +3785,21 @@ int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
 			  enum ieee80211_p2p_attr_id attr,
 			  u8 *buf, unsigned int bufsize);
 
+/**
+ * cfg80211_report_wowlan_wakeup - report wakeup from WoWLAN
+ * @wdev: the wireless device reporting the wakeup
+ * @wakeup: the wakeup report
+ * @gfp: allocation flags
+ *
+ * This function reports that the given device woke up. If it
+ * caused the wakeup, report the reason(s), otherwise you may
+ * pass %NULL as the @wakeup parameter to advertise that something
+ * else caused the wakeup.
+ */
+void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
+				   struct cfg80211_wowlan_wakeup *wakeup,
+				   gfp_t gfp);
+                                                                      
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f10fe9f..f1e169f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4166,4 +4166,16 @@ void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif);
  */
 int ieee80211_ave_rssi(struct ieee80211_vif *vif);
 
+/**
+ * ieee80211_report_wowlan_wakeup - report WoWLAN wakeup
+ * @vif: virtual interface
+ * @wakeup: wakeup reason(s)
+ * @gfp: allocation flags
+ *
+ * See cfg80211_report_wowlan_wakeup().
+ */
+void ieee80211_report_wowlan_wakeup(struct ieee80211_vif *vif,
+				    struct cfg80211_wowlan_wakeup *wakeup,
+				    gfp_t gfp);
+
 #endif /* MAC80211_H */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5470171..0df5db4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -512,6 +512,12 @@
  *	command with the %NL80211_ATTR_WOWLAN_TRIGGERS attribute. For
  *	more background information, see
  *	http://wireless.kernel.org/en/users/Documentation/WoWLAN.
+ *	The @NL80211_CMD_SET_WOWLAN command can also be used as a notification
+ *	from the driver reporting the wakeup reason. In this case, the
+ *	@NL80211_ATTR_WOWLAN_TRIGGERS attribute will contain the reason
+ *	for the wakeup, if it was caused by wireless. If it is not present
+ *	in the wakeup notification, the wireless device didn't cause the
+ *	wakeup but reports that it was woken up.
  *
  * @NL80211_CMD_SET_REKEY_OFFLOAD: This command is used give the driver
  *	the necessary information for supporting GTK rekey offload. This
@@ -2871,6 +2877,10 @@ struct nl80211_wowlan_pattern_support {
  *
  *	In %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED, it is a binary attribute
  *	carrying a &struct nl80211_wowlan_pattern_support.
+ *
+ *	When reporting wakeup. it is a u32 attribute containing the 0-based
+ *	index of the pattern that caused the wakeup, in the patterns passed
+ *	to the kernel when configuring.
  * @NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED: Not a real trigger, and cannot be
  *	used when setting, used only to indicate that GTK rekeying is supported
  *	by the device (flag)
@@ -2881,8 +2891,19 @@ struct nl80211_wowlan_pattern_support {
  * @NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE: wake up on 4-way handshake (flag)
  * @NL80211_WOWLAN_TRIG_RFKILL_RELEASE: wake up when rfkill is released
  *	(on devices that have rfkill in the device) (flag)
+ * @NL80211_WOWLAN_TRIG_WAKEUP_PACKET: For wakeup reporting only, contains the
+ *	packet, if any, that caused the wakeup. This is an 802.3 packet for
+ *	the data matching wakeup reasons (magic packet, pattern match) or an
+ *	802.11 packet (e.g. deauth). The packet may be truncated, the attribute
+ *	@NL80211_WOWLAN_TRIG_WAKEUP_PACKET_LEN contains the original length.
+ * @NL80211_WOWLAN_TRIG_WAKEUP_PACKET_LEN: Original length of the packet, might
+ *	be longer than the length of the @NL80211_WOWLAN_TRIG_WAKEUP_PACKET
+ *	attribute if the packet was truncated.
  * @NUM_NL80211_WOWLAN_TRIG: number of wake on wireless triggers
  * @MAX_NL80211_WOWLAN_TRIG: highest wowlan trigger attribute number
+ *
+ * These nested attributes are used to configure the wakeup triggers and
+ * to report the wakeup reason(s).
  */
 enum nl80211_wowlan_triggers {
 	__NL80211_WOWLAN_TRIG_INVALID,
@@ -2895,6 +2916,8 @@ enum nl80211_wowlan_triggers {
 	NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST,
 	NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE,
 	NL80211_WOWLAN_TRIG_RFKILL_RELEASE,
+	NL80211_WOWLAN_TRIG_WAKEUP_PACKET,
+	NL80211_WOWLAN_TRIG_WAKEUP_PACKET_LEN,
 
 	/* keep last */
 	NUM_NL80211_WOWLAN_TRIG,
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index e45b836..53801d2 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -228,3 +228,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
  * ieee80211_reconfig(), which is also needed for hardware
  * hang/firmware failure/etc. recovery.
  */
+
+void ieee80211_report_wowlan_wakeup(struct ieee80211_vif *vif,
+				    struct cfg80211_wowlan_wakeup *wakeup,
+				    gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_report_wowlan_wakeup(&sdata->wdev, wakeup, gfp);
+}
+EXPORT_SYMBOL(ieee80211_report_wowlan_wakeup);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 142d146..23a61fc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9127,6 +9127,94 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_report_obss_beacon);
 
+#ifdef CONFIG_PM
+void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
+				   struct cfg80211_wowlan_wakeup *wakeup,
+				   gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	int err, size = 200;
+
+	trace_cfg80211_report_wowlan_wakeup(wdev->wiphy, wdev, wakeup);
+
+	if (wakeup)
+		size += wakeup->packet_present_len;
+
+	msg = nlmsg_new(size, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SET_WOWLAN);
+	if (!hdr)
+		goto free_msg;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+		goto free_msg;
+
+	if (wdev->netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+					wdev->netdev->ifindex))
+		goto free_msg;
+
+	if (wakeup) {
+		struct nlattr *reasons;
+
+		reasons = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
+
+		if (wakeup->disconnect &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_DISCONNECT))
+			goto free_msg;
+		if (wakeup->magic_pkt &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT))
+			goto free_msg;
+		if (wakeup->gtk_rekey_failure &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE))
+			goto free_msg;
+		if (wakeup->eap_identity_req &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST))
+			goto free_msg;
+		if (wakeup->four_way_handshake &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE))
+			goto free_msg;
+		if (wakeup->rfkill_release &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_RFKILL_RELEASE))
+			goto free_msg;
+
+		if (wakeup->pattern_idx >= 0 &&
+		    nla_put_u32(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN,
+				wakeup->pattern_idx))
+			goto free_msg;
+
+		if (wakeup->packet) {
+			if (wakeup->packet_len &&
+			    nla_put_u32(msg,
+					NL80211_WOWLAN_TRIG_WAKEUP_PACKET_LEN,
+					wakeup->packet_len))
+				goto free_msg;
+			if (nla_put(msg, NL80211_WOWLAN_TRIG_WAKEUP_PACKET,
+				    wakeup->packet_present_len, wakeup->packet))
+				goto free_msg;
+		}
+
+		nla_nest_end(msg, reasons);
+	}
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0)
+		goto free_msg;
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ free_msg:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_report_wowlan_wakeup);
+#endif
+
 void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
 				enum nl80211_tdls_operation oper,
 				u16 reason_code, gfp_t gfp)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2134576..3bac363 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2315,6 +2315,41 @@ TRACE_EVENT(cfg80211_return_u32,
 	TP_printk("ret: %u", __entry->ret)
 );
 
+TRACE_EVENT(cfg80211_report_wowlan_wakeup,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_wowlan_wakeup *wakeup),
+	TP_ARGS(wiphy, wdev, wakeup),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(bool, disconnect)
+		__field(bool, magic_pkt)
+		__field(bool, gtk_rekey_failure)
+		__field(bool, eap_identity_req)
+		__field(bool, four_way_handshake)
+		__field(bool, rfkill_release)
+		__field(s32, pattern_idx)
+		__field(u32, packet_len)
+		__dynamic_array(u8, packet, wakeup->packet_present_len)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->disconnect = wakeup->disconnect;
+		__entry->magic_pkt = wakeup->magic_pkt;
+		__entry->gtk_rekey_failure = wakeup->gtk_rekey_failure;
+		__entry->eap_identity_req = wakeup->eap_identity_req;
+		__entry->four_way_handshake = wakeup->four_way_handshake;
+		__entry->rfkill_release = wakeup->rfkill_release;
+		__entry->pattern_idx = wakeup->pattern_idx;
+		__entry->packet_len = wakeup->packet_len;
+		if (wakeup->packet && wakeup->packet_present_len)
+			memcpy(__get_dynamic_array(packet), wakeup->packet,
+			       wakeup->packet_present_len);
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
+);		
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.8.0

