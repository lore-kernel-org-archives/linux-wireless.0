Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33005 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753208AbeCPOp6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 10:45:58 -0400
Received: by mail-wr0-f196.google.com with SMTP id z73so7724316wrb.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2018 07:45:58 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, arnd@arndb.de
Subject: [PATCH] mt76: enable MAC80211_LEDS by default
Date: Fri, 16 Mar 2018 15:45:48 +0100
Message-Id: <a159566d0970fb5c43da7758d8281b594b6ca48e.1521209538.git.lorenzo.bianconi@redhat.com> (sfid-20180316_154622_034123_84A96CF1)
In-Reply-To: <cover.1521209538.git.lorenzo.bianconi@redhat.com>
References: <cover.1521209538.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Select mac80211 led support by default in order to fix the following
compilation error that occurs when CONFIG_LEDS_CLASS/CONFIG_MAC80211_LEDS
options are not enabled on the system

ERROR: "devm_of_led_classdev_register" undefined!

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index fc05d79c80d0..0bbd492c2c2b 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -1,5 +1,8 @@
 config MT76_CORE
 	tristate
+	select MAC80211_LEDS
+	select LEDS_CLASS
+	select NEW_LEDS
 
 config MT76x2E
 	tristate "MediaTek MT76x2E (PCIe) support"
-- 
2.14.3
