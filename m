Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5508 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933029AbdDEL6e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:58:34 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 08/11] wil6210: fix memory access violation in wil_memcpy_from/toio_32
Date: Wed,  5 Apr 2017 14:58:11 +0300
Message-Id: <1491393494-11816-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170405_140158_716170_0CF6AF1A)
In-Reply-To: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

In case count is not multiple of 4, there is a read access in
wil_memcpy_toio_32() from outside src buffer boundary.
In wil_memcpy_fromio_32(), in case count is not multiple of 4, there is
a write access to outside dst io memory boundary.

Fix these issues with proper handling of the last 1 to 4 copied bytes.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 9aa81ce..439d27c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -130,9 +130,15 @@ void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 	u32 *d = dst;
 	const volatile u32 __iomem *s = src;
 
-	/* size_t is unsigned, if (count%4 != 0) it will wrap */
-	for (count += 4; count > 4; count -= 4)
+	for (; count >= 4; count -= 4)
 		*d++ = __raw_readl(s++);
+
+	if (unlikely(count)) {
+		/* count can be 1..3 */
+		u32 tmp = __raw_readl(s);
+
+		memcpy(d, &tmp, count);
+	}
 }
 
 void wil_memcpy_fromio_halp_vote(struct wil6210_priv *wil, void *dst,
@@ -149,8 +155,16 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 	volatile u32 __iomem *d = dst;
 	const u32 *s = src;
 
-	for (count += 4; count > 4; count -= 4)
+	for (; count >= 4; count -= 4)
 		__raw_writel(*s++, d++);
+
+	if (unlikely(count)) {
+		/* count can be 1..3 */
+		u32 tmp = 0;
+
+		memcpy(&tmp, s, count);
+		__raw_writel(tmp, d);
+	}
 }
 
 void wil_memcpy_toio_halp_vote(struct wil6210_priv *wil,
-- 
1.9.1
