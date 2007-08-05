Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:12966 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbXHEXSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 19:18:47 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: use correct preambles for RTS/CTS frames
Message-Id: <20070805231845.657BA7B409F@zog.reactivated.net>
Date: Mon,  6 Aug 2007 00:18:45 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This uses the new mac80211 ERP change notifications to correctly program
the RTS_CTS register to use short preambles only when appropriate for
device-generated frames.

This isn't quite as complete as the softmac version, where TX is stopped
until the register has been programmed. That functionality requires
further mac80211 work and will be added later.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
---
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.c |   18 +++++++++
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.h |   10 +++++
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c  |   44 +++++++++++++++++++++-
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.h  |    7 +++
 4 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
index 4513675..bfd6a00 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
@@ -1002,6 +1002,24 @@ static int set_mandatory_rates(struct zd_chip *chip, int mode)
 	return zd_iowrite32_locked(chip, rates, CR_MANDATORY_RATE_TBL);
 }
 
+int zd_chip_set_rts_cts_rate_locked(struct zd_chip *chip,
+				    int preamble)
+{
+	u32 value = 0;
+
+	dev_dbg_f(zd_chip_dev(chip), "preamble=%x\n", preamble);
+	value |= preamble << RTSCTS_SH_RTS_PMB_TYPE;
+	value |= preamble << RTSCTS_SH_CTS_PMB_TYPE;
+
+	/* We always send 11M RTS/self-CTS messages, like the vendor driver. */
+	value |= ZD_PURE_RATE(ZD_CCK_RATE_11M) << RTSCTS_SH_RTS_RATE;
+	value |= ZD_RX_CCK << RTSCTS_SH_RTS_MOD_TYPE;
+	value |= ZD_PURE_RATE(ZD_CCK_RATE_11M) << RTSCTS_SH_CTS_RATE;
+	value |= ZD_RX_CCK << RTSCTS_SH_CTS_MOD_TYPE;
+
+	return zd_iowrite32_locked(chip, value, CR_RTS_CTS_RATE);
+}
+
 int zd_chip_enable_hwint(struct zd_chip *chip)
 {
 	int r;
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
index 1145827..96c48bb 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
@@ -460,6 +460,15 @@ enum {
 #define CR_MANDATORY_RATE_TBL		CTL_REG(0x0634)
 #define CR_RTS_CTS_RATE			CTL_REG(0x0638)
 
+/* These are all bit indexes in CR_RTS_CTS_RATE, so remember to shift. */
+#define RTSCTS_SH_RTS_RATE		0
+#define RTSCTS_SH_EXP_CTS_RATE		4
+#define RTSCTS_SH_RTS_MOD_TYPE		8
+#define RTSCTS_SH_RTS_PMB_TYPE		9
+#define RTSCTS_SH_CTS_RATE		16
+#define RTSCTS_SH_CTS_MOD_TYPE		24
+#define RTSCTS_SH_CTS_PMB_TYPE		25
+
 #define CR_WEP_PROTECT			CTL_REG(0x063C)
 #define CR_RX_THRESHOLD			CTL_REG(0x0640)
 
@@ -833,6 +842,7 @@ void zd_chip_disable_rxtx(struct zd_chip *chip);
 int zd_chip_enable_hwint(struct zd_chip *chip);
 int zd_chip_disable_hwint(struct zd_chip *chip);
 int zd_chip_generic_patch_6m_band(struct zd_chip *chip, int channel);
+int zd_chip_set_rts_cts_rate_locked(struct zd_chip *chip, int preamble);
 
 static inline int zd_get_encryption_type(struct zd_chip *chip, u32 *type)
 {
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
index cef5492..39a26c1 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
@@ -304,6 +304,7 @@ static int zd_op_stop(struct ieee80211_hw *hw)
 
 	zd_chip_disable_rxtx(chip);
 	housekeeping_disable(mac);
+	flush_workqueue(zd_workqueue);
 
 	zd_chip_disable_hwint(chip);
 	zd_chip_switch_radio_off(chip);
@@ -792,6 +793,45 @@ static void zd_op_set_multicast_list(struct ieee80211_hw *hw,
 	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
 }
 
+static void set_rts_cts_work(struct work_struct *work)
+{
+	struct zd_mac *mac =
+		container_of(work, struct zd_mac, set_rts_cts_work);
+	unsigned long flags;
+	unsigned int short_preamble;
+
+	mutex_lock(&mac->chip.mutex);
+
+	spin_lock_irqsave(&mac->lock, flags);
+	mac->updating_rts_rate = 0;
+	short_preamble = mac->short_preamble;
+	spin_unlock_irqrestore(&mac->lock, flags);
+
+	zd_chip_set_rts_cts_rate_locked(&mac->chip, short_preamble);
+	mutex_unlock(&mac->chip.mutex);
+}
+
+static void zd_op_erp_ie_changed(struct ieee80211_hw *hw, u8 changes,
+				 int cts_protection, int preamble)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	unsigned long flags;
+
+	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
+
+	if (changes & IEEE80211_ERP_CHANGE_PREAMBLE) {
+		spin_lock_irqsave(&mac->lock, flags);
+		mac->short_preamble = !preamble;
+		if (!mac->updating_rts_rate) {
+			mac->updating_rts_rate = 1;
+			/* FIXME: should disable TX here, until work has
+			 * completed and RTS_CTS reg is updated */
+			queue_work(zd_workqueue, &mac->set_rts_cts_work);
+		}
+		spin_unlock_irqrestore(&mac->lock, flags);
+	}
+}
+
 static const struct ieee80211_ops zd_ops = {
 	.tx			= zd_op_tx,
 	.open			= zd_op_open,
@@ -800,7 +840,8 @@ static const struct ieee80211_ops zd_ops = {
 	.remove_interface	= zd_op_remove_interface,
 	.config			= zd_op_config,
 	.config_interface	= zd_op_config_interface,
-	.set_multicast_list	= zd_op_set_multicast_list
+	.set_multicast_list	= zd_op_set_multicast_list,
+	.erp_ie_changed		= zd_op_erp_ie_changed,
 };
 
 struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
@@ -859,6 +900,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	zd_chip_init(&mac->chip, hw, intf);
 	housekeeping_init(mac);
 	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
+	INIT_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
 
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	return hw;
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
index 27289a7..a60b10c 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
@@ -172,6 +172,7 @@ struct zd_mac {
 	struct ieee80211_hw *hw;
 	struct housekeeping housekeeping;
 	struct work_struct set_multicast_hash_work;
+	struct work_struct set_rts_cts_work;
 	struct zd_mc_hash multicast_hash;
 	u8 regdomain;
 	u8 default_regdomain;
@@ -182,6 +183,12 @@ struct zd_mac {
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
 	struct ieee80211_hw_mode modes[2];
+
+	/* Short preamble (used for RTS/CTS) */
+	unsigned int short_preamble:1;
+
+	/* flags to indicate update in progress */
+	unsigned int updating_rts_rate:1;
 };
 
 static inline struct zd_mac *zd_hw_mac(struct ieee80211_hw *hw)
-- 
1.5.2.4

