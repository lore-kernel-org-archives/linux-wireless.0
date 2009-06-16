Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZFPXqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 19:46:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MGiLs-0006jv-Cx
	for linux-wireless@vger.kernel.org; Wed, 17 Jun 2009 01:46:05 +0200
Subject: [RFT/RFC] mac80211: remove master netdev
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 01:45:34 +0200
Message-Id: <1245195935.21287.74.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the internal 'pending' queue system in place, we can simply
put packets there instead of pushing them off to the master dev,
getting rid of the master interface completely.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This requires
	http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-net-core-mc-sync-list.patch
unless you build mac80211 into the kernel.

I've hammered it with and without aggregation and it seems to
behave just fine. With aggregation I'm definitely hitting the
case where queues are stopped for mac80211-internal reasons,
and I suspect with iperf I'll also have queues stopped by the
driver. But more testing is probably necessary, especially AP
and other modes!

 include/net/mac80211.h     |    3 
 net/mac80211/debugfs.c     |    5 
 net/mac80211/ieee80211_i.h |   18 +--
 net/mac80211/iface.c       |   43 +++----
 net/mac80211/main.c        |  120 ---------------------
 net/mac80211/rate.c        |    2 
 net/mac80211/rx.c          |   16 +-
 net/mac80211/scan.c        |   19 +--
 net/mac80211/tx.c          |  254 ++++++++++++++++++---------------------------
 net/mac80211/util.c        |   35 +-----
 net/mac80211/wme.c         |    6 -
 net/mac80211/wme.h         |    3 
 12 files changed, 171 insertions(+), 353 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-06-17 01:43:32.000000000 +0200
@@ -592,10 +592,6 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 };
 
