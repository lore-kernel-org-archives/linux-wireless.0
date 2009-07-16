Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44081 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZGPJJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:09:34 -0400
Received: by fxm18 with SMTP id 18so3956870fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:09:32 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT 5/5] mac80211: implement basic background scanning
Date: Thu, 16 Jul 2009 11:09:40 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200907161104.41975.helmut.schaa@gmail.com>
In-Reply-To: <200907161104.41975.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907161109.40471.helmut.schaa@gmail.com>
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

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.>

---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index be880b5..15e8b4a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -570,9 +570,40 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 };
 
+/**
+ * enum mac80211_scan_flag - currently active scan mode
+ *
+ * @SCAN_SW_SCANNING: We're off our operating channel for scanning
+ * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
+ *	determine if we are on the operating channel or not
+ * @SCAN_BG_SCANNING: We're currently in the process of scanning but may
+ *	as well be on the operating channel
+ */
 enum mac80211_scan_flag {
 	SCAN_SW_SCANNING = 1,"SCAN_ENTER_OPER_CHANNEL"
 	SCAN_HW_SCANNING = 2,
+	SCAN_BG_SCANNING = 4,
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
@@ -683,7 +714,7 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 
-	enum { SCAN_DECISION, SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
+	enum mac80211_scan_state scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	enum nl80211_channel_type oper_channel_type;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2e514f2..634442c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -513,7 +513,7 @@ static int ieee80211_stop(struct net_device *dev)
 			 * the scan_sdata is NULL already don't send out a
 			 * scan event to userspace -- the scan is incomplete.
 			 */
-			if (local->scanning & SCAN_SW_SCANNING)
+			if (local->scanning & SCAN_BG_SCANNING)
 				ieee80211_scan_completed(&local->hw, true);
 		}
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a1b4887..a87522f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -198,7 +198,7 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (local->scanning & SCAN_SW_SCANNING) {
+		if (local->scanning & SCAN_BG_SCANNING) {
 			sdata->vif.bss_conf.enable_beacon = false;
 		} else {
 			/*
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3df8a6e..24739ab 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2136,7 +2136,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		return;
 	}
 
-	if (unlikely(local->scanning))
+	if (unlikely((local->scanning & SCAN_HW_SCANNING) || (local->scanning & SCAN_SW_SCANNING)))
 		rx.flags |= IEEE80211_RX_IN_SCAN;
 
 	ieee80211_parse_qos(&rx);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b4cc556..8f33fb5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -282,7 +282,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
 
-	was_hw_scan = local->scanning & SCAN_HW_SCANNING;
+	was_hw_scan = !!(local->scanning & SCAN_HW_SCANNING);
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
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
@@ -435,7 +434,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan)
 		local->scanning |= SCAN_HW_SCANNING;
 	else
-		local->scanning |= SCAN_SW_SCANNING;
+		local->scanning |= SCAN_BG_SCANNING;
 	/*
 	 * Kicking off the scan need not be protected,
 	 * only the scan variable stuff, since now
@@ -473,17 +472,115 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 static int ieee80211_scan_state_decision(struct ieee80211_local *local, unsigned long *next_delay)
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
 
+static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local, unsigned long *next_delay)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	local->scanning |= SCAN_SW_SCANNING;
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
+	/* advance to the next channel to be scanned */
+	*next_delay = HZ / 10;
+	local->scan_state = SCAN_SET_CHANNEL;
+}
+
+static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local, unsigned long *next_delay)
+{
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+
+	/* switch back to the operating channel */
+	local->scan_channel = NULL;
+	if (ieee80211_hw_config(local,
+					IEEE80211_CONF_CHANGE_CHANNEL))
+		printk(KERN_DEBUG "%s: failed to restore operational "
+		"channel during scan\n", sdata->dev->name);
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
+			if (sdata->u.mgd.associated) {
+				ieee80211_scan_ps_disable(sdata);
+			}
+			netif_tx_wake_all_queues(sdata->dev);
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	local->scanning &= ~SCAN_SW_SCANNING;
+
+	*next_delay = HZ / 5;
+	local->scan_state = SCAN_DECISION;
+}
+
 static void ieee80211_scan_state_set_channel(struct ieee80211_local *local, unsigned long *next_delay)
 {
 	int skip;
@@ -606,6 +703,12 @@ void ieee80211_scan_work(struct work_struct *work)
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
 
@@ -657,7 +760,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	 * queued -- mostly at suspend under RTNL.
 	 */
 	mutex_lock(&local->scan_mtx);
-	swscan = !!(local->scanning & SCAN_SW_SCANNING);
+	swscan = !!(local->scanning & SCAN_BG_SCANNING);
 	mutex_unlock(&local->scan_mtx);
 
 	if (swscan)
