Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58659 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbaCSFYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 01:24:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: update MCS set as per RX-STBC bit from hostapd
Date: Tue, 18 Mar 2014 22:24:10 -0700
Message-ID: <1395206650-11812-1-git-send-email-bzhao@marvell.com> (sfid-20140319_062418_407305_6AEAE25A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

To set AP in 1X1 or 2X2 mode through hostapd, we need to set
RX-STBC* in hostapd.conf file. Depending upon RX-STBC bit in
ht_cap IE received from hostapd, we need to update mcs set in
bss_cfg appropriately before starting AP.

Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  6 +++---
 drivers/net/wireless/mwifiex/fw.h       |  5 +++++
 drivers/net/wireless/mwifiex/uap_cmd.c  | 20 ++++++++++++++++++++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ee45d62..21ee27a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2100,10 +2100,10 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	else
 		ht_info->cap &= ~IEEE80211_HT_CAP_SGI_40;
 
-	if (ISSUPP_RXSTBC(adapter->hw_dot_11n_dev_cap))
-		ht_info->cap |= 1 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
+	if (adapter->user_dev_mcs_support == HT_STREAM_2X2)
+		ht_info->cap |= 3 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 	else
-		ht_info->cap &= ~(3 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+		ht_info->cap |= 1 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
 	if (ISSUPP_TXSTBC(adapter->hw_dot_11n_dev_cap))
 		ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 341e419..b485dc1 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -202,6 +202,11 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define MWIFIEX_DEF_AMPDU	IEEE80211_HT_AMPDU_PARM_FACTOR
 
+#define GET_RXSTBC(x) (x & IEEE80211_HT_CAP_RX_STBC)
+#define MWIFIEX_RX_STBC1	0x0100
+#define MWIFIEX_RX_STBC12	0x0200
+#define MWIFIEX_RX_STBC123	0x0300
+
 /* dev_cap bitmap
  * BIT
  * 0-16		reserved
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index a6a6a53..9be6544 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -159,6 +159,7 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 		      struct cfg80211_ap_settings *params)
 {
 	const u8 *ht_ie;
+	u16 cap_info;
 
 	if (!ISSUPP_11NENABLED(priv->adapter->fw_cap_info))
 		return;
@@ -168,6 +169,25 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 	if (ht_ie) {
 		memcpy(&bss_cfg->ht_cap, ht_ie + 2,
 		       sizeof(struct ieee80211_ht_cap));
+		cap_info = le16_to_cpu(bss_cfg->ht_cap.cap_info);
+		memset(&bss_cfg->ht_cap.mcs, 0,
+		       priv->adapter->number_of_antenna);
+		switch (GET_RXSTBC(cap_info)) {
+		case MWIFIEX_RX_STBC1:
+			/* HT_CAP 1X1 mode */
+			memset(&bss_cfg->ht_cap.mcs, 0xff, 1);
+			break;
+		case MWIFIEX_RX_STBC12:	/* fall through */
+		case MWIFIEX_RX_STBC123:
+			/* HT_CAP 2X2 mode */
+			memset(&bss_cfg->ht_cap.mcs, 0xff, 2);
+			break;
+		default:
+			dev_warn(priv->adapter->dev,
+				 "Unsupported RX-STBC, default to 2x2\n");
+			memset(&bss_cfg->ht_cap.mcs, 0xff, 2);
+			break;
+		}
 		priv->ap_11n_enabled = 1;
 	} else {
 		memset(&bss_cfg->ht_cap , 0, sizeof(struct ieee80211_ht_cap));
-- 
1.8.2.3

