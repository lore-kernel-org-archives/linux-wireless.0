Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55130 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3JKSaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 14:30:03 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so4530023pbc.30
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 11:30:03 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v4 1/6] mac80211: process the CSA frame for mesh accordingly
Date: Fri, 11 Oct 2013 11:29:45 -0700
Message-Id: <1381516190-23918-2-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203020_920708_C059491A)
In-Reply-To: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process the CSA frame according to the procedures define in IEEE Std
802.11-2012 section 10.9.8.4.3 as follow:
* The mesh channel switch parameters element (MCSP) must be availabe.
* If the MCSP's TTL is 1, drop the frame but still process the CSA.
* If the MCSP's precedence value is less than or equal to the current
  precedence value, drop the frame and do not process the CSA.
* The CSA frame is forwarded after TTL is decremented by 1 and the
  initiator field is set to 0. Transmit restrict field and others
  are maintained as is.
* No beacon or probe response frame are handled here.

Also, introduce the debug message used for mesh CSA purpose.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
v2: fix return value, typo and others (Johannes Berg)

 include/linux/ieee80211.h  |   20 +++++++++++
 net/mac80211/Kconfig       |   11 ++++++
 net/mac80211/debug.h       |   10 ++++++
 net/mac80211/ieee80211_i.h |    4 +++
 net/mac80211/mesh.c        |   83 ++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/util.c        |    9 +++++
 6 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 23a8877..f117427 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -696,6 +696,18 @@ struct ieee80211_sec_chan_offs_ie {
 } __packed;
 
 /**
+ * struct ieee80211_mesh_chansw_params_ie - mesh channel switch parameters IE
+ *
+ * This structure represents the "Mesh Channel Switch Paramters element"
+ */
+struct ieee80211_mesh_chansw_params_ie {
+	u8 mesh_ttl;
+	u8 mesh_flags;
+	__le16 mesh_reason;
+	__le16 mesh_pre_value;
+} __packed;
+
+/**
  * struct ieee80211_wide_bw_chansw_ie - wide bandwidth channel switch IE
  */
 struct ieee80211_wide_bw_chansw_ie {
@@ -750,6 +762,14 @@ enum mesh_config_capab_flags {
 };
 
 /**
+ * mesh channel switch parameters element's flag indicator
+ *
+ */
+#define WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT BIT(0)
+#define WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR BIT(1)
+#define WLAN_EID_CHAN_SWITCH_PARAM_REASON BIT(2)
+
+/**
  * struct ieee80211_rann_ie
  *
  * This structure refers to "Root Announcement information element"
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 62535fe..bf1871e 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -258,6 +258,17 @@ config MAC80211_MESH_SYNC_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_MESH_CSA_DEBUG
+	bool "Verbose mesh channel switch debugging"
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_MESH
+	---help---
+	  Selecting this option causes mac80211 to print out very verbose mesh
+	  channel switch debugging messages (when mac80211 is taking part in a
+	  mesh network).
+
+	  Do not select this option.
+
 config MAC80211_MESH_PS_DEBUG
 	bool "Verbose mesh powersave debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index 4ccc5ed..493d680 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -44,6 +44,12 @@
 #define MAC80211_MESH_SYNC_DEBUG 0
 #endif
 
+#ifdef CONFIG_MAC80211_MESH_CSA_DEBUG
+#define MAC80211_MESH_CSA_DEBUG 1
+#else
+#define MAC80211_MESH_CSA_DEBUG 0
+#endif
+
 #ifdef CONFIG_MAC80211_MESH_PS_DEBUG
 #define MAC80211_MESH_PS_DEBUG 1
 #else
@@ -157,6 +163,10 @@ do {									\
 	_sdata_dbg(MAC80211_MESH_SYNC_DEBUG,				\
 		   sdata, fmt, ##__VA_ARGS__)
 
+#define mcsa_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_MESH_CSA_DEBUG,				\
+		   sdata, fmt, ##__VA_ARGS__)
+
 #define mps_dbg(sdata, fmt, ...)					\
 	_sdata_dbg(MAC80211_MESH_PS_DEBUG,				\
 		   sdata, fmt, ##__VA_ARGS__)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3a87c89..7f13b65 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -598,6 +598,9 @@ struct ieee80211_if_mesh {
 	int ps_peers_light_sleep;
 	int ps_peers_deep_sleep;
 	struct ps_data ps;
+	/* Channel Switching Support */
+	bool chsw_init;
+	u16 pre_value;
 };
 
 #ifdef CONFIG_MAC80211_MESH
