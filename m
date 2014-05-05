Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54935 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaEEIdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 04:33:45 -0400
Received: by mail-pa0-f53.google.com with SMTP id kp14so4436434pab.40
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2014 01:33:45 -0700 (PDT)
From: Adam Lee <adam.lee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] rtlwifi: make MSI support a module parameter
Date: Mon,  5 May 2014 16:33:36 +0800
Message-Id: <1399278818-19152-1-git-send-email-adam.lee@canonical.com> (sfid-20140505_103350_044665_43603AE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes MSI support a module parameter, for debugging and workaround
convenience.

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/net/wireless/rtlwifi/wifi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 6965afd..eef93d1 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -2030,6 +2030,10 @@ struct rtl_mod_params {
 
 	/* default: 1 = using linked fw power save */
 	bool fwctrl_lps;
+
+	/* default: 0 = not using MSI interrupts mode */
+	/* submodules should set their own defalut value */
+	bool msi_support;
 };
 
 struct rtl_hal_usbint_cfg {
-- 
2.0.0.rc0

