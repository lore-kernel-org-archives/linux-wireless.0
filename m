Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19635 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZGXA7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 20:59:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 17:59:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] mac80211: add helper to add to the mac80211 workqueue
Date: Thu, 23 Jul 2009 17:59:01 -0700
Message-ID: <1248397141-6605-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add a mac80211 helper for adding work onto the mac80211
workqueue. We then add a warning if we are suspended. At that
point drivers nor mac80211 should have queued work, drivers
and mac80211 should ensure the workqueue will remain clair
until resume.

We don't migrate drivers yet, those can be done on a case by
case basis, but once all drivers are moved we could just make
the workqueue private to prevent future drivers from accessing
it directly.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/mac80211.h   |   12 ++++++++++++
 net/mac80211/ibss.c      |    6 +++---
 net/mac80211/iface.c     |    2 +-
 net/mac80211/mesh.c      |   10 +++++-----
 net/mac80211/mesh_hwmp.c |    4 ++--
 net/mac80211/mlme.c      |   42 +++++++++++++++++++-----------------------
 net/mac80211/tx.c        |    2 +-
 net/mac80211/util.c      |   20 ++++++++++++++++++++
 8 files changed, 63 insertions(+), 35 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7dd67a1..5804a32 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1924,6 +1924,18 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
 						void *data);
 
 /**
+ * ieee80211_queue_work - add work onto the mac80211 workqueue
+ *
+ * Drivers and mac80211 should use this to add work onto the mac80211
+ * workqueue instead of adding work directly through queue_work(). This
+ * helper ensures drivers are not queueing work when they should not be.
+ *
+ * @hw: the hardware struct for the interface we are adding work for
+ * @work: the work we want to add onto the mac80211 workqueue
+ */
+int ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work);
+
+/**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @ra: receiver address of the BA session recipient
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8e22200..f0573c5 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -781,7 +781,7 @@ static void ieee80211_ibss_timer(unsigned long data)
 	}
 
 	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
-	queue_work(local->hw.workqueue, &ifibss->work);
+	ieee80211_queue_work(&local->hw, &ifibss->work);
 }
 
 #ifdef CONFIG_PM
@@ -853,7 +853,7 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_AUTH:
 		skb_queue_tail(&sdata->u.ibss.skb_queue, skb);
-		queue_work(local->hw.workqueue, &sdata->u.ibss.work);
+		ieee80211_queue_work(&local->hw, &sdata->u.ibss.work);
 		return RX_QUEUED;
 	}
 
@@ -912,7 +912,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_idle(sdata->local);
 
 	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	queue_work(sdata->local->hw.workqueue, &sdata->u.ibss.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.ibss.work);
 
 	return 0;
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2f797a8..9b9b3d4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -312,7 +312,7 @@ static int ieee80211_open(struct net_device *dev)
 	 * to fix this.
 	 */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
+		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 
 	netif_tx_start_all_queues(dev);
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8a97b14..84546b2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -54,7 +54,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 }
 
 /**
@@ -357,7 +357,7 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 }
 
 struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
@@ -471,7 +471,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 
 	ifmsh->housekeeping = true;
-	queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED);
 }
@@ -619,7 +619,7 @@ void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			queue_work(local->hw.workqueue, &sdata->u.mesh.work);
+			ieee80211_queue_work(local->hw.workqueue, &sdata->u.mesh.work);
 	rcu_read_unlock();
 }
 
@@ -692,7 +692,7 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 		skb_queue_tail(&ifmsh->skb_queue, skb);
-		queue_work(local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 		return RX_QUEUED;
 	}
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e93c37e..11ab71a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -660,14 +660,14 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 	spin_unlock(&ifmsh->mesh_preq_queue_lock);
 
 	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
-		queue_work(sdata->local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(sdata->local->hw.workqueue, &ifmsh->work);
 
 	else if (time_before(jiffies, ifmsh->last_preq)) {
 		/* avoid long wait if did not send preqs for a long time
 		 * and jiffies wrapped around
 		 */
 		ifmsh->last_preq = jiffies - min_preq_int_jiff(sdata) - 1;
-		queue_work(sdata->local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(sdata->local->hw.workqueue, &ifmsh->work);
 	} else
 		mod_timer(&ifmsh->mesh_path_timer, ifmsh->last_preq +
 						min_preq_int_jiff(sdata));
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index db0b4b2..3da36d2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -565,7 +565,7 @@ static void ieee80211_chswitch_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
+	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 }
 
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
@@ -597,7 +597,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	sdata->local->csa_channel = new_ch;
 
 	if (sw_elem->count <= 1) {
-		queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
+		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	} else {
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -763,7 +763,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
+	ieee80211_queue_work(&local->hw, &local->dynamic_ps_enable_work);
 }
 
 /* MLME */
@@ -950,7 +950,7 @@ ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
 		 * due to work needing to be done. Hence, queue the STAs work
 		 * again for that.
 		 */
-		queue_work(local->hw.workqueue, &ifmgd->work);
+		ieee80211_queue_work(&local->hw, &ifmgd->work);
 		return RX_MGMT_CFG80211_AUTH_TO;
 	}
 
