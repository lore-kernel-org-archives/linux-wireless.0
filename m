Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C9B2931CD
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897299; cv=none; b=nCvHZSvhaJswr/rls8dG0lBcpIPWwx6GvUVdrNZqiEIYXBW30+2waUnJ7f9NPdh+k3yHPKWO9YzOwn8IWt/W6evWCigrivoQVLkc7RYTImY0ABsKdKOvJhgUdWv6T2Cw0GJLvbXPRC7wRn/NLbEGnr9Q7c2P+jIn3UCeLcgBapM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897299; c=relaxed/simple;
	bh=mT6V3lktBT28OpUcDln55U+lKWsvukffDK8/hEEBgV8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BC1XJzZJBSeSwukcIxevGsjcTB5YIFaxkbaI2hjBMjVVqB/b+jgH8uQTuByRdlmHg9gVYH0VQ1tOrWzvHods3Yn48/u5fNFzTR0+o7LEcWhjqIbZzIl5qZl3E7dDlhQlUFoYkZeuJbszFwdEKQ+gQ/AQu822IKvaU2u5a3vgTzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=H17qnavy; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="H17qnavy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YPIHaI06n1mMIpUbMueRAynSb2oFhdaKB5+tPW04jXg=; b=H17qnavygJF3xiE2zPG+t4LwpN
	SQmxnm9SS1qJTaG/WFxzCDBM5UUUqG10jcKYN34A+K51qdMT2tit7sPG3DyVXB9nGmEKxbd1QzXxO
	IvK0nYyl+1uTMBAf+0PIVo9Oy/HUtHlvZo9dFUDGTlKVtJjzHzAZp7EfxE29XkxKOpBc=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK4-006LeO-0e
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 04/29] wifi: mt76: mt7915: unwind state on add_interface failure
Date: Fri, 24 Jul 2026 12:47:48 +0000
Message-ID: <20260724124813.3961474-4-nbd@nbd.name>
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

When mt76_wcid_alloc() fails, mt7915_add_interface() returned without
clearing the vif_mask/omac_mask bits it had already set, without removing
the firmware dev info added earlier, and without clearing a monitor_vif
pointer to the vif mac80211 is about to free. mac80211 does not call
remove_interface() for a failed add, so the indices and firmware dev
entry leaked permanently and testmode could dereference the stale
monitor_vif. Add a proper error unwind.

Fixes: b619e01380ee ("mt76: fix MBSS index condition in DBDC mode")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 4ed3d808654f..d2130226de64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -249,7 +249,7 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
 	if (idx < 0) {
 		ret = -ENOSPC;
-		goto out;
+		goto err;
 	}
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
@@ -277,7 +277,17 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_PORT_SECURE, true);
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 
+	mutex_unlock(&dev->mt76.mutex);
+
+	return 0;
+
+err:
+	dev->mt76.vif_mask &= ~BIT_ULL(mvif->mt76.idx);
+	phy->omac_mask &= ~BIT_ULL(mvif->mt76.omac_idx);
+	mt7915_mcu_add_dev_info(phy, vif, false);
 out:
+	if (phy->monitor_vif == vif)
+		phy->monitor_vif = NULL;
 	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
-- 
2.53.0

