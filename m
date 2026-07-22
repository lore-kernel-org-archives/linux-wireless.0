Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F8B22B8DF
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708782; cv=none; b=GfuunUP2KihEQMZW0KG9xw1jljTqAVl8wyRpy5TY6LqcH3XQLA4zcW8gI+/E7Ii6HNyoopkHsIY7C5OjNbhK2ltyyxpAHtHIHPtgyAH8lTTKAQDXs9TD24YZicX8dEFVgp2D7ZaKjt7Z9x56Y+7x45xMKz2xdZijFGtCMz8Oyl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708782; c=relaxed/simple;
	bh=j7iY7At6P1RKlF4+OZ3ZnAsDoNQzvPTbbscagKpZWhI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uftp8MqPAEjTUh8hATEGfm7CMXkR5NoSZ7evkpBk6JQUSFYO0dyaoblWEwyb6eZx69obn2wYQdAncG5q/FR8MlrS8MqVvVVtK/X9snIexqvkwDvo//yE1kYYfC8Neus9yvP3aoLgZAhDfMRBcIiRmmj1KPtltPVNIwVkXL9OWvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=PW7Ijj9S; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="PW7Ijj9S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ES/Lqs9gvzZK6uZXry5fWcpcgzX3ax8VBus/JerxPoc=; b=PW7Ijj9SD0UAqEVc/oJqbqirof
	ucDXv2tlkgyKESmXwfOOIcjybf+visCA1+PnJiBuTZlkt9xA5RXaoG5qKiEq/vqyRtuJiNLkpyBzB
	awAJV259doU+zf40D6CsS+rvM1Dn5dpHnu58QKQbJWOTqb37y/5DYUBW6HxiCd8M3a2U=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHP-005AHx-1i
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 04/18] wifi: mt76: fix non-AQL packet accounting for MLO stations
Date: Wed, 22 Jul 2026 08:25:56 +0000
Message-ID: <20260722082610.2699628-4-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

__mt76_tx_queue_skb() overrides the wcid passed by the driver with
sta->drv_priv, so the wcid might incorrectly be changed after TX,
causing wcid->non_aql_packets to be counted on the wrong wcid. For
example, on the AP side, if a station's setup link is the 5G link and
the station uses 2G to transmit a frame, the value of non_aql_packets
is increased on the 5G wcid but decreased on the 2G wcid. Once the
inflated counter exceeds MT_MAX_NON_AQL_PKT, the TX scheduler
permanently refuses to service the station.

Drop the reassignment and account on the wcid used for transmission.
This also records the actual wcid in the queue entry.

Fixes: e1378e5228aa ("mt76: rely on AQL for burst size limits on tx queueing")
Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index dc60a9661b74..f477157ee589 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -339,10 +339,6 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
 	if (idx < 0 || !sta)
 		return idx;
 
-	wcid = (struct mt76_wcid *)sta->drv_priv;
-	if (!wcid->sta)
-		return idx;
-
 	q->entry[idx].wcid = wcid->idx;
 
 	if (!non_aql)
-- 
2.53.0

