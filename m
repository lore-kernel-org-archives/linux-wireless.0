Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29843 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaBHA1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:27:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 16/30] mwifiex: cleanup in mwifiex_fill_cap_info()
Date: Fri, 7 Feb 2014 16:27:31 -0800
Message-ID: <1391819254-21130-6-git-send-email-bzhao@marvell.com> (sfid-20140208_012744_840603_B7B531DF)
In-Reply-To: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
References: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Pass 'struct ieee80211_ht_cap' pointer to
mwifiex_fill_cap_info() instead of
'struct mwifiex_ie_types_htcap' pointer, because the routine
internally uses the later one.
This patch also adds WARN_ON_ONCE check for NULL band.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  | 29 +++++++++++++++++------------
 drivers/net/wireless/mwifiex/11n.h  |  4 ++--
 drivers/net/wireless/mwifiex/join.c |  2 +-
 drivers/net/wireless/mwifiex/scan.c |  2 +-
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 822e622..616b1d6 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -34,22 +34,26 @@
  *
  * RD responder bit to set to clear in the extended capability header.
  */
-void
-mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
-		      struct mwifiex_ie_types_htcap *ht_cap)
+int mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
+			  struct ieee80211_ht_cap *ht_cap)
 {
-	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->ht_cap.extended_ht_cap_info);
+	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->extended_ht_cap_info);
 	struct ieee80211_supported_band *sband =
 					priv->wdev->wiphy->bands[radio_type];
 
-	ht_cap->ht_cap.ampdu_params_info =
+	if (WARN_ON_ONCE(!sband)) {
+		dev_err(priv->adapter->dev, "Invalid radio type!\n");
+		return -EINVAL;
+	}
+
+	ht_cap->ampdu_params_info =
 		(sband->ht_cap.ampdu_factor &
 		 IEEE80211_HT_AMPDU_PARM_FACTOR) |
 		((sband->ht_cap.ampdu_density <<
 		 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT) &
 		 IEEE80211_HT_AMPDU_PARM_DENSITY);
 
-	memcpy((u8 *) &ht_cap->ht_cap.mcs, &sband->ht_cap.mcs,
+	memcpy((u8 *)&ht_cap->mcs, &sband->ht_cap.mcs,
 	       sizeof(sband->ht_cap.mcs));
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
@@ -57,17 +61,18 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 	     (priv->adapter->sec_chan_offset !=
 					IEEE80211_HT_PARAM_CHA_SEC_NONE)))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
-		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
+		SETHT_MCS32(ht_cap->mcs.rx_mask);
 
 	/* Clear RD responder bit */
 	ht_ext_cap &= ~IEEE80211_HT_EXT_CAP_RD_RESPONDER;
 
-	ht_cap->ht_cap.cap_info = cpu_to_le16(sband->ht_cap.cap);
-	ht_cap->ht_cap.extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
+	ht_cap->cap_info = cpu_to_le16(sband->ht_cap.cap);
+	ht_cap->extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
 
 	if (ISSUPP_BEAMFORMING(priv->adapter->hw_dot_11n_dev_cap))
-		ht_cap->ht_cap.tx_BF_cap_info =
-				cpu_to_le32(MWIFIEX_DEF_11N_TX_BF_CAP);
+		ht_cap->tx_BF_cap_info = cpu_to_le32(MWIFIEX_DEF_11N_TX_BF_CAP);
+
+	return 0;
 }
 
 /*
@@ -316,7 +321,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		       sizeof(struct ieee_types_header),
 		       le16_to_cpu(ht_cap->header.len));
 
-		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
+		mwifiex_fill_cap_info(priv, radio_type, &ht_cap->ht_cap);
 
 		*buffer += sizeof(struct mwifiex_ie_types_htcap);
 		ret_len += sizeof(struct mwifiex_ie_types_htcap);
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 353032d..fde39fe 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -34,8 +34,8 @@ int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
 int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       struct mwifiex_bssdescriptor *bss_desc,
 			       u8 **buffer);
-void mwifiex_fill_cap_info(struct mwifiex_private *, u8 radio_type,
-			   struct mwifiex_ie_types_htcap *);
+int mwifiex_fill_cap_info(struct mwifiex_private *, u8 radio_type,
+			  struct ieee80211_ht_cap *);
 int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
 				  u16 action, int *htcap_cfg);
 void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index d3934c6..34472ea 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -982,7 +982,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		       cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		radio_type = mwifiex_band_to_radio_type(
 					priv->adapter->config_bands);
-		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
+		mwifiex_fill_cap_info(priv, radio_type, &ht_cap->ht_cap);
 
 		if (adapter->sec_chan_offset ==
 					IEEE80211_HT_PARAM_CHA_SEC_NONE) {
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 2ed85a3..ef47fd2 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -957,7 +957,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		radio_type =
 			mwifiex_band_to_radio_type(priv->adapter->config_bands);
-		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
+		mwifiex_fill_cap_info(priv, radio_type, &ht_cap->ht_cap);
 		tlv_pos += sizeof(struct mwifiex_ie_types_htcap);
 	}
 
-- 
1.8.2.3

