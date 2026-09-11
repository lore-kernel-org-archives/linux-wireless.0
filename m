Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AC32C21D8
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 02:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094677; cv=none; b=qnZd0jfggk/JzWsN5HOLALeCXcAdUL/rSGQzCuTzUZD8C+ZqivNfuAESwzeRRgpKuK4OGzMdhWnFMhgI3huLs8XHoCgnWTZPffh91f85MjSaYQZy4rdh9ro/kcH3RoYrFSJtnla+PIw/zWPjcoPw6XwUmvSzzdoRzXl0bHRM4Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094677; c=relaxed/simple;
	bh=6s7db2mV+TlkzTBdjKbi5IdNEnFyPr3Kh2+StaULis0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V1mj8EGJBMeCslW4y7bZPwlx7QvrXDyzi7f3AWNW9qjXIAIUeADX22dT3j30oDzylIEM8pCapQOJ5NSIwkJ/CKionfz5sYwKP4HZz8Rp28aGJpfR3ltL/53QTgx86vFJWfdbgzN9sJXkGM164GYvWjHhViZPJJv+wiQKzItFofg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=jmR4bZcd; arc=none smtp.client-ip=91.218.175.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="jmR4bZcd"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6s7db2mV+TlkzTBdjKbi5IdNEnFyPr3Kh2+StaULis0=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789094672; v=1; x=1789699472;
 b=jmR4bZcdh9NrgUWk1uo/zORoV7q+POewcXMH1/mSHpeNKNEOtYyd40jpb7z2Uk9zGPp4QjyL
 srb3ro/D1zU9g5f4VfDnD6lJv2WIdWLeQ3szcSxKC1vvC6QyiZHZ3VUQDOJYPixtlxljULnhms0
 CDhmdJiSLxgvsgE9JH9MAFhbm/i8ZF2xEXSJNrUlp/u7IybV0EC67jtLebpnfdHKVrfg5RHD0J4
 NN/rb/RmqXxJ0gA7/TjqPOCqcEphj7UgnZv27oj8fHsWJ12sYV73lKtW/58Pe+/HmfhuQGj26SO
 ZqMQOlNUfaqI83NRSygNajMblCiveyPU0caGq46hVhm1A==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ea8fa00fd0bba988;
	Fri, 11 Sep 2026 02:44:32 +0000
X-Mizu-Trace-ID: ea8fa00fd0bba988
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mt76: mt7925: don't put the band auto marker in TGID
Date: Thu, 10 Sep 2026 19:44:28 -0700
Message-ID: <20260911024428.65244-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

band_idx starts out as 0xff, which tells the firmware to pick the band on
its own. A remain-on-channel grant normally writes a real index over it
before anything else looks. Two cases never see that: an MLD station
throws the grant away, and an AP has no association to trigger one.

The TX descriptor reads the same field into a two-bit slot, so the marker
comes out as 3. Every data frame from those two goes out tagged band 3.
Beacons are fine, they reach the firmware separately and never build a
descriptor.

Same numbers on an MT7925 and on a Netgear A9000:

                        stock         patched
  station, one link     0x00000001    0x00000001
  station, two links    0x00003001    0x00000001
  AP                    0x00003013    0x00000013
  real band index, STA  0x00001001    0x00001001
  real band index, AP   0x00001013    0x00001013

Only the marker cases move.

Fixes: 0cb349d742d1 ("wifi: mt76: mt7925: update mt7925_mac_link_bss_add for MLO")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 101f571b0..3b82c9de2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -798,7 +798,8 @@ mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 	val = FIELD_PREP(MT_TXD1_WLAN_IDX, wcid->idx) |
 	      FIELD_PREP(MT_TXD1_OWN_MAC, omac_idx);
 
-	if (band_idx)
+	/* 0xff means BAND_AUTO to the firmware, and TGID cannot encode it */
+	if (band_idx && band_idx != 0xff)
 		val |= FIELD_PREP(MT_TXD1_TGID, band_idx);
 
 	txwi[1] = cpu_to_le32(val);
