Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=4kpzpw22f4HJ/etWPgaZEdb6ebt/eDJVr1937n5ou86EH5jwu/ujniE3mIgt/zMWIHex
	 15RR4/MzuoLKz+QJDEOKWSPFQWOgqzD4qmMVRZ+KgR5h4HcTRYZb6TdnEfszjyRGTu8lT
	 7ahLrdpF9lhSUWh0EF/c3NbZscrPfJDcm7r3Qxfvd+Gj+Iojita2AU3tGk2BmFN47KV4P
	 gMk7aYsKN4CHdpLtw9uV8Xh2jG+jJIlhMzkVoqN9/u+PLOOqfpbD4rEXR/qIpZTLZX03e
	 ocjqOn/uFxMkueqm7Vxi5fwu7PjWnoUPYnwfOeciG9ShZ1oFq0zfn1qlIJfiN7ZIz/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TZBq6hk0z7IkHzKTHkkOyL8kK6QF0TUDAUmiq/HggO8=;
	b=IoBPId35ebeOuEXjOs/rAPa340GpFT/3UfrC6O7xSgW7UhMK+en7P4z9Akd/fZbblmTv
	 fHo4pCsC2c7zO29kN+sb64EtgzwRPzrkNS0yv1Pr5BXs67BnFvnwnOO5M177ynrGeStO2
	 +FWyHDhDQ3j2RDrWY+rl0najb/+pTy0rG4XfwFUYXHcvMACncqCtmTzk2r0yYiETcJOUq
	 bNQq9I2a4PmVEAYs6IBlDj9Cr1cZTpzPE6R4f42qFQLmJozyUfwi/oguugfcEdUk1bO9H
	 fBbWI9842A9VKtj4ZR1HepRuywaecYRU4E/nC2hgOGhgUDtY+YdXjqY9CDsEcYutdeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=FBfdnit5;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1D760A2611
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C1D760A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=FBfdnit5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TZBq6hk0z7IkHzKTHkkOyL8kK6QF0TUDAUmiq/HggO8=; b=FBfdnit5Pxsdy+qx3omG7x4kCM
	oZ/jj1x7u66vk10I/GHrN6+ZJBq9SRxwp7SMD2iPvMuorQ56zj7bUDODcXq2EMDnVcC3JXEN4JJmK
	CVHU7ydePdBTbNxfZ9Bbbdy5v0jFZG6cM/3l9Ufqk2Bzb9yP/9P9w0Jg2CyG4+5Uc1Eg=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hM-00C8Bw-3D
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:09 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 17/25] wifi: mt76: mt7915: upload the CSA beacon only once
Date: Wed, 28 Oct 2026 13:23:55 +0100
Message-ID: <20261028122403.796394-17-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
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

At the start of a CSA, __ieee80211_channel_switch() reports
BSS_CHANGED_BEACON with csa_active set and then calls
.channel_switch_beacon. mt7915_bss_info_changed() and
mt7915_channel_switch_beacon() thus both upload the same CSA beacon,
and each upload passes the initial count of the template to the
firmware.

Drop mt7915_channel_switch_beacon(). mac80211 calls it only after a
BSS_CHANGED_BEACON report, so mt7915_bss_info_changed() already uploads
the CSA beacon, like mt7996 does.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 556f8948abac..8cf7fde1a197 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -737,18 +737,6 @@ mt7915_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-static void
-mt7915_channel_switch_beacon(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     struct cfg80211_chan_def *chandef)
-{
-	struct mt7915_dev *dev = mt7915_hw_dev(hw);
-
-	mutex_lock(&dev->mt76.mutex);
-	mt7915_mcu_add_beacon(hw, vif, true, BSS_CHANGED_BEACON);
-	mutex_unlock(&dev->mt76.mutex);
-}
-
 int mt7915_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta)
 {
@@ -1803,7 +1791,6 @@ const struct ieee80211_ops mt7915_ops = {
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.get_txpower = mt76_get_txpower,
 	.set_sar_specs = mt7915_set_sar_specs,
-	.channel_switch_beacon = mt7915_channel_switch_beacon,
 	.get_stats = mt7915_get_stats,
 	.get_et_sset_count = mt7915_get_et_sset_count,
 	.get_et_stats = mt7915_get_et_stats,
-- 
2.47.3

