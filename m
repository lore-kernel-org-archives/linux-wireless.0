Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170B938B12C
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 10:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784285770; cv=none; b=LgHHH6m7iUhBO+ORgfdzBjdHFtYkr3y++AYtHcPS2S5QNrgPDjOB7FP2V+x2GO1lhQRCsRkQjPXLHm/F1BzbtgprKU4L9XeJMCD3tSfiQu9Wu3irtKwu/8LZfvpC/PzS+Y+krP7PYnD7R7QrFuoAxeegGIUyXG/iAngDoziMHmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784285770; c=relaxed/simple;
	bh=lBe8rQlMZtGxtAWiz6v0Y25g27Z68UzmBj/9L3bt+5E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Wsx76/0ui0O5q1/mawaRc2PgZSlQpE4i6p9tiMaLCpERAU8J+PVuxSA1j6DgjFrS3bFfCD8Jr3UtCJD7xusuj7SrzIjcoKAAslGy8RT/WA+1poNLt10wMkS9ga0CmtoSdHfLSY37ukckr6JMea3/G3cejYz16C9edjhdFHklClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=M5vN/rBi; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M5vN/rBi"
X-UUID: 14f4252a81ce11f1b1788b6acf885367-20260717
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=pkNNPMc+4Y/lU1Tqxe5npoC2NL+iAxIPrmi/UsZfjSo=;
	b=M5vN/rBiIkC5EzRrLaCRvgmT1T96atFqks3vMFppCQfJ5HdBdHALV3fY7dxPRDKaFjha7SdKyktgj29MwpPrXrG3o+X8VkevSrgmi2tMQBAE/HY9VXXvoX11MKTx+hwxG68JYS/3zUqEvejwTWtXnw3ddqDV0UAIHJZCHCFbSps=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:972afbcf-7ead-45f5-a142-e31fd80286d2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:d5fd3c19-ab14-4403-9336-76696324c5a8,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 14f4252a81ce11f1b1788b6acf885367-20260717
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <shayne.chen@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1936401022; Fri, 17 Jul 2026 18:55:53 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 17 Jul 2026 18:55:52 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 17 Jul 2026 18:55:52 +0800
From: Shayne Chen <shayne.chen@mediatek.com>
To: Felix Fietkau <nbd@nbd.name>
CC: linux-wireless <linux-wireless@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Evelyn Tsai
	<evelyn.tsai@mediatek.com>, Money Wang <money.wang@mediatek.com>,
	linux-mediatek <linux-mediatek@lists.infradead.org>, Shayne Chen
	<shayne.chen@mediatek.com>, Rex Lu <rex.lu@mediatek.com>
Subject: [PATCH mt76] wifi: mt76: fix handling channel context with different bands in mt76_switch_vif_chanctx()
Date: Fri, 17 Jul 2026 18:54:58 +0800
Message-ID: <20260717105458.3005812-1-shayne.chen@mediatek.com>
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

When performing channel switches on different radios within a short
timeframe, channel contexts with different bands can be carried for
each struct ieee80211_vif_chanctx_switch.

Rework mt76_switch_vif_chanctx() to properly handle this scenario.

