Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25428 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2BMGUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 01:20:53 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20280.43962.403799.188541@gargle.gargle.HOWL> (sfid-20120213_072057_133562_0A749150)
Date: Mon, 13 Feb 2012 11:50:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch merges the 'wiphy' and 'misc' debugfs files
and consolidates the information.

Information about the current channel and other HT parameters
can be obtained from both mac80211 and iw. Remove such
redundant data.

The reset statistics have been removed, they will be re-added in
a subsequent patch (in a new debugfs file).

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |  224 +++++++++-----------------------
 1 files changed, 64 insertions(+), 160 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index dc45cf9..b2c6069 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -451,109 +451,6 @@ static const struct file_operations fops_interrupt = {
 	.llseek = default_llseek,
 };
 
-static const char *channel_type_str(enum nl80211_channel_type t)
-{
-	switch (t) {
-	case NL80211_CHAN_NO_HT:
-		return "no ht";
-	case NL80211_CHAN_HT20:
-		return "ht20";
-	case NL80211_CHAN_HT40MINUS:
-		return "ht40-";
-	case NL80211_CHAN_HT40PLUS:
-		return "ht40+";
-	default:
-		return "???";
-	}
-}
-
-static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
-			       size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ieee80211_channel *chan = sc->hw->conf.channel;
-	struct ieee80211_conf *conf = &(sc->hw->conf);
-	char buf[512];
-	unsigned int len = 0;
-	u8 addr[ETH_ALEN];
-	u32 tmp;
-
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%s (chan=%d  center-freq: %d MHz  channel-type: %d (%s))\n",
-			wiphy_name(sc->hw->wiphy),
-			ieee80211_frequency_to_channel(chan->center_freq),
-			chan->center_freq,
-			conf->channel_type,
-			channel_type_str(conf->channel_type));
-
-	ath9k_ps_wakeup(sc);
-	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
-	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"addr: %pM\n", addr);
-	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_BSSMSKL), addr);
-	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"addrmask: %pM\n", addr);
-	tmp = ath9k_hw_getrxfilter(sc->sc_ah);
-	ath9k_ps_restore(sc);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"rfilt: 0x%x", tmp);
-	if (tmp & ATH9K_RX_FILTER_UCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " UCAST");
-	if (tmp & ATH9K_RX_FILTER_MCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " MCAST");
-	if (tmp & ATH9K_RX_FILTER_BCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " BCAST");
-	if (tmp & ATH9K_RX_FILTER_CONTROL)
-		len += snprintf(buf + len, sizeof(buf) - len, " CONTROL");
-	if (tmp & ATH9K_RX_FILTER_BEACON)
-		len += snprintf(buf + len, sizeof(buf) - len, " BEACON");
-	if (tmp & ATH9K_RX_FILTER_PROM)
-		len += snprintf(buf + len, sizeof(buf) - len, " PROM");
-	if (tmp & ATH9K_RX_FILTER_PROBEREQ)
-		len += snprintf(buf + len, sizeof(buf) - len, " PROBEREQ");
-	if (tmp & ATH9K_RX_FILTER_PHYERR)
-		len += snprintf(buf + len, sizeof(buf) - len, " PHYERR");
-	if (tmp & ATH9K_RX_FILTER_MYBEACON)
-		len += snprintf(buf + len, sizeof(buf) - len, " MYBEACON");
-	if (tmp & ATH9K_RX_FILTER_COMP_BAR)
-		len += snprintf(buf + len, sizeof(buf) - len, " COMP_BAR");
-	if (tmp & ATH9K_RX_FILTER_PSPOLL)
-		len += snprintf(buf + len, sizeof(buf) - len, " PSPOLL");
-	if (tmp & ATH9K_RX_FILTER_PHYRADAR)
-		len += snprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
-	if (tmp & ATH9K_RX_FILTER_MCAST_BCAST_ALL)
-		len += snprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL");
-
-	len += snprintf(buf + len, sizeof(buf) - len,
-		       "\n\nReset causes:\n"
-		       "  baseband hang: %d\n"
-		       "  baseband watchdog: %d\n"
-		       "  fatal hardware error interrupt: %d\n"
-		       "  tx hardware error: %d\n"
-		       "  tx path hang: %d\n"
-		       "  pll rx hang: %d\n",
-		       sc->debug.stats.reset[RESET_TYPE_BB_HANG],
-		       sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG],
-		       sc->debug.stats.reset[RESET_TYPE_FATAL_INT],
-		       sc->debug.stats.reset[RESET_TYPE_TX_ERROR],
-		       sc->debug.stats.reset[RESET_TYPE_TX_HANG],
-		       sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
-
-	if (len > sizeof(buf))
-		len = sizeof(buf);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static const struct file_operations fops_wiphy = {
-	.read = read_file_wiphy,
-	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 #define PR_QNUM(_n) sc->tx.txq_map[_n]->axq_qnum
 #define PR(str, elem)							\
 	do {								\
@@ -763,84 +660,93 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_hw *hw = sc->hw;
-	char *buf;
-	unsigned int len = 0, size = 8000;
+	struct ath9k_vif_iter_data iter_data;
+	char buf[512];
+	unsigned int len = 0;
 	ssize_t retval = 0;
 	unsigned int reg;
-	struct ath9k_vif_iter_data iter_data;
+	u32 rxfilter;
 
-	ath9k_calculate_iter_data(hw, NULL, &iter_data);
-	
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"BSSID: %pM\n", common->curbssid);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"BSSID-MASK: %pM\n", common->bssidmask);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"OPMODE: %s\n", ath_opmode_to_string(sc->sc_ah->opmode));
 
 	ath9k_ps_wakeup(sc);
