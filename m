Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.32
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131099;
	b=iRJeNmciHyVaOsZOuUeUTZa4pNZzw5pu2jHJEbb0TLni6HFtvp+ApCNbeK6TWZ6tNBBR
	 OJxBBw5ytF4xeTtjKb59+gEr+pu8mJonz4rgtefvIzh++8WxxkXKNrGo6BbllNKyhKSgM
	 VY+3vgdVC4iyfcIY+sJvabFIT2SBWVRBp31LFaJIaP4PLLQPxJcY+PjX0Ow6m4ikqP1PR
	 GyidObrVvAm9VEpLqWF6EuJOSD9f4agrT0mYKGYv5hvTEd/iGx0GLyuXR8ehKBW4RNk4G
	 kqMlO9g/tAJjSbYGB2lkYTzI5L/L04EYcaMxqre+ZRqxMRftZf/uvsZKXF1qvXh8Y7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131099;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cJhLPFhreq0kby1+GoG6JYwvIcm4Ucp6yVaKB9f71aw=;
	b=y+YN18FW3x2fL7cUsZ8ineSFVwTQyCuRU3vQiYy6/LrnThiowGI5ritIPwBpJ4RoERlb
	 nGjAKYJyVZNSRPOd1aAS52dMob6QXput3GuYoLNNFHv3QfF9Tv+ddR3fWiNjzT2rpFX6J
	 iOKCuDcflo3vZuarJn/YqVBQayTWwQ9KXaBLN1z8+Rjl4uR8SpyNCaLdkmTdcOPq3gIn/
	 wZkOqNOeWwONdN1xn08PRlDokxKy/SHtAPzA9Q0Rnp3lZ4Vu+qYG7bRKX+5RLvs3OnPnI
	 mLG+duiyBS0tNmuBL+G8MHKhxzD/wModX11JmCkoNtRXLJsMEQW2PINXAMychZInhwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=c6ffjaSr;
	arc=none smtp.remote-ip=95.215.58.32
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4527D606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4527D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=c6ffjaSr
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PHDFZP89OIILUvmxSLDL3cX7w3QXqZewfsLiygSrbx4=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793131095; v=1; x=1793735895;
 b=c6ffjaSrrku/ZwOxEP2VJJhWd68heNIwr4ssENvh1wq5scB3Ku7liEcBZjEVEeqJVUthueer
 R/34iK0P1ukE275iZ5+6OeSl2S93GCfZ1PhmH32EjXQSJXsnuZYTuPGcCgrk/WCSV0L0H6swXFo
 cYdGwKEiwdhq6WIjM96LQCs75pmv+/XD/C5p3rnb2BIDNc96Uhvk7wM2qVbkHjrsjsSYH40J1PN
 dPP1qcE0gxZ2HvyK8yRdrxxTptQZ/LtjYxb/dSjS5JJRjL976RzY+jhWrLNSTroFlpuVGuU1gLX
 DuqP7fLjnHjUr2hU8sFBCVo4G+8hnHQSt/tg0cbkA6/LA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dd736aeec128e6c6;
	Tue, 27 Oct 2026 19:58:14 +0000
X-Mizu-Trace-ID: dd736aeec128e6c6
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Gavin <a_gavin@icloud.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless 3/4] wifi: mt76: mt792x: pass monitors to the driver as real vifs
Date: Tue, 27 Oct 2026 12:58:02 -0700
Message-ID: <20261027195803.711995-4-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027195803.711995-1-lucid_duck@justthetip.ca>
References: <20261027195803.711995-1-lucid_duck@justthetip.ca>
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

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

An active monitor on mt7921, and on mt7925 other than MT7927, never
gets a channel: its request goes to the shared virtual monitor, which
it does not use.

Pass every mt792x monitor to the driver as its own vif, as MT7927
already does. Commit 55e95ce469d0 ("wifi: mt76: mt792x: improve monitor
interface handling") did this and was reverted because capture stopped.
Commit a7d35545c2ce ("wifi: mt76: mt7921: assert sniffer on chanctx
change") and the previous two commits arm the sniffer it was missing.

Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index dbea3c2e626f..dcb244a3f8ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -835,10 +835,7 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, SUPPORTS_TX_ENCAP_OFFLOAD);
 	ieee80211_hw_set(hw, SUPPORTS_RX_DECAP_OFFLOAD);
-	if (is_mt7927(&dev->mt76))
-		ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
-	else
-		ieee80211_hw_set(hw, WANT_MONITOR_VIF);
+	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
 	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
-- 
2.56.0

