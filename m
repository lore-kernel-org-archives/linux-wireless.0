Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52896 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZJQT4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 15:56:53 -0400
Received: by mail-fx0-f218.google.com with SMTP id 18so3633004fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2009 12:56:57 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ar9170: don't filter BlockACK frames
Date: Sat, 17 Oct 2009 21:56:55 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910172156.56045.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current A-MPDU tx_status report mechanism is too inaccurate.
With this patch BlockACK frames show now up to the driver and
can be processed.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 611747d..b7d27dd 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -152,14 +152,14 @@ enum ar9170_cmd {
 #define		AR9170_MAC_REG_FTF_BIT14		BIT(14)
 #define		AR9170_MAC_REG_FTF_BIT15		BIT(15)
 #define		AR9170_MAC_REG_FTF_BAR			BIT(24)
-#define		AR9170_MAC_REG_FTF_BIT25		BIT(25)
+#define		AR9170_MAC_REG_FTF_BA			BIT(25)
 #define		AR9170_MAC_REG_FTF_PSPOLL		BIT(26)
 #define		AR9170_MAC_REG_FTF_RTS			BIT(27)
 #define		AR9170_MAC_REG_FTF_CTS			BIT(28)
 #define		AR9170_MAC_REG_FTF_ACK			BIT(29)
 #define		AR9170_MAC_REG_FTF_CFE			BIT(30)
 #define		AR9170_MAC_REG_FTF_CFE_ACK		BIT(31)
-#define		AR9170_MAC_REG_FTF_DEFAULTS		0x0500ffff
+#define		AR9170_MAC_REG_FTF_DEFAULTS		0x0700ffff
 #define		AR9170_MAC_REG_FTF_MONITOR		0xfd00ffff
 
 #define AR9170_MAC_REG_RX_TOTAL			(AR9170_MAC_REG_BASE + 0x6A0)
