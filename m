Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754008;
	b=wc70DfcMUl8zgasTqQpIwDpWfkkyHuFZYwzkZ7YSnuYyKz/uU1kEKJzhu5hjl/qKgGIO
	 iYCU9lirmBXhs4MQXoAmeIYDsLoUetgddmPck50l5tU4bmtBTvV5FP2sGLJS7H7Nz81cC
	 dsVgRTCyGoaf6hK0judIw8/4dUo1gZT8S0E6Rm6UCDi1vpQK8hHDWX777kqzxJcRyqQEf
	 ef/1wfNbGcknXcn6TSfgndszuRk51O26P2cC7YrfLuFPdcnijcZpzh1yTURf87ldG39GY
	 r04H+14turITVA3kinLtX9qLUl8w2t8mKknk1AZjmLrOOrwTK95VNqbScsRAAZHRv6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754008;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=aBNu5SRdBnpcTfV7kfGOhyjTErmpzqlkFixB5ENVcZg=;
	b=DJNYCchtv6lINSDiJiGA3fQi0gYmCz1I8aRBEzjPxxpSBYQZs0+lHuX08MtXoYQP9Gk1
	 YiHh3sm1XO87IleGoCOxwCJ5Fnk1ySOpcnYzRJxUdT0QrDJdNIIjD/GzvJdRYuryKLChH
	 m7kfgcVksCiPIjkGcf4A7nEbIpY5Ghuk/HLvTNnM03n/JgZiLGqvXP2FBEQ6rSByo/XME
	 LDozqUuMAmLILmZ5gYAmcePDf4oBczEb4phTSBzV9fmsAkXTGeTlgBTpBgyNcn0BMN7ch
	 4H/M8wfIwbSy49XljBmhYws3QiXpKGCdug5V5jAd4hZn7zZuukd/4gmPo4o65mE1dkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=ncu26p1m;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD5606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EECD5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=ncu26p1m
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aBNu5SRdBnpcTfV7kfGOhyjTErmpzqlkFixB5ENVcZg=; b=ncu26p1mJ3Z0zO1MoIQaTQUmMy
	os/6Wt+G/dphPdpi7n5A2r3MZwPuV5CvvnRTloxkQpa5UFpbAJ/8mlBHkAB8kEUm1Q9O3EX1NoA/c
	BaLl5CrGYsOl+5glgv/UZ8CqBqEJFC37wLDzeGrQLXXDiqNr0Al4jtIOY11ynv41NBss=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKDD6-009eAh-1A
	for linux-wireless@vger.kernel.org;
	Fri, 23 Oct 2026 13:13:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 1/3] wifi: mt76: honour the more-data flag when releasing buffered frames
Date: Fri, 23 Oct 2026 13:13:16 +0200
Message-ID: <20261023111318.2802233-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
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

mt76_release_buffered_frames() always clears the more-data bit on the
last released frame, so the client stops polling while frames are still
buffered for it. The .release_buffered_frames documentation in
include/net/mac80211.h requires the bit if @more_data is set or if the
released TIDs still hold frames.

Set the bit in both cases.

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 29 +++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index b022d3843473..ea9993e9a199 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -420,7 +420,7 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
 static void
 mt76_queue_ps_skb(struct mt76_phy *phy, struct ieee80211_sta *sta,
-		  struct sk_buff *skb, bool last,
+		  struct sk_buff *skb, bool last, bool more_data,
 		  enum ieee80211_frame_release_type reason)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
@@ -437,10 +437,29 @@ mt76_queue_ps_skb(struct mt76_phy *phy, struct ieee80211_sta *sta,
 			*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_EOSP;
 	}
 
-	mt76_skb_set_moredata(skb, !last);
+	mt76_skb_set_moredata(skb, !last || more_data);
 	__mt76_tx_queue_skb(phy, MT_TXQ_PSD, skb, wcid, sta, NULL);
 }
 
+static bool
+mt76_ps_tids_pending(struct ieee80211_sta *sta, u16 tids)
+{
+	int i;
+
+	for (i = 0; tids; i++, tids >>= 1) {
+		unsigned long frames, bytes;
+
+		if (!(tids & 1) || !sta->txq[i])
+			continue;
+
+		ieee80211_txq_get_depth(sta->txq[i], &frames, &bytes);
+		if (frames)
+			return true;
+	}
+
+	return false;
+}
+
 void
 mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 			     u16 tids, int nframes,
@@ -451,6 +470,7 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	struct mt76_dev *dev = phy->dev;
 	struct sk_buff *last_skb = NULL;
 	struct mt76_queue *hwq = phy->q_tx[MT_TXQ_PSD];
+	u16 release_tids = tids;
 	int i;
 
 	spin_lock_bh(&hwq->lock);
@@ -470,14 +490,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 			nframes--;
 			if (last_skb)
 				mt76_queue_ps_skb(phy, sta, last_skb, false,
-						  reason);
+						  false, reason);
 
 			last_skb = skb;
 		} while (nframes);
 	}
 
 	if (last_skb) {
-		mt76_queue_ps_skb(phy, sta, last_skb, true, reason);
+		more_data |= mt76_ps_tids_pending(sta, release_tids);
+		mt76_queue_ps_skb(phy, sta, last_skb, true, more_data, reason);
 		dev->queue_ops->kick(dev, hwq);
 	} else {
 		ieee80211_sta_eosp(sta);
-- 
2.47.3

