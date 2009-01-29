Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:61264 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZA2V0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 16:26:47 -0500
Received: by an-out-0708.google.com with SMTP id c2so74843anc.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2009 13:26:46 -0800 (PST)
Subject: [PATCH] wireless: replace uses of __constant_{endian}
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 13:26:44 -0800
Message-Id: <1233264404.5594.0.camel@brick> (sfid-20090129_222718_885873_EC90985D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The base versions handle constant folding now.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Rebased onto wireless-testing.

 drivers/net/wireless/hostap/hostap_80211_rx.c |    4 ++--
 drivers/net/wireless/hostap/hostap_ap.c       |    8 ++++----
 drivers/net/wireless/hostap/hostap_ioctl.c    |    6 +++---
 drivers/net/wireless/ipw2x00/ipw2200.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-calib.c      |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-commands.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-led.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h      |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-tx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |    4 ++--
 drivers/net/wireless/orinoco/hermes_dld.c     |    4 ++--
 drivers/net/wireless/orinoco/orinoco.c        |    2 +-
 net/mac80211/rx.c                             |    8 ++++----
 15 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index 19b1bf0..2417563 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -193,7 +193,7 @@ hdr->f.status = s; hdr->f.len = l; hdr->f.data = d
 	if (prism_header)
 		skb_pull(skb, phdrlen);
 	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = __constant_htons(ETH_P_802_2);
+	skb->protocol = cpu_to_be16(ETH_P_802_2);
 	memset(skb->cb, 0, sizeof(skb->cb));
 	netif_rx(skb);
 
@@ -1094,7 +1094,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 	if (skb2 != NULL) {
 		/* send to wireless media */
 		skb2->dev = dev;
-		skb2->protocol = __constant_htons(ETH_P_802_3);
+		skb2->protocol = cpu_to_be16(ETH_P_802_3);
 		skb_reset_mac_header(skb2);
 		skb_reset_network_header(skb2);
 		/* skb2->network_header += ETH_HLEN; */
diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 0903db7..0a4bf94 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -609,7 +609,7 @@ static void hostap_ap_tx_cb(struct sk_buff *skb, int ok, void *data)
 	skb->dev = ap->local->apdev;
 	skb_pull(skb, hostap_80211_get_hdrlen(fc));
 	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = __constant_htons(ETH_P_802_2);
+	skb->protocol = cpu_to_be16(ETH_P_802_2);
 	memset(skb->cb, 0, sizeof(skb->cb));
 	netif_rx(skb);
 }
@@ -2281,7 +2281,7 @@ void hostap_rx(struct net_device *dev, struct sk_buff *skb,
 	    WLAN_FC_GET_STYPE(fc) == IEEE80211_STYPE_BEACON)
 		goto drop;
 
-	skb->protocol = __constant_htons(ETH_P_HOSTAP);
+	skb->protocol = cpu_to_be16(ETH_P_HOSTAP);
 	handle_ap_item(local, skb, rx_stats);
 	return;
 
@@ -2310,7 +2310,7 @@ static void schedule_packet_send(local_info_t *local, struct sta_info *sta)
 	hdr = (struct ieee80211_hdr_4addr *) skb_put(skb, 16);
 
 	/* Generate a fake pspoll frame to start packet delivery */
-	hdr->frame_ctl = __constant_cpu_to_le16(
+	hdr->frame_ctl = cpu_to_le16(
 		IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
 	memcpy(hdr->addr1, local->dev->dev_addr, ETH_ALEN);
 	memcpy(hdr->addr2, sta->addr, ETH_ALEN);
@@ -2754,7 +2754,7 @@ ap_tx_ret hostap_handle_sta_tx(local_info_t *local, struct hostap_tx_data *tx)
 	if (meta->flags & HOSTAP_TX_FLAGS_ADD_MOREDATA) {
 		/* indicate to STA that more frames follow */
 		hdr->frame_ctl |=
-			__constant_cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	}
 
 	if (meta->flags & HOSTAP_TX_FLAGS_BUFFERED_FRAME) {
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index c40fdf4..8618b33 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -1638,7 +1638,7 @@ static int prism2_request_hostscan(struct net_device *dev,
 	memset(&scan_req, 0, sizeof(scan_req));
 	scan_req.channel_list = cpu_to_le16(local->channel_mask &
 					    local->scan_channel_mask);
-	scan_req.txrate = __constant_cpu_to_le16(HFA384X_RATES_1MBPS);
+	scan_req.txrate = cpu_to_le16(HFA384X_RATES_1MBPS);
 	if (ssid) {
 		if (ssid_len > 32)
 			return -EINVAL;
@@ -1668,7 +1668,7 @@ static int prism2_request_scan(struct net_device *dev)
 	memset(&scan_req, 0, sizeof(scan_req));
 	scan_req.channel_list = cpu_to_le16(local->channel_mask &
 					    local->scan_channel_mask);
-	scan_req.txrate = __constant_cpu_to_le16(HFA384X_RATES_1MBPS);
+	scan_req.txrate = cpu_to_le16(HFA384X_RATES_1MBPS);
 
 	/* FIX:
 	 * It seems to be enough to set roaming mode for a short moment to
@@ -2514,7 +2514,7 @@ static int prism2_ioctl_priv_prism2_param(struct net_device *dev,
 		u16 rate;
 
 		memset(&scan_req, 0, sizeof(scan_req));
-		scan_req.channel_list = __constant_cpu_to_le16(0x3fff);
+		scan_req.channel_list = cpu_to_le16(0x3fff);
 		switch (value) {
 		case 1: rate = HFA384X_RATES_1MBPS; break;
 		case 2: rate = HFA384X_RATES_2MBPS; break;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 625f2cf..0420d3d 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -8272,7 +8272,7 @@ static void ipw_handle_mgmt_packet(struct ipw_priv *priv,
 		skb_reset_mac_header(skb);
 
 		skb->pkt_type = PACKET_OTHERHOST;
-		skb->protocol = __constant_htons(ETH_P_80211_STATS);
+		skb->protocol = cpu_to_be16(ETH_P_80211_STATS);
 		memset(skb->cb, 0, sizeof(rxb->skb->cb));
 		netif_rx(skb);
 		rxb->skb = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d7d956d..3967712 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1995,8 +1995,8 @@ static u16 iwl4965_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 	addsta->add_immediate_ba_tid = cmd->add_immediate_ba_tid;
 	addsta->remove_immediate_ba_tid = cmd->remove_immediate_ba_tid;
 	addsta->add_immediate_ba_ssn = cmd->add_immediate_ba_ssn;
-	addsta->reserved1 = __constant_cpu_to_le16(0);
-	addsta->reserved2 = __constant_cpu_to_le32(0);
+	addsta->reserved1 = cpu_to_le16(0);
+	addsta->reserved2 = cpu_to_le32(0);
 
 	return (u16)sizeof(struct iwl4965_addsta_cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 8e5e666..45f6232 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -452,11 +452,11 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 				cpu_to_le16((u16)data->nrg_th_ofdm);
 
 	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
-				__constant_cpu_to_le16(190);
+				cpu_to_le16(190);
 	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
-				__constant_cpu_to_le16(390);
+				cpu_to_le16(390);
 	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] =
-				__constant_cpu_to_le16(62);
+				cpu_to_le16(62);
 
 	IWL_DEBUG_CALIB("ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
 			data->auto_corr_ofdm, data->auto_corr_ofdm_mrc,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e49415c..5130e90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2846,7 +2846,7 @@ struct statistics_rx_ht_phy {
 	__le32 reserved2;
 } __attribute__ ((packed));
 
-#define INTERFERENCE_DATA_AVAILABLE      __constant_cpu_to_le32(1)
+#define INTERFERENCE_DATA_AVAILABLE      cpu_to_le32(1)
 
 struct statistics_rx_non_phy {
 	__le32 bogus_cts;	/* CTS received when not expecting CTS */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3c6a4b0..c8d26ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -343,8 +343,8 @@ int iwl_send_scan_abort(struct iwl_priv *priv);
  * time if it's a quiet channel (nothing responded to our probe, and there's
  * no other traffic).
  * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
-#define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(10)  /* msec */
-#define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)  /* packets */
+#define IWL_ACTIVE_QUIET_TIME       cpu_to_le16(10)  /* msec */
+#define IWL_PLCP_QUIET_THRESH       cpu_to_le16(1)  /* packets */
 
 
 /*******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 1d798d0..140fd8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -35,7 +35,7 @@ struct iwl_priv;
 
 #define IWL_LED_SOLID 11
 #define IWL_LED_NAME_LEN 31
-#define IWL_DEF_LED_INTRVL __constant_cpu_to_le32(1000)
+#define IWL_DEF_LED_INTRVL cpu_to_le32(1000)
 
 #define IWL_LED_ACTIVITY       (0<<1)
 #define IWL_LED_LINK           (1<<1)
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 859b60b..2a13f9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -66,14 +66,14 @@ enum {
 
 /* Power management (not Tx power) structures */
 
-#define NOSLP __constant_cpu_to_le16(0), 0, 0
+#define NOSLP cpu_to_le16(0), 0, 0
 #define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
-#define SLP_TOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
-#define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
-				     __constant_cpu_to_le32(X1), \
-				     __constant_cpu_to_le32(X2), \
-				     __constant_cpu_to_le32(X3), \
-				     __constant_cpu_to_le32(X4)}
+#define SLP_TOUT(T) cpu_to_le32((T) * MSEC_TO_USEC)
+#define SLP_VEC(X0, X1, X2, X3, X4) {cpu_to_le32(X0), \
+				     cpu_to_le32(X1), \
+				     cpu_to_le32(X2), \
+				     cpu_to_le32(X3), \
+				     cpu_to_le32(X4)}
 struct iwl_power_vec_entry {
 	struct iwl_powertable_cmd cmd;
 	u8 no_dtim;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 7d2b6e1..035504e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -757,7 +757,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		seq_number = priv->stations[sta_id].tid[tid].seq_number;
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = hdr->seq_ctrl &
-				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG);
+				cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 25a3508..3b0e251 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -982,7 +982,7 @@ static int iwl3945_send_power_mode(struct iwl_priv *priv, u32 mode)
 }
 
 #define MAX_UCODE_BEACON_INTERVAL	1024
-#define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
+#define INTEL_CONN_LISTEN_INTERVAL	cpu_to_le16(0xA)
 
 static __le16 iwl3945_adjust_beacon_interval(u16 beacon_val)
 {
@@ -1482,7 +1482,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
 			(hdr->seq_ctrl &
-				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
+				cpu_to_le16(IEEE80211_SCTL_FRAG));
 		seq_number += 0x10;
 	}
 
diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index d8c626e..45aed14 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -573,9 +573,9 @@ static const struct {							\
 	__le16 id;							\
 	u8 val[length];							\
 } __attribute__ ((packed)) default_pdr_data_##pid = {			\
-	__constant_cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
+	cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
 				sizeof(__le16)) - 1),			\
