Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38144 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3BMOnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 09:43:46 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: victorg@ti.com, kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC] ath9k: add basic DFS dummy support and simulation debug file
Date: Wed, 13 Feb 2013 15:43:32 +0100
Message-Id: <1360766612-24459-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130213_154351_528690_FA920869)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is not intended to be applied upstream, but demonstrates
how the DFS interface to mac80211 works. I've used this while working
on the nl80211/mac80211 DFS support.

A driver interfacing to mac80211 has to:

 * add interface combinations based on its DFS support (20 MHz/single
   interface only for now)
 * set WIPHY_FLAG_HAS_RADAR_DETECT
 * call ieee80211_radar_detected() when a radar has been detected
 * enable radar detection when config() is called with
   hw->conf.radar_enabled on.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 drivers/net/wireless/ath/ath9k/debug.c |   19 ++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c  |   33 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/main.c  |    2 ++
 3 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 3714b97..526155e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -88,6 +88,23 @@ static const struct file_operations fops_debug = {
 
 #define DMA_BUF_LEN 1024
 
+static ssize_t write_file_simulate_radar(struct file *file, const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+
+	ieee80211_radar_detected(sc->hw);
+
+	return count;
+}
+
+static const struct file_operations fops_simulate_radar = {
+	.write = write_file_simulate_radar,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_tx_chainmask(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
@@ -2046,6 +2063,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    sc->debug.debugfs_phy, sc, &fops_rx_chainmask);
 	debugfs_create_file("tx_chainmask", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_tx_chainmask);
+	debugfs_create_file("simulate_radar", S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_simulate_radar);
 	debugfs_create_file("disable_ani", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_disable_ani);
 	debugfs_create_bool("paprd", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af932c9..6733e3e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -727,12 +727,28 @@ static const struct ieee80211_iface_limit if_limits[] = {
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
-static const struct ieee80211_iface_combination if_comb = {
-	.limits = if_limits,
-	.n_limits = ARRAY_SIZE(if_limits),
-	.max_interfaces = 2048,
-	.num_different_channels = 1,
-	.beacon_int_infra_match = true,
+
+static const struct ieee80211_iface_limit if_dfs_limits[] = {
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) },
+};
+
+static const struct ieee80211_iface_combination if_comb[] = {
+	{
+		.limits = if_limits,
+		.n_limits = ARRAY_SIZE(if_limits),
+		.max_interfaces = 2048,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+	},
+	{
+		.limits = if_dfs_limits,
+		.n_limits = ARRAY_SIZE(if_dfs_limits),
+		.max_interfaces = 1,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+		.radar_detect_widths =	BIT(NL80211_CHAN_NO_HT) |
+					BIT(NL80211_CHAN_HT20),
+	}
 };
 
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
@@ -763,8 +779,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->iface_combinations = &if_comb;
-	hw->wiphy->n_iface_combinations = 1;
+	hw->wiphy->iface_combinations = if_comb;
+	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 
 	if (AR_SREV_5416(sc->sc_ah))
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -772,6 +788,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	hw->wiphy->flags |= WIPHY_FLAG_HAS_RADAR_DETECT;
 
 #ifdef CONFIG_PM_SLEEP
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5432f12..8d5190b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1195,6 +1195,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		if (ah->curchan)
 			old_pos = ah->curchan - &ah->channels[0];
 
+		/* TODO: enable radar detection when hw->conf.radar_enabled is enabled */
+
 		ath_dbg(common, CONFIG, "Set channel: %d MHz type: %d\n",
 			curchan->center_freq, conf->channel_type);
 
-- 
1.7.10.4

