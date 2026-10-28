Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190255;
	b=SEm4EvvcoXRnZJTgt0lUZVFdXDilzY1VgmukIYRWmf5RuNiOGwqHl+UzldEol96ilulk
	 f7ZyaKrDLYpH9hfkvwVz01i+wZ7d/lvtOkFdczJIRBCHEKkVOh7TrldikAjkHCmS9zmrB
	 MI8O2snWKFJSMag5Wm517vz3GZ0HGb22CksYSkbpvEXtjEwAYW+mByRfZpb4uDYf/+4GH
	 cqkGHVRrNZ5Wj9f1fyqn3rGgB9JenyiHx1xU6ogvVJ8PAVJz7JjrNWQtO8ZWx0xAsWCOq
	 CqFR0sn7+GhRFrRIr84I//2bDJWHNZI1FsbAdBCkEEFXMUw6fc1lPEyFbh5uj/Dgj7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190255;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sI5A2gcL6lVitnswfNUV2D+tlHa2PWBs5fiDGqxWQAc=;
	b=IOS4nD/mfY1XzsKHrFJIrJ1CRlykpjpnJYJQmLN1B5DNHigcsZcKL2vb1uC8j6MdsbNQ
	 grhMblndyWFIltKN6XdTRH7Q2J85bs/v8CFVRX3S6cixPUPtqTEGo6c0wyJrtvgFrzbFs
	 C+1EoaKkOwdme4Rz91Vy2TX24SiV7GwM5NIOWLawBsr+dDlmwFC0q6StTnmfBsomSJXLI
	 QNm5RyzTRkEBYx5wHpaMsNuR6S6xHibRYSnsjrO9TgF40oGyb4Pp6Q9L4s6vpDI2w+7rh
	 P7whGwhXmSOaJs4oeyZsVAsuEIuVM7U/j6/m7J2bV0ppkVbgHSBPgcYNxzWegsP67mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=efCA7tAS;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E43606A32E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39E43606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=efCA7tAS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sI5A2gcL6lVitnswfNUV2D+tlHa2PWBs5fiDGqxWQAc=; b=efCA7tAS+QRdcCUsFDboPnI8X8
	UwQYog9vN3q315jhQUaJ244PaE5A7CQ6wuRSQtdKzd1qx825hftR5yE489nC/kIx6aU6Z9dylN7QT
	/gKNjK6yoIGjhnmwO7LQDN3gGwpJNYuuXMp8KTI7uX8GSqxMm0FRjGt0u+5WayytLqWk=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hM-00C8Bw-0T
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:08 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 12/25] wifi: mt76: mt7996: set up a vif link again on another radio
Date: Wed, 28 Oct 2026 13:23:50 +0100
Message-ID: <20261028122403.796394-12-nbd@nbd.name>
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

Since the link teardown moved to mt7996_remove_interface(), a link stays
in mvif->mt76.valid_links after its chanctx is unassigned. When the next
chanctx assignment puts the link on another radio, mt7996_vif_link_add()
takes the reuse branch and programs DEV_INFO and BSS_INFO on the new
radio with the OMAC index and the band of the old radio. The firmware
then holds the BSS of the link on the wrong band, and the STA_REC of a
station on that link is created under it. After the station
disconnects, the firmware keeps that record, so every later station
that gets the same WTBL index is refused:

  mt7996e 0000:01:00.0: Message 001a0003 (seq 1) cid 0003 failed: firmware status 0x10003

hostapd then fails with "Could not set STA to kernel driver" for each
new station on that index until the firmware restarts. Examples are a
non-AP interface that used link 0 on 6 GHz and associates as an MLD
with link 0 on 2.4 GHz, and an AP that is stopped and started on
another band, both without an interface down.

Tear such a link down on its old radio and add it again on the new one.
If the add on the new radio fails, free the link, since it is no longer
a valid link and mt7996_remove_interface() destroys only valid links.
Keep the reuse branch for a link that stays on its band, and for
mt76_switch_vif_chanctx(), which moves a link to another radio during a
channel switch with its stations in place.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 145 ++++++++++++------
 1 file changed, 96 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d22abbd543b7..3384e46e7b05 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -305,6 +305,76 @@ mt7996_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	WARN_ON(mt7996_set_hw_key(hw, it->cmd, vif, sta, it->link_id, key));
 }
 
