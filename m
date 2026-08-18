Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E67022B8DF
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 13:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059588; cv=none; b=rGXB6UkQdG3Lg50kGqHbwAz0zU4qUsK1kT94O52t647pi4uo5ybfPXuX2RmtGXFeu5fjd8k/EwYnaoNZ1gSAxmMPP+ctWFV6sJe1IzLmtfHJRXXuFpBuAWWJzfIB2cnm3NWcY+E6ZQW8wtC7R/Igg9CXIX/h8F7jcesZdERw7us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059588; c=relaxed/simple;
	bh=bBT2e35RmpHECNNLH53GHuhgt5IN8LI4dN5Mgz89pQs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qMnu02neFype3O2avAXueoU7adJI42FCR5uFKNqJB0CuPYCqMOBfdS8RlcHwiTXJTBK90qbOe2BT11o27NjuCdXU4zz1rOmOKGtpDlUKk4jWBQLfvK4BCiRylGCddy4ARLiN/HgSeJ7FTvTiQVt2b1DAZxfjJ0HotxnqRWrjb28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Zn+Gw4Zj; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Zn+Gw4Zj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KI80MJVlKvH+ozdY0Vn7dAtuUZ067ZaIH8xdKkROGpM=; b=Zn+Gw4Zjn77lqFf66D8Z3KtdYw
	owQtJYVGf+kYCNHZog9LpWdk71aUjqFlFxKwoF3B0oZDbKDfFAChXtxTM4wZQpJY4yJemI8BM4fLr
	dpGqjLnp0D2LfTc9oVjmicRIOYTllMtjKTha0i6dAGaj0KoNXUOztdEVsLO0PeoVEVHs=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wwJOd-002b0i-1W
	for linux-wireless@vger.kernel.org;
	Tue, 18 Aug 2026 14:58:27 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 1/5] wifi: mt76: mt7996: program a link again if the driver holds it
Date: Tue, 18 Aug 2026 12:58:21 +0000
Message-ID: <20260818125825.395538-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The firmware needs the driver to remove active links from the BSSINFO table
when it destroys the interface. A link therefore stays registered from its
first chanctx assignment until the interface goes away. If the driver holds
the link already, a second add does nothing.

mac80211 gives a non-AP MLD a new address each time it sets a link up. A link
that comes back after a failed attempt thus carries an address that the
hardware does not know, on a BSS that the driver never programs again. The
station then authenticates from an address that nothing answers. The failure
repeats until the driver tears the interface down for good.

Program the address and the BSS again. This is the pair that the initial add
sets up. For a station it does what mt7996_mcu_mld_link_oper() does for an AP.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index e218856b0c45..d17d1dbb2038 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -310,7 +310,14 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		if (vif->type == NL80211_IFTYPE_AP)
 			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
 							true);
-		return 0;
+
+		/* update the link address */
+		ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
+		if (ret)
+			return ret;
+
+		return mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink,
+					       msta_link, true);
 	}
 
 	mlink->idx = __ffs64(~dev->mt76.vif_mask);
-- 
2.53.0

