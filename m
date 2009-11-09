Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55578 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZKIXaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:30:02 -0500
Date: Mon, 09 Nov 2009 17:30:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: [RFT 4/6] rtl8187se: Create file rtl8187se_rtl8225.h
Message-ID: <4af8a5ff.z2bSRW13a+8Y5B+o%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create the radio driver header file for rtl8187se.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187se_rtl8225.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187se_rtl8225.h
@@ -0,0 +1,24 @@
+#ifndef RTL8187SE_RTL8225_H
+#define RTL8187SE_RTL8225_H
+
+#define RTL8225_ANAPARAM_ON	0xa0000b59
+#define RTL8225_ANAPARAM2_ON	0x860dec11
+#define RTL8225_ANAPARAM_OFF	0xa00beb59
+#define RTL8225_ANAPARAM2_OFF	0x840dec11
+
+const struct rtl818x_rf_ops * rtl8187se_detect_rf(struct ieee80211_hw *);
+
+static inline void rtl8225_write_phy_ofdm(struct ieee80211_hw *dev,
+					  u8 addr, u8 data)
+{
+	rtl8187se_write_phy(dev, addr, data);
+}
+
+static inline void rtl8225_write_phy_cck(struct ieee80211_hw *dev,
+					 u8 addr, u8 data)
+{
+	rtl8187se_write_phy(dev, addr, data | 0x10000);
+}
+
+#endif /* RTL8187SE_RTL8225_H */
+

