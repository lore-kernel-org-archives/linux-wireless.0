Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:13468 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728509AbeHMPX1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 11:23:27 -0400
From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH 3/3] wil6210: Add EDMG channel support
Date: Mon, 13 Aug 2018 15:33:02 +0300
Message-Id: <1534163582-9983-4-git-send-email-ailizaro@codeaurora.org> (sfid-20180813_144125_331478_EA2958F3)
In-Reply-To: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
References: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for Enhanced Directional Multi-Gigabit (EDMG) channels 9-11.
wil6210 reports it's EDMG capabilities (that are also based on FW
capability) to cfg80211 by filling
wiphy->bands[NL80211_BAND_60GHZ]->edmg_cap.
wil6210 handles edmg_channel requested in connect and start_ap
operations.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  | 194 +++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/main.c      |   3 +
 drivers/net/wireless/ath/wil6210/txrx_edma.c |   2 +
 drivers/net/wireless/ath/wil6210/txrx_edma.h |   6 +
 drivers/net/wireless/ath/wil6210/wil6210.h   |   6 +-
 drivers/net/wireless/ath/wil6210/wmi.c       |   5 +-
 drivers/net/wireless/ath/wil6210/wmi.h       |  43 +++++-
 7 files changed, 242 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4740b53..63c8f44 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -51,6 +51,52 @@
 /* channel 4 not supported yet */
 };
 
