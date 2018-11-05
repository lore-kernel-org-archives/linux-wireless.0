Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA01C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1221E20827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1221E20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbeKFBM2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:12:28 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36338 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbeKFBM2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 20:12:28 -0500
Received: by mail-wm1-f66.google.com with SMTP id a8-v6so8527966wmf.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 07:52:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TFedjIpQBAFd7awSZcqwYx7ieDOkJuidkc7bA7AOd24=;
        b=JZfhbvB+EZ5op/bxnGaCj3Hc7vtry122dGXBF7XLrM4hL17xc5kGqO+CxLCCzRHU2n
         98H9H9cJASShfv4tzM1ULTAp9Kk6+QieO92Xo1JFcEsrMpmH+6l572V1WZ8oNHs3b+ta
         boeM582Fo8o459JkJQ5R+RirjFVJrOKUVhcl39QAYb8qYN+M+DPbiutlTpEoRrig+Zm1
         D8ybc13ELpgr9FbEemedclMAefkk+kkadWF6qaHsawuy2D+alI9SuOo5+vBwiQopQrjX
         Rwb0MCQF9auXcZmwv1MdP/h4ZrAhoavOSlWgY0+gV1dkUq0Z//vRAaHogHgcUxLQmn4o
         LuNw==
X-Gm-Message-State: AGRZ1gIjOPgyy866e3HvmalA+OtdLe/hk3Pr9vmTCRRqhQKRGd1y0+Mw
        Ct8YvKNJemoBFOePtk7tEisQKstvM5Y=
X-Google-Smtp-Source: AJdET5dQ+JKOBmDfkkG/l3RtaSFv+20Mm4yf6V5cJ/gX3Siy02FpUF2VZGph1+jdFdP2YPyx7+qfUw==
X-Received: by 2002:a1c:1692:: with SMTP id 140-v6mr4623257wmw.119.1541433126170;
        Mon, 05 Nov 2018 07:52:06 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y4-v6sm30729866wrd.61.2018.11.05.07.52.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Nov 2018 07:52:05 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name, sgruszka@redhat.com, arnd@arndb.de
Subject: [PATCH v2] mt76: fix building without CONFIG_LEDS_CLASS
Date:   Mon,  5 Nov 2018 16:51:47 +0100
Message-Id: <33a74f5182ddf9bf90c883884924dc93547a5fb4.1541432864.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1541432864.git.lorenzo.bianconi@redhat.com>
References: <cover.1541432864.git.lorenzo.bianconi@redhat.com>
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
Changes since v1:
- rebased on top of wireless-drivers repository
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
index 3824290b219d..fd125722d1fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -507,8 +507,10 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	mt76x2_dfs_init_detector(dev);
 
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

