Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D2D3955C3
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596027; cv=none; b=qOQspttAJDYXPLU1qKV6DdHoJvv6I4nizYzP8QEIjt1xd/RhVW99A3NdGJMI0nEZo/pJuDnQNvzinBXciO6QU2c+xXuwb3wz1pRW8ZlYzHe0gfvIaWdbSagaoYW8AgQoSS60NTWttEsNxEF4zBVP3KE1tHtMw505uXBV35Y+uWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596027; c=relaxed/simple;
	bh=S5LYktXmmyHQ6N1oJE8u/iSFhchQO5oDYAEX/Cgs92I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crdGYp2ZSVordgpXR4RZ1fubYMdDPR3/+edqBFhJZOeVOGz7ljk9gb2cDwqZZCaUKo0GkOEXtzvf4XxTwuSauaYddFqKS838IA0qUksvZmYyfmiNX5k7+xrv0wIVGVudofDJoopT36Sgtf2o00TVNrTBPyaOeQLk9oUmgdacraY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Y7YxvPuX; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Y7YxvPuX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GhVoZejl/tZYJOz8nEItcwRRaeeg26Podh79NeDj7uc=; b=Y7YxvPuXkaQ3R/G2MdcuoQ9Hc6
	XEKaCwz/2jRwiuLdKPPJYcxyPD4koQzuEfQDJeaiWk1J8v6L9KvaJtrRTlhfazJr/NbGlqKtSeEDj
	iomUSwrbXKHT7KLa0Zc8S08pMlrcNlxUficqePKGlzrTAMERDdQF+EvJWX733wcCP7Cg=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5m-009znC-1r
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:38 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 08/10] wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211
Date: Sat,  1 Aug 2026 14:53:32 +0000
Message-ID: <20260801145334.1166751-8-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801145334.1166751-1-nbd@nbd.name>
References: <20260801145334.1166751-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PS queue filed redirected frames under the TID taken from the TXD,
while mac80211 was told about the TID taken from the QoS header, or TID 0
for anything that is not a QoS data frame. When the two disagree,
mt7603_release_buffered_frames() skips the frame because it does not
match the requested TIDs, so it stays in the PS queue until the station
wakes up. Buffered MMPDUs hit this whenever they were sent on a
non-zero TID.

Use one TID for both.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 3a16851524a0..477a9b7a8cf7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -39,7 +39,6 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 
 	val = le32_to_cpu(txd[1]);
 	idx = FIELD_GET(MT_TXD1_WLAN_IDX, val);
-	skb->priority = FIELD_GET(MT_TXD1_TID, val);
 
 	if (idx >= MT7603_WTBL_STA - 1)
 		goto free;
@@ -72,6 +71,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 		hwq = MT_TX_HW_QUEUE_MGMT;
 	}
 
+	skb->priority = tid;
 	ieee80211_sta_set_buffered(sta, tid, true);
 
 	val = le32_to_cpu(txd[0]);
-- 
2.53.0

