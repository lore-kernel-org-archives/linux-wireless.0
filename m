Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8284A3F25
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320388; cv=none; b=LtjV09h7H88OyboKXCJ/z1lYeBjaPBwLgXVCGhHC2GWRFR2upqpWZc7gtrZui+/ZU2ZepyP97+W+uAPAaeFdHJzw7QHqDzYYybOG0Ky40lavz9VV/axuSCRycirrHwJXedo3TPWSQ5ABD1Wc/+g9JGysX+fxLWNzarFRp3FUTAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320388; c=relaxed/simple;
	bh=xsZHukiDb5GFiKU/tpfIAcRsYtJUQFtyxnLsKOcomco=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKIEK5f9qzTMNe7F+te8ZZQXVoUD+zOIApTcOiCYO5v/+6w7eg42AMqphqZ/qJuNyHHetjpGyQKJkXSnPLVNzClAq2ti3b/YQis8qMeUVjSJLW4HBV3ZWJcE4iKMOLT+mGxc4z06+6TzOjZchXbFye/B9DTuwDTEWevNicX+L+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Z0N60m0c; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Z0N60m0c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=efIHySm4e+O21kbZfeX3wTiep8/PUCu238ZF28c+Bqk=; b=Z0N60m0cgyYu8G0TRfC+/tq2nT
	ctOlsKAG1Ky/ZGbKNj87cfMD05jHcst9mLWHPrYswxI+59xxTWIle01Z8UBZDvToZ1/277q+34r7J
	7JwVq7E/w+bc+1+zDxHAglOoxngp8M9bsO5nxIGe00sTEpJcqNpIF5mtJKwmmFNcuxQA=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGF-00HAg3-1Y
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 24/27] wifi: mt76: mt7996: restore a station link that returns after a removal
Date: Tue,  6 Oct 2026 22:59:33 +0200
Message-ID: <20261006205936.669125-24-nbd@nbd.name>
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

When mt7996_mac_sta_change_links() removes a link from a station, it
keeps the msta_link and the firmware entry of the link. Commit
e077071e7ac4 ("wifi: mt76: mt7996: fix teardown command for an MLD
peer") removed the per-link DISCONNECT command for MLD peers, and a link
that comes back must not get a second STA_REC with EXTRA_INFO_NEW,
which commit 8e3e7567b8c1 ("mt76: mt7915: add sta_rec with
EXTRA_INFO_NEW for the first time only") says can remove the entry. A
link that comes back is therefore not connected again, and gets no rate
control, keys or authorization.

On removal, reset only the driver state of the link: its TWT flows, the
TX state and the key index. When the link comes back with its entry
still connected, send it the header translation state, rate control,
its keys and, for an authorized station, the CONN_STATE_PORT_SECURE
update without EXTRA_INFO_NEW, which also carries the header
translation state. Send the 4-address PS leave request and the block
ack sessions as for a new link, since the link can come back as a link
other than the primary link.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 33 +++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 89e9ef855a78..9965ac136bec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1263,6 +1263,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	INIT_LIST_HEAD(&msta_link->wcid.poll_list);
 	msta_link->sta = msta;
 	msta_link->connected = false;
+	msta_link->wcid.tx_info = 0;
 	msta_link->wcid.sta = 1;
 	msta_link->wcid.idx = idx;
 	msta_link->wcid.link_id = link_id;
@@ -1699,7 +1700,7 @@ mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			  unsigned long add)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	unsigned long new_links = 0, updated;
+	unsigned long new_links = 0, resumed = 0, joined, updated;
 	unsigned int link_id;
 	int err;
 
@@ -1713,6 +1714,8 @@ mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
 		if (!msta_link->connected)
 			new_links |= BIT(link_id);
+		else if (!(msta_link->wcid.tx_info & MT_WCID_TX_INFO_SET))
+			resumed |= BIT(link_id);
 	}
 
 	err = mt7996_mac_sta_links_event(dev, vif, sta, new_links,
@@ -1720,17 +1723,40 @@ mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	if (err)
 		return err;
 
+	for_each_set_bit(link_id, &resumed, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt7996_sta_link *msta_link;
+		struct mt7996_vif_link *link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		link = mt7996_vif_link(dev, vif, link_id);
+
+		if (msta->conn_state != CONN_STATE_PORT_SECURE) {
+			err = mt7996_mcu_wtbl_update_hdr_trans(dev, vif, link,
+							       msta_link);
+			if (err)
+				return err;
+		}
+
+		err = mt7996_mcu_add_rate_ctrl(dev, msta, vif, link_id, false);
+		if (err)
+			return err;
+
+		msta_link->wcid.tx_info |= MT_WCID_TX_INFO_SET;
+	}
+
 	mt7996_mac_sta_links_set_keys(dev, vif, sta, links & add);
 
 	updated = new_links;
 	if (msta->conn_state == CONN_STATE_PORT_SECURE) {
+		updated |= resumed;
 		err = mt7996_mac_sta_links_event(dev, vif, sta, updated,
 						 MT76_STA_EVENT_AUTHORIZE);
 		if (err)
 			return err;
 	}
 
-	for_each_set_bit(link_id, &new_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+	joined = new_links | resumed;
+	for_each_set_bit(link_id, &joined, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 
@@ -1751,7 +1777,7 @@ mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			return err;
 	}
 
-	return mt7996_mac_sta_links_ba_add(dev, vif, sta, new_links);
+	return mt7996_mac_sta_links_ba_add(dev, vif, sta, new_links | resumed);
 }
 
 static void
@@ -1825,6 +1851,7 @@ mt7996_mac_sta_change_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&dev->mt76.mutex);
 
+	mt7996_mac_sta_links_reset(dev, vif, sta, rem);
 	mt7996_mac_sta_remove_links(dev, vif, sta, rem, false);
 	mt7996_mac_sta_links_bss_add(dev, vif, sta, add);
 	ret = mt7996_mac_sta_add_links(dev, vif, sta, add);
-- 
2.47.3

