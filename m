Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53283BED42
	for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2026 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782722156; cv=none; b=FMpdzfX8mePzTQ/uwdsHW2CRgvjOcfSkvuhPDfdBdTaCMAlEioImXuYbpElyQIK9azCLBSyaRfTNd9qYRq0qt7VXHmvmmTReZaE1E13fzPJxVGAnlrSJmitKGNhWlJspEDr5Uu4sLI/vc3/3NO0bP+/xCnpLzeHx0xQaUJatUxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782722156; c=relaxed/simple;
	bh=1cTn3ObnuY88x2abiTIHtU9V8hEPIUPw8HYl0HjasK4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GyXjHoc80wifT1juQNqVaSOACpsAVFs9XiND3+hmKYYA8eB4th2Vcb/qVKTZ9x3pUOqRSfZsAK/RpWO4V6OFgBW9UyIUKdFjqdGKaGnVrTdBq3W/gMZrrhLNH5purrNH0wKJDf8xp7LKVFaPxSAmRb8ObF3xDxk3k/HdhL/ilMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=tVjQnbd3; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tVjQnbd3"
X-UUID: 863ffb9c739511f1b1788b6acf885367-20260629
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=8StqZ2ZvnvjvPuHl88BWmQ+kB4Rag7l2q/B8b2J1o9k=;
	b=tVjQnbd3fGILrcnhLdE/9NDaJCMNqmHosla4otX1Ch1wDBp0T7uqJewHXAhKSIyr1qrFetxIpu8zKKNUvjTXwOgp2DcsxR1h5oUQF4BFE+YPDKo4Dutg85Q7LphuwpvkaLt9HfxbQ9UDCp6Kd8BPORsdS1gYZBTgNFUbQhX1ZpE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:ba3d6ec6-47af-4347-a1c0-31cc85d85229,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:b11fecbb-16fe-4666-9091-b0c333957a8c,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 863ffb9c739511f1b1788b6acf885367-20260629
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1402058862; Mon, 29 Jun 2026 16:35:46 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 29 Jun 2026 16:35:45 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 29 Jun 2026 16:35:45 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>, Charlie-cy Wu
	<charlie-cy.wu@mediatek.corp-partner.google.com>
Subject: [PATCH] wifi: mt76: mt7921: refactor regd update to fix recursive mutex deadlock
Date: Mon, 29 Jun 2026 16:35:43 +0800
Message-ID: <20260629083543.153564-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Charlie-cy Wu <charlie-cy.wu@mediatek.corp-partner.google.com>

Split mt7921_mcu_regd_update() into two functions to prevent recursive
mutex acquisition. Introduce __mt7921_mcu_regd_update() as the internal
implementation that assumes the mutex is already held by the caller,
while mt7921_mcu_regd_update() remains as the external interface that
handles mutex acquisition and release.

This fixes a deadlock issue when mt7921_regd_set_6ghz_power_type() is
called with the device mutex already held. Without this change, calling
mt7921_mcu_regd_update() would attempt to acquire the same mutex again,
causing a recursive lock deadlock.

The __mt7921_mcu_regd_update() function can be safely called when the
caller has already acquired the device mutex, avoiding the deadlock
while maintaining proper synchronization for regulatory domain updates.

Fixes: dc2608cf5224 ("wifi: mt76: mt7921: refactor regulatory notifier flow")
Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt7921/regd.c  | 30 ++++++++++++-------
 .../net/wireless/mediatek/mt76/mt7921/regd.h  |  2 ++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index af5d16055396..b3f29ebf4015 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -808,7 +808,7 @@ mt7921_regd_set_6ghz_power_type(struct ieee80211_vif *vif, bool is_add)
 
 out:
 	if (vif->bss_conf.chanreq.oper.chan->band == NL80211_BAND_6GHZ)
-		mt7921_mcu_regd_update(dev, dev->mt76.alpha2, dev->country_ie_env);
+		__mt7921_mcu_regd_update(dev, dev->mt76.alpha2, dev->country_ie_env);
 }
 
 int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c b/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
index f122e418d825..f923af1440d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
@@ -71,36 +71,44 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 	}
 }
 
-int mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
-			   enum environment_cap country_ie_env)
+/* Internal version that assumes mutex is already held by caller */
+int __mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
+			     enum environment_cap country_ie_env)
 {
 	struct mt76_dev *mdev = &dev->mt76;
 	struct ieee80211_hw *hw = mdev->hw;
 	struct wiphy *wiphy = hw->wiphy;
 	int ret = 0;
 
-	dev->regd_in_progress = true;
-
-	mt792x_mutex_acquire(dev);
 	if (!dev->regd_change)
-		goto err;
+		return 0;
 
 	ret = mt7921_mcu_set_clc(dev, alpha2, country_ie_env);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	mt7921_regd_channel_update(wiphy, dev);
 
 	ret = mt76_connac_mcu_set_channel_domain(hw->priv);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	ret = mt7921_set_tx_sar_pwr(hw, NULL);
-	if (ret < 0)
-		goto err;
 
-err:
+	return ret;
+}
+
+int mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
+			   enum environment_cap country_ie_env)
+{
+	int ret = 0;
+
+	dev->regd_in_progress = true;
+
+	mt792x_mutex_acquire(dev);
+	ret = __mt7921_mcu_regd_update(dev, alpha2, country_ie_env);
 	mt792x_mutex_release(dev);
+
 	dev->regd_change = false;
 	dev->regd_in_progress = false;
 	wake_up(&dev->wait);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regd.h b/drivers/net/wireless/mediatek/mt76/mt7921/regd.h
index 571f31629e9e..5b24d0902c36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regd.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regd.h
@@ -10,6 +10,8 @@ struct regulatory_request;
 
 int mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
 			   enum environment_cap country_ie_env);
+int __mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
+			     enum environment_cap country_ie_env);
 void mt7921_regd_notifier(struct wiphy *wiphy,
 			  struct regulatory_request *request);
 bool mt7921_regd_clc_supported(struct mt792x_dev *dev);
-- 
2.45.2

