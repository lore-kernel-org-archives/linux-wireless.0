Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750916AbdATNn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 08:43:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH v4 1/3] rt2x00: add copy of clk for soc devices
Date: Fri, 20 Jan 2017 14:28:24 +0100
Message-Id: <1484918906-21856-2-git-send-email-sgruszka@redhat.com> (sfid-20170120_144333_551529_12B54804)
In-Reply-To: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
References: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since clk_get() is not trivial add copy of clk pointer to rt2x00dev
for System On Chip devices and initialize it on probe routine.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    | 4 ++++
 drivers/net/wireless/ralink/rt2x00/rt2x00soc.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index bea7ac3..b59e721 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -39,6 +39,7 @@
 #include <linux/hrtimer.h>
 #include <linux/average.h>
 #include <linux/usb.h>
+#include <linux/clk.h>
 
 #include <net/mac80211.h>
 
@@ -1011,6 +1012,9 @@ struct rt2x00_dev {
 	unsigned int extra_tx_headroom;
 
 	struct usb_anchor *anchor;
+
+	/* Clock for System On Chip devices. */
+	struct clk *clk;
 };
 
 struct rt2x00_bar_list_entry {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
index 69a0cda..362f9d3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
@@ -92,6 +92,7 @@ int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops)
 	rt2x00dev->hw = hw;
 	rt2x00dev->irq = platform_get_irq(pdev, 0);
 	rt2x00dev->name = pdev->dev.driver->name;
+	rt2x00dev->clk = clk_get(&pdev->dev);
 
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
 
-- 
1.8.3.1
