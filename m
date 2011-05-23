Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:8718 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab1G1RCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:02:04 -0400
Message-Id: <ee96368a4bef8d9cca786406089c5f3806b33f5c.1311872448.git.pstew@chromium.org> (sfid-20110728_190209_373633_0A17FEC0)
In-Reply-To: <5ec1fd1a0868f7a07741c25fa43fff0969667f9e.1311870004.git.pstew@chromium.org>
References: <5ec1fd1a0868f7a07741c25fa43fff0969667f9e.1311870004.git.pstew@chromium.org>
From: Paul Stewart <pstew@chromium.org>
Date: Mon, 23 May 2011 14:34:14 -0700
Subject: [PATCHv2] nl80211: add support to abort a scan request on tx
To: linux-wireless@vger.kernel.org
Cc: sleffler@chromium.org, johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_ATTR_SCAN_FLAGS to nl80211's NL80211_CMD_TRIGGER_SCAN and
define a flag to indicate outbound traffic should abort a scan request.
This is implemented in mac80211 and can be used (e.g. by wpa_supplicant)
to cause low-priority scan requests to be aborted when traffic is present
(reducing tx latency).

Signed-off-by: pstew@chromium.org
Signed-off-by: sleffler@chromium.org
---
v2: Fix broken merge into wireless-testing

 include/linux/nl80211.h    |    3 +++
 include/net/cfg80211.h     |   11 +++++++++++
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/scan.c        |   44 +++++++++++++++++++++++++++++++++++---------
 net/wireless/nl80211.c     |    6 ++++++
 5 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 7ba71e4..b7b8ea0 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1014,6 +1014,8 @@ enum nl80211_commands {
  * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
  *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
  *
+ * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u8)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1216,6 +1218,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
 	NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
+	NL80211_ATTR_SCAN_FLAGS,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 930c783..fc46f81 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -769,6 +769,15 @@ struct cfg80211_ssid {
 };
 
 /**
+ * enum cfg80211_scan_flag -  scan request control flags
+ *
+ * @CFG80211_SCAN__FLAG_TX_ABORT: abort scan on pending transmit
+ */
+enum cfg80211_scan_flags {
+	CFG80211_SCAN_FLAG_TX_ABORT	= BIT(0),
+};
+
+/**
  * struct cfg80211_scan_request - scan request description
  *
  * @ssids: SSIDs to scan for (active scan only)
@@ -777,6 +786,7 @@ struct cfg80211_ssid {
  * @n_channels: total number of channels to scan
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @flags: bit field of flags controlling operation
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
@@ -787,6 +797,7 @@ struct cfg80211_scan_request {
 	u32 n_channels;
 	const u8 *ie;
 	size_t ie_len;
+	u8 flags;
 
 	/* internal */
 	struct wiphy *wiphy;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index dda0d1a..f1eaab9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -714,6 +714,10 @@ enum {
  *	about us leaving the channel and stop all associated STA interfaces
  * @SCAN_ENTER_OPER_CHANNEL: Enter the operating channel again, notify the
  *	AP about us being back and restart all associated STA interfaces
+ * @SCAN_ABORT: Abnormally terminate the scan operation, set only when
+ *	on the operating channel
+ * @SCAN_ENTER_OPER_CHANNEL_ABORT: Return to the operating channel then
+ *	terminate the scan operation
  */
 enum mac80211_scan_state {
 	SCAN_DECISION,
@@ -721,6 +725,8 @@ enum mac80211_scan_state {
 	SCAN_SEND_PROBE,
 	SCAN_LEAVE_OPER_CHANNEL,
 	SCAN_ENTER_OPER_CHANNEL,
+	SCAN_ABORT,
+	SCAN_ENTER_OPER_CHANNEL_ABORT,
 };
 
 struct ieee80211_local {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 08a45ac..cd269f5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -478,6 +478,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	unsigned long min_beacon_int = 0;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
+	enum mac80211_scan_state next_scan_state;
 
 	/*
 	 * check if at least one STA interface is associated,
@@ -511,15 +512,19 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 
 	if (ieee80211_cfg_on_oper_channel(local)) {
 		/* We're currently on operating channel. */
-		if (next_chan == local->oper_channel)
+		if (associated && !tx_empty &&
+		    (local->scan_req->flags & CFG80211_SCAN_FLAG_TX_ABORT))
+			/* We have a pending xmit and scan should abort. */
+			next_scan_state = SCAN_ABORT;
+		else if (next_chan == local->oper_channel)
 			/* We don't need to move off of operating channel. */
-			local->next_scan_state = SCAN_SET_CHANNEL;
+			next_scan_state = SCAN_SET_CHANNEL;
 		else
 			/*
 			 * We do need to leave operating channel, as next
 			 * scan is somewhere else.
 			 */
-			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+			next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
 	} else {
 		/*
 		 * we're currently scanning a different channel, let's
@@ -548,12 +553,24 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 				usecs_to_jiffies(min_beacon_int * 1024) *
 				local->hw.conf.listen_interval);
 
-		if (associated && ( !tx_empty || bad_latency ||
-		    listen_int_exceeded))
-			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
+
+		if (associated && !tx_empty) {
+			if (unlikely(local->scan_req->flags & CFG80211_SCAN_FLAG_TX_ABORT)) {
+				/*
+				 * Scan request is marked to abort when there
+				 * is outbound traffic.  Mark state to return
+				 * the operating channel and then abort.  This
+				 * happens as soon as possible.
+				 */
+				next_scan_state = SCAN_ENTER_OPER_CHANNEL_ABORT;
+			} else
+				next_scan_state = SCAN_ENTER_OPER_CHANNEL;
+		} else if (associated && (bad_latency || listen_int_exceeded))
+			next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
-			local->next_scan_state = SCAN_SET_CHANNEL;
+			next_scan_state = SCAN_SET_CHANNEL;
 	}
