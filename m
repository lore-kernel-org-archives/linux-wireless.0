Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190255;
	b=1hnxyLvY9Pq8YIff2aASKhpVvYj5OOK3KUZ8zTb6cMPhnzctLyin3WbzD+wNvWg1uk5M
	 6UpeGoVfon8k0nUbH5et7e9jJkcmlSEbbMYFZvCFcxVHuZdiCnMj2na70tOvvcPG8rVz0
	 abTWAJFQju1ZLNcNOLzFdPQaHi3ypRTuEhURy04F3LOoZnb453ppRSISRsB18xv0Ct6cO
	 dxTnVH5DWr3kIMkLGm6olE5dnoDYLE7+dkB/pcdf+BCGERQpOOvoiU3uPKFzKRevI/e6R
	 7thMN3POOE2Usj68N6i2pLQygiwt1fAf3SA1CW1NlDHbs23Cb1VWWIr2DsEc3gScuUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190255;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6kVdGtkJvBlJumwcgX23LmiwAk8vOX4EYYojNUrE3/4=;
	b=Jv8xQeAQfNCWKVCNmWyOr4wvSVQcBANO+OQTBbSpsRTOUKWWCCYXOGYb9YonAMjAVoyO
	 ULbXLSbwB4KNWceqyaVRnhX8+ANtJFHqu2mPsu7vl9KCEIuf+w5isS9n5Phq1crG2w+n5
	 aOugBg+OBhyOmOkAVUYPpv8wsqKA2eVv13Jy7XxOIAoFDEGSrIw+IBGkfAH/IVJV8rIkZ
	 +1pvUX+2YD8QVth6qLHOHuSYhHNqo0TmhVryPKCJ0/XfK33XvuMEbWJDOT75Qa3jkVZP+
	 qJpQeuikwme5hikQW9E0jstLGnA6kE9NwT/3ZTkeqPwzowwnTE+q8T3h0cTn1SUMyeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=IrgZEOgr;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8A6606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF8A6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=IrgZEOgr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6kVdGtkJvBlJumwcgX23LmiwAk8vOX4EYYojNUrE3/4=; b=IrgZEOgrkd1mT4JlKIVsf+eV8L
	AOpdplkGhZKZc4WvtauC3TBS8FRhMqPA4JlCkk7RZ+67XMpY1wC0DkadZlQvwet6Uvdz8s6Db1wwb
	i65iI5q5HVAi/SUMZrExFycMMcC3xr3TP9nDs4KTOikxnCBMJUyZ+h04TTGGWp8bO8DM=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hK-00C8Bw-1t
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:06 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 03/25] wifi: mt76: mt7996: only remove a BMC STA_REC that was added
Date: Wed, 28 Oct 2026 13:23:41 +0100
Message-ID: <20261028122403.796394-3-nbd@nbd.name>
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

mt7996_vif_link_add() defers the BMC STA_REC of a station interface to
BSS_CHANGED_BSSID or BSS_CHANGED_ASSOC. A link that
mt76_get_vif_phy_link() creates for a scan or ROC receives neither,
because it is not part of the vif links. mt7996_vif_link_destroy() still
sends a STA_REC removal for it at the end of each scan, and the firmware
rejects it:

  staRecFreeStaRec-1606 Err: u2ClientSupportCnt is already 0. (wcid 1087)
  staRecUniCmdUpdate, u2Tag 0x0 ret = 0xc0000001 not success

Record per link whether the firmware accepted its BMC STA_REC, and only
send the removal for such a link. This also covers a station link that
is torn down before its first BSSID or association update.

Fixes: 51b795d68cad ("wifi: mt76: connac: use peer address for station BMC entry")
Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c   | 18 +++++++++++-------
 .../net/wireless/mediatek/mt76/mt7996/mt7996.h |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index a2655784a13d..e8faa826e037 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -349,6 +349,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		return -ENOSPC;
 
 	link->mld_idx = mld_idx;
+	link->bmc_sta_added = false;
 	link->csa_bcn_uploaded = false;
 	eth_zero_addr(link->bmc_bssid);
 	mlink->omac_idx = idx;
@@ -392,9 +393,10 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	/* defer the first STA_REC of BMC entry to BSS_CHANGED_BSSID for STA
 	 * interface, since firmware only records BSSID when the entry is new
 	 */
-	if (vif->type != NL80211_IFTYPE_STATION)
-		mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
-				   CONN_STATE_PORT_SECURE, true);
+	if (vif->type != NL80211_IFTYPE_STATION &&
+	    !mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
+				CONN_STATE_PORT_SECURE, true))
+		link->bmc_sta_added = true;
 	rcu_assign_pointer(dev->mt76.wcid[idx], &msta_link->wcid);
 
 	if (!mlink->wcid->offchannel)
@@ -441,8 +443,9 @@ static void mt7996_vif_link_destroy(struct mt7996_phy *phy,
 	if (!link_conf)
 		link_conf = &vif->bss_conf;
 
-	mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
-			   CONN_STATE_DISCONNECT, false);
+	if (link->bmc_sta_added)
+		mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
+				   CONN_STATE_DISCONNECT, false);
 	mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink, msta_link, false);
 	mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, false);
 
@@ -939,8 +942,9 @@ mt7996_vif_link_bss_add(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 
 	mt7996_mcu_add_bss_info(phy, vif, link_conf, &link->mt76,
 				&link->msta_link, true);
-	mt7996_mcu_add_sta(phy->dev, link_conf, NULL, link, NULL,
-			   CONN_STATE_PORT_SECURE, newly);
+	if (!mt7996_mcu_add_sta(phy->dev, link_conf, NULL, link, NULL,
+				CONN_STATE_PORT_SECURE, newly))
+		link->bmc_sta_added = true;
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 84edb905fe06..d30b4d689bac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -295,6 +295,7 @@ struct mt7996_vif_link {
 
 	u8 mld_idx;
 	u8 bmc_bssid[ETH_ALEN];
+	bool bmc_sta_added;
 	bool csa_bcn_uploaded;
 };
 
-- 
2.47.3

