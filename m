Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx71.mail.ru ([94.100.176.85]:55714 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZIQPI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 11:08:57 -0400
Subject: [PATCH] mac80211: Fix [re]association power saving issue on AP side
From: Igor Perminov <igor.perminov@inbox.ru>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 17 Sep 2009 19:08:57 +0400
Message-Id: <1253200137.26765.338.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Consider the following step-by step:
1. A STA authenticates and associates with the AP and exchanges
traffic.
2. The STA reports to the AP that it is going to PS state.
3. Some time later the STA device goes to the stand-by mode (not only
its wi-fi card, but the device itself) and drops the association state
without sending a disassociation frame.
4. The STA device wakes up and begins authentication with an
Auth frame as it hasn't been authenticated/associated previously.
 
At the step 4 the AP "remembers" the STA and considers it is still in
the PS state, so the AP buffers frames, which it has to send to the STA.
But the STA isn't actually in the PS state and so it neither checks
TIM bits nor reports to the AP that it isn't power saving.
Because of that reauthentication/association fails.

To fix this issue:
1. Auth, Assoc Resp and Reassoc Resp frames are transmitted disregarding
of STA's power saving state.
2. When an application (hostapd) tries to add a STA to an AP (that
occurs when the STA has [re]associated successfully) and mac80211
already "knows" that STA, the AP resets the power saving state of the
STA and purges of frames that was previously buffered if any.

Signed-off-by: Igor Perminov <igor.perminov@inbox.ru>
---
 net/mac80211/cfg.c      |   15 +++++++++------
 net/mac80211/sta_info.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |    1 +
 net/mac80211/tx.c       |    5 ++++-
 4 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5608f6c..20d4c12 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -704,7 +704,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
        struct sta_info *sta;
        struct ieee80211_sub_if_data *sdata;
        int err;
-       int layer2_update;
+       int iftype_ap;
 
        if (params->vlan) {
                sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -731,7 +731,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 
        rate_control_rate_init(sta);
 
-       layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+       iftype_ap = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
                sdata->vif.type == NL80211_IFTYPE_AP;
 
        rcu_read_lock();
@@ -739,17 +739,20 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
        err = sta_info_insert(sta);
        if (err) {
                /* STA has been freed */
-               if (err == -EEXIST && layer2_update) {
-                       /* Need to update layer 2 devices on reassociation */
+               if (err == -EEXIST && iftype_ap) {
+                       /* Need to reset PS state
+                        * and update layer 2 devices on reassociation */
                        sta = sta_info_get(local, mac);
-                       if (sta)
+                       if (sta) {
+                               sta_info_reset_ps(sta);
                                ieee80211_send_layer2_update(sta);
+                       }
                }
                rcu_read_unlock();
                return err;
        }
 
-       if (layer2_update)
+       if (iftype_ap)
                ieee80211_send_layer2_update(sta);
 
        rcu_read_unlock();
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index eec0014..09dc8de 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -459,6 +459,53 @@ void sta_info_clear_tim_bit(struct sta_info *sta)
        spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 }
 
+void sta_info_reset_ps(struct sta_info *sta)
+{
+       struct ieee80211_sub_if_data *sdata = sta->sdata;
+       struct ieee80211_local *local = sdata->local;
+       struct ieee80211_if_ap *bss = sdata->bss;
+       unsigned long flags;
+       int filtered, buffered;
+
+       BUG_ON(!bss);
+
+       spin_lock_irqsave(&sta->local->sta_lock, flags);
+
+       if (!test_sta_flags(sta, WLAN_STA_PS)) {
+               spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+               return;
+       }
+
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+       printk(KERN_DEBUG "%s: STA %pM aid %d resets power save mode\n",
+              sdata->dev->name, sta->sta.addr, sta->sta.aid);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+
+       atomic_dec(&bss->num_sta_ps);
+
+       clear_sta_flags(sta, WLAN_STA_PS);
+       drv_sta_notify(local, &sdata->vif, STA_NOTIFY_AWAKE, &sta->sta);
+
+       filtered = skb_queue_len(&sta->tx_filtered);
+       skb_queue_purge(&sta->tx_filtered);
+
+       buffered = skb_queue_len(&sta->ps_tx_buf);
+       skb_queue_purge(&sta->ps_tx_buf);
+
+       if (buffered) {
+               __sta_info_clear_tim_bit(bss, sta);
+               local->total_ps_buffered -= buffered;
+       }
+
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+       printk(KERN_DEBUG "%s: STA %pM aid %d purged of "
+                       "%d filtered/%d PS frames\n", sdata->dev->name,
+                       sta->sta.addr, sta->sta.aid, filtered, buffered);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+
+       spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+}
+
 static void __sta_info_unlink(struct sta_info **sta)
 {
        struct ieee80211_local *local = (*sta)->local;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ccc3adf..bd65d9c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -445,6 +445,7 @@ void sta_info_unlink(struct sta_info **sta);
 void sta_info_destroy(struct sta_info *sta);
 void sta_info_set_tim_bit(struct sta_info *sta);
 void sta_info_clear_tim_bit(struct sta_info *sta);
+void sta_info_reset_ps(struct sta_info *sta);
 
 void sta_info_init(struct ieee80211_local *local);
 int sta_info_start(struct ieee80211_local *local);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 10a1099..4d981e7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -367,7 +367,10 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
        u32 staflags;
 
-       if (unlikely(!sta || ieee80211_is_probe_resp(hdr->frame_control)))
+       if (unlikely(!sta || ieee80211_is_probe_resp(hdr->frame_control)
+                       || ieee80211_is_auth(hdr->frame_control)
+                       || ieee80211_is_assoc_resp(hdr->frame_control)
+                       || ieee80211_is_reassoc_resp(hdr->frame_control)))
                return TX_CONTINUE;
 
        staflags = get_sta_flags(sta);


