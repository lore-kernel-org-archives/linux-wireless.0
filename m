Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4368E3E4115
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320384; cv=none; b=WeVz4xzviOagpBFRY+3uAeEbZjOOA1X/Qr2aFJf+TSUwKXo6rchqYsuXQbd0cZVwiaETDKmjrKMJEH+nxtgQ2DFBkP17LYwHiiBrDI+9MIme1DunEdJ73UwQdebgkQb+e9rDhjjxk6EUcBnLuqepcMadv4rNTs1HmJWhI7qL+B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320384; c=relaxed/simple;
	bh=ll+JBQAcd8VDhY8wW5fIF2wVAicBeCe5ZO1kpA3cseQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1PbsJydWMLjAPyhBB89+ZO869Js6zPo54BgnDgPF4U7/YPdT+UoJd0KPxhNfshrttKPxjxN6YbTOsLQlbba67f35NF7wymlpms/J8auxOWFh+IWvqZGis0hH2341cNh1bZyh7EH2vDlUSwTECbJYDD8pH8+4gWr5WTI0jivawE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=AIkAmp2T; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="AIkAmp2T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4YgGpb8+1WhqeoUb4evzo6fiWYjS5aNFk0GAe0vehGU=; b=AIkAmp2T9q+THHu/mgxZ5n2nUf
	Hs7iDRRLsnRxVGSn/ExVrLXWITcsxCfhGiZPBv3qbwApHT30FhIC1/8oKDzybUGU9A39whhAGow47
	OV/MvRifLdU9HASe7F7kB1HnNo52bXzVKY7zvaPQ7ufZIk8fsEfISwD52WExYinY5q9U=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGC-00HAg3-1T
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:40 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 06/27] wifi: mt76: mt7996: find the last MLD link among the links torn down
Date: Tue,  6 Oct 2026 22:59:15 +0200
Message-ID: <20261006205936.669125-6-nbd@nbd.name>
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

On disassociation, mt7996_mac_sta_event() sends STA_REC_MLD_OFF when
the link it handles is the last of sta->valid_links, but it handles
only active links with driver state. On a station interface with one
active link out of two valid links, no link is ever the last one, so
the firmware never gets STA_REC_MLD_OFF for the MLD.

Walk the same set of links that mt7996_mcu_sta_mld_setup_tlv()
describes, and detect the last link within that set. The per-link
event handling moves into a helper that takes the set of links, so
that a later change can bring up links that became active after
association.

Fixes: c1d6dd5d03eb ("wifi: mt76: mt7996: Add mt7996_mcu_teardown_mld_sta rouine")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 47 ++++++++++---------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 0c229a8f071f..e5f74f23d469 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1406,34 +1406,26 @@ mt7996_mac_sta_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 }
 
 static int
-mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
-		     struct ieee80211_sta *sta, enum mt76_sta_event ev)
+mt7996_mac_sta_links_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta, unsigned long links,
+			   enum mt76_sta_event ev)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	unsigned long links = sta->valid_links;
-	struct ieee80211_link_sta *link_sta;
+	unsigned long iter_links = links;
 	unsigned int link_id;
-	int err = 0;
+	int err;
 
-	mutex_lock(&dev->mt76.mutex);
-
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_set_bit(link_id, &iter_links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct ieee80211_bss_conf *link_conf;
+		struct ieee80211_link_sta *link_sta;
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 		int i;
 
 		link_conf = link_conf_dereference_protected(vif, link_id);
-		if (!link_conf)
-			continue;
-
-		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link)
-			continue;
-
+		link_sta = link_sta_dereference_protected(sta, link_id);
 		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
-		if (!msta_link)
-			continue;
+		link = mt7996_vif_link(dev, vif, link_id);
 
 		switch (ev) {
 		case MT76_STA_EVENT_ASSOC:
@@ -1441,12 +1433,12 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 						 link, msta_link,
 						 CONN_STATE_CONNECT, true);
 			if (err)
-				goto unlock;
+				return err;
 
 			err = mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
 						       link_id, false);
 			if (err)
-				goto unlock;
+				return err;
 
 			msta_link->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 			break;
@@ -1455,7 +1447,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 						 link, msta_link,
 						 CONN_STATE_PORT_SECURE, false);
 			if (err)
-				goto unlock;
+				return err;
 			break;
 		case MT76_STA_EVENT_DISASSOC:
 			for (i = 0; i < ARRAY_SIZE(msta_link->twt.flow); i++)
@@ -1475,7 +1467,20 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			break;
 		}
 	}
-unlock:
+
+	return 0;
+}
+
+static int
+mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+		     struct ieee80211_sta *sta, enum mt76_sta_event ev)
+{
+	int err;
+
+	mutex_lock(&dev->mt76.mutex);
+	err = mt7996_mac_sta_links_event(dev, vif, sta,
+					 mt7996_mac_sta_links(dev, vif, sta),
+					 ev);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return err;
-- 
2.47.3

