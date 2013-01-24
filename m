Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:20419 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab3AXU7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 15:59:11 -0500
Date: Thu, 24 Jan 2013 21:59:32 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 1/4] rt2x00: print warning, notice and info as default
Message-ID: <20130124205931.GB16252@localhost.localdomain> (sfid-20130124_215917_509934_CFACC425)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some messages provide useful information, but are disabled without
CONFIG_RT2X00_DEBUG=y, so enable them by default

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 3e37c19..8ef11b6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -88,11 +88,11 @@
 #define ERROR_PROBE(__msg, __args...) \
 	DEBUG_PRINTK_PROBE(KERN_ERR, "Error", __msg, ##__args)
 #define WARNING(__dev, __msg, __args...) \
-	DEBUG_PRINTK(__dev, KERN_WARNING, "Warning", __msg, ##__args)
+	DEBUG_PRINTK_MSG(__dev, KERN_WARNING, "Warning", __msg, ##__args)
 #define NOTICE(__dev, __msg, __args...) \
-	DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
+	DEBUG_PRINTK_MSG(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
 #define INFO(__dev, __msg, __args...) \
-	DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
+	DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
 #define DEBUG(__dev, __msg, __args...) \
 	DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
 #define EEPROM(__dev, __msg, __args...) \
-- 
1.7.4.4

