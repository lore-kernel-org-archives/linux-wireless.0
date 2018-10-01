Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29956C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8C220645
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF8C220645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbeJBFOx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 01:14:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33382 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeJBFOx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 01:14:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id y140-v6so3576508wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l0Zo9P41+4voPcWp2zVCxRdduptJG1DoKRiWT/9C32A=;
        b=d/X8A6mUssdDRSxQLthqgN1cFd1gFvi35K4NNVZ+mD+CROPLgbbMhi9npBIAKQB22g
         gk7hG1uiRzNtfXeudJMTEm5ZUKiIhFk/wRjy/QP73YBLEbZ7M1/co4+POjupQg5wBlNf
         JVVMB4XzqLEm//eqhsgWEdwAda6cmv7d/4ckeUrzr/RmYnEYchUoRGvuxIeGfKBrjLsK
         4eRShA64VHAb26bdbhGbGfm0QiJ6/NFSkkpRb4DTzMEyT9h/AeY1fuTaSoxKhuLs7qdR
         OIy3JoEdr2AS4NfbVlzEf98syl2Yy0WhG3SwjeJJsVqlRKar0sGe2Hch+NeLpbvcr6TQ
         r45g==
X-Gm-Message-State: ABuFfognqQ2aPZ1ZE69clBUXxY5zkc081VrWm0gY+AbiQhiBLVBDL6I+
        RF9G6eXIUza9zNrvfPe3jGax6gWrnEc=
X-Google-Smtp-Source: ACcGV63PKEsEkhzX3NjB27kbfDG9mkK7jSmlNfBrSm4Lv2P62M271wJDmRkscQWb3vB6lz/X83Vm2w==
X-Received: by 2002:a1c:a9ce:: with SMTP id s197-v6mr41840wme.82.1538433291460;
        Mon, 01 Oct 2018 15:34:51 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id 184-v6sm22231093wmv.6.2018.10.01.15.34.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:34:50 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76x2: remove leftover function declatarions
Date:   Tue,  2 Oct 2018 00:34:29 +0200
Message-Id: <20181001223429.21061-4-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.19.0

