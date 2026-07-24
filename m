Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125F2931D7
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897303; cv=none; b=IpwE9dbYG1lu3wRuq7m8sIZalGLDBjsgT18Qe3SJqrz498F3ZcEM1aFj9/lzSN2b5YJCQ/KIHYcXm4910bDndxbBn0rtqVRvjBnKV3FH8Yeh1bMnHpFgRN3akWjz6VaQsxIe7qZUj8835e/R5YujTNJJx9oKIiMSH9gphmI+Nzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897303; c=relaxed/simple;
	bh=OueOFVAyx7c+HTSM/UTybiTe3mF/XGmCGvthTfNCCJk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPQRgZs/ZGFrSKWIUtALjdW0OQdTG7b0detQ8ulSCuDj8ejj/WFVf/m79WaWpa+P3DRsp/vvKInilhQ+W2faFNcXD7lan6+kRtHrfdUmtEl4NRSdpRMkTK3U5nISvx09ut6tkQSpvVxL5+3N6ORyAZECLPyEzMlZn4GoPo9Iyp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=umYZ8M30; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="umYZ8M30"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/hQ2o63xT1ZZ0GdtaInlOOv0ZuFO0INPEFWyppHD7NE=; b=umYZ8M30j1gP5aIBff0PFNUNFx
	A5nhcG6ypxKO4nt7i0HaJSkZsKjbZLcfmjhZtWvV8OPEdYDsDWVmYAdpylMaEFOa3whN7Q3Hatont
	iTBZFSAssaUwcxKCp+OmEz7M0TUI+BhG2QBMaGkEMDu4lUeJw9TwSltR0E9TgGc2rC0w=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK7-006LeO-17
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:19 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 22/29] wifi: mt76: fix stuck TX queues after SER with no active interfaces
Date: Fri, 24 Jul 2026 12:48:06 +0000
Message-ID: <20260724124813.3961474-22-nbd@nbd.name>
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

From: Chad Monroe <chad@monroe.io>

When a firmware watchdog triggers full SER recovery before any VAPs
are up, mac80211 skips drv_reconfig_complete() because open_count is
zero. This leaves the DRIVER queue stop reason set permanently,
blocking all TX when interfaces eventually start.

Signed-off-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index ebe1376ffc2c..350d4573ced2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1469,6 +1469,10 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
 
 	mutex_unlock(&dev->mt76.mutex);
 
+	ieee80211_wake_queues(mt76_hw(dev));
+	if (ext_phy)
+		ieee80211_wake_queues(ext_phy->hw);
+
 	ieee80211_restart_hw(mt76_hw(dev));
 	if (ext_phy)
 		ieee80211_restart_hw(ext_phy->hw);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 96589aea1548..544da01b0411 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2512,6 +2512,8 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	mutex_unlock(&dev->mt76.mutex);
 
+	ieee80211_wake_queues(mt76_hw(dev));
+
 	ieee80211_restart_hw(mt76_hw(dev));
 }
 
-- 
2.53.0

