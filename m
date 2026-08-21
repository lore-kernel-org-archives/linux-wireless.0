Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F5717993
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 01:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787275553; cv=none; b=UUaPOLttxhgmE/B+QDgI0Y2u3r+/7SGQpq1q6sSWmbHkwWuD5/HmdN7g8BuV6/RZ/d2il71sFgMxo2D77dAqq2K0br2rGWF1Zm0+t0o5XSgfAOB3Exif2+NSGBpM8YCB1oYXQEeYg1My7dw9osfvAtv05NXmdzjQFLd968Qzhk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787275553; c=relaxed/simple;
	bh=wYQY1GTVeGvaiZc1MVTsQzbUEV+Len16CXrRVdAYl4g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hRTpMMmrohW1ETNA2Y1N7rwycCnv+gkIjAiSm9ATi5u7alDAKeesP//5dHJdcxGIeuqiNFvGL/PUwqMjtqjqncrWV+43DcUByUzM6tox6T7nOU9jBvej5USAi9bhTJLbYYAFPp4cy9b8JZ36V5c6D6NNHV+LEU5gh/BVvnr62zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=slolAnOO; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="slolAnOO"
X-UUID: 396f3d6c9cff11f18dc8c9802ae25ab1-20260821
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=p5GiJXrSInWGLYVDBdF42ox+8FqWGYR7BDF+4zj3OQY=;
	b=slolAnOOiFIgW4KXazdgUibNEanjDqEwVCoOTZ0ZcNJxEVs11yl/+519EYAUoH1ECkOe05wvfSsKgL71/J4GRl8mY8kFMnhx65VRaZHN7QaiVsMzwCM5cEaqyhk7RCuul7wTUPNcKbzHY5Yqs4C99ndW3IqRwcYBIar6k/a1bl0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b51c6c57-3766-47c3-9cf3-a6c6a7d245a6,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:f160b1e2-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 396f3d6c9cff11f18dc8c9802ae25ab1-20260821
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 937469066; Fri, 21 Aug 2026 09:25:41 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 21 Aug 2026 09:25:40 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 21 Aug 2026 09:25:40 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v2] [PATCH 01/05] wifi: mt76: refactor chip_config to accept generic commands
Date: Fri, 21 Aug 2026 09:25:24 +0800
Message-ID: <20260821012528.2259093-1-anthony.liu@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

The API, mt76_connac_mcu_chip_config(), was only used to send reset
command but the chip_config command is a carrier of more commands.

This patch enables other FW commands to be carried over
mt76_connac_mcu_chip_config().

Change-Id: I6a82052ab3a2bdb8aff5aeb3ccc692f527b826b1
Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index 6a1475e3c899..83cffa94bc0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -54,7 +54,7 @@ static int mt7615_config(void *data, u64 val)
 	int ret;
 
 	mt7615_mutex_acquire(dev);
-	ret = mt76_connac_mcu_chip_config(&dev->mt76);
+	ret = mt76_connac_mcu_chip_config(&dev->mt76, "assert");
 	mt7615_mutex_release(dev);
 
 	return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 2f925d22b9aa..de83d41ca9c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2044,13 +2044,13 @@ int mt76_connac_mcu_sched_scan_enable(struct mt76_phy *phy,
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_sched_scan_enable);
 
-int mt76_connac_mcu_chip_config(struct mt76_dev *dev)
+int mt76_connac_mcu_chip_config(struct mt76_dev *dev, const char *cmd)
 {
 	struct mt76_connac_config req = {
 		.resp_type = 0,
 	};
 
-	strscpy(req.data, "assert");
+	strscpy(req.data, cmd);
 
 	return mt76_mcu_send_msg(dev, MCU_CE_CMD(CHIP_CONFIG),
 				 &req, sizeof(req), false);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 0ededa569e9a..45f77c80e879 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -2098,7 +2098,7 @@ void mt76_connac_mcu_set_suspend_iter(void *priv, u8 *mac,
 int mt76_connac_sta_state_dp(struct mt76_dev *dev,
 			     enum ieee80211_sta_state old_state,
 			     enum ieee80211_sta_state new_state);
-int mt76_connac_mcu_chip_config(struct mt76_dev *dev);
+int mt76_connac_mcu_chip_config(struct mt76_dev *dev, const char *cmd);
 int mt76_connac_mcu_set_deep_sleep(struct mt76_dev *dev, bool enable);
 void mt76_connac_mcu_coredump_event(struct mt76_dev *dev, struct sk_buff *skb,
 				    struct mt76_connac_coredump *coredump);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index a5a70d8e8544..62bf33347e9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -237,7 +237,7 @@ static int mt7921_chip_reset(void *data, u64 val)
 	default:
 		/* Collect the core dump before reset wifisys. */
 		mt792x_mutex_acquire(dev);
-		ret = mt76_connac_mcu_chip_config(&dev->mt76);
+		ret = mt76_connac_mcu_chip_config(&dev->mt76, "assert");
 		mt792x_mutex_release(dev);
 		break;
 	}
-- 
2.45.2

