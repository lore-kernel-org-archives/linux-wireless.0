Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52058 "HELO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934983AbZLMCCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 21:02:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([10.128.143.54])
          by hrndva-qmta04.mail.rr.com with ESMTP
          id <20091213005110392.RVXI22884@hrndva-qmta04.mail.rr.com>
          for <linux-wireless@vger.kernel.org>;
          Sun, 13 Dec 2009 00:51:10 +0000
Date: Sat, 12 Dec 2009 18:04:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8180: Remove usage of deprecated 'qual'
Message-ID: <4b242f9e.4JOejhV35R7ixmmP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building rtl8180, the following warning occurs:

  CC [M]  drivers/net/wireless/rtl818x/rtl8180_dev.o
drivers/net/wireless/rtl818x/rtl8180_dev.c: In function ‘rtl8180_handle_rx’:
drivers/net/wireless/rtl818x/rtl8180_dev.c:135: warning: ‘qual’ is deprecated
    (declared at include/net/mac80211.h:562)

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch has very low priority.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -132,7 +132,6 @@ static void rtl8180_handle_rx(struct iee
 
 			rx_status.antenna = (flags2 >> 15) & 1;
 			/* TODO: improve signal/rssi reporting */
-			rx_status.qual = flags2 & 0xFF;
 			rx_status.signal = (flags2 >> 8) & 0x7F;
 			/* XXX: is this correct? */
 			rx_status.rate_idx = (flags >> 20) & 0xF;
