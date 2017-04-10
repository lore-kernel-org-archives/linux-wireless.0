Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33044 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdDJJJn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 05:09:43 -0400
Received: by mail-pf0-f194.google.com with SMTP id c198so5661997pfc.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 02:09:43 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH v3 2/4] mwifiex: fall back mwifiex_dbg to pr_info when adapter->dev not set
Date: Mon, 10 Apr 2017 09:09:32 +0000
Message-Id: <1491815374-6555-2-git-send-email-huxinming820@gmail.com> (sfid-20170410_110946_716149_59BE9916)
In-Reply-To: <1491815374-6555-1-git-send-email-huxinming820@gmail.com>
References: <1491815374-6555-1-git-send-email-huxinming820@gmail.com>
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