+	local->next_scan_state = next_scan_state;
 
 	*next_delay = 0;
 }
@@ -597,8 +614,13 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 	 */
 	ieee80211_offchannel_return(local, true, false);
 
-	*next_delay = HZ / 5;
-	local->next_scan_state = SCAN_DECISION;
+	if (local->next_scan_state == SCAN_ENTER_OPER_CHANNEL) {
+		*next_delay = HZ / 5;
+		local->next_scan_state = SCAN_DECISION;
+	} else {
+		*next_delay = 0;
+		local->next_scan_state = SCAN_ABORT;
+	}
 }
 
 static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
@@ -744,8 +766,12 @@ void ieee80211_scan_work(struct work_struct *work)
 			ieee80211_scan_state_leave_oper_channel(local, &next_delay);
 			break;
 		case SCAN_ENTER_OPER_CHANNEL:
+		case SCAN_ENTER_OPER_CHANNEL_ABORT:
 			ieee80211_scan_state_enter_oper_channel(local, &next_delay);
 			break;
+		case SCAN_ABORT:
+			aborted = true;
+			goto out_complete;
 		}
 	} while (next_delay == 0);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44a3fc2..81fa898 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -132,6 +132,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MGMT_SUBTYPE] = { .type = NLA_U8 },
 	[NL80211_ATTR_IE] = { .type = NLA_BINARY,
 			      .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U8 },
 	[NL80211_ATTR_SCAN_FREQUENCIES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SCAN_SSIDS] = { .type = NLA_NESTED },
 
@@ -3450,6 +3451,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		       request->ie_len);
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u8(info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
@@ -6137,6 +6141,8 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	if (req->ie)
 		NLA_PUT(msg, NL80211_ATTR_IE, req->ie_len, req->ie);
 
+	NLA_PUT_U8(msg, NL80211_ATTR_SCAN_FLAGS, req->flags);
+
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
-- 
1.7.3.1

