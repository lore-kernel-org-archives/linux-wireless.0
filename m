Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37524 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbeG0KLp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 06:11:45 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: realtek: rtl8225se: Replace mdelay() with msleep() in rtl8225se_rf_init
Date: Fri, 27 Jul 2018 16:50:45 +0800
Message-Id: <20180727085045.3949-1-baijiaju1990@gmail.com> (sfid-20180727_105108_139455_A94EAF08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8225se_rf_init() is never called in atomic context.
It calls mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().
This patch only replaces the mdelay() that has >20ms time to wait.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
index fde89866fa8d..51e32df6120b 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
@@ -363,7 +363,7 @@ void rtl8225se_rf_init(struct ieee80211_hw *dev)
 	rtl8187se_rf_writereg(dev, 0x00, 0x0037); mdelay(11);
 	rtl8187se_rf_writereg(dev, 0x04, 0x0160); mdelay(11);
 	rtl8187se_rf_writereg(dev, 0x07, 0x0080); mdelay(11);
-	rtl8187se_rf_writereg(dev, 0x02, 0x088D); mdelay(221);
+	rtl8187se_rf_writereg(dev, 0x02, 0x088D); msleep(221);
 	rtl8187se_rf_writereg(dev, 0x00, 0x0137); mdelay(11);
 	rtl8187se_rf_writereg(dev, 0x07, 0x0000); mdelay(1);
 	rtl8187se_rf_writereg(dev, 0x07, 0x0180); mdelay(1);
@@ -386,7 +386,7 @@ void rtl8225se_rf_init(struct ieee80211_hw *dev)
 	rtl8187se_rf_writereg(dev, 0x00, 0x00BF); mdelay(1);
 	rtl8187se_rf_writereg(dev, 0x0D, 0x08DF); mdelay(1);
 	rtl8187se_rf_writereg(dev, 0x02, 0x004D); mdelay(1);
-	rtl8187se_rf_writereg(dev, 0x04, 0x0975); mdelay(31);
+	rtl8187se_rf_writereg(dev, 0x04, 0x0975); msleep(31);
 	rtl8187se_rf_writereg(dev, 0x00, 0x0197); mdelay(1);
 	rtl8187se_rf_writereg(dev, 0x05, 0x05AB); mdelay(1);
 
-- 
2.17.0
