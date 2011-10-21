Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61557 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1JUIge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:36:34 -0400
Received: by ywf7 with SMTP id 7so3651635ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 01:36:33 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Oct 2011 12:36:33 +0400
Message-ID: <CAG5dHkRULKh90W1MeR3zq+-gpeNUshrHZ0qbKXsW19PMG5enoQ@mail.gmail.com> (sfid-20111021_103637_877411_FF47FAB4)
Subject: [RFC 1/7] mac80211: mesh power mode indication in QoS frames
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

indicate non-peer mesh power mode in multicast and local
link-specific power mode in unicast QoS frames

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 include/linux/ieee80211.h |    3 ++
 include/linux/nl80211.h   |   29 ++++++++++++++++++++++++++
 include/net/cfg80211.h    |    2 +
 net/mac80211/sta_info.h   |    2 +
 net/mac80211/tx.c         |   50 ++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/mesh.c       |    1 +
 6 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..b206b94 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -133,6 +133,9 @@
 /* Mesh Control 802.11s */
 #define IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT  0x0100

+/* mesh power save level subfield mask */
+#define IEEE80211_QOS_CTL_PS_LEVEL      0x0200
+
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
 #define IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK	0x0f
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8049bf7..001e9e3 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1915,6 +1915,35 @@ enum nl80211_mntr_flags {
 };

 /**
+ * enum nl80211_mesh_power_mode - mesh power save modes
+ *
+ * @__NL80211_MESH_POWER_INVALID - internal use
+ *
+ * @NL80211_MESH_POWER_ACTIVE - active mesh power mode, mesh STA
+ *                            in Awake state all the time
+ * @NL80211_MESH_POWER_LIGHT_SLEEP - light sleep mode, mesh STA
+ *                            alternate between Active and Doze states,
+ *                            mesh STA should listen to all the beacons
+ * @NL80211_MESH_POWER_DEEP_SLEEP - deep sleep mode, mesh STA
+ *                            alternates between Active and Doze states,
+ *                            may choose not listen to the beacons
+ *
+ * @__NL80211_MESH_POWER_AFTER_LAST - internal use
+ * @NL80211_MESH_POWER_MAX - highest possible power save level
+ */
+
+enum nl80211_mesh_power_mode {
+	__NL80211_MESH_POWER_INVALID,
+
+	NL80211_MESH_POWER_ACTIVE,
+	NL80211_MESH_POWER_LIGHT_SLEEP,
+	NL80211_MESH_POWER_DEEP_SLEEP,
+
+	__NL80211_MESH_POWER_AFTER_LAST,
+	NL80211_MESH_POWER_MAX = __NL80211_MESH_POWER_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
  * Mesh configuration parameters. These can be changed while the mesh is
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 92cf1c2..e00e04e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -765,6 +765,8 @@ struct mesh_config {
 	u16 dot11MeshMaxPeerLinks;
 	u8  dot11MeshMaxRetries;
 	u8  dot11MeshTTL;
+	/* non-peer mesh power save mode */
+	u8 power_mode;
 	/* ttl used in path selection information elements */
 	u8  element_ttl;
 	bool auto_open_plinks;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c8ce05..8742668 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -250,6 +250,7 @@ struct sta_ampdu_mlme {
  * @plink_retries: Retries in establishment
  * @ignore_plink_timer: ignore the peer-link timer (used internally)
  * @plink_state: peer link state
+ * @local_ps_mode: local link-specific power save mode
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
  * @plink_timer_was_running: used by suspend/resume to restore timers
@@ -338,6 +339,7 @@ struct sta_info {
 	bool ignore_plink_timer;
 	bool plink_timer_was_running;
 	enum nl80211_plink_state plink_state;
+	enum nl80211_mesh_power_mode local_ps_mode;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
 #endif
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 48bbb96..8f2bc51 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1033,6 +1033,48 @@ ieee80211_tx_h_calculate_duration(struct
ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }

+#ifdef CONFIG_MAC80211_MESH
+static enum nl80211_mesh_power_mode
+ieee80211s_get_ps_mode(struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_hdr *hdr)
+{
+	enum nl80211_mesh_power_mode pm = NL80211_MESH_POWER_ACTIVE;
+	struct mesh_path *mpath;
+
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		pm = (enum nl80211_mesh_power_mode)
+				sdata->u.mesh.mshcfg.power_mode;
+	} else {
+		rcu_read_lock();
+		mpath = mesh_path_lookup(hdr->addr3, sdata);
+		if (mpath) {
+			pm = mpath->next_hop->local_ps_mode;
+		}
+		rcu_read_unlock();
+	}
+
+	return pm;
+}
+
+static void ieee80211_set_mesh_ps_fields(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_hdr *hdr)
+{
+	if (ieee80211_vif_is_mesh(&sdata->vif) &&
+	    (ieee80211_is_data_qos(hdr->frame_control)
+	     || ieee80211_is_qos_nullfunc(hdr->frame_control))) {
+		enum nl80211_mesh_power_mode
+				pm = ieee80211s_get_ps_mode(sdata, hdr);
+		if (pm != NL80211_MESH_POWER_ACTIVE) {
+			__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+			if (pm == NL80211_MESH_POWER_DEEP_SLEEP) {
+				*qc |= cpu_to_le16(IEEE80211_QOS_CTL_PS_LEVEL);
+			}
+		}
+	}
+}
+#endif /* CONFIG_MAC80211_MESH*/
+
 /* actual transmit path */

 static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
@@ -1437,6 +1479,9 @@ void ieee80211_xmit(struct ieee80211_sub_if_data
*sdata, struct sk_buff *skb)
 			}

 	ieee80211_set_qos_hdr(sdata, skb);
+#ifdef CONFIG_MAC80211_MESH
+	ieee80211_set_mesh_ps_fields(sdata, hdr);
+#endif /* CONFIG_MAC80211_MESH */
 	ieee80211_tx(sdata, skb, false);
 	rcu_read_unlock();
 }
@@ -1887,7 +1932,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct
sk_buff *skb,
 		wme_sta = true;

 	/* receiver and we are QoS enabled, use a QoS type frame */
-	if (wme_sta && local->hw.queues >= 4) {
+	if ((wme_sta && local->hw.queues >= 4) ||
+	    (ieee80211_vif_is_mesh(&sdata->vif) &&
+	     (ieee80211s_get_ps_mode(sdata, &hdr) !=
+			NL80211_MESH_POWER_ACTIVE))) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
 	}
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 4423e64..5febd0b 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -52,6 +52,7 @@ const struct mesh_config default_mesh_config = {
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
 	.dot11MeshHWMPRannInterval = MESH_RANN_INTERVAL,
 	.dot11MeshGateAnnouncementProtocol = false,
+	.power_mode = NL80211_MESH_POWER_ACTIVE,
 };

 const struct mesh_setup default_mesh_setup = {
-- 
1.7.3.4
