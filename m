Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190257;
	b=zzYRU5KZHOUovkBkqN+OrSvRYDMHE4447zRhRWd/OhRhAk9pLEtmh+lHkWy0c9WmfJlK
	 5gqr1DSss2AG7LzbFSE9wOfH72/0qV7f73xWvpRqTr7b0A3UpLaPiDhw/9ebKZcRC7JUF
	 BxOlLkDuEjEQkXu7KXWDc4DuVN+SF7G3Bj27/LRxOZqY1i8iyBNd/EWiFwh9PXnIDeYLo
	 1AfRQl6NugUvBBliyara1Zi5h/ee8nAkXW8jGxUBximeaGVtdNGPO2wVx0mDdrMtgcvIy
	 x1PGQx4dKmIJRN19m3RJ0bHvJHd04T0mIijHSpyljUhpGwdXpIK6igZW5YBzsNBp2YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190257;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=W2huyd4P3/w2XrCfHTeKH+GglXwct7CR3EjNkerNeyE=;
	b=Bq9sE6044oNufLWqmIEAWC1m+ODswlps8nLPZibpCn9tA8jmfbN3dsAcv7UzpOJdX9Mj
	 HiN7iEEs5Sq7z9Yxk4bXoBhLlAXlbnHVpQkfUG5kR6bRPRpTIwYwRXXQ9anBE7NNmcLaT
	 t3DZG2JfmCdFokQ8i8tu3fnjpMnRNriY8gcatEG+vqpE5utA39zNDxn9aFwYil2GWb67r
	 38g3hCyEtVqw5bxOEEJ1p67E3n/ETQDaXrmVnAugxzcPlVhZAqHf2VfZxUBFvsiHi0Obb
	 TVSezTf3ExkuHXYdg/mQ2X7E/zq6vKvU4/36LuBkOecSSoLXOEeP8XzcY/NPZxi6i7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=smQDZS5d;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D61606A32A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17D61606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=smQDZS5d
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W2huyd4P3/w2XrCfHTeKH+GglXwct7CR3EjNkerNeyE=; b=smQDZS5dNXUT1y2tz0AlbHC954
	wuqTysIohd3pxJdVkDFZVsD+Ddwv6m6XyXX8cA0w5B0gHxlKT4wY8qwddqwQkDPHGhvV7/Rasd6MJ
	M/15w8AWJ+Y6KbHgmWBmEHoXTw2Q2IaSKVcpYMWdv/BAFa5Nz1zMXwQQ+FlHJOjqNKtA=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hO-00C8Bw-14
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:10 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 25/25] wifi: mt76: mt7996: keep a unicast management frame on its MLO link
Date: Wed, 28 Oct 2026 13:24:03 +0100
Message-ID: <20261028122403.796394-25-nbd@nbd.name>
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

mt7996_mac_write_txwi_80211() sets MT_TXD5_FL for an MLD interface only
on multicast, EAPOL and 4-address null frames. A unicast management
frame to an MLD peer goes out on a link that the hardware picks among
the links of the peer, not on the link of its TXD. ML reconfiguration
depends on that link: mac80211 removes a link before it sends the Link
Reconfiguration Request, so that the request leaves on a remaining
link, and the AP MLD sends the Response on the link where the request
was received. With hardware link selection, the request leaves on the
removed link, or the AP sends the Response there. The station then
drops the Response, and the link removal ends with a disconnection.

Set MT_TXD5_FL for unicast management frames to a station of an MLD
interface, so that they keep the link that mac80211 or the driver
selected.

Fixes: f0b0b239b8f3 ("wifi: mt76: mt7996: rework mt7996_mac_write_txwi() for MLO support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index a92536180dbe..03670293a78f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -851,7 +851,8 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	}
 
 	if (vif && ieee80211_vif_is_mld(vif) &&
-	    (multicast || unlikely(skb->protocol == cpu_to_be16(ETH_P_PAE))))
+	    (multicast || unlikely(skb->protocol == cpu_to_be16(ETH_P_PAE)) ||
+	     (ieee80211_is_mgmt(fc) && wcid->sta)))
 		txwi[5] |= cpu_to_le32(MT_TXD5_FL);
 
 	if (ieee80211_is_nullfunc(fc) && ieee80211_has_a4(fc) &&
-- 
2.47.3

