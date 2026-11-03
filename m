Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793665359;
	b=X3OsssB5kI0CmJwa9PIB8y/MqvbWSVcXxWqRNG+xZwHOCa+TK6Y2CLgWtEupUen9WHSw
	 uhVwZjuvUxRwn7mh+YIQg01OZnzEcp03IEfa6e37zk7X95c9j5HxodRkuRVasxn9jihCs
	 9GV+c6mX9K/cm/gGmi2BOZB+K/5CEQlMNHEVNE9WZ9827CY/nT2JrM+6/onMv5SEAkakE
	 HLsm/EnEnEqc04LqZPKZoLDi1kzg8spCuhCmCBNjwFG4q9UopAP8kZyqbAuWD/pVGTYZo
	 zzlevYBR03Q29I6+Im6WukWBdvr6JHqETKU4PPzZCLNOCpgQ2kBXfmtElzhZu3Y8MtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793665359;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:DKIM-Signature;
	bh=bbgOkBv14A9d4wO2ZfS0KJRZcE91RuXy5G4jiTp1jO0=;
	b=1MlWTiqMGb9hauxoOAallTG3vdqlFurV9N11kbAkuryKC+MLlfgUNGMmvNXD2lx+cPds
	 zkt3hsIqidjLuFXlnXC6KIPDmCqzJzNvxRCBdWPK1mPxC0pmL8ObXAJqYljDNpk2t384F
	 TOnkO1dAqj2nA2LBx+zNLWSvKioQ+byNGzOBdQHEe4x/Ty9rnSjsx/6XV5tb0XwfNziNP
	 A0x0Jeldg6FFbGiafRU2jWlxofaHgrR7w0I35CcukeZsmAeaPSuqLgDppBUc04BWZ+MwA
	 RZkR7PvnvRgxEj97PJFUogAea5V5eGXW0Q0Mw3CLn2gBct/D59g45Z44SrkdnujG+Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=david-bauer.net;
	spf=pass smtp.mailfrom=david-bauer.net;
	dkim=pass header.d=david-bauer.net header.i=@david-bauer.net header.a=rsa-sha256 header.s=uberspace header.b=Q4+ohvyn;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84624606D832
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 00:22:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84624606D832
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=david-bauer.net header.i=@david-bauer.net header.a=rsa-sha256 header.s=uberspace header.b=Q4+ohvyn
Received: from perseus.uberspace.de (perseus.uberspace.de [95.143.172.134])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id ED297610F8
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:22:28 +0100 (CET)
Received: (qmail 10944 invoked by uid 988); 3 Nov 2026 00:22:28 -0000
Authentication-Results: perseus.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by perseus.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 03 Nov 2026 01:22:28 +0100
From: David Bauer <mail@david-bauer.net>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH mt76] wifi: mt76: mt7603: avoid deadlock on failed channel config
Date: Tue,  3 Nov 2026 01:22:09 +0100
Message-ID: <20261103002210.166517-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: SUSPICIOUS_RECIPS(1.5) BAYES_HAM(-3) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -0.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=david-bauer.net; s=uberspace;
	h=from:to:cc:subject:date;
	bh=0IaUd68iA8zNEbntjgxpaciU9eYyrP6IEDHh8U3mBas=;
	b=Q4+ohvynJpU7XX6TsaKD4WHzqc2RVzr9ST4DSpvCWlmNBJ1ayJxeL4sGcg9wtynNR2uJe7NzvF
	PMSHno5Zqj0ZfVUlteK/coz8o3lzll7bo5JTRP30gDrMxi1aCZsHUmil78Z7A6jkfh9iCQRrWw8t
	vXmThNDw6uuc0n7MYsVIQDTASk2gh/9wCagelDvFuGTLw7YZ3B2BQvm1xBuaCy55eloMc3foW3rd
	YMdqtpwiIzD97wOz8x9DXKSuF+vhR46WuKFqIBLW6w8hvqSYDtKqJHPEiWV2Tx7YhLMD7ylvtLCN
	RGrwBNFk/4zls1I4wkHDIjXmXjFQmeSQ4nH9+C9cju4ZcqR7saPx6OvoCrTAY00LmkRBr02mIsdr
	qyht/1QKxNqzW4p9YRrjz1CS/omL0MIV163U3Vct4OcZxmxDhS0IXE27AEs5bGbTuF9hKZTgoQIM
	BHKA9smUcZbmWQVgQvQnO6dVCAp0tYEBg6yVvjYXSCDs/X3ZlvopeVOwden8sj6DTf4FALt2NppH
	MWQ69RxwVIGXQtykaORV4dDYvDLbbLqwVMa4jUCSVvGfoOpGd+qrBXGdPJEtw4PyFu5UETwrjWst
	1aS5aqr3DXb7OfwXLzw/uNB9fIdTeNv9fpOHb20YkpO6dxqXMCfUbcZ4ZgGp9mUF2bQdNJRrA1on
	E=

The synchronous call to mt7603_mac_work locks the global
mt76 device mutex. This can create a deadlock situation,
as the lock was already taken in mt76_set_channel.

Instead schedule the next mac_work iteration to happen immediately in
case a reset is necessary and perform the reset asynchronously.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 757664e9e1f20..61f2461939872 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -172,9 +172,6 @@ int mt7603_set_channel(struct mt76_phy *mphy)
 	mt7603_mac_set_timing(dev);
 	mt7603_mac_start(dev);
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
-				     msecs_to_jiffies(MT7603_WATCHDOG_TIME));
-
 	/* reset channel stats */
 	mt76_clear(dev, MT_MIB_CTL, MT_MIB_CTL_READ_CLR_DIS);
 	mt76_set(dev, MT_MIB_CTL,
@@ -191,9 +188,8 @@ int mt7603_set_channel(struct mt76_phy *mphy)
 		mt7603_beacon_set_timer(dev, -1, dev->mt76.beacon_int);
 
 	tasklet_enable(&dev->mt76.pre_tbtt_tasklet);
-
-	if (failed)
-		mt7603_mac_work(&dev->mphy.mac_work.work);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
+				     failed ? 0 : msecs_to_jiffies(MT7603_WATCHDOG_TIME));
 
 	return ret;
 }
-- 
2.53.0

