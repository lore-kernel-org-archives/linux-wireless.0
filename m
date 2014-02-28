Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46256 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaB1Dfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 9/9] mwifiex: update MCS information as per antenna settings
Date: Thu, 27 Feb 2014 19:35:18 -0800
Message-ID: <1393558518-921-4-git-send-email-bzhao@marvell.com> (sfid-20140228_043536_216969_FB9B2326)
In-Reply-To: <1393558518-921-1-git-send-email-bzhao@marvell.com>
References: <1393558518-921-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Even if the device is changed to 1X1 mode, data is sent with
higher MCS rates after association.

This patch fixes the problem by updating MCS information field
in HT capability when antenna setting changes so that correct
information will be advertised in association and probe request.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 31 +++++++++++++++++++++++++++++--
 drivers/net/wireless/mwifiex/cfp.c      |  2 +-
 drivers/net/wireless/mwifiex/cmdevt.c   |  1 +
 drivers/net/wireless/mwifiex/fw.h       | 13 +++++++++++++
 drivers/net/wireless/mwifiex/main.h     |  1 +
 5 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index bfe9316..51ce99c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1324,6 +1324,33 @@ mwifiex_cfg80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
 			tx_ant = RF_ANTENNA_AUTO;
 			rx_ant = RF_ANTENNA_AUTO;
 		}
+	} else {
+		struct ieee80211_sta_ht_cap *ht_info;
+		int rx_mcs_supp;
+		enum ieee80211_band band;
+
+		if ((tx_ant == 0x1 && rx_ant == 0x1)) {
+			adapter->user_dev_mcs_support = HT_STREAM_1X1;
+			if (adapter->is_hw_11ac_capable)
+				adapter->usr_dot_11ac_mcs_support =
+						MWIFIEX_11AC_MCS_MAP_1X1;
+		} else {
+			adapter->user_dev_mcs_support = HT_STREAM_2X2;
+			if (adapter->is_hw_11ac_capable)
+				adapter->usr_dot_11ac_mcs_support =
+						MWIFIEX_11AC_MCS_MAP_2X2;
+		}
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			if (!adapter->wiphy->bands[band])
+				continue;
+
+			ht_info = &adapter->wiphy->bands[band]->ht_cap;
+			rx_mcs_supp =
+				GET_RXMCSSUPP(adapter->user_dev_mcs_support);
+			memset(&ht_info->mcs, 0, adapter->number_of_antenna);
+			memset(&ht_info->mcs, 0xff, rx_mcs_supp);
+		}
 	}
 
 	ant_cfg.tx_ant = tx_ant;
@@ -2093,8 +2120,8 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	ht_info->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
 	ht_info->cap |= IEEE80211_HT_CAP_SM_PS;
 
-	rx_mcs_supp = GET_RXMCSSUPP(adapter->hw_dev_mcs_support);
-	/* Set MCS for 1x1 */
+	rx_mcs_supp = GET_RXMCSSUPP(adapter->user_dev_mcs_support);
+	/* Set MCS for 1x1/2x2 */
 	memset(mcs, 0xff, rx_mcs_supp);
 	/* Clear all the other values */
 	memset(&mcs[rx_mcs_supp], 0,
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 2c3226b..0ddec3d 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -253,7 +253,7 @@ u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv,
 			       u8 index, u8 ht_info)
 {
 	u32 mcs_num_supp =
-		(priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2) ? 16 : 8;
+		(priv->adapter->user_dev_mcs_support == HT_STREAM_2X2) ? 16 : 8;
 	u32 rate;
 
 	if (priv->adapter->is_hw_11ac_capable)
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index b4d28ed..14e05c9 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1592,6 +1592,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 
 	adapter->hw_dot_11n_dev_cap = le32_to_cpu(hw_spec->dot_11n_dev_cap);
 	adapter->hw_dev_mcs_support = hw_spec->dev_mcs_support;
+	adapter->user_dev_mcs_support = adapter->hw_dev_mcs_support;
 
 	if (adapter->if_ops.update_mp_end_port)
 		adapter->if_ops.update_mp_end_port(adapter,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index aa8abef..39cb354 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -236,8 +236,21 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
  */
 #define MWIFIEX_FW_DEF_HTTXCFG (BIT(1) | BIT(4) | BIT(5) | BIT(6))
 
+/* 11AC Tx and Rx MCS map for 1x1 mode:
+ * IEEE80211_VHT_MCS_SUPPORT_0_9 for stream 1
+ * IEEE80211_VHT_MCS_NOT_SUPPORTED for remaining 7 streams
+ */
+#define MWIFIEX_11AC_MCS_MAP_1X1	0xfffefffe
+
+/* 11AC Tx and Rx MCS map for 2x2 mode:
+ * IEEE80211_VHT_MCS_SUPPORT_0_9 for stream 1 and 2
+ * IEEE80211_VHT_MCS_NOT_SUPPORTED for remaining 6 streams
+ */
+#define MWIFIEX_11AC_MCS_MAP_2X2	0xfffafffa
+
 #define GET_RXMCSSUPP(DevMCSSupported) (DevMCSSupported & 0x0f)
 #define SETHT_MCS32(x) (x[4] |= 1)
+#define HT_STREAM_1X1	0x11
 #define HT_STREAM_2X2	0x22
 
 #define SET_SECONDARYCHAN(RadioType, SECCHAN) (RadioType |= (SECCHAN << 4))
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c423c2e..2097b0c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -772,6 +772,7 @@ struct mwifiex_adapter {
 	u8 event_body[MAX_EVENT_SIZE];
 	u32 hw_dot_11n_dev_cap;
 	u8 hw_dev_mcs_support;
+	u8 user_dev_mcs_support;
 	u8 adhoc_11n_enabled;
 	u8 sec_chan_offset;
 	struct mwifiex_dbg dbg;
-- 
1.8.2.3

