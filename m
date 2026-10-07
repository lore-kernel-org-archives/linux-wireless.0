Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4342F48D864
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372283; cv=none; b=h5EaGWHGxMW0pSbLoT89EpiZjmkEEp87/3+1PulWsm6XhnrOp9hsxXnRXooq7pm8vuGMvNmaBAC6unO0wUplZt03bAiCSVOSNpfvOo4Y8FqA+UXSgr4fuJDqWNxTphpJVZXko6AYVhiogf3FihMWzuAfPlNp1qaytLclAubn54Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372283; c=relaxed/simple;
	bh=Io8sY+BbO2m8gjOGwcgwpAMaP+CNYPeFKEsrNd1lRXM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fu4HAbyYLd1EF03mDe8eGiUkLNfB8FamqyzU+j8sD7p5JrtJj6LWF8/tyasuGhN+7fr8SiIyO3h2pVBLnTfUN63CDox6d0XIWzAzvGHc+crf+8LD2Xg5kwOeWxhOoUQYzQZ6GNafPbXz2/jZ/VQl+XCliDFPXPH8L60QlbooNF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=aShKXczT; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="aShKXczT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DNBlJz+CyqF+0kV/RRCHsEy8QGXnpRKUYoxbcezvH+U=; b=aShKXczTQwgK6jB2U67NOy3XLQ
	qoK4dup0IypGShp4oAGeWlwDZNL2QVDw+WlyWRmZLoqLrT1km7WUpfKGVtuEAH+twWftYzlYBEDtz
	kopTg9SRAxoanAb1YMg9XIIlmG9SIKB34WRTk613MTsFehTtlNEeKmdryg2lQe+hkxQk=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl2-00HY5A-0p
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:24 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 9/9] wifi: mt76: keep beacons from queueing the scan work during an abort
Date: Wed,  7 Oct 2026 13:24:19 +0200
Message-ID: <20261007112419.1277594-9-nbd@nbd.name>
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

mt76_abort_scan() clears beacon_wait and then cancels the scan work. A
scan work that runs at that time can set beacon_wait again when it
moves to a NO_IR or radar channel. After the cancel, a beacon on that
channel makes mt76_scan_rx_beacon() queue the work again. The work then
runs without dev->mutex while mt76_scan_phy_complete() removes the scan
link, so mt76_scan_send_probe() can use the removed link. Reachable via
mac80211 cancel_hw_scan, chanctx changes, interface removal and the
mt7996 reset work.

Disable the scan works instead of cancelling them, so that no beacon
can queue them until the abort completes the scan. Enable them again
with dev->mutex held, so that a scan that mt76_hw_scan() starts after
the abort can always queue its work.

Fixes: 360552c8592d ("wifi: mt76: support upgrading passive scans to active")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index ada7a8984971..3271a2fa100d 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -76,14 +76,17 @@ void mt76_abort_scan(struct mt76_dev *dev)
 		phy->scan.beacon_wait = false;
 		spin_unlock_bh(&dev->scan_lock);
 
-		cancel_delayed_work_sync(&phy->scan_work);
+		disable_delayed_work_sync(&phy->scan_work);
 	}
 
 	mutex_lock(&dev->mutex);
 	for (i = 0; i < ARRAY_SIZE(dev->phys); i++) {
 		phy = dev->phys[i];
-		if (phy)
-			mt76_scan_phy_complete(phy, true);
+		if (!phy)
+			continue;
+
+		mt76_scan_phy_complete(phy, true);
+		enable_delayed_work(&phy->scan_work);
 	}
 	mutex_unlock(&dev->mutex);
 }
-- 
2.47.3

