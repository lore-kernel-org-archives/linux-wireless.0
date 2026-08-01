Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A6339524B
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596028; cv=none; b=L26HaLiQ/2+x3xhNx1NP4zoohLVOhMjAH6bf4NdCQQWQZCXpRTA7cztdLA7dZkgd4cbShlDYaUJnqa+XFAoOpRp1kkww97IxkUGISPSqEwLYbuErJG+eiEpPi3ATZyWboP4dVlSXpEDOiJXQXuaV4zr19GLptkVxO1fDAqQYRv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596028; c=relaxed/simple;
	bh=+3/FKDnNpEL2wFiJzE/Qb1lP4WLXJ7r+tYujm7iet+Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzYHQd7t6vtt2P/rfnRdslbkydzrI1mykV7PhvMR3J+eIV/qNQr++FSoS1y+JDKrI5jyEn4LUtxvkjxfK5zSudSXeGEuIBUsR8wof+ENrqSSANoQ1tVQuWWLCYqxk8Cq/1pyeZ4z37PgWTQW9h1xfPsHCwwHg3NgCnZvn3dtOpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=d8ZT2krd; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="d8ZT2krd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7Vm/d9fPRL12C8n7VeP1npNWBp9vwgIQUAwRMbeN3U4=; b=d8ZT2krdZhGu8NRsqDuPI6Y6oQ
	klPozO+jdI+4N9KO6zqRew7OF56aJREXKXw2jFylnCq7g5T+X/+6NGI/SEuMjXli/rEsaQVvPECex
	rOIi7ku0PVlQ3ArYIGkafgU+TZbOQM7R4f14xhz11H9GoOq4cdcdmhy1rP6T4D5HEwoY=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5m-009znC-0j
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:38 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 06/10] wifi: mt76: mt7603: tell mac80211 when the PS queue has run empty
Date: Sat,  1 Aug 2026 14:53:30 +0000
Message-ID: <20260801145334.1166751-6-nbd@nbd.name>
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

mt7603_rx_loopback_skb() marks a TID as buffered when the hardware
redirects a frame into the driver PS queue, but nothing ever clears that
state again. mac80211 therefore keeps the TIM bit set for the station and
keeps routing every service period to the driver, which also prevents it
from releasing frames it has buffered itself.

Clear the buffered state for every requested TID that has no frames left
in the PS queue.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 7c231995392b..c968ee3d591a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -464,8 +464,10 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 	struct sk_buff_head list;
 	struct sk_buff *skb, *tmp, *last;
 	bool eosp_null, uapsd;
+	unsigned long drained;
 	u16 pending = 0;
 	u8 last_tid;
+	int i;
 
 	__skb_queue_head_init(&list);
 
@@ -489,6 +491,15 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 		pending |= BIT(skb->priority);
 	spin_unlock_bh(&dev->ps_lock);
 
+	/*
+	 * Without this, mac80211 keeps the TIM bit set for the station and
+	 * keeps routing every service period to the driver, even though there
+	 * is nothing left to release.
+	 */
+	drained = tids & ~pending;
+	for_each_set_bit(i, &drained, IEEE80211_NUM_TIDS)
+		ieee80211_sta_set_buffered(sta, i, false);
+
 	last = skb_peek_tail(&list);
 	if (!last) {
 		mt76_release_buffered_frames(hw, sta, tids, nframes, reason,
-- 
2.53.0

