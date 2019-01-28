Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0483C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF97D2147A
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548690498;
	bh=g/oYbflqXAgepNg1BLIjmsTLfnzwdT7UhliIQde4gtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=V2fBJEAXefS4YQbSbdh5XtFx0zpOSUNXEIwitqr7VpgkTpgS4zgINSEXIeRj1gPBg
	 4oAIS08v5+gZkq9wfNNc3AEm4gAOMeUHQrjYS21OLSEuHLKPaGmEXFP2Q1ulcTw9K6
	 Ap3My2YYA4/Q6kwmslrndACCoQClm15jTcIQ/Ru8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfA1PsR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:48:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbfA1PsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:48:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066172147A;
        Mon, 28 Jan 2019 15:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690496;
        bh=g/oYbflqXAgepNg1BLIjmsTLfnzwdT7UhliIQde4gtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2u/Ogc9B2pd2mrq5Z7ZIq5foujsSAh6AzJI8Q0ApJJXX9QkszSERflEWdRWpocEwQ
         Y68aBy0fJyBFYvh8ZVH/7S2EyGcyN03wgNPSmfa5AGjOgypv7ejj5NRKuyBpwck8wS
         WSJASq2RGdVpPV8XZPCjJAvZE/dGrQlpvkGJsuLc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 105/304] mt76x0: use band parameter for LC calibration
Date:   Mon, 28 Jan 2019 10:40:22 -0500
Message-Id: <20190128154341.47195-105-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit ad3f993a0857ad3b792e7463828eb0d90cdd6f4d ]

We use always 1 as band parameter for MCU_CAL_LC, this break 2GHz,
we should use 0 for this band instead.

Patch fixes problems happened sometimes when try to associate with 2GHz
AP and manifest by errors like below:

[14680.920823] wlan0: authenticate with 18:31:bf:c0:51:b0
[14681.109506] wlan0: send auth to 18:31:bf:c0:51:b0 (try 1/3)
[14681.310454] wlan0: send auth to 18:31:bf:c0:51:b0 (try 2/3)
[14681.518469] wlan0: send auth to 18:31:bf:c0:51:b0 (try 3/3)
[14681.726499] wlan0: authentication with 18:31:bf:c0:51:b0 timed out

Fixes: 9aec146d0f6b ("mt76x0: pci: introduce mt76x0_phy_calirate routine")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index cf024950e0ed..9c0a042c28b0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -585,6 +585,7 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	int is_5ghz = (chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
 	u32 val, tx_alc, reg_val;
 
 	if (power_on) {
@@ -602,7 +603,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
 	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
 
-	if (chan->band == NL80211_BAND_5GHZ) {
+	if (is_5ghz) {
 		if (chan->hw_value < 100)
 			val = 0x701;
 		else if (chan->hw_value < 140)
@@ -615,7 +616,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_FULL, val, false);
 	msleep(350);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 1, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz, false);
 	usleep_range(15000, 20000);
 
 	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
-- 
2.19.1

