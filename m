Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:39211 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755391Ab2ECHYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:24:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 18/18] mwifiex: delete IEs when stop_ap
Date: Thu,  3 May 2012 00:22:40 -0700
Message-Id: <1336029760-22565-19-git-send-email-bzhao@marvell.com> (sfid-20120503_092410_592707_6DBB7296)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Delete custom IEs set by start_ap cfg80211 handler when stop_ap
handler is called for AP interface.
IE index required for deletion is stored in mwifiex_private
structure.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    5 ++
 drivers/net/wireless/mwifiex/ie.c       |   69 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h     |    1 +
 3 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fcb30eb..8804023 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -929,6 +929,11 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
+	if (mwifiex_del_mgmt_ies(priv, MGMT_MASK_BEACON |
+				       MGMT_MASK_PROBE_RESP |
+				       MGMT_MASK_ASSOC_RESP))
+		return -1;
+
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
 				  HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "Failed to stop the BSS\n");
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 78f0285..bbe540a 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -376,3 +376,72 @@ done:
 
 	return ret;
 }
+
+/* This function removes management IE set */
+int mwifiex_del_mgmt_ies(struct mwifiex_private *priv, u16 ie_mask)
+{
+	struct mwifiex_ie *beacon_ie = NULL, *pr_ie = NULL;
+	struct mwifiex_ie *ar_ie = NULL, *rsn_ie = NULL;
+	int ret;
+
+	if (priv->rsn_idx != MWIFIEX_AUTO_IDX_MASK) {
+		rsn_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!rsn_ie)
+			return -ENOMEM;
+
+		rsn_ie->ie_index = cpu_to_le16(priv->rsn_idx);
+		rsn_ie->mgmt_subtype_mask = cpu_to_le16(MWIFIEX_DELETE_MASK);
+		rsn_ie->ie_length = 0;
+		if (mwifiex_update_uap_custom_ie(priv, rsn_ie, &priv->rsn_idx,
+						 NULL, &priv->proberesp_idx,
+						 NULL, &priv->assocresp_idx)) {
+			ret = -1;
+			goto done;
+		}
+
+		priv->rsn_idx = MWIFIEX_AUTO_IDX_MASK;
+	}
+
+	if (ie_mask & MGMT_MASK_BEACON) {
+		beacon_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!beacon_ie) {
+			ret = -ENOMEM;
+			goto done;
+		}
+		beacon_ie->ie_index = cpu_to_le16(priv->beacon_idx);
+		beacon_ie->mgmt_subtype_mask = cpu_to_le16(MWIFIEX_DELETE_MASK);
+		beacon_ie->ie_length = 0;
+	}
+	if (ie_mask & MGMT_MASK_PROBE_RESP) {
+		pr_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!pr_ie) {
+			ret = -ENOMEM;
+			goto done;
+		}
+		pr_ie->ie_index = cpu_to_le16(priv->beacon_idx);
+		pr_ie->mgmt_subtype_mask = cpu_to_le16(MWIFIEX_DELETE_MASK);
+		pr_ie->ie_length = 0;
+	}
+	if (ie_mask & MGMT_MASK_ASSOC_RESP) {
+		ar_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!ar_ie) {
+			ret = -ENOMEM;
+			goto done;
+		}
+		ar_ie->ie_index = cpu_to_le16(priv->beacon_idx);
+		ar_ie->mgmt_subtype_mask = cpu_to_le16(MWIFIEX_DELETE_MASK);
+		ar_ie->ie_length = 0;
+	}
+
+	ret = mwifiex_update_uap_custom_ie(priv, beacon_ie, &priv->beacon_idx,
+					   pr_ie, &priv->proberesp_idx,
+					   ar_ie, &priv->assocresp_idx);
+
+done:
+	kfree(beacon_ie);
+	kfree(pr_ie);
+	kfree(ar_ie);
+	kfree(rsn_ie);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1eb6539..5b444c4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1007,6 +1007,7 @@ void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config);
 
 int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 			 struct cfg80211_ap_settings *params, u16 ie_mask);
+int mwifiex_del_mgmt_ies(struct mwifiex_private *priv, u16 ie_mask);
 
 u8 *mwifiex_11d_code_2_region(u8 code);
 
-- 
1.7.0.2

