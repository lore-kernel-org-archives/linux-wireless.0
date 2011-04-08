Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:60521 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab1DHTDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 15:03:11 -0400
Date: Sat, 9 Apr 2011 00:25:37 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: Fix checkpatch.pl and sparse warnings and errors
Message-ID: <20110408185529.GA26751@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch errors and warnings comprising of indent errors, spaces and
__packed warnings. Also fix 'make C = 2' warnings.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8913180..fb472f4 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -701,7 +701,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 			       "helper image\n", pci_name(priv->pdev));
 			return rc;
 		}
-		msleep(5);
+		msleep(20);
 
 		rc = mwl8k_feed_fw_image(priv, fw->data, fw->size);
 	} else {
@@ -823,8 +823,8 @@ static void mwl8k_encapsulate_tx_frame(struct sk_buff *skb)
 	/*
 	 * Make sure the packet header is in the DMA header format (4-address
 	 * without QoS), the necessary crypto padding between the header and the
-	 * payload has already been provided by mac80211, but it doesn't add tail
-	 * padding when HW crypto is enabled.
+	 * payload has already been provided by mac80211, but it doesn't add
+	 * tail padding when HW crypto is enabled.
 	 *
 	 * We have the following trailer padding requirements:
 	 * - WEP: 4 trailer bytes (ICV)
@@ -1487,9 +1487,8 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 		if (timeout) {
 			WARN_ON(priv->pending_tx_pkts);
-			if (retry) {
+			if (retry)
 				wiphy_notice(hw->wiphy, "tx rings drained\n");
-			}
 			break;
 		}
 
@@ -1649,8 +1648,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		/* Rate control is happening in the firmware.
 		 * Ensure no tx rate is being reported.
 		 */
-                info->status.rates[0].idx = -1;
-                info->status.rates[0].count = 1;
+		info->status.rates[0].idx = -1;
+		info->status.rates[0].count = 1;
 
 		if (MWL8K_TXD_SUCCESS(status))
 			info->flags |= IEEE80211_TX_STAT_ACK;
@@ -1688,7 +1687,7 @@ static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 }
 
 /* caller must hold priv->stream_lock when calling the stream functions */
-struct mwl8k_ampdu_stream *
+static struct mwl8k_ampdu_stream *
 mwl8k_add_stream(struct ieee80211_hw *hw, struct ieee80211_sta *sta, u8 tid)
 {
 	struct mwl8k_ampdu_stream *stream;
@@ -2657,7 +2656,7 @@ struct mwl8k_cmd_tx_power {
 	__le16 bw;
 	__le16 sub_ch;
 	__le16 power_level_list[MWL8K_TX_POWER_LEVEL_TOTAL];
-} __attribute__((packed));
+} __packed;
 
 static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
 				     struct ieee80211_conf *conf,
@@ -3520,13 +3519,13 @@ static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw,
 #define BASTREAM_FLAG_DIRECTION_UPSTREAM	0x00
 #define BASTREAM_FLAG_IMMEDIATE_TYPE		0x01
 
-enum {
+enum ba_stream_action_type {
 	MWL8K_BA_CREATE,
 	MWL8K_BA_UPDATE,
 	MWL8K_BA_DESTROY,
 	MWL8K_BA_FLUSH,
 	MWL8K_BA_CHECK,
-} ba_stream_action_type;
+};
 
 
 struct mwl8k_create_ba_stream {
@@ -3780,7 +3779,7 @@ struct mwl8k_cmd_update_encryption {
 	__u8 mac_addr[6];
 	__u8 encr_type;
 
-} __attribute__((packed));
+} __packed;
 
 struct mwl8k_cmd_set_key {
 	struct mwl8k_cmd_pkt header;
@@ -3800,7 +3799,7 @@ struct mwl8k_cmd_set_key {
 	__le16 tkip_tsc_low;
 	__le32 tkip_tsc_high;
 	__u8 mac_addr[6];
-} __attribute__((packed));
+} __packed;
 
 enum {
 	MWL8K_ENCR_ENABLE,
@@ -4502,7 +4501,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	u32 ap_legacy_rates;
+	u32 ap_legacy_rates = 0;
 	u8 ap_mcs_rates[16];
 	int rc;
 
-- 
1.5.4.1

