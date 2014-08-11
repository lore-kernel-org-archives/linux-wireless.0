Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43955 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaHKKbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 06:31:09 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()
Date: Mon, 11 Aug 2014 03:29:57 -0700
Message-ID: <1407752997-12382-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140811_123113_817825_B2075E32)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the cfg80211_rx_mgmt(), parameter @gfp was used for the memory allocation.
But, memory get allocated under spin_lock_bh(), this implies atomic context.
So, one can't use GFP_KERNEL, only variants with no __GFP_WAIT. Actually, in all
occurrences GFP_ATOMIC is used (wil6210 use GFP_KERNEL by mistake),
and it should be this way or warning triggered in the memory allocation code.

Remove @gfp parameter as no actual choice exist, and use hard coded
GFP_ATOMIC for memory allocation.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c             | 5 ++---
 drivers/net/wireless/ath/wil6210/wmi.c            | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c     | 6 ++----
 drivers/net/wireless/mwifiex/util.c               | 2 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 3 +--
 include/net/cfg80211.h                            | 3 +--
 net/mac80211/rx.c                                 | 2 +-
 net/wireless/mlme.c                               | 4 ++--
 8 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 4d7f9e4..eca3014 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -570,8 +570,7 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len,
 		   dlen, freq, vif->probe_req_report);
 
 	if (vif->probe_req_report || vif->nw_type == AP_NETWORK)
-		cfg80211_rx_mgmt(&vif->wdev, freq, 0, ev->data, dlen, 0,
-				 GFP_ATOMIC);
+		cfg80211_rx_mgmt(&vif->wdev, freq, 0, ev->data, dlen, 0);
 
 	return 0;
 }
@@ -610,7 +609,7 @@ static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len,
 		return -EINVAL;
 	}
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u freq=%u\n", dlen, freq);
-	cfg80211_rx_mgmt(&vif->wdev, freq, 0, ev->data, dlen, 0, GFP_ATOMIC);
+	cfg80211_rx_mgmt(&vif->wdev, freq, 0, ev->data, dlen, 0);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 1d1d0af..335bc38 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -350,7 +350,7 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 		}
 	} else {
 		cfg80211_rx_mgmt(wil->wdev, freq, signal,
-				 (void *)rx_mgmt_frame, d_len, 0, GFP_KERNEL);
+				 (void *)rx_mgmt_frame, d_len, 0);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 588fdbd..31b87d8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1431,8 +1431,7 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 					      IEEE80211_BAND_5GHZ);
 
 	wdev = &ifp->vif->wdev;
-	cfg80211_rx_mgmt(wdev, freq, 0, (u8 *)mgmt_frame, mgmt_frame_len, 0,
-			 GFP_ATOMIC);
+	cfg80211_rx_mgmt(wdev, freq, 0, (u8 *)mgmt_frame, mgmt_frame_len, 0);
 
 	kfree(mgmt_frame);
 	return 0;
@@ -1896,8 +1895,7 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 					      IEEE80211_BAND_2GHZ :
 					      IEEE80211_BAND_5GHZ);
 
-	cfg80211_rx_mgmt(&vif->wdev, freq, 0, mgmt_frame, mgmt_frame_len, 0,
-			 GFP_ATOMIC);
+	cfg80211_rx_mgmt(&vif->wdev, freq, 0, mgmt_frame, mgmt_frame_len, 0);
 
 	brcmf_dbg(INFO, "mgmt_frame_len (%d) , e->datalen (%d), chanspec (%04x), freq (%d)\n",
 		  mgmt_frame_len, e->datalen, chanspec, freq);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index cee0283..ec79c49 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -172,7 +172,7 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 
 	cfg80211_rx_mgmt(priv->wdev, priv->roc_cfg.chan.center_freq,
 			 CAL_RSSI(rx_pd->snr, rx_pd->nf), skb->data, pkt_len,
-			 0, GFP_ATOMIC);
+			 0);
 
 	return 0;
 }
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index f0839f6..a794bf0 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -3038,8 +3038,7 @@ void rtw_cfg80211_rx_action(struct rtw_adapter *adapter, u8 *frame,
 		freq = ieee80211_channel_to_frequency(channel,
 						      IEEE80211_BAND_5GHZ);
 
-	cfg80211_rx_mgmt(adapter->rtw_wdev, freq, 0, frame, frame_len,
-			 0, GFP_ATOMIC);
+	cfg80211_rx_mgmt(adapter->rtw_wdev, freq, 0, frame, frame_len, 0);
 }
 
 static int _cfg80211_rtw_mgmt_tx(struct rtw_adapter *padapter, u8 tx_ch,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0a080c4..7b8dac3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4412,7 +4412,6 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * @buf: Management frame (header + body)
  * @len: length of the frame data
  * @flags: flags, as defined in enum nl80211_rxmgmt_flags
- * @gfp: context flags
  *
  * This function is called whenever an Action frame is received for a station
  * mode interface, but is not processed in kernel.
@@ -4423,7 +4422,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * driver is responsible for rejecting the frame.
  */
 bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_dbm,
-		      const u8 *buf, size_t len, u32 flags, gfp_t gfp);
+		      const u8 *buf, size_t len, u32 flags);
 
 /**
  * cfg80211_mgmt_tx_status - notification of TX status for management frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5f572be..08fd450 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2706,7 +2706,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		sig = status->signal;
 
 	if (cfg80211_rx_mgmt(&rx->sdata->wdev, status->freq, sig,
-			     rx->skb->data, rx->skb->len, 0, GFP_ATOMIC)) {
+			     rx->skb->data, rx->skb->len, 0)) {
 		if (rx->sta)
 			rx->sta->rx_packets++;
 		dev_kfree_skb(rx->skb);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 266766b..369fc334 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -605,7 +605,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 }
 
 bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
-		      const u8 *buf, size_t len, u32 flags, gfp_t gfp)
+		      const u8 *buf, size_t len, u32 flags)
 {
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -648,7 +648,7 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 		/* Indicate the received Action frame to user space */
 		if (nl80211_send_mgmt(rdev, wdev, reg->nlportid,
 				      freq, sig_mbm,
-				      buf, len, flags, gfp))
+				      buf, len, flags, GFP_ATOMIC))
 			continue;
 
 		result = true;
-- 
1.9.1

