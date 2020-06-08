Return-Path: <SRS0=eW0r=7W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0EBC433DF
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE5120760
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Jun 2020 00:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591663903;
	bh=+6kXrgQ4NVOvyd8KUFY2r+iOtJb5sRwbTKszCOGlshU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=l8tv2Kt2k3cAxIKbme/8Lwyw9UbWuR/XOtFi9faqoL9IJPHxPXV8bhe2FxgRan/8V
	 s4UK/WAewBbbtkXfmAot1k8BvDZNm3E31C4zCJ9esOjkhqHaQ1jIBd8BZ0VuKgie9O
	 kKsQG52WiBtFtDKVUNVWRoD0mSJgpHTM+sZkpi9c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgFIAvf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728612AbgFHXKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B1D20E65;
        Mon,  8 Jun 2020 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657817;
        bh=+6kXrgQ4NVOvyd8KUFY2r+iOtJb5sRwbTKszCOGlshU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwBSWwlHHwT1eOdvbDAzMiAS1zda14eYEEjhXFzOUnZIORcjTIHzvJz89PaBHtkab
         hrF3YbjaR7v8uk6duvBlLrHAO/3tP2M3hPDKudu8v8EMFAUwXoNE88qQvGNAxRW2Zt
         PUr69nkY0Sm3GgfOOF04c/QiN8Q497lYLP7iiU5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 191/274] mt76: mt7615: do not always reset the dfs state setting the channel
Date:   Mon,  8 Jun 2020 19:04:44 -0400
Message-Id: <20200608230607.3361041-191-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fdb786cce0ef3615dcbb30d8baf06a1d4cb7a344 ]

mac80211/hostapd runs mt7615_set_channel with the same channel
parameters sending multiple rdd commands overwriting the previous ones.
This behaviour is causing tpt issues on dfs channels.
Fix the issue checking new channel freq/width with the running one.

Fixes: 5dabdf71e94e ("mt76: mt7615: add multiple wiphy support to the dfs support code")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/main.c  | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 6586176c29af..f92ac9a916fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -218,6 +218,25 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 	spin_unlock_bh(&dev->sta_poll_lock);
 }
 
+static void mt7615_init_dfs_state(struct mt7615_phy *phy)
+{
+	struct mt76_phy *mphy = phy->mt76;
+	struct ieee80211_hw *hw = mphy->hw;
+	struct cfg80211_chan_def *chandef = &hw->conf.chandef;
+
+	if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+		return;
+
+	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR))
+		return;
+
+	if (mphy->chandef.chan->center_freq == chandef->chan->center_freq &&
+	    mphy->chandef.width == chandef->width)
+		return;
+
+	phy->dfs_state = -1;
+}
+
 static int mt7615_set_channel(struct mt7615_phy *phy)
 {
 	struct mt7615_dev *dev = phy->dev;
@@ -229,7 +248,7 @@ static int mt7615_set_channel(struct mt7615_phy *phy)
 	mutex_lock(&dev->mt76.mutex);
 	set_bit(MT76_RESET, &phy->mt76->state);
 
-	phy->dfs_state = -1;
+	mt7615_init_dfs_state(phy);
 	mt76_set_channel(phy->mt76);
 
 	ret = mt7615_mcu_set_chan_info(phy, MCU_EXT_CMD_CHANNEL_SWITCH);
-- 
2.25.1

