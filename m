Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228CE486E58
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372280; cv=none; b=KeAvpacfO871eo4rnmR+SmqWpecBfP1KufSs8JmivokcsYYrNZqXJvgIMMaQkt5ulyKJp5HRDSMLBSbGhcpuQg9ePeMI3QWWSKv5uCYhWRj3Qd+gfbtoF/DXGMXi3HexxmCml9zM1x+NknO+sxHOKSDxOfdq+NPAbXrVYshXN7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372280; c=relaxed/simple;
	bh=0bRrzvSHPpFDsiMqBXB3CH5FNEnovO33jwTO4wcyMa4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmTc9o/DxSG7Mlo5pyxgHFA2Cffy9WNBPrtHfbzDZobUN2TIrw5kHfQXi+utxIwy2yZIee3IbEFAcRvlcR2Xj8yLLawoT0xDFZAXO2y/CktOfP3bbc+qa+w5dvEd1sXcMLQXsnys4cjzLfN9uGEndbcYkmqABau5tFQ1JEP9sUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=e/PRrwda; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="e/PRrwda"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mSRCNut1e4ChycwBzwfFaL5iWybBhbeHRIO1lu0TwPc=; b=e/PRrwdaYE3CfgbneNKnS69dcZ
	lp9FIDtsqX2zMhUZ/0u5FEZafolw38LJTqbbcBAYJnXyo53h6bPU6xukAUxFX+CIfen4yymjEi++0
	7kx7GJsrNI833fTJvrTxI7HdjL8PPuYgiz+6Z3edg1IvsffJtrJBg/GUdxb/wQz2IfR8=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl1-00HY5A-0I
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:23 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 2/9] wifi: mt76: report an aborted scan or ROC to mac80211 during a reset
Date: Wed,  7 Oct 2026 13:24:12 +0200
Message-ID: <20261007112419.1277594-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007112419.1277594-1-nbd@nbd.name>
References: <20261007112419.1277594-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_full_reset() and the L1 SER branch of mt7996_mac_reset_work()
abort a running scan and remain on channel. mt76_scan_complete() and
mt76_roc_complete() then skip ieee80211_scan_completed() and
ieee80211_remain_on_channel_expired() while MT76_MCU_RESET is set.
mac80211 clears a hardware scan only from the completion. After an L1
SER recovery, which does not restart the hardware, every later scan on
the wiphy is then refused, and a remain on channel stays pending until
userspace cancels it. After a full reset, ieee80211_restart_work()
warns:

  WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
       "%s called with hardware scan in progress\n", __func__);

Report an aborted scan to mac80211 in a reset as well, and an aborted
remain on channel unless a hardware restart follows. On a restart,
ieee80211_reconfig_roc() restarts a remain on channel that had not
begun and ends one that had. Since the scan is reported as aborted,
mac80211 does not continue it on the next band during the reset.

Fixes: b36d55610215 ("wifi: mt76: abort scan/roc on hw restart")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 +-
 drivers/net/wireless/mediatek/mt76/scan.c    | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index ce1824da7563..243d252e7644 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -336,7 +336,7 @@ void mt76_roc_complete(struct mt76_phy *phy)
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
 	phy->roc_link = NULL;
-	if (!test_bit(MT76_MCU_RESET, &dev->phy.state))
+	if (!test_bit(MT76_RESTART, &dev->phy.state))
 		ieee80211_remain_on_channel_expired(phy->hw);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 7bf9b7d4a8d7..4a5cdb4efc61 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -39,8 +39,7 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
-	if (!test_bit(MT76_MCU_RESET, &dev->phy.state))
-		ieee80211_scan_completed(phy->hw, &info);
+	ieee80211_scan_completed(phy->hw, &info);
 }
 
 void mt76_abort_scan(struct mt76_dev *dev)
-- 
2.47.3

