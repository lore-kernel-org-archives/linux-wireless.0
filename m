Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA69C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 551BF20815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfBDQvz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 11:51:55 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36648 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729892AbfBDQvz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 11:51:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id p6so653665wmc.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 08:51:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wX6nxWTlBcwblmhHjyDd7eUVh7ijgEJ3FKaiEYVhMsw=;
        b=HgTG3ez9x1ajlWvnKgYiEhYVoi50E6CBULIHK5xBl+za0XahoAsNBXzzr28/86z0nZ
         efAEse7Y85IQVJHK5Mfsf1N+T3XcHHlb6CsRIFPwEtI4ke5G2rRh/MnkhOJecHzpAJom
         zoqNNl/RowCaNk8IQqoURkcqO07v1cep7maJ25poOtill4MeXj045GmaiGS4dP68ez+J
         Bi6mc5ZvwRFHcL/ivKJ7lpD6aHwh7GGAvuWhBqOolbkGMN+t72wysWErf2Fpzs4xgMHE
         yAMCRDQfy+UXFnV22E9DxBVf0OwX53ZlTMgJoXZzd0DcRQVkrTXWZazXGttU6nliWe0a
         v4Qw==
X-Gm-Message-State: AHQUAuZe9UYJckEC/sWoe6WcrdkNJVsTRKXLvOzGedNiRpnOE6O2S9WM
        aKQRmpi/x7WCWbo/ALK5o4jMdfy2Rcw=
X-Google-Smtp-Source: AHgI3IZavWHVdTAcBzkuAczo4EFKGZ3NaOtbNLFIVCowi68iWkwrTRtku9Symdszun5X7l76Sx+l2Q==
X-Received: by 2002:a1c:6a0f:: with SMTP id f15mr278055wmc.68.1549299113204;
        Mon, 04 Feb 2019 08:51:53 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r22sm11233707wmh.2.2019.02.04.08.51.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 04 Feb 2019 08:51:52 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 3/3] mt76: move mt76_mcu_rx_event in mt76-core
Date:   Mon,  4 Feb 2019 17:51:29 +0100
Message-Id: <0036ff4837833af385d0457d23e438198eea8461.1549298196.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549298196.git.lorenzo.bianconi@redhat.com>
References: <cover.1549298196.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76_mcu_rx_event i mt76-core module and remove duplicated code.
mt76_mcu_rx_event will be reused adding support for mt7603 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mcu.c          | 7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76.h         | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 3 +--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mcu.c b/drivers/net/wireless/mediatek/mt76/mcu.c
index 0fd71a97a197..dbb57b593a87 100644
--- a/drivers/net/wireless/mediatek/mt76/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mcu.c
@@ -51,3 +51,10 @@ struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
 	return skb_dequeue(&dev->mmio.mcu.res_q);
 }
 EXPORT_SYMBOL_GPL(mt76_mcu_get_response);
+
+void mt76_mcu_rx_event(struct mt76_dev *dev, struct sk_buff *skb)
+{
+	skb_queue_tail(&dev->mmio.mcu.res_q, skb);
+	wake_up(&dev->mmio.mcu.wait);
+}
+EXPORT_SYMBOL_GPL(mt76_mcu_rx_event);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index c43c78d45493..9c6b6cb4ff91 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -776,6 +776,7 @@ void mt76u_queues_deinit(struct mt76_dev *dev);
 struct sk_buff *
 mt76_mcu_msg_alloc(const void *data, int head_len,
 		   int data_len, int tail_len);
+void mt76_mcu_rx_event(struct mt76_dev *dev, struct sk_buff *skb);
 struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
 				      unsigned long expires);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index a5413a309a0a..7861a832940b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -58,8 +58,7 @@ void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 
 	if (q == MT_RXQ_MCU) {
 		/* this is used just by mmio code */
-		skb_queue_tail(&mdev->mmio.mcu.res_q, skb);
-		wake_up(&mdev->mmio.mcu.wait);
+		mt76_mcu_rx_event(&dev->mt76, skb);
 		return;
 	}
 
-- 
2.20.1