-	len += snprintf(buf + len, size - len,
-			"curbssid: %pM\n"
-			"OP-Mode: %s(%i)\n"
-			"Beacon-Timer-Register: 0x%x\n",
-			common->curbssid,
-			ath_opmode_to_string(sc->sc_ah->opmode),
-			(int)(sc->sc_ah->opmode),
-			REG_READ(ah, AR_BEACON_PERIOD));
-
-	reg = REG_READ(ah, AR_TIMER_MODE);
+	rxfilter = ath9k_hw_getrxfilter(sc->sc_ah);
 	ath9k_ps_restore(sc);
-	len += snprintf(buf + len, size - len, "Timer-Mode-Register: 0x%x (",
-			reg);
-	if (reg & AR_TBTT_TIMER_EN)
-		len += snprintf(buf + len, size - len, "TBTT ");
-	if (reg & AR_DBA_TIMER_EN)
-		len += snprintf(buf + len, size - len, "DBA ");
-	if (reg & AR_SWBA_TIMER_EN)
-		len += snprintf(buf + len, size - len, "SWBA ");
-	if (reg & AR_HCF_TIMER_EN)
-		len += snprintf(buf + len, size - len, "HCF ");
-	if (reg & AR_TIM_TIMER_EN)
-		len += snprintf(buf + len, size - len, "TIM ");
-	if (reg & AR_DTIM_TIMER_EN)
-		len += snprintf(buf + len, size - len, "DTIM ");
-	len += snprintf(buf + len, size - len, ")\n");
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"RXFILTER: 0x%x", rxfilter);
+
+	if (rxfilter & ATH9K_RX_FILTER_UCAST)
+		len += snprintf(buf + len, sizeof(buf) - len, " UCAST");
+	if (rxfilter & ATH9K_RX_FILTER_MCAST)
+		len += snprintf(buf + len, sizeof(buf) - len, " MCAST");
+	if (rxfilter & ATH9K_RX_FILTER_BCAST)
+		len += snprintf(buf + len, sizeof(buf) - len, " BCAST");
+	if (rxfilter & ATH9K_RX_FILTER_CONTROL)
+		len += snprintf(buf + len, sizeof(buf) - len, " CONTROL");
+	if (rxfilter & ATH9K_RX_FILTER_BEACON)
+		len += snprintf(buf + len, sizeof(buf) - len, " BEACON");
+	if (rxfilter & ATH9K_RX_FILTER_PROM)
+		len += snprintf(buf + len, sizeof(buf) - len, " PROM");
+	if (rxfilter & ATH9K_RX_FILTER_PROBEREQ)
+		len += snprintf(buf + len, sizeof(buf) - len, " PROBEREQ");
+	if (rxfilter & ATH9K_RX_FILTER_PHYERR)
+		len += snprintf(buf + len, sizeof(buf) - len, " PHYERR");
+	if (rxfilter & ATH9K_RX_FILTER_MYBEACON)
+		len += snprintf(buf + len, sizeof(buf) - len, " MYBEACON");
+	if (rxfilter & ATH9K_RX_FILTER_COMP_BAR)
+		len += snprintf(buf + len, sizeof(buf) - len, " COMP_BAR");
+	if (rxfilter & ATH9K_RX_FILTER_PSPOLL)
+		len += snprintf(buf + len, sizeof(buf) - len, " PSPOLL");
+	if (rxfilter & ATH9K_RX_FILTER_PHYRADAR)
+		len += snprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
+	if (rxfilter & ATH9K_RX_FILTER_MCAST_BCAST_ALL)
+		len += snprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL");
+	if (rxfilter & ATH9K_RX_FILTER_CONTROL_WRAPPER)
+		len += snprintf(buf + len, sizeof(buf) - len, " CONTROL_WRAPPER");
+
+	len += snprintf(buf + len, sizeof(buf) - len, "\n");
 
 	reg = sc->sc_ah->imask;
