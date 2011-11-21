Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58523 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1KUOln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 09:41:43 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so6626611bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 06:41:42 -0800 (PST)
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC v2 2/8] mac80211: mesh power mode indication in QoS frames
Date: Mon, 21 Nov 2011 18:40:10 +0400
Message-Id: <1321886416-12597-3-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154146_911104_5CCCA53C)
In-Reply-To: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE80211s standard a mesh peering is always associated
with two mesh STAs. Both mesh STAs have their own mesh power mode for
the mesh peering. This power mode is called as link-specific power
mode.

local_ps_mode field has been added to sta_info structure to represent
link-specific power mode at this station for station represented by
this structure.

According to this standard mesh STA shall indicate its non-peer mesh
power mode with the Power Management field in the Frame Control field
and the Mesh Power Save Level field in the QoS Control field in group
addressed Mesh Data frames.

And mesh STA shall indicate link-specific power mode with the Power
Management field in the Frame Control field and the Mesh Power Save
Level field in the QoS Control field in all transmitted individually
addressed Mesh Data frames and QoS Null frames.

The Power Management field set to 1 and the Mesh Power Save Level
subfield set to 0 indicate that the mesh STA is operating in light
mode. The Power Management field set to 0 and the mesh Power Save
Level subfield set to 1 indicate that the mesh STA is operating in
deep sleep mode. The Mesh Power Save Level subfield is reserved, if
the Power Management subfield is set to 0.

Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 include/linux/ieee80211.h |    3 +++
 net/mac80211/sta_info.h   |    2 ++
 net/mac80211/tx.c         |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..483fa46 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -133,6 +133,9 @@
 /* Mesh Control 802.11s */
 #define IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT  0x0100
 
+/* mesh power save level subfield mask */
+#define IEEE80211_QOS_CTL_MESH_PS_LEVEL 	0x0200
+
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
 #define IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK	0x0f
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
index 48bbb96..500c3ce 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1033,6 +1033,47 @@ ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
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
+				*qc |= cpu_to_le16(
+					IEEE80211_QOS_CTL_MESH_PS_LEVEL);
+			}
+		}
+	}
+}
+
 /* actual transmit path */
 
 static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
@@ -1437,6 +1478,8 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 			}
 
 	ieee80211_set_qos_hdr(sdata, skb);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		ieee80211_set_mesh_ps_fields(sdata, hdr);
 	ieee80211_tx(sdata, skb, false);
 	rcu_read_unlock();
 }
-- 
1.7.3.4

