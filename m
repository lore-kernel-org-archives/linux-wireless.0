Return-Path: <SRS0=6eO7=TB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898FFC04AA8
	for <linux-wireless@archiver.kernel.org>; Wed,  1 May 2019 16:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 576AA208C3
	for <linux-wireless@archiver.kernel.org>; Wed,  1 May 2019 16:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556726881;
	bh=zUf7rDK62Ax1d3lMjUdPwaUVfYGPr3d0dspTrJM4C/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AaO4lCTW7ozrUD7CquXvYAT6CIxJmHiro1qtiBdvso/N4zzew04cvPIjDPpPAEFQU
	 67BW9tUprOUorY7DELhJiKcTWnnTNfFFf/pDapJDY3cvJ0PakZtM0gu5n7ki/c9oG0
	 V9NTYv97ctE6iWNe/2igc0GwFWrCcFCRiHeR1mxE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfEAQIA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 May 2019 12:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfEAQIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 May 2019 12:08:00 -0400
Received: from localhost.localdomain (unknown [151.66.22.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 592462177B;
        Wed,  1 May 2019 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556726879;
        bh=zUf7rDK62Ax1d3lMjUdPwaUVfYGPr3d0dspTrJM4C/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ho/+M22f5SFTlmXnPHz9XW1CmvZlYLWFGikCwPmBtTavmA8y7cc4SXc0DnO/Lyau
         lvtBa+HLB8zIpEwdAIgxJCQC9ryN2JfAqnHsylxIXCM87y1QwWVZSezNXX3wkGlHYb
         3bW3efDAGX1b0P7Y0DyTLqkC7tQpEODJWCP9zT0I=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [RFC 05/17] mt7615: mcu: use proper msg size in mt7615_mcu_add_wtbl
Date:   Wed,  1 May 2019 18:07:27 +0200
Message-Id: <96456a49763d7410f1fc9183930552fb29ef1d35.1556726268.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1556726268.git.lorenzo@kernel.org>
References: <cover.1556726268.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use proper mcu message size in mt7615_mcu_add_wtbl and do not
allocate a huge buffer. Moreover use stack memory instead of heap one

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 54 +++++++++----------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 8c76274fd79b..1d7c8cf56040 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1029,37 +1029,31 @@ int mt7615_mcu_add_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 {
 	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
 	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
-	struct wtbl_generic *wtbl_generic;
-	struct wtbl_rx *wtbl_rx;
-	int buf_len, ret;
-	u8 *buf;
-
-	buf = kzalloc(MT7615_WTBL_UPDATE_MAX_SIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	wtbl_generic = (struct wtbl_generic *)buf;
-	buf_len = sizeof(*wtbl_generic);
-	wtbl_generic->tag = cpu_to_le16(WTBL_GENERIC);
-	wtbl_generic->len = cpu_to_le16(buf_len);
-	memcpy(wtbl_generic->peer_addr, sta->addr, ETH_ALEN);
-	wtbl_generic->muar_idx = mvif->omac_idx;
-	wtbl_generic->qos = sta->wme;
-	wtbl_generic->partial_aid = cpu_to_le16(sta->aid);
-
-	wtbl_rx = (struct wtbl_rx *)(buf + buf_len);
-	buf_len += sizeof(*wtbl_rx);
-	wtbl_rx->tag = cpu_to_le16(WTBL_RX);
-	wtbl_rx->len = cpu_to_le16(sizeof(*wtbl_rx));
-	wtbl_rx->rca1 = (vif->type == NL80211_IFTYPE_AP) ? 0 : 1;
-	wtbl_rx->rca2 = 1;
-	wtbl_rx->rv = 1;
-
-	ret = __mt7615_mcu_set_wtbl(dev, msta->wcid.idx, WTBL_RESET_AND_SET,
-				    2, buf, buf_len);
+	struct {
+		struct wtbl_generic g_wtbl;
+		struct wtbl_rx rx_wtbl;
+	} data = {
+		.g_wtbl = {
+			.tag = cpu_to_le16(WTBL_GENERIC),
+			.len = cpu_to_le16(sizeof(struct wtbl_generic)),
+			.muar_idx = mvif->omac_idx,
+			.qos = sta->wme,
+			.partial_aid = cpu_to_le16(sta->aid),
+		},
+		.rx_wtbl = {
+			.tag = cpu_to_le16(WTBL_RX),
+			.len = cpu_to_le16(sizeof(struct wtbl_rx)),
+			.rca1 = vif->type != NL80211_IFTYPE_AP,
+			.rca2 = 1,
+			.rv = 1,
+		},
+	};
+	memcpy(data.g_wtbl.peer_addr, sta->addr, ETH_ALEN);
 
-	kfree(buf);
-	return ret;
+	return __mt7615_mcu_set_wtbl(dev, msta->wcid.idx,
+				     WTBL_RESET_AND_SET, 2, &data,
+				     sizeof(struct wtbl_generic) +
+				     sizeof(struct wtbl_rx));
 }
 
 int mt7615_mcu_del_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
-- 
2.20.1

