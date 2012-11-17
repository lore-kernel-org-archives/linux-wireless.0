Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48676 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQGsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:45 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [RFC 06/14] mac80211: track neighbor STA power modes
Date: Fri, 16 Nov 2012 22:47:58 -0800
Message-Id: <1353134886-13256-7-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074920_420776_09C810AF)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE802.11-2012 a mesh peering is always associated between
two mesh STAs. Both mesh STAs have their own mesh power mode for the
mesh peering. This power mode is called the link-specific power mode.
The peer_ps_mode field has been added to the sta_info structure to
represent the peer's link-specific power mode towards the local station.
The nonpeer_ps_mode field has been added to represent the peer's power
mode towards all non-peer stations.

The peer's link-specific power modes are tracked from the Power Management
field in the Frame Control field and the Mesh Power Save Level field
in the QoS Control field. Peer and non-peer modes are tracked independently
from respective frames. This allows fast reconfiguration after a peering
change.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 include/linux/ieee80211.h |    9 ++++++
 net/mac80211/mesh.h       |    4 +++
 net/mac80211/mesh_ps.c    |   79 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c         |   18 +++++++++++
 net/mac80211/sta_info.h   |    4 +++
 5 files changed, 114 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 537edf3..1d8e69a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -571,6 +571,15 @@ static inline int ieee80211_is_first_frag(__le16 seq_ctrl)
 	return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0;
 }
 
+/**
+ * ieee80211_has_qos_pm - check Power Save Level in QoS control
+ * @qc - QoS control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_qos_pm(__le16 qc)
+{
+	return (qc & cpu_to_le16(IEEE80211_QOS_CTL_MESH_PS_LEVEL)) != 0;
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index a13549e..0e80ea7 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -264,6 +264,10 @@ void ieee80211_set_local_ps_mode(struct sta_info *sta,
 void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta,
 				 struct ieee80211_hdr *hdr);
+void ieee80211_set_peer_ps_mode(struct sta_info *sta,
+				struct ieee80211_hdr *hdr);
+void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
+				   struct ieee80211_hdr *hdr);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 4b7d2ef..2d147d2 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -232,3 +232,82 @@ void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
 	else
 		*qc &= cpu_to_le16(~IEEE80211_QOS_CTL_MESH_PS_LEVEL);
 }
+
+/**
+ * ieee80211_set_peer_ps_mode - track the neighbor mesh STA's peer-specific
+ * power mode towards the local STA
+ *
+ * @sta: STA info to update
+ * @hdr: IEEE 802.11 QoS Header
+ */
+void ieee80211_set_peer_ps_mode(struct sta_info *sta,
+				struct ieee80211_hdr *hdr)
+{
+	enum nl80211_mesh_power_mode pm;
+	__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+	static const char *modes[] = {
+		[NL80211_MESH_POWER_ACTIVE] = "active",
+		[NL80211_MESH_POWER_LIGHT_SLEEP] = "light sleep",
+		[NL80211_MESH_POWER_DEEP_SLEEP] = "deep sleep",
+	};
+
+	WARN_ON(!ieee80211_is_data_qos(hdr->frame_control) ||
+		is_multicast_ether_addr(hdr->addr1));
+
+	/*
+	 * Test Power Managment field of frame control (PW) and
+	 * mesh power save level subfield of QoS control field (PSL)
+	 *
+	 * | PM | PSL| Mesh Power Mode |
+	 * +----+----+-----------------+
+	 * | 0  |Rsrv|    Active       |
+	 * | 1  | 0  |    Light        |
+	 * | 1  | 1  |    Deep         |
+	 */
+	if (ieee80211_has_pm(hdr->frame_control)) {
+		if (ieee80211_has_qos_pm(*qc))
+			pm = NL80211_MESH_POWER_DEEP_SLEEP;
+		else
+			pm = NL80211_MESH_POWER_LIGHT_SLEEP;
+	} else {
+		pm = NL80211_MESH_POWER_ACTIVE;
+	}
+
+	if (sta->peer_ps_mode == pm)
+		return;
+
+	mps_dbg(sta->sdata, "STA %pM enters %s mode\n",
+		sta->sta.addr, modes[pm]);
+
+	sta->peer_ps_mode = pm;
+}
+
+/**
+ * ieee80211_set_nonpeer_ps_mode - track the neighbor mesh STA's
+ * power mode towards non-peer STA
+ *
+ * @sta: STA info to update
+ * @hdr: IEEE 802.11 (QoS) Header
+ */
+void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
+				   struct ieee80211_hdr *hdr)
+{
+	enum nl80211_mesh_power_mode pm;
+	static const char *modes[] = {
+		[NL80211_MESH_POWER_ACTIVE] = "active",
+		[NL80211_MESH_POWER_DEEP_SLEEP] = "deep sleep",
+	};
+
+	if (ieee80211_has_pm(hdr->frame_control))
+		pm = NL80211_MESH_POWER_DEEP_SLEEP;
+	else
+		pm = NL80211_MESH_POWER_ACTIVE;
+
+	if (sta->nonpeer_ps_mode == pm)
+		return;
+
+	mps_dbg(sta->sdata, "STA %pM sets non-peer mode to %s\n",
+		sta->sta.addr, modes[pm]);
+
+	sta->nonpeer_ps_mode = pm;
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 67aa26c..90f2ce5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1356,6 +1356,24 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		}
 	}
 
+	/* mesh power save support */
+	if (ieee80211_vif_is_mesh(&rx->sdata->vif)) {
+		if (is_unicast_ether_addr(hdr->addr1) &&
+		    ieee80211_is_data_qos(hdr->frame_control)) {
+			/*
+			 * individually addressed QoS Data/Null frames contain
+			 * peer's link-specific PS mode towards the local STA
+			 */
+			ieee80211_set_peer_ps_mode(sta, hdr);
+		} else {
+			/*
+			 * can only determine non-peer PS mode
+			 * (see IEEE802.11-2012 8.2.4.1.7)
+			 */
+			ieee80211_set_nonpeer_ps_mode(sta, hdr);
+		}
+	}
+
 	/*
 	 * Drop (qos-)data::nullfunc frames silently, since they
 	 * are used only to control station power saving mode.
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 046ca70..dbb3a10 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -277,6 +277,8 @@ struct sta_ampdu_mlme {
  * @local_ps_mode: local link-specific power save mode
  * @local_ps_mode_delayed: temp. storage for delayed setting of local_ps_mode
  * @local_ps_mode_timer: timer for delayed setting of local_ps_mode
+ * @peer_ps_mode: peer's link-specific power save mode
+ * @nonpeer_ps_mode: STA's power save mode towards non-peer neighbors
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -376,6 +378,8 @@ struct sta_info {
 	enum nl80211_mesh_power_mode local_ps_mode;
 	enum nl80211_mesh_power_mode local_ps_mode_delayed;
 	struct timer_list local_ps_mode_timer;
+	enum nl80211_mesh_power_mode peer_ps_mode;
+	enum nl80211_mesh_power_mode nonpeer_ps_mode;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.7.9.5

