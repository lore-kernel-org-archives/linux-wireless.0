Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C64549CF5A
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320387; cv=none; b=Dw8vJRaftQUmGiZ6E5KC0t6LbV8T35PQ6ZizdKuC+H9HeELKTfsOjLEX6P6MnLnmw6ir7MetrkglsVpxn+K/sK4l72nPIje//vFXeFRqv6iB1RbC/bxBFXM2l5AomLh4ZBSD11eODJe5LIzlKv/KwmsbXxN9MaxxjFuXznz2gts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320387; c=relaxed/simple;
	bh=H4ooTC15pomTCBnjtNoakJ1P7uTR3358aDKMYn7+Y08=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdawtXi6yLCD/Sii4plelU5N7jg5dzOzdy12W2+inDRmTnkklN4HgMLbl06yAGPKRD36q7lpEcbrrvSof5HPV7IAzv8bjhBYFa6yk2StcXPUnH2ZcKOOE1fxwAGrRLC+hMnvKsdoRhSSyPJRMQx6bpWFjePIYdW2rizyZrFHCgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ZufpXfcj; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ZufpXfcj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yJiQFyw3zu9MDOk3whfkOs9htoGwUFc0S4j1D/dd4s0=; b=ZufpXfcjMqNbpjjHX7EFop5QHz
	OQZSHIs4K/WX/zLeqcPCen8XPPj3wnamrw6kJFR9R9ziZl8R4MS5g9qaaLDARJdwml11yOo//s08S
	nqmtWmamGC9Ozp2lgHALK321oxRi5DTioM0E/eeE3BuqhnyM9R+e3DFEWE3Zi+G7dyGo=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGD-00HAg3-23
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 13/27] wifi: mt76: mt7996: make a returning link primary if a station has none
Date: Tue,  6 Oct 2026 22:59:22 +0200
Message-ID: <20261006205936.669125-13-nbd@nbd.name>
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

mt7996_mac_sta_remove_link() clears deflink_id when it removes the
primary link and no secondary link is left to take its place. If the
removed link then comes back, mt7996_mac_sta_add_links() finds its
existing msta_link and only marks it valid again. deflink_id stays
IEEE80211_LINK_UNSPECIFIED, so the station has no primary link: the TXQs
keep the WLAN index that they had before, seclink_id stays unspecified,
mt7996_sta_rate_ctrl_update() finds no primary link, and
mt7996_sta_set_4addr() treats every link as a secondary link.

Make a returning link the primary link when the station has none, in
the same way as mt7996_mac_sta_init_link() does for a new link. Move the
two steps that set the primary link, and the switch to the secondary
link on removal, to helpers.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 55 +++++++++++++------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 9de455939125..8f483b1de852 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1133,6 +1133,38 @@ mt7996_sta_init_txq_wcid(struct ieee80211_sta *sta, int idx)
 	}
 }
 
+static void
+mt7996_sta_deflink_set(struct ieee80211_sta *sta, unsigned int link_id,
+		       int idx)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+
+	msta->deflink_id = link_id;
+	mt7996_sta_init_txq_wcid(sta, idx);
+}
+
+static void
+mt7996_sta_deflink_release(struct mt7996_dev *dev, struct ieee80211_sta *sta,
+			   unsigned int link_id)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_sta_link *msta_seclink;
+
+	if (msta->deflink_id != link_id)
+		return;
+
+	msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
+	if (msta->seclink_id == link_id)
+		return;
+
+	/* switch to the secondary link */
+	msta_seclink = mt76_dereference(msta->link[msta->seclink_id],
+					&dev->mt76);
+	if (msta_seclink)
+		mt7996_sta_deflink_set(sta, msta->seclink_id,
+				       msta_seclink->wcid.idx);
+}
+
 static u8
 mt7996_sta_seclink_get(struct mt7996_dev *dev, struct mt7996_sta *msta)
 {
@@ -1180,8 +1212,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 
 	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED) {
 		msta_link = &msta->deflink;
-		msta->deflink_id = link_id;
-		mt7996_sta_init_txq_wcid(sta, idx);
+		mt7996_sta_deflink_set(sta, link_id, idx);
 	} else {
 		msta_link = kzalloc_obj(*msta_link);
 		if (!msta_link) {
@@ -1242,22 +1273,7 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 		mt7996_mac_wtbl_update(dev, msta_link->wcid.idx,
 				       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 
-		if (msta->deflink_id == link_id) {
-			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
-			if (msta->seclink_id != link_id) {
-				struct mt7996_sta_link *msta_seclink;
-
-				/* switch to the secondary link */
-				msta_seclink = mt76_dereference(
-						msta->link[msta->seclink_id],
-						&dev->mt76);
-				if (msta_seclink) {
-					msta->deflink_id = msta->seclink_id;
-					mt7996_sta_init_txq_wcid(sta,
-						msta_seclink->wcid.idx);
-				}
-			}
-		}
+		mt7996_sta_deflink_release(dev, sta, link_id);
 		msta_link->wcid.link_valid = false;
 		msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 	}
@@ -1336,6 +1352,9 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (msta_link) {
 			msta_link->wcid.link_valid = true;
+			if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
+				mt7996_sta_deflink_set(sta, link_id,
+						       msta_link->wcid.idx);
 			msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 			continue;
 		}
-- 
2.47.3

