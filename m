Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA847127E
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662933; cv=none; b=Jia/9TpdC57+3FOHFBAtRNXt6coPGhFr7/TACjIsSUo4WySqrFtgkk0vt5+gWZmhg1ff1vtE656S3DdAvrm/3AxGjogolhUvrQfpxmzGfYGn667q7uZBooTw2+UlcXxX9zQCqNPqKUr8Nv9Dp0V9PDFKVIPuyvo2BvDIYcqiY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662933; c=relaxed/simple;
	bh=DoZOp6Yg4uG3w2Zo1iFmEqQfMVH3PGMGDypbO62C4tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz8YbDEeKFyh28H3WjjrxCrzAmlcZ8v5hh4hy87F9PwA7NWbYtDOnCNsK9yI9aYDyBsyivappDDSbyTKcGECodWBrHuOoyLsFETv3XpvAvo2Zys0vJb8LuI07V2ygZbcum4+rAL58ijHvN0z8s1Oe6Nk6eZFjspvNm4TYIwUe54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=dxG0b8RN; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dxG0b8RN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NLv9Y7PGlPVhlmeAq8Xy0jN+zqCA/lhOCW1wS7BXWIY=; b=dxG0b8RNRgBlMdT5OY8gD+0fAN
	HYg8DE78SThCkTypOZL/nEowy4A9W5en3zVs+5pMfvIqhZGzDVU79J7t1cNJQbPhM5QnsLJk4LZwe
	lsfAUk51cZR3xhm0eq6sO7uermGVoetR6kqRA01EGl5MyJ0jYM4zWRL2TcBy/3YtMr2s=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmGLx-004wLC-27;
	Tue, 21 Jul 2026 21:42:09 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next v4 4/4] wifi: mac80211: add ieee80211_txq_aql_pending()
Date: Tue, 21 Jul 2026 19:42:07 +0000
Message-ID: <20260721194207.2431113-4-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721194207.2431113-1-nbd@nbd.name>
References: <20260721194207.2431113-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a function to allow drivers to query the pending AQL airtime
for a given txq, for both unicast and broadcast.
This will be used for mt76 to limit buffering in AP mode for power-save
stations.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: reorder txq->tid check
v3: fix compile error - adjust for changes in previous patch

 include/net/mac80211.h | 11 +++++++++++
 net/mac80211/tx.c      | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 17cc970c02dc..365122f9e08c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6881,6 +6881,17 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
 bool
 ieee80211_txq_airtime_check(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
 
+/**
+ * ieee80211_txq_aql_pending - get pending AQL airtime for a txq
+ *
+ * @hw: pointer obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ * Return: pending airtime (in usec) for the given txq.
+ */
+u32 ieee80211_txq_aql_pending(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq);
+
 /**
  * ieee80211_iter_keys - iterate keys programmed into the device
  * @hw: pointer obtained from ieee80211_alloc_hw()
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1bba49d0b6bf..04307d6ac923 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4244,6 +4244,24 @@ bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_txq_airtime_check);
 
+u32 ieee80211_txq_aql_pending(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+
+	if (unlikely(txq->tid == IEEE80211_NUM_TIDS))
+		return 0;
+
+	if (!txq->sta)
+		return atomic_read(&local->aql_mc_pending_airtime);
+
+	sta = container_of(txq->sta, struct sta_info, sta);
+
+	return atomic_read(&sta->airtime[txq->ac].aql_tx_pending);
+}
+EXPORT_SYMBOL(ieee80211_txq_aql_pending);
+
 static bool
 ieee80211_txq_schedule_airtime_check(struct ieee80211_local *local, u8 ac)
 {
-- 
2.53.0

