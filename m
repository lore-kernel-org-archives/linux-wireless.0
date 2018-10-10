Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAC7C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 10:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4750620835
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 10:31:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4750620835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbeJJRxB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 13:53:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40198 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbeJJRxB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 13:53:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id d2-v6so5114283wro.7
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 03:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=240c6f/TaoJ2rmfMB28D1Bi/0G484hvntJQvvOizY7c=;
        b=R3+K2jViDuYosB3vdrizd84vEm9aGThZt5EWV4S6GGXXz5G0QBBknLWiUSucGPQRTz
         WH94RkqL7y84eDuv1Ns1DqND5wwKAkJ/50tYU9KLKSS6PWqwiJ+ZIrgqZsiMuveROegR
         LyT3zb72qojOD99VQXuKSGMBEPZIg2f8G8jhX2V31unEU49cTcaFs8pjMMK8H7di/awg
         4A/W7ZpxZGn5DwAMBWyn2mdVFuIeln9ertNfeGctZq1PA7YDRfajsEr8XrFKnl4o3h8u
         fQYOkA79pCIggjVDoGwF7wBenXZcTk3Wr3/6IbJdhAP9+gwqLywNcR/UDicQFHPSONVb
         OsZw==
X-Gm-Message-State: ABuFfoiT3cZZb9QS59GbcVLSIBg9jAVMU8xlW7tQ5JWxPt5KkiKTWz0W
        U5xrAiskI6J+DHMKq/tWSAmL/D3Mb28=
X-Google-Smtp-Source: ACcGV63mckvmXi65NxOTaP7etEvchy/QZ4lGbskFzT0lTA96XTCnO/qvq6Tpk5B1t0rqleiEkbM63w==
X-Received: by 2002:adf:afdd:: with SMTP id y29-v6mr24520959wrd.176.1539167489293;
        Wed, 10 Oct 2018 03:31:29 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o63-v6sm21931025wmd.3.2018.10.10.03.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Oct 2018 03:31:28 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: phy: remove channel parameter from mt76x0_phy_set_chan_bbp_params
Date:   Wed, 10 Oct 2018 12:31:13 +0200
Message-Id: <3ec48695920433e323123e4aa91768df867ee6a6.1539167134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1539167134.git.lorenzo.bianconi@redhat.com>
References: <cover.1539167134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove unused channel parameter from mt76x0_phy_set_chan_bbp_params
routine signature

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 29bc4e4623cd..7c30ba47c7f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -529,7 +529,7 @@ mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_ban
 }
 
 static void
-mt76x0_phy_set_chan_bbp_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_band)
+mt76x0_phy_set_chan_bbp_params(struct mt76x02_dev *dev, u16 rf_bw_band)
 {
 	int i;
 
@@ -705,7 +705,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 		val &= ~0x20;
 	mt76_wr(dev, MT_BBP(CORE, 1), val);
 
-	mt76x0_phy_set_chan_bbp_params(dev, channel, rf_bw_band);
+	mt76x0_phy_set_chan_bbp_params(dev, rf_bw_band);
 
 	/* Vendor driver don't do it */
 	/* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
-- 
2.17.1

