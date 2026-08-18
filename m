Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C7819B5A3
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 13:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059599; cv=none; b=m6h1ECzSSjc1kVRyjkw12AW/Qb0x8az4ROMQH+ehGHykcMkNB6NXwhaqLIXPOO0RbQXdjrFq2cbfAp3YqbcDV9eDx/FuhbxbIhza8QC3MbydvalIoQAhcj9HrAZ32Mrgwg+So/NSLeuBNXV98hrkz8KZi6EXPFmq0v0BQ+MdbGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059599; c=relaxed/simple;
	bh=ISEbcBhAENvS+/sCzzW13LYsAqRP8n1/XezGTv8DyEI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiangUJVxhjsNAziTZN2XmjdA6ADeHFIAnUj1C8+71pifUdYhZEZ+E+wLnV6IhwASuZ+eGUd2GptB8CNjw7JnTOKYljiEjdEOXFlXYPv6Mp+b1TOUQOqBGcmMx2IOHr7+N3hEh/siDId3eoh/rhJoWUQgt/wOj6qOGKEFudd6Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=UyzENwaA; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UyzENwaA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rKZmnRdYUcqPIZ3ThNluxxst2RICSuxwPEVDdg8fHzg=; b=UyzENwaAMmis2MCZrHJeB4POIA
	YDQwel8EujkYqK5MkaeLCQL+/IH9ygV2vTLJiCbdQMTXGd4kk6I2Fvhr+qIql0/8zEgyIdFbAC0+u
	aLtSCHaCgmx5Digfu3NEeEfeNUGm9xDZTuZ96Sx/e/yC1CrGscEKw0+NERccDYXdqBb4=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wwJOe-002b0i-0V
	for linux-wireless@vger.kernel.org;
	Tue, 18 Aug 2026 14:58:28 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 5/5] wifi: mt76: account non-AQL frames per peer rather than per link
Date: Tue, 18 Aug 2026 12:58:25 +0000
Message-ID: <20260818125825.395538-5-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818125825.395538-1-nbd@nbd.name>
References: <20260818125825.395538-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver increments wcid->non_aql_packets when a frame goes to the
hardware queue. The completion path decrements the counter again.

For an MLO peer, the hardware reports the completion on the link that it
used for the transmission. This link can differ from the link that the
driver queued the frame on. In that case, the increment and the
decrement go to different link wcids, and the count drifts upwards until
it blocks the station.

Keep the count on the wcid of the primary link, like the other peer-wide
state.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  7 +++++++
 drivers/net/wireless/mediatek/mt76/tx.c   | 11 ++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 62b41c8bb7c0..2ade848fe3bb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1426,6 +1426,13 @@ mtxq_to_txq(struct mt76_txq *mtxq)
 	return container_of(ptr, struct ieee80211_txq, drv_priv);
 }
 
+/* peer-wide state uses the wcid of the primary link */
+static inline struct mt76_wcid *
+mt76_wcid_primary(struct mt76_wcid *wcid)
+{
+	return wcid->def_wcid ? wcid->def_wcid : wcid;
+}
+
 static inline struct ieee80211_sta *
 wcid_to_sta(struct mt76_wcid *wcid)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 3707ee19e4ae..b1e894b19cbd 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -234,6 +234,8 @@ mt76_tx_check_non_aql(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	if (!wcid || info->tx_time_est)
 		return;
 
+	wcid = mt76_wcid_primary(wcid);
+
 	pending = atomic_dec_return(&wcid->non_aql_packets);
 	if (pending < 0)
 		atomic_cmpxchg(&wcid->non_aql_packets, pending, 0);
@@ -344,7 +346,8 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
 	if (!non_aql)
 		return idx;
 
-	pending = atomic_inc_return(&wcid->non_aql_packets);
+	/* the hardware can report the completion on a different link */
+	pending = atomic_inc_return(&mt76_wcid_primary(wcid)->non_aql_packets);
 	if (stop && pending >= MT_MAX_NON_AQL_PKT)
 		*stop = true;
 
@@ -506,7 +509,8 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 			return 0;
 	}
 
-	if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+	if (atomic_read(&mt76_wcid_primary(wcid)->non_aql_packets) >=
+	    MT_MAX_NON_AQL_PKT)
 		return 0;
 
 	skb = mt76_txq_dequeue(phy, mtxq);
@@ -603,7 +607,8 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 			continue;
 		}
 
-		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+		if (atomic_read(&mt76_wcid_primary(wcid)->non_aql_packets) >=
+		    MT_MAX_NON_AQL_PKT)
 			continue;
 		if (dev->queue_ops->tx_cleanup &&
 		    q->queued + 2 * MT_TXQ_FREE_THR >= q->ndesc) {
-- 
2.53.0

