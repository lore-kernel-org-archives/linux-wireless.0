Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3906C43331
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2F0F2067B
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573612080;
	bh=WatvhTlnTrUeKgE4vGEfMfvYTXMAw5MLRYU+EHcOmmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LpeYZj7R+Hscp5rGMZqi2dPSkUfDJ/83VmjC5gKfEtl2UBhII99VxFKHIPBJ5EDM3
	 GCAFjI/u0Tg8oQT/gpwa5oUC7LdBV/XAhK249ZrHVbgSSXpq/RbNLcsvQhdhOvGmOR
	 gJWU36A41E4kn6Q/uQr3tsZRMe6wBb6RU+vUrlfw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbfKMC1o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbfKMBur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D54B222CE;
        Wed, 13 Nov 2019 01:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609846;
        bh=WatvhTlnTrUeKgE4vGEfMfvYTXMAw5MLRYU+EHcOmmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLPpSQMue8YGB9dBP1N6Er52/66wIf2qQ/6uw5JzrNrbJZxuWiww/+yO9BaMeJYr1
         pmc3ehZfNLkpSJx/1rJgT2/2W8eOexDfD+PT8cfuTqQpfVbL1CienxDN+NqlFjq91a
         Jpjn1KBaAayicGysk/zGTWrYdlius+KTxqzZe0hc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 018/209] mt76x2: fix tx power configuration for VHT mcs 9
Date:   Tue, 12 Nov 2019 20:47:14 -0500
Message-Id: <20191113015025.9685-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 60b6645ef1a9239a02c70adeae136298395d145a ]

Fix tx power configuration for VHT 1SS/STBC mcs 9 since
in MT_TX_PWR_CFG_{8,9} mcs 8,9 bits are GENMASK(21,16) and
GENMASK(29,24) while GENMASK(15,6) are marked as reserved

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index 9fd6ab4cbb949..ca68dd184489b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -232,9 +232,9 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_TX_PWR_CFG_7,
 		mt76x2_tx_power_mask(t.ofdm[6], t.vht[8], t.ht[6], t.vht[8]));
 	mt76_wr(dev, MT_TX_PWR_CFG_8,
-		mt76x2_tx_power_mask(t.ht[14], t.vht[8], t.vht[8], 0));
+		mt76x2_tx_power_mask(t.ht[14], 0, t.vht[8], t.vht[8]));
 	mt76_wr(dev, MT_TX_PWR_CFG_9,
-		mt76x2_tx_power_mask(t.ht[6], t.vht[8], t.vht[8], 0));
+		mt76x2_tx_power_mask(t.ht[6], 0, t.vht[8], t.vht[8]));
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower);
 
-- 
2.20.1

