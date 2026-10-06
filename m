Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE02A45563B
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320386; cv=none; b=gVa/Z1/llhsJZ5aYOcQDUYODlZIB4lWarnWVRfavEHuGBFBxbnAOcuGR4AEVwq+rDzckNp4UWvQzrLIlP3UnDKdWR1CM6atI8h24x0k121CXv5Zx8cEAdiiddDllRP3Li3RQQL5XcOOc967IPyVAk3cBJf9Pt7ZzXzp5UbhJY+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320386; c=relaxed/simple;
	bh=oK8EiSZ/lPafnOPjmCQRE2GFqkWc7wBk0jzfq7N0AE4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6Zp6oW9q2I4o8M7NQXp+HaL6TE3bFjorhmXS8OMffaGnRWvIR+jrZHfYQhjukfcznYoLibGSoPud7wU0zcqm80o4GREEO0d1+tp0l8oxuBh26TKr+T8zw5HhWTWviBJ3f3X+sYPJgsYeUgWvIKfVDBHzmLteUd5391LMJRwvN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=IsR1Y28Z; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="IsR1Y28Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sH5tdVMi5BaL84WL+WI0S+ynOTyUKPslmmy6nhngyIk=; b=IsR1Y28Z4JeCZjXZ6GaFcxk1kx
	udjjyIyrPdzLbjAL3FQVrudB7pZU9T4FY5Xf4aN3KEejnil7k1g+N2C7I4vyD6NJDAAtC2TitAzSK
	HZEciNZVexpEsk87nw/EKa2OyHVzpFgWQpQvM/V+tGnAwqoOja1+L5m4NQfIWbvFaAdI=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGC-00HAg3-34
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 09/27] wifi: mt76: mt7996: report station statistics from the primary link
Date: Tue,  6 Oct 2026 22:59:18 +0200
Message-ID: <20261006205936.669125-9-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_sta_statistics() and mt7996_ethtool_worker() read the TX rate,
the TX counters and the ACK signal from msta->deflink. That is the
msta_link of the first link of the station, not of its primary link.
When the first link of an MLD station is removed, msta->deflink keeps
the values of the removed link, and the station reports them until it
is removed.

Read them from the link that deflink_id selects.

msta->deflink also holds the RX reorder state, the TX aggregation
state and the def_wcid target of all links. These are state of the
whole station, and wcid_to_sta() needs def_wcid at the start of
drv_priv, so they stay there.

Fixes: f520eceacd24 ("wifi: mt76: mt7996: Add mt7996_mac_sta_change_links callback")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index f94b5fdfca24..f44af31281b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1920,9 +1920,16 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct mt7996_sta_link *msta_link = &msta->deflink;
-	struct rate_info *txrate = &msta_link->wcid.rate;
+	struct mt7996_sta_link *msta_link;
+	struct rate_info *txrate;
 
+	rcu_read_lock();
+
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
+	if (!msta_link)
+		goto out;
+
+	txrate = &msta_link->wcid.rate;
 	if (txrate->legacy || txrate->flags) {
 		if (txrate->legacy) {
 			sinfo->txrate.legacy = txrate->legacy;
@@ -1965,6 +1972,9 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->rx_packets = msta_link->wcid.stats.rx_packets;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
 static void mt7996_link_rate_ctrl_update(void *data,
@@ -2264,11 +2274,15 @@ static void mt7996_ethtool_worker(void *wi_data, struct ieee80211_sta *sta)
 {
 	struct mt76_ethtool_worker_info *wi = wi_data;
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct mt7996_sta_link *msta_link = &msta->deflink;
+	struct mt7996_sta_link *msta_link;
 
 	if (msta->vif->deflink.mt76.idx != wi->idx)
 		return;
 
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
+	if (!msta_link)
+		return;
+
 	mt76_ethtool_worker(wi, &msta_link->wcid.stats, true);
 }
 
-- 
2.47.3

