Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD721E0DE8;
	Mon, 19 Oct 2026 01:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373541; cv=none; b=nF9TMgcum9EvdiZSroQmCVEfKiYrYLhqui8owVskf+m8fWt6HrLoAbyDN3GDA5MEs3n/4u4QUpYoVshyowT/8/KxZDfggqyTFpVq58MfQh6m7kyo8QMgNUatsMgGDSOGpfATh/QXBLIcYVwTMiRqtl60pd2GQwvQroo4ETg4Yxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373541; c=relaxed/simple;
	bh=v/pfBpRv6RvbRTdZhVeerig7+YcY6ilwiHEJ1nnwPQ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AGowHWt24JjA4Ax5Fd8iNMu8gS1FVI4El5/ltIdfXM2glrKp5wWfiL7whXmXU3EhO8WtyQPZfgwJdKwjSFwpinlVIQex0oMTJdhrY9QRvVntZIio6RC89dEwZZ/jooFSs7k5Vdm6OHh26DhC+crYXC8E+7HecAn39ZiRxZIxIJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fQWPm5mf; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fQWPm5mf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cN
	R3vb579dXsDYsujzLCTLqAAOGxXjoVkILSQWP2oe8=; b=fQWPm5mfBDj4rk4TrJ
	5C5lGQqMiOE4ZJLQ468NXt9Rxv0Z8YlJoJtp+nzgKDkFJC45sCjDnIxUgkr7WzNL
	q9JxzgCXNRWO9CqMNAtLCX2G/ba11RIASARGABhOb547LTvJIol7dMS53pfL+9nu
	AGfaBkN6nhywuuO5OgauW8rio=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wCnj78Dc9VqcUAyAw--.1470S2;
	Mon, 19 Oct 2026 09:31:48 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] wifi: mt76: mt7996: stop radios after add failure
Date: Mon, 19 Oct 2026 09:31:45 +0800
Message-Id: <20261019013146.1488644-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnj78Dc9VqcUAyAw--.1470S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF43ZF4DCw48AFy3Zw15twb_yoW5Xr4fp3
	yjka90yr4UArn5XF18Cr4jvF1rC3yxGry7CrWku3Z8Crn7CrZ3Jr40vF9FvF1rCrWxC3Wa
	vr40y3ZrWanxWFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piJPE3UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8ATtKGrVcwQqoQAA3y

A multi-radio interface can start one radio before starting a later
radio fails. add_interface returns without stopping the radios started
by that failed request. mt7996_run can also leave firmware radio state
enabled when setup fails after radio enablement.

Disable a radio when mt7996_run fails and track radios newly started by
add_interface so they and their monitor state are rolled back on a later
failure.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index dd7a01c02a7c..1cea0515a413 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -24,15 +24,15 @@ int mt7996_run(struct mt7996_phy *phy)
 
 	ret = mt7996_mcu_set_chan_info(phy, UNI_CHANNEL_RX_PATH);
 	if (ret)
-		return ret;
+		goto disable_radio;
 
 	ret = mt7996_mcu_set_thermal_throttling(phy, MT7996_THERMAL_THROTTLE_MAX);
 	if (ret)
-		return ret;
+		goto disable_radio;
 
 	ret = mt7996_mcu_set_thermal_protect(phy, true);
 	if (ret)
-		return ret;
+		goto disable_radio;
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
 
@@ -45,6 +45,11 @@ int mt7996_run(struct mt7996_phy *phy)
 	}
 
 	return 0;
+
+disable_radio:
+	mt7996_mcu_set_radio_en(phy, false);
+
+	return ret;
 }
 
 static int mt7996_start(struct ieee80211_hw *hw)
@@ -558,6 +563,7 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
 	struct wireless_dev *wdev = ieee80211_vif_to_wdev(vif);
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	unsigned long started = 0;
 	int i, err = 0;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -572,6 +578,7 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 		err = mt7996_run(phy);
 		if (err)
 			goto out;
+		set_bit(i, &started);
 
 		if (vif->type == NL80211_IFTYPE_MONITOR)
 			mt7996_set_monitor(phy, true);
@@ -584,6 +591,19 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 
 out:
 	mutex_unlock(&dev->mt76.mutex);
+	if (err) {
+		for_each_set_bit(i, &started, MT7996_MAX_RADIOS) {
+			struct mt7996_phy *phy = dev->radio_phy[i];
+
+			if (vif->type == NL80211_IFTYPE_MONITOR) {
+				mutex_lock(&dev->mt76.mutex);
+				mt7996_set_monitor(phy, false);
+				mutex_unlock(&dev->mt76.mutex);
+			}
+
+			mt7996_stop_phy(phy);
+		}
+	}
 
 	return err;
 }
-- 
2.34.1

