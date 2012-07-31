Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2GaLfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:35:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] iwlwifi: report A-MPDU status
Date: Tue, 31 Jul 2012 13:35:41 +0200
Message-Id: <1343734541-14934-4-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133549_704085_20225A9F)
In-Reply-To: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the firmware will give us an A-MPDU bit and
only a single PHY information packet for all the
subframes in an A-MPDU, we can easily report the
minimal A-MPDU information for radiotap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h |    1 +
 drivers/net/wireless/iwlwifi/dvm/dev.h      |    1 +
 drivers/net/wireless/iwlwifi/dvm/rx.c       |   11 +++++++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index 4a361c5..c5d4490 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -1055,6 +1055,7 @@ struct iwl_wep_cmd {
 #define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
 #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
 #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
+#define RX_RES_PHY_FLAGS_AGG_MSK		cpu_to_le16(1 << 7)
 #define RX_RES_PHY_FLAGS_ANTENNA_MSK		0xf0
 #define RX_RES_PHY_FLAGS_ANTENNA_POS		4
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 054f728..8141f91 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -771,6 +771,7 @@ struct iwl_priv {
 	u8 agg_tids_count;
 
 	struct iwl_rx_phy_res last_phy_res;
+	u32 ampdu_ref;
 	bool last_phy_res_valid;
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index fee5cff..5a9c325 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -667,6 +667,7 @@ static int iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	priv->last_phy_res_valid = true;
+	priv->ampdu_ref++;
 	memcpy(&priv->last_phy_res, pkt->data,
 	       sizeof(struct iwl_rx_phy_res));
 	return 0;
@@ -981,6 +982,16 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
+	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_AGG_MSK) {
+		/*
+		 * We know which subframes of an A-MPDU belong
+		 * together since we get a single PHY response
+		 * from the firmware for all of them
+		 */
+		rx_status.flag |= RX_FLAG_AMPDU_DETAILS;
+		rx_status.ampdu_reference = priv->ampdu_ref;
+	}
+
 	/* Set up the HT phy flags */
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		rx_status.flag |= RX_FLAG_HT;
-- 
1.7.10.4