-struct ieee80211_master_priv {
-	struct ieee80211_local *local;
-};
-
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
@@ -608,13 +604,20 @@ struct ieee80211_local {
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
 
-	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors, cooked_mntrs;
 	/* number of interfaces with corresponding FIF_ flags */
 	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss;
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
+
+	/* protects the aggregated multicast list and filter calls */
+	spinlock_t filter_lock;
+
+	/* aggregated multicast list */
+	struct dev_addr_list *mc_list;
+	int mc_count;
+
 	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
 
 	/*
@@ -834,10 +837,6 @@ struct ieee80211_local {
 static inline struct ieee80211_sub_if_data *
 IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	BUG_ON(!local || local->mdev == dev);
-
 	return netdev_priv(dev);
 }
 
@@ -1025,7 +1024,6 @@ void ieee80211_recalc_idle(struct ieee80
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
 void ieee80211_tx_pending(unsigned long data);
-int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
--- wireless-testing.orig/net/mac80211/iface.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-06-17 01:26:37.000000000 +0200
@@ -190,10 +190,6 @@ static int ieee80211_open(struct net_dev
 			       ETH_ALEN);
 	}
 
-	if (compare_ether_addr(null_addr, local->mdev->dev_addr) == 0)
-		memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr,
-		       ETH_ALEN);
-
 	/*
 	 * Validate the MAC address for this device.
 	 */
@@ -229,9 +225,9 @@ static int ieee80211_open(struct net_dev
 		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
 			local->fif_other_bss++;
 
-		netif_addr_lock_bh(local->mdev);
+		spin_lock_bh(&local->filter_lock);
 		ieee80211_configure_filter(local);
-		netif_addr_unlock_bh(local->mdev);
+		spin_unlock_bh(&local->filter_lock);
 		break;
 	case NL80211_IFTYPE_STATION:
 		sdata->u.mgd.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
@@ -246,9 +242,9 @@ static int ieee80211_open(struct net_dev
 
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
 			local->fif_other_bss++;
-			netif_addr_lock_bh(local->mdev);
+			spin_lock_bh(&local->filter_lock);
 			ieee80211_configure_filter(local);
-			netif_addr_unlock_bh(local->mdev);
+			spin_unlock_bh(&local->filter_lock);
 
 			ieee80211_start_mesh(sdata);
 		}
@@ -282,10 +278,6 @@ static int ieee80211_open(struct net_dev
 	}
 
 	if (local->open_count == 0) {
-		res = dev_open(local->mdev);
-		WARN_ON(res);
-		if (res)
-			goto err_del_interface;
 		tasklet_enable(&local->tx_pending_tasklet);
 		tasklet_enable(&local->tasklet);
 	}
@@ -408,7 +400,14 @@ static int ieee80211_stop(struct net_dev
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_dec(&local->iff_promiscs);
 
-	dev_mc_unsync(local->mdev, dev);
+	netif_addr_lock_bh(dev);
+	spin_lock_bh(&local->filter_lock);
+	__dev_addr_unsync(&local->mc_list, &local->mc_count,
+			  &dev->mc_list, &dev->mc_count);
+	ieee80211_configure_filter(local);
+	spin_unlock_bh(&local->filter_lock);
+	netif_addr_unlock_bh(dev);
+
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
@@ -457,9 +456,9 @@ static int ieee80211_stop(struct net_dev
 		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
 			local->fif_other_bss--;
 
-		netif_addr_lock_bh(local->mdev);
+		spin_lock_bh(&local->filter_lock);
 		ieee80211_configure_filter(local);
-		netif_addr_unlock_bh(local->mdev);
+		spin_unlock_bh(&local->filter_lock);
 		break;
 	case NL80211_IFTYPE_STATION:
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
@@ -507,9 +506,9 @@ static int ieee80211_stop(struct net_dev
 			local->fif_other_bss--;
 			atomic_dec(&local->iff_allmultis);
 
-			netif_addr_lock_bh(local->mdev);
+			spin_lock_bh(&local->filter_lock);
 			ieee80211_configure_filter(local);
-			netif_addr_unlock_bh(local->mdev);
+			spin_unlock_bh(&local->filter_lock);
 
 			ieee80211_stop_mesh(sdata);
 		}
@@ -555,9 +554,6 @@ static int ieee80211_stop(struct net_dev
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
-		if (netif_running(local->mdev))
-			dev_close(local->mdev);
-
 		drv_stop(local);
 
 		ieee80211_led_radio(local, false);
@@ -604,8 +600,11 @@ static void ieee80211_set_multicast_list
 			atomic_dec(&local->iff_promiscs);
 		sdata->flags ^= IEEE80211_SDATA_PROMISC;
 	}
-
-	dev_mc_sync(local->mdev, dev);
+	spin_lock_bh(&local->filter_lock);
+	__dev_addr_sync(&local->mc_list, &local->mc_count,
+			&dev->mc_list, &dev->mc_count);
+	ieee80211_configure_filter(local);
+	spin_unlock_bh(&local->filter_lock);
 }
 
 /*
--- wireless-testing.orig/net/mac80211/main.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-06-17 01:22:18.000000000 +0200
@@ -83,75 +83,14 @@ void ieee80211_configure_filter(struct i
 	new_flags |= (1<<31);
 
 	drv_configure_filter(local, changed_flags, &new_flags,
-			     local->mdev->mc_count,
-			     local->mdev->mc_list);
+			     local->mc_count,
+			     local->mc_list);
 
 	WARN_ON(new_flags & (1<<31));
 
 	local->filter_flags = new_flags & ~(1<<31);
 }
 
-/* master interface */
-
-static int header_parse_80211(const struct sk_buff *skb, unsigned char *haddr)
-{
-	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
-	return ETH_ALEN;
-}
-
-static const struct header_ops ieee80211_header_ops = {
-	.create		= eth_header,
-	.parse		= header_parse_80211,
-	.rebuild	= eth_rebuild_header,
-	.cache		= eth_header_cache,
-	.cache_update	= eth_header_cache_update,
-};
-
-static int ieee80211_master_open(struct net_device *dev)
-{
-	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
-	struct ieee80211_local *local = mpriv->local;
-	struct ieee80211_sub_if_data *sdata;
-	int res = -EOPNOTSUPP;
-
-	/* we hold the RTNL here so can safely walk the list */
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (netif_running(sdata->dev)) {
-			res = 0;
-			break;
-		}
-	}
-
-	if (res)
-		return res;
-
-	netif_tx_start_all_queues(local->mdev);
-
-	return 0;
-}
-
-static int ieee80211_master_stop(struct net_device *dev)
-{
-	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
-	struct ieee80211_local *local = mpriv->local;
-	struct ieee80211_sub_if_data *sdata;
-
-	/* we hold the RTNL here so can safely walk the list */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		if (netif_running(sdata->dev))
-			dev_close(sdata->dev);
-
-	return 0;
-}
-
-static void ieee80211_master_set_multicast_list(struct net_device *dev)
-{
-	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
-	struct ieee80211_local *local = mpriv->local;
-
-	ieee80211_configure_filter(local);
-}
-
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
 	struct ieee80211_channel *chan, *scan_chan;
@@ -310,7 +249,6 @@ void ieee80211_tx_status_irqsafe(struct 
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int tmp;
 
-	skb->dev = local->mdev;
 	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
 	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
@@ -723,7 +661,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	mutex_init(&local->scan_mtx);
 
 	spin_lock_init(&local->key_lock);
-
+	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
@@ -759,30 +697,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
 
-static const struct net_device_ops ieee80211_master_ops = {
-	.ndo_start_xmit = ieee80211_master_start_xmit,
-	.ndo_open = ieee80211_master_open,
-	.ndo_stop = ieee80211_master_stop,
-	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
-	.ndo_select_queue = ieee80211_select_queue,
-};
-
-static void ieee80211_master_setup(struct net_device *mdev)
-{
-	mdev->type = ARPHRD_IEEE80211;
-	mdev->netdev_ops = &ieee80211_master_ops;
-	mdev->header_ops = &ieee80211_header_ops;
-	mdev->tx_queue_len = 1000;
-	mdev->addr_len = ETH_ALEN;
-}
-
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	int result;
 	enum ieee80211_band band;
-	struct net_device *mdev;
-	struct ieee80211_master_priv *mpriv;
 	int channels, i, j, max_bitrates;
 	bool supp_ht;
 	static const u32 cipher_suites[] = {
@@ -881,16 +800,6 @@ int ieee80211_register_hw(struct ieee802
 	if (hw->queues > IEEE80211_MAX_QUEUES)
 		hw->queues = IEEE80211_MAX_QUEUES;
 
-	mdev = alloc_netdev_mq(sizeof(struct ieee80211_master_priv),
-			       "wmaster%d", ieee80211_master_setup,
-			       hw->queues);
-	if (!mdev)
-		goto fail_mdev_alloc;
-
-	mpriv = netdev_priv(mdev);
-	mpriv->local = local;
-	local->mdev = mdev;
-
 	local->hw.workqueue =
 		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
 	if (!local->hw.workqueue) {
@@ -925,17 +834,6 @@ int ieee80211_register_hw(struct ieee802
 	}
 
 	rtnl_lock();
-	result = dev_alloc_name(local->mdev, local->mdev->name);
-	if (result < 0)
-		goto fail_dev;
-
-	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
-	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
-	local->mdev->features |= NETIF_F_NETNS_LOCAL;
-
-	result = register_netdevice(local->mdev);
-	if (result < 0)
-		goto fail_dev;
 
 	result = ieee80211_init_rate_ctrl_alg(local,
 					      hw->rate_control_algorithm);
@@ -988,9 +886,6 @@ int ieee80211_register_hw(struct ieee802
 	ieee80211_led_exit(local);
 	ieee80211_remove_interfaces(local);
  fail_rate:
-	unregister_netdevice(local->mdev);
-	local->mdev = NULL;
- fail_dev:
 	rtnl_unlock();
 	ieee80211_wep_free(local);
  fail_wep:
@@ -999,9 +894,6 @@ int ieee80211_register_hw(struct ieee802
 	debugfs_hw_del(local);
 	destroy_workqueue(local->hw.workqueue);
  fail_workqueue:
-	if (local->mdev)
-		free_netdev(local->mdev);
- fail_mdev_alloc:
 	wiphy_unregister(local->hw.wiphy);
  fail_wiphy_register:
 	kfree(local->int_scan_req.channels);
@@ -1026,13 +918,8 @@ void ieee80211_unregister_hw(struct ieee
 	 * because the driver cannot be handing us frames any
 	 * more and the tasklet is killed.
 	 */
-
-	/* First, we remove all virtual interfaces. */
 	ieee80211_remove_interfaces(local);
 
-	/* then, finally, remove the master interface */
-	unregister_netdevice(local->mdev);
-
 	rtnl_unlock();
 
 	ieee80211_clear_tx_pending(local);
@@ -1051,7 +938,6 @@ void ieee80211_unregister_hw(struct ieee
 	wiphy_unregister(local->hw.wiphy);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
-	free_netdev(local->mdev);
 	kfree(local->int_scan_req.channels);
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
--- wireless-testing.orig/net/mac80211/scan.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-06-17 01:22:18.000000000 +0200
@@ -307,16 +307,13 @@ void ieee80211_scan_completed(struct iee
 	if (was_hw_scan)
 		goto done;
 
-	netif_tx_lock_bh(local->mdev);
-	netif_addr_lock(local->mdev);
+	spin_lock_bh(&local->filter_lock);
 	local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
 	drv_configure_filter(local, FIF_BCN_PRBRESP_PROMISC,
 			     &local->filter_flags,
-			     local->mdev->mc_count,
-			     local->mdev->mc_list);
-
-	netif_addr_unlock(local->mdev);
-	netif_tx_unlock_bh(local->mdev);
+			     local->mc_count,
+			     local->mc_list);
+	spin_unlock_bh(&local->filter_lock);
 
 	drv_sw_scan_complete(local);
 
@@ -395,13 +392,13 @@ static int ieee80211_start_sw_scan(struc
 	local->scan_state = SCAN_SET_CHANNEL;
 	local->scan_channel_idx = 0;
 
-	netif_addr_lock_bh(local->mdev);
+	spin_lock_bh(&local->filter_lock);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
 	drv_configure_filter(local, FIF_BCN_PRBRESP_PROMISC,
 			     &local->filter_flags,
-			     local->mdev->mc_count,
-			     local->mdev->mc_list);
-	netif_addr_unlock_bh(local->mdev);
+			     local->mc_count,
+			     local->mc_list);
+	spin_unlock_bh(&local->filter_lock);
 
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,
--- wireless-testing.orig/include/net/mac80211.h	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-06-17 01:22:18.000000000 +0200
@@ -241,6 +241,8 @@ struct ieee80211_bss_conf {
  *	it can be sent out.
  * @IEEE80211_TX_INTFL_RETRIED: completely internal to mac80211,
  *	used to indicate that a frame was already retried due to PS
+ * @IEEE80211_TX_INTFL_DONT_ENCRYPT: completely internal to mac80211,
+ *	used to indicate frame should not be encrypted
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -259,6 +261,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_RCALGO		= BIT(13),
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
+	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/rate.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/rate.c	2009-06-17 01:22:18.000000000 +0200
@@ -258,7 +258,7 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	struct rate_control_ref *ref, *old;
 
 	ASSERT_RTNL();
-	if (local->open_count || netif_running(local->mdev))
+	if (local->open_count)
 		return -EBUSY;
 
 	ref = rate_control_alloc(name, local);
--- wireless-testing.orig/net/mac80211/rx.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-06-17 01:22:18.000000000 +0200
@@ -1487,6 +1487,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	struct ieee80211s_hdr *mesh_hdr;
 	unsigned int hdrlen;
 	struct sk_buff *skb = rx->skb, *fwd_skb;
+	struct ieee80211_local *local = rx->local;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -1529,6 +1530,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 						     dropped_frames_ttl);
 		else {
 			struct ieee80211_hdr *fwd_hdr;
+			struct ieee80211_tx_info *info;
+
 			fwd_skb = skb_copy(skb, GFP_ATOMIC);
 
 			if (!fwd_skb && net_ratelimit())
@@ -1542,9 +1545,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 			 */
 			memcpy(fwd_hdr->addr1, fwd_hdr->addr2, ETH_ALEN);
 			memcpy(fwd_hdr->addr2, rx->dev->dev_addr, ETH_ALEN);
-			fwd_skb->dev = rx->local->mdev;
+			info = IEEE80211_SKB_CB(fwd_skb);
+			memset(info, 0, sizeof(*info));
+			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			fwd_skb->iif = rx->dev->ifindex;
-			dev_queue_xmit(fwd_skb);
+			ieee80211_select_queue(local, fwd_skb);
+			ieee80211_add_pending_skb(local, fwd_skb);
 		}
 	}
 
@@ -1828,8 +1834,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	return RX_DROP_MONITOR;
 }
 
-static void ieee80211_rx_michael_mic_report(struct net_device *dev,
-					    struct ieee80211_hdr *hdr,
+static void ieee80211_rx_michael_mic_report(struct ieee80211_hdr *hdr,
 					    struct ieee80211_rx_data *rx)
 {
 	int keyidx;
@@ -2143,7 +2148,7 @@ static void __ieee80211_rx_handle_packet
 	}
 
 	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
-		ieee80211_rx_michael_mic_report(local->mdev, hdr, &rx);
+		ieee80211_rx_michael_mic_report(hdr, &rx);
 		return;
 	}
 
@@ -2516,7 +2521,6 @@ void ieee80211_rx_irqsafe(struct ieee802
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
 
-	skb->dev = local->mdev;
 	/* copy status into skb->cb for use by tasklet */
 	memcpy(skb->cb, status, sizeof(*status));
 	skb->pkt_type = IEEE80211_RX_MSG;
--- wireless-testing.orig/net/mac80211/tx.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-06-17 01:22:18.000000000 +0200
@@ -451,7 +451,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (unlikely(tx->skb->do_not_encrypt))
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
 		tx->key = NULL;
 	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
 		tx->key = key;
@@ -497,7 +497,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	}
 
 	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		tx->skb->do_not_encrypt = 1;
+		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
 	return TX_CONTINUE;
 }
@@ -754,9 +754,7 @@ static int ieee80211_fragment(struct iee
 		memcpy(tmp->cb, skb->cb, sizeof(tmp->cb));
 		skb_copy_queue_mapping(tmp, skb);
 		tmp->priority = skb->priority;
-		tmp->do_not_encrypt = skb->do_not_encrypt;
 		tmp->dev = skb->dev;
-		tmp->iif = skb->iif;
 
 		/* copy header and data */
 		memcpy(skb_put(tmp, hdrlen), skb->data, hdrlen);
@@ -784,7 +782,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 
 	/*
 	 * Warn when submitting a fragmented A-MPDU frame and drop it.
-	 * This scenario is handled in __ieee80211_tx_prepare but extra
+	 * This scenario is handled in ieee80211_tx_prepare but extra
 	 * caution taken here as fragmented ampdu may cause Tx stop.
 	 */
 	if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
@@ -923,11 +921,12 @@ static bool __ieee80211_parse_tx_radiota
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
-	skb->do_not_encrypt = 1;
+	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
 	/*
@@ -965,7 +964,7 @@ static bool __ieee80211_parse_tx_radiota
 				skb_trim(skb, skb->len - FCS_LEN);
 			}
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
-				tx->skb->do_not_encrypt = 0;
+				info->flags &= ~IEEE80211_TX_INTFL_DONT_ENCRYPT;
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
@@ -998,13 +997,12 @@ static bool __ieee80211_parse_tx_radiota
  * initialises @tx
  */
 static ieee80211_tx_result
-__ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
-		       struct sk_buff *skb,
-		       struct net_device *dev)
+ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
+		     struct ieee80211_tx_data *tx,
+		     struct sk_buff *skb)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, tid;
 	u8 *qc, *state;
@@ -1012,9 +1010,9 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 	memset(tx, 0, sizeof(*tx));
 	tx->skb = skb;
-	tx->dev = dev; /* use original interface */
+	tx->dev = sdata->dev; /* use original interface */
 	tx->local = local;
-	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	tx->sdata = sdata;
 	tx->channel = local->hw.conf.channel;
 	/*
 	 * Set this flag (used below to indicate "automatic fragmentation"),
@@ -1023,7 +1021,6 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->flags |= IEEE80211_TX_FRAGMENTED;
 
 	/* process and remove the injection radiotap header */
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED)) {
 		if (!__ieee80211_parse_tx_radiotap(tx, skb))
 			return TX_DROP;
@@ -1119,50 +1116,25 @@ __ieee80211_tx_prepare(struct ieee80211_
 	return TX_CONTINUE;
 }
 
-/*
- * NB: @tx is uninitialised when passed in here
- */
-static int ieee80211_tx_prepare(struct ieee80211_local *local,
-				struct ieee80211_tx_data *tx,
-				struct sk_buff *skb)
-{
-	struct net_device *dev;
-
-	dev = dev_get_by_index(&init_net, skb->iif);
-	if (unlikely(dev && !is_ieee80211_device(local, dev))) {
-		dev_put(dev);
-		dev = NULL;
-	}
-	if (unlikely(!dev))
-		return -ENODEV;
-	/*
-	 * initialises tx with control
-	 *
-	 * return value is safe to ignore here because this function
-	 * can only be invoked for multicast frames
-	 *
-	 * XXX: clean up
-	 */
-	__ieee80211_tx_prepare(tx, skb, dev);
-	dev_put(dev);
-	return 0;
-}
-
 static int __ieee80211_tx(struct ieee80211_local *local,
 			  struct sk_buff **skbp,
 			  struct sta_info *sta)
 {
 	struct sk_buff *skb = *skbp, *next;
 	struct ieee80211_tx_info *info;
+	unsigned long flags;
 	int ret, len;
 	bool fragm = false;
 
-	local->mdev->trans_start = jiffies;
-
 	while (skb) {
-		if (ieee80211_queue_stopped(&local->hw,
-					    skb_get_queue_mapping(skb)))
-			return IEEE80211_TX_PENDING;
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		ret = IEEE80211_TX_OK;
+		if ((local->queue_stop_reasons[skb_get_queue_mapping(skb)] &
+				~BIT(IEEE80211_QUEUE_STOP_REASON_PENDING)))
+			ret = IEEE80211_TX_PENDING;
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+		if (ret != IEEE80211_TX_OK)
+			return ret;
 
 		info = IEEE80211_SKB_CB(skb);
 
@@ -1234,10 +1206,10 @@ static int invoke_tx_handlers(struct iee
 	return 0;
 }
 
-static void ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
-			 bool txpending)
+static void ieee80211_tx(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1248,8 +1220,6 @@ static void ieee80211_tx(struct net_devi
 
 	queue = skb_get_queue_mapping(skb);
 
-	WARN_ON(!txpending && !skb_queue_empty(&local->pending[queue]));
-
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
 		return;
@@ -1258,7 +1228,7 @@ static void ieee80211_tx(struct net_devi
 	rcu_read_lock();
 
 	/* initialises tx */
-	res_prepare = __ieee80211_tx_prepare(&tx, skb, dev);
+	res_prepare = ieee80211_tx_prepare(sdata, &tx, skb);
 
 	if (unlikely(res_prepare == TX_DROP)) {
 		dev_kfree_skb(skb);
@@ -1295,22 +1265,22 @@ static void ieee80211_tx(struct net_devi
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
-		if (__netif_subqueue_stopped(local->mdev, queue)) {
+		if ((local->queue_stop_reasons[queue] &
+				~BIT(IEEE80211_QUEUE_STOP_REASON_PENDING))) {
+			/*
+			 * if queue is stopped, queue up frames for later
+			 * transmission from the tasklet
+			 */
 			do {
 				next = skb->next;
 				skb->next = NULL;
-				if (unlikely(txpending))
-					skb_queue_head(&local->pending[queue],
-						       skb);
-				else
-					skb_queue_tail(&local->pending[queue],
-						       skb);
+				skb_queue_head(&local->pending[queue],
+					       skb);
 			} while ((skb = next));
 
 			/*
 			 * Make sure nobody will enable the queue on us
-			 * (without going through the tasklet) nor disable the
-			 * netdev queue underneath the pending handling code.
+			 * (without going through the tasklet)
 			 */
 			__set_bit(IEEE80211_QUEUE_STOP_REASON_PENDING,
 				  &local->queue_stop_reasons[queue]);
@@ -1318,11 +1288,15 @@ static void ieee80211_tx(struct net_devi
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 					       flags);
 		} else {
+			/*
+			 * otherwise retry, but this is a race condition or
+			 * a driver bug (which we warn about if it persists)
+			 */
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 					       flags);
 
 			retries++;
-			if (WARN(retries > 10, "tx refused but queue active"))
+			if (WARN(retries > 10, "tx refused but queue active\n"))
 				goto drop;
 			goto retry;
 		}
@@ -1383,14 +1357,13 @@ static int ieee80211_skb_resize(struct i
 	return 0;
 }
 
-int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
+			   struct sk_buff *skb)
 {
-	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
-	struct ieee80211_local *local = mpriv->local;
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct net_device *odev = NULL;
-	struct ieee80211_sub_if_data *osdata;
+	struct ieee80211_sub_if_data *tmp_sdata;
 	int headroom;
 	bool may_encrypt;
 	enum {
@@ -1399,20 +1372,7 @@ int ieee80211_master_start_xmit(struct s
 		UNKNOWN_ADDRESS,
 	} monitor_iface = NOT_MONITOR;
 
-	if (skb->iif)
-		odev = dev_get_by_index(&init_net, skb->iif);
-	if (unlikely(odev && !is_ieee80211_device(local, odev))) {
-		dev_put(odev);
-		odev = NULL;
-	}
-	if (unlikely(!odev)) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		printk(KERN_DEBUG "%s: Discarded packet with nonexistent "
-		       "originating device\n", dev->name);
-#endif
-		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
+	dev_hold(sdata->dev);
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    local->hw.conf.dynamic_ps_timeout > 0 &&
@@ -1428,26 +1388,21 @@ int ieee80211_master_start_xmit(struct s
 		        msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
-	memset(info, 0, sizeof(*info));
-
 	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-	osdata = IEEE80211_DEV_TO_SUB_IF(odev);
-
-	if (ieee80211_vif_is_mesh(&osdata->vif) &&
+	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    ieee80211_is_data(hdr->frame_control)) {
 		if (is_multicast_ether_addr(hdr->addr3))
 			memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
 		else
-			if (mesh_nexthop_lookup(skb, osdata)) {
-				dev_put(odev);
-				return NETDEV_TX_OK;
+			if (mesh_nexthop_lookup(skb, sdata)) {
+				dev_put(sdata->dev);
+				return;
 			}
-		if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
-			IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
-							    fwded_frames);
-	} else if (unlikely(osdata->vif.type == NL80211_IFTYPE_MONITOR)) {
-		struct ieee80211_sub_if_data *sdata;
+		if (memcmp(sdata->dev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
+			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+						     fwded_frames);
+	} else if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
 		int hdrlen;
 		u16 len_rthdr;
 
@@ -1471,19 +1426,17 @@ int ieee80211_master_start_xmit(struct s
 			 */
 
 			rcu_read_lock();
-			list_for_each_entry_rcu(sdata, &local->interfaces,
+			list_for_each_entry_rcu(tmp_sdata, &local->interfaces,
 						list) {
-				if (!netif_running(sdata->dev))
+				if (!netif_running(tmp_sdata->dev))
 					continue;
-				if (sdata->vif.type != NL80211_IFTYPE_AP)
+				if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
 					continue;
-				if (compare_ether_addr(sdata->dev->dev_addr,
+				if (compare_ether_addr(tmp_sdata->dev->dev_addr,
 						       hdr->addr2)) {
-					dev_hold(sdata->dev);
-					dev_put(odev);
-					osdata = sdata;
-					odev = osdata->dev;
-					skb->iif = sdata->dev->ifindex;
+					dev_hold(tmp_sdata->dev);
+					dev_put(sdata->dev);
+					sdata = tmp_sdata;
 					monitor_iface = FOUND_SDATA;
 					break;
 				}
@@ -1492,31 +1445,31 @@ int ieee80211_master_start_xmit(struct s
 		}
 	}
 
-	may_encrypt = !skb->do_not_encrypt;
+	may_encrypt = !(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT);
 
-	headroom = osdata->local->tx_headroom;
+	headroom = local->tx_headroom;
 	if (may_encrypt)
 		headroom += IEEE80211_ENCRYPT_HEADROOM;
 	headroom -= skb_headroom(skb);
 	headroom = max_t(int, 0, headroom);
 
-	if (ieee80211_skb_resize(osdata->local, skb, headroom, may_encrypt)) {
+	if (ieee80211_skb_resize(local, skb, headroom, may_encrypt)) {
 		dev_kfree_skb(skb);
-		dev_put(odev);
-		return NETDEV_TX_OK;
+		dev_put(sdata->dev);
+		return;
 	}
 
-	if (osdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		osdata = container_of(osdata->bss,
-				      struct ieee80211_sub_if_data,
-				      u.ap);
+	tmp_sdata = sdata;
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		tmp_sdata = container_of(sdata->bss,
+					 struct ieee80211_sub_if_data,
+					 u.ap);
 	if (likely(monitor_iface != UNKNOWN_ADDRESS))
-		info->control.vif = &osdata->vif;
-
-	ieee80211_tx(odev, skb, false);
-	dev_put(odev);
+		info->control.vif = &tmp_sdata->vif;
 
-	return NETDEV_TX_OK;
+	ieee80211_select_queue(local, skb);
+	ieee80211_tx(sdata, skb);
+	dev_put(sdata->dev);
 }
 
 int ieee80211_monitor_start_xmit(struct sk_buff *skb,
@@ -1526,6 +1479,7 @@ int ieee80211_monitor_start_xmit(struct 
 	struct ieee80211_channel *chan = local->hw.conf.channel;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u16 len_rthdr;
 
 	/*
@@ -1563,15 +1517,9 @@ int ieee80211_monitor_start_xmit(struct 
 	if (unlikely(skb->len < len_rthdr))
 		goto fail; /* skb too short for claimed rt header extent */
 
-	skb->dev = local->mdev;
-
 	/* needed because we set skb device to master */
 	skb->iif = dev->ifindex;
 
-	/* sometimes we do encrypt injected frames, will be fixed
-	 * up in radiotap parser if not wanted */
-	skb->do_not_encrypt = 0;
-
 	/*
 	 * fix up the pointers accounting for the radiotap
 	 * header still being in there.  We are being given
@@ -1586,8 +1534,10 @@ int ieee80211_monitor_start_xmit(struct 
 	skb_set_network_header(skb, len_rthdr);
 	skb_set_transport_header(skb, len_rthdr);
 
-	/* pass the radiotap header up to the next stage intact */
-	dev_queue_xmit(skb);
+	memset(info, 0, sizeof(*info));
+
+	/* pass the radiotap header up to xmit */
+	ieee80211_xmit(IEEE80211_DEV_TO_SUB_IF(dev), skb);
 	return NETDEV_TX_OK;
 
 fail:
@@ -1615,6 +1565,7 @@ int ieee80211_subif_start_xmit(struct sk
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = 1, head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
@@ -1844,7 +1795,6 @@ int ieee80211_subif_start_xmit(struct sk
 
 	skb->iif = dev->ifindex;
 
-	skb->dev = local->mdev;
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
@@ -1855,10 +1805,12 @@ int ieee80211_subif_start_xmit(struct sk
 	skb_set_network_header(skb, nh_pos);
 	skb_set_transport_header(skb, h_pos);
 
+	memset(info, 0, sizeof(*info));
+
 	dev->trans_start = jiffies;
-	dev_queue_xmit(skb);
+	ieee80211_xmit(sdata, skb);
 
-	return 0;
+	return NETDEV_TX_OK;
 
  fail:
 	if (!ret)
@@ -1898,7 +1850,6 @@ static bool ieee80211_tx_pending_skb(str
 		return true;
 	}
 
-	/* validate info->control.vif against skb->iif */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
@@ -1912,7 +1863,8 @@ static bool ieee80211_tx_pending_skb(str
 	}
 
 	if (info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING) {
-		ieee80211_tx(dev, skb, true);
+		/* do not use sdata, it may have been changed above */
+		ieee80211_tx(IEEE80211_DEV_TO_SUB_IF(dev), skb);
 	} else {
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(local, hdr->addr1);
@@ -1929,19 +1881,16 @@ static bool ieee80211_tx_pending_skb(str
 }
 
 /*
- * Transmit all pending packets. Called from tasklet, locks master device
- * TX lock so that no new packets can come in.
+ * Transmit all pending packets. Called from tasklet.
  */
 void ieee80211_tx_pending(unsigned long data)
 {
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
-	struct net_device *dev = local->mdev;
 	unsigned long flags;
 	int i;
 	bool next;
 
 	rcu_read_lock();
-	netif_tx_lock_bh(dev);
 
 	for (i = 0; i < local->hw.queues; i++) {
 		/*
@@ -1959,13 +1908,6 @@ void ieee80211_tx_pending(unsigned long 
 		if (next)
 			continue;
 
-		/*
-		 * start the queue now to allow processing our packets,
-		 * we're under the tx lock here anyway so nothing will
-		 * happen as a result of this
-		 */
-		netif_start_subqueue(local->mdev, i);
-
 		while (!skb_queue_empty(&local->pending[i])) {
 			struct sk_buff *skb = skb_dequeue(&local->pending[i]);
 
@@ -1981,7 +1923,6 @@ void ieee80211_tx_pending(unsigned long 
 					IEEE80211_QUEUE_STOP_REASON_PENDING);
 	}
 
-	netif_tx_unlock_bh(dev);
 	rcu_read_unlock();
 }
 
@@ -2156,8 +2097,7 @@ struct sk_buff *ieee80211_beacon_get(str
 
 	info = IEEE80211_SKB_CB(skb);
 
-	skb->do_not_encrypt = 1;
-
+	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	info->band = band;
 	/*
 	 * XXX: For now, always use the lowest rate
@@ -2228,9 +2168,6 @@ ieee80211_get_buffered_bc(struct ieee802
 	sdata = vif_to_sdata(vif);
 	bss = &sdata->u.ap;
 
-	if (!bss)
-		return NULL;
-
 	rcu_read_lock();
 	beacon = rcu_dereference(bss->beacon);
 
@@ -2256,7 +2193,7 @@ ieee80211_get_buffered_bc(struct ieee802
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (!ieee80211_tx_prepare(local, &tx, skb))
+		if (!ieee80211_tx_prepare(sdata, &tx, skb))
 			break;
 		dev_kfree_skb_any(skb);
 	}
@@ -2276,3 +2213,18 @@ ieee80211_get_buffered_bc(struct ieee802
 	return skb;
 }
 EXPORT_SYMBOL(ieee80211_get_buffered_bc);
+
+void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		      int encrypt)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	skb_set_mac_header(skb, 0);
+	skb_set_network_header(skb, 0);
+	skb_set_transport_header(skb, 0);
+
+	skb->iif = sdata->dev->ifindex;
+	if (!encrypt)
+		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+	ieee80211_xmit(sdata, skb);
+}
--- wireless-testing.orig/net/mac80211/util.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-06-17 01:22:18.000000000 +0200
@@ -282,8 +282,6 @@ static void __ieee80211_wake_queue(struc
 	if (local->queue_stop_reasons[queue] != 0)
 		/* someone still has this queue stopped */
 		return;
-
-	netif_wake_subqueue(local->mdev, queue);
 }
 
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
@@ -312,14 +310,6 @@ static void __ieee80211_stop_queue(struc
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
-	/*
-	 * Only stop if it was previously running, this is necessary
-	 * for correct pending packets handling because there we may
-	 * start (but not wake) the queue and rely on that.
-	 */
-	if (!local->queue_stop_reasons[queue])
-		netif_stop_subqueue(local->mdev, queue);
-
 	__set_bit(reason, &local->queue_stop_reasons[queue]);
 }
 
@@ -412,11 +402,16 @@ EXPORT_SYMBOL(ieee80211_stop_queues);
 int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
+	int ret;
 
 	if (WARN_ON(queue >= hw->queues))
 		return true;
 
-	return __netif_subqueue_stopped(local->mdev, queue);
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	ret = !!local->queue_stop_reasons[queue];
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL(ieee80211_queue_stopped);
 
@@ -760,20 +755,6 @@ void ieee80211_sta_def_wmm_params(struct
 	ieee80211_set_wmm_default(sdata);
 }
 
-void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		      int encrypt)
-{
-	skb->dev = sdata->local->mdev;
-	skb_set_mac_header(skb, 0);
-	skb_set_network_header(skb, 0);
-	skb_set_transport_header(skb, 0);
-
-	skb->iif = sdata->dev->ifindex;
-	skb->do_not_encrypt = !encrypt;
-
-	dev_queue_xmit(skb);
-}
-
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band)
 {
@@ -1043,9 +1024,9 @@ int ieee80211_reconfig(struct ieee80211_
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
-	netif_addr_lock_bh(local->mdev);
+	spin_lock_bh(&local->filter_lock);
 	ieee80211_configure_filter(local);
-	netif_addr_unlock_bh(local->mdev);
+	spin_unlock_bh(&local->filter_lock);
 
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
--- wireless-testing.orig/net/mac80211/wme.c	2009-06-17 01:21:11.000000000 +0200
+++ wireless-testing/net/mac80211/wme.c	2009-06-17 01:22:18.000000000 +0200
@@ -85,10 +85,8 @@ static u16 classify80211(struct ieee8021
 	return ieee802_1d_to_ac[skb->priority];
 }
 
-u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
+void ieee80211_select_queue(struct ieee80211_local *local, struct sk_buff *skb)
 {
-	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
-	struct ieee80211_local *local = mpriv->local;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 queue;
 	u8 tid;
@@ -113,5 +111,5 @@ u16 ieee80211_select_queue(struct net_de
 		*p = 0;
 	}
 
-	return queue;
+	skb_set_queue_mapping(skb, queue);
 }
--- wireless-testing.orig/net/mac80211/wme.h	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/wme.h	2009-06-17 01:22:18.000000000 +0200
@@ -20,6 +20,7 @@
 
 extern const int ieee802_1d_to_ac[8];
 
-u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb);
+void ieee80211_select_queue(struct ieee80211_local *local,
+			    struct sk_buff *skb);
 
 #endif /* _WME_H */
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-06-17 01:21:12.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs.c	2009-06-17 01:22:18.000000000 +0200
@@ -173,9 +173,8 @@ static ssize_t queues_read(struct file *
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (q = 0; q < local->hw.queues; q++)
-		res += sprintf(buf + res, "%02d: %#.8lx/%d\n", q,
-				local->queue_stop_reasons[q],
-				__netif_subqueue_stopped(local->mdev, q));
+		res += sprintf(buf + res, "%02d: %#.8lx\n", q,
+				local->queue_stop_reasons[q]);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, res);


