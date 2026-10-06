Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA3949C4DA
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320388; cv=none; b=WICyQokCEkbnuHTd3evu0uGWz+u1JQnwNGhhLAs9zv3reegH2IOVUYrTmAoS8gQI2b5aKnQgGfSjyR6ZaXeZ4q0kIqGI+gC/2J+qHfpAFX4oNoucpEREcWwwWo4xscU/qoZ/f7sXgWZiuchBlSYKUyO4z0Y+RjXusMtav1d3d+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320388; c=relaxed/simple;
	bh=lANzvdGKXvXEvJZLXSquH35/7IZ72p5ksY14Ix7mQXc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9IhWuq8R8/e41vWyzOd6rMF+XWjincS7fFM9gmCU32OSEON5Owk500jX3UoFAkzCLsIJs/BOHQNuGPJW90M8EroL2YmDF6BHE9W6wui6OH0gSL8EU9JzI2jnhYycZrIXDtAf5YEZm7wSwScMbhLhgn3KZwDGEDF3UDb7DdR+xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=XvbWtkR9; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="XvbWtkR9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0ZZ4/BLpwwzINm/U9axZ7xwmm81h+ggkeuFBQaMGhJM=; b=XvbWtkR9Zg3FxLnhISaEfSaKPT
	+KsDEo0LCkjTcLJfDu8mGdET7slMRBjPGTld9f/gnXqwfgwpR6Yqkd1tqoAAPjTR+brY/12KDBkCv
	i1ixv7rl7gtMlhbCnp3Z219vqfGKu6chKM9TyJWXX+w0AWgKuwiWYR8iQLP0vDgrDEWQ=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGD-00HAg3-1U
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 12/27] wifi: mt76: mt7996: pick the secondary link from links with driver state
Date: Tue,  6 Oct 2026 22:59:21 +0200
Message-ID: <20261006205936.669125-12-nbd@nbd.name>
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

mt7996_mac_sta_init_link() takes the secondary link from
sta->valid_links. On a station interface mac80211 creates driver state
only for active links, since drv_change_sta_links() masks both link
sets with vif->active_links. With three valid links of which links 0
and 2 are active, seclink_id then points at link 1, which has no
mt7996_sta_link. mt7996_tx_prepare_skb() maps odd TIDs to seclink_id,
keeps the primary wcid for them and passes the inactive link id to
mt7996_mac_write_txwi(), which finds no vif link and falls back to OMAC
and WMM index 0.

Choose the secondary link among the links that have driver state and
are valid, and choose it again whenever such a link is added, restored
or removed. A removed secondary link now hands over to another
remaining link instead of the primary one, and a secondary link that
was promoted to primary gets a successor.

Fixes: 85cd5534a3f2 ("wifi: mt76: mt7996: use correct link_id when filling TXD and TXP")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 42 +++++++++++++------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 5207def2fd36..9de455939125 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1133,6 +1133,32 @@ mt7996_sta_init_txq_wcid(struct ieee80211_sta *sta, int idx)
 	}
 }
 
+static u8
+mt7996_sta_seclink_get(struct mt7996_dev *dev, struct mt7996_sta *msta)
+{
+	struct mt7996_sta_link *msta_link;
+	unsigned int link_id;
+
+	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
+		return IEEE80211_LINK_UNSPECIFIED;
+
+	msta_link = mt7996_sta_link_protected(dev, msta, msta->seclink_id);
+	if (msta->seclink_id != msta->deflink_id && msta_link &&
+	    msta_link->wcid.link_valid)
+		return msta->seclink_id;
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		if (link_id == msta->deflink_id)
+			continue;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (msta_link && msta_link->wcid.link_valid)
+			return link_id;
+	}
+
+	return msta->deflink_id;
+}
+
 static int
 mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 			 struct ieee80211_bss_conf *link_conf,
@@ -1155,7 +1181,6 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED) {
 		msta_link = &msta->deflink;
 		msta->deflink_id = link_id;
-		msta->seclink_id = msta->deflink_id;
 		mt7996_sta_init_txq_wcid(sta, idx);
 	} else {
 		msta_link = kzalloc_obj(*msta_link);
@@ -1163,11 +1188,6 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 			mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
 			return -ENOMEM;
 		}
-
-		if (msta->seclink_id == msta->deflink_id &&
-		    (sta->valid_links & ~BIT(msta->deflink_id)))
-			msta->seclink_id = __ffs(sta->valid_links &
-						 ~BIT(msta->deflink_id));
 	}
 
 	INIT_LIST_HEAD(&msta_link->rc_list);
@@ -1186,6 +1206,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	ewma_signal_init(&msta_link->wcid.rssi);
 
 	rcu_assign_pointer(msta->link[link_id], msta_link);
+	msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 
 	mt7996_mac_wtbl_update(dev, idx, MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 	mt7996_mcu_add_sta(dev, link_conf, link_sta, link, msta_link,
@@ -1223,10 +1244,7 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 
 		if (msta->deflink_id == link_id) {
 			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
-			if (msta->seclink_id == link_id) {
-				/* no secondary link available */
-				msta->seclink_id = msta->deflink_id;
-			} else {
+			if (msta->seclink_id != link_id) {
 				struct mt7996_sta_link *msta_seclink;
 
 				/* switch to the secondary link */
@@ -1239,10 +1257,9 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 						msta_seclink->wcid.idx);
 				}
 			}
-		} else if (msta->seclink_id == link_id) {
-			msta->seclink_id = msta->deflink_id;
 		}
 		msta_link->wcid.link_valid = false;
+		msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 	}
 
 	if (flush) {
@@ -1319,6 +1336,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (msta_link) {
 			msta_link->wcid.link_valid = true;
+			msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 			continue;
 		}
 
-- 
2.47.3

