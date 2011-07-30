Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1G3Qaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 12:30:30 -0400
Date: Sat, 30 Jul 2011 11:30:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Remove EXPERIMENTAL designation from LP PHY
 selection
Message-ID: <4e3431a3.okCWfww1KPoiQhgM%Larry.Finger@lwfinger.net> (sfid-20110730_183040_287751_18D3BE07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since kernel 3.0, the problems with controlling b43 devices that have
low-power (LP) PHYs have been fixed and the EXPERIMENTAL designation
can be fixed.

This patch also fixes a typo as the device supports 802.11b communications.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/Kconfig
+++ wireless-testing-new/drivers/net/wireless/b43/Kconfig
@@ -114,13 +114,13 @@ config B43_PHY_N
 	  affect other devices support and may provide support for basic needs.
 
 config B43_PHY_LP
-	bool "Support for low-power (LP-PHY) devices (EXPERIMENTAL)"
-	depends on B43 && EXPERIMENTAL
+	bool "Support for low-power (LP-PHY) devices"
+	depends on B43
 	default y
 	---help---
 	  Support for the LP-PHY.
 	  The LP-PHY is a low-power PHY built into some notebooks
-	  and embedded devices. It supports 802.11a/g
+	  and embedded devices. It supports 802.11a/b/g
 	  (802.11a support is optional, and currently disabled).
 
 config B43_PHY_HT
