Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:8741 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYBICpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 21:45:41 -0500
Received: by an-out-0708.google.com with SMTP id d31so958694and.103
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 18:45:41 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 8 Feb 2008 18:41:17 -0800
Subject: [PATCH] zd1211rw: Fixed incorrect constant name.
Message-ID: <47ad13d4.2c012c0a.14e0.fffff14d@mx.google.com> (sfid-20080209_024552_711458_41CE4C9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trial and error reveals that CR_ZD1211B_TX_PWR_CTL* do not affect the
transmission power.  Instead these registers seem to control the contention
windows limits for different QoS access categories.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    8 ++++----
 drivers/net/wireless/zd1211rw/zd_chip.h |    9 ++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 66abc4e..0acb5c3 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -771,10 +771,10 @@ static int zd1211b_hw_init_hmac(struct zd_chip *chip)
 {
 	static const struct zd_ioreq32 ioreqs[] = {
 		{ CR_ZD1211B_RETRY_MAX,		0x02020202 },
-		{ CR_ZD1211B_TX_PWR_CTL4,	0x007f003f },
-		{ CR_ZD1211B_TX_PWR_CTL3,	0x007f003f },
-		{ CR_ZD1211B_TX_PWR_CTL2,       0x003f001f },
-		{ CR_ZD1211B_TX_PWR_CTL1,       0x001f000f },
+		{ CR_ZD1211B_CWIN_MAX_MIN_AC0,	0x007f003f },
+		{ CR_ZD1211B_CWIN_MAX_MIN_AC1,	0x007f003f },
+		{ CR_ZD1211B_CWIN_MAX_MIN_AC2,  0x003f001f },
+		{ CR_ZD1211B_CWIN_MAX_MIN_AC3,  0x001f000f },
 		{ CR_ZD1211B_AIFS_CTL1,		0x00280028 },
 		{ CR_ZD1211B_AIFS_CTL2,		0x008C003C },
 		{ CR_ZD1211B_TXOP,		0x01800824 },
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 5cffbd6..3f44db2 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -633,11 +633,10 @@ enum {
 #define CR_S_MD				CTL_REG(0x0830)
 
 #define CR_USB_DEBUG_PORT		CTL_REG(0x0888)
-
-#define CR_ZD1211B_TX_PWR_CTL1		CTL_REG(0x0b00)
-#define CR_ZD1211B_TX_PWR_CTL2		CTL_REG(0x0b04)
-#define CR_ZD1211B_TX_PWR_CTL3		CTL_REG(0x0b08)
-#define CR_ZD1211B_TX_PWR_CTL4		CTL_REG(0x0b0c)
+#define CR_ZD1211B_CWIN_MAX_MIN_AC0	CTL_REG(0x0b00)
+#define CR_ZD1211B_CWIN_MAX_MIN_AC1	CTL_REG(0x0b04)
+#define CR_ZD1211B_CWIN_MAX_MIN_AC2	CTL_REG(0x0b08)
+#define CR_ZD1211B_CWIN_MAX_MIN_AC3	CTL_REG(0x0b0c)
 #define CR_ZD1211B_AIFS_CTL1		CTL_REG(0x0b10)
 #define CR_ZD1211B_AIFS_CTL2		CTL_REG(0x0b14)
 #define CR_ZD1211B_TXOP			CTL_REG(0x0b20)
-- 
1.5.2.4



