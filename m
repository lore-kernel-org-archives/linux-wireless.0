Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=zWkkmFVTzXv+r+Pcd8lTBXpuanVJv3NiAtYRMQ2oASKjzl61vRkrSak422dxxMLp/+1a
	 kCj1QZeJf22AeLcxrrrLab3uCbR5XViHS0AdgvMbabeNAxfl0HkUz86e5xaNhi4S73xE1
	 xhUyi0XaplLPYHq45yTUqEYURTrBbDwh3oH2sx7nMxMy/uDFWfk5BxvIScYPCHlGBgYdd
	 kI41tgsMEhW5P+5CzZndXSm411okeTYlEjtyZA0MOcAIUrLEB09VvCYkzogiGpGMHJeZn
	 2AfJ6gcxICXyD3tzySJhf0Xi18jZNHtRG9/TaNIn7j/V1NRqNnECa3eJ+loMEtw1p8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LjDQyPvCOjYMB6yYJdmmd9DAcaJZRK3km26mngX/vkU=;
	b=4QbxnTinYdErRvVcfEP3XJqS1s7457d4krMJfBwKXD32PouyTsCLl69swLkxJ+ro3OC1
	 1x0HZbjz4K7mh471Lk6r23mTp6ly2hdCd5U5dAZPQP8Aakde/aN0zssEMs/ZbV+/+PtRQ
	 gh3/nnp+BGmwBe4tnM4zeTdm1NYtHBaUcfrJegr5eFSXlQIIMhttH4R68c6s7bWfqwMl8
	 VAuXWcngFVqNBhVeaH6KjsKp2dJZhMrU6ZWxPEhXqVbu7FgsJYqDJtYtgtZCsN9zShk8V
	 QzwPh1MF1Iqeex3fqW6+onEIC/C9tXohiJO2jDuT+UJsNvTns53s7JXS3iyGbb5Flsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=UIH23xcI;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2439B60A260B
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2439B60A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=UIH23xcI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LjDQyPvCOjYMB6yYJdmmd9DAcaJZRK3km26mngX/vkU=; b=UIH23xcIN1gPKgPe45juEiMAfh
	wtnZgh7shT2ROjhCQYZmHY7QrQBwQm8ICJcZowNhwNtKAkZbBIG9wbA7CTYlBSfEDflEnFJgenrew
	m5MZrvoD6lG4vRWvCSDzw5sPhXNhUlBfrracJJ+aGql5YuvnQVk4JXKbxnz1OycDzRRw=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hM-00C8Bw-28
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:08 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 15/25] wifi: mt76: mt7996: skip MLD address translation for encap offload frames
Date: Wed, 28 Oct 2026 13:23:53 +0100
Message-ID: <20261028122403.796394-15-nbd@nbd.name>
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

mt7996_tx() translates the MLD addresses of a frame into link addresses
for an MLD interface. It casts skb->data to struct ieee80211_hdr, but a
frame with IEEE80211_TX_CTL_HW_80211_ENCAP set carries an Ethernet
header, so the writes to addr1 and addr2 corrupt the Ethernet header
and the start of the payload.

Skip the translation for such a frame.

This is currently not reachable, because mac80211 queues encap offload
frames to a TXQ and mt7996_tx() receives them only when they bypass the
TXQ. Found by inspection.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index e97af1828444..f715817243a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2089,7 +2089,8 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 	if (link_id == IEEE80211_LINK_UNSPECIFIED)
 		link_id = deflink_id;
 
-	if (vif && ieee80211_vif_is_mld(vif)) {
+	if (vif && ieee80211_vif_is_mld(vif) &&
+	    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)) {
 		struct ieee80211_bss_conf *link_conf;
 
 		if (msta) {
-- 
2.47.3

