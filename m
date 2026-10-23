Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754008;
	b=bnXEo2ZgqvsXEFGTIXl6jcvHHgvZm3/THXZPiwcBCjvp6hmKOgPZU48BgTJ4Vs2mS8be
	 I0XQ2+md+40RtckzSFRFxE77l7TSox1UDjfVlqvFCzJlZ861rh+znp9PsxXhRli4hEGcA
	 96Cov3EeqH+G0bT770su2xPVpoxdh1yjTA/OMTVVvzvfJYGwsryJ68f6LGl/1MchMBaJb
	 cKLo7O9nQRyGETtEjVUoOE/xeGSCQ4ek+CE4NrDXmJvHTb1A3v78k2FjQsSdvMeq3vxgf
	 cNDVCJELXce0rVcO/0PF6EvyjwhLj6HkPj9/RhjYTiu0RdbyO3r75FFJl4pdXv6QJAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754008;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NgMjl7Ej0ulqgqAdHBxVMEITLqJkDxiHZDssY1dYnkc=;
	b=G/HtXJVxCdziyMaoNp/7O6vhQc5EwhEjc0hGuH2mvf4bJU4VQixs4qfFfiYPP+W3O3XC
	 I8XBFHemFkNGwcGse+LZeDcnMh8uKCPlZI1ABZnkM0eCSfLWtiSaIpp+KbAw3MrhKp6OF
	 W1NFbc4vP1wbrbv2iS4CRNQB8Is3KplTnBajJOzfBkpu+Zz4qAxrJ52Q5DhtTM7L5wAMT
	 B9vMmcr64S6u81s7ICajczLNVOYZcYy4sUtY9XasmbCI9bHJ8tFM0ti3T1N20X6xRgs5g
	 7IVC6gkt71PWkOAVTeCrNInAPD02521snhOUy3ejoOTLY3gX/a+eMegKytpLwJ6/oVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=p2WsNyWt;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5263B606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5263B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=p2WsNyWt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NgMjl7Ej0ulqgqAdHBxVMEITLqJkDxiHZDssY1dYnkc=; b=p2WsNyWtfHoWtqYEcYI9guNQgV
	Sq5TbLRM39rDMO8SGOuXPOByRtwwa+uHFEgbLzONnJm46TQ68HBbqluuXvbeyc7e4vbG4KB4IsxEU
	kARuk+MAow8nSZJLsSN6rY6+0GqvcmRZTWodCvWGYaXCMdg8bfAIouHgu2vf6yq7TzsI=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKDD6-009eAh-2G
	for linux-wireless@vger.kernel.org;
	Fri, 23 Oct 2026 13:13:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 3/3] wifi: mt76: mt76x02: clear the wcid drop mask for all powersave responses
Date: Fri, 23 Oct 2026 13:13:18 +0200
Message-ID: <20261023111318.2802233-3-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023111318.2802233-1-nbd@nbd.name>
References: <20261023111318.2802233-1-nbd@nbd.name>
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

mt76x02_tx_prepare_skb() clears the drop bit of a sleeping station only
for frames on MT_TXQ_PSD. Only frames that
mt76_release_buffered_frames() releases from the driver TXQs use that
queue. Frames that mac80211 buffered itself go through the regular tx
path on their access category queue, and the hardware discards these
PS-Poll and U-APSD responses.

Clear the drop bit for every frame that mac80211 marks as a powersave
response or as exempt from powersave buffering, like
mt7603_tx_prepare_skb() does.

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 3ca530f1c171..1698eb9051c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -158,11 +158,15 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx_info->skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
 	struct mt76x02_txwi *txwi = txwi_ptr;
-	bool ampdu = IEEE80211_SKB_CB(tx_info->skb)->flags & IEEE80211_TX_CTL_AMPDU;
+	bool ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
 	int hdrlen, len, pid, qsel = MT_QSEL_EDCA;
 
-	if (qid == MT_TXQ_PSD && wcid && wcid->idx < 128)
+	if (wcid && wcid->idx < MT76x02_N_WCIDS &&
+	    ((info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
+			     IEEE80211_TX_CTL_CLEAR_PS_FILT)) ||
+	     (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)))
 		mt76x02_mac_wcid_set_drop(dev, wcid->idx, false);
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-- 
2.47.3

