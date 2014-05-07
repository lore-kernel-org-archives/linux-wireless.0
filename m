Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9862 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbaEGFDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 01:03:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: add HT operation IE in TDLS setup confirm
Date: Tue, 6 May 2014 22:02:45 -0700
Message-ID: <1399438965-12221-3-git-send-email-bzhao@marvell.com> (sfid-20140507_070317_337475_45C7A7FB)
In-Reply-To: <1399438965-12221-1-git-send-email-bzhao@marvell.com>
References: <1399438965-12221-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support to populate HT operatation IE in TDLS
setup confirm command. This is required for setting wider
bandwidths for TDLS operations.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  | 42 +++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/11n.h  |  1 +
 drivers/net/wireless/mwifiex/fw.h   |  1 +
 drivers/net/wireless/mwifiex/tdls.c | 53 +++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 2bd07d6..e1c2f67 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -749,3 +749,45 @@ void mwifiex_set_ba_params(struct mwifiex_private *priv)
 
 	return;
 }
+
+u8 mwifiex_get_sec_chan_offset(int chan)
+{
+	u8 sec_offset;
+
+	switch (chan) {
+	case 36:
+	case 44:
+	case 52:
+	case 60:
+	case 100:
+	case 108:
+	case 116:
+	case 124:
+	case 132:
+	case 140:
+	case 149:
+	case 157:
+		sec_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		break;
+	case 40:
+	case 48:
+	case 56:
+	case 64:
+	case 104:
+	case 112:
+	case 120:
+	case 128:
+	case 136:
+	case 144:
+	case 153:
+	case 161:
+		sec_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		break;
+	case 165:
+	default:
+		sec_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		break;
+	}
+
+	return sec_offset;
+}
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 40b007a..43889d9e 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -63,6 +63,7 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
 				int cmd_action,
 				struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl);
 void mwifiex_del_tx_ba_stream_tbl_by_ra(struct mwifiex_private *priv, u8 *ra);
+u8 mwifiex_get_sec_chan_offset(int chan);
 
 static inline u8
 mwifiex_is_station_ampdu_allowed(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index f0730bd..ee59508 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -230,6 +230,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISENABLED_40MHZ_INTOLERANT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
 #define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
 #define ISSUPP_BEAMFORMING(Dot11nDevCap) (Dot11nDevCap & BIT(30))
+#define ISALLOWED_CHANWIDTH40(ht_param) (ht_param & BIT(2))
 
 /* httxcfg bitmap
  * 0		reserved
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 97662a1..6bef47c 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -185,6 +185,48 @@ static int mwifiex_tdls_add_vht_capab(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int
+mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, u8 *mac,
+			 u8 vht_enabled, struct sk_buff *skb)
+{
+	struct ieee80211_ht_operation *ht_oper;
+	struct mwifiex_sta_node *sta_ptr;
+	struct mwifiex_bssdescriptor *bss_desc =
+					&priv->curr_bss_params.bss_descriptor;
+	u8 *pos;
+
+	sta_ptr = mwifiex_get_sta_entry(priv, mac);
+	if (unlikely(!sta_ptr)) {
+		dev_warn(priv->adapter->dev,
+			 "TDLS peer station not found in list\n");
+		return -1;
+	}
+
+	pos = (void *)skb_put(skb, sizeof(struct ieee80211_ht_operation) + 2);
+	*pos++ = WLAN_EID_HT_OPERATION;
+	*pos++ = sizeof(struct ieee80211_ht_operation);
+	ht_oper = (void *)pos;
+
+	ht_oper->primary_chan = bss_desc->channel;
+
+	/* follow AP's channel bandwidth */
+	if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
+	    bss_desc->bcn_ht_cap &&
+	    ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_oper->ht_param))
+		ht_oper->ht_param = bss_desc->bcn_ht_oper->ht_param;
+
+	if (vht_enabled) {
+		ht_oper->ht_param =
+			  mwifiex_get_sec_chan_offset(bss_desc->channel);
+		ht_oper->ht_param |= BIT(2);
+	}
+
+	memcpy(&sta_ptr->tdls_cap.ht_oper, ht_oper,
+	       sizeof(struct ieee80211_ht_operation));
+
+	return 0;
+}
+
 static int mwifiex_tdls_add_vht_oper(struct mwifiex_private *priv,
 				     u8 *mac, struct sk_buff *skb)
 {
@@ -428,6 +470,17 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 				dev_kfree_skb_any(skb);
 				return ret;
 			}
+			ret = mwifiex_tdls_add_ht_oper(priv, peer, 1, skb);
+			if (ret) {
+				dev_kfree_skb_any(skb);
+				return ret;
+			}
+		} else {
+			ret = mwifiex_tdls_add_ht_oper(priv, peer, 0, skb);
+			if (ret) {
+				dev_kfree_skb_any(skb);
+				return ret;
+			}
 		}
 		break;
 
-- 
1.8.2.3

