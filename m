Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45311 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3JXHWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 03:22:07 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] ath9k: Fix TX99 config option usage
Date: Thu, 24 Oct 2013 12:47:41 +0530
Message-Id: <1382599061-16186-1-git-send-email-sujith@msujith.org> (sfid-20131024_092212_746519_6F2D7D80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use CONFIG_ATH9K_TX99 to properly enclose the tx99 code
and make sure that it is not compiled as part of the driver
when it is not selected. Move the tx99 code to a new file tx99.c
and also add ATH9K_DEBUGFS as a dependency in Kconfig.

This reduces the module size on platforms like OpenWrt where
ATH9K_DEBUGFS is selected, but TX99 might be disabled.

Cc: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  |   2 +-
 drivers/net/wireless/ath/ath9k/Makefile |   4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h  |  20 ++-
 drivers/net/wireless/ath/ath9k/debug.c  | 115 +-------------
 drivers/net/wireless/ath/ath9k/main.c   | 130 +---------------
 drivers/net/wireless/ath/ath9k/tx99.c   | 263 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c   |   4 +
 7 files changed, 290 insertions(+), 248 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/tx99.c

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 32f139e..3ffa4ea 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -86,7 +86,7 @@ config ATH9K_DFS_CERTIFIED
 
 config ATH9K_TX99
 	bool "Atheros ath9k TX99 testing support"
-	depends on CFG80211_CERTIFICATION_ONUS
+	depends on ATH9K_DEBUGFS && CFG80211_CERTIFICATION_ONUS
 	default n
 	---help---
 	  Say N. This should only be enabled on systems undergoing
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 6205ef5..f86a261 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -13,9 +13,9 @@ ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) += dfs_debug.o
-ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += \
-		dfs.o
+ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
 ath9k-$(CONFIG_PM_SLEEP) += wow.o
+ath9k-$(CONFIG_ATH9K_TX99) += tx99.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f48cfe8..62f5892 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -947,10 +947,25 @@ struct fft_sample_ht20_40 {
 	u8 data[SPECTRAL_HT20_40_NUM_BINS];
 } __packed;
 
-int ath9k_tx99_init(struct ath_softc *sc);
-void ath9k_tx99_deinit(struct ath_softc *sc);
+/********/
+/* TX99 */
+/********/
+
+#ifdef CONFIG_ATH9K_TX99
+void ath9k_tx99_init_debug(struct ath_softc *sc);
 int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
 		    struct ath_tx_control *txctl);
+#else
+static inline void ath9k_tx99_init_debug(struct ath_softc *sc)
+{
+}
+static inline int ath9k_tx99_send(struct ath_softc *sc,
+				  struct sk_buff *skb,
+				  struct ath_tx_control *txctl)
+{
+	return 0;
+}
+#endif /* CONFIG_ATH9K_TX99 */
 
 void ath9k_tasklet(unsigned long data);
 int ath_cabq_update(struct ath_softc *);
@@ -967,6 +982,7 @@ extern bool is_ath9k_unloaded;
 
 u8 ath9k_parse_mpdudensity(u8 mpdudensity);
 irqreturn_t ath_isr(int irq, void *dev);
+int ath_reset(struct ath_softc *sc);
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 83a2c59..2f7dccf 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1778,111 +1778,6 @@ void ath9k_deinit_debug(struct ath_softc *sc)
 	}
 }
 