@@ -995,7 +995,7 @@ ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
 		 * due to work needing to be done. Hence, queue the STAs work
 		 * again for that.
 		 */
-		queue_work(local->hw.workqueue, &ifmgd->work);
+		ieee80211_queue_work(&local->hw, &ifmgd->work);
 		return RX_MGMT_CFG80211_AUTH_TO;
 	}
 
@@ -1124,7 +1124,7 @@ ieee80211_associate(struct ieee80211_sub_if_data *sdata,
 		 * due to work needing to be done. Hence, queue the STAs work
 		 * again for that.
 		 */
-		queue_work(local->hw.workqueue, &ifmgd->work);
+		ieee80211_queue_work(&local->hw, &ifmgd->work);
 		return RX_MGMT_CFG80211_ASSOC_TO;
 	}
 
@@ -1232,8 +1232,7 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	queue_work(sdata->local->hw.workqueue,
-		   &sdata->u.mgd.beacon_loss_work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.beacon_loss_work);
 }
 EXPORT_SYMBOL(ieee80211_beacon_loss);
 
@@ -1888,7 +1887,7 @@ ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_STYPE_DISASSOC:
 	case IEEE80211_STYPE_ACTION:
 		skb_queue_tail(&sdata->u.mgd.skb_queue, skb);
-		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
+		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 		return RX_QUEUED;
 	}
 
@@ -2023,7 +2022,7 @@ static void ieee80211_sta_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(local->hw.workqueue, &ifmgd->work);
+	ieee80211_queue_work(&local->hw, &ifmgd->work);
 }
 
 static void ieee80211_sta_work(struct work_struct *work)
@@ -2048,13 +2047,11 @@ static void ieee80211_sta_work(struct work_struct *work)
 		return;
 
 	/*
-	 * Nothing should have been stuffed into the workqueue during
-	 * the suspend->resume cycle. If this WARN is seen then there
-	 * is a bug with either the driver suspend or something in
-	 * mac80211 stuffing into the workqueue which we haven't yet
-	 * cleared during mac80211's suspend cycle.
+	 * ieee80211_queue_work() should have picked up most cases,
+	 * here we'll pick the the rest.
 	 */
-	if (WARN_ON(local->suspended))
+	if (WARN(local->suspended, "STA MLME work scheduled while "
+		 "going to suspend\n"))
 		return;
 
 	ifmgd = &sdata->u.mgd;
@@ -2193,8 +2190,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(sdata->local->hw.workqueue,
-		   &sdata->u.mgd.beacon_loss_work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.beacon_loss_work);
 }
 
 static void ieee80211_sta_conn_mon_timer(unsigned long data)
@@ -2207,7 +2203,7 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(local->hw.workqueue, &ifmgd->monitor_work);
+	ieee80211_queue_work(&local->hw, &ifmgd->monitor_work);
 }
 
 static void ieee80211_sta_monitor_work(struct work_struct *work)
@@ -2226,10 +2222,10 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 					IEEE80211_STA_CONNECTION_POLL);
 
 		/* let's probe the connection once */
-		queue_work(sdata->local->hw.workqueue,
+		ieee80211_queue_work(&sdata->local->hw,
 			   &sdata->u.mgd.monitor_work);
 		/* and do all the other regular work too */
-		queue_work(sdata->local->hw.workqueue,
+		ieee80211_queue_work(&sdata->local->hw,
 			   &sdata->u.mgd.work);
 	}
 }
@@ -2389,7 +2385,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	list_add(&wk->list, &sdata->u.mgd.work_list);
 	mutex_unlock(&ifmgd->mtx);
 
-	queue_work(sdata->local->hw.workqueue, &sdata->u.mgd.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 	return 0;
 }
 
@@ -2462,7 +2458,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	else
 		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
 
-	queue_work(sdata->local->hw.workqueue, &sdata->u.mgd.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 
 	err = 0;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c11cbbd..8369fe2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1400,7 +1400,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);
-			queue_work(local->hw.workqueue,
+			ieee80211_queue_work(&local->hw,
 					&local->dynamic_ps_disable_work);
 		}
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7fc5584..1375511 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -498,6 +498,25 @@ void ieee80211_iterate_active_interfaces_atomic(
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
 
+int ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	/*
+	 * Nothing should have been stuffed into the workqueue during
+	 * the suspend->resume cycle. If this WARN is seen then there
+	 * is a bug with either the driver suspend or something in
+	 * mac80211 stuffing into the workqueue which we haven't yet
+	 * cleared during mac80211's suspend cycle.
+	 */
+        if (WARN(local->suspended, "queueing ieee80211 work while "
+		 "going to suspend\n"))
+                return -EINVAL;
+
+	return queue_work(hw->workqueue, work);
+}
+EXPORT_SYMBOL_GPL(ieee80211_queue_work);
+
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems)
 {
@@ -1101,3 +1120,4 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 #endif
 	return 0;
 }
+
-- 
1.6.3.3

