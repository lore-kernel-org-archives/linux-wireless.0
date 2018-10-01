Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED28C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 634DC2064D
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 634DC2064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbeJASZo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:25:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55886 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbeJASZo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:25:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id 206-v6so8452988wmb.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 04:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pa28zo1Ym7Sc0nRXV05cAFJwfyBh9wjstWXQLurcDBA=;
        b=NTuXyI8TECjQDpA8qu4C1VO4NA9sMGs6G22SXdgfW/WidXRulBtBZQ5WeJWUHZfYFG
         K2AYLTMcbLIM9HtdzjwhH9BaFx2HNlyPWr/d+G08FzcrZWguBQnQVOo+/B3SecNyBdhr
         6QoPhNL/q1mKpsEWGNtfliBhCsH+7Mwn40ZTvNGfj633q77CjGUVM8ZaO1R3BASoMi/G
         XIgcoz/zUrykt75e2mLd3qnylq14rqyqllMN+HXXwchEjyDqA9Nbg8SewxytWZ26ARkq
         GoUOaS4ckql8Vi0hlTlaoBi+L3tnU30waOCI+fNebK/PWXOdPTrd2KwK68NG3WOG8jjW
         rGUw==
X-Gm-Message-State: ABuFfojPo+fcRIp48ErzHZlRwaJIL04rzDFgve3T0Mvdzf7zDc10JziM
        QyTIaHAN3XMTCGeYNjhcWWdXvQ==
X-Google-Smtp-Source: ACcGV63Mv4Cceq8Hmfz/WOqIwe5zCpknBhDDTFeHkb6iWBLBaROK1Zzq6xIRpFUWrLKivZdw04PhnA==
X-Received: by 2002:a1c:b686:: with SMTP id g128-v6mr8137297wmf.83.1538394499057;
        Mon, 01 Oct 2018 04:48:19 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k63-v6sm19046977wmd.46.2018.10.01.04.48.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 04:48:18 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: init: remove unnecessary configurations
Date:   Mon,  1 Oct 2018 13:48:14 +0200
Message-Id: <26d8075223be86a471efe7d6d1d11fbb95a38d16.1538394294.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538394294.git.lorenzo.bianconi@redhat.com>
References: <cover.1538394294.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove leftover configuration for legacy devices in
mt76x0_init_mac_registers routine. Moreover substitute
msleep function with usleep_range routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index edfd5d94d197..f59363f12c0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -172,12 +172,7 @@ static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
 	reg &= ~0x000003FF;
 	reg |= 0x00000201;
 	mt76_wr(dev, MT_WMM_CTRL, reg);
-
-	/* TODO: Probably not needed */
-	mt76_wr(dev, 0x7028, 0);
-	mt76_wr(dev, 0x7010, 0);
-	mt76_wr(dev, 0x7024, 0);
-	msleep(10);
+	usleep_range(10000, 20000);
 }
 
 static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
-- 
2.17.1

