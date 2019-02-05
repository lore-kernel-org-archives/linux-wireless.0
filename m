Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5105C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DA2207E0
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfBEOG7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 09:06:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37050 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbfBEOG7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 09:06:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id g67so3803550wmd.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2019 06:06:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NHS5LwwW278psv8jhjd+T2UY6jcckeZz4ELT2GAP+1U=;
        b=go6zsz1MfmRFzOGaMIFDz7ptLU6MRUT85OaJsxunzBoE8r7Ji/JTd6N3YS36KqiybR
         fKydSBT/MS5gQbiKAexhwD0DGVcCrvoiyPFHGtMR/eXHiyZc8npzpvlaL/SEyo8QNcFX
         m+Uqeg8nvtLwscWFHFSjXa4I3TIpDKxWkl73dJhsQEWW0u5abLHKa/x2fuHxsPxBrcno
         8ofyyBaiflIRJKrWL2/oVpJaowpP1MMuD38kLugo+p1ozpFMlKi4WHsgivlxUxpqcX9O
         JX3PCEHYd8fx+EB29Z9kYjG6oCljXX3D6sARCesn+epa6EDnYTT2JUtcga9+azhXLvpT
         Xd0g==
X-Gm-Message-State: AHQUAuYDXnF840/IfOYyZr1CLFNybuxAySVx2k+xTQcyJ+2ete7HqfvT
        7o2xaTCyQGROcsvvC0mimMSZCXl0JJA=
X-Google-Smtp-Source: AHgI3IYHBrEpKcYN3g8F5dp2ue4cRhjsHBju4h+F5JYyTKAI8U4bw5o/Fp1wI1j5Ee+jjGTwlFkJpw==
X-Received: by 2002:a1c:3d44:: with SMTP id k65mr3886491wma.76.1549375617475;
        Tue, 05 Feb 2019 06:06:57 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 129sm25740457wmd.18.2019.02.05.06.06.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 05 Feb 2019 06:06:56 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76x0: eeprom: fix VHT mcs{8,9} rate power offset
Date:   Tue,  5 Feb 2019 15:06:34 +0100
Message-Id: <2c8c824603c2cf9e41abcc2ff716585adef24d2d.1549375500.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549375500.git.lorenzo.bianconi@redhat.com>
References: <cover.1549375500.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix rate power configuration for VHT mcs 8 and 9 in
mt76x0_get_tx_power_per_rate. Moreover use the rate power
offset used for HT/VHT mcs 6 even for HT/VHT mcs 7

Fixes: b37bbc8c8251 ("mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 952d20b8353a..ab6dfc026acb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -189,7 +189,7 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev,
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 8 : 0x126;
 	val = mt76x02_eeprom_get(dev, addr);
 	t->ht[4] = t->ht[5] = t->vht[4] = t->vht[5] = s6_to_s8(val);
-	t->ht[6] = t->vht[6] = s6_to_s8(val >> 8);
+	t->ht[6] = t->ht[7] = t->vht[6] = t->vht[7] = s6_to_s8(val >> 8);
 
 	/* ht-vht mcs 1ss 0, 1, 2, 3 stbc */
 	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 14 : 0xec;
@@ -205,8 +205,8 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev,
 
 	/* vht mcs 8, 9 5GHz */
 	val = mt76x02_eeprom_get(dev, 0x132);
-	t->vht[7] = s6_to_s8(val);
-	t->vht[8] = s6_to_s8(val >> 8);
+	t->vht[8] = s6_to_s8(val);
+	t->vht[9] = s6_to_s8(val >> 8);
 
 	delta = mt76x0_tssi_enabled(dev) ? 0 : mt76x0_get_delta(dev);
 	mt76x02_add_rate_power_offset(t, delta);
-- 
2.20.1

