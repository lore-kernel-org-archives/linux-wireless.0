Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F941D233
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=F6FuN/4XuKoysmTKJIueO68aYOFW8LLbBuPl/2dnTbAmyGL/R7vhJ74RT3q1wQuxi4jplIOK/hYYBJqRBymjzzo0l/wcj7z89l9OiE7UxeQM9NBQ1QX1smlmwPJuKCAYIzq8bhpqiXzoSyao4n/v6S2oHi3aNbhTsKc4N0Kw8G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=bcMZ1hsr/k3cAcsTflu4zVrgx4q81vnN27HuZ3lbW+4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYTu8CnnCsUmAixRRZWNwl7Y5WFa7VRP3/mRybmvPy4pza032v2/hwiLA55XsZDeK0l+vNw/sXwUDug3O4HN+mmzkE0ZwirKNFWYnVrHylXDacVspWPDhu+KBHNaa0ZU9IwkeUDVdSQxCzRn5a/wgTHPELorMWF3BTYukXoI+Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Y6HieSOO; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Y6HieSOO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yyNHlNoMYEfIwOzusMkau+jLk5s1Xk30bincm7pq4j0=; b=Y6HieSOON/NlnrvlCViCRAqSzK
	cergB23dGyWkQk4uCf6Y/mWtbZEmeb3qZRlLTLHChfUWJhb4AaM/E/EFWBUxd6ECLdAjRthxHMey7
	72uMy/oHoWjGpt+ZMiJ+xOBc/FJ0pw0fOmiOvPvgLwsUGZCh7OVgvn9v0zsOVfr6KYqU=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsl-008KN0-0c
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 11/15] wifi: mt76: fix queue assignment for disassoc packets
Date: Mon, 27 Jul 2026 15:04:30 +0000
Message-ID: <20260727150434.1778520-11-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peter Chiu <chui-hao.chiu@mediatek.com>

Like deauth, a disassoc frame sent to a client in powersave mode can get
stuck in a tx queue along with other buffered frames, filling up hardware
queues with frames that are only released after the WTBL slot is reused
for another client.

Move disassoc packets to the ALTX queue, matching the existing deauth
handling.

Fixes: dedf2ec30fe4 ("wifi: mt76: fix queue assignment for deauth packets")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index dc8407be2891..b03be0eb4712 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -631,6 +631,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		    !ieee80211_is_data_present(hdr->frame_control) &&
 		    (!ieee80211_is_bufferable_mmpdu(skb) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
+		     ieee80211_is_disassoc(hdr->frame_control) ||
 		     head == &wcid->tx_offchannel))
 			qid = MT_TXQ_PSD;
 
-- 
2.53.0

