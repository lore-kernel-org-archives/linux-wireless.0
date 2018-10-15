Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE91C7112A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4847205C9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4847205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbeJORSZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:18:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36462 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeJORSY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 13:18:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id a8-v6so18811386wmf.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 02:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hwpxzwCb8Nd33xCxhEIkMz8lLgwba5RQ0nTLwp1viAQ=;
        b=tkU6iyJp7PKJEkBzw9HO1MvBnmVAUoCu3xK5Q69jX9VG8G1v8WPcFDbdONLgT1+nKA
         gv2gNyRRMdLSFIIcQHtUVw73VqRGKRpErJWwVfAZ+WqHRuNNOzrN6J7szPaa5PCKpcll
         Sw3legtt8oQEzhTeG3Psbj8hHvedYyisjRUWu30Hq/Bval//R14O+JV+WpVvPeY1CADS
         ym7deTkYCe39ZHTqS329Gvz2f5RCCxVGZ6cnMoLk/TEgt0N59riupN3AiHwUYE7gluf5
         qHN27fR1+gLkiH5gaGU+ixAPD40+lOV5cPmhc73yPoezkkLQWrmjqqJtZ9ZIKUuiRDl+
         qctA==
X-Gm-Message-State: ABuFfoj/3s9TSrMWggQdtezdmgHWM4VKY1QXEoVByMDc7a7VzJt5Rhj8
        uBzuY5EJL/Of74+BbQERYrGe1w==
X-Google-Smtp-Source: ACcGV60iXK0GiBEJsngQxRC7yqEwrxe6SRgjU+K1VhAkkqvbE617Dzv0pstaOYdUkF2zq9f+P7yw1A==
X-Received: by 2002:a1c:234c:: with SMTP id j73-v6mr11907327wmj.68.1539596035393;
        Mon, 15 Oct 2018 02:33:55 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id w11-v6sm17102507wrn.65.2018.10.15.02.33.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 02:33:54 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] mt76x2u: introduce mac workqueue support
Date:   Mon, 15 Oct 2018 11:33:16 +0200
Message-Id: <69563ff705ac496ed505a0111129c7ed7015f2bc.1539595605.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
References: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mac workqueue support to mt76x2u driver in order
to compute device statistics and add mac stuck routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c     | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 2 ++
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index 3c73fdeaf30f..04790f84d7d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -162,6 +162,8 @@ void mt76x2_init_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 
+	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
+
 	hw->queues = 4;
 	hw->max_rates = 1;
 	hw->max_report_rates = 7;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 5b167aaaf7f7..b15c97e1dfb3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -467,7 +467,6 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	int i, ret;
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
-	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
 
 	mt76x2_init_device(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index dfc80ecfde92..b2388f506505 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -297,6 +297,7 @@ void mt76x2u_stop_hw(struct mt76x02_dev *dev)
 {
 	mt76u_stop_stat_wk(&dev->mt76);
 	cancel_delayed_work_sync(&dev->cal_work);
+	cancel_delayed_work_sync(&dev->mac_work);
 	mt76x2u_mac_stop(dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 1971a1b00038..25c43175e6e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -27,6 +27,8 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+				     MT_CALIBRATE_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
 out:
-- 
2.19.0

