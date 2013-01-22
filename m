Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:38987 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab3AVQtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 11:49:11 -0500
Date: Tue, 22 Jan 2013 17:49:14 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: print chip and firmware version by default
Message-ID: <20130122164914.GB25134@localhost.localdomain> (sfid-20130122_174914_967695_C215DAED)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 3e37c19..bef449c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -92,7 +92,7 @@
 #define NOTICE(__dev, __msg, __args...) \
 	DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
 #define INFO(__dev, __msg, __args...) \
-	DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
+	DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
 #define DEBUG(__dev, __msg, __args...) \
 	DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
 #define EEPROM(__dev, __msg, __args...) \
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index ed7a1bb..20c6ecc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -731,9 +731,9 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
 	queue->aifs = params->aifs;
 	queue->txop = params->txop;
 
-	INFO(rt2x00dev,
-	     "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
-	     queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
+	DEBUG(rt2x00dev,
+	      "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
+	      queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
 
 	return 0;
 }
-- 
1.7.4.4

