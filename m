Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9654334A3
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897304; cv=none; b=L7efuCviVMc3+gm4iqTfNzTHYpjn5Ytb57vJwB5hJPfZU7yvzxc4UwntHHihb/MHO0WfKB4bh3jnlxTUJBN5qmuSvj7ZApevaUMsZhnMov+ZTe5NpUVyyoZ0HQWPPm9SF8GivoCR+MgNe0m79gXRqdBCg55KlpZw+CbTw4UNvD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897304; c=relaxed/simple;
	bh=IBvK2bFrlO7fmfgeELVSMjFHUbQxH3GsgYqFeRyZzfI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or3AsAzCJL8Dhp9USPIMHR0ol+Vnadj9oQQ5Rt5BJlUpIOERqL011x9x44Bn9L8GjY3ECRg6qVuqcaYGRGBJ4j1GZUCcxhh3ihxZiwZ5rInvsFim+1IC1c1UCRSQuJ3qBDpH1Hg5B3C6L5kh1DtMbh6P14nBZ9n5zUdkpnjfrkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=uJohurpW; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="uJohurpW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UlveJyhsGRYeod4TF8/WaGSPLi0Be2HdqMFpwkCsZHA=; b=uJohurpWYuk8T8hp/8adREydXS
	QZmHSETGZ1HLnkeSxawuwB3NjbBkXhgUFQxepCH+Y09OnbEpT9IFAv3EqpebYou127Ohx+ntlXlF9
	1et8TmyUyLuzBXvkWaV0C22yhX90THSQMRD5zVXT/pkTmnaK2fa0KVVKKyheP1aKdSPs=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK8-006LeO-0z
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 25/29] wifi: mt76: mt7996: free vif links after clearing wcid entries on full reset
Date: Fri, 24 Jul 2026 12:48:09 +0000
Message-ID: <20260724124813.3961474-25-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_reset_vif_iter() queues non-default vif links for kfree_rcu
while dev->wcid[] still holds pointers to the wcid embedded in each
freed link; mt76_reset_device() then dereferences those entries and
runs mt76_wcid_cleanup() on them. If a grace period elapses in between,
the cleanup operates on freed memory.

Run mt76_reset_device() first, so the wcid entries are cleaned up and
cleared while the links are still valid.

Fixes: ace5d3b6b49e ("wifi: mt76: mt7996: improve hardware restart reliability")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 544da01b0411..ce8c5a5ea8cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2485,10 +2485,10 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 		phy->omac_mask = 0;
 
 	ieee80211_iterate_stations_atomic(hw, mt7996_mac_reset_sta_iter, dev);
+	mt76_reset_device(&dev->mt76);
 	ieee80211_iterate_active_interfaces_atomic(hw,
 						   IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER,
 						   mt7996_mac_reset_vif_iter, dev);
-	mt76_reset_device(&dev->mt76);
 
 	INIT_LIST_HEAD(&dev->sta_rc_list);
 	INIT_LIST_HEAD(&dev->twt_list);
-- 
2.53.0

