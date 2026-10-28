Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=oMtekHsHCscE7nmH5YibSKzaihVf1lFGy6/XaRfWAdyHX/i+w5e25fyVF15h/EhNB1cq
	 JulEGt9fPOaWBbHB8dLBI+FCY9JbOgFvZZEqKiLcy65I+lZ96GQavlE+2QKPdroVCG6vP
	 TwpqtYguTrDZ2NMhp8seqSAa1HtdXVu8025GAee2M4UjCJVLSHNQiMg6nKNdUappLNHAb
	 3hSr9rpck54vTe2uBVDnu33YzfWCxNoUCxaQcWQ8zWW85pCRH66wcmclpnz7riUWpd43o
	 k9G8APk6gMmG3BJym07ugfgb3/FmqvAOEkHxQy1y7852dJAa2FuRb9CQWFM7U7vlqmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Gd76QZPqRZfzgQp6/SAN6xoCix4siVmDpoOFPbUM+Os=;
	b=3YXaaLiNYokKvzAOXSB8FP44p/K4HiPZFc/gONvZu97RtCMawS1Ubhij+v700iAUzxTb
	 9VcnNaKmXUPQLoRwLvPI+d9vOywV/A3sWdp/5RFwGLKjK3oKFSkIXvT2j0IBf5x3wTfle
	 Ak87BBiJzt8fIWT1tTZ3KWp/4YTL1rVQghAagyNXtrd/nnaZ3yNb4UOhnku3JUT2AhsLb
	 GYHa0HyQzms2k30ctvpwMsnbl+9D5g4QVg8BOUCPfCp3BQAVFd2qrtJjaJzHGSFgt/Eb2
	 2pX9OI3M/1BPJNh0b2SkndaMVC13QOz+sgk2E7XUv2t8YMcRqnvAYj8i4knaer/OyTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=JxHL1frV;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5E360A260F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A5E360A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=JxHL1frV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Gd76QZPqRZfzgQp6/SAN6xoCix4siVmDpoOFPbUM+Os=; b=JxHL1frVXvcil9GyisALWe0dek
	5iSGJ04NJ79NIQJ3w9ZQE8RzNBBZsTzbTNorhTa8qdpE9+borWrFqZn35nRtGNo+HpJhGI+FLVoVi
	I9m78SzvLc8NMJpgbIThcMFisrBKUIT/IJvsU8a/PRZgFdHEsQzungqI8Mn0lPs3UJao=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hN-00C8Bw-1c
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:09 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 20/25] wifi: mt76: publish the beacon monitor interval after its timestamp
Date: Wed, 28 Oct 2026 13:23:58 +0100
Message-ID: <20261028122403.796394-20-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_vif_link_add() and mt7996_vif_cfg_changed() start the beacon
monitor of a station link with a plain store of beacon_mon_interval,
followed by the store of beacon_mon_last. mt76_beacon_mon_iter() runs
without dev->mutex and reads the interval first. It can thus see the
new interval with the old timestamp, for example 0 for a new link, and
report a beacon loss at once.

Add helpers that start and stop the monitor: the timestamp is written
first, and the interval is published with release semantics, which
mt76_beacon_mon_iter() pairs with an acquire load. Read the interval
with READ_ONCE() in the other lockless users. This also removes the
duplicated interval computation in mt7996.

