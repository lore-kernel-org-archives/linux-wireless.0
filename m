Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FD2C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC08B2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC08B2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389447AbeKGC0R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:26:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43314 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:26:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id y3-v6so14049369wrh.10
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 09:00:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1Zr/yr36XtR7nj8WAI/rLWpJ8ZqzD69e2a6KztYJlfs=;
        b=X1uvfcivNMu3rKOH9dwL4wqDN1fkRP6YjakJ3EYdzc5+QBsXIZnvQ0zU4YO6S5pyTS
         NaTpsELhUdCKaAtA8hKgcZLGFUN8Ovks4Ob0Wwk9JlyZjFvNOyKBSdG28qFAk8Oh9Mys
         CuwFEU6uIbyZOzwv6pG9SfM8sYxBc5yiWdWOFb2NZ+Mn0YWSqcbhhnPtklj2ou/unDQN
         98mPDSUZi66W9tiuWhEwxs0o+WH0zOcJwkIcK3dokLZfF06R2qa2M1a39byWzt+KqDDb
         66S2tksdNhcFpkPY0cIfhJhWraE3NBNriIq3FaUdk+ZXxgQfCV5QnJM+9C/upOq++N8u
         Pn2A==
X-Gm-Message-State: AGRZ1gK4VEQ1PfsLX4PFGniaNfhAB5E1K/IJw7FJh+gypvjpWiYojk/h
        Hc9LwDJ1k5+/dPetRp5RgyE5Tw==
X-Google-Smtp-Source: AJdET5duay4ylNQIQm/9lVTHVaLIVdFSUltX893unQ56TdwPwcMwvQTeMa2Xn+In3t84zZ3GiC0cTA==
X-Received: by 2002:adf:ff4e:: with SMTP id u14-v6mr24206875wrs.232.1541523607906;
        Tue, 06 Nov 2018 09:00:07 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x142-v6sm649271wmd.20.2018.11.06.09.00.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Nov 2018 09:00:07 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mt76x2u: phy: add TX_SHAPING calibration
Date:   Tue,  6 Nov 2018 17:59:45 +0100
Message-Id: <1870868969df6afe13a424a69af2802f9bb9ab9f.1541522368.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
References: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add MCU_CAL_TX_SHAPING calibration in mt76x2u_phy_channel_calibrate
routine since now mt76x2 and mt76x2u driver run the same firmware

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 8011c261c658..24e292e895b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -35,6 +35,7 @@ void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev)
 	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz, false);
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz, false);
 	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_SHAPING, 0, false);
 
 	mt76x2u_mac_resume(dev);
 }
-- 
2.17.2

