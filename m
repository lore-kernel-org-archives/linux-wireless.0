Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC79C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 10:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5387420879
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 10:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbeL1KBP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Dec 2018 05:01:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55569 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730267AbeL1KBP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Dec 2018 05:01:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id y139so18470036wmc.5
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2018 02:01:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PmNQhhBaePFmDZhiFfyx13k93vg6yBrcosaYfsefZ50=;
        b=g0HYnwkOcwnqzvqZto1ihaHRwvYxVimm5Qd/+TuT9ZO8G5E1ma7bRGG7hLWt2XH+vW
         bVtpwJxMaVbmbLwADOucBOvl+4gIdS7bL3U/3dYeGYFeE2kzb6AFo0o1sXWqf/F4o+Qp
         ihKWmCYbucm3dDbfb/fyNC8E4caO5aqXnGS6cUS1fr61le+W06eQP+NsiK0t3vOXdxb8
         vu9zX2HBxFkNyptZtG+xLDwWttXBhtGmB5VoU/dVkFq7Vt/zDQx2ST1kV7ggZ8IFYK4T
         zKj7PhRnoJ+05PPIWEoOimDj8DKzNKGDR/HgA6NBBqT4LGKN1yivPwUsiwI7qaXayUTh
         3Csg==
X-Gm-Message-State: AA+aEWZO5COtBSVb/0UPuAQ+RUcZM7tmGrWCvtBOG6POxNnTcpoDcf8x
        iKNOiCmZp9uq9uRcq3MP0C/vyaRNhWM=
X-Google-Smtp-Source: ALg8bN7FuITXck3PeBmiuttbbWQLruo05kq7rq9BKEhAdQ/Uz82riQ/QaBji6Pw9CPo5SLHAXZ8I2A==
X-Received: by 2002:a1c:4346:: with SMTP id q67mr25082596wma.114.1545991273414;
        Fri, 28 Dec 2018 02:01:13 -0800 (PST)
Received: from localhost.net (host10-126-dynamic.18-79-r.retail.telecomitalia.it. [79.18.126.10])
        by smtp.gmail.com with ESMTPSA id o9sm20866727wmh.3.2018.12.28.02.01.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Dec 2018 02:01:12 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76: mac: minor optimizations in mt76x02_mac_tx_rate_val
Date:   Fri, 28 Dec 2018 11:00:47 +0100
Message-Id: <7836e3c7ef8d5fc25df968df188fc36ec02ca799.1545990781.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1545990781.git.lorenzo.bianconi@redhat.com>
References: <cover.1545990781.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not set bw variable to zero for legacy rates since it is already
initialized to zero. Moreover set nss to 1 just for legacy rates
since nss will be properly set for VHT/HT rates

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index c08bf371e527..475eb3d40b4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -130,10 +130,8 @@ static __le16
 mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 			const struct ieee80211_tx_rate *rate, u8 *nss_val)
 {
+	u8 phy, rate_idx, nss, bw = 0;
 	u16 rateval;
-	u8 phy, rate_idx;
-	u8 nss = 1;
-	u8 bw = 0;
 
 	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
 		rate_idx = rate->idx;
@@ -164,7 +162,7 @@ mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 
 		phy = val >> 8;
 		rate_idx = val & 0xff;
-		bw = 0;
+		nss = 1;
 	}
 
 	rateval = FIELD_PREP(MT_RXWI_RATE_INDEX, rate_idx);
-- 
2.20.1

