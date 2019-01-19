Return-Path: <SRS0=bfUd=P3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0F8C61CE4
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Jan 2019 15:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B63D2084F
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Jan 2019 15:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfASPAc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Jan 2019 10:00:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33433 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbfASPAc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Jan 2019 10:00:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so18479067wrr.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jan 2019 07:00:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UOSHYtf2C7el6mefqufgOVFniHJMg/J6YU/SD1ztmBk=;
        b=MYJPOSIU2OINeSIwm3t+m/bTN5cERbcYgy28ZpCuHHBcpYaFqkQgNTnD/2Gd9Hf4qS
         WoMwKkkfpbL0na0OvwwdZvVqrjkEd8E8a2//Yyb9EyZ78AeVbmVatiA81/cdWBoruwMF
         ivdPiQnAul/x154nKsZXQDIthNiNO6qfz9HgWxCwtbK3OJLUdg3GS8Des86hOewrKCMf
         ZXXykG/doQ1r+3GUDY+wSnCxBpKEimDAj1y5/0SjnXI4nuQUDwvx/Ox1rwj0jbElxU79
         iEA+2SRHvsEcVxXaoEegOyHy15KdSs926kbvvUrQaBsHi/a1s9EOyttdQ0yCSyWrhoip
         Aepw==
X-Gm-Message-State: AJcUukcBa4xVwGrBKXzpDkHVcDF5bIBruvkc3FlhfQSfNjIKcboFBOOv
        gtm/8vwletYKLPtmsBVe42UVlg==
X-Google-Smtp-Source: ALg8bN4tlcSXeA24MMEtOKSDGDph5guisS/WcSDLQ3NStRTUcbtxCzBt9W6JYjZ45YGWNG1SjDFXPA==
X-Received: by 2002:adf:9bda:: with SMTP id e26mr19862902wrc.295.1547910030434;
        Sat, 19 Jan 2019 07:00:30 -0800 (PST)
Received: from localhost.localdomain ([151.21.137.205])
        by smtp.gmail.com with ESMTPSA id k128sm57531625wmd.37.2019.01.19.07.00.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Jan 2019 07:00:29 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76: do not report out-of-range rx nss
Date:   Sat, 19 Jan 2019 16:00:26 +0100
Message-Id: <611062117f1037517e22c589e100abb767328cc7.1547909691.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547909691.git.lorenzo.bianconi@redhat.com>
References: <cover.1547909691.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Take into account device rx stream in mt76x02_mac_process_rate
in order to not report wrong number of rx spatial stream to mac80211.
The issue has been reported on mt76x0 device which is 1x1:1 however
the hw sometimes reports rx nss equal to 2

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 68d01e136fa0..ce9bb702045f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -476,7 +476,9 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 }
 
 static int
-mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
+mt76x02_mac_process_rate(struct mt76x02_dev *dev,
+			 struct mt76_rx_status *status,
+			 u16 rate)
 {
 	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
 
@@ -508,11 +510,15 @@ mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 		status->encoding = RX_ENC_HT;
 		status->rate_idx = idx;
 		break;
-	case MT_PHY_TYPE_VHT:
+	case MT_PHY_TYPE_VHT: {
+		u8 n_rxstream = dev->mt76.chainmask & 0xf;
+
 		status->encoding = RX_ENC_VHT;
 		status->rate_idx = FIELD_GET(MT_RATE_INDEX_VHT_IDX, idx);
-		status->nss = FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1;
+		status->nss = min_t(u8, n_rxstream,
+				    FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1);
 		break;
+	}
 	default:
 		return -EINVAL;
 	}
@@ -656,7 +662,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	status->tid = FIELD_GET(MT_RXWI_TID, tid_sn);
 	status->seqno = FIELD_GET(MT_RXWI_SN, tid_sn);
 
-	return mt76x02_mac_process_rate(status, rate);
+	return mt76x02_mac_process_rate(dev, status, rate);
 }
 
 void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
-- 
2.20.1

