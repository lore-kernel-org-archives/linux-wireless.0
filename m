Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E865BC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8BED20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8BED20875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbeJEO6a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:58:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37517 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbeJEO6a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 10:58:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id 185-v6so991017wmt.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3X0Vmwzw87PuuogTzOuFuZdLgQofmlrLzQAFtAGtcGs=;
        b=YqZhxyMfawg4Bv69yYeVfmfhRvW7evMIgaD3+l2ufBEaP7SzHY/tvx8iIS4LC2BNGQ
         Ac+I+Vz4bXspGg1hQ5GJpdKzV12FGWwKrI0ZeCNcIzN2MOz0EEjnvzBk/cHZn4a4mEXx
         5Zr4aw/SlVNNLWdVYVjZPyWhqXCC7SYEuytm+cCWWHQBx1m73vcRE2Vgq52Y+cY4oRj6
         kWE0fLA9jLxAowQN1/wrIfm682Gr8J6tqOQA113wkO6UuQsucdaF2QEoPdF1r3z5rZBA
         HnSWkL+HFNIgzNSEgqY3nGIZoa28Q/GRs6ZlPrVF7R1dpju6K+BOWpv6CHELuM0scei4
         JGFg==
X-Gm-Message-State: ABuFfoi8NMqKiQfHmeJ1DrVnbTRK9/Ey7VDXuALgew9UkkoINYpVavPC
        MhFnRLUrC3wDEiq1a2Apb09oyQ==
X-Google-Smtp-Source: ACcGV621KSkaClDcHVrsTggopn1n3VoYY96B5hssK2nMzKzSbFqAz+g/OP+yixmlS8gDOZZS+3h1vQ==
X-Received: by 2002:a1c:9908:: with SMTP id b8-v6mr6821904wme.59.1538726455691;
        Fri, 05 Oct 2018 01:00:55 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id d2-v6sm4826947wrn.20.2018.10.05.01.00.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:00:55 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/3] mt76x2: remove leftover function declatarions
Date:   Fri,  5 Oct 2018 10:00:34 +0200
Message-Id: <11c24a593cf2ba48a02b88719e7fa9a144d37073.1538726002.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538726002.git.lorenzo.bianconi@redhat.com>
References: <cover.1538726002.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove following function declarations since they have been moved
to mt76x02-lib module:
- mt76x2_sta_add
- mt76x2_sta_remove
- mt76x2_remove_interface
- mt76x2_conf_tx
- mt76x2_txq_init

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 62a211563056..c4d1e5d8cea2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -111,16 +111,6 @@ void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
 void mt76_write_mac_initvals(struct mt76x02_dev *dev);
 
-int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   struct ieee80211_sta *sta);
-int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      struct ieee80211_sta *sta);
-void mt76x2_remove_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif);
-int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   u16 queue, const struct ieee80211_tx_queue_params *params);
-void mt76x2_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq);
-
 void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait);
 void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 				 enum nl80211_band band);
-- 
2.17.1