+static void mt7996_vif_link_teardown(struct mt7996_phy *phy,
+				     struct mt7996_vif_link *link,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *link_conf)
+{
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	struct mt7996_sta_link *msta_link = &link->msta_link;
+	unsigned int link_id = msta_link->wcid.link_id;
+	struct mt76_vif_link *mlink = &link->mt76;
+	struct mt7996_dev *dev = phy->dev;
+	int idx = msta_link->wcid.idx;
+
+	if (!link_conf)
+		link_conf = &vif->bss_conf;
+
+	if (link->bmc_sta_added)
+		mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
+				   CONN_STATE_DISCONNECT, false);
+	mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink, msta_link, false);
+	mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, false);
+
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
+
+	dev->mt76.vif_mask &= ~BIT_ULL(mlink->idx);
+	dev->mld_idx_mask &= ~BIT_ULL(link->mld_idx);
+	phy->omac_mask &= ~BIT_ULL(mlink->omac_idx);
+	if (!mlink->wcid->offchannel)
+		mvif->mt76.valid_links &= ~BIT(link_id);
+
+	spin_lock_bh(&dev->mt76.sta_poll_lock);
+	if (!list_empty(&msta_link->wcid.poll_list))
+		list_del_init(&msta_link->wcid.poll_list);
+	spin_unlock_bh(&dev->mt76.sta_poll_lock);
+
+	mt76_wcid_cleanup(&dev->mt76, &msta_link->wcid);
+}
+
+static void mt7996_vif_link_free(struct mt7996_vif_link *link,
+				 struct ieee80211_vif *vif)
+{
+	unsigned int link_id = link->msta_link.wcid.link_id;
+	struct mt76_vif_link *mlink = &link->mt76;
+
+	if (mlink == (struct mt76_vif_link *)vif->drv_priv ||
+	    mlink->wcid->offchannel)
+		return;
+
+	rcu_assign_pointer(mlink->mvif->link[link_id], NULL);
+	kfree_rcu(mlink, rcu_head);
+}
+
+static int mt7996_vif_link_reuse(struct mt7996_phy *phy,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_bss_conf *link_conf,
+				 struct mt7996_vif_link *link)
+{
+	struct mt76_vif_link *mlink = &link->mt76;
+	int ret;
+
+	ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
+	if (ret)
+		return ret;
+
+	if (vif->type == NL80211_IFTYPE_AP && ieee80211_vif_is_mld(vif))
+		return mt7996_mcu_mld_link_oper(phy->dev, link_conf, link, true);
+
+	return mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink,
+				       &link->msta_link, true);
+}
+
 int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *link_conf,
 			struct mt76_vif_link *mlink)
@@ -320,33 +390,38 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		.link_id = link_conf->link_id,
 	};
 	int mld_idx, idx, ret;
+	bool moved = false;
 
 	if ((mvif->mt76.valid_links & BIT(link_conf->link_id)) &&
 	    !mlink->offchannel) {
-		/* update the link address */
-		ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
-		if (ret)
-			return ret;
+		struct mt7996_phy *old_phy;
 
-		if (vif->type == NL80211_IFTYPE_AP && ieee80211_vif_is_mld(vif))
-			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
-							true);
+		/* mt76_switch_vif_chanctx() sets the new chanctx only after
+		 * the link moved
+		 */
+		if (mlink->band_idx == band_idx ||
+		    mt76_vif_link_phy(mlink) != mphy)
+			return mt7996_vif_link_reuse(phy, vif, link_conf, link);
 
-		return mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink,
-					       msta_link, true);
+		old_phy = __mt7996_phy(dev, msta_link->wcid.phy_idx);
+		if (old_phy) {
+			mt7996_vif_link_teardown(old_phy, link, vif, link_conf);
+			moved = true;
+		}
 	}
 
+	ret = -ENOSPC;
 	mlink->idx = __ffs64(~dev->mt76.vif_mask);
 	if (mlink->idx >= mt7996_max_interface_num(dev))
-		return -ENOSPC;
+		goto error;
 
 	idx = get_omac_idx(vif->type, phy->omac_mask);
 	if (idx < 0)
-		return -ENOSPC;
+		goto error;
 
 	mld_idx = get_own_mld_idx(dev->mld_idx_mask, false);
 	if (mld_idx < 0)
-		return -ENOSPC;
+		goto error;
 
 	link->mld_idx = mld_idx;
 	link->bmc_sta_added = false;
@@ -360,7 +435,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
 	if (ret)
-		return ret;
+		goto error;
 
 	dev->mt76.vif_mask |= BIT_ULL(mlink->idx);
 	dev->mld_idx_mask |= BIT_ULL(link->mld_idx);
@@ -426,6 +501,12 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	}
 
 	return 0;
+
+error:
+	if (moved)
+		mt7996_vif_link_free(link, vif);
+
+	return ret;
 }
 
 static void mt7996_vif_link_destroy(struct mt7996_phy *phy,
@@ -433,42 +514,8 @@ static void mt7996_vif_link_destroy(struct mt7996_phy *phy,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_bss_conf *link_conf)
 {
-	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
-	struct mt7996_sta_link *msta_link = &link->msta_link;
-	unsigned int link_id = msta_link->wcid.link_id;
-	struct mt76_vif_link *mlink = &link->mt76;
-	struct mt7996_dev *dev = phy->dev;
-	int idx = msta_link->wcid.idx;
-
-	if (!link_conf)
-		link_conf = &vif->bss_conf;
-
-	if (link->bmc_sta_added)
-		mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
-				   CONN_STATE_DISCONNECT, false);
-	mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink, msta_link, false);
-	mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, false);
-
-	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
-
-	dev->mt76.vif_mask &= ~BIT_ULL(mlink->idx);
-	dev->mld_idx_mask &= ~BIT_ULL(link->mld_idx);
-	phy->omac_mask &= ~BIT_ULL(mlink->omac_idx);
-	if (!mlink->wcid->offchannel)
-		mvif->mt76.valid_links &= ~BIT(link_id);
-
-	spin_lock_bh(&dev->mt76.sta_poll_lock);
-	if (!list_empty(&msta_link->wcid.poll_list))
-		list_del_init(&msta_link->wcid.poll_list);
-	spin_unlock_bh(&dev->mt76.sta_poll_lock);
-
-	mt76_wcid_cleanup(&dev->mt76, &msta_link->wcid);
-
-	if (mlink != (struct mt76_vif_link *)vif->drv_priv &&
-	    !mlink->wcid->offchannel) {
-		rcu_assign_pointer(mlink->mvif->link[link_id], NULL);
-		kfree_rcu(mlink, rcu_head);
-	}
+	mt7996_vif_link_teardown(phy, link, vif, link_conf);
+	mt7996_vif_link_free(link, vif);
 }
 
 static void
-- 
2.47.3

