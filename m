Return-Path: <SRS0=5aJJ=UD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569E7C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Jun 2019 10:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D0C424BAA
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Jun 2019 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559642782;
	bh=MQoyrD6Bmiyjp0O8dCZV1jCQyA7pDR8Ab/0HZDHSids=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=pfjW2qm0UU6vo5DRQgWSoFd0FigxIRhRvItGYenP6tUQZ3ni5zK8jcHOpuM0hEtCO
	 2By9Xg4Nx1NyAv1c3yW19Wl9Nru0UgkMw9kuYjGBEC9Bc/yhdeIgua0IvbjPzdh2lP
	 8vfqW0a/tlMwsETyDTkMo62oGqOZuSN/gemIUziM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfFDKGU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Jun 2019 06:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfFDKGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jun 2019 06:06:20 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F9224B8B;
        Tue,  4 Jun 2019 10:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559642779;
        bh=MQoyrD6Bmiyjp0O8dCZV1jCQyA7pDR8Ab/0HZDHSids=;
        h=From:To:Cc:Subject:Date:From;
        b=Ozvzw/5QLu8sBRLN3nv5zjkJOt7hf5PbbBJyoq1yIC8v/rl3hqNhiYC53RJvtBf3u
         C2F9uvcQlNcCzwSg7uxbL/+e00NxJ8sdyWRa/lLaEiJYTLvR4bf9nRpCPoi7P56tSe
         MBpR/haEbtiqv+sU6jU4zO6JnHXRE6xfS5cDHSV0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH] mt76: mt7615: remove unused variable in mt7615_mcu_set_bcn
Date:   Tue,  4 Jun 2019 12:06:06 +0200
Message-Id: <d2b9a68b797fbbd67fe8f3be0fe851113eaa1488.1559641771.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove tim_len in mt7615_mcu_set_bcn since it is not actually used
and ieee80211_beacon_get_tim checks if tim_length is NULL

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 93b1501fbcda..d104435cd901 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1130,10 +1130,10 @@ int mt7615_mcu_set_bcn(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 		/* pky_type: 0 for bcn, 1 for tim */
 		.pkt_type = 0,
 	};
-	u16 tim_off, tim_len;
 	struct sk_buff *skb;
+	u16 tim_off;
 
-	skb = ieee80211_beacon_get_tim(mt76_hw(dev), vif, &tim_off, &tim_len);
+	skb = ieee80211_beacon_get_tim(mt76_hw(dev), vif, &tim_off, NULL);
 	if (!skb)
 		return -EINVAL;
 
-- 
2.21.0

