Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:25316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZERTHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 15:07:50 -0400
Received: by fg-out-1718.google.com with SMTP id d23so690976fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 12:07:49 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Plan of attack for enhancements for scan while associated
Date: Mon, 18 May 2009 21:07:52 +0200
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com, Gaurav.Jauhar@atheros.com
References: <43e72e890905181122w38f83785p2134a5142a9f0905@mail.gmail.com>
In-Reply-To: <43e72e890905181122w38f83785p2134a5142a9f0905@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905182107.52613.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 18. Mai 2009 schrieb Luis R. Rodriguez:
> Helmut, Senthil has indicated interest in working on this, Johannes
> had pointed out you might have some initial work on this already? Can
> you post your patch, it might help?

Sure, see below. However, the patch was against mac80211 in February or
so and due to the recent changes in the scan code it won't apply anymore :)

> Just so we're clear this would be an enhancement for wext/nl80211
> regular scan -- when we're associated we'd do scans by going to a new
> channel and then coming back to our operating channel to able to
> receive frames. We'd do this for each channel we can scan on until
> we're done with all of them.

Yep, that's the idea.

> We could possibly allow for a debugfs parameters to allow users to
> tune this to say scan over x channels before going to the operating
> channel, as well as change the time between moving to a new channel.
> This would probably help mostly with tuning this while debugging or
> figuring out ideal default values.

Agreed.

Helmut


---

The patch basically enhances the scanning state machine by two further
states (SCAN_SET_OPER_CHANNEL & SCAN_OPERATION). In state SCAN_SET_OPER_CHANNEL
the driver is advised to switch back to the operating channel while
SCAN_OPERATION tells the access point about being back from power saving and
restarts the tx queue. Just before SCAN_SET_CHANNEL sets the next channel to
scan it notifies the access point about going to power save state and stops
the tx queue.

It does not add any periodic scan behavior, it only reduces the impact of a
scan onto the traffic (multiple short interruptions instead of one long)
which results in a smoother user experience.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3912fba..21c623d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -646,11 +647,11 @@ struct ieee80211_local {
 
 
        /* Scanning and BSS list */
-       bool sw_scanning, hw_scanning;
+       bool sw_scanning, hw_scanning, bg_scanning;
        int scan_channel_idx;
        enum ieee80211_band scan_band;
 
-       enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
+       enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE, SCAN_SET_OPER_CHANNEL, SCAN_OPERATION } scan_state;
        unsigned long last_scan_completed;
        struct delayed_work scan_work;
        struct ieee80211_sub_if_data *scan_sdata;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 92d898b..49b5c29 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -414,7 +414,7 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
                return RX_QUEUED;
        }
 
