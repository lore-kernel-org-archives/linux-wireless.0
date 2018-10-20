Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27582ECDE44
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD5D22150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD5D22150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbeJTSYE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:24:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39768 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbeJTSYE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:24:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id 61-v6so39861130wrb.6
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1VW+yumGPPry6wXZHgfFqx/8IJbdG00S8aBSwcZeJFk=;
        b=tEIa8eYBiyXXML3lLaAhuMq881i/Mqfte5T2F5XZin2QttHuejiFQulGEdAjYlL/3d
         Il6/VlPUxRc95ZsArJdiGBWpsq4elRjOCOoiMVvCqnmuCQldwF4DvHG0+HsCF6XzqszY
         s6Bw2RSEHlSHa8i+FclmG5nA74wl694c7Gok20LPpATYYjvI8lKwy/So1QLTP1ztDQmn
         dy8Nm8o4tGWl9lq1hlIoO+OogLTDhKDP4nk3k0d5eGWBg3Wi7JuLfBfjvJsSphj7Ony0
         5tpZ+cFEQYvuJdtjUc+gafV1PsaVtD2tkIETApBz+eycxMmk7uGgKK7SjMpj6L4/BaOt
         kmeg==
X-Gm-Message-State: ABuFfoiUu2o6pxfv25b/NXWc/0kV+3i37gMj+YZ76XNGaKiYie6lhI/c
        MDGb9W5GZVU35OdPm6qm8HKXbD7j6So=
X-Google-Smtp-Source: ACcGV615omfLj6xi2oeH5IesjIyowK5bPpF9TCrK3msaGNrI0Y5uq5zlL78736EBHX8dWvfKBHMHJA==
X-Received: by 2002:adf:db8e:: with SMTP id u14-v6mr38858644wri.217.1540030447256;
        Sat, 20 Oct 2018 03:14:07 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.14.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:14:06 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 7/9] mt76: move mt76x02_sta_ps in mt76x02-lib module
Date:   Sat, 20 Oct 2018 12:13:30 +0200
Message-Id: <5e3f51cbe94036c3d9c48cb159968e60a641a9b3.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
References: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_sta_ps utility routine in mt76x02_util.c
in order to be reused by mt76x0 driver adding AP support

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h         |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 12 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h   |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c | 11 -----------
 6 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 4d4800d09da6..4deaf7f7c4f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -142,6 +142,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x02_rx_poll_complete,
+		.sta_ps = mt76x02_sta_ps,
 	};
 	struct mt76x02_dev *dev;
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index f830e39b58e7..1733226b657d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -153,6 +153,7 @@ void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
 int mt76x02_get_txpower(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif, int *dbm);
+void mt76x02_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 25f36e333b9b..4e358066bf9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -526,6 +526,18 @@ int mt76x02_get_txpower(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_get_txpower);
 
+void mt76x02_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta,
+		    bool ps)
+{
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	struct mt76x02_sta *msta = (struct mt76x02_sta *)sta->drv_priv;
+	int idx = msta->wcid.idx;
+
+	mt76_stop_tx_queues(&dev->mt76, sta, true);
+	mt76x02_mac_wcid_set_drop(dev, idx, ps);
+}
+EXPORT_SYMBOL_GPL(mt76x02_sta_ps);
+
 const u16 mt76x02_beacon_offsets[16] = {
 	/* 1024 byte per beacon */
 	0xc000,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 2bae70c63ab0..0c323a0762e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -77,8 +77,6 @@ void mt76x2_cleanup(struct mt76x02_dev *dev);
 
 void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 
-void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
-
 void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index c5d5fcbd9a55..c3c2f4441777 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -356,7 +356,7 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x02_rx_poll_complete,
-		.sta_ps = mt76x2_sta_ps,
+		.sta_ps = mt76x02_sta_ps,
 	};
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 5dfd06e56636..b2c599d4d670 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -164,17 +164,6 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-void
-mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
-{
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	int idx = msta->wcid.idx;
-
-	mt76_stop_tx_queues(&dev->mt76, sta, true);
-	mt76x02_mac_wcid_set_drop(dev, idx, ps);
-}
-
 static void
 mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	     u32 queues, bool drop)
-- 
2.19.1

