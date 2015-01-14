Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28981 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbbANKsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:48:13 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EAOBlQ027963
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:48:13 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rwj838p4c-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:48:12 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 10/10] mwifiex: 11h handling for AP interface
Date: Wed, 14 Jan 2015 21:45:38 +0530
Message-ID: <1421252138-30157-11-git-send-email-patila@marvell.com> (sfid-20150114_114815_909192_4B1C1DF0)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables 11h extensions in FW upon detecting DFS
channel in start radar detection/channel switch handlers.
Patch also takes care of disabling 11h when non DFS channels
are to be set during start_ap handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c      | 18 +++++++++++++++++-
 drivers/net/wireless/mwifiex/cfg80211.c | 22 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h     |  5 +++++
 drivers/net/wireless/mwifiex/fw.h       |  2 ++
 drivers/net/wireless/mwifiex/init.c     |  2 ++
 drivers/net/wireless/mwifiex/main.h     |  5 +++++
 6 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index d794686..3ab87a8 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -21,6 +21,16 @@
 #include "fw.h"
 
 
+void mwifiex_init_11h_params(struct mwifiex_private *priv)
+{
+	priv->state_11h.is_11h_enabled = true;
+	priv->state_11h.is_11h_active = false;
+}
+
+inline int mwifiex_is_11h_active(struct mwifiex_private *priv)
+{
+	return priv->state_11h.is_11h_active;
+}
 /* This function appends 11h info to a buffer while joining an
  * infrastructure BSS
  */
@@ -69,10 +79,14 @@ mwifiex_11h_process_infra_join(struct mwifiex_private *priv, u8 **buffer,
 }
 
 /* Enable or disable the 11h extensions in the firmware */
-static int mwifiex_11h_activate(struct mwifiex_private *priv, bool flag)
+int mwifiex_11h_activate(struct mwifiex_private *priv, bool flag)
 {
 	u32 enable = flag;
 
+	/* enable master mode radar detection on AP interface */
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) && enable)
+		enable |= MWIFIEX_MASTER_RADAR_DET_MASK;
+
 	return mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
 				HostCmd_ACT_GEN_SET, DOT11H_I, &enable, true);
 }
@@ -91,11 +105,13 @@ void mwifiex_11h_process_join(struct mwifiex_private *priv, u8 **buffer,
 		 * bit
 		 */
 		mwifiex_11h_activate(priv, true);
+		priv->state_11h.is_11h_active = true;
 		bss_desc->cap_info_bitmap |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 		mwifiex_11h_process_infra_join(priv, buffer, bss_desc);
 	} else {
 		/* Deactivate 11h functions in the firmware */
 		mwifiex_11h_activate(priv, false);
+		priv->state_11h.is_11h_active = false;
 		bss_desc->cap_info_bitmap &= ~WLAN_CAPABILITY_SPECTRUM_MGMT;
 	}
 }
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 72dd1f3..dc1be72 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1740,6 +1740,18 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	mwifiex_set_wmm_params(priv, bss_cfg, params);
 
+	if (mwifiex_is_11h_active(priv) &&
+	    !cfg80211_chandef_dfs_required(wiphy, &params->chandef,
+					   priv->bss_mode)) {
+		dev_dbg(priv->adapter->dev, "Disable 11h extensions in FW\n");
+		if (mwifiex_11h_activate(priv, false)) {
+			dev_err(priv->adapter->dev,
+				"Failed to disable 11h extensions!!");
+			return -1;
+		}
+		priv->state_11h.is_11h_active = true;
+	}
+
 	if (mwifiex_config_start_uap(priv, bss_cfg)) {
 		wiphy_err(wiphy, "Failed to start AP\n");
 		kfree(bss_cfg);
@@ -3176,6 +3188,16 @@ mwifiex_cfg80211_start_radar_detection(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
+	if (!mwifiex_is_11h_active(priv)) {
+		dev_dbg(priv->adapter->dev, "Enable 11h extensions in FW\n");
+		if (mwifiex_11h_activate(priv, true)) {
+			dev_err(priv->adapter->dev,
+				"Failed to activate 11h extensions!!");
+			return -1;
+		}
+		priv->state_11h.is_11h_active = true;
+	}
+
 	memset(&radar_params, 0, sizeof(struct mwifiex_radar_params));
 	radar_params.chandef = chandef;
 	radar_params.cac_time_ms = cac_time_ms;
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 68aed4e..88d0ead 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -248,4 +248,9 @@ struct mwifiex_radar_params {
 	struct cfg80211_chan_def *chandef;
 	u32 cac_time_ms;
 } __packed;
+
+struct mwifiex_11h_intf_state {
+	bool is_11h_enabled;
+	bool is_11h_active;
+} __packed;
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6d433227..df553e8 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -534,6 +534,8 @@ enum P2P_MODES {
 
 #define MWIFIEX_FW_V15		   15
 
+#define MWIFIEX_MASTER_RADAR_DET_MASK BIT(1)
+
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index b021701..f4087bf 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -140,6 +140,8 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->check_tdls_tx = false;
 	memcpy(priv->tos_to_tid_inv, tos_to_tid_inv, MAX_NUM_TID);
 
+	mwifiex_init_11h_params(priv);
+
 	return mwifiex_add_bss_prio_tbl(priv);
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0163fcb..c120141 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -596,6 +596,7 @@ struct mwifiex_private {
 	struct workqueue_struct *dfs_chan_sw_workqueue;
 	struct delayed_work dfs_chan_sw_work;
 	struct cfg80211_beacon_data beacon_after;
+	struct mwifiex_11h_intf_state state_11h;
 };
 
 enum mwifiex_ba_status {
@@ -1337,6 +1338,10 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 void mwifiex_uap_del_sta_data(struct mwifiex_private *priv,
 			      struct mwifiex_sta_node *node);
 
+void mwifiex_init_11h_params(struct mwifiex_private *priv);
+int mwifiex_is_11h_active(struct mwifiex_private *priv);
+int mwifiex_11h_activate(struct mwifiex_private *priv, bool flag);
+
 void mwifiex_11h_process_join(struct mwifiex_private *priv, u8 **buffer,
 			      struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_11h_handle_event_chanswann(struct mwifiex_private *priv);
-- 
1.8.1.4

