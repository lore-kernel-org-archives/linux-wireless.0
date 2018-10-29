Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE66EC0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21E620870
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A21E620870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbeJ3GHZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:07:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50810 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbeJ3GHZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 02:07:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id h2-v6so5913242wmb.0
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2018 14:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FrEx31FEN1Xt85vWZOCOuIBvafEBBqd+ASNr4UAzXkk=;
        b=HIQFIIECGMcm0Skq2KUnQMGmuXsLbrhZmOEUtAgIkqH5nGPOvSWvS7FuCBh3hnypMB
         SMboO6oube+JiOz75eNz1r3eqetex1bsBD/deNvhJWWoZUQNSOmBjVTaE8ESu5KEFC2h
         NpWkW5qe6sq66FzaTYz7qKEQ+Hsx0O1NsaCkNtx3Y60oJPAJAgzA49n15LxlTiO0rsYJ
         7C9F98t1mCUoviD+7av2M+5c8Od70+u5FdCuLFBdqKtq5fL5NW5j5Vqsu8u/GuiDa16u
         AUnch6FuuTG5oeJB1/2L3tkwfGrA5+O+exkm1vZogzOgnyyePgOPDdgD2NvJmqdwzt7J
         ERZw==
X-Gm-Message-State: AGRZ1gJGuS2uVRCvIyLAFqAxCwDEmnLJg0c38dCPNexgOQRdmPRrpqGR
        umBpWdMKDVr5BNBxzGRnzsCTWF9nMTE=
X-Google-Smtp-Source: AJdET5dKvyqdSOCLMnPD2XnHQWxdTEbAbb7YtzIe4028hc/VyRdugMZJ290UICzV+AC5tV0KrMUqlg==
X-Received: by 2002:a1c:8414:: with SMTP id g20-v6mr14887096wmd.123.1540847817586;
        Mon, 29 Oct 2018 14:16:57 -0700 (PDT)
Received: from localhost.localdomain ([151.66.3.112])
        by smtp.gmail.com with ESMTPSA id 138-v6sm7829306wmr.16.2018.10.29.14.16.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Oct 2018 14:16:56 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2u: init: use common routines for wcid/key initialization
Date:   Mon, 29 Oct 2018 22:16:50 +0100
Message-Id: <cd068de8910a6ee147006eb50b9e4cfea8e0dba7.1540847490.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540847490.git.lorenzo.bianconi@redhat.com>
References: <cover.1540847490.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_mac_wcid_setup and mt76x02_mac_shared_key_setup for
shared keys and wcid table initialization and remove duplicated
code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index c338ac0433ad..94a4b58fddc1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -166,11 +166,7 @@ static void mt76x2u_init_beacon_offsets(struct mt76x02_dev *dev)
 
 int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 {
-	const struct mt76_wcid_addr addr = {
-		.macaddr = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
-		.ba_mask = 0,
-	};
-	int i, err;
+	int i, k, err;
 
 	mt76x2_reset_wlan(dev, true);
 	mt76x2u_power_on(dev);
@@ -210,15 +206,14 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 		return -ETIMEDOUT;
 
 	/* reset wcid table */
-	for (i = 0; i < 254; i++)
-		mt76_wr_copy(dev, MT_WCID_ADDR(i), &addr,
-			     sizeof(struct mt76_wcid_addr));
+	for (i = 0; i < 256; i++)
+		mt76x02_mac_wcid_setup(dev, i, 0, NULL);
 
 	/* reset shared key table and pairwise key table */
-	for (i = 0; i < 4; i++)
-		mt76_wr(dev, MT_SKEY_MODE_BASE_0 + 4 * i, 0);
-	for (i = 0; i < 256; i++)
-		mt76_wr(dev, MT_WCID_ATTR(i), 1);
+	for (i = 0; i < 16; i++) {
+		for (k = 0; k < 4; k++)
+			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
+	}
 
 	mt76_clear(dev, MT_BEACON_TIME_CFG,
 		   MT_BEACON_TIME_CFG_TIMER_EN |
-- 
2.19.1

