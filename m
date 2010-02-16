Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61637 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150Ab0BPR44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 12:56:56 -0500
Date: Tue, 16 Feb 2010 11:56:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: [PATCH 4/5] rtl8187se: Add rfkill routines
Message-ID: <4b7adc62.XZgY1Bxz31Xlk+qP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the RFKILL routines needed for RTL8187SE.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 rtl8187se_rfkill.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 rtl8187se_rfkill.h |   22 ++++++++++++++++
 2 files changed, 94 insertions(+)

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187se_rfkill.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187se_rfkill.h
@@ -0,0 +1,22 @@
+#ifndef RTL8187SE_RFKILL_H
+#define RTL8187SE_RFKILL_H
+/*
+ * Linux RFKILL support for RTL8187SE
+ *
+ * Copyright (c) 2010 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Based on the RFKILL handling in the r8187se driver, which is:
+ * Copyright (c) Realtek Semiconductor Corp. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+bool rtl8187se_is_radio_enabled(struct rtl8187se_priv *priv);
+void rtl8187se_rfkill_init(struct ieee80211_hw *hw);
+void rtl8187se_rfkill_poll(struct ieee80211_hw *hw);
+void rtl8187se_rfkill_exit(struct ieee80211_hw *hw);
+
+#endif /* RTL8187SE_RFKILL_H */
+
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187se_rfkill.c
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187se_rfkill.c
@@ -0,0 +1,72 @@
+/*
+ * Linux RFKILL support for RTL8187SE
+ *
+ * Copyright (c) 2010 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Based on the RFKILL handling in the r8187se driver, which is:
+ * Copyright (c) Realtek Semiconductor Corp. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <net/mac80211.h>
+
+#include "rtl8187se.h"
+#include "rtl8187se_rfkill.h"
+
+bool rtl8187se_is_radio_enabled(struct rtl8187se_priv *priv)
+{
+	u8 config0;
+	u8 pgsel = rtl818x_ioread8(priv, &priv->map->PGSELECT);
+
+	/* vendor driver turns LED off before reading CONFIG0 */
+	rtl818x_iowrite8(priv, &priv->map->PGSELECT, pgsel & 0xF7);
+	udelay(4);
+
+	config0 = rtl818x_ioread8(priv, &priv->map->CONFIG0);
+	/* Turn LED back on if switch on */
+	if (config0)
+		rtl818x_iowrite8(priv, &priv->map->PGSELECT, config0 | 0x08);
+	return config0 & 0x10;
+}
+
+void rtl8187se_rfkill_init(struct ieee80211_hw *hw)
+{
+	struct rtl8187se_priv *priv = hw->priv;
+
+	priv->rfkill_off = rtl8187se_is_radio_enabled(priv);
+	printk(KERN_INFO "rtl8187se: wireless switch is %s\n",
+	       priv->rfkill_off ? "on" : "off");
+	wiphy_rfkill_set_hw_state(hw->wiphy, !priv->rfkill_off);
+	wiphy_rfkill_start_polling(hw->wiphy);
+}
+
+void rtl8187se_rfkill_poll(struct ieee80211_hw *hw)
+{
+	bool enabled;
+	struct rtl8187se_priv *priv = hw->priv;
+
+	mutex_lock(&priv->conf_mutex);
+	enabled = rtl8187se_is_radio_enabled(priv);
+	if (unlikely(enabled != priv->rfkill_off)) {
+		priv->rfkill_off = enabled;
+		printk(KERN_INFO "rtl8187se: wireless radio switch turned %s\n",
+		       enabled ? "on" : "off");
+		wiphy_rfkill_set_hw_state(hw->wiphy, !enabled);
+	}
+	mutex_unlock(&priv->conf_mutex);
+}
+
+void rtl8187se_rfkill_exit(struct ieee80211_hw *hw)
+{
+	struct rtl8187se_priv *priv = hw->priv;
+	u8 pgsel = rtl818x_ioread8(priv, &priv->map->PGSELECT);
+
+	wiphy_rfkill_stop_polling(hw->wiphy);
+	/* Turn LED off before stopping */
+	rtl818x_iowrite8(priv, &priv->map->PGSELECT, pgsel & 0xF7);
+}
+
