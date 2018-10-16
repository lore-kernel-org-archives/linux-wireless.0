Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F302C5ACC6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07DEC2145D
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07DEC2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbeJQFQW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 01:16:22 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39878 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbeJQFQW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 01:16:22 -0400
Received: by mail-wm1-f53.google.com with SMTP id y144-v6so24714202wmd.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SDpG8UZ15bHjxfNa5PFvQwcFz7APolulEUmI3UfXJWE=;
        b=FTIlqLq1XIwI7zShjU+YbNwigv/6Iw9/O6nzTiKStJjutf1pwi18yEGG41BC6v/i+p
         G3ys5GTm2P82qqdO3kyD1hc1UO5yV7cX6uoO8R2AFz2lbDIJaVfZIbyVvf5B70L82ADm
         eQjtW/u8RuLqEbimv2f7vcHPTN5VITkOiw1BtCoChSmS8xRJ5SG7ujoEJ0r/nudVShXh
         Ebyk31/jGOCOC+Tc/oWzp4xF5bxFsa1pSm0uUFDSzJ6Zn0467f5uEKGQezUsJhB/pzPF
         md6wMTWNPyJEx599m20/3QMQlsnhU2rUEh00pORGUWTiyXFzt2wKlBwEywQhNSIPjctL
         Zy+Q==
X-Gm-Message-State: ABuFfoj0GwuA7qKvTz7mlg2H2tJorqMCDpgHCYHi94WzqjNL6y3E4D+0
        +r7rW/Xdrt84SyxFAiVun7hJeNpsuf8=
X-Google-Smtp-Source: ACcGV623mGXR0VwK5JNEdCFtAjv07wfuohSUTRQiUb/tubrbx+9UsWRy2dEQrKeo98VnAylPY3Cuvw==
X-Received: by 2002:a1c:5e49:: with SMTP id s70-v6mr18041268wmb.131.1539725043129;
        Tue, 16 Oct 2018 14:24:03 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id 193-v6sm14390046wmj.21.2018.10.16.14.24.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 14:24:02 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 7/9] mt76: move mt76x02_sta_ps in mt76x02-lib module
Date:   Tue, 16 Oct 2018 23:23:29 +0200
Message-Id: <67f438757c8c26b423c21b280099677aff51e6b6.1539723134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
References: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
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
index df13c00717bc..3e51c92c212b 100644
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
2.19.0

