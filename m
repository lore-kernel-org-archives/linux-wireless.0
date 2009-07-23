Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:35299 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZGWKOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:14:04 -0400
Received: by mail-bw0-f228.google.com with SMTP id 28so709536bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:14:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 5/7] mac80211: implement basic background scanning
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jul 2009 12:14:12 +0200
Message-ID: <20090723101411.5147.78380.stgit@localhost.localdomain>
In-Reply-To: <20090723100732.5147.73989.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a new scan flag "SCAN_BG_SCANNING" which basically tells us
that we are currently scanning but may as well be on the operating channel
to RX/TX data whereas "SCAN_SW_SCANNING" tells us that we are currently
on a different channel for scanning. While "SCAN_BG_SCANNING" is set
during the whole scan "SCAN_SW_SCANNING" is set when leaving the operating
channel and unset when coming back.
    
Introduce two new scan states "SCAN_LEAVE_OPER_CHANNEL" and
"SCAN_ENTER_OPER_CHANNEL" which basically implement the functionality we
need to leave the operating channel (send a nullfunc to the AP and stop
the queues) and enter it again (send a nullfunc to the AP and start the
queues again).
    
Enhance the scan state "SCAN_DECISION" to switch back to the operating
channel after each scanned channel. In the future it sould be simple
to enhance the decision state to scan as much channels in a row as the
qos latency allows us.
    
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/ieee80211_i.h |   36 +++++++++++++-
 net/mac80211/rx.c          |    6 ++
 net/mac80211/scan.c        |  117 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/tx.c          |    2 -
 4 files changed, 148 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 783a125..efda19e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -570,9 +570,41 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 };
 
+/**
+ * mac80211 scan flags - currently active scan mode
+ *
+ * @SCAN_SW_SCANNING: We're currently in the process of scanning but may as
+ *	well be on the operating channel
+ * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
+ *	determine if we are on the operating channel or not
+ * @SCAN_OFF_CHANNEL: We're off our operating channel for scanning,
+ *	gets only set in conjunction with SCAN_SW_SCANNING
+ */
 enum {
 	SCAN_SW_SCANNING,
-	SCAN_HW_SCANNING
+	SCAN_HW_SCANNING,
+	SCAN_OFF_CHANNEL,
+};
+
+/**
+ * enum mac80211_scan_state - scan state machine states
+ *
+ * @SCAN_DECISION: Main entry point to the scan state machine, this state
+ *	determines if we should keep on scanning or switch back to the
+ *	operating channel
+ * @SCAN_SET_CHANNEL: Set the next channel to be scanned
+ * @SCAN_SEND_PROBE: Send probe requests and wait for probe responses
+ * @SCAN_LEAVE_OPER_CHANNEL: Leave the operating channel, notify the AP
+ *	about us leaving the channel and stop all associated STA interfaces
+ * @SCAN_ENTER_OPER_CHANNEL: Enter the operating channel again, notify the
+ *	AP about us being back and restart all associated STA interfaces
+ */
+enum mac80211_scan_state {
+	SCAN_DECISION,
+	SCAN_SET_CHANNEL,
+	SCAN_SEND_PROBE,
+	SCAN_LEAVE_OPER_CHANNEL,
+	SCAN_ENTER_OPER_CHANNEL,
 };
 
 struct ieee80211_local {
@@ -683,7 +715,7 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 
-	enum { SCAN_DECISION, SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
+	enum mac80211_scan_state scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	enum nl80211_channel_type oper_channel_type;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b1bebc1..dd192b3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -421,7 +421,8 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning)))
 		return ieee80211_scan_rx(rx->sdata, skb);
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning))) {
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning) &&
+		     (rx->flags & IEEE80211_RX_IN_SCAN))) {
 		/* drop all the other packets during a software scan anyway */
 		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
 			dev_kfree_skb(skb);
@@ -2136,7 +2137,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		return;
 	}
 
