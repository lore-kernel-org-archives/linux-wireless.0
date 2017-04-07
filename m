Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36759 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbdDGKwB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 06:52:01 -0400
Received: by mail-pg0-f68.google.com with SMTP id 81so14764804pgh.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Apr 2017 03:52:00 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH v2 2/4] mwifiex: fall back mwifiex_dbg to pr_info when adapter->dev not set
Date: Fri,  7 Apr 2017 10:51:23 +0000
Message-Id: <1491562285-29818-2-git-send-email-huxinming820@gmail.com> (sfid-20170407_125408_463120_62445F69)
In-Reply-To: <1491562285-29818-1-git-send-email-huxinming820@gmail.com>
References: <1491562285-29818-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

mwifiex_dbg will do nothing before adapter->dev get assigned. several logs
lost in this case. it can be avoided by fall back to pr_info.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
v2: enhance adapter->dev null case.(Brain)
---
 drivers/net/wireless/marvell/mwifiex/main.c | 17 ++++++++++++-----
 drivers/net/wireless/marvell/mwifiex/main.h |  2 ++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 98fd491..f3e772f 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1749,18 +1749,25 @@ void _mwifiex_dbg(const struct mwifiex_adapter *adapter, int mask,
 {
 	struct va_format vaf;
 	va_list args;
+	char msg[MWIFIEX_LOG_LEN];
 
-	if (!adapter->dev || !(adapter->debug_mask & mask))
+	if (!(adapter->debug_mask & mask))
 		return;
 
 	va_start(args, fmt);
 
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	dev_info(adapter->dev, "%pV", &vaf);
+	if (!adapter->dev) {
+		vsnprintf(msg, MWIFIEX_LOG_LEN, fmt, args);
+	} else {
+		vaf.fmt = fmt;
+		vaf.va = &args;
+		dev_info(adapter->dev, "%pV", &vaf);
+	}
 
 	va_end(args);
+
+	if (!adapter->dev)
+		pr_info("%s", msg);
 }
 EXPORT_SYMBOL_GPL(_mwifiex_dbg);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f1cb875..d4289a9 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -164,6 +164,8 @@ enum {
 /* Address alignment */
 #define MWIFIEX_ALIGN_ADDR(p, a) (((long)(p) + (a) - 1) & ~((a) - 1))
 
+#define MWIFIEX_LOG_LEN 120
+
 /**
  *enum mwifiex_debug_level  -  marvell wifi debug level
  */
-- 
1.8.1.4
