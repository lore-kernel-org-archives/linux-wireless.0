Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD7C4772A6
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 13:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059592; cv=none; b=plqOkC4hANq/d6sGP6ABQJP9fQ+T50ZXI4KrpBy2gunK4tMO0vz8fyS8sGX7Xdn0bGoou2dq1TIsp8l7Lv1wSgL0UgCvyTxI77VFARMhaRnjiMwqHYGcmU5LzcozJxdneIV9W9qdfddG15m7fnHP8M211FPJ/4NmiuHrgJ42oWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059592; c=relaxed/simple;
	bh=cx636GLTuosHs/L6LtpUabmBliOkQM+/Sx4IdnwKv3c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCDRS2D9MM5FD31H6K+cuJz+7LTSDpXQYaQRnD4r44t1H+3glESHmHN6/BjeCYgMBYmV+qMhx9jp6PzV2R9oKzr0OQ30YeetcGhM4TMPC2iQXXJxmVqvA03bzw6eIEuDZGw+8oScso6ldovzrxjkkKTBoLoNsBd7rVPVks65Dkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=owap+7tB; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="owap+7tB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=N0O+poGUgVa3at+vehnvNmfCip4BQhiqRK/mLWWDQ/g=; b=owap+7tBL9bH8J2aB4hDkX2zCN
	EFrtBabT+st/pduO58abIs8gtbNk53Ea9SQS/KCe4SSCaazZE9xHLtVD8qsUOydTiT/Vc9hOjoFOt
	3SAz+mm03qyqFKZM2Oi16MIUL5T5b/RK0BffLbzVRUj/JIcYqoZDLKrKeth+ZBMuMp8Q=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wwJOd-002b0i-27
	for linux-wireless@vger.kernel.org;
	Tue, 18 Aug 2026 14:58:27 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 2/5] wifi: mt76: check the owner of a remain-on-channel request
Date: Tue, 18 Aug 2026 12:58:22 +0000
Message-ID: <20260818125825.395538-2-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818125825.395538-1-nbd@nbd.name>
References: <20260818125825.395538-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvif->roc_phy points to the phy of the request that started last for the
interface. That request can end, and the phy can start a request for a
different interface. The driver does not always clear the pointer.

Two callers trust the pointer:

- mt76_vif_cleanup() aborts the request on that phy when the driver removes
  the interface.
- mt76_cancel_remain_on_channel() aborts the request on that phy for the
  interface.

If the phy holds a request for a different interface, both callers abort the
wrong request. The request of the interface stays active. Its work then runs
after the driver removes the interface. The work tears the link down through
the freed bss_conf.

Compare phy->roc_vif with the interface in both callers before the abort.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 28ad7bcaffd4..1d2635672ac3 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -423,7 +423,7 @@ int mt76_cancel_remain_on_channel(struct ieee80211_hw *hw,
 	struct mt76_vif_data *mvif = mlink->mvif;
 	struct mt76_phy *phy = mvif->roc_phy;
 
-	if (!phy)
+	if (!phy || phy->roc_vif != vif)
 		return 0;
 
 	mt76_abort_roc(phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index abbe65cbcd89..adda8b92ebe9 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -2107,7 +2107,7 @@ void mt76_vif_cleanup(struct mt76_dev *dev, struct ieee80211_vif *vif)
 
 	rcu_assign_pointer(mvif->link[0], NULL);
 	mt76_abort_scan(dev);
-	if (mvif->roc_phy)
+	if (mvif->roc_phy && mvif->roc_phy->roc_vif == vif)
 		mt76_abort_roc(mvif->roc_phy);
 }
 EXPORT_SYMBOL_GPL(mt76_vif_cleanup);
-- 
2.53.0

