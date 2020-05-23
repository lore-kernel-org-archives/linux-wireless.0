Return-Path: <SRS0=ka5T=7F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8CBC433E0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 May 2020 04:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C024207DA
	for <linux-wireless@archiver.kernel.org>; Sat, 23 May 2020 04:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="brjn7n8m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgEWETe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 May 2020 00:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgEWETd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 May 2020 00:19:33 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CAFC061A0E;
        Fri, 22 May 2020 21:19:33 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k7so5847596pjs.5;
        Fri, 22 May 2020 21:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnKO8mEgKG0cuqfZGwVZY3dnnPkJgdITjBuWRWcUqiQ=;
        b=brjn7n8mURXe0FKXGVqBamb/EFgvxQBFyCyv8KRwVVLButg24bt1mO+ShPhCfc8b7b
         qyF0yYPI78ty562/3Y8jNL82dtOcK6AafaszzzWi/T4Q9iy6J1c6Qy8gaFoqzSoKzKNY
         f+mRVVq3hOSP3hmyktnJxhQiFm1YR2Ja2S7zfpuiqFXG1AfMQVJK8IIurdw8PzAXvztH
         OgNBa+L+q9gj/7prZDr7VvFi/Z9UjQnwklLZVdrktiW/83F+jpJ1/3Vv6gqLS9uEpkjg
         3yqgo99VvvnpNWibMzYlO0TrgNKAObuJsEzyJJa4H9Fwf9N9x10aKc1z8WfDnp3SMogA
         WR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lnKO8mEgKG0cuqfZGwVZY3dnnPkJgdITjBuWRWcUqiQ=;
        b=qkQfHzS9bQR/ErasgBSq1EcUOP8aw1DMlX9tJQ1eZAQVmttkWUU+VyYbglfd2oc+MR
         GL08HBn9PxcKU3hVFMRvt/MmZcnI83oIL9alp+UGXt0Ya4ECa6JlKPwCD4U1/Na+tyLa
         ytw+ez76MY5MCPd8evDfHqyLRHuej5L/hsLZ2UuGsZdVtALKfJY4fVLP/xPuoH9CLBrP
         fK1nlRzik2b6cnB17o/z+vYklvtnu/pKdfnlFQWAvy7TOe5YpCe2cyHpGALZGCYB6GXr
         qNM6Sb7HKxc6Cc0Ux7N4pv7r5YDvhbY8FkgqMpYqcuMflr92DVuUkV4HyzXQMDAwncnp
         pIXg==
X-Gm-Message-State: AOAM5307uk1jvDq+HPqNhubRgm3OLsyYxSNsESjRaYchHBrNHS6PQvJv
        EPJvSM4N7hLb+W2TP89kBD0=
X-Google-Smtp-Source: ABdhPJysX9LqXvkIYAcO2nda8F8H3jXr/8IwdGUWf9qFEo01Q6E3ECDmQaGCBwTTxTKz38LznCi7FA==
X-Received: by 2002:a17:902:bd07:: with SMTP id p7mr17186991pls.293.1590207573197;
        Fri, 22 May 2020 21:19:33 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id g18sm8202317pfq.146.2020.05.22.21.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 21:19:32 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     Ryder Lee <ryder.lee@mediatek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] mt76: mt7915: Use proper enum type in __mt7915_mcu_msg_send
Date:   Fri, 22 May 2020 21:19:23 -0700
Message-Id: <20200523041923.3332257-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Clang warns:

drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:232:9: warning: implicit
conversion from enumeration type 'enum mt76_txq_id' to different
enumeration type 'enum mt7915_txq_id' [-Wenum-conversion]
                txq = MT_TXQ_FWDL;
                    ~ ^~~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:239:9: warning: implicit
conversion from enumeration type 'enum mt76_txq_id' to different
enumeration type 'enum mt7915_txq_id' [-Wenum-conversion]
                txq = MT_TXQ_MCU_WA;
                    ~ ^~~~~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:243:9: warning: implicit
conversion from enumeration type 'enum mt76_txq_id' to different
enumeration type 'enum mt7915_txq_id' [-Wenum-conversion]
                txq = MT_TXQ_MCU;
                    ~ ^~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:287:36: warning:
implicit conversion from enumeration type 'enum mt7915_txq_id' to
different enumeration type 'enum mt76_txq_id' [-Wenum-conversion]
        return mt76_tx_queue_skb_raw(dev, txq, skb, 0);
               ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~

txq should be a "enum mt76_txq_id" as values of that type are the only
ones assigned to it and that is the type that mt76_tx_queue_skb_raw
expects.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Link: https://github.com/ClangBuiltLinux/linux/issues/1035
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index f00ad2b66761..916f664e964e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -220,7 +220,7 @@ static int __mt7915_mcu_msg_send(struct mt7915_dev *dev, struct sk_buff *skb,
 {
 	struct mt7915_mcu_txd *mcu_txd;
 	u8 seq, pkt_fmt, qidx;
-	enum mt7915_txq_id txq;
+	enum mt76_txq_id txq;
 	__le32 *txd;
 	u32 val;
 

base-commit: c11d28ab4a691736e30b49813fb801847bd44e83
-- 
2.27.0.rc0

