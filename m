Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33037 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdDMGsg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 02:48:36 -0400
Received: by mail-pf0-f195.google.com with SMTP id c198so8870810pfc.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 23:48:36 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH v4 2/4] mwifiex: fall back mwifiex_dbg to pr_info when adapter->dev not set
Date: Thu, 13 Apr 2017 06:48:20 +0000
Message-Id: <1492066102-31251-2-git-send-email-huxinming820@gmail.com> (sfid-20170413_084840_370517_1186ECDB)
In-Reply-To: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
References: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

mwifiex_dbg will do nothing before adapter->dev get assigned. several logs
lost in this case. it can be avoided by fall back to pr_info.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Dmitry Torokhov <dtor@chromium.org>
---
v2: enhance adapter->dev null case.(Brain)
v3: use va_list in pr_info.(Dmitry)
v4: same as v3
---
 drivers/net/wireless/marvell/mwifiex/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 98fd491..16cd14e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1750,7 +1750,7 @@ void _mwifiex_dbg(const struct mwifiex_adapter *adapter, int mask,
 	struct va_format vaf;
 	va_list args;
 
-	if (!adapter->dev || !(adapter->debug_mask & mask))
+	if (!(adapter->debug_mask & mask))
 		return;
 
 	va_start(args, fmt);
@@ -1758,7 +1758,10 @@ void _mwifiex_dbg(const struct mwifiex_adapter *adapter, int mask,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	dev_info(adapter->dev, "%pV", &vaf);
+	if (adapter->dev)
+		dev_info(adapter->dev, "%pV", &vaf);
+	else
+		pr_info("%pV", &vaf);
 
 	va_end(args);
 }
-- 
1.8.1.4
