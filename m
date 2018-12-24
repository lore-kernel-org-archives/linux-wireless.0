Return-Path: <SRS0=QFll=PB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F52C64E79
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 16:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F370021736
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 16:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbeLXQY4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Dec 2018 11:24:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44424 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbeLXQY4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Dec 2018 11:24:56 -0500
Received: by mail-wr1-f67.google.com with SMTP id z5so11920820wrt.11
        for <linux-wireless@vger.kernel.org>; Mon, 24 Dec 2018 08:24:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8uvM3KgG9Pa4dMAzFTwv6ZdFS77ues0Y09lvemWv6xs=;
        b=T9ZMglsKWZSZeg+JwhMyGmo/UZdTPGrunGwDivm3017fU0YrsScWgf5tmqEV5NDyA4
         f/yTGQ1ha90mgRq8Ivy6BoeN4SXchC6SkgyfbH5vhw7d4UgBjxJ1YA0CxPQ9UEwewyz2
         1ahjqOapq9JvqxStvaseimQErjXFSm7Vu62K+quq+Sw/sD8XHFGo3gFc6hNhBXz9bh2r
         leEwEd+689o78yJsUK2aK70N8+J220sijwCmo7jH1AOUGeRgcnemrThf7rK+8vMXeGzL
         GmI1scLef2dRORh69EVYVik219A5cStw9bvKi5RrWiyvwxrKrrIq1Iq4d2jLKH+Un+w2
         N+6w==
X-Gm-Message-State: AJcUukfFR3HgJagRqZHv/kIKVeB8Tz4Gfr9f+LHY8c1a/8JuwY/edZgG
        z7xl8WSYLLUr+tmm339RaAAOCuukfxM=
X-Google-Smtp-Source: ALg8bN7dPDXLy/8PAZMKNDdqr9qhzx0jbVBPF20vw9wQmf9+OXjmKMmySwB4vGl6ZryEwizuNqkxeA==
X-Received: by 2002:a05:6000:108d:: with SMTP id y13mr11974158wrw.135.1545668694369;
        Mon, 24 Dec 2018 08:24:54 -0800 (PST)
Received: from localhost.localdomain.com (host89-60-dynamic.56-79-r.retail.telecomitalia.it. [79.56.60.89])
        by smtp.gmail.com with ESMTPSA id o82sm21283194wmo.29.2018.12.24.08.24.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Dec 2018 08:24:53 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 1/2] mt76: run mac work every 100ms
Date:   Mon, 24 Dec 2018 17:24:41 +0100
Message-Id: <f28b63441e1a1c1518e28dc70ff7fc854ae60361.1545667662.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
References: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce MT_WATCHDOG_TIME macro in order to run mac work every 100ms.
This is a preliminary patch to implement a proper tx hang watchdog

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h         | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 2 +-
 6 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 720b05e325a5..d2005632101f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -30,7 +30,7 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 	mt76x02_mac_start(dev);
 	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_WATCHDOG_TIME);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0e6b43bb4678..b7ace310ca72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -118,7 +118,7 @@ static int mt76x0u_start(struct ieee80211_hw *hw)
 
 	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_WATCHDOG_TIME);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 5f5831d18af5..17e13e373f53 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -26,6 +26,7 @@
 #include "mt76x02_dfs.h"
 #include "mt76x02_dma.h"
 
+#define MT_WATCHDOG_TIME	(HZ / 10)
 #define MT_CALIBRATE_INTERVAL	HZ
 
 #define MT_MAX_CHAINS		2
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index aed108e8761f..a4ff5a7a219f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -888,7 +888,7 @@ void mt76x02_mac_work(struct work_struct *work)
 	mt76_tx_status_check(&dev->mt76, NULL, false);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_WATCHDOG_TIME);
 }
 
 void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index b54a32397486..ec936002a286 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -33,7 +33,7 @@ mt76x2_start(struct ieee80211_hw *hw)
 		goto out;
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_WATCHDOG_TIME);
 
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 2b48cc51a30d..77f95688a41b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -28,7 +28,7 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
 		goto out;
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_WATCHDOG_TIME);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
 out:
-- 
2.20.1

