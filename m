Return-Path: <SRS0=wpaD=YZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46B3CA9ECF
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Nov 2019 22:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D0D2217D9
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Nov 2019 22:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572646884;
	bh=HUPGtTZLVpAWY+8RTZpAQ/hxyNw2qEjJR81px40iEak=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=A4lyv2d5HUAcIC+QmE25qknJuSCtLdepFdPgXo5ZC5HnwCTnLKsi0RHlINAXM42yI
	 iV64Tay+wlyMYKhqhcbNwyuvjwMCxye+qbQZkilTpvldvdFchnMrM3UAPYuf3JV2kx
	 3o5B2SeariSgb3A1eOvoRn8Ig50iPKgzCl3aoVfo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKAWVX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfKAWVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Nov 2019 18:21:23 -0400
Received: from localhost.localdomain.com (unknown [176.229.194.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ECFF20659;
        Fri,  1 Nov 2019 22:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572646883;
        bh=HUPGtTZLVpAWY+8RTZpAQ/hxyNw2qEjJR81px40iEak=;
        h=From:To:Cc:Subject:Date:From;
        b=y2AoqM5LnI7PfDmOKtF9VSu+8eN1BZNvToT8R9Uke7xCH8aSYAdvR5yIhZPB5sBRT
         LWIm8G77I2Ru79F/ceNMjylR4DTTdx8TCvZwOhBgL4wZZ4IM7HMZqn+VCwFTvJwD8u
         +bGlOha68K7gEDnDAKASclAv+J3Zd6rs3efGTPyk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH] mt76: mt7615: disable radar pattern detector during scanning
Date:   Fri,  1 Nov 2019 23:21:07 +0100
Message-Id: <8fa2b0b7fbdbb333274e7d7e650210b1a99461ec.1572645752.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Set switch_reason to CH_SWITCH_SCAN_BYPASS_DPD during frequency scanning
in order to disable radar pattern detector

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 3d960871dbbe..46f4f15fe0e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1333,8 +1333,10 @@ int mt7615_mcu_set_channel(struct mt7615_dev *dev)
 	};
 	int ret;
 
-	if ((chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
-	    chandef->chan->dfs_state != NL80211_DFS_AVAILABLE)
+	if (dev->mt76.hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+		req.switch_reason = CH_SWITCH_SCAN_BYPASS_DPD;
+	else if ((chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
+		 chandef->chan->dfs_state != NL80211_DFS_AVAILABLE)
 		req.switch_reason = CH_SWITCH_DFS;
 	else
 		req.switch_reason = CH_SWITCH_NORMAL;
-- 
2.21.0

