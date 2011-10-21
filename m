Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64879 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab1JUIhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:37:12 -0400
Received: by ggnb1 with SMTP id b1so3634075ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 01:37:11 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Oct 2011 12:37:11 +0400
Message-ID: <CAG5dHkRJ0UJMyTR4YuND262gAHBYrieCUex=Oe3D+pNW7wfCfQ@mail.gmail.com> (sfid-20111021_103717_210150_BEA4E630)
Subject: [RFC 2/7] mac80211: tracking mesh peer link-specific power mode
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tracking link-specific power mode from QoS data and QoS null frames

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 include/linux/ieee80211.h |   10 +++++++
 net/mac80211/mesh.h       |    2 +
 net/mac80211/rx.c         |   65 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h   |    2 +
 4 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b206b94..aa6e61d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -546,6 +546,16 @@ static inline int ieee80211_is_qos_nullfunc(__le16 fc)
 	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
 }

+/**
+ * ieee80211s_has_qos_pm - check Power Save Level in QoS control
+ * @qc - QoS control bytes in little-endian byteorder
+ */
+
+static inline int ieee80211s_has_qos_pm(__le16 qc)
+{
+	return (qc & cpu_to_le16(IEEE80211_QOS_CTL_PS_LEVEL)) != 0;
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8c00e2d..6842453 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -222,6 +222,8 @@ void ieee80211_mesh_init_sdata(struct
ieee80211_sub_if_data *sdata);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
+void ieee80211s_set_sta_ps_mode(struct sta_info *sta,
+				enum nl80211_mesh_power_mode mode);

 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b867bd5..4decfab 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1162,6 +1162,36 @@ int ieee80211_sta_ps_transition(struct
ieee80211_sta *sta, bool start)
 }
 EXPORT_SYMBOL(ieee80211_sta_ps_transition);

+#ifdef CONFIG_MAC80211_MESH
+void ieee80211s_set_sta_ps_mode(struct sta_info *sta,
+				enum nl80211_mesh_power_mode mode)
+{
+	if (sta->peer_ps_mode != mode) {
+		sta->peer_ps_mode = mode;
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		switch (mode) {
+		case NL80211_MESH_POWER_ACTIVE:
+			printk(KERN_DEBUG "%s: STA %pM enters active mode\n",
+				sta->sdata->name, sta->sta.addr);
+			break;
+		case NL80211_MESH_POWER_LIGHT_SLEEP:
+			printk(KERN_DEBUG "%s: STA %pM enters light sleep mode\n",
+				sta->sdata->name, sta->sta.addr);
+			break;
+		case NL80211_MESH_POWER_DEEP_SLEEP:
+			printk(KERN_DEBUG "%s: STA %pM enters deep sleep mode\n",
+				sta->sdata->name, sta->sta.addr);
+			break;
+		default:
+			printk(KERN_DEBUG "%s: STA %pM used invalid power save mode\n",
+				sta->sdata->name, sta->sta.addr);
+			break;
+		}
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+	}
+}
+#endif /* CONFIG_MAC80211_MESH */
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
 {
@@ -1313,6 +1343,41 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		}
 	}

+#ifdef CONFIG_MAC80211_MESH
+	/*
+	 * Test mesh power save level subfield of QoS control field (PSL)
+	 * and Power Managment field of frame control (PW)
+	 * +----+----+-----------------+
+	 * | PM | PSL| Mesh Power Mode |
+	 * +----+----+-----------------+
+	 * | 0  |Rsrv|    Active       |
+	 * +----+----+-----------------+
+	 * | 1  | 0  |    Light        |
+	 * +----+----+-----------------+
+	 * | 1  | 1  |    Deep         |
+	 * +----+----+-----------------+
+	 */
+	if (!ieee80211_has_morefrags(hdr->frame_control) &&
+	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
+	    ieee80211_vif_is_mesh(&rx->sdata->vif) &&
+	    (ieee80211_is_data(hdr->frame_control) ||
+	     ieee80211_is_nullfunc(hdr->frame_control))) {
+		if (ieee80211_has_pm(hdr->frame_control)) {
+			__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+			if (ieee80211s_has_qos_pm(*qc)) {
+				ieee80211s_set_sta_ps_mode(sta,
+					NL80211_MESH_POWER_DEEP_SLEEP);
+			} else {
+				ieee80211s_set_sta_ps_mode(sta,
+					NL80211_MESH_POWER_LIGHT_SLEEP);
+			}
+		} else {
+			ieee80211s_set_sta_ps_mode(sta,
+				NL80211_MESH_POWER_ACTIVE);
+		}
+	}
+#endif /* CONFIG_MAC80211_MESH */
+
 	/*
 	 * Drop (qos-)data::nullfunc frames silently, since they
 	 * are used only to control station power saving mode.
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8742668..86fe10a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -251,6 +251,7 @@ struct sta_ampdu_mlme {
  * @ignore_plink_timer: ignore the peer-link timer (used internally)
  * @plink_state: peer link state
  * @local_ps_mode: local link-specific power save mode
+ * @peer_ps_mode: peer link-specific power save mode
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
  * @plink_timer_was_running: used by suspend/resume to restore timers
@@ -340,6 +341,7 @@ struct sta_info {
 	bool plink_timer_was_running;
 	enum nl80211_plink_state plink_state;
 	enum nl80211_mesh_power_mode local_ps_mode;
+	enum nl80211_mesh_power_mode peer_ps_mode;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
 #endif
-- 
1.7.3.4
