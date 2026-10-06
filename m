Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129884A0933
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320387; cv=none; b=YjJ2LKJ9t8M+sMmRgMo9vqOfqqRB26VHN4HtBIme52LS2CzuCxjYAdmw0wBenQp1MCEq0KcvrOISnJAzvj/FPqZXT6d8f+LLjEaiH1gbLnwMGNiJnrcH19znQRF92Xs9Y0m4yvUs5YnH/tBf3ysYeV/ZJBWIYig9Xxk2vKK5khE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320387; c=relaxed/simple;
	bh=pRzWnftlI+pmLL5Zwk2LEheP4pUbaiRE6L4sy7HZT0U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/zhoDGyUNTT9pqiWXYgjXMmeoei9yoE1vVuLVZ9Yymjbv3awlMMFNEDF74O5dnO4jAHmAR/H+42dLa6PDZQa+L/jDf2CH3J9wCFsEOjqqLF2uaLrIivKcSzyg43B39jkEU2L10KRfIiFU3sfO4a5uwlg8QxfSsRCzv4al86l/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=dxRzzbHX; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dxRzzbHX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=32qBq066RvIi2PeNeMk3UMsIfxYgRD3TJrKnCqNFFzM=; b=dxRzzbHXH28rDo0+CQ0yMW37/U
	vTw6LL5VsrbX0yQKHDLEdhMkNm4f0pHq3wp0tZeso+Zf5xx4MT/kAg0frVJXAurRxXBQU/izicJUq
	J8Q6YXotFHfqVPi/K0PVcKLcmhZmy3PX3zn/2TfjKiQ5ut9R+6cd2f5wtJH/IdkQqNp4=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGE-00HAg3-0Q
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 16/27] wifi: mt76: mt7996: add the station BMC entry as new once per BSSID
Date: Tue,  6 Oct 2026 22:59:25 +0200
Message-ID: <20261006205936.669125-16-nbd@nbd.name>
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

A station link sends its broadcast STA_REC with EXTRA_INFO_NEW on every
BSS_CHANGED_BSSID. Commit 8e3e7567b8c1 ("mt76: mt7915: add sta_rec with
EXTRA_INFO_NEW for the first time only") notes that the firmware may
remove an entry that is added as new twice. Since a removed vif link
keeps its firmware entry, this happens on a link that is deactivated and
activated again: _ieee80211_set_active_links() reports
BSS_CHANGED_BSSID with the same BSSID, after ieee80211_key_switch_links()
has installed the group keys of the link, and nothing in the driver
installs them again after the entry is added as new.

Record the BSSID the entry was added with, and add it as new only for
a different BSSID. A BSSID that goes to zero on disconnection clears
the record, so that the next association adds the entry as new again.
A link that is set up clears the record as well, since the firmware has
no entry for it then.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 38 ++++++++++++-------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 58a487549ddf..d868e9641334 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -341,6 +341,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		return -ENOSPC;
 
 	link->mld_idx = mld_idx;
+	eth_zero_addr(link->bmc_bssid);
 	mlink->omac_idx = idx;
 	mlink->band_idx = band_idx;
 	mlink->wmm_idx = vif->type == NL80211_IFTYPE_AP ? 0 : 3;
@@ -898,6 +899,23 @@ mt7996_update_mu_group(struct ieee80211_hw *hw, struct mt7996_vif_link *link,
 	mt76_wr(dev, MT_WF_PHYRX_BAND_GID_TAB_POS3(band), mu[3]);
 }
 
+static void
+mt7996_vif_link_bss_add(struct mt7996_phy *phy, struct ieee80211_vif *vif,
+			struct ieee80211_bss_conf *link_conf,
+			struct mt7996_vif_link *link, bool newly)
+{
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		newly = !ether_addr_equal_unaligned(link->bmc_bssid,
+						    link_conf->bssid);
+		memcpy(link->bmc_bssid, link_conf->bssid, ETH_ALEN);
+	}
+
+	mt7996_mcu_add_bss_info(phy, vif, link_conf, &link->mt76,
+				&link->msta_link, true);
+	mt7996_mcu_add_sta(phy->dev, link_conf, NULL, link, NULL,
+			   CONN_STATE_PORT_SECURE, newly);
+}
+
 static void
 mt7996_vif_cfg_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       u64 changed)
@@ -929,12 +947,8 @@ mt7996_vif_cfg_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			if (!phy)
 				continue;
 
-			mt7996_mcu_add_bss_info(phy, vif, link_conf,
-						&link->mt76, &link->msta_link,
-						true);
-			mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
-					   CONN_STATE_PORT_SECURE,
-					   !!(changed & BSS_CHANGED_BSSID));
+			mt7996_vif_link_bss_add(phy, vif, link_conf, link,
+						!!(changed & BSS_CHANGED_BSSID));
 		}
 	}
 
@@ -980,13 +994,11 @@ mt7996_link_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	 * and then peer references bss_info_rfch to set bandwidth cap.
 	 */
 	if ((changed & BSS_CHANGED_BSSID && !is_zero_ether_addr(info->bssid)) ||
-	    (changed & BSS_CHANGED_BEACON_ENABLED && info->enable_beacon)) {
-		mt7996_mcu_add_bss_info(phy, vif, info, &link->mt76,
-					&link->msta_link, true);
-		mt7996_mcu_add_sta(dev, info, NULL, link, NULL,
-				   CONN_STATE_PORT_SECURE,
-				   !!(changed & BSS_CHANGED_BSSID));
-	}
+	    (changed & BSS_CHANGED_BEACON_ENABLED && info->enable_beacon))
+		mt7996_vif_link_bss_add(phy, vif, info, link,
+					!!(changed & BSS_CHANGED_BSSID));
+	else if (changed & BSS_CHANGED_BSSID)
+		eth_zero_addr(link->bmc_bssid);
 
 	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
 		mt7996_mcu_set_protection(phy, link, info->ht_operation_mode,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 82a2a8a5db69..03fc0e7fd4f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -279,6 +279,7 @@ struct mt7996_vif_link {
 	struct cfg80211_bitrate_mask bitrate_mask;
 
 	u8 mld_idx;
+	u8 bmc_bssid[ETH_ALEN];
 };
 
 struct mt7996_vif_link_info {
-- 
2.47.3

