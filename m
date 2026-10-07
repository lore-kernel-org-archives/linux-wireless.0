Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B53488208
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372279; cv=none; b=LkHXxSLRThcCR4LnSacZNoCNf9kZLIwXewnabDtXH9Hx9m1/EHLrNaqQ3kDl8n5ZbL5L5XLH3i1zU2AMWG59sV7cPhpX1oPuIg0Hs24dH3/Lx/SesVFCezremwb5MTsl8D73S/7RMTjlvmmFeqNX2HSRBlhcnqVcfggFAFfube8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372279; c=relaxed/simple;
	bh=r4CaGEVGU7twVmC30w+GpPaEMD2XFWEdQome4ux6vlc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YMuIAb39Jpzb6ve2Rwu4gzvTBLWYaP4twqZLq6J+Lv+gxVJSh97xMlpo5KbCqUkm2hAmsvrHAXMwPtSCZCNJ/23iyx1xWw6uWKHdwJx9T8LakNCOiaBHPQdRo2S7QFyTMfj7ZOUmuUX2INBN/RHaGX3dGop0n7ZLaivg4kG7x+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=HgdED0UF; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="HgdED0UF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tpyGswOh1p5nntFOTJ4QbdusOr9ApcfnAX9QVOeZ/XQ=; b=HgdED0UFN65Us77IZYgWJV81zz
	leMz3202t9/P7jR7e4ni88hwa1pvUkDywIgHNrqelv9oDGRj88ZgKw7O4c752Gml9IjgFDlMQnVIN
	oggqiVkqHfoASO4NYn0Z54lP4gT3d5FE8Al8N6nlmRZfRgVI2cHby+o22arlijGPeNZw=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl0-00HY5A-2v
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:22 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 1/9] wifi: mt76: mt7996: refuse scan and ROC until the hardware restart is done
Date: Wed,  7 Oct 2026 13:24:11 +0200
Message-ID: <20261007112419.1277594-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_restart() clears MT76_MCU_RESET before it loads the firmware
again, and mac80211 adds the interfaces back only later, in
ieee80211_reconfig() after ieee80211_restart_hw(). A scan or remain on
channel that reaches mt76_hw_scan() or mt76_remain_on_channel() in
between, for example a request that waited for dev->mutex during the
reset, runs on a device that has no interfaces configured.

Mark a full reset with MT76_RESTART and refuse a scan or remain on
channel while it is set. Clear the flag in .start: ieee80211_reconfig()
adds the interfaces back before it releases the wiphy lock, so no
request runs in between. .reconfig_complete is not suitable, because
mac80211 skips it when no interface is open, and the flag would then
stay set.

Fixes: c56d6edebc1f ("wifi: mt76: mt7996: use emulated hardware scan support")
Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c     | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c  | 1 +
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 ++
 drivers/net/wireless/mediatek/mt76/scan.c        | 3 ++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 8d4daa76be54..ce1824da7563 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -382,7 +382,8 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&dev->mutex);
 
 	if (phy->roc_vif || dev->scan.phy == phy ||
-	    test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+	    test_bit(MT76_MCU_RESET, &dev->phy.state) ||
+	    test_bit(MT76_RESTART, &dev->phy.state)) {
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index c4e82b1e259c..ce1e4773bddd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2467,6 +2467,7 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_RESTART, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(hw);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 9965ac136bec..d37bd9efde79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -59,6 +59,8 @@ static int mt7996_start(struct ieee80211_hw *hw)
 
 	flush_work(&dev->init_work);
 
+	clear_bit(MT76_RESTART, &dev->mphy.state);
+
 	mutex_lock(&dev->mt76.mutex);
 	ret = mt7996_mcu_set_hdr_trans(dev, true);
 	if (!ret && !is_mt7996(&dev->mt76)) {
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index c8c4d096c809..7bf9b7d4a8d7 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -216,7 +216,8 @@ int mt76_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&dev->mutex);
 
 	if (dev->scan.req || phy->roc_vif ||
-	    test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+	    test_bit(MT76_MCU_RESET, &dev->phy.state) ||
+	    test_bit(MT76_RESTART, &dev->phy.state)) {
 		ret = -EBUSY;
 		goto out;
 	}
-- 
2.47.3

