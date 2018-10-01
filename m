Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4382C0044B
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A53982082A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A53982082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbeJAXhM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:37:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33195 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbeJAXhL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 19:37:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id e4-v6so961075wrs.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 09:58:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FQ39nO/30oOonUVQmSyppCQ+vWiW6AnYFM1z56KC53A=;
        b=fz0/KhabLw0tpUu88eoe94B5ufUu/E+Gdx6D+eWyUeNgZyqY/Yq4iOueujjkElN+96
         tCKkCrOHtHgbby7r4Wn7kfr+8OGTjbuTHCwpaUErVYWh+d5jlUl+pdRmVBam3J6H3+Gb
         lu6oS5iwXbqI4pxicd4gbRbOPs+9mbENEQ2OOLgvghtvIxPaGi1JhSpRgFwJq7lpFykY
         aTRteoZTJzKDNwdFOD10BtwSjNBRY6yF0Alz+1EoIuB35Q173eoPJPSoHb1AQitoncjR
         gdUa6z45bVK4G55MM28mNU4soS4kMWnZWQUol+uccVzwNRjUkJwgxDKYIqhck/SJIqRn
         6XGA==
X-Gm-Message-State: ABuFfohXZeRpoM95SduXTssZjaiUr2MAzZVI47XkdkaosENXNxqqAn+/
        rgQp/UHIyq0cBStwOIxlbNUSuw==
X-Google-Smtp-Source: ACcGV62Dra3qtO53RN6ZB3haddcsLZvGQElhQmHFpw/xRR+Ub1nfq22DYKARsDLjlrToixZ0b7BKaw==
X-Received: by 2002:adf:f7c1:: with SMTP id a1-v6mr7309704wrq.152.1538413106813;
        Mon, 01 Oct 2018 09:58:26 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b2-v6sm5057600wru.51.2018.10.01.09.58.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 09:58:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mt76: add get_tx_txpwr_adj function pointer to mt76_driver_ops
Date:   Mon,  1 Oct 2018 18:58:18 +0200
Message-Id: <1643ff06891345867537aeb9628a5c912db147f7.1538411693.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
References: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add get_tx_txpwr_adj function pointer to mt76_driver_ops data structure
as a preliminary patch to unify txwi configuration between mt76x0 and
mt76x2 drivers since tpc is currently supported just by mt76x2 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h            | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/tx.c       | 6 ++++--
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index c47ad67ce2ff..422b09a42bf6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -262,6 +262,8 @@ struct mt76_driver_ops {
 
 	void (*sta_ps)(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		       bool ps);
+	s8 (*get_tx_txpwr_adj)(struct mt76_dev *dev, s8 txpwr,
+			       s8 max_txpwr_adj);
 };
 
 struct mt76_channel_state {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index a396a56dcfe0..0791fa11875c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -100,7 +100,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 	}
 	spin_unlock_bh(&dev->mt76.lock);
 
-	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, dev->mt76.txpower_conf,
+	txpwr_adj = mt76x2_tx_get_txpwr_adj(&dev->mt76, dev->mt76.txpower_conf,
 					    max_txpwr_adj);
 	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 50490c75a1e2..5c3425507adf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -176,7 +176,7 @@ void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 void mt76x2_update_channel(struct mt76_dev *mdev);
 
-s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj);
+s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj);
 void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
 
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index d9fb06e34dbf..a6c66bf08ded 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -362,6 +362,7 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 		.rx_skb = mt76x2_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
+		.get_tx_txpwr_adj = mt76x2_tx_get_txpwr_adj,
 	};
 	struct mt76x2_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
index 0c878c9eb33d..c8203e49560c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
@@ -47,8 +47,10 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 }
 EXPORT_SYMBOL_GPL(mt76x2_tx);
 
-s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj)
+s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
 {
+	struct mt76x2_dev  *dev = container_of(mdev, struct mt76x2_dev, mt76);
+
 	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
 	txpwr -= (dev->target_power + dev->target_power_delta[0]);
 	txpwr = min_t(s8, txpwr, max_txpwr_adj);
@@ -66,7 +68,7 @@ void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr)
 {
 	s8 txpwr_adj;
 
-	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, txpwr,
+	txpwr_adj = mt76x2_tx_get_txpwr_adj(&dev->mt76, txpwr,
 					    dev->mt76.rate_power.ofdm[4]);
 	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
 		       MT_PROT_AUTO_TX_CFG_PROT_PADJ, txpwr_adj);
-- 
2.17.1