-	len += snprintf(buf + len, size - len, "imask: 0x%x (", reg);
+
+	len += snprintf(buf + len, sizeof(buf) - len, "INTERRUPT-MASK: 0x%x", reg);
+
 	if (reg & ATH9K_INT_SWBA)
-		len += snprintf(buf + len, size - len, "SWBA ");
+		len += snprintf(buf + len, sizeof(buf) - len, " SWBA");
 	if (reg & ATH9K_INT_BMISS)
-		len += snprintf(buf + len, size - len, "BMISS ");
+		len += snprintf(buf + len, sizeof(buf) - len, " BMISS");
 	if (reg & ATH9K_INT_CST)
-		len += snprintf(buf + len, size - len, "CST ");
+		len += snprintf(buf + len, sizeof(buf) - len, " CST");
 	if (reg & ATH9K_INT_RX)
-		len += snprintf(buf + len, size - len, "RX ");
+		len += snprintf(buf + len, sizeof(buf) - len, " RX");
 	if (reg & ATH9K_INT_RXHP)
-		len += snprintf(buf + len, size - len, "RXHP ");
+		len += snprintf(buf + len, sizeof(buf) - len, " RXHP");
 	if (reg & ATH9K_INT_RXLP)
-		len += snprintf(buf + len, size - len, "RXLP ");
+		len += snprintf(buf + len, sizeof(buf) - len, " RXLP");
 	if (reg & ATH9K_INT_BB_WATCHDOG)
-		len += snprintf(buf + len, size - len, "BB_WATCHDOG ");
-	/* there are other IRQs if one wanted to add them. */
-	len += snprintf(buf + len, size - len, ")\n");
+		len += snprintf(buf + len, sizeof(buf) - len, " BB_WATCHDOG");
 
-	len += snprintf(buf + len, size - len,
-			"VIF Counts: AP: %i STA: %i MESH: %i WDS: %i"
-			" ADHOC: %i OTHER: %i nvifs: %hi beacon-vifs: %hi\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "\n");
+
+	ath9k_calculate_iter_data(hw, NULL, &iter_data);
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"VIF-COUNTS: AP: %i STA: %i MESH: %i WDS: %i"
+			" ADHOC: %i OTHER: %i TOTAL: %hi BEACON-VIF: %hi\n",
 			iter_data.naps, iter_data.nstations, iter_data.nmeshes,
 			iter_data.nwds, iter_data.nadhocs, iter_data.nothers,
 			sc->nvifs, sc->nbcnvifs);
 
-	len += snprintf(buf + len, size - len,
-			"Calculated-BSSID-Mask: %pM\n",
-			iter_data.mask);
-
-	if (len > size)
-		len = size;
+	if (len > sizeof(buf))
+		len = sizeof(buf);
 
 	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
 	return retval;
 }
 
@@ -1637,8 +1543,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_dma);
 	debugfs_create_file("interrupt", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_interrupt);
-	debugfs_create_file("wiphy", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			    sc, &fops_wiphy);
 	debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_xmit);
 	debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy, sc,
-- 
1.7.9

