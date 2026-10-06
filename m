Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C470A46AA95
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320385; cv=none; b=T0WzFJkB+eiUy+Bd+ep+NgEZWnQYnY4nctflWAsNdHptEFNVAy9z+nqS9wvpJSdYae7l7xc3hBqaivTqT5QQbp/sl8nburzwC6BWiVHmhxcTNRCZ6afjZkMD30C/Bu4zjnGLYxLDxx5ZMFo8Y9kTP2QnJvUsx0y+GlgtFdtRs84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320385; c=relaxed/simple;
	bh=9bWW61ZWNyY84pXY6+bwXjlYTF7OzhGmRfKggKH/dYw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeWKZKgBNuEzg/yOCKD50LsK5lW84CnZB5TAoXUQxmZXS1ocxllIxlHyK7T6gMoo1fVc552+4tv/f7n9+kIKXieuu6SNbeiY1Qa+SveA5Ed5uSWmhAoBmPWdJs8PFgXf3kOd4wbZCemLJBDDrjeQ3HfgEtUEHxdIcwPMf+ganrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=KEUlwA4x; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="KEUlwA4x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3DFnPqJFeTJPxvW9IhPUHbcSJ+aRONpwAnQd6Nk070o=; b=KEUlwA4x7XxajR6L7qYK4CPOL7
	zTPK8AVQ+emkfFM5VsdSopEuh16uBhUCeYYisReYUFU3TvF54uXNsWXy6KqwbOlIAhSSnzDDmjxas
	xFxGQkpof6d4u7Aw+o6oJ2/3a40UIPYkPx7WVkqySvQf0O8GaCWJ35vdsnDmPlbyLh7g=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGD-00HAg3-0P
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 10/27] wifi: mt76: mt7996: clear all link wcid entries in sta_pre_rcu_remove
Date: Tue,  6 Oct 2026 22:59:19 +0200
Message-ID: <20261006205936.669125-10-nbd@nbd.name>
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

mt76_sta_pre_rcu_remove() clears the wcid table entry of msta->deflink
only. mac80211 calls it before the synchronize_net() that ends the RCU
readers of the station, and frees the station right after
mt7996_mac_sta_remove(). For an MLD station, the wcid table entries of
the other links stay set until mt7996_mac_sta_remove(), after that
grace period. An RX or TX status reader that looks up one of these
entries in that window can follow msta_link->sta or def_wcid into the
freed station.

Clear the wcid table entries of all links of the station in
.sta_pre_rcu_remove.

Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index f44af31281b7..3c27cc02d527 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1513,6 +1513,30 @@ mt7996_set_active_links(struct ieee80211_vif *vif)
 	ieee80211_set_active_links_async(vif, active_links);
 }
 
+static void
+mt7996_sta_pre_rcu_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	unsigned int link_id;
+
+	mutex_lock(&dev->mt76.mutex);
+	spin_lock_bh(&dev->mt76.status_lock);
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		struct mt7996_sta_link *msta_link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (msta_link)
+			rcu_assign_pointer(dev->mt76.wcid[msta_link->wcid.idx],
+					   NULL);
+	}
+
+	spin_unlock_bh(&dev->mt76.status_lock);
+	mutex_unlock(&dev->mt76.mutex);
+}
+
 static int
 mt7996_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 struct ieee80211_sta *sta, enum ieee80211_sta_state old_state,
@@ -2618,7 +2642,7 @@ const struct ieee80211_ops mt7996_ops = {
 	.vif_cfg_changed = mt7996_vif_cfg_changed,
 	.link_info_changed = mt7996_link_info_changed,
 	.sta_state = mt7996_sta_state,
-	.sta_pre_rcu_remove = mt76_sta_pre_rcu_remove,
+	.sta_pre_rcu_remove = mt7996_sta_pre_rcu_remove,
 	.link_sta_rc_update = mt7996_link_sta_rc_update,
 	.set_key = mt7996_set_key,
 	.ampdu_action = mt7996_ampdu_action,
-- 
2.47.3

