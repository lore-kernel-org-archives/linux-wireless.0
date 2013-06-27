Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48307 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3F0LR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 07:17:58 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>, Peer@vger.kernel.org,
	Ilan <ilan.peer@intel.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v13 1/2] cfg80211: add 'flags' to cfg80211_rx_mgmt()
Date: Thu, 27 Jun 2013 14:17:42 +0300
Message-ID: <1372331863-14083-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130627_131801_742015_7C3B1F54)
In-Reply-To: <1372331863-14083-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1372331863-14083-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flags intended to report various auxiliary information.
Introduced flag NL80211_RXMGMT_FLAG_REPLIED to report
whether frame was replied by the device/driver.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c         |  7 +++----
 drivers/net/wireless/ath/wil6210/wmi.c        |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |  4 ++--
 drivers/net/wireless/mwifiex/util.c           |  4 ++--
 include/net/cfg80211.h                        |  3 ++-
 include/uapi/linux/nl80211.h                  | 17 +++++++++++++++++
 net/mac80211/rx.c                             |  3 +--
 net/wireless/mlme.c                           |  4 ++--
 net/wireless/nl80211.c                        |  6 ++++--
 net/wireless/nl80211.h                        |  2 +-
 10 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 87aefb4..546d5da 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -568,8 +568,8 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len,
 		   dlen, freq, vif->probe_req_report);
 
 	if (vif->probe_req_report || vif->nw_type == AP_NETWORK)
-		cfg80211_rx_mgmt(&vif->wdev, freq, 0,
-				 ev->data, dlen, GFP_ATOMIC);
+		cfg80211_rx_mgmt(&vif->wdev, freq, 0, ev->data, dlen, 0,
+				 GFP_ATOMIC);
 
 	return 0;
 }
@@ -608,8 +608,7 @@ static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len,
 		return -EINVAL;
 	}
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u freq=%u\n", dlen, freq);
-	cfg80211_rx_mgmt(&vif->wdev, freq, 0,
-			 ev->data, dlen, GFP_ATOMIC);
+	cfg80211_rx_mgmt(&vif->wdev, freq, 0, ev->data, dlen, 0, GFP_ATOMIC);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dc8059a..21c791e 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -339,7 +339,7 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 		}
 	} else {
 		cfg80211_rx_mgmt(wil->wdev, freq, signal,
-				 (void *)rx_mgmt_frame, d_len, GFP_KERNEL);
+				 (void *)rx_mgmt_frame, d_len, 0, GFP_KERNEL);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 79555f0..d7a9745 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1430,7 +1430,7 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 					      IEEE80211_BAND_5GHZ);
 
 	wdev = &ifp->vif->wdev;
-	cfg80211_rx_mgmt(wdev, freq, 0, (u8 *)mgmt_frame, mgmt_frame_len,
+	cfg80211_rx_mgmt(wdev, freq, 0, (u8 *)mgmt_frame, mgmt_frame_len, 0,
 			 GFP_ATOMIC);
 
 	kfree(mgmt_frame);
@@ -1895,7 +1895,7 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 					      IEEE80211_BAND_2GHZ :
 					      IEEE80211_BAND_5GHZ);
 
-	cfg80211_rx_mgmt(&vif->wdev, freq, 0, mgmt_frame, mgmt_frame_len,
+	cfg80211_rx_mgmt(&vif->wdev, freq, 0, mgmt_frame, mgmt_frame_len, 0,
 			 GFP_ATOMIC);
 
 	brcmf_dbg(INFO, "mgmt_frame_len (%d) , e->datalen (%d), chanspec (%04x), freq (%d)\n",
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index e57ac0d..5d9e150 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -171,8 +171,8 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 	rx_pd->rx_pkt_length = cpu_to_le16(pkt_len);
 
 	cfg80211_rx_mgmt(priv->wdev, priv->roc_cfg.chan.center_freq,
-			 CAL_RSSI(rx_pd->snr, rx_pd->nf),
-			 skb->data, pkt_len, GFP_ATOMIC);
+			 CAL_RSSI(rx_pd->snr, rx_pd->nf), skb->data, pkt_len,
+			 0, GFP_ATOMIC);
 
 	return 0;
 }
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b0730a..c6acc70 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3886,6 +3886,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * @sig_dbm: signal strength in mBm, or 0 if unknown
  * @buf: Management frame (header + body)
  * @len: length of the frame data
