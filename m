Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60979394793
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596028; cv=none; b=r3nWKvYCpvtKDQ06iJKrU7dPDqG0zBqefHBbqzr0zoqrrxOei98cFi8+8NsXNwjk/LsKDsy3TPtbmjgaxFLa1eWeZC5JqCdNV4+fy6lVxxARw8CSF57QO0ZXhwbyUk2SA3Tk2LihtZ99vX3ETaUlPyrcfK10F+vXlpgbhGe9txI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596028; c=relaxed/simple;
	bh=zcAgbB91h/H8rcCLaF3EeQLfrIO4MJ7//3MwAnbD540=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9xX98WK57gOgZvetsw9jCH9DU7SWACxISa+G8r1kO0bE8Oc4MKNEHKJFLjCnTmNHxFCBE09mEKPK50mzMaCL+EZ5yc5QqwXWxe49Kq0xEUGT6dfhsSQiCaffwZuNXiUEgy92B/1fNnE5IlaCP05GB9WB4aTW9C7I7S1nykw7NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Odo4JQlH; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Odo4JQlH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=04L6T3xBc5Z6STMwUNDH2hQve8yS9UL5KTlh+ByVFPI=; b=Odo4JQlHlRzUlJIkmMBvFTp4S7
	+OKziDMVszaKY/TVrA6S8ju+i0JH2YkDtDklyzTkc+UJR8MYnvZdOAgY+C+JYJ2bnDsA5rni9ho2/
	cZ8TJp8NX0x4LXMRAO3ie4YPNhDZLKWDQT/6V6P9dqnCOtvJVnnspvc8UtEBoa5YJDMw=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5l-009znC-2p
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:37 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 04/10] wifi: mt76: set the EOSP bit in the QoS header of the last released frame
Date: Sat,  1 Aug 2026 14:53:28 +0000
Message-ID: <20260801145334.1166751-4-nbd@nbd.name>
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

When the driver implements .release_buffered_frames, mac80211 leaves the
U-APSD signalling entirely to the driver: "In this case it is also
responsible for setting the EOSP flag in the QoS header of the frames"
(include/net/mac80211.h). Only IEEE80211_TX_STATUS_EOSP was being set,
which merely ends the service period inside mac80211, so on air the
service period was never terminated. Clients that wait for EOSP before
going back to doze keep the SP open and stop triggering, which stalls all
downlink traffic for that station.

Set the wire EOSP bit on the last frame of a U-APSD service period.
EOSP has no meaning for a PS-Poll response, so pass the release reason
down and leave those frames alone.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 12c615b1294b..3707ee19e4ae 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -412,16 +412,23 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
 static void
 mt76_queue_ps_skb(struct mt76_phy *phy, struct ieee80211_sta *sta,
-		  struct sk_buff *skb, bool last)
+		  struct sk_buff *skb, bool last,
+		  enum ieee80211_frame_release_type reason)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
-	if (last)
+	if (last) {
 		info->flags |= IEEE80211_TX_STATUS_EOSP |
 			       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+		if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
+		    ieee80211_is_data_qos(hdr->frame_control))
+			*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_EOSP;
+	}
+
 	mt76_skb_set_moredata(skb, !last);
 	__mt76_tx_queue_skb(phy, MT_TXQ_PSD, skb, wcid, sta, NULL);
 }
@@ -454,14 +461,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
 			nframes--;
 			if (last_skb)
-				mt76_queue_ps_skb(phy, sta, last_skb, false);
+				mt76_queue_ps_skb(phy, sta, last_skb, false,
+						  reason);
 
 			last_skb = skb;
 		} while (nframes);
 	}
 
 	if (last_skb) {
-		mt76_queue_ps_skb(phy, sta, last_skb, true);
+		mt76_queue_ps_skb(phy, sta, last_skb, true, reason);
 		dev->queue_ops->kick(dev, hwq);
 	} else {
 		ieee80211_sta_eosp(sta);
-- 
2.53.0

