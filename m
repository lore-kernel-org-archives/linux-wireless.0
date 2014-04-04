Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51749 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaDDQYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 12:24:53 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so1625385wib.14
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 09:24:52 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com, kilroyd@googlemail.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 3/4] rtl8180: add parentheses to REG_ADDR macros
Date: Fri,  4 Apr 2014 18:24:36 +0200
Message-Id: <1396628676-14512-1-git-send-email-andrea.merello@gmail.com> (sfid-20140404_182456_637116_7DA9E5A5)
In-Reply-To: <533C63D6.5000109@gmail.com>
References: <533C63D6.5000109@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parentheses are missing around the macro argument, causing the
macro possibly not to work passing certain expressions as
arguments.

This should not cause any issues with current code, however it's
worth to add them, as a good practice, and to eventually avoid
future bugs.

Suggested-by: Dave Kilroy <kilroyd@googlemail.com>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl818x.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
index 45ea4e1..7abef95 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -334,9 +334,9 @@ struct rtl818x_csr {
  * I don't like to introduce a ton of "reserved"..
  * They are for RTL8187SE
  */
-#define REG_ADDR1(addr)	((u8 __iomem *)priv->map + addr)
-#define REG_ADDR2(addr)	((__le16 __iomem *)priv->map + (addr >> 1))
-#define REG_ADDR4(addr)	((__le32 __iomem *)priv->map + (addr >> 2))
+#define REG_ADDR1(addr)	((u8 __iomem *)priv->map + (addr))
+#define REG_ADDR2(addr)	((__le16 __iomem *)priv->map + ((addr) >> 1))
+#define REG_ADDR4(addr)	((__le32 __iomem *)priv->map + ((addr) >> 2))
 
 #define FEMR_SE		REG_ADDR2(0x1D4)
 #define ARFR		REG_ADDR2(0x1E0)
-- 
1.8.3.2