+ * @flags: flags, as defined in enum nl80211_rxmgmt_flags
  * @gfp: context flags
  *
  * This function is called whenever an Action frame is received for a station
@@ -3897,7 +3898,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * driver is responsible for rejecting the frame.
  */
 bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_dbm,
-		      const u8 *buf, size_t len, gfp_t gfp);
+		      const u8 *buf, size_t len, u32 flags, gfp_t gfp);
 
 /**
  * cfg80211_mgmt_tx_status - notification of TX status for management frame
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 861e5eb..a042507 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1436,6 +1436,10 @@ enum nl80211_commands {
  *	allowed to be used with the first @NL80211_CMD_SET_STATION command to
  *	update a TDLS peer STA entry.
  *
+ * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
+ *	As specified in the enum nl80211_rxmgmt_flags.
+ *	Passed from cfg80211_rx_mgmt()
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1736,6 +1740,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PEER_AID,
 
+	NL80211_ATTR_RXMGMT_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3758,4 +3764,15 @@ enum nl80211_crit_proto_id {
 /* maximum duration for critical protocol measures */
 #define NL80211_CRIT_PROTO_MAX_DURATION		5000 /* msec */
 
+/**
+ * enum nl80211_rxmgmt_flags - flags for received management frame.
+ *
+ * Used by cfg80211_rx_mgmt()
+ *
+ * @NL80211_RXMGMT_FLAG_REPLIED: frame was replied by device/driver.
+ */
+enum nl80211_rxmgmt_flags {
+	NL80211_RXMGMT_FLAG_REPLIED = 1 << 0,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 23dbcfc..3f7fa49 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2635,8 +2635,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		sig = status->signal;
 
 	if (cfg80211_rx_mgmt(&rx->sdata->wdev, status->freq, sig,
-			     rx->skb->data, rx->skb->len,
-			     GFP_ATOMIC)) {
+			     rx->skb->data, rx->skb->len, 0, GFP_ATOMIC)) {
 		if (rx->sta)
 			rx->sta->rx_packets++;
 		dev_kfree_skb(rx->skb);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index bfac5e1..8d49c1c 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -621,7 +621,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 }
 
 bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
-		      const u8 *buf, size_t len, gfp_t gfp)
+		      const u8 *buf, size_t len, u32 flags, gfp_t gfp)
 {
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
@@ -664,7 +664,7 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 		/* Indicate the received Action frame to user space */
 		if (nl80211_send_mgmt(rdev, wdev, reg->nlportid,
 				      freq, sig_mbm,
-				      buf, len, gfp))
+				      buf, len, flags, gfp))
 			continue;
 
 		result = true;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7dc3343..8c98083 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9994,7 +9994,7 @@ EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, u32 nlportid,
 		      int freq, int sig_dbm,
-		      const u8 *buf, size_t len, gfp_t gfp)
+		      const u8 *buf, size_t len, u32 flags, gfp_t gfp)
 {
 	struct net_device *netdev = wdev->netdev;
 	struct sk_buff *msg;
@@ -10017,7 +10017,9 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, freq) ||
 	    (sig_dbm &&
 	     nla_put_u32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm)) ||
-	    nla_put(msg, NL80211_ATTR_FRAME, len, buf))
+	    nla_put(msg, NL80211_ATTR_FRAME, len, buf) ||
+	    (flags &&
+	     nla_put_u32(msg, NL80211_ATTR_RXMGMT_FLAGS, flags)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index a4073e8..3b51a76 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -66,7 +66,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, u32 nlpid,
 		      int freq, int sig_dbm,
-		      const u8 *buf, size_t len, gfp_t gfp);
+		      const u8 *buf, size_t len, u32 flags, gfp_t gfp);
 
 void
 nl80211_radar_notify(struct cfg80211_registered_device *rdev,
-- 
1.8.1.2