-	if (unlikely(local->scanning))
+	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
+		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
 		rx.flags |= IEEE80211_RX_IN_SCAN;
 
 	ieee80211_parse_qos(&rx);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4233c3d..d56b9da 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -365,12 +365,11 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 			ieee80211_bss_info_change_notify(
 				sdata, BSS_CHANGED_BEACON_ENABLED);
 
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.mgd.associated) {
-				netif_tx_stop_all_queues(sdata->dev);
-				ieee80211_scan_ps_enable(sdata);
-			}
-		} else
+		/*
+		 * only handle non-STA interfaces here, STA interfaces
+		 * are handled in the scan state machine
+		 */
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			netif_tx_stop_all_queues(sdata->dev);
 	}
 	mutex_unlock(&local->iflist_mtx);
@@ -474,17 +473,113 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 					 unsigned long *next_delay)
 {
-	/* if no more bands/channels left, complete scan */
+	bool associated = false;
+	struct ieee80211_sub_if_data *sdata;
+
+	/* if no more bands/channels left, complete scan and advance to the idle state */
 	if (local->scan_channel_idx >= local->scan_req->n_channels) {
 		ieee80211_scan_completed(&local->hw, false);
 		return 1;
 	}
 
+	/* check if at least one STA interface is associated */
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			if (sdata->u.mgd.associated) {
+				associated = true;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	if (local->scan_channel) {
+		/*
+		 * we're currently scanning a different channel, let's
+		 * switch back to the operating channel now if at least
+		 * one interface is associated. Otherwise just scan the
+		 * next channel
+		 */
+		if (associated)
+			local->scan_state = SCAN_ENTER_OPER_CHANNEL;
+		else
+			local->scan_state = SCAN_SET_CHANNEL;
+	} else {
+		/*
+		 * we're on the operating channel currently, let's
+		 * leave that channel now to scan another one
+		 */
+		local->scan_state = SCAN_LEAVE_OPER_CHANNEL;
+	}
+
 	*next_delay = 0;
-	local->scan_state = SCAN_SET_CHANNEL;
 	return 0;
 }
 
+static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
+						    unsigned long *next_delay)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	/*
+	 * notify the AP about us leaving the channel and stop all STA interfaces
+	 */
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			netif_tx_stop_all_queues(sdata->dev);
+			if (sdata->u.mgd.associated)
+				ieee80211_scan_ps_enable(sdata);
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
+
+	/* advance to the next channel to be scanned */
+	*next_delay = HZ / 10;
+	local->scan_state = SCAN_SET_CHANNEL;
+}
+
+static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local,
+						    unsigned long *next_delay)
+{
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+
+	/* switch back to the operating channel */
+	local->scan_channel = NULL;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	/*
+	 * notify the AP about us being back and restart all STA interfaces
+	 */
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+
+		/* Tell AP we're back */
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			if (sdata->u.mgd.associated)
+				ieee80211_scan_ps_disable(sdata);
+			netif_tx_wake_all_queues(sdata->dev);
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
+
+	*next_delay = HZ / 5;
+	local->scan_state = SCAN_DECISION;
+}
+
 static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 					     unsigned long *next_delay)
 {
@@ -609,6 +704,12 @@ void ieee80211_scan_work(struct work_struct *work)
 		case SCAN_SEND_PROBE:
 			ieee80211_scan_state_send_probe(local, &next_delay);
 			break;
+		case SCAN_LEAVE_OPER_CHANNEL:
+			ieee80211_scan_state_leave_oper_channel(local, &next_delay);
+			break;
+		case SCAN_ENTER_OPER_CHANNEL:
+			ieee80211_scan_state_enter_oper_channel(local, &next_delay);
+			break;
 		}
 	} while (next_delay == 0);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 61739ab..275bc15 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -192,7 +192,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
 		return TX_CONTINUE;
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
+	if (unlikely(test_bit(SCAN_OFF_CHANNEL, &tx->local->scanning)) &&
 	    !ieee80211_is_probe_req(hdr->frame_control) &&
 	    !ieee80211_is_nullfunc(hdr->frame_control))
 		/*

