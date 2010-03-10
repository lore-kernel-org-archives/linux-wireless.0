Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33156 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0CJQlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 11:41:36 -0500
Date: Wed, 10 Mar 2010 10:41:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, zajec5@gmail.com
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Export ssb_chipco_gpio_control - needed by N PHY
 code
Message-ID: <4b97cbbc.nqHhscLOOd2KdAxL%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest changes in the N PHY core require the symbol
ssb_chipco_gpio_control to be exported.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This fixes a build error in wireless-testing - "git describe" lists
it as v2.6.34-rc1-47014-g33b6b57.

Larry
---
 
Index: wireless-testing/drivers/ssb/driver_chipcommon.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_chipcommon.c
+++ wireless-testing/drivers/ssb/driver_chipcommon.c
@@ -370,6 +370,7 @@ u32 ssb_chipco_gpio_control(struct ssb_c
 {
 	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOCTL, mask, value);
 }
+EXPORT_SYMBOL(ssb_chipco_gpio_control);
 
 u32 ssb_chipco_gpio_intmask(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