Fixes: 82334623af0c ("wifi: mt76: add chanctx functions for multi-channel phy support")
Co-developed-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 93 ++++++++++----------
 1 file changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 6edcb3b8f279..37894b78fd08 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -186,68 +186,71 @@ int mt76_switch_vif_chanctx(struct ieee80211_hw *hw,
 			    int n_vifs,
 			    enum ieee80211_chanctx_switch_mode mode)
 {
-	struct mt76_chanctx *old_ctx = (struct mt76_chanctx *)vifs->old_ctx->drv_priv;
-	struct mt76_chanctx *new_ctx = (struct mt76_chanctx *)vifs->new_ctx->drv_priv;
-	struct ieee80211_chanctx_conf *conf = vifs->new_ctx;
-	struct mt76_phy *old_phy = old_ctx->phy;
-	struct mt76_phy *phy = hw->priv;
+	struct ieee80211_vif_chanctx_switch *v;
+	struct mt76_chanctx *old_ctx, *new_ctx;
+	struct mt76_phy *old_phy, *phy = hw->priv;
 	struct mt76_dev *dev = phy->dev;
 	struct mt76_vif_link *mlink;
-	bool update_chan;
+	bool need_update[__MT_MAX_BAND] = {};
 	int i, ret = 0;
 
-	if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS)
-		phy = new_ctx->phy = dev->band_phys[conf->def.chan->band];
-	else
-		phy = new_ctx->phy;
-	if (!phy)
-		return -EINVAL;
-
-	update_chan = phy->chanctx != new_ctx;
-	if (update_chan) {
-		if (dev->scan.phy == phy)
-			mt76_abort_scan(dev);
-
-		cancel_delayed_work_sync(&phy->mac_work);
+	for (i = 0; i < n_vifs; i++) {
+		v = &vifs[i];
+		new_ctx = (struct mt76_chanctx *)v->new_ctx->drv_priv;
+		if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS)
+			phy = new_ctx->phy = dev->band_phys[v->new_ctx->def.chan->band];
+		else
+			phy = new_ctx->phy;
+
+		if (!phy)
+			return -EINVAL;
+
+		if (phy->chanctx != new_ctx) {
+			if (dev->scan.phy == phy)
+				mt76_abort_scan(dev);
+
+			cancel_delayed_work_sync(&phy->mac_work);
+			need_update[phy->band_idx] = true;
+		}
 	}
 
 	mutex_lock(&dev->mutex);
 
-	if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS &&
-	    phy != old_phy && old_phy->chanctx == old_ctx)
-		old_phy->chanctx = NULL;
+	for (i = 0; i < n_vifs; i++) {
+		v = &vifs[i];
+		old_ctx = (struct mt76_chanctx *)v->old_ctx->drv_priv;
+		old_phy = old_ctx->phy;
 
-	if (update_chan)
-		ret = mt76_phy_update_channel(phy, vifs->new_ctx);
+		new_ctx = (struct mt76_chanctx *)v->new_ctx->drv_priv;
+		phy = new_ctx->phy;
 
-	if (ret)
-		goto out;
+		if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS && old_phy->chanctx &&
+		    old_phy->chanctx == old_ctx && phy != old_phy)
+			old_phy->chanctx = NULL;
 
-	if (old_phy == phy)
-		goto skip_link_replace;
+		if (need_update[phy->band_idx]) {
+			ret = mt76_phy_update_channel(phy, v->new_ctx);
+			if (ret)
+				goto out;
 
-	for (i = 0; i < n_vifs; i++) {
-		mlink = mt76_vif_conf_link(dev, vifs[i].vif, vifs[i].link_conf);
+			need_update[phy->band_idx] = false;
+		}
+
+		mlink = mt76_vif_conf_link(dev, v->vif, v->link_conf);
 		if (!mlink)
 			continue;
 
-		dev->drv->vif_link_remove(old_phy, vifs[i].vif,
-					  vifs[i].link_conf, mlink);
+		if (old_phy != phy) {
+			dev->drv->vif_link_remove(old_phy, v->vif, v->link_conf,
+						  mlink);
 
-		ret = dev->drv->vif_link_add(phy, vifs[i].vif,
-					     vifs[i].link_conf, mlink);
-		if (ret)
-			goto out;
-
-	}
-
-skip_link_replace:
-	for (i = 0; i < n_vifs; i++) {
-		mlink = mt76_vif_conf_link(dev, vifs[i].vif, vifs[i].link_conf);
-		if (!mlink)
-			continue;
+			ret = dev->drv->vif_link_add(phy, v->vif, v->link_conf,
+						     mlink);
+			if (ret)
+				goto out;
+		}
 
-		mlink->ctx = vifs->new_ctx;
+		mlink->ctx = v->new_ctx;
 		if (mlink->beacon_mon_interval)
 			WRITE_ONCE(mlink->beacon_mon_last, jiffies);
 	}
-- 
2.51.0