-static ssize_t read_file_tx99(struct file *file, char __user *user_buf,
-			      size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	char buf[3];
-	unsigned int len;
-
-	len = sprintf(buf, "%d\n", sc->tx99_state);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
-			       size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	char buf[32];
-	bool start;
-	ssize_t len;
-	int r;
-
-	if (sc->nvifs > 1)
-		return -EOPNOTSUPP;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	if (strtobool(buf, &start))
-		return -EINVAL;
-
-	if (start == sc->tx99_state) {
-		if (!start)
-			return count;
-		ath_dbg(common, XMIT, "Resetting TX99\n");
-		ath9k_tx99_deinit(sc);
-	}
-
-	if (!start) {
-		ath9k_tx99_deinit(sc);
-		return count;
-	}
-
-	r = ath9k_tx99_init(sc);
-	if (r)
-		return r;
-
-	return count;
-}
-
-static const struct file_operations fops_tx99 = {
-	.read = read_file_tx99,
-	.write = write_file_tx99,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-static ssize_t read_file_tx99_power(struct file *file,
-				    char __user *user_buf,
-				    size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "%d (%d dBm)\n",
-		      sc->tx99_power,
-		      sc->tx99_power / 2);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static ssize_t write_file_tx99_power(struct file *file,
-				     const char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	int r;
-	u8 tx_power;
-
-	r = kstrtou8_from_user(user_buf, count, 0, &tx_power);
-	if (r)
-		return r;
-
-	if (tx_power > MAX_RATE_POWER)
-		return -EINVAL;
-
-	sc->tx99_power = tx_power;
-
-	ath9k_ps_wakeup(sc);
-	ath9k_hw_tx99_set_txpower(sc->sc_ah, sc->tx99_power);
-	ath9k_ps_restore(sc);
-
-	return count;
-}
-
-static const struct file_operations fops_tx99_power = {
-	.read = read_file_tx99_power,
-	.write = write_file_tx99_power,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1899,6 +1794,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 #endif
 
 	ath9k_dfs_init_debug(sc);
+	ath9k_tx99_init_debug(sc);
 
 	debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_dma);
@@ -1974,15 +1870,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("btcoex", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_btcoex);
 #endif
-	if (config_enabled(CONFIG_ATH9K_TX99) &&
-	    AR_SREV_9300_20_OR_LATER(ah)) {
-		debugfs_create_file("tx99", S_IRUSR | S_IWUSR,
-				    sc->debug.debugfs_phy, sc,
-				    &fops_tx99);
-		debugfs_create_file("tx99_power", S_IRUSR | S_IWUSR,
-				    sc->debug.debugfs_phy, sc,
-				    &fops_tx99_power);
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 74f452c..3d17398 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -627,7 +627,7 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-static int ath_reset(struct ath_softc *sc)
+int ath_reset(struct ath_softc *sc)
 {
 	int r;
 
@@ -2373,134 +2373,6 @@ static void ath9k_channel_switch_beacon(struct ieee80211_hw *hw,
 	sc->csa_vif = vif;
 }
 
-static void ath9k_tx99_stop(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	ath_drain_all_txq(sc);
-	ath_startrecv(sc);
-
-	ath9k_hw_set_interrupts(ah);
-	ath9k_hw_enable_interrupts(ah);
-
-	ieee80211_wake_queues(sc->hw);
-
-	kfree_skb(sc->tx99_skb);
-	sc->tx99_skb = NULL;
-	sc->tx99_state = false;
-
-	ath9k_hw_tx99_stop(sc->sc_ah);
-	ath_dbg(common, XMIT, "TX99 stopped\n");
-}
-
-static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
-{
-	static u8 PN9Data[] = {0xff, 0x87, 0xb8, 0x59, 0xb7, 0xa1, 0xcc, 0x24,
-			       0x57, 0x5e, 0x4b, 0x9c, 0x0e, 0xe9, 0xea, 0x50,
-			       0x2a, 0xbe, 0xb4, 0x1b, 0xb6, 0xb0, 0x5d, 0xf1,
-			       0xe6, 0x9a, 0xe3, 0x45, 0xfd, 0x2c, 0x53, 0x18,
-			       0x0c, 0xca, 0xc9, 0xfb, 0x49, 0x37, 0xe5, 0xa8,
-			       0x51, 0x3b, 0x2f, 0x61, 0xaa, 0x72, 0x18, 0x84,
-			       0x02, 0x23, 0x23, 0xab, 0x63, 0x89, 0x51, 0xb3,
-			       0xe7, 0x8b, 0x72, 0x90, 0x4c, 0xe8, 0xfb, 0xc0};
-	u32 len = 1200;
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_hdr *hdr;
-	struct ieee80211_tx_info *tx_info;
-	struct sk_buff *skb;
-
-	skb = alloc_skb(len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-
-	skb_put(skb, len);
-
-	memset(skb->data, 0, len);
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA);
-	hdr->duration_id = 0;
-
-	memcpy(hdr->addr1, hw->wiphy->perm_addr, ETH_ALEN);
-	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
-	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
-
-	hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
-
-	tx_info = IEEE80211_SKB_CB(skb);
-	memset(tx_info, 0, sizeof(*tx_info));
-	tx_info->band = hw->conf.chandef.chan->band;
-	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
-	tx_info->control.vif = sc->tx99_vif;
-
-	memcpy(skb->data + sizeof(*hdr), PN9Data, sizeof(PN9Data));
-
-	return skb;
-}
-
-void ath9k_tx99_deinit(struct ath_softc *sc)
-{
-	ath_reset(sc);
-
-	ath9k_ps_wakeup(sc);
-	ath9k_tx99_stop(sc);
-	ath9k_ps_restore(sc);
-}
-
-int ath9k_tx99_init(struct ath_softc *sc)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_tx_control txctl;
-	int r;
-
-	if (sc->sc_flags & SC_OP_INVALID) {
-		ath_err(common,
-			"driver is in invalid state unable to use TX99");
-		return -EINVAL;
-	}
-
-	sc->tx99_skb = ath9k_build_tx99_skb(sc);
-	if (!sc->tx99_skb)
-		return -ENOMEM;
-
-	memset(&txctl, 0, sizeof(txctl));
-	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
-
-	ath_reset(sc);
-
-	ath9k_ps_wakeup(sc);
-
-	ath9k_hw_disable_interrupts(ah);
-	atomic_set(&ah->intr_ref_cnt, -1);
-	ath_drain_all_txq(sc);
-	ath_stoprecv(sc);
-
-	sc->tx99_state = true;
-
-	ieee80211_stop_queues(hw);
-
-	if (sc->tx99_power == MAX_RATE_POWER + 1)
-		sc->tx99_power = MAX_RATE_POWER;
-
-	ath9k_hw_tx99_set_txpower(ah, sc->tx99_power);
-	r = ath9k_tx99_send(sc, sc->tx99_skb, &txctl);
-	if (r) {
-		ath_dbg(common, XMIT, "Failed to xmit TX99 skb\n");
-		return r;
-	}
-
-	ath_dbg(common, XMIT, "TX99 xmit started using %d ( %ddBm)\n",
-		sc->tx99_power,
-		sc->tx99_power / 2);
-
-	/* We leave the harware awake as it will be chugging on */
-
-	return 0;
-}
-
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
new file mode 100644
index 0000000..6668197
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -0,0 +1,263 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+
+static void ath9k_tx99_stop(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_drain_all_txq(sc);
+	ath_startrecv(sc);
+
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
+
+	ieee80211_wake_queues(sc->hw);
+
+	kfree_skb(sc->tx99_skb);
+	sc->tx99_skb = NULL;
+	sc->tx99_state = false;
+
+	ath9k_hw_tx99_stop(sc->sc_ah);
+	ath_dbg(common, XMIT, "TX99 stopped\n");
+}
+
+static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
+{
+	static u8 PN9Data[] = {0xff, 0x87, 0xb8, 0x59, 0xb7, 0xa1, 0xcc, 0x24,
+			       0x57, 0x5e, 0x4b, 0x9c, 0x0e, 0xe9, 0xea, 0x50,
+			       0x2a, 0xbe, 0xb4, 0x1b, 0xb6, 0xb0, 0x5d, 0xf1,
+			       0xe6, 0x9a, 0xe3, 0x45, 0xfd, 0x2c, 0x53, 0x18,
+			       0x0c, 0xca, 0xc9, 0xfb, 0x49, 0x37, 0xe5, 0xa8,
+			       0x51, 0x3b, 0x2f, 0x61, 0xaa, 0x72, 0x18, 0x84,
+			       0x02, 0x23, 0x23, 0xab, 0x63, 0x89, 0x51, 0xb3,
+			       0xe7, 0x8b, 0x72, 0x90, 0x4c, 0xe8, 0xfb, 0xc0};
+	u32 len = 1200;
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *tx_info;
+	struct sk_buff *skb;
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_put(skb, len);
+
+	memset(skb->data, 0, len);
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA);
+	hdr->duration_id = 0;
+
+	memcpy(hdr->addr1, hw->wiphy->perm_addr, ETH_ALEN);
+	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
+	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
+
+	hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
+
+	tx_info = IEEE80211_SKB_CB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
+	tx_info->band = hw->conf.chandef.chan->band;
+	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
+	tx_info->control.vif = sc->tx99_vif;
+
+	memcpy(skb->data + sizeof(*hdr), PN9Data, sizeof(PN9Data));
+
+	return skb;
+}
+
+static void ath9k_tx99_deinit(struct ath_softc *sc)
+{
+	ath_reset(sc);
+
+	ath9k_ps_wakeup(sc);
+	ath9k_tx99_stop(sc);
+	ath9k_ps_restore(sc);
+}
+
+static int ath9k_tx99_init(struct ath_softc *sc)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_tx_control txctl;
+	int r;
+
+	if (sc->sc_flags & SC_OP_INVALID) {
+		ath_err(common,
+			"driver is in invalid state unable to use TX99");
+		return -EINVAL;
+	}
+
+	sc->tx99_skb = ath9k_build_tx99_skb(sc);
+	if (!sc->tx99_skb)
+		return -ENOMEM;
+
+	memset(&txctl, 0, sizeof(txctl));
+	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
+
+	ath_reset(sc);
+
+	ath9k_ps_wakeup(sc);
+
+	ath9k_hw_disable_interrupts(ah);
+	atomic_set(&ah->intr_ref_cnt, -1);
+	ath_drain_all_txq(sc);
+	ath_stoprecv(sc);
+
+	sc->tx99_state = true;
+
+	ieee80211_stop_queues(hw);
+
+	if (sc->tx99_power == MAX_RATE_POWER + 1)
+		sc->tx99_power = MAX_RATE_POWER;
+
+	ath9k_hw_tx99_set_txpower(ah, sc->tx99_power);
+	r = ath9k_tx99_send(sc, sc->tx99_skb, &txctl);
+	if (r) {
+		ath_dbg(common, XMIT, "Failed to xmit TX99 skb\n");
+		return r;
+	}
+
+	ath_dbg(common, XMIT, "TX99 xmit started using %d ( %ddBm)\n",
+		sc->tx99_power,
+		sc->tx99_power / 2);
+
+	/* We leave the harware awake as it will be chugging on */
+
+	return 0;
+}
+
+static ssize_t read_file_tx99(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[3];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", sc->tx99_state);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	char buf[32];
+	bool start;
+	ssize_t len;
+	int r;
+
+	if (sc->nvifs > 1)
+		return -EOPNOTSUPP;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	if (strtobool(buf, &start))
+		return -EINVAL;
+
+	if (start == sc->tx99_state) {
+		if (!start)
+			return count;
+		ath_dbg(common, XMIT, "Resetting TX99\n");
+		ath9k_tx99_deinit(sc);
+	}
+
+	if (!start) {
+		ath9k_tx99_deinit(sc);
+		return count;
+	}
+
+	r = ath9k_tx99_init(sc);
+	if (r)
+		return r;
+
+	return count;
+}
+
+static const struct file_operations fops_tx99 = {
+	.read = read_file_tx99,
+	.write = write_file_tx99,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_tx99_power(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d (%d dBm)\n",
+		      sc->tx99_power,
+		      sc->tx99_power / 2);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_tx99_power(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	int r;
+	u8 tx_power;
+
+	r = kstrtou8_from_user(user_buf, count, 0, &tx_power);
+	if (r)
+		return r;
+
+	if (tx_power > MAX_RATE_POWER)
+		return -EINVAL;
+
+	sc->tx99_power = tx_power;
+
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_tx99_set_txpower(sc->sc_ah, sc->tx99_power);
+	ath9k_ps_restore(sc);
+
+	return count;
+}
+
+static const struct file_operations fops_tx99_power = {
+	.read = read_file_tx99_power,
+	.write = write_file_tx99_power,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+void ath9k_tx99_init_debug(struct ath_softc *sc)
+{
+	if (!AR_SREV_9300_20_OR_LATER(sc->sc_ah))
+		return;
+
+	debugfs_create_file("tx99", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc,
+			    &fops_tx99);
+	debugfs_create_file("tx99_power", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc,
+			    &fops_tx99_power);
+}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 09cdbcd..95f6c5a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2749,6 +2749,8 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 	}
 }
 
+#ifdef CONFIG_ATH9K_TX99
+
 int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
 		    struct ath_tx_control *txctl)
 {
@@ -2791,3 +2793,5 @@ int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
 
 	return 0;
 }
+
+#endif /* CONFIG_ATH9K_TX99 */
-- 
1.8.4.1

