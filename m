Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A28547042C
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708783; cv=none; b=sTisYqmPk4ETuEiS3ieWwIneZGPzPttYFlP/T4axGIEROBGA6/s5K466HZ4TbSVD1KEVtDlDRhfETf2tUHLnjoGsMHhKbfF1zIV1kQ+Kt++h2xDzvhLRNfaEMj21mlEDRfqN23axZJ90lc0ToEPVWUoJV5OfFpvgh0mik6DxfXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708783; c=relaxed/simple;
	bh=4ZT+KwSqRhzQDNBu34XEiv87JwPzjtIwoAvCZ2xA/Bg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noJWOngON0FkcBQRTN8PBQj1334JXBA061FLKRp6ooEEggC16rzvQbDnXXpcL1nyDmuEP3DCun+a6XEAQORlyeQIcxeR4W9fDYOAMEJjysbLxbhFYKGrhcxbjNbsKHcRd8OUV1hG+68lsiTo/yuxPelvnQIh5N+lEDJpYumoeu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=UZob4gWv; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UZob4gWv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yCHAqceAmHveszw/t4VfUWnJ0nYKtRUhK6P3u9/ybLY=; b=UZob4gWvvgC5AuMW9Ev288ZxBm
	7r+OopXYFYkixKAC/jtBKPbwexjwuvwfOaIGWh3T8jdVsAialy8Ti6f1DrQEwVzVb5XvtJnZalkD2
	QKiTluN8+75TB1zdpRvqiRxepDnSQJW3WCCO4b9OJuTzkYL9kZSOH/tEnZv9YMJ/3wFY=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHR-005AHx-0Y
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 14/18] wifi: mt76: fix stranded frames in mt76_txq_schedule_pending
Date: Wed, 22 Jul 2026 08:26:06 +0000
Message-ID: <20260722082610.2699628-14-nbd@nbd.name>
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

A wcid is added to phy->tx_list whenever either tx_pending or
tx_offchannel becomes non-empty, but the requeue check after a partial
schedule required BOTH queues to be non-empty. When
mt76_txq_schedule_pending_wcid() returns -1 (queue stopped or
MT76_RESET) it leaves frames in tx_pending while tx_offchannel is empty,
so the wcid is dropped from every scheduling list and its frames stall
until the next mt76_tx() for that wcid or wcid cleanup. This strands
EAPOL/mgmt/nullfunc frames under momentary queue-full or across
scan/channel-switch, causing association and 4-way-handshake timeouts.

Requeue when either queue still holds frames, matching the enqueue
condition.

Fixes: 0b3be9d1d34e ("wifi: mt76: add separate tx scheduling queue for off-channel tx")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index f477157ee589..e2e9ef8ed151 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -720,8 +720,8 @@ void mt76_txq_schedule_pending(struct mt76_phy *phy)
 			ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_pending);
 		spin_lock(&phy->tx_lock);
 
-		if (!skb_queue_empty(&wcid->tx_pending) &&
-		    !skb_queue_empty(&wcid->tx_offchannel) &&
+		if ((!skb_queue_empty(&wcid->tx_pending) ||
+		     !skb_queue_empty(&wcid->tx_offchannel)) &&
 		    list_empty(&wcid->tx_list))
 			list_add_tail(&wcid->tx_list, &phy->tx_list);
 	}
-- 
2.53.0

