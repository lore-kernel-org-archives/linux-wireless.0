Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34314 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932836AbdC3JTm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 05:19:42 -0400
Received: by mail-pg0-f68.google.com with SMTP id o123so8600476pga.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 02:19:41 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH 1/3] mwifiex: remove unnecessary wakeup interrupt number sanity check
Date: Thu, 30 Mar 2017 09:19:05 +0000
Message-Id: <1490865547-10208-1-git-send-email-huxinming820@gmail.com> (sfid-20170330_112019_795293_9C0EE8E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Sanity check of interrupt number in interrupt handler is unnecessary and
confusion, remove it.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 30f4994..5e82602 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1503,11 +1503,9 @@ static irqreturn_t mwifiex_irq_wakeup_handler(int irq, void *priv)
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
