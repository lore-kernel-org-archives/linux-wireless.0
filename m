Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24621 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965266AbbA1EnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:43:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4Z1q2015630
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:09 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1s50eqxaqg-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:08 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 3/8] mwifiex: do not declare wdev as pointer
Date: Wed, 28 Jan 2015 15:42:00 +0530
Message-ID: <1422439925-25666-4-git-send-email-patila@marvell.com> (sfid-20150128_054333_814095_9626FF6C)
In-Reply-To: <1422439925-25666-1-git-send-email-patila@marvell.com>
References: <1422439925-25666-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wdev is used even after del_virtual_interface handler in cfg80211
in nl80211_post_doit. Since we have freed wdev in handling of
del_virtual_intf, this can result into crash while deleting
interface.
Avoid this be not declaring wdev which part of
mwifiex_private structure but struct wireless_dev type.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c           |  2 +-
 drivers/net/wireless/mwifiex/11n.c           |  4 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  2 +-
 drivers/net/wireless/mwifiex/cfg80211.c      | 70 ++++++++++------------------
 drivers/net/wireless/mwifiex/cfp.c           |  4 +-
 drivers/net/wireless/mwifiex/main.c          |  5 +-
 drivers/net/wireless/mwifiex/main.h          |  2 +-
 drivers/net/wireless/mwifiex/scan.c          | 10 ++--
 drivers/net/wireless/mwifiex/sta_event.c     |  2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  2 +-
 drivers/net/wireless/mwifiex/txrx.c          |  2 +-
 drivers/net/wireless/mwifiex/util.c          |  2 +-
 12 files changed, 44 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index 2668e83..f23b647a 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -39,7 +39,7 @@ mwifiex_11h_process_infra_join(struct mwifiex_private *priv, u8 **buffer,
 		return;
 
 	radio_type = mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
-	sband = priv->wdev->wiphy->bands[radio_type];
+	sband = priv->wdev.wiphy->bands[radio_type];
 
 	cap = (struct mwifiex_ie_types_pwr_capability *)*buffer;
 	cap->header.type = cpu_to_le16(WLAN_EID_PWR_CAPABILITY);
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index c5c83cf..543148d 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -39,7 +39,7 @@ int mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 {
 	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->extended_ht_cap_info);
 	struct ieee80211_supported_band *sband =
-					priv->wdev->wiphy->bands[radio_type];
+					priv->wdev.wiphy->bands[radio_type];
 
 	if (WARN_ON_ONCE(!sband)) {
 		dev_err(priv->adapter->dev, "Invalid radio type!\n");
@@ -314,7 +314,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		return ret_len;
 
 	radio_type = mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
-	sband = priv->wdev->wiphy->bands[radio_type];
+	sband = priv->wdev.wiphy->bands[radio_type];
 
 	if (bss_desc->bcn_ht_cap) {
 		ht_cap = (struct mwifiex_ie_types_htcap *) *buffer;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index c7ca5b7..a2e8817 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -45,7 +45,7 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev->iftype, 0, false);
+					 priv->wdev.iftype, 0, false);
 
 		while (!skb_queue_empty(&list)) {
 			rx_skb = __skb_dequeue(&list);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index dd0e410..9710b23 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1590,15 +1590,15 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
 
 	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
-	chan = __ieee80211_get_channel(priv->wdev->wiphy,
+	chan = __ieee80211_get_channel(priv->wdev.wiphy,
 			ieee80211_channel_to_frequency(bss_info.bss_chan,
 						       band));
 
-	bss = cfg80211_inform_bss(priv->wdev->wiphy, chan,
+	bss = cfg80211_inform_bss(priv->wdev.wiphy, chan,
 				  CFG80211_BSS_FTYPE_UNKNOWN,
 				  bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
 				  0, ie_buf, ie_len, 0, GFP_KERNEL);
-	cfg80211_put_bss(priv->wdev->wiphy, bss);
+	cfg80211_put_bss(priv->wdev.wiphy, bss);
 	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
 
 	return 0;
@@ -1719,12 +1719,12 @@ done:
 
 		/* Find the BSS we want using available scan results */
 		if (mode == NL80211_IFTYPE_ADHOC)
-			bss = cfg80211_get_bss(priv->wdev->wiphy, channel,
+			bss = cfg80211_get_bss(priv->wdev.wiphy, channel,
 					       bssid, ssid, ssid_len,
 					       WLAN_CAPABILITY_IBSS,
 					       WLAN_CAPABILITY_IBSS);
 		else
-			bss = cfg80211_get_bss(priv->wdev->wiphy, channel,
+			bss = cfg80211_get_bss(priv->wdev.wiphy, channel,
 					       bssid, ssid, ssid_len,
 					       WLAN_CAPABILITY_ESS,
 					       WLAN_CAPABILITY_ESS);
@@ -1781,7 +1781,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 
-	if (priv->wdev && priv->wdev->current_bss) {
+	if (priv->wdev.current_bss) {
 		wiphy_warn(wiphy, "%s: already connected\n", dev->name);
 		return -EALREADY;
 	}
@@ -1839,7 +1839,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 				   struct cfg80211_ibss_params *params)
 {
-	struct wiphy *wiphy = priv->wdev->wiphy;
+	struct wiphy *wiphy = priv->wdev.wiphy;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int index = 0, i;
 	u8 config_bands = 0;
@@ -2177,7 +2177,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	struct mwifiex_private *priv;
 	struct net_device *dev;
 	void *mdev_priv;
-	struct wireless_dev *wdev;
 
 	if (!adapter)
 		return ERR_PTR(-EFAULT);
@@ -2193,13 +2192,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			return ERR_PTR(-EINVAL);
 		}
 
-		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
-		if (!wdev)
-			return ERR_PTR(-ENOMEM);
-
-		wdev->wiphy = wiphy;
-		priv->wdev = wdev;
-		wdev->iftype = NL80211_IFTYPE_STATION;
+		priv->wdev.wiphy = wiphy;
+		priv->wdev.iftype = NL80211_IFTYPE_STATION;
 
 		if (type == NL80211_IFTYPE_UNSPECIFIED)
 			priv->bss_mode = NL80211_IFTYPE_STATION;
@@ -2221,13 +2215,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			return ERR_PTR(-EINVAL);
 		}
 
-		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
-		if (!wdev)
-			return ERR_PTR(-ENOMEM);
-
-		priv->wdev = wdev;
-		wdev->wiphy = wiphy;
-		wdev->iftype = NL80211_IFTYPE_AP;
+		priv->wdev.wiphy = wiphy;
+		priv->wdev.iftype = NL80211_IFTYPE_AP;
 
 		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
@@ -2246,17 +2235,12 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			return ERR_PTR(-EINVAL);
 		}
 
-		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
-		if (!wdev)
-			return ERR_PTR(-ENOMEM);
-
-		priv->wdev = wdev;
-		wdev->wiphy = wiphy;
+		priv->wdev.wiphy = wiphy;
 
 		/* At start-up, wpa_supplicant tries to change the interface
 		 * to NL80211_IFTYPE_STATION if it is not managed mode.
 		 */
-		wdev->iftype = NL80211_IFTYPE_P2P_CLIENT;
+		priv->wdev.iftype = NL80211_IFTYPE_P2P_CLIENT;
 		priv->bss_mode = NL80211_IFTYPE_P2P_CLIENT;
 
 		/* Setting bss_type to P2P tells firmware that this interface
@@ -2272,8 +2256,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_num = 0;
 
 		if (mwifiex_cfg80211_init_p2p_client(priv)) {
-			wdev = ERR_PTR(-EFAULT);
-			goto done;
+			memset(&priv->wdev, 0, sizeof(priv->wdev));
+			priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+			return ERR_PTR(-EFAULT);
 		}
 
 		break;
@@ -2287,9 +2272,10 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			       IEEE80211_NUM_ACS, 1);
 	if (!dev) {
 		wiphy_err(wiphy, "no memory available for netdevice\n");
+		memset(&priv->wdev, 0, sizeof(priv->wdev));
+		priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
-		wdev = ERR_PTR(-ENOMEM);
-		goto done;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	mwifiex_init_priv_params(priv, dev);
@@ -2309,7 +2295,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			&wiphy->bands[IEEE80211_BAND_5GHZ]->vht_cap, priv);
 
 	dev_net_set(dev, wiphy_net(wiphy));
-	dev->ieee80211_ptr = priv->wdev;
+	dev->ieee80211_ptr = &priv->wdev;
 	dev->ieee80211_ptr->iftype = priv->bss_mode;
 	memcpy(dev->dev_addr, wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(dev, wiphy_dev(wiphy));
@@ -2330,8 +2316,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		free_netdev(dev);
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 		priv->netdev = NULL;
-		wdev = ERR_PTR(-EFAULT);
-		goto done;
+		memset(&priv->wdev, 0, sizeof(priv->wdev));
+		priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-EFAULT);
 	}
 
 	sema_init(&priv->async_sem, 1);
@@ -2342,13 +2329,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mwifiex_dev_debugfs_init(priv);
 #endif
 
-done:
-	if (IS_ERR(wdev)) {
-		kfree(priv->wdev);
-		priv->wdev = NULL;
-	}
-
-	return wdev;
+	return &priv->wdev;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
 
@@ -2374,8 +2355,7 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	/* Clear the priv in adapter */
 	priv->netdev->ieee80211_ptr = NULL;
 	priv->netdev = NULL;
-	kfree(wdev);
-	priv->wdev = NULL;
+	priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
 
 	priv->media_connected = false;
 
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index f494fc7..e9df882 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -322,9 +322,9 @@ mwifiex_get_cfp(struct mwifiex_private *priv, u8 band, u16 channel, u32 freq)
 		return cfp;
 
 	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
-		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
+		sband = priv->wdev.wiphy->bands[IEEE80211_BAND_2GHZ];
 	else
-		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
+		sband = priv->wdev.wiphy->bands[IEEE80211_BAND_5GHZ];
 
 	if (!sband) {
 		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d\n",
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 99cd360..49dec6b 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -1203,8 +1203,9 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 			continue;
 
 		rtnl_lock();
-		if (priv->wdev && priv->netdev)
-			mwifiex_del_virtual_intf(adapter->wiphy, priv->wdev);
+		if (priv->netdev &&
+		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED)
+			mwifiex_del_virtual_intf(adapter->wiphy, &priv->wdev);
 		rtnl_unlock();
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 99792b8..a560179 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -547,7 +547,7 @@ struct mwifiex_private {
 	u32 curr_bcn_size;
 	/* spin lock for beacon buffer */
 	spinlock_t curr_bcn_buf_lock;
-	struct wireless_dev *wdev;
+	struct wireless_dev wdev;
 	struct mwifiex_chan_freq_power cfp;
 	char version_str[128];
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index e304f07..0ffdb7c 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -496,10 +496,10 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 
 	for (band = 0; (band < IEEE80211_NUM_BANDS) ; band++) {
 
-		if (!priv->wdev->wiphy->bands[band])
+		if (!priv->wdev.wiphy->bands[band])
 			continue;
 
-		sband = priv->wdev->wiphy->bands[band];
+		sband = priv->wdev.wiphy->bands[band];
 
 		for (i = 0; (i < sband->n_channels) ; i++) {
 			ch = &sband->channels[i];
@@ -1733,10 +1733,10 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 
 		freq = cfp ? cfp->freq : 0;
 
-		chan = ieee80211_get_channel(priv->wdev->wiphy, freq);
+		chan = ieee80211_get_channel(priv->wdev.wiphy, freq);
 
 		if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
-			bss = cfg80211_inform_bss(priv->wdev->wiphy,
+			bss = cfg80211_inform_bss(priv->wdev.wiphy,
 					    chan, CFG80211_BSS_FTYPE_UNKNOWN,
 					    bssid, timestamp,
 					    cap_info_bitmap, beacon_period,
@@ -1748,7 +1748,7 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 			    !memcmp(bssid, priv->curr_bss_params.bss_descriptor
 				    .mac_address, ETH_ALEN))
 				mwifiex_update_curr_bss_params(priv, bss);
-			cfg80211_put_bss(priv->wdev->wiphy, bss);
+			cfg80211_put_bss(priv->wdev.wiphy, bss);
 		}
 	} else {
 		dev_dbg(adapter->dev, "missing BSS channel IE\n");
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 419e35f..c37e8cb 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -487,7 +487,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_REMAIN_ON_CHAN_EXPIRED:
 		dev_dbg(adapter->dev, "event: Remain on channel expired\n");
-		cfg80211_remain_on_channel_expired(priv->wdev,
+		cfg80211_remain_on_channel_expired(&priv->wdev,
 						   priv->roc_cfg.cookie,
 						   &priv->roc_cfg.chan,
 						   GFP_ATOMIC);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fb9c5fc..329cd51 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -219,7 +219,7 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 
 	if (!strncmp(priv->adapter->country_code, &country_ie[2], 2)) {
 		rcu_read_unlock();
-		wiphy_dbg(priv->wdev->wiphy,
+		wiphy_dbg(priv->wdev.wiphy,
 			  "11D: skip setting domain info in FW\n");
 		return 0;
 	}
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 6ae1333..ac93557 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -227,7 +227,7 @@ void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 			/* consumes ack_skb */
 			skb_complete_wifi_ack(ack_skb, !tx_status->status);
 		} else {
-			cfg80211_mgmt_tx_status(priv->wdev, tx_info->cookie,
+			cfg80211_mgmt_tx_status(&priv->wdev, tx_info->cookie,
 						ack_skb->data, ack_skb->len,
 						!tx_status->status, GFP_ATOMIC);
 			dev_kfree_skb_any(ack_skb);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 70731979..3085506 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -387,7 +387,7 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 	pkt_len -= ETH_ALEN + sizeof(pkt_len);
 	rx_pd->rx_pkt_length = cpu_to_le16(pkt_len);
 
-	cfg80211_rx_mgmt(priv->wdev, priv->roc_cfg.chan.center_freq,
+	cfg80211_rx_mgmt(&priv->wdev, priv->roc_cfg.chan.center_freq,
 			 CAL_RSSI(rx_pd->snr, rx_pd->nf), skb->data, pkt_len,
 			 0);
 
-- 
1.8.1.4

