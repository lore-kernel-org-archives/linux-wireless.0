Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAFE33E367
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708784; cv=none; b=qYWfiE4UUgKXIBfU7QSLdbcWBxFKLQ8XqKZU5fqFbrK6jZEvh81PlDKUP7NB8a/E9rZUZkHwhB2P+daVdF7liqt7wbsTohUz2CN5de4ndBmLM/pTZsa08rYYcCUMF3+0gFAVPoJ1lNM8VCS4Y8cFwSXEUj0Bevf/q+2WkZOx6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708784; c=relaxed/simple;
	bh=zmkS/Fm1B3ZtgMpGKXoNi/pDVG+oSNCLo/DsaEmyDsI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYObcHOSL89mym7xJ9WwMhCdTtx8LTH01YHVe7eBoVGNKDOYfRGzpKpCz6mUNEDmK8EEKb8T6S0uJuQ3Y2/HoKHFlM1Yd61C+WGTswMlMU4Vftg9pfGTe2n+vyBqarsGam+tmkBF+vcqm3hOyvlkz0xNvQhpwDonfIRZnstI/5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=eUPIyTXN; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="eUPIyTXN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C01kychTyZqWf0TUBoOuBFYcNj/Jr8koZoKEecUspOA=; b=eUPIyTXNyCNnNADxORhsCEnSp3
	fmkx+ms7tnZ0wUd3uBw9Xec8ZszMZYf9fWaepeyuDCr7Bx8l7t1CbZ+cjU/5Ng1LqcZgsCQ056gzM
	ugc/x6k3Bmj2cLzsFRW+BBlkc4xrXns52A/S2BzX3LU+yAPiLHm6MBRs+A1J03bvTBmk=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHR-005AHx-16
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 15/18] wifi: mt76: allow TX aggregation on the VO queue
Date: Wed, 22 Jul 2026 08:26:07 +0000
Message-ID: <20260722082610.2699628-15-nbd@nbd.name>
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

The TX aggregation check skipped TIDs 6 and 7, so all voice-priority
traffic was sent without a BA session and therefore unaggregated,
limiting throughput for stations that map bulk traffic to VO. The
hardware handles aggregation on the VO queue fine, and a peer that
prefers unaggregated voice frames can still decline the ADDBA request.

Remove the skip from both the connac2 and the mt7996 aggregation setup
paths.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 2 --
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c      | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 976043521f44..8a8d608dd56e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -1156,8 +1156,6 @@ void mt76_connac2_tx_check_aggr(struct ieee80211_sta *sta, __le32 *txwi)
 		return;
 
 	tid = le32_get_bits(txwi[1], MT_TXD1_TID);
-	if (tid >= 6) /* skip VO queue */
-		return;
 
 	val = le32_to_cpu(txwi[2]);
 	fc = FIELD_GET(MT_TXD2_FRAME_TYPE, val) << 2 |
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 552b59c6e6b8..df722d334086 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1256,8 +1256,6 @@ mt7996_tx_check_aggr(struct ieee80211_link_sta *link_sta,
 		return;
 
 	tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
-	if (tid >= 6) /* skip VO queue */
-		return;
 
 	if (is_8023) {
 		fc = IEEE80211_FTYPE_DATA |
-- 
2.53.0

