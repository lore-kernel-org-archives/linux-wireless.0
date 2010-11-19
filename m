Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22562 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0KSLPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 06:15:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 03:15:34 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/4] ath: Add a driver_info bitmask field
Date: Fri, 19 Nov 2010 16:53:19 +0530
Message-ID: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver_info stores the device category information which
is used to load appropriate device firmware, select firmware offset
and eeprom starting location. The driver_info is accessed across
ath9k_htc and ath9k_hw. Hence placed under common structure.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 501050c..20ea68c 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -104,6 +104,11 @@ enum ath_cipher {
 	ATH_CIPHER_MIC = 127
 };
 
+enum ath_drv_info {
+	AR7010_DEVICE		= BIT(0),
+	AR9287_DEVICE		= BIT(1),
+};
+
 /**
  * struct ath_ops - Register read/write operations
  *
@@ -147,6 +152,7 @@ struct ath_common {
 	u8 rx_chainmask;
 
 	u32 rx_bufsize;
+	u32 driver_info;
 
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
-- 
1.7.3.2

