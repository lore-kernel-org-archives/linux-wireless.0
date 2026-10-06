Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1177F4A2A46
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320387; cv=none; b=boO8WZU5lXQKrCzoML2MB5HIzuloz0kNBxQ55mlch1zMnObdhf7AOa1UEQGJG46SUJPNY09V+wRQFFTSzNAQL37w2H1StvtpbcHNMgZRoR5NTBxlTemKtaIuFdJaK9KL+EHdD66LAdpUAajOaHUYqGVfvof98LSgU7PBJtMeF84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320387; c=relaxed/simple;
	bh=fYA1ecD4hDz3NvUitPZPBGcA5Qk19BNwkUV50IQzAgI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKrT74J9AEZP3Cbw/P/krKynQIJ+6dSBCOmrha3cwNwH+rjAZiSVHx3I6TV8yrj0LDKijLY64mchkl7TZzvJpRwYKTzS+o+kY3/RBGbcY/nF7BegOCJrMKK0V4kQcZlB5vUcHQ5AQ7puX221xGI+8ddD+AGnOKUoDBM7eIVen5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ZQWvIYvT; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ZQWvIYvT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9sysCB043KETdo+BEp+DVWg9EwYtCIKVBMyPde7/f1s=; b=ZQWvIYvTPnJMUbFAPF8RhRCuIk
	GUiAFviJvyJSEWCLnyz25rOsNjzt+Z2nKDp3ISOQ3KJP8nYtIZE+FvCls3cv8CnBcVRfvzZ9/jJvv
	sTSZtYtJqYJa3igaccTVC/Nw5OHvXdGjJv1UsJtCsRBrP/8EEta+mdInDm5fYst7wOxE=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGE-00HAg3-26
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 19/27] wifi: mt76: mt7996: record the connection state of a station
Date: Tue,  6 Oct 2026 22:59:28 +0200
Message-ID: <20261006205936.669125-19-nbd@nbd.name>
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

mt7996_sta_state() turns the station state transitions into STA_REC
updates for the links of the station, but the driver keeps no record of
the state that the station reached. A link that is added after
association needs that state to be brought up to the same level as the
other links.

Record the connection state after each station event, and lower it to
CONN_STATE_CONNECT when the station leaves IEEE80211_STA_AUTHORIZED,
for example when hostapd de-authorizes it for a re-authentication.

No functional change on its own.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 30 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index a23d148eafa6..7792c3a878af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1472,6 +1472,7 @@ mt7996_mac_sta_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
 	msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
 	msta->seclink_id = IEEE80211_LINK_UNSPECIFIED;
+	msta->conn_state = CONN_STATE_DISCONNECT;
 	msta->vif = mvif;
 	err = mt7996_mac_sta_add_links(dev, vif, sta, links);
 
@@ -1569,11 +1570,27 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	int err;
 
 	mutex_lock(&dev->mt76.mutex);
+
 	err = mt7996_mac_sta_links_event(dev, vif, sta,
 					 mt7996_mac_sta_links(dev, vif, sta),
 					 ev);
-	if (!err && ev == MT76_STA_EVENT_DISASSOC)
+	if (err)
+		goto out;
+
+	switch (ev) {
+	case MT76_STA_EVENT_ASSOC:
+		msta->conn_state = CONN_STATE_CONNECT;
+		break;
+	case MT76_STA_EVENT_AUTHORIZE:
+		msta->conn_state = CONN_STATE_PORT_SECURE;
+		break;
+	case MT76_STA_EVENT_DISASSOC:
+		msta->conn_state = CONN_STATE_DISCONNECT;
 		mt7996_mac_sta_clear_connected(dev, msta);
+		break;
+	}
+
+out:
 	mutex_unlock(&dev->mt76.mutex);
 
 	return err;
@@ -1650,6 +1667,17 @@ mt7996_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	    new_state == IEEE80211_STA_NOTEXIST)
 		mt7996_mac_sta_remove(dev, vif, sta);
 
+	if (old_state == IEEE80211_STA_AUTHORIZED &&
+	    new_state == IEEE80211_STA_ASSOC) {
+		struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+
+		mutex_lock(&dev->mt76.mutex);
+		msta->conn_state = CONN_STATE_CONNECT;
+		mutex_unlock(&dev->mt76.mutex);
+
+		return 0;
+	}
+
 	if (old_state == IEEE80211_STA_AUTH &&
 	    new_state == IEEE80211_STA_ASSOC) {
 		mt7996_set_active_links(vif);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index ec453f5ff3a5..ead211391404 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -269,6 +269,7 @@ struct mt7996_sta {
 	struct mt7996_sta_link __rcu *link[IEEE80211_MLD_MAX_NUM_LINKS];
 	u8 deflink_id;
 	u8 seclink_id;
+	u8 conn_state;
 
 	unsigned long wcid_flags;
 
-- 
2.47.3