-       if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN)) {
+       if (unlikely((rx->flags & IEEE80211_RX_IN_SCAN) && !local->bg_scanning)) {
                /* scanning finished during invoking of handlers */
                I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
                return RX_DROP_UNUSABLE;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8e6685e..9120e6b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -29,6 +29,7 @@
 #define IEEE80211_PROBE_DELAY (HZ / 33)
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
+#define IEEE80211_BG_SCAN_INTERRUPT (HZ / 4)
 
 void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
 {
@@ -455,6 +456,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
        }
 
        local->sw_scanning = false;
+       local->bg_scanning = false;
        if (ieee80211_hw_config(local))
                printk(KERN_DEBUG "%s: failed to restore operational "
                       "channel after scan\n", wiphy_name(local->hw.wiphy));
@@ -510,6 +512,36 @@ void ieee80211_scan_work(struct work_struct *work)
 
        switch (local->scan_state) {
        case SCAN_SET_CHANNEL:
+               if (local->bg_scanning) {
+                       /*
+                        * background scan is in progress, notify all associated 
+                        * access points about us leaving the channel and
+                        * update the filter flags
+                        */
+                       local->sw_scanning = 1;
+
+                       rcu_read_lock();
+                       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+                               if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+                                   (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)) {
+                                       ieee80211_send_nullfunc(local, sdata, 1);
+                                       /* TODO: wait until all nullfunc frames are ACKed */
+                                       msleep(1);
+                                       netif_tx_stop_all_queues(sdata->dev);
+                               }
+                       }
+                       rcu_read_unlock();
+
+                       netif_tx_lock_bh(local->mdev);
+                       local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
+                       local->ops->configure_filter(local_to_hw(local),
+                                                    FIF_BCN_PRBRESP_PROMISC,
+                                                    &local->filter_flags,
+                                                    local->mdev->mc_count,
+                                                    local->mdev->mc_list);
+                       netif_tx_unlock_bh(local->mdev);
+               }
+
                /*
                 * Get current scan band. scan_band may be IEEE80211_NUM_BANDS
                 * after we successfully scanned the last channel of the last
@@ -574,7 +606,10 @@ void ieee80211_scan_work(struct work_struct *work)
                break;
        case SCAN_SEND_PROBE:
                next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-               local->scan_state = SCAN_SET_CHANNEL;
+               if (!local->bg_scanning)
+                       local->scan_state = SCAN_SET_CHANNEL;
+               else
+                       local->scan_state = SCAN_SET_OPER_CHANNEL;
 
                if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN)
                        break;
@@ -582,6 +617,49 @@ void ieee80211_scan_work(struct work_struct *work)
                                         local->scan_ssid_len);
                next_delay = IEEE80211_CHANNEL_TIME;
                break;
+       case SCAN_SET_OPER_CHANNEL:
+               local->scan_state = SCAN_OPERATION;
+               /* interrupt the current scan */
+               local->sw_scanning = 0;
+
+               /* switch back to the operating channel */
+               if (ieee80211_hw_config(local))
+                       printk(KERN_DEBUG "%s: failed to restore operational "
+                              "channel after scan\n", sdata->dev->name);
+
+               /* reconfigure filter flags*/
+               netif_tx_lock_bh(local->mdev);
+               local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
+               local->ops->configure_filter(local_to_hw(local),
+                                            FIF_BCN_PRBRESP_PROMISC,
+                                            &local->filter_flags,
+                                            local->mdev->mc_count,
+                                            local->mdev->mc_list);
+
+               netif_tx_unlock_bh(local->mdev);
+
+               /* wait for the channel switch */
+               next_delay = usecs_to_jiffies(local->hw.channel_change_time);
+               break;
+
+       case SCAN_OPERATION:    
+               rcu_read_lock();
+               list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+                       /* Tell AP we're back */
+                       if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+                           sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+                               ieee80211_send_nullfunc(local, sdata, 0);
+                               /* TODO: wait until all nullfunc frames are ACKed */
+                               msleep(1);
+                               netif_tx_wake_all_queues(sdata->dev);
+                       }
+               }
+               rcu_read_unlock();
+
+               next_delay = IEEE80211_BG_SCAN_INTERRUPT;
+               local->scan_state = SCAN_SET_CHANNEL;
+
+               break;
        }
 
        queue_delayed_work(local->hw.workqueue, &local->scan_work,
@@ -615,7 +693,7 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
          * ResultCode: SUCCESS, INVALID_PARAMETERS
         */
 
-       if (local->sw_scanning || local->hw_scanning) {
+       if (local->sw_scanning || local->hw_scanning || local->bg_scanning) {
                if (local->scan_sdata == scan_sdata)
                        return 0;
                return -EBUSY;
@@ -636,18 +714,28 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 
        local->sw_scanning = true;
 
+       /*
+        * if at least one station interface is associated start a background scan
+        * instead of a common software scan
+        */
        rcu_read_lock();
        list_for_each_entry_rcu(sdata, &local->interfaces, list) {
                if (sdata->vif.type == NL80211_IFTYPE_STATION) {
                        if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
-                               netif_tx_stop_all_queues(sdata->dev);
-                               ieee80211_send_nullfunc(local, sdata, 1);
+                               /*
+                                * no need to stop station interaces here, that will be done in
+                                * the scan handler
+                                */
+                               local->bg_scanning = true;
                        }
                } else
                        netif_tx_stop_all_queues(sdata->dev);
        }
        rcu_read_unlock();
 
+       if (!local->bg_scanning)
+               local->sw_scanning = true;
+
        if (ssid) {
                local->scan_ssid_len = ssid_len;
                memcpy(local->scan_ssid, ssid, ssid_len);
@@ -658,14 +746,16 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
        local->scan_band = IEEE80211_BAND_2GHZ;
        local->scan_sdata = scan_sdata;
 
-       netif_addr_lock_bh(local->mdev);
-       local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
-       local->ops->configure_filter(local_to_hw(local),
-                                    FIF_BCN_PRBRESP_PROMISC,
-                                    &local->filter_flags,
-                                    local->mdev->mc_count,
-                                    local->mdev->mc_list);
-       netif_addr_unlock_bh(local->mdev);
+       if (!local->bg_scanning) {
+               netif_addr_lock_bh(local->mdev);
+               local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
+               local->ops->configure_filter(local_to_hw(local),
+                                            FIF_BCN_PRBRESP_PROMISC,
+                                            &local->filter_flags,
+                                            local->mdev->mc_count,
+                                            local->mdev->mc_list);
+               netif_addr_unlock_bh(local->mdev);
+       }
 
        /* TODO: start scan as soon as all nullfunc frames are ACKed */
        queue_delayed_work(local->hw.workqueue, &local->scan_work,
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 7e0d53a..fd7783a 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -566,7 +566,7 @@ static int ieee80211_ioctl_giwscan(struct net_device *dev,
 
        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-       if (local->sw_scanning || local->hw_scanning)
+       if (local->sw_scanning || local->hw_scanning || local->bg_scanning)
                return -EAGAIN;
 
        res = ieee80211_scan_results(local, info, extra, data->length);


