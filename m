Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C60C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59B2C20868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59B2C20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbeJLRs1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44219 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbeJLRs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id 63-v6so12812704wra.11
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D/YmYOAVr/RO6b56NB6/u7RzOApU4JVjt8zBK+ZR/Lo=;
        b=JvYIbbiRIqsmhEejkrK7qHS5jYK1qyvuXFNmWxfH7CTh98PwaKNUY1+xLo8OG7ElRC
         hObUkV3Yzdya/+r8WS7Pcj13vWF4SoGjOoxB3Q9EM77kZPFHtm6ZcmPK76c1L3h3tsVd
         rUO9dIBt378qHmGCRzHXjkke6nueopcKlHDGvmPmqb8Y5CNjw8OIw1+D/3+cc0fU1N0u
         24jLNcjBQXkvfMUsUsNAUJ0FeUwDMzEb8bejyVeFiAz+EzpKD/0EX8OvnNLI9qCXrZwt
         x5+COZ3AV7vAsMM78ow3HRNXaAFJO7DwVNR85fnhELCZ6ynjRw3yOCPfukgKBrEufIVW
         tJxQ==
X-Gm-Message-State: ABuFfoi1xqO9pkiEr9xfF32TZbPAFsnFKWLwK+Sx0fKx31yelmyv8r5G
        Ft946057zdBVTkqTQgREJS2ev0ZMYrU=
X-Google-Smtp-Source: ACcGV61/sb5gwPH+fvFsVkK76xBAGHkxoW6eos9alPFstX7frUsO3DTx5uxqDkfVOQ9zeut7cibEJA==
X-Received: by 2002:adf:f84e:: with SMTP id d14-v6mr4747175wrq.174.1539339404797;
        Fri, 12 Oct 2018 03:16:44 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:44 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 03/13] mt76x0: pci: rename mt76x0_phy_calibrate
Date:   Fri, 12 Oct 2018 12:16:19 +0200
Message-Id: <6572922b3472d21b6ad4da512ffd4738687872d6.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rename mt76x0_phy_calibrate routine in mt76x0_phy_calibration_work
in order to not collide with calibration routine for mt76x0e

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 638a2bca5cff..9a8e1fcee26b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -787,7 +787,7 @@ static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_BBP(AGC,8), val);
 }
 
-static void mt76x0_phy_calibrate(struct work_struct *work)
+static void mt76x0_phy_calibration_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
 					       cal_work.work);
@@ -854,7 +854,7 @@ static void mt76x0_rf_init(struct mt76x02_dev *dev)
 
 void mt76x0_phy_init(struct mt76x02_dev *dev)
 {
-	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibrate);
+	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibration_work);
 
 	mt76x0_rf_init(dev);
 	mt76x02_phy_set_rxpath(dev);
-- 
2.17.2

