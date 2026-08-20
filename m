Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC6F4156C0
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 11:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224353; cv=none; b=cF6LDgBejG938dEThMJw+iizUo7N1lzYT0IA5ZSWVvhC+A1cA1YRfTEDxOvxquJvWX/ibv1VjTqgtlVbbrm0UmXMIWd9UwZuD690hTWxhy1d0Aev/RA4OdjzUOo24xX8YingyMqX2Gn15xCxdQvGtPUe6XH45EUv+Bd5mQAwKIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224353; c=relaxed/simple;
	bh=vsrfXTv1xN2Th/9cq2he1aC2aGJQXWvJGJhsH+LcMVc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XKIulzA8l28091ti2DQ+PGLr36Lg0JlWb7M9XRQ8dF/Q3uSzwancqrtcVBlCLOq+8wOUjov45UjUIiCYwu7uoBOoJSSgZeLGzg2o98IdTlKNPXG96daXHnA6SkyZHlkKiQv4B7jKEcPRUEM1Zanhhzkqra30bULIbcg2Q+jiAts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=T89ZvGLz; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="T89ZvGLz"
X-UUID: ffa9cfec9c8711f18dc8c9802ae25ab1-20260820
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=pSW0vTaHdqvoxxgPJ66HY7eg7tk75pq3rDu8tdmdE44=;
	b=T89ZvGLznkOtu5WN7uwUJU5tPona6cspMj8ULUGezKVxwxqHIpC9SyPmavCwICZ1MaUdu2/WTTxno0YJrl7XpdTq5pD/xb0u4hFgF0HWJM3dnaAw5Im+qGS4atZhzQgvjoB0O1K4jb/XT5+Cz31h3qIjTqczneNW1Wyemyts6Uc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ee536998-61cc-470b-9779-a8ecad4156ff,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:f54512f2-0685-46a3-9cac-19d8f3a05ae7,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ffa9cfec9c8711f18dc8c9802ae25ab1-20260820
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1229508644; Thu, 20 Aug 2026 19:12:14 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 20 Aug 2026 19:12:13 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 20 Aug 2026 19:12:13 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v1] [PATCH 01/05] wifi: mt76: refactor chip_config to accept generic commands
Date: Thu, 20 Aug 2026 19:11:58 +0800
Message-ID: <20260820111202.1935373-1-anthony.liu@mediatek.com>
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

Change-Id: I2b05c0805e28169cdb09ab6bf486b70e974866cd
CR-Id: WCNCR00542202
Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
Reviewed-on: https://gerrit.mediatek.inc/c/neptune/oss/nbd168_wireless/+/12378110
Reviewed-by: jb.tsai <jb.tsai@mediatek.com>
AutoUT-Review-Label: srv_neptune_adm <srv_neptune_adm@mediatek.com>
GAI-Code-Review: srv_ai_review001 <srv_ai_review001@mediatek.com>
Commit-Check: srv_check_service <srv_check_service@mediatek.com>
Code-Review-Course-Train: srv_check_service <srv_check_service@mediatek.com>
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

