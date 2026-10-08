Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA803DD521
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 07:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445477; cv=none; b=TNbvJHvMX/kmc8tbA0w2HLND0ByeCHVJyxIx3V1Mz5O7l3xvCNfKosxb603g+Mg9m/39iXLYYjkadVIO7IWOidJcIOjVjWk2Vw66W17e5Khw/FgZBvL1HJzclTWq6F/IZ9ggmfo1TzIxJTDp4XPoK8/440zpLbn3QWypfcHvhG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445477; c=relaxed/simple;
	bh=gpCsCyC61CkmX8/8E4IX0TI2mfIq56fnfitCjRRw6xY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ctqfJE/FIbgLmUuk/7NZi5+UQ/rKbyDHhUONEn7JS5H+Z1a6rC67ikhhPOR9QK5wCbulzoZ8SfIQjLVXgfXXb2Tc4A8t+sfveJJV2q+cVysyYwQl34W86o87CCcgGYv6Ou1LW6/y/fvqFvLo1mLx6bJ8dO2GUlVdAp6sR+cr7gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=aMAyKY7p; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="aMAyKY7p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NeIyFWBtTEMlsr7CaMgeEHtoFqHhTSsnhPR6nqZ6yJM=; b=aMAyKY7pKZDNHYu7oL+X8SVmLT
	8O+zCqH7rREYdhSmdNZtbx8Eugx40qhIbS+wAINFxT7Jq6JQ5tcCLyzxD36/U95SlwwFJtonXUY5l
	rh9e666ZE01NSOiOZ5bwcotPPmILj8zq7HQGKf8/2i/9luv8R1lbkR1Z6LFPgzOVPyDg=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEink-000Xc7-0A
	for linux-wireless@vger.kernel.org;
	Thu, 08 Oct 2026 09:44:28 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next] wifi: mt76: bypass DPD on a scan channel while a monitor is active
Date: Thu,  8 Oct 2026 09:44:25 +0200
Message-ID: <20261008074425.2717811-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit "mt76: fix monitor rx FCS error in DFS channel" set
CH_SWITCH_NORMAL for every channel switch while a monitor interface is
active, to keep CH_SWITCH_DFS away from a monitored DFS channel. The
monitor check comes before the offchannel check, so a scan channel also
gets CH_SWITCH_NORMAL instead of CH_SWITCH_SCAN_BYPASS_DPD, and the
firmware runs the full calibration on each scan channel.

On an MT7981 with a monitor on the 5 GHz phy, a scan on that phy took
10.8 to 11.0 s instead of 2.9 to 3.1 s. hostapd aborts its first scan
after 10 s, so ACS never completes a scan there.

Apply the monitor rule only on the operating channel.

Fixes: 24e69f6bc3ca ("mt76: fix monitor rx FCS error in DFS channel")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index aab4303fef65..152b75178b27 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -2156,7 +2156,8 @@ int mt7615_mcu_set_chan_info(struct mt7615_phy *phy, int cmd)
 	};
 
 	if (cmd == MCU_EXT_CMD(SET_RX_PATH) ||
-	    phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR)
+	    (phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR &&
+	     !phy->mt76->offchannel))
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->offchannel)
 		req.switch_reason = CH_SWITCH_SCAN_BYPASS_DPD;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 45a98c586efa..d7fac69ec999 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2838,7 +2838,8 @@ int mt7915_mcu_set_chan_info(struct mt7915_phy *phy, int cmd)
 	if (mt76_connac_spe_idx(phy->mt76->antenna_mask))
 		req.tx_path_num = fls(phy->mt76->antenna_mask);
 
-	if (phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR)
+	if (phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR &&
+	    !phy->mt76->offchannel)
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->offchannel ||
 		 phy->mt76->hw->conf.flags & IEEE80211_CONF_IDLE)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 25638c68c468..792e338a6644 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -927,7 +927,8 @@ int mt7921_mcu_set_chan_info(struct mt792x_phy *phy, int cmd)
 		req.channel_band = chandef->chan->band;
 
 	if (cmd == MCU_EXT_CMD(SET_RX_PATH) ||
-	    dev->mt76.hw->conf.flags & IEEE80211_CONF_MONITOR)
+	    (dev->mt76.hw->conf.flags & IEEE80211_CONF_MONITOR &&
+	     !phy->mt76->offchannel))
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->offchannel)
 		req.switch_reason = CH_SWITCH_SCAN_BYPASS_DPD;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 8d98616acd54..eeb6d89b01d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4199,7 +4199,8 @@ int mt7996_mcu_set_chan_info(struct mt7996_phy *phy, u16 tag)
 		.channel_band = ch_band[chandef->chan->band],
 	};
 
-	if (phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR)
+	if (phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR &&
+	    !phy->mt76->offchannel)
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->offchannel || !phy->mt76->chanctx)
 		req.switch_reason = CH_SWITCH_SCAN_BYPASS_DPD;
-- 
2.47.3

