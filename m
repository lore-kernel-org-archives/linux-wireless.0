Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264AA4418F2
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320384; cv=none; b=MCwzlUQr+vTqmW6JF/irfMlWbjYhuuPIPoTsAptiE/JbZBiiwjXt34AIP/2XwIU2VsLS9VZ7Hy/H7VfQQPORY9V7tqeKihcersKPoxmbqfiHyQkXgDDkBASEgkN1QzXC8sUADP4208jiNQKuLQ5NcqB47tPOhyiPna8z94t7w98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320384; c=relaxed/simple;
	bh=vF5kk4ydFDSNGE7+LQzW3fLCNBVIO8FsZzttn3UT9II=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGJb6SK4HKxJcGQgAoMBzDYU3KBl8b4/HIs94u0GwshXJr8W49FIO/7A7yoJtA6TVM61+UXeCPx3OAbWnSB+RR6pvJYqMX4z+o+LdaVbsRh/Eg70kCE1dZuh5r2mgjIZeQj2Iu3qw07IYVjQ4kNOuUgVOfVoOMG0gaTqz0Wg3hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=kw0UEpwS; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="kw0UEpwS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jMIoAxvI4v2JDc7DSx7MQr3/KlF6H2aRFIAFM3gwirw=; b=kw0UEpwSOilOklX4uHZAYr+9Jb
	WNN5oAcNHoKGSaNdsoqK6As2CbevOx1/nFIzihA1YLSHEqQjXS3CuJN6UfWsXVA1fBR9suf0cww2i
	sbolpaFdiwVWUxzhGvMR57yLyfChBBp1q/jQiNqPjXLKDCNf+uWAAjRbmKZFVzcLndHs=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGC-00HAg3-0w
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:40 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 05/27] wifi: mt76: mt7996: size the MLD setup TLV by the links it describes
Date: Tue,  6 Oct 2026 22:59:14 +0200
Message-ID: <20261006205936.669125-5-nbd@nbd.name>
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

mt7996_mcu_sta_mld_setup_tlv() sets link_num and the TLV length from
hweight16(sta->valid_links), but fills an entry only for active links
that have driver state. On a station interface mac80211 activates only
the association link at first, and drv_change_sta_links() masks the
other links with vif->active_links, so the driver has no state for
them. A station with valid_links 0x3 and active_links 0x2 thus sends
STA_REC_MLD with link_num 2 and a second entry of zeroes, at
association and again at authorization. The zeroed entry names WTBL
index 0 and BSS index 0 as a link of the MLD.

Count the links with driver state first and describe exactly those,
with the secondary id taken from them. A link removed without flush
keeps its mt7996_sta_link but is no longer valid, so leave it out as
well.

Fixes: 00cef41d9d8f ("wifi: mt76: mt7996: Add mt7996_mcu_sta_mld_setup_tlv() and mt7996_mcu_sta_eht_mld_tlv()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 30 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 26 +++++++---------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  2 ++
 3 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 621e1337dec2..0c229a8f071f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1262,6 +1262,36 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 	}
 }
 
+u16 mt7996_mac_sta_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct ieee80211_link_sta *link_sta;
+	unsigned int link_id;
+	u16 links = 0;
+
+	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+		struct mt7996_sta_link *msta_link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (!msta_link)
+			continue;
+
+		if (sta->valid_links && !msta_link->wcid.link_valid)
+			continue;
+
+		if (!link_conf_dereference_protected(vif, link_id))
+			continue;
+
+		if (!mt7996_vif_link(dev, vif, link_id))
+			continue;
+
+		links |= BIT(link_id);
+	}
+
+	return links;
+}
+
 static void
 mt7996_mac_sta_remove_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, unsigned long links,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 310ce18ec12c..02f9bcfdf5d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2759,18 +2759,20 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 			     struct ieee80211_sta *sta)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	unsigned int nlinks = hweight16(sta->valid_links);
+	unsigned long links = mt7996_mac_sta_links(dev, vif, sta);
+	unsigned int nlinks = hweight16(links);
 	struct mld_setup_link *mld_setup_link;
-	struct ieee80211_link_sta *link_sta;
 	struct sta_rec_mld_setup *mld_setup;
 	struct mt7996_sta_link *msta_link;
+	u8 seclink_id = msta->deflink_id;
 	unsigned int link_id;
 	struct tlv *tlv;
 
-	msta_link = mt7996_sta_link_protected(dev, msta, msta->deflink_id);
-	if (!msta_link)
+	if (!(links & BIT(msta->deflink_id)))
 		return;
 
+	msta_link = mt7996_sta_link_protected(dev, msta, msta->deflink_id);
+
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_MLD,
 				      sizeof(struct sta_rec_mld_setup) +
 				      sizeof(struct mld_setup_link) * nlinks);
@@ -2780,26 +2782,18 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 	mld_setup->setup_wcid = cpu_to_le16(msta_link->wcid.idx);
 	mld_setup->primary_id = cpu_to_le16(msta_link->wcid.idx);
 
-	if (nlinks > 1) {
-		msta_link = mt7996_sta_link_protected(dev, msta,
-						      msta->seclink_id);
-		if (!msta_link)
-			return;
-	}
+	if (links & BIT(msta->seclink_id))
+		seclink_id = msta->seclink_id;
+	msta_link = mt7996_sta_link_protected(dev, msta, seclink_id);
 	mld_setup->seconed_id = cpu_to_le16(msta_link->wcid.idx);
 	mld_setup->link_num = nlinks;
 
 	mld_setup_link = (struct mld_setup_link *)mld_setup->link_info;
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_vif_link *link;
 
 		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
-		if (!msta_link)
-			continue;
-
 		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link)
-			continue;
 
 		mld_setup_link->wcid = cpu_to_le16(msta_link->wcid.idx);
 		mld_setup_link->bss_idx = link->mt76.idx;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index dcfdcd5975c3..82a2a8a5db69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -894,6 +894,8 @@ void mt7996_mac_twt_teardown_flow(struct mt7996_dev *dev,
 void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 				struct ieee80211_sta *sta,
 				unsigned int link_id, bool flush);
+u16 mt7996_mac_sta_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta);
 void mt7996_mac_add_twt_setup(struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta,
 			      struct ieee80211_twt_setup *twt);
-- 
2.47.3

