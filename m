Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39741 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYLIP2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:28:06 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: integrate sta_notify_ps cmds into sta_notify
Date: Tue, 9 Dec 2008 16:28:06 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812091628.06947.chunkeey@web.de> (sfid-20081209_162810_992901_F74CED52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces the newly introduced sta_notify_ps function,
which can be used to notify the driver about every power state 
transition for all associated stations, by integrating its functionality
back into the original sta_notify callback.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
It turned out that sta_notify needs to be atomic as well. so
we don't break locking requirement.

Let me know, if you find any spelling errors in the documentation.

and @ Johannes:
make htmldocs -j3
  DOCPROC Documentation/DocBook/mac80211.xml
  HTML    Documentation/DocBook/mac80211.html
[...]
---
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f43da1c..af6cd83 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -524,6 +524,10 @@ static void mac80211_hwsim_sta_notify(struct ieee80211_hw *hw,
 	case STA_NOTIFY_REMOVE:
 		hwsim_clear_sta_magic(sta);
 		break;
+	case STA_NOTIFY_SLEEP:
+	case STA_NOTIFY_AWAKE:
+		/* TODO: make good use of these flags */
+		break;
 	}
 }
 
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 719bdab..1e1c06e 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1052,19 +1052,6 @@ static int p54_sta_unlock(struct ieee80211_hw *dev, u8 *addr)
 	return 0;
 }
 
-static void p54_sta_notify_ps(struct ieee80211_hw *dev,
-			      enum sta_notify_ps_cmd notify_cmd,
-			      struct ieee80211_sta *sta)
-{
-	switch (notify_cmd) {
-	case STA_NOTIFY_AWAKE:
-		p54_sta_unlock(dev, sta->addr);
-		break;
-	default:
-		break;
-	}
-}
-
 static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 			      enum sta_notify_cmd notify_cmd,
 			      struct ieee80211_sta *sta)
@@ -1079,6 +1066,10 @@ static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 
 		p54_sta_unlock(dev, sta->addr);
 		break;
+	case STA_NOTIFY_AWAKE:
+		/* update the firmware's filter table */
+		p54_sta_unlock(dev, sta->addr);
+		break;
 	default:
 		break;
 	}
@@ -2028,7 +2019,6 @@ static const struct ieee80211_ops p54_ops = {
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
 	.set_tim		= p54_set_tim,
-	.sta_notify_ps		= p54_sta_notify_ps,
 	.sta_notify		= p54_sta_notify,
 	.set_key		= p54_set_key,
 	.config			= p54_config,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 346f373..674f90d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -773,25 +773,16 @@ struct ieee80211_sta {
  * enum sta_notify_cmd - sta notify command
  *
  * Used with the sta_notify() callback in &struct ieee80211_ops, this
- * indicates addition and removal of a station to station table.
+ * indicates addition and removal of a station to station table,
+ * or if a associated station made a power state transition.
  *
  * @STA_NOTIFY_ADD: a station was added to the station table
  * @STA_NOTIFY_REMOVE: a station being removed from the station table
- */
-enum sta_notify_cmd {
-	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
-};
-
-/**
- * enum sta_notify_ps_cmd - sta power save notify command
- *
- * Used with the sta_notify_ps() callback in &struct ieee80211_ops to
- * notify the driver if a station made a power state transition.
- *
  * @STA_NOTIFY_SLEEP: a station is now sleeping
  * @STA_NOTIFY_AWAKE: a sleeping station woke up
  */
-enum sta_notify_ps_cmd {
+enum sta_notify_cmd {
+	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
 	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
 };
 
@@ -1262,11 +1253,9 @@ enum ieee80211_ampdu_mlme_action {
  *	the device does fragmentation by itself; if this method is assigned then
  *	the stack will not do fragmentation.
  *
- * @sta_notify: Notifies low level driver about addition or removal of an
- *	associated station, AP, IBSS/WDS/mesh peer etc. Must be atomic.
- *
- * @sta_ps_notify: Notifies low level driver about the power state transition
- *	of a associated station. Must be atomic.
+ * @sta_notify: Notifies low level driver about addition, removal or power
+ *	state transition of an associated station, AP,  IBSS/WDS/mesh peer etc.
+ *	Must be atomic.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
@@ -1334,8 +1323,6 @@ struct ieee80211_ops {
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
-	void (*sta_notify_ps)(struct ieee80211_hw *hw,
-			enum sta_notify_ps_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 59f356a..ffaaa2a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -659,9 +659,9 @@ static void ap_sta_ps_start(struct sta_info *sta)
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
-	if (local->ops->sta_notify_ps)
-		local->ops->sta_notify_ps(local_to_hw(local), STA_NOTIFY_SLEEP,
-					  &sta->sta);
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
+					STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
@@ -679,9 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
-	if (local->ops->sta_notify_ps)
-		local->ops->sta_notify_ps(local_to_hw(local), STA_NOTIFY_AWAKE,
-					  &sta->sta);
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
+					STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