@@ -1239,6 +1242,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_timeout_interval_ie *timeout_int;
 	const u8 *opmode_notif;
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
+	const struct ieee80211_mesh_chansw_params_ie *mesh_chansw_params_ie;
 
 	/* length of them, respectively */
 	u8 ssid_len;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 707ac61..0a3ccaa 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -920,6 +920,82 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			stype, mgmt, &elems, rx_status);
 }
 
+static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_mgmt *mgmt_fwd;
+	struct sk_buff *skb;
+	struct ieee80211_local *local = sdata->local;
+	u8 *pos = mgmt->u.action.u.chan_switch.variable;
+	size_t offset_ttl;
+
+	skb = dev_alloc_skb(local->tx_headroom + len);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, local->tx_headroom);
+	mgmt_fwd = (struct ieee80211_mgmt *) skb_put(skb, len);
+
+	/* offset_ttl is based on whether the secondary channel
+	 * offset is available or not. Substract 1 from the mesh TTL
+	 * and disable the initiator flag before forwarding.
+	 */
+	offset_ttl = (len < 42) ? 7 : 10;
+	*(pos + offset_ttl) -= 1;
+	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
+
+	memcpy(mgmt_fwd, mgmt, len);
+	eth_broadcast_addr(mgmt_fwd->da);
+	memcpy(mgmt_fwd->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(mgmt_fwd->bssid, sdata->vif.addr, ETH_ALEN);
+
+	ieee80211_tx_skb(sdata, skb);
+	return 0;
+}
+
+static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
+			      struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee802_11_elems elems;
+	u16 pre_value;
+	bool block_tx, fwd_csa = true;
+	size_t baselen;
+	u8 *pos, ttl;
+
+	if (mgmt->u.action.u.measurement.action_code !=
+	    WLAN_ACTION_SPCT_CHL_SWITCH)
+		return;
+
+	pos = mgmt->u.action.u.chan_switch.variable;
+	baselen = offsetof(struct ieee80211_mgmt,
+			   u.action.u.chan_switch.variable);
+	ieee802_11_parse_elems(pos, len - baselen, false, &elems);
+
+	ttl = elems.mesh_chansw_params_ie->mesh_ttl;
+	if (!--ttl)
+		fwd_csa = false;
+
+	pre_value = le16_to_cpu(elems.mesh_chansw_params_ie->mesh_pre_value);
+	if (ifmsh->pre_value >= pre_value)
+		return;
+
+	ifmsh->pre_value = pre_value;
+
+	/* forward or re-broadcast the CSA frame */
+	if (fwd_csa) {
+		if (mesh_fwd_csa_frame(sdata, mgmt, len) < 0)
+			mcsa_dbg(sdata, "Failed to forward the CSA frame");
+	}
+
+	/* block the Tx only after forwarding the CSA frame if required */
+	block_tx = elems.mesh_chansw_params_ie->mesh_flags &
+		   WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT;
+	if (block_tx)
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_MAX_QUEUE_MAP,
+				IEEE80211_QUEUE_STOP_REASON_CSA);
+}
+
 static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len,
@@ -939,6 +1015,9 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 		if (mesh_action_is_path_sel(mgmt))
 			mesh_rx_path_sel_frame(sdata, mgmt, len);
 		break;
+	case WLAN_CATEGORY_SPECTRUM_MGMT:
+		mesh_rx_csa_frame(sdata, mgmt, len);
+		break;
 	}
 }
 
@@ -1056,13 +1135,11 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 		    (unsigned long) sdata);
 
 	ifmsh->accepting_plinks = true;
-	ifmsh->preq_id = 0;
-	ifmsh->sn = 0;
-	ifmsh->num_gates = 0;
 	atomic_set(&ifmsh->mpaths, 0);
 	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
+	ifmsh->chsw_init = false;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c8283b..133667c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -743,6 +743,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_TIMEOUT_INTERVAL:
 		case WLAN_EID_SECONDARY_CHANNEL_OFFSET:
 		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
+		case WLAN_EID_CHAN_SWITCH_PARAM:
 		/*
 		 * not listing WLAN_EID_CHANNEL_SWITCH_WRAPPER -- it seems possible
 		 * that if the content gets bigger it might be needed more than once
@@ -908,6 +909,14 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			}
 			elems->sec_chan_offs = (void *)pos;
 			break;
+		case WLAN_EID_CHAN_SWITCH_PARAM:
+			if (elen !=
+			    sizeof(*elems->mesh_chansw_params_ie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->mesh_chansw_params_ie = (void *)pos;
+			break;
 		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
 			if (!action ||
 			    elen != sizeof(*elems->wide_bw_chansw_ie)) {
-- 
1.7.9.5