Fixes: 4df75606ece5 ("wifi: mt76: add per-link beacon monitoring for MLO")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 19 +++++++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76.h     | 16 +++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 20 +++++++------------
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index b2702c9079d9..76908bd835f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -2243,7 +2243,7 @@ mt76_offchannel_notify_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
 
 	if (!ieee80211_vif_is_mld(vif)) {
 		if (mt76_vif_link_phy(mlink) == data->phy) {
-			if (!data->offchannel && mlink->beacon_mon_interval)
+			if (!data->offchannel && READ_ONCE(mlink->beacon_mon_interval))
 				WRITE_ONCE(mlink->beacon_mon_last, jiffies);
 			mt76_offchannel_send_nullfunc(data, vif, -1);
 		}
@@ -2260,7 +2260,7 @@ mt76_offchannel_notify_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
 		if (mt76_vif_link_phy(mlink) != data->phy)
 			continue;
 
-		if (!data->offchannel && mlink->beacon_mon_interval)
+		if (!data->offchannel && READ_ONCE(mlink->beacon_mon_interval))
 			WRITE_ONCE(mlink->beacon_mon_last, jiffies);
 
 		mt76_offchannel_send_nullfunc(data, vif, link_id);
@@ -2308,7 +2308,7 @@ static void mt76_rx_beacon_iter(void *_data, u8 *mac,
 			mlink = (struct mt76_vif_link *)vif->drv_priv;
 		else
 			mlink = rcu_dereference(mvif->link[link_id]);
-		if (!mlink || !mlink->beacon_mon_interval)
+		if (!mlink || !READ_ONCE(mlink->beacon_mon_interval))
 			continue;
 
 		if (mt76_vif_link_phy(mlink) != data->phy)
@@ -2363,11 +2363,20 @@ static void mt76_beacon_mon_iter(void *data, u8 *mac,
 		return;
 
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
+		u16 interval;
+
 		if (link_id == mvif->deflink_id)
 			mlink = (struct mt76_vif_link *)vif->drv_priv;
 		else
 			mlink = rcu_dereference(mvif->link[link_id]);
-		if (!mlink || !mlink->beacon_mon_interval)
+		if (!mlink)
+			continue;
+
+		/* pairs with smp_store_release() in
+		 * mt76_vif_link_beacon_mon_start()
+		 */
+		interval = smp_load_acquire(&mlink->beacon_mon_interval);
+		if (!interval)
 			continue;
 
 		if (mt76_vif_link_phy(mlink) != phy)
@@ -2375,7 +2384,7 @@ static void mt76_beacon_mon_iter(void *data, u8 *mac,
 
 		if (time_after(jiffies,
 			       READ_ONCE(mlink->beacon_mon_last) +
-			       MT76_BEACON_MON_MAX_MISS * mlink->beacon_mon_interval))
+			       MT76_BEACON_MON_MAX_MISS * interval))
 			ieee80211_beacon_loss(vif);
 	}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index fb1b99f56e9c..fce7bf2f0333 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -2178,6 +2178,22 @@ mt76_vif_link_ctx_set(struct mt76_vif_link *mlink,
 	smp_store_release(&mlink->ctx, conf);
 }
 
+static inline void
+mt76_vif_link_beacon_mon_start(struct mt76_vif_link *mlink, u16 beacon_int)
+{
+	u16 interval = msecs_to_jiffies(ieee80211_tu_to_usec(beacon_int) / 1000);
+
+	WRITE_ONCE(mlink->beacon_mon_last, jiffies);
+	/* pairs with smp_load_acquire() in mt76_beacon_mon_iter() */
+	smp_store_release(&mlink->beacon_mon_interval, interval);
+}
+
+static inline void
+mt76_vif_link_beacon_mon_stop(struct mt76_vif_link *mlink)
+{
+	WRITE_ONCE(mlink->beacon_mon_interval, 0);
+}
+
 static inline struct mt76_phy *
 mt76_vif_link_phy(struct mt76_vif_link *mlink)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index f715817243a6..6815f5192116 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -492,12 +492,9 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 
-		if (vif->cfg.assoc && link_conf->beacon_int) {
-			mlink->beacon_mon_interval =
-				msecs_to_jiffies(ieee80211_tu_to_usec(
-					link_conf->beacon_int) / 1000);
-			WRITE_ONCE(mlink->beacon_mon_last, jiffies);
-		}
+		if (vif->cfg.assoc && link_conf->beacon_int)
+			mt76_vif_link_beacon_mon_start(mlink,
+						       link_conf->beacon_int);
 	}
 
 	return 0;
@@ -1027,12 +1024,9 @@ mt7996_vif_cfg_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			if (!link)
 				continue;
 
-			if (vif->type == NL80211_IFTYPE_STATION) {
-				link->mt76.beacon_mon_interval =
-					msecs_to_jiffies(ieee80211_tu_to_usec(
-						link_conf->beacon_int) / 1000);
-				WRITE_ONCE(link->mt76.beacon_mon_last, jiffies);
-			}
+			if (vif->type == NL80211_IFTYPE_STATION)
+				mt76_vif_link_beacon_mon_start(&link->mt76,
+							       link_conf->beacon_int);
 
 			phy = mt7996_vif_link_phy(link);
 			if (!phy)
@@ -1053,7 +1047,7 @@ mt7996_vif_cfg_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			link = mt7996_vif_link(dev, vif, link_id);
 			if (link)
-				link->mt76.beacon_mon_interval = 0;
+				mt76_vif_link_beacon_mon_stop(&link->mt76);
 		}
 	}
 
-- 
2.47.3

