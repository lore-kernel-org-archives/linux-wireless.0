Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31651 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYLBUEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:04:32 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mB2K4LMt018832
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:30 +0200
Received: from [127.0.1.1] (essapo-nirac253161.europe.nokia.com [10.162.253.161])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mB2K4KLI027669
	for <linux-wireless@vger.kernel.org>; Tue, 2 Dec 2008 22:04:20 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v4 4/5] mac80211: move dynamic_ps_timeout to hw.conf
To: linux-wireless@vger.kernel.org
Date: Tue, 02 Dec 2008 22:04:19 +0200
Message-ID: <20081202200419.5507.44562.stgit@tikku> (sfid-20081202_210435_267286_2C376CB4)
In-Reply-To: <20081202200219.5507.83250.stgit@tikku>
References: <20081202200219.5507.83250.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/mac80211.h     |    5 +++++
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/mlme.c        |    4 ++--
 net/mac80211/tx.c          |    4 ++--
 net/mac80211/wext.c        |    8 ++++----
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 89affd8..047b20d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -546,6 +546,10 @@ enum ieee80211_conf_changed {
  * @power_level: requested transmit power (in dBm)
  * @channel: the channel to tune to
  * @ht: the HT configuration for the device
+ * @dynamic_ps_timeout: Length of the tranmission idle period after the
+ *    power save mode should be enabled. The timeout should be enabled only
+ *    when %IEEE80211_CONF_PS is enabled. If zero, there should be no timeout.
+ *    Unit is millisecond.
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
  *    (a frame not RTS protected), called "dot11LongRetryLimit" in 802.11,
  *    but actually means the number of transmissions not the number of retries
@@ -560,6 +564,7 @@ struct ieee80211_conf {
 
 	u16 listen_interval;
 	bool radio_enabled;
+	int dynamic_ps_timeout;
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 83b4b08..f03261b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -690,7 +690,6 @@ struct ieee80211_local {
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	bool powersave;
-	int dynamic_ps_timeout;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ee71b12..add3553 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -747,9 +747,9 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	if (local->powersave) {
-		if (local->dynamic_ps_timeout > 0)
+		if (local->hw.conf.dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
-				  msecs_to_jiffies(local->dynamic_ps_timeout));
+				  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 		else {
 			conf->flags |= IEEE80211_CONF_PS;
 			ieee80211_hw_config(local,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9444a06..de3283b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1477,7 +1477,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	}
 
 	if ((local->hw.flags & IEEE80211_HW_NO_DYNAMIC_PS) &&
-	    local->dynamic_ps_timeout > 0) {
+	    local->hw.conf.dynamic_ps_timeout > 0) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			netif_tx_stop_all_queues(local->mdev);
 			queue_work(local->hw.workqueue,
@@ -1485,7 +1485,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		}
 
 		mod_timer(&local->dynamic_ps_timer, jiffies +
-			  msecs_to_jiffies(local->dynamic_ps_timeout));
+			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
 	nh_pos = skb_network_header(skb) - skb->data;
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index a666ced..c4319cc 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -979,20 +979,20 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 		timeout = wrq->value / 1000;
 
 set:
-	if (ps == local->powersave && timeout == local->dynamic_ps_timeout)
+	if (ps == local->powersave && timeout == conf->dynamic_ps_timeout)
 		return ret;
 
 	local->powersave = ps;
-	local->dynamic_ps_timeout = timeout;
+	conf->dynamic_ps_timeout = timeout;
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return ret;
 
 	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
 		if ((local->hw.flags & IEEE80211_HW_NO_DYNAMIC_PS) &&
-		    local->dynamic_ps_timeout > 0)
+		    conf->dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
-				  msecs_to_jiffies(local->dynamic_ps_timeout));
+				  msecs_to_jiffies(conf->dynamic_ps_timeout));
 		else {
 			if (local->powersave)
 				conf->flags |= IEEE80211_CONF_PS;

