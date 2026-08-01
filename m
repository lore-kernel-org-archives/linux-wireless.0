Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE3E3955EE
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596028; cv=none; b=Ns6nVzgv4tMlYpdJjtwRc9+B+tGZpYKor34OHgxTfmDPaXva2q3FPLdoGoVPMVDDOu1UGxrgAvnhV1xJP/RnqyHkHAq5M5JY2ylvleUGOEx4ztqPe8u6QtAtJ3DXp3KPXtLCdRs3bj5gJm0ryXKL1WNMHbFvQcP3uXkL3WH/g9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596028; c=relaxed/simple;
	bh=r/L8XQ7WRwBNyqstz0IIb6jr+cywROCakTf+ZI4TXnY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhO6jxNwpAZ1Rygvi3+vc+Ijnj65mv4aX3JuVZKTo8Uu6MhpryzzpzUPdlk8WWeBIXkq4pKvK5BP1GMTQzwivq3t3o3DyR0WVJoXSU4WwFdqCQ6cq+zhtnIyKRXrUzF51uXi4zQYIg/7uY7jcTGBUHrlLJ407WysunIr2uZ/FMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=oW534OGV; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oW534OGV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VT+WSXe57xLGMh2fHLfRu5E++1TmPuQ6NJB4IurN+b8=; b=oW534OGV/NYI84lDJc8e0tjkWh
	2fYT0QJVP+Xd4M6Fg6bqlVSTz563RAKLt6ZtcEyWqPmG7xERip7dv4IVtQ67dLPyP7bM5Ysj0mLm4
	KhII6BWQOheYEkP3AT002DVIYd3kLN9rk4TkewiZcTPBKk9Bk4AeM3waXMrzejHUYYnk=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5m-009znC-30
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:39 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 10/10] wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()
Date: Sat,  1 Aug 2026 14:53:34 +0000
Message-ID: <20260801145334.1166751-10-nbd@nbd.name>
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

When mac80211 leaves the link unspecified, mt7996_tx() substitutes the
primary link id of the station or vif. That value is
IEEE80211_LINK_UNSPECIFIED (0xf) until the first link has been added,
and it is then used unchecked to index vif->link_conf[],
mvif->mt76.link[] and sta->link[], all of which hold
IEEE80211_MLD_MAX_NUM_LINKS (15) entries.

Clamp the primary link id to the default link before using it, and use
the clamped value for the link_sta fallback as well.

Fixes: 1609b014aa29 ("wifi: mt76: mt7996: Overwrite unspecified link_id in mt7996_tx()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 54e79bd25995..e218856b0c45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1515,20 +1515,26 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct mt7996_vif *mvif = vif ? (void *)vif->drv_priv : NULL;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
+	u8 deflink_id = IEEE80211_LINK_UNSPECIFIED;
 	u8 link_id = u32_get_bits(info->control.flags,
 				  IEEE80211_TX_CTRL_MLO_LINK);
 
 	rcu_read_lock();
 
+	if (msta)
+		deflink_id = msta->deflink_id;
+	else if (mvif)
+		deflink_id = mvif->mt76.deflink_id;
+
+	/* the primary link is unset until the first link has been added */
+	if (deflink_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+		deflink_id = 0;
+
 	/* Use primary link_id if the value from mac80211 is set to
 	 * IEEE80211_LINK_UNSPECIFIED.
 	 */
-	if (link_id == IEEE80211_LINK_UNSPECIFIED) {
-		if (msta)
-			link_id = msta->deflink_id;
-		else if (mvif)
-			link_id = mvif->mt76.deflink_id;
-	}
+	if (link_id == IEEE80211_LINK_UNSPECIFIED)
+		link_id = deflink_id;
 
 	if (vif && ieee80211_vif_is_mld(vif)) {
 		struct ieee80211_bss_conf *link_conf;
@@ -1538,7 +1544,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 
 			link_sta = rcu_dereference(sta->link[link_id]);
 			if (!link_sta)
-				link_sta = rcu_dereference(sta->link[msta->deflink_id]);
+				link_sta = rcu_dereference(sta->link[deflink_id]);
 
 			if (link_sta) {
 				memcpy(hdr->addr1, link_sta->addr, ETH_ALEN);
-- 
2.53.0