+/* supported EDMG channels */
+static u8 wil_edmg_channels[] = {9, 10};
+
+/* Rx channel bonding mode */
+enum wil_rx_cb_mode {
+	WIL_RX_CB_MODE_DMG,
+	WIL_RX_CB_MODE_EDMG,
+	WIL_RX_CB_MODE_WIDE,
+};
+
+static int wil_rx_cb_mode_to_n_bonded(u8 cb_mode)
+{
+	switch (cb_mode) {
+	case WIL_RX_CB_MODE_DMG:
+	case WIL_RX_CB_MODE_EDMG:
+		return 1;
+	case WIL_RX_CB_MODE_WIDE:
+		return 2;
+	default:
+		return 1;
+	}
+}
+
+static int wil_tx_cb_mode_to_n_bonded(u8 cb_mode)
+{
+	switch (cb_mode) {
+	case WMI_TX_MODE_DMG:
+	case WMI_TX_MODE_EDMG_CB1:
+		return 1;
+	case WMI_TX_MODE_EDMG_CB2:
+		return 2;
+	default:
+		return 1;
+	}
+}
+
+void wil_update_supported_bands(struct wil6210_priv *wil)
+{
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+
+	wiphy->bands[NL80211_BAND_60GHZ]->edmg_cap.channels = wil_edmg_channels;
+	wiphy->bands[NL80211_BAND_60GHZ]->edmg_cap.n_channels =
+						ARRAY_SIZE(wil_edmg_channels);
+	wiphy->bands[NL80211_BAND_60GHZ]->edmg_cap.supported = true;
+}
+
 /* Vendor id to be used in vendor specific command and events
  * to user space.
  * NOTE: The authoritative place for definition of QCA_NL80211_VENDOR_ID,
@@ -261,6 +307,86 @@ int wil_iftype_nl2wmi(enum nl80211_iftype type)
 	return -EOPNOTSUPP;
 }
 
+int wil_spec2wmi_ch(u8 spec_ch, u8 *wmi_ch)
+{
+	switch (spec_ch) {
+	case 1:
+		*wmi_ch = WMI_CHANNEL_1;
+		break;
+	case 2:
+		*wmi_ch = WMI_CHANNEL_2;
+		break;
+	case 3:
+		*wmi_ch = WMI_CHANNEL_3;
+		break;
+	case 4:
+		*wmi_ch = WMI_CHANNEL_4;
+		break;
+	case 5:
+		*wmi_ch = WMI_CHANNEL_5;
+		break;
+	case 6:
+		*wmi_ch = WMI_CHANNEL_6;
+		break;
+	case 9:
+		*wmi_ch = WMI_CHANNEL_9;
+		break;
+	case 10:
+		*wmi_ch = WMI_CHANNEL_10;
+		break;
+	case 11:
+		*wmi_ch = WMI_CHANNEL_11;
+		break;
+	case 12:
+		*wmi_ch = WMI_CHANNEL_12;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int wil_wmi2spec_ch(u8 wmi_ch, u8 *spec_ch)
+{
+	switch (wmi_ch) {
+	case WMI_CHANNEL_1:
+		*spec_ch = 1;
+		break;
+	case WMI_CHANNEL_2:
+		*spec_ch = 2;
+		break;
+	case WMI_CHANNEL_3:
+		*spec_ch = 3;
+		break;
+	case WMI_CHANNEL_4:
+		*spec_ch = 4;
+		break;
+	case WMI_CHANNEL_5:
+		*spec_ch = 5;
+		break;
+	case WMI_CHANNEL_6:
+		*spec_ch = 6;
+		break;
+	case WMI_CHANNEL_9:
+		*spec_ch = 9;
+		break;
+	case WMI_CHANNEL_10:
+		*spec_ch = 10;
+		break;
+	case WMI_CHANNEL_11:
+		*spec_ch = 11;
+		break;
+	case WMI_CHANNEL_12:
+		*spec_ch = 12;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 		       struct station_info *sinfo)
 {
@@ -275,6 +401,7 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 	} __packed reply;
 	struct wil_net_stats *stats = &wil->sta[cid].stats;
 	int rc;
+	u8 txflag = RATE_INFO_FLAGS_DMG;
 
 	memset(&reply, 0, sizeof(reply));
 
@@ -287,7 +414,8 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 		    "  MCS %d TSF 0x%016llx\n"
 		    "  BF status 0x%08x RSSI %d SQI %d%%\n"
 		    "  Tx Tpt %d goodput %d Rx goodput %d\n"
-		    "  Sectors(rx:tx) my %d:%d peer %d:%d\n""}\n",
+		    "  Sectors(rx:tx) my %d:%d peer %d:%d\n"
+		    "  Tx mode %d}\n",
 		    cid, vif->mid, le16_to_cpu(reply.evt.bf_mcs),
 		    le64_to_cpu(reply.evt.tsf), reply.evt.status,
 		    reply.evt.rssi,
@@ -298,7 +426,8 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 		    le16_to_cpu(reply.evt.my_rx_sector),
 		    le16_to_cpu(reply.evt.my_tx_sector),
 		    le16_to_cpu(reply.evt.other_rx_sector),
-		    le16_to_cpu(reply.evt.other_tx_sector));
+		    le16_to_cpu(reply.evt.other_tx_sector),
+		    reply.evt.tx_mode);
 
 	sinfo->generation = wil->sinfo_gen;
 
@@ -311,9 +440,16 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 			BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC) |
 			BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 
-	sinfo->txrate.flags = RATE_INFO_FLAGS_DMG;
+	if (wil->use_enhanced_dma_hw && reply.evt.tx_mode != WMI_TX_MODE_DMG)
+		txflag = RATE_INFO_FLAGS_EDMG;
+
+	sinfo->txrate.flags = txflag;
 	sinfo->txrate.mcs = le16_to_cpu(reply.evt.bf_mcs);
 	sinfo->rxrate.mcs = stats->last_mcs_rx;
+	sinfo->txrate.n_bonded_ch =
+				wil_tx_cb_mode_to_n_bonded(reply.evt.tx_mode);
+	sinfo->rxrate.n_bonded_ch =
+			wil_rx_cb_mode_to_n_bonded(stats->last_cb_mode_rx);
 	sinfo->rx_bytes = stats->rx_bytes;
 	sinfo->rx_packets = stats->rx_packets;
 	sinfo->rx_dropped_misc = stats->rx_dropped;
@@ -888,6 +1024,30 @@ static void wil_print_connect_params(struct wil6210_priv *wil,
 	wil_print_crypto(wil, &sme->crypto);
 }
 
+static int wil_get_wmi_edmg_channel(struct wil6210_priv *wil, u8 edmg_channel,
+				    u8 *wmi_ch)
+{
+	int rc;
+
+	if (!test_bit(WMI_FW_CAPABILITY_CHANNEL_BONDING,
+		      wil->fw_capabilities) && edmg_channel)
+		return -EOPNOTSUPP;
+
+	if (edmg_channel) {
+		rc = wil_spec2wmi_ch(edmg_channel, wmi_ch);
+		if (rc) {
+			wil_err(wil, "wmi channel for spec channel %d not found\n",
+				edmg_channel);
+			return rc;
+		}
+		wil_dbg_misc(wil, "Set WMI channel %d\n", *wmi_ch);
+	} else {
+		wmi_ch = 0;
+	}
+
+	return 0;
+}
+
 static int wil_cfg80211_connect(struct wiphy *wiphy,
 				struct net_device *ndev,
 				struct cfg80211_connect_params *sme)
@@ -1007,6 +1167,11 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	}
 	conn.channel = ch - 1;
 
+	rc = wil_get_wmi_edmg_channel(wil, sme->edmg_channel,
+				      &conn.edmg_channel);
+	if (rc)
+		return rc;
+
 	ether_addr_copy(conn.bssid, bss->bssid);
 	ether_addr_copy(conn.dst_mac, bss->bssid);
 
@@ -1482,7 +1647,7 @@ static int _wil_cfg80211_set_ies(struct wil6210_vif *vif,
 static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 				  struct net_device *ndev,
 				  const u8 *ssid, size_t ssid_len, u32 privacy,
-				  int bi, u8 chan,
+				  int bi, u8 chan, u8 edmg_channel,
 				  struct cfg80211_beacon_data *bcon,
 				  u8 hidden_ssid, u32 pbss)
 {
@@ -1492,6 +1657,7 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
 	u8 is_go = (wdev->iftype == NL80211_IFTYPE_P2P_GO);
+	u8 wmi_edmg_chan;
 
 	if (pbss)
 		wmi_nettype = WMI_NETTYPE_P2P;
@@ -1521,8 +1687,13 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		goto out;
 
+	rc = wil_get_wmi_edmg_channel(wil, edmg_channel, &wmi_edmg_chan);
+	if (rc)
+		goto out;
+
 	vif->privacy = privacy;
 	vif->channel = chan;
+	vif->edmg_channel = edmg_channel;
 	vif->hidden_ssid = hidden_ssid;
 	vif->pbss = pbss;
 
@@ -1530,7 +1701,8 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (!wil_has_other_active_ifaces(wil, ndev, false, true))
 		wil6210_bus_request(wil, WIL_MAX_BUS_REQUEST_KBPS);
 
-	rc = wmi_pcp_start(vif, bi, wmi_nettype, chan, hidden_ssid, is_go);
+	rc = wmi_pcp_start(vif, bi, wmi_nettype, chan, wmi_edmg_chan,
+			   hidden_ssid, is_go);
 	if (rc)
 		goto err_pcp_start;
 
@@ -1578,7 +1750,8 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 		rc = _wil_cfg80211_start_ap(wiphy, ndev, wdev->ssid,
 					    wdev->ssid_len, privacy,
 					    wdev->beacon_interval,
-					    vif->channel, bcon,
+					    vif->channel,
+					    vif->edmg_channel, bcon,
 					    vif->hidden_ssid,
 					    vif->pbss);
 	} else {
@@ -1597,6 +1770,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	struct ieee80211_channel *channel = info->chandef.chan;
 	struct cfg80211_beacon_data *bcon = &info->beacon;
 	struct cfg80211_crypto_settings *crypto = &info->crypto;
+	u8 edmg_channel = info->chandef.edmg_channel;
 	u8 hidden_ssid;
 
 	wil_dbg_misc(wil, "start_ap\n");
@@ -1637,10 +1811,10 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	wil_print_bcon_data(bcon);
 	wil_print_crypto(wil, crypto);
 
-	rc = _wil_cfg80211_start_ap(wiphy, ndev,
-				    info->ssid, info->ssid_len, info->privacy,
-				    info->beacon_interval, channel->hw_value,
-				    bcon, hidden_ssid, info->pbss);
+	rc = _wil_cfg80211_start_ap(wiphy, ndev, info->ssid, info->ssid_len,
+				    info->privacy, info->beacon_interval,
+				    channel->hw_value, edmg_channel, bcon,
+				    hidden_ssid, info->pbss);
 
 	return rc;
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4de19bd..7e2fcf3 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1137,6 +1137,9 @@ void wil_refresh_fw_capabilities(struct wil6210_priv *wil)
 
 		wil->platform_ops.set_features(wil->platform_handle, features);
 	}
+
+	if (test_bit(WMI_FW_CAPABILITY_CHANNEL_BONDING, wil->fw_capabilities))
+		wil_update_supported_bands(wil);
 }
 
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 95f38e6..64bc0fb 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -1002,6 +1002,8 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 			stats->rx_per_mcs[stats->last_mcs_rx]++;
 	}
 
+	stats->last_cb_mode_rx  = wil_rx_status_get_cb_mode(msg);
+
 	if (!wil->use_rx_hw_reordering && !wil->use_compressed_rx_status &&
 	    wil_check_bar(wil, msg, cid, skb, stats) == -EAGAIN) {
 		kfree_skb(skb);
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.h b/drivers/net/wireless/ath/wil6210/txrx_edma.h
index e86fc2d..e7afa8b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.h
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.h
@@ -366,6 +366,12 @@ static inline u8 wil_rx_status_get_mcs(void *msg)
 			    16, 21);
 }
 
+static inline u8 wil_rx_status_get_cb_mode(void *msg)
+{
+	return WIL_GET_BITS(((struct wil_rx_status_compressed *)msg)->d1,
+			    22, 23);
+}
+
 static inline u16 wil_rx_status_get_flow_id(void *msg)
 {
 	return WIL_GET_BITS(((struct wil_rx_status_compressed *)msg)->d0,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d963c76..6baf5db 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -690,6 +690,7 @@ struct wil_net_stats {
 	unsigned long	rx_key_error; /* eDMA specific */
 	unsigned long	rx_amsdu_error; /* eDMA specific */
 	u16 last_mcs_rx;
