Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229D44A2E24
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320388; cv=none; b=CdBip+Jwet227P4APvhG688AiIHkGlwEcRbFyZj0KGTvKm5XrXswEVnksz4dDaPge6RBzSS0u7e5OvNnQuH0TAoJ9G0f/tiWDvUYhRkcZ+15VpAa5nO71IhAgk289W9Qyla++qPaj2yl5KW6eJpLuL4MFDAUgk7NhWMfygbSfMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320388; c=relaxed/simple;
	bh=mthd0ETg9K/lpux80HE7gUbZGYDkJRbmNDnFpXcICTY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW4WwhSIDuc9/cBL1XkobD/Levau6xEsnLIV2rh8cATn4Pkk/aAboDCF6qrUpi6djvthqdHyPlDct9Xb9kZqVeBEXMOMoXERAHY+bfTyx2nQQoC6qlalPomQh/Q+L0yojb7jthovfFFop7yqkTt2UR8TwgFs89jTS0rDq0x6T80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=YBeB4TD9; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YBeB4TD9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZkjOXl4TzRPxjEF5RhwFHCOynQCGMuW49K4RupTblyI=; b=YBeB4TD9PFf3/dq02lXtEmWlek
	fHAfN7kkGeQbZXbljffw9KYNSTizn/KW+zmPCv29eYtdWtlDejQBjUWaBstzX/pxqoK3DKXrV9ZEx
	fM5EQ66esXgLkrEAkh307/T/+nC3ZAA33fGQIOaQXffHqcMPu4PXtL2wnbltxB4HGD48=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGE-00HAg3-3B
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 21/27] wifi: mt76: mt7996: set up the BSS of a late station link before its peer
Date: Tue,  6 Oct 2026 22:59:30 +0200
Message-ID: <20261006205936.669125-21-nbd@nbd.name>
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

On association, a station link gets its BSS_INFO with the BSSID and
its broadcast STA_REC from BSS_CHANGED_BSSID before the peer STA_REC is
created, and mt7996_link_info_changed() notes that station mode maps
the peer entry through the BSSID. For a link that becomes active later,
_ieee80211_set_active_links() calls drv_change_sta_links() first and
reports BSS_CHANGED_BSSID for the link only afterwards.

Send the BSS_INFO and the broadcast STA_REC of an added station link
from mt7996_mac_sta_change_links() before its peer entry is set up when
the station is already associated, in the order of an association. The
later BSS_CHANGED_BSSID finds the BSSID recorded and does not add the
broadcast entry as new again.

This prepares for bringing up such links in the following change.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 72 +++++++++++++------
 1 file changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d90ada7f0f2a..4f3ebe4cee65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1439,26 +1439,6 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	return err;
 }
 
-static int
-mt7996_mac_sta_change_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			    struct ieee80211_sta *sta, u16 old_links,
-			    u16 new_links)
-{
-	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	unsigned long add = new_links & ~old_links;
-	unsigned long rem = old_links & ~new_links;
-	int ret;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	mt7996_mac_sta_remove_links(dev, vif, sta, rem, false);
-	ret = mt7996_mac_sta_add_links(dev, vif, sta, add);
-
-	mutex_unlock(&dev->mt76.mutex);
-
-	return ret;
-}
-
 static int
 mt7996_mac_sta_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta)
@@ -1598,6 +1578,58 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	return err;
 }
 
+static void
+mt7996_mac_sta_links_bss_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta, unsigned long links)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	unsigned int link_id;
+
+	if (vif->type != NL80211_IFTYPE_STATION ||
+	    msta->conn_state == CONN_STATE_DISCONNECT)
+		return;
+
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct ieee80211_bss_conf *link_conf;
+		struct mt7996_vif_link *link;
+		struct mt7996_phy *phy;
+
+		link_conf = link_conf_dereference_protected(vif, link_id);
+		if (!link_conf || !link_conf->bssid ||
+		    is_zero_ether_addr(link_conf->bssid))
+			continue;
+
+		link = mt7996_vif_link(dev, vif, link_id);
+		if (!link)
+			continue;
+
+		phy = mt7996_vif_link_phy(link);
+		if (phy)
+			mt7996_vif_link_bss_add(phy, vif, link_conf, link, true);
+	}
+}
+
+static int
+mt7996_mac_sta_change_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, u16 old_links,
+			    u16 new_links)
+{
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	unsigned long add = new_links & ~old_links;
+	unsigned long rem = old_links & ~new_links;
+	int ret;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	mt7996_mac_sta_remove_links(dev, vif, sta, rem, false);
+	mt7996_mac_sta_links_bss_add(dev, vif, sta, add);
+	ret = mt7996_mac_sta_add_links(dev, vif, sta, add);
+
+	mutex_unlock(&dev->mt76.mutex);
+
+	return ret;
+}
+
 static void
 mt7996_mac_sta_remove(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta)
-- 
2.47.3

