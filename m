Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32992 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdDMGs3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 02:48:29 -0400
Received: by mail-pf0-f194.google.com with SMTP id c198so8870546pfc.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 23:48:28 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH v4 1/4] mwifiex: remove unnecessary wakeup interrupt number sanity check
Date: Thu, 13 Apr 2017 06:48:19 +0000
Message-Id: <1492066102-31251-1-git-send-email-huxinming820@gmail.com> (sfid-20170413_084833_900281_E1C9CC3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

If wakeup interrupt handler is called, we know that the wakeup
interrupt number is valid, there is no need to check it.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Reviewed-by: Dmitry Torokhov <dtor@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
---
v2: modify description(Dimtry)
v4: same as v2, v3
---
 drivers/net/wireless/marvell/mwifiex/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 0dfbac8..98fd491 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1513,11 +1513,9 @@ static irqreturn_t mwifiex_irq_wakeup_handler(int irq, void *priv)
 {
 	struct mwifiex_adapter *adapter = priv;
 
-	if (adapter->irq_wakeup >= 0) {
-		dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
-		adapter->wake_by_wifi = true;
-		disable_irq_nosync(irq);
-	}
+	dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
+	adapter->wake_by_wifi = true;
+	disable_irq_nosync(irq);
 
 	/* Notify PM core we are wakeup source */
 	pm_wakeup_event(adapter->dev, 0);
-- 
1.8.1.4
