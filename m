Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=iU01fQjqnhqvSnlh0+K+xs9VlmKVPhJWOlneAPeWbnUtLJYRHLgAb6B6xCg2RS1YrDc2
	 LaG8mZoMFaf7dB6eLZ9t8vELITTgNaqpLSK8DNw9MZH58B8jDLK6kIm0XttpFH4K2Ft4x
	 XNaDi9iWtTECTq7r8lml6Mwz0Joxx3JEeU0zkDOSB/geG6L+IaB9iP5WElhf+67Ewbh4o
	 Goh/c+qHjJAAaH3OHpu07Mtp75JJSFpHT4xQ/34YLvXXxOgkwExPcq0x5ui5WhqFbQyTe
	 RPwTGg5qUv1CNHLoXs8YjIzKXEIXXo2Xg/y3KbqF4LPdi2woipJRvadMzcbSJR6q/7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ait+ZkrdM8EZKVehSFGvtBE5zI/jD0xy8QpKtHbi9WY=;
	b=NmnvzhgRAV+TfZXcydXDOsk7G3DzqEKIgA8C9dxaQKbueYiVRPID2STUbyJ1ZfFLY9Mq
	 d3fl8bu0RLj9H7ShBzZUDSEpNDwFa5IpxAwR1bzc+LI8vhNdzh1aY+c6281vTFYfiWusm
	 uPycT0QZqdHWyiN0ZaqT/Wy7JdQYbwgc//Uv+RcZZQ/1p/MEr3+P9pduXCtg5SVCdqlk/
	 bPMsEMlSl0n6wMOX+6o33xwpjWJlpRmSUbc+lfE00PDVPsyHpLF5yQvdGXvWfBt2ipZNI
	 vJKp0AaA6BlrAWFh8DVRe9sFKiVUCWlt5w0OpawsFrzvPuRF3xn8x0QMEC0kwCNyVbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=hZjqyE02;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397ED60A260E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 397ED60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=hZjqyE02
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ait+ZkrdM8EZKVehSFGvtBE5zI/jD0xy8QpKtHbi9WY=; b=hZjqyE02qWnxIgbZKOqCFMpGNA
	eHVdIP42SIrirdCu7gtdmiJNnj9X2l4XOC1snMvs3sp7rX6Rp85M4ds9EVjDz8oLwOLBmf02xAMCc
	aJrfriqaP6jq1ovMgjnhrhkjqxUtdxkHLgCizowf+oJ8DAhlzk9AnNQjxGfEOd2Ds8EU=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hN-00C8Bw-0X
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:09 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 18/25] wifi: mt76: read the chanctx of a link once
Date: Wed, 28 Oct 2026 13:23:56 +0100
Message-ID: <20261028122403.796394-18-nbd@nbd.name>
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

mt76_vif_link_phy() and mt76_vif_phy() test mlink->ctx and then load it
again to reach the mt76_chanctx. mt7996_tx(), mt7996_mac_sta_poll() from
the TX free path, mt76_rx_beacon(), the beacon monitor and
mt76_offchannel_notify() call mt76_vif_link_phy() without dev->mutex,
while mt76_unassign_vif_chanctx() can set mlink->ctx to NULL in between.
The second load can then return NULL.

Load mlink->ctx once with acquire semantics, and publish it with
release semantics in the chanctx functions, so that a reader that sees
a chanctx also sees the link state written before it. Let
mt76_vif_phy() use mt76_vif_link_phy() instead of its own copy.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c  |  6 +++---
 drivers/net/wireless/mediatek/mt76/mac80211.c |  7 +------
 drivers/net/wireless/mediatek/mt76/mt76.h     | 15 +++++++++++++--
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 39a5dca4ca7d..a44773b9a49e 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -137,7 +137,7 @@ int mt76_assign_vif_chanctx(struct ieee80211_hw *hw,
 		mlink_alloc = true;
 	}
 
-	mlink->ctx = conf;
+	mt76_vif_link_ctx_set(mlink, conf);
 	ret = dev->drv->vif_link_add(phy, vif, link_conf, mlink);
 	if (ret) {
 		if (mlink_alloc)
@@ -179,7 +179,7 @@ void mt76_unassign_vif_chanctx(struct ieee80211_hw *hw,
 		goto out;
 
 	dev->drv->vif_link_remove(phy, vif, link_conf, mlink);
-	mlink->ctx = NULL;
+	mt76_vif_link_ctx_set(mlink, NULL);
 out:
 	mutex_unlock(&dev->mutex);
 }
@@ -257,7 +257,7 @@ int mt76_switch_vif_chanctx(struct ieee80211_hw *hw,
 				goto out;
 		}
 
-		mlink->ctx = v->new_ctx;
+		mt76_vif_link_ctx_set(mlink, v->new_ctx);
 		if (mlink->beacon_mon_interval)
 			WRITE_ONCE(mlink->beacon_mon_last, jiffies);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 89f289ac57a9..b2702c9079d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -876,16 +876,11 @@ struct mt76_phy *mt76_vif_phy(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
 	struct mt76_vif_link *mlink = (struct mt76_vif_link *)vif->drv_priv;
-	struct mt76_chanctx *ctx;
 
 	if (!hw->wiphy->n_radio)
 		return hw->priv;
 
-	if (!mlink->ctx)
-		return NULL;
-
-	ctx = (struct mt76_chanctx *)mlink->ctx->drv_priv;
-	return ctx->phy;
+	return mt76_vif_link_phy(mlink);
 }
 EXPORT_SYMBOL_GPL(mt76_vif_phy);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9e851dea71d9..42a1f84c5ca9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -2167,15 +2167,26 @@ mt76_vif_conf_link(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	return mt76_dereference(mvif->link[link_conf->link_id], dev);
 }
 
+static inline void
+mt76_vif_link_ctx_set(struct mt76_vif_link *mlink,
+		      struct ieee80211_chanctx_conf *conf)
+{
+	/* pairs with smp_load_acquire() in mt76_vif_link_phy() */
+	smp_store_release(&mlink->ctx, conf);
+}
+
 static inline struct mt76_phy *
 mt76_vif_link_phy(struct mt76_vif_link *mlink)
 {
+	struct ieee80211_chanctx_conf *conf;
 	struct mt76_chanctx *ctx;
 
-	if (!mlink->ctx)
+	/* pairs with smp_store_release() in mt76_vif_link_ctx_set() */
+	conf = smp_load_acquire(&mlink->ctx);
+	if (!conf)
 		return NULL;
 
-	ctx = (struct mt76_chanctx *)mlink->ctx->drv_priv;
+	ctx = (struct mt76_chanctx *)conf->drv_priv;
 
 	return ctx->phy;
 }
-- 
2.47.3

