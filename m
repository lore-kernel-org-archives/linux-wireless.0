Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8752AC67839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A8D320849
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A8D320849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbeLLVwI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 16:52:08 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39124 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbeLLVwI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 16:52:08 -0500
Received: by mail-wr1-f67.google.com with SMTP id t27so19196268wra.6
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 13:52:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+TYyUzbNCCJDFXb+jr1z8INqPis77LRhVrlhQp0xf6w=;
        b=ItyzZoU700oyqVPMjFb5RFMYkubfFBaPeJ00dYPu1gHh84b58VOlOCQwoHhVb5nNw0
         rhwRrhl9iG7duOloAuNYSnRTIJcA5CIVgJkIqsK1ze7O8k1uIXBldBH9IP8Khz9O1O8m
         Wkv3MGQcoMH2h6S6RMSlLia74Twa3qlqPGI1TGJOD2oXHJGGus6JYL6Du0sltks0j87r
         D3E6NZYqUp4ZzakQ/FEGdWjH11Yr7FcznvsgK8F96a4uRrq3QgULTFgvRzWBNP+bx3Ip
         GkVoJPzWv/+UIiKrpcxTOuh9Iv0XGfQDGq71nAuxkVPyNc5KyPbd7vMDprnK9iV9Rv3z
         wpvQ==
X-Gm-Message-State: AA+aEWYaYZB7XQUUGyIsIv1NpHnQPM1Gxm1G/IxDiO1pg9l8vcbrsZlM
        hgSKfB0xRlC34pNNKo6PoLfQ3Q==
X-Google-Smtp-Source: AFSGD/UuH6aJ/JdnCHcJfsZP8cpj6GGGx2iaSSGIzOO7nq36xnvgTZkpkqX3FKpEreJY7RVQeIQqgA==
X-Received: by 2002:adf:80cf:: with SMTP id 73mr418106wrl.57.1544651526843;
        Wed, 12 Dec 2018 13:52:06 -0800 (PST)
Received: from localhost.localdomain ([151.66.36.11])
        by smtp.gmail.com with ESMTPSA id o17sm225615wmg.35.2018.12.12.13.52.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 13:52:06 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 2/3] mt76x2: init: set default value for MT_TX_LINK_CFG
Date:   Wed, 12 Dec 2018 22:51:54 +0100
Message-Id: <87d5cbe3208ae962fcdf02d7d4266420e0e4dd92.1544568618.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544568618.git.lorenzo.bianconi@redhat.com>
References: <cover.1544568618.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Update default value for MT_TX_LINK_CFG according to vendor driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index 54a9b5fac787..f8534362e2c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -143,6 +143,7 @@ void mt76_write_mac_initvals(struct mt76x02_dev *dev)
 		{ MT_VHT_HT_FBK_CFG1,		0xedcba980 },
 		{ MT_PROT_AUTO_TX_CFG,		0x00830083 },
 		{ MT_HT_CTRL_CFG,		0x000001ff },
+		{ MT_TX_LINK_CFG,		0x00001020 },
 	};
 	struct mt76_reg_pair prot_vals[] = {
 		{ MT_CCK_PROT_CFG,		DEFAULT_PROT_CFG_CCK },
-- 
2.19.2