-	__constant_cpu_to_le16(pid),					\
+	cpu_to_le16(pid),					\
 	data								\
 }
 
diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 6514e46..e082ef0 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -1333,7 +1333,7 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	skb->dev = dev;
 	skb->ip_summed = CHECKSUM_NONE;
 	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = __constant_htons(ETH_P_802_2);
+	skb->protocol = cpu_to_be16(ETH_P_802_2);
 	
 	stats->rx_packets++;
 	stats->rx_bytes += skb->len;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 19ffc8e..1a59382 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1225,12 +1225,12 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 
 	switch (hdr->frame_control &
 		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
-	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS):
+	case cpu_to_le16(IEEE80211_FCTL_TODS):
 		if (unlikely(sdata->vif.type != NL80211_IFTYPE_AP &&
 			     sdata->vif.type != NL80211_IFTYPE_AP_VLAN))
 			return -1;
 		break;
-	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
+	case cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
 		if (unlikely(sdata->vif.type != NL80211_IFTYPE_WDS &&
 			     sdata->vif.type != NL80211_IFTYPE_MESH_POINT))
 			return -1;
@@ -1244,13 +1244,13 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 			}
 		}
 		break;
-	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
+	case cpu_to_le16(IEEE80211_FCTL_FROMDS):
 		if (sdata->vif.type != NL80211_IFTYPE_STATION ||
 		    (is_multicast_ether_addr(dst) &&
 		     !compare_ether_addr(src, dev->dev_addr)))
 			return -1;
 		break;
-	case __constant_cpu_to_le16(0):
+	case cpu_to_le16(0):
 		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			return -1;
 		break;
-- 
1.6.1.401.gf39d5



