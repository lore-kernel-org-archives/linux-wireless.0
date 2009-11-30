Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57144 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZK3RLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:11:39 -0500
Date: Mon, 30 Nov 2009 18:11:44 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 02/12] mwl8k: fix UPDATE_STADB command struct legacy_rates array length
Message-ID: <20091130171144.GE20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There exist 12 802.11b/g rates, but mwl8k supports two additional
(non-standard) rates, and includes those rates in rate bitmasks and
in its internal rate table that hardware rate indices index.

Commit "mwl8k: report rate and other information for received frames"
added one of the nonstandard rates to the mwl8k_rates table to make
the OFDM rates in the table line up with the rate indices that are
reported in the receive descriptor (so that we can just simply copy
the receive descriptor rate index into ieee80211_rx_status::rate_idx)
and bumped MWL8K_IEEE_LEGACY_DATA_RATES from 12 to 13, but this
screwed up the UPDATE_STADB command struct layout, as it also uses
that define, for its legacy_rates array.

To avoid having to convert rate indices and legacy rate bitmaps (e.g.
ieee80211_bss_conf::basic_rates) between the 12-rate mac80211 format
and the 14-rate mwl8k format, we'll report all 14 rates in our wiphy's
band, but filter out the nonstandard ones e.g. in the case of the
UPDATE_STADB command which only accepts 12 rates.

