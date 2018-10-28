Return-Path: <SRS0=/i66=NI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F94C2BC61
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 22:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32FCA2082D
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 22:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32FCA2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbeJ2HlI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 03:41:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43733 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbeJ2HlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 03:41:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id t10-v6so6668875wrn.10
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2018 15:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zh+I6CpxDoNNfW0wEwMole7k6dnb6GzIot468UhPsDc=;
        b=jA+gL3F7OSF4p+AZUl+ypS9LcGB+Ss4OPqRyqSOkooyNLp3kRG9XlAuKz/gSa/lIko
         B0717kei1fcMlJyfGTqnZkc3bsTc7OjGGUqYm9/nlIzD/35MjbbBMJ9okrba1Eqf/NNS
         etyv5/rOXUJt0sxIxSczU5aEWXYTxiZY27193EkHepEX+aJTJF41zSLDcrHXWbtlGr9f
         aGhjkmKfqwHAneRaGg9OQXe6hpvLNbxN8Wph099cDYeVpW4lykVvp2gxC3mGeBS3WeAw
         C4YNH6X1a7HvyEeRL0PQHr6QeDxZrQBTP/+e3T2qzAGVAluy5AyrU7yn2jTLxzz0DpBZ
         6Djw==
X-Gm-Message-State: AGRZ1gLc/u1k1QKacRWbKxA8ji9NiW75TsSGzgky10ZCXdr6dXAL5KHN
        ETlb5AWgp6q/L9i1s6eMTQXId/SnPOM=
X-Google-Smtp-Source: AJdET5eG0HpelP1FUV+PACYE2z8ieGyy/NILiaDP89NYU2nTEGP8q0oKLeE+/mVdaL42kJ8TM3mZyg==
X-Received: by 2002:a5d:46ce:: with SMTP id g14-v6mr12313278wrs.263.1540767302767;
        Sun, 28 Oct 2018 15:55:02 -0700 (PDT)
Received: from localhost.localdomain ([151.66.52.234])
        by smtp.gmail.com with ESMTPSA id s18-v6sm2322335wrf.61.2018.10.28.15.55.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Oct 2018 15:55:02 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: init: use mt76x02_mac_shared_key_setup in mt76x0_init_hardware
Date:   Sun, 28 Oct 2018 23:54:36 +0100
Message-Id: <2e94395e76c21ce9ec6005adeb1aa07aa3626a84.1540767086.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540767086.git.lorenzo.bianconi@redhat.com>
References: <cover.1540767086.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_mac_shared_key_setup utility routine for shared key
initialization and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 64eb6f451541..23ff29990ff7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -176,13 +176,6 @@ static int mt76x0_init_wcid_mem(struct mt76x02_dev *dev)
 	return 0;
 }
 
-static void mt76x0_init_key_mem(struct mt76x02_dev *dev)
-{
-	u32 vals[4] = {};
-
-	mt76_wr_copy(dev, MT_SKEY_MODE_BASE_0, vals, ARRAY_SIZE(vals));
-}
-
 static int mt76x0_init_wcid_attr_mem(struct mt76x02_dev *dev)
 {
 	u32 *vals;
@@ -260,7 +253,7 @@ EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
 
 int mt76x0_init_hardware(struct mt76x02_dev *dev)
 {
-	int ret;
+	int ret, i, k;
 
 	if (!mt76x02_wait_for_wpdma(&dev->mt76, 1000))
 		return -EIO;
@@ -289,7 +282,9 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 	if (ret)
 		return ret;
 
-	mt76x0_init_key_mem(dev);
+	for (i = 0; i < 16; i++)
+		for (k = 0; k < 4; k++)
+			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
 
 	ret = mt76x0_init_wcid_attr_mem(dev);
 	if (ret)
-- 
2.19.1

