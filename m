Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C710438F642
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897302; cv=none; b=YzhI1Q0WpieeOGhFs8+802TAI0ACHapn9Y7GVspBJCb8OdU3ojV3OCrPKoAmaMRbKVydp9LNW574CzCgQ1MdSW/2Ee7nkClxP9sp5oH0gA1FK/0HnEuNoCkqhxJz8bWPkwkQoWg7rqaIM4Zs5XECXPIxmpr5aEtyHpp8Fe4QhWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897302; c=relaxed/simple;
	bh=6HQDJyqCeXHQ6itOBHd5VYoaFN8iNom3rukYCDFxqNo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du3V0ZFGXUPQTlWBEXPAQ2BkXqX2X4feZL2xvElYYkZnUkSGy5Wh8gX2dLDgPJ2/urv9F2SE7xgU1P5JL8Lc3fd/7yUO7HHqNe7cCVipig5TuofbfJbJZ/YgKzmjEQeajdTykybGQA4EtMdIfhYbgQKgmeE/JVF7DaS11ThLMNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=UI3FlN19; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UI3FlN19"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5TkjyAwdi4byp5TaoLJxiFlt+/BJgIjLWMwTqfI32+0=; b=UI3FlN19do+y9c8BrDo7JZC/AP
	qz48CeqHp0olM+Hs8HrljMdGHnUpvmMFkYCimuOMghwgRYrC7aj3TADWfAC2dIhizbkNOcLMYtdBq
	r/xuYTlDyuk2pvsW+8wNkP17V+2qt84yf5yZzAhiObs7gL+9MfMSwEO/ClHIhGO9GSz4=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK6-006LeO-2j
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:18 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 19/29] wifi: mt76: mt7996: wake MCU waiters before aborting scan in L1 SER
Date: Fri, 24 Jul 2026 12:48:03 +0000
Message-ID: <20260724124813.3961474-19-nbd@nbd.name>
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

The L1 reset path calls mt76_abort_scan() between setting MT76_MCU_RESET
and waking mcu.wait. A scan work blocked on an in-flight MCU command
does not re-evaluate its wait condition until woken, so the
cancel_delayed_work_sync() inside the abort sleeps out the full MCU
timeout before recovery can proceed, adding several seconds of SER
latency. mt7996_mac_full_reset() and the mt7915 counterpart already
order the wake-up first.

Wake mcu.wait immediately after setting MT76_MCU_RESET so in-flight
commands bail out before the abort synchronises against them.

Fixes: b36d55610215 ("wifi: mt76: abort scan/roc on hw restart")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 4449dde33f4e..96589aea1548 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2567,8 +2567,8 @@ void mt7996_mac_reset_work(struct work_struct *work)
 
 	set_bit(MT76_RESET, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
-	mt76_abort_scan(&dev->mt76);
 	wake_up(&dev->mt76.mcu.wait);
+	mt76_abort_scan(&dev->mt76);
 
 	cancel_work_sync(&dev->wed_rro.work);
 	mt7996_for_each_phy(dev, phy) {
-- 
2.53.0

