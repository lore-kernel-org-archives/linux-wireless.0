Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A6A46A611
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320384; cv=none; b=irgWY2vr/Ykak4qE41uVCCfYqbI+XWGQPM2AmEQjg2aeW9UzkThKyx3BKud2dTBXnd34lYPOpysUqaWLV5mk41m4DVWbwuhBtQQadT7iOprBDmWW9Hdj+azKj/dSsZHkE1Divfn+y/Bj4CrWqxd1gNzt5MOmMtdiE75k683Wb7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320384; c=relaxed/simple;
	bh=kxxie7BJwnLAsv9Ef2nke2ypNs6RX6r5yxozGDoKCpU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqiP/vj0fMICqoHtOR7eRXSdiN1HeTzccoCoaYe7jaAga9glCWla/6Ip8IvYlrOBdVxAy3ju8uzX404RvZp7SesJm5QNBXIEzt/+bmK8icQQc5ZRIA4BSGof64G5umrR1WV5qtB4KidBqOvcp2LvXBCeT5rLHaF718UaocRTWNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EsNkO9Af; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EsNkO9Af"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G9k1OKEF7s7OH/FacSQH1wLDNNWBwBz+tAjO9XNtywU=; b=EsNkO9AfZnGj2DjML6VEhTa0eF
	xaPVTnrcRmnPzfU5GlJUz4MrYYnPTJ6FcNxEyLzuqPYFD75/zfYp0n4U/e89/KMbYt6jdoPL7zsN4
	QWNcsmlJJth+er5ezV54nvwReQaGWisnssvm3CM198QbzozezUGP2q8BPbh4Ofp5ZiQA=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGC-00HAg3-2X
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:40 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 08/27] wifi: mt76: mt7996: do not walk the vif keys when a link is destroyed
Date: Tue,  6 Oct 2026 22:59:17 +0200
Message-ID: <20261006205936.669125-8-nbd@nbd.name>
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

Since commit eddc7286f6bb ("wifi: mt76: mt7996: fix key add/remove
imbalance"), mt7996_vif_link_destroy() walks the vif keys with SET_KEY.
Before that commit the walk used DISABLE_KEY. The commit message says a
key for a link is added and removed only once, but a SET_KEY walk on
destroy uploads the keys again, and for a BIGTK with beaconing enabled
it also removes and adds the beacon of the link being destroyed.

Remove the walk. mac80211 removes the keys itself with set_key() calls,
which is the one removal that commit describes.

The walk currently finds no keys: mt7996_vif_link_destroy() runs for a
non-offchannel link only from mt7996_remove_interface(), and
ieee80211_do_stop() frees the keys of the interface before
drv_remove_interface(). An interface type change goes through the same
path, since mt7996 has no .change_interface. Found by inspection.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index e74254928578..f94b5fdfca24 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -425,19 +425,12 @@ static void mt7996_vif_link_destroy(struct mt7996_phy *phy,
 	struct mt7996_sta_link *msta_link = &link->msta_link;
 	unsigned int link_id = msta_link->wcid.link_id;
 	struct mt76_vif_link *mlink = &link->mt76;
-	struct mt7996_key_iter_data it = {
-		.cmd = SET_KEY,
-		.link_id = link_id,
-	};
 	struct mt7996_dev *dev = phy->dev;
 	int idx = msta_link->wcid.idx;
 
 	if (!link_conf)
 		link_conf = &vif->bss_conf;
 
-	if (!mlink->wcid->offchannel)
-		ieee80211_iter_keys(phy->mt76->hw, vif, mt7996_key_iter, &it);
-
 	mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
 			   CONN_STATE_DISCONNECT, false);
 	mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink, msta_link, false);
-- 
2.47.3