In the commands that accept 14 rates (SET_AID, SET_RATE), replace the
use of the MWL8K_RATE_INDEX_MAX_ARRAY define in the command struct by
the constant 14, to make it clearer that these commands accept 14 rates.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   51 ++++++++++-------------------------------
 1 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7b136e7..a72ee1f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -184,7 +184,7 @@ struct mwl8k_priv {
 	/* PHY parameters */
 	struct ieee80211_supported_band band;
 	struct ieee80211_channel channels[14];
-	struct ieee80211_rate rates[13];
+	struct ieee80211_rate rates[14];
 
 	bool radio_on;
 	bool radio_short_preamble;
@@ -220,15 +220,6 @@ struct mwl8k_vif {
 	u8	bssid[ETH_ALEN];
 	u8	mac_addr[ETH_ALEN];
 
-	/*
-	 * Subset of supported legacy rates.
-	 * Intersection of AP and STA supported rates.
-	 */
-	struct ieee80211_rate legacy_rates[13];
-
-	/* number of supported legacy rates */
-	u8	legacy_nrates;
-
 	 /* Index into station database.Returned by update_sta_db call */
 	u8	peer_id;
 
@@ -266,6 +257,11 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 	{ .bitrate = 360, .hw_value = 72, },
 	{ .bitrate = 480, .hw_value = 96, },
 	{ .bitrate = 540, .hw_value = 108, },
+	{ .bitrate = 720, .hw_value = 144, },
+};
+
+static const u8 mwl8k_rateids[12] = {
+	2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108,
 };
 
 /* Set or get info from Firmware */
@@ -633,8 +629,6 @@ struct ewc_ht_info {
 /* Peer Entry flags - used to define the type of the peer node */
 #define MWL8K_PEER_TYPE_ACCESSPOINT	2
 
-#define MWL8K_IEEE_LEGACY_DATA_RATES	13
-
 struct peer_capability_info {
 	/* Peer type - AP vs. STA.  */
 	__u8	peer_type;
@@ -651,7 +645,7 @@ struct peer_capability_info {
 	struct ewc_ht_info	ewc_info;
 
 	/* Legacy rate table. Intersection of our rates and peer rates.  */
-	__u8	legacy_rates[MWL8K_IEEE_LEGACY_DATA_RATES];
+	__u8	legacy_rates[12];
 
 	/* HT rate table. Intersection of our rates and peer rates.  */
 	__u8	ht_rates[16];
@@ -2514,9 +2508,7 @@ static int mwl8k_cmd_update_sta_db(struct ieee80211_hw *hw,
 	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
 	struct mwl8k_cmd_update_sta_db *cmd;
 	struct peer_capability_info *peer_info;
-	struct ieee80211_rate *bitrates = mv_vif->legacy_rates;
 	int rc;
-	__u8 count, *rates;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
@@ -2535,13 +2527,11 @@ static int mwl8k_cmd_update_sta_db(struct ieee80211_hw *hw,
 		/* Build peer_info block */
 		peer_info->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
 		peer_info->basic_caps = cpu_to_le16(info->assoc_capability);
+		memcpy(peer_info->legacy_rates, mwl8k_rateids,
+		       sizeof(mwl8k_rateids));
 		peer_info->interop = 1;
 		peer_info->amsdu_enabled = 0;
 
-		rates = peer_info->legacy_rates;
-		for (count = 0; count < mv_vif->legacy_nrates; count++)
-			rates[count] = bitrates[count].hw_value;
-
 		rc = mwl8k_post_cmd(hw, &cmd->header);
 		if (rc == 0)
 			mv_vif->peer_id = peer_info->station_id;
@@ -2564,8 +2554,6 @@ static int mwl8k_cmd_update_sta_db(struct ieee80211_hw *hw,
 /*
  * CMD_SET_AID.
  */
-#define MWL8K_RATE_INDEX_MAX_ARRAY			14
-
 #define MWL8K_FRAME_PROT_DISABLED			0x00
 #define MWL8K_FRAME_PROT_11G				0x07
 #define MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY		0x02
@@ -2578,7 +2566,7 @@ struct mwl8k_cmd_update_set_aid {
 	 /* AP's MAC address (BSSID) */
 	__u8	bssid[ETH_ALEN];
 	__le16	protection_mode;
-	__u8	supp_rates[MWL8K_RATE_INDEX_MAX_ARRAY];
+	__u8	supp_rates[14];
 } __attribute__((packed));
 
 static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
@@ -2587,8 +2575,6 @@ static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
 	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
 	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
 	struct mwl8k_cmd_update_set_aid *cmd;
-	struct ieee80211_rate *bitrates = mv_vif->legacy_rates;
-	int count;
 	u16 prot_mode;
 	int rc;
 
@@ -2620,8 +2606,7 @@ static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
 	}
 	cmd->protection_mode = cpu_to_le16(prot_mode);
 
-	for (count = 0; count < mv_vif->legacy_nrates; count++)
-		cmd->supp_rates[count] = bitrates[count].hw_value;
+	memcpy(cmd->supp_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2634,7 +2619,7 @@ static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
  */
 struct mwl8k_cmd_update_rateset {
 	struct	mwl8k_cmd_pkt header;
-	__u8	legacy_rates[MWL8K_RATE_INDEX_MAX_ARRAY];
+	__u8	legacy_rates[14];
 
 	/* Bitmap for supported MCS codes.  */
 	__u8	mcs_set[16];
@@ -2644,10 +2629,7 @@ struct mwl8k_cmd_update_rateset {
 static int mwl8k_update_rateset(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif)
 {
-	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
 	struct mwl8k_cmd_update_rateset *cmd;
-	struct ieee80211_rate *bitrates = mv_vif->legacy_rates;
-	int count;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -2656,9 +2638,7 @@ static int mwl8k_update_rateset(struct ieee80211_hw *hw,
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_RATE);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-
-	for (count = 0; count < mv_vif->legacy_nrates; count++)
-		cmd->legacy_rates[count] = bitrates[count].hw_value;
+	memcpy(cmd->legacy_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2931,11 +2911,6 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	/* Back pointer to parent config block */
 	mwl8k_vif->priv = priv;
 
-	/* Setup initial PHY parameters */
-	memcpy(mwl8k_vif->legacy_rates,
-		priv->rates, sizeof(mwl8k_vif->legacy_rates));
-	mwl8k_vif->legacy_nrates = ARRAY_SIZE(priv->rates);
-
 	/* Set Initial sequence number to zero */
 	mwl8k_vif->seqno = 0;
 
-- 
1.5.6.4
