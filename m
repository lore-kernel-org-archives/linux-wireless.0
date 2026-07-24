Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE83C3B2FE6
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897304; cv=none; b=MDJPZBI0zh01SgMw/zSwIPVRF8q/8S54ksBh3zvqt181qF84eDs6sW3q9mgiEqL0iYCX7HXDwxVpTke1BgUfYeLTRaaTHLsn6ZUpiLBYcVseYRAw8od6RS1zkNWNry7M8I8I6k6PcKr3mw1CSo9W6ym5utV9u4NByBo2s1JtLjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897304; c=relaxed/simple;
	bh=+BDw3TyPz4YNm91DnaJeYnAv/JIIDpiEuAL2cX09Upw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR+BbqwmCWu7LapMZVAAfkpeyJApuowWkn75aQLsRltVW7HC+W/EjmiliBMuXuMfGTtqUbHV0TwtrTvMVSgNH3HQImqNSOKMnbIbhdPih0LnztAP7M/K1KtWP81xjV15b4v5Fn0pQeAHlQm7tEBdCzBmxmsC15CkIdkDOWObR2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=V4yeWv31; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="V4yeWv31"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fK8nIkFZu7dY+UoYLEm0dXuC3dvTk/sactmMKDKcP6I=; b=V4yeWv31UJ+tPSCLda02sdvnTV
	P6SbYNkBU4mOv3HbsWCiNxUjqi2XJKkNaeWD0CtDzaG0/Ay/kWCQP1QYtnX12v3gBmpZeNGRdH0b2
	iiNKt8UqK4FJIj+L6CRfeymO5LCEplhQkHoGgEn1rFenLi0d7KcxlgKqMAi0zYHS0VuE=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK8-006LeO-2d
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 28/29] wifi: mt76: serialize scan-link teardown with dev->mutex
Date: Fri, 24 Jul 2026 12:48:12 +0000
Message-ID: <20260724124813.3961474-28-nbd@nbd.name>
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

The offchannel scan link is allocated in mt76_hw_scan() under
dev->mutex, but torn down without it: mt76_scan_complete() runs from
mt76_scan_work() on the mac80211 workqueue, or from mt76_abort_scan(),
and calls mt76_put_vif_phy_link(), whose vif_link_remove clears the
per-phy omac_mask and the device-wide vif_mask/mld_idx_mask with plain
read-modify-write. A vif link add or remove for another interface,
running concurrently under dev->mutex, can interleave with these
unlocked writes and lose an update: a cleared bit belonging to a live
link gets handed out again (two links sharing an omac/bss/wcid index,
breaking own-MAC unicast RX for the first one), or a freed bit stays
set until reboot and eventually exhausts the index space.

Take dev->mutex around the scan completion, mirroring the ROC teardown
in mt76_roc_complete_work()/mt76_abort_roc(), and switch the channel
restore to __mt76_set_channel() since the caller now holds the lock.
mt76_abort_scan() keeps cancelling the scan work before taking the
mutex, so the work-vs-abort ordering is unchanged.

Signed-off-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 3cb11689d4bf..3594b599662d 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -11,6 +11,8 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 		.aborted = abort,
 	};
 
+	lockdep_assert_held(&dev->mutex);
+
 	if (!phy)
 		return;
 
@@ -24,7 +26,7 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
 		bool offchannel = phy->offchannel;
 
-		mt76_set_channel(phy, &phy->main_chandef, false);
+		__mt76_set_channel(phy, &phy->main_chandef, false);
 		if (offchannel)
 			mt76_offchannel_notify(phy, false);
 	}
@@ -41,7 +43,10 @@ void mt76_abort_scan(struct mt76_dev *dev)
 	spin_unlock_bh(&dev->scan_lock);
 
 	cancel_delayed_work_sync(&dev->scan_work);
+
+	mutex_lock(&dev->mutex);
 	mt76_scan_complete(dev, true);
+	mutex_unlock(&dev->mutex);
 }
 EXPORT_SYMBOL_GPL(mt76_abort_scan);
 
@@ -139,7 +144,9 @@ void mt76_scan_work(struct work_struct *work)
 		goto probe;
 
 	if (dev->scan.chan_idx >= req->n_channels) {
+		mutex_lock(&dev->mutex);
 		mt76_scan_complete(dev, false);
+		mutex_unlock(&dev->mutex);
 		return;
 	}
 
-- 
2.53.0

