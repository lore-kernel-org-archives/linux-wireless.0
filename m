Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60433 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1AOTOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 14:14:06 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 2/2] ath9k:  Add 'misc' file to debugfs, fix queue indexes.
Date: Sat, 15 Jan 2011 11:13:49 -0800
Message-Id: <1295118829-7464-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1295118829-7464-1-git-send-email-greearb@candelatech.com>
References: <1295118829-7464-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add a misc file to show hardware op-mode, irq setup,
number of various types of VIFs and more.

Also, previous patches were using the wrong xmit queue
indexes.  Change to use the internal ath9k indexes instead
of the mac80211 queue indexes.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v3:  Update to use iterator to gather vif stats.  Print
   calculated bssid mask as well.

This patch requires previous debugfs patches that I have posted.

:100644 100644 b0cb792... 5005621... M	drivers/net/wireless/ath/ath9k/debug.c
 drivers/net/wireless/ath/ath9k/debug.c |  128 +++++++++++++++++++++++++++++---
 1 files changed, 116 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index b0cb792..5005621 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -595,10 +595,10 @@ static const struct file_operations fops_wiphy = {
 do {									\
 	len += snprintf(buf + len, size - len,				\
 			"%s%13u%11u%10u%10u\n", str,			\
-			(unsigned int)(sc->tx.txq[WME_AC_BE].elem),	\
-			(unsigned int)(sc->tx.txq[WME_AC_BK].elem),	\
-			(unsigned int)(sc->tx.txq[WME_AC_VI].elem),	\
-			(unsigned int)(sc->tx.txq[WME_AC_VO].elem));	\
+			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_BE].elem),	\
+			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_BK].elem),	\
+			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_VI].elem),	\
+			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_VO].elem));	\
 	if (len >= size)						\
 		goto done;						\
 } while(0)
@@ -607,10 +607,10 @@ do {									\
 do {									\
 	len += snprintf(buf + len, size - len,				\
 			"%s%13i%11i%10i%10i\n", str,			\
-			list_empty(&sc->tx.txq[WME_AC_BE].elem),	\
-			list_empty(&sc->tx.txq[WME_AC_BK].elem),	\
-			list_empty(&sc->tx.txq[WME_AC_VI].elem),	\
-			list_empty(&sc->tx.txq[WME_AC_VO].elem));	\
+			list_empty(&sc->tx.txq[ATH_TXQ_AC_BE].elem),	\
+			list_empty(&sc->tx.txq[ATH_TXQ_AC_BK].elem),	\
+			list_empty(&sc->tx.txq[ATH_TXQ_AC_VI].elem),	\
+			list_empty(&sc->tx.txq[ATH_TXQ_AC_VO].elem));	\
 	if (len >= size)						\
 		goto done;						\
 } while (0)
@@ -657,10 +657,10 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("hw-tx-proc-desc: ", txprocdesc);
 	len += snprintf(buf + len, size - len,
 			"%s%11p%11p%10p%10p\n", "txq-memory-address:",
-			&(sc->tx.txq[WME_AC_BE]),
-			&(sc->tx.txq[WME_AC_BK]),
-			&(sc->tx.txq[WME_AC_VI]),
-			&(sc->tx.txq[WME_AC_VO]));
+			&(sc->tx.txq[ATH_TXQ_AC_BE]),
+			&(sc->tx.txq[ATH_TXQ_AC_BK]),
+			&(sc->tx.txq[ATH_TXQ_AC_VI]),
+			&(sc->tx.txq[ATH_TXQ_AC_VO]));
 	if (len >= size)
 		goto done;
 
@@ -777,6 +777,99 @@ done:
 	return retval;
 }
 
+static ssize_t read_file_misc(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	char *buf;
+	unsigned int len = 0, size = 8000;
+	ssize_t retval = 0;
+	const char *tmp;
+	unsigned int reg;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	switch (sc->sc_ah->opmode) {
+	case  NL80211_IFTYPE_ADHOC:
+		tmp = "ADHOC";
+		break;
+	case  NL80211_IFTYPE_MESH_POINT:
+		tmp = "MESH";
+		break;
+	case  NL80211_IFTYPE_AP:
+		tmp = "AP";
+		break;
+	case  NL80211_IFTYPE_STATION:
+		tmp = "STATION";
+		break;
+	default:
+		tmp = "???";
+		break;
+	}
+
+	len += snprintf(buf + len, size - len,
+			"curbssid: %pM\n"
+			"OP-Mode: %s(%i)\n"
+			"Beacon-Timer-Register: 0x%x\n",
+			common->curbssid,
+			tmp, (int)(sc->sc_ah->opmode),
+			REG_READ(ah, AR_BEACON_PERIOD));
+
+	reg = REG_READ(ah, AR_TIMER_MODE);
+	len += snprintf(buf + len, size - len, "Timer-Mode-Register: 0x%x (",
+			reg);
+	if (reg & AR_TBTT_TIMER_EN)
+		len += snprintf(buf + len, size - len, "TBTT ");
+	if (reg & AR_DBA_TIMER_EN)
+		len += snprintf(buf + len, size - len, "DBA ");
+	if (reg & AR_SWBA_TIMER_EN)
+		len += snprintf(buf + len, size - len, "SWBA ");
+	if (reg & AR_HCF_TIMER_EN)
+		len += snprintf(buf + len, size - len, "HCF ");
+	if (reg & AR_TIM_TIMER_EN)
+		len += snprintf(buf + len, size - len, "TIM ");
+	if (reg & AR_DTIM_TIMER_EN)
+		len += snprintf(buf + len, size - len, "DTIM ");
+	len += snprintf(buf + len, size - len, ")\n");
+
+	reg = sc->sc_ah->imask;
+	len += snprintf(buf + len, size - len, "imask: 0x%x (", reg);
+	if (reg & ATH9K_INT_SWBA)
+		len += snprintf(buf + len, size - len, "SWBA ");
+	if (reg & ATH9K_INT_BMISS)
+		len += snprintf(buf + len, size - len, "BMISS ");
+	if (reg & ATH9K_INT_CST)
+		len += snprintf(buf + len, size - len, "CST ");
+	if (reg & ATH9K_INT_RX)
+		len += snprintf(buf + len, size - len, "RX ");
+	if (reg & ATH9K_INT_RXHP)
+		len += snprintf(buf + len, size - len, "RXHP ");
+	if (reg & ATH9K_INT_RXLP)
+		len += snprintf(buf + len, size - len, "RXLP ");
+	if (reg & ATH9K_INT_BB_WATCHDOG)
+		len += snprintf(buf + len, size - len, "BB_WATCHDOG ");
+	/* there are other IRQs if one wanted to add them. */
+	len += snprintf(buf + len, size - len, ")\n");
+
+	len += snprintf(buf + len, size - len,
+			"VIF Counts: AP: %hi STA: %hi MESH: %hi WDS: %hi"
+			" ADHOC: %hi nvifs: %hi beacon-vifs: %hi\n",
+			sc->naps, sc->nstations, sc->nmeshes, sc->nwds,
+			sc->nadhocs, sc->nvifs, sc->nbcnvifs);
+
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts)
 {
@@ -822,6 +915,13 @@ static const struct file_operations fops_stations = {
 	.llseek = default_llseek,
 };
 
+static const struct file_operations fops_misc = {
+	.read = read_file_misc,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
@@ -1063,6 +1163,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc, &fops_stations))
 		goto err;
 
+	if (!debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_misc))
+		goto err;
+
 	if (!debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy,
 			sc, &fops_recv))
 		goto err;
-- 
1.7.2.3

