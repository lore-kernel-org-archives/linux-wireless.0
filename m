Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35455 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936357AbcI0Q4f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 12:56:35 -0400
Received: by mail-pf0-f178.google.com with SMTP id s13so7649046pfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2016 09:56:35 -0700 (PDT)
From: Rajat Jain <rajatja@google.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Rajat Jain <rajatja@google.com>,
        Wei-Ning Huang <wnhuang@google.com>,
        Brian Norris <briannorris@google.com>,
        Eric Caruso <ejcaruso@chromium.org>, rajatxjain@gmail.com
Subject: [PATCH] mwifiex: report wakeup for wowlan
Date: Tue, 27 Sep 2016 09:56:04 -0700
Message-Id: <1474995364-123069-1-git-send-email-rajatja@google.com> (sfid-20160927_185701_396036_824E4BAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable notifying wakeup source to the PM core. This allow darkresume to
correctly track wakeup source and mark mwifiex_plt as 'automatic' wakeup
source.

Signed-off-by: Wei-Ning Huang <wnhuang@google.com>
Signed-off-by: Rajat Jain <rajatja@google.com>
Tested-by: Wei-Ning Huang <wnhuang@chromium.org>
Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 8 ++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index d3e1561..a5f63e4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -89,6 +89,9 @@ static irqreturn_t mwifiex_wake_irq_wifi(int irq, void *priv)
 		disable_irq_nosync(irq);
 	}
 
+	/* Notify PM core we are wakeup source */
+	pm_wakeup_event(cfg->dev, 0);
+
 	return IRQ_HANDLED;
 }
 
@@ -112,6 +115,7 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 					  GFP_KERNEL);
 	cfg = card->plt_wake_cfg;
 	if (cfg && card->plt_of_node) {
+		cfg->dev = dev;
 		cfg->irq_wifi = irq_of_parse_and_map(card->plt_of_node, 0);
 		if (!cfg->irq_wifi) {
 			dev_dbg(dev,
@@ -130,6 +134,10 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 		}
 	}
 
+	ret = device_init_wakeup(dev, true);
+	if (ret)
+		dev_err(dev, "fail to init wakeup for mwifiex");
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index db837f1..07cdd23 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -155,6 +155,7 @@
 } while (0)
 
 struct mwifiex_plt_wake_cfg {
+	struct device *dev;
 	int irq_wifi;
 	bool wake_by_wifi;
 };
-- 
2.8.0.rc3.226.g39d4020
