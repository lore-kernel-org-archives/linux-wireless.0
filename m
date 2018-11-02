Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53BDC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 09:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A6D02081B
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 09:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A6D02081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbeKBSjT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 14:39:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41336 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeKBSjT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 14:39:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id x12-v6so1259501wrw.8
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 02:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cDEsRzYPhWsGVE2Frm/pfFQGbOxkLlYK9jCdGqFUq+w=;
        b=R423da5wegeuj7lyEb6xL+IYKv5jI84zbD4y3dODllfeT29O/7GfdsSbdNQeb4aoIt
         lxdsOWr6LOrlo0DzMKHc70Otw1tcGxvtggQqGzdaQuvFLGUxh0w/d/XUktxApDZKGNUv
         zt7F5qP0LOZOuKTnAprvep2nWmmW8/N2HE1FXOJ9sEezJJeCDEOXwYTvKtkZn5zpvNAX
         PACu3sH42CWADX0qPrpjdY9IMv5ZtG6p0z9HRMue2MIDqxOb+xTMwejSPCChqzNlt+Xi
         MQGoRF/uzcTji6dkP2yMQPiQNKWiCpVaoWAmISmu28Xh6yFmvNUPULJA+jfUGCJJQ0Ud
         LQyw==
X-Gm-Message-State: AGRZ1gJDUtd7udNeLwQhA7RkfgHtwf+eXhyPAXvJHWh+hqumrK3ogh09
        UljX6XEYvClbi7Pp8eWo3V7ZDA==
X-Google-Smtp-Source: AJdET5dsidvUtgPtuMx+dnZ3GO98AfbdGyNH6c1AicqdXpxPcYuNBGSChZNinNDAlKTtHm9mN62ZGQ==
X-Received: by 2002:adf:f748:: with SMTP id z8-v6mr586116wrp.237.1541151165480;
        Fri, 02 Nov 2018 02:32:45 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o126-v6sm21452848wmo.3.2018.11.02.02.32.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Nov 2018 02:32:44 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org, arnd@arndb.de
Subject: [PATCH] mt76: fix building without CONFIG_LEDS_CLASS
Date:   Fri,  2 Nov 2018 10:32:32 +0100
Message-Id: <5d0d7286445acef822a806dc89fcbf9eb2672ade.1541150589.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1541150589.git.lorenzo.bianconi@redhat.com>
References: <cover.1541150589.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_LEDS_CLASS is disabled, or it is a loadable module while
mt76 is built-in, we run into a link error:

drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_register_device':
mac80211.c:(.text+0xb78): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `devm_of_led_classdev_register'

We don't really need a hard dependency here as the driver can presumably
work just fine without LEDs, so this follows the iwlwifi example and
adds a separate Kconfig option for the LED support, this will be available
whenever it will link, and otherwise the respective code gets left out from
the driver object.

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig           | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mac80211.c        | 8 +++++---
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 6 ++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 0ccbcd7e887d..c30d8f5bbf2a 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -1,6 +1,12 @@
 config MT76_CORE
 	tristate
 
+config MT76_LEDS
+	bool
+	depends on MT76_CORE
+	depends on LEDS_CLASS=y || MT76_CORE=LEDS_CLASS
+	default y
+
 config MT76_USB
 	tristate
 	depends on MT76_CORE
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 2a699e8b79bf..7d219ff2d480 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -345,9 +345,11 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	mt76_check_sband(dev, NL80211_BAND_2GHZ);
 	mt76_check_sband(dev, NL80211_BAND_5GHZ);
 
-	ret = mt76_led_init(dev);
-	if (ret)
-		return ret;
+	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
+		ret = mt76_led_init(dev);
+		if (ret)
+			return ret;
+	}
 
 	return ieee80211_register_hw(hw);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 7b53b2be28c2..b6f1efb7daa8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -417,8 +417,10 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 	/* init led callbacks */
-	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
-	dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
+	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
+		dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
+		dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
+	}
 
 	ret = mt76_register_device(&dev->mt76, true, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
-- 
2.17.2

