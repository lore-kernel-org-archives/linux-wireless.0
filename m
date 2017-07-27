Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0084.outbound.protection.outlook.com ([104.47.41.84]:11662
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751684AbdG0XHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:52 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 11/12] qtnfmac: remove function qtnf_cmd_skb_put_action
Date: Fri, 28 Jul 2017 02:06:53 +0300
Message-Id: <20170727230654.30850-12-sergey.matyukevich.os@quantenna.com> (sfid-20170728_013043_058595_14189A3B)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is not used anymore, so remove it.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/qlink_util.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index c9e882a3a991..de06c1e20b5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -22,14 +22,6 @@
 
 #include "qlink.h"
 
-static inline void qtnf_cmd_skb_put_action(struct sk_buff *skb, u16 action)
-{
-	__le16 *buf_ptr;
-
-	buf_ptr = skb_put(skb, sizeof(action));
-	*buf_ptr = cpu_to_le16(action);
-}
-
 static inline void
 qtnf_cmd_skb_put_buffer(struct sk_buff *skb, const u8 *buf_src, size_t len)
 {
-- 
2.11.0
