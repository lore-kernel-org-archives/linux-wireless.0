Received: from rere.qmqm.pl (rere.qmqm.pl [91.227.64.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828A92DFF3F
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 19:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.227.64.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791054970; cv=none; b=J8FZVwPWfHByI9VNTVSwbmYq9FG7CkcKyOphCLAs1yy0H8NNrw4lwPTTEGZzpvhUo3mNMhQryupIzr9dHb6WNmtcVw4sEM2gbGo2CW1g0XKCwisT5yEzEbSgboOT92VnuuagZ6LLf5PKvvTCTjlSabwfaASkQVVfKo4iJeIajnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791054970; c=relaxed/simple;
	bh=Px9//7W6clULTpRQ7xToIbekfQMAoyzUz2aYL0l/DZ4=;
	h=Date:Message-ID:Subject:MIME-Version:Content-Type:From:To:Cc; b=OOJmcTTnVVR9rdozaLaKTyd5Fr4tfyRO83yWJsgrNmyzYIuMQuoFk6sOw5wDUUddCQWIRXpVOS9s83PQ91FpG8jvJiyluPRV5ItAa6KG0LxMoXfh0vDm6cZsvdgLPtqWfgSKmHzBSkllAgCLWpJfOp7tiSvfIi/0duruqRPeW50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rere.qmqm.pl; spf=pass smtp.mailfrom=rere.qmqm.pl; dkim=pass (2048-bit key) header.d=rere.qmqm.pl header.i=@rere.qmqm.pl header.b=WIXQs3df; arc=none smtp.client-ip=91.227.64.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rere.qmqm.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rere.qmqm.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rere.qmqm.pl header.i=@rere.qmqm.pl header.b="WIXQs3df"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
	t=1791054408; bh=Px9//7W6clULTpRQ7xToIbekfQMAoyzUz2aYL0l/DZ4=;
	h=Date:Subject:From:To:Cc:From;
	b=WIXQs3dfPYDCe93v/dNWbbvxdaYjl4HE0HGjRR9+aUw4OlsYxhUVTyC/frrBNBcAA
	 sIP13i/dHtrRIl7GKMcuD5Kbv3I5Uc4lJVj0R4E+3Ye6pRn5/rsdonbj7PAKNt9p1g
	 sy5BMRw7EmhQTr7EM79qWxqSJoFzpOJXaGO96lnk0TBTCCeDJEK/1yiEtmqKjGfChb
	 FPBW6OTpWNpoVQYLvUC8RCCMHseaFzXw0jdwkGrfw/+CpAXG026MD91hvJdvE61x4C
	 fPcNLvYoNzOGHRdJ/JrseTQDq2Jcoh8zQw79U/5ownvjKCtmKiePLmkMEApnqbYIFt
	 cR7bEp6wgvtJA==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 1.4.3 at mail
Received: from remote.user (localhost [127.0.0.1])
	by rere.qmqm.pl (Postfix) with UTF8SMTPSA id 4hxw9z4yFSz2w;
	Sat, 03 Oct 2026 21:06:47 +0200 (CEST)
Date: Sat, 03 Oct 2026 21:06:46 +0200
Message-ID: <6e918a7119e4adb8ecd0629a28ba4a28c7efae30.1791054303.git.mirq-linux@rere.qmqm.pl>
Subject: [PATCH] wifi: mt76: mt7925: deduplicate MLD support code in
 mt7925_mac_link_sta_add
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From:	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
To:	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc:	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org

Simplify mt7925_mac_link_sta_add() logic branching where
mt7925_mcu_add_bss_info_sta() and mt7925_mcu_sta_update()
are called with identical arguments.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 36 ++++++-------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 9f080da13341..18e46bc587f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -897,6 +897,7 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 	struct mt792x_bss_conf *mconf;
 	u8 link_id = link_sta->link_id;
 	bool wcid_published = false;
+	bool is_secondary_link_sta;
 	struct mt792x_sta *msta;
 	struct mt76_wcid *wcid;
 	bool pm_woken = false;
@@ -941,39 +942,28 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 
 	link_conf = mt792x_vif_to_bss_conf(vif, link_id);
+	is_secondary_link_sta = ieee80211_vif_is_mld(vif) && link_sta != mlink->pri_link;
 
 	/* should update bss info before STA add */
 	if (vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls) {
 		struct mt792x_link_sta *mlink_bc;
 
 		mlink_bc = mt792x_sta_to_link(&mvif->sta, mconf->link_id);
-
-		if (ieee80211_vif_is_mld(vif)) {
-			ret = mt7925_mcu_add_bss_info_sta(&dev->phy, mconf->mt76.ctx,
-							  link_conf, link_sta,
-							  mlink_bc->wcid.idx, mlink->wcid.idx,
-							  link_sta != mlink->pri_link);
-			if (ret)
-				goto out_pm;
-		} else {
-			ret = mt7925_mcu_add_bss_info_sta(&dev->phy, mconf->mt76.ctx,
-							  link_conf, link_sta,
-							  mlink_bc->wcid.idx, mlink->wcid.idx,
-							  false);
-			if (ret)
-				goto out_pm;
-		}
+		ret = mt7925_mcu_add_bss_info_sta(&dev->phy, mconf->mt76.ctx,
+						  link_conf, link_sta,
+						  mlink_bc->wcid.idx, mlink->wcid.idx,
+						  is_secondary_link_sta);
+		if (ret)
+			goto out_pm;
 	}
 
-	if (ieee80211_vif_is_mld(vif) &&
-	    link_sta == mlink->pri_link) {
+	if (!is_secondary_link_sta) {
 		ret = mt7925_mcu_sta_update(dev, link_sta, vif,
 					    mlink, true,
 					    MT76_STA_INFO_STATE_NONE);
 		if (ret)
 			goto out_pm;
-	} else if (ieee80211_vif_is_mld(vif) &&
-		   link_sta != mlink->pri_link) {
+	} else {
 		struct mt792x_link_sta *pri_mlink;
 		struct mt76_wcid *pri_wcid;
 
@@ -1000,12 +990,6 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 					    MT76_STA_INFO_STATE_ASSOC);
 		if (ret)
 			goto out_pm;
-	} else {
-		ret = mt7925_mcu_sta_update(dev, link_sta, vif,
-					    mlink, true,
-					    MT76_STA_INFO_STATE_NONE);
-		if (ret)
-			goto out_pm;
 	}
 
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
-- 
2.47.3