+	u8 last_cb_mode_rx;
 	u64 rx_per_mcs[WIL_MCS_MAX + 1];
 };
 
@@ -803,6 +804,7 @@ struct wil6210_vif {
 	DECLARE_BITMAP(status, wil_vif_status_last);
 	u32 privacy; /* secure connection? */
 	u16 channel; /* relevant in AP mode */
+	u8 edmg_channel; /* relevant in AP mode */
 	u8 hidden_ssid; /* relevant in AP mode */
 	u32 ap_isolate; /* no intra-BSS communication */
 	bool pbss;
@@ -1236,7 +1238,7 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
 int wmi_pcp_start(struct wil6210_vif *vif, int bi, u8 wmi_nettype, u8 chan,
-		  u8 hidden_ssid, u8 is_go);
+		  u8 edmg_chan, u8 hidden_ssid, u8 is_go);
 int wmi_pcp_stop(struct wil6210_vif *vif);
 int wmi_led_cfg(struct wil6210_priv *wil, bool enable);
 int wmi_abort_scan(struct wil6210_vif *vif);
@@ -1305,6 +1307,8 @@ int wmi_start_sched_scan(struct wil6210_priv *wil,
 int wmi_stop_sched_scan(struct wil6210_priv *wil);
 int wmi_mgmt_tx(struct wil6210_vif *vif, const u8 *buf, size_t len);
 
+void wil_update_supported_bands(struct wil6210_priv *wil);
+
 int reverse_memcmp(const void *cs, const void *ct, size_t count);
 
 /* WMI for enhanced DMA */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 71056c8..77f0e6c 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1628,8 +1628,8 @@ int wmi_led_cfg(struct wil6210_priv *wil, bool enable)
 	return rc;
 }
 
