Return-Path: <SRS0=oU4Q=ZI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9ABC432C3
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 037E6214DE
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921679;
	bh=30FkFKk0NxEOy+6Bj802DFapeTmG8/Wur0OjpwyjWbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vB+fTb49lq3l0kqK1x7NiJUyIjT1QMb/BoC+j+RO0Q6zhRhKztwTwdyR2yjWjQYLS
	 wMnJi/3VfCr1PFz7AO3Vnt0Q6D4OlAjVPyc4d9XQAentaT39g4E03T39sIlBsNozVY
	 BE/BWM28CnJu/u/1rB324ccNNNq+Sn3WMtmnnLKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfKPPlb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbfKPPla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:30 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E5FD20740;
        Sat, 16 Nov 2019 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918889;
        bh=30FkFKk0NxEOy+6Bj802DFapeTmG8/Wur0OjpwyjWbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtY9IZdFdJzGwXWS/EYR5+OKH5pgagk35dtji48Q6oXHrKRM9SUJo7SFlguFyY8Pv
         BZjwrlFvpAP73+CGEX1eNRYpH3h8DWVE0h7mmxNFFuYqEBE6AB7LwilfM5C+esBLe0
         mBMIMBhqPq2zsWWCxepTllV23/znIFPu0P8M0CLw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 017/237] mt76x0: phy: fix restore phase in mt76x0_phy_recalibrate_after_assoc
Date:   Sat, 16 Nov 2019 10:37:32 -0500
Message-Id: <20191116154113.7417-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 4df942733fd26d9378a4a00619be348c771e0190 ]

Fix restore value configured in MT_BBP(IBI, 9) register in
mt76x0_phy_recalibrate_after_assoc routine.

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 14e8c575f6c3e..924c761f34fd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -793,9 +793,8 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
 	usleep_range(500, 700);
 
-	reg_val = mt76_rr(dev, 0x2124);
-	reg_val &= 0xffffff7e;
-	mt76_wr(dev, 0x2124, reg_val);
+	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
+	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
 
 	mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 0);
 
@@ -806,7 +805,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
 	mt76x0_mcu_calibrate(dev, MCU_CAL_RXIQ, is_5ghz);
 	mt76x0_mcu_calibrate(dev, MCU_CAL_RX_GROUP_DELAY, is_5ghz);
 
-	mt76_wr(dev, 0x2124, reg_val);
+	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
 	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
 	msleep(100);
 
-- 
2.20.1