-int wmi_pcp_start(struct wil6210_vif *vif,
-		  int bi, u8 wmi_nettype, u8 chan, u8 hidden_ssid, u8 is_go)
+int wmi_pcp_start(struct wil6210_vif *vif, int bi, u8 wmi_nettype,
+		  u8 chan, u8 edmg_chan, u8 hidden_ssid, u8 is_go)
 {
 	struct wil6210_priv *wil = vif_to_wil(vif);
 	int rc;
@@ -1639,6 +1639,7 @@ int wmi_pcp_start(struct wil6210_vif *vif,
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
 		.channel = chan - 1,
+		.edmg_channel = edmg_chan,
 		.pcp_max_assoc_sta = max_assoc_sta,
 		.hidden_ssid = hidden_ssid,
 		.is_go = is_go,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index abf6f05..2018014 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -84,6 +84,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_SET_SILENT_RSSI_TABLE		= 13,
 	WMI_FW_CAPABILITY_LO_POWER_CALIB_FROM_OTP	= 14,
 	WMI_FW_CAPABILITY_PNO				= 15,
+	WMI_FW_CAPABILITY_CHANNEL_BONDING		= 17,
 	WMI_FW_CAPABILITY_REF_CLOCK_CONTROL		= 18,
 	WMI_FW_CAPABILITY_AP_SME_OFFLOAD_NONE		= 19,
 	WMI_FW_CAPABILITY_AMSDU				= 23,
@@ -313,6 +314,19 @@ enum wmi_connect_ctrl_flag_bits {
 
 #define WMI_MAX_SSID_LEN	(32)
 
+enum wmi_channel {
+	WMI_CHANNEL_1	= 0x00,
+	WMI_CHANNEL_2	= 0x01,
+	WMI_CHANNEL_3	= 0x02,
+	WMI_CHANNEL_4	= 0x03,
+	WMI_CHANNEL_5	= 0x04,
+	WMI_CHANNEL_6	= 0x05,
+	WMI_CHANNEL_9	= 0x06,
+	WMI_CHANNEL_10	= 0x07,
+	WMI_CHANNEL_11	= 0x08,
+	WMI_CHANNEL_12	= 0x09,
+};
+
 /* WMI_CONNECT_CMDID */
 struct wmi_connect_cmd {
 	u8 network_type;
@@ -324,8 +338,12 @@ struct wmi_connect_cmd {
 	u8 group_crypto_len;
 	u8 ssid_len;
 	u8 ssid[WMI_MAX_SSID_LEN];
+	/* enum wmi_channel WMI_CHANNEL_1..WMI_CHANNEL_6; for EDMG this is
+	 * the primary channel number
+	 */
 	u8 channel;
-	u8 reserved0;
+	/* enum wmi_channel WMI_CHANNEL_9..WMI_CHANNEL_12 */
+	u8 edmg_channel;
 	u8 bssid[WMI_MAC_LEN];
 	__le32 ctrl_flags;
 	u8 dst_mac[WMI_MAC_LEN];
@@ -643,7 +661,9 @@ struct wmi_pcp_start_cmd {
 	u8 pcp_max_assoc_sta;
 	u8 hidden_ssid;
 	u8 is_go;
-	u8 reserved0[5];
+	/* enum wmi_channel WMI_CHANNEL_9..WMI_CHANNEL_12 */
+	u8 edmg_channel;
+	u8 reserved0[4];
 	/* A-BFT length override if non-0 */
 	u8 abft_len;
 	/* enum wmi_ap_sme_offload_mode_e */
@@ -1876,13 +1896,24 @@ struct wmi_ready_event {
 	u8 reserved[2];
 } __packed;
 
+enum wmi_edmg_tx_mode {
+	WMI_TX_MODE_DMG			= 0x0,
+	WMI_TX_MODE_EDMG_CB1		= 0x1,
+	WMI_TX_MODE_EDMG_CB2		= 0x2,
+	WMI_TX_MODE_EDMG_CB1_LONG_LDPC	= 0x3,
+	WMI_TX_MODE_EDMG_CB2_LONG_LDPC	= 0x4,
+	WMI_TX_MODE_MAX,
+};
+
 /* WMI_NOTIFY_REQ_DONE_EVENTID */
 struct wmi_notify_req_done_event {
 	/* beamforming status, 0: fail; 1: OK; 2: retrying */
 	__le32 status;
 	__le64 tsf;
 	s8 rssi;
-	u8 reserved0[3];
+	/* enum wmi_edmg_tx_mode */
+	u8 tx_mode;
+	u8 reserved0[2];
 	__le32 tx_tpt;
 	__le32 tx_goodput;
 	__le32 rx_goodput;
@@ -1898,8 +1929,12 @@ struct wmi_notify_req_done_event {
 
 /* WMI_CONNECT_EVENTID */
 struct wmi_connect_event {
+	/* enum wmi_channel WMI_CHANNEL_1..WMI_CHANNEL_6; for EDMG this is
+	 * the primary channel number
+	 */
 	u8 channel;
-	u8 reserved0;
+	/* enum wmi_channel WMI_CHANNEL_9..WMI_CHANNEL_12 */
+	u8 edmg_channel;
 	u8 bssid[WMI_MAC_LEN];
 	__le16 listen_interval;
 	__le16 beacon_interval;
-- 
1.9.1
