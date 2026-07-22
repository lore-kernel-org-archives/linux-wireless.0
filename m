Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FA23D47A8
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708784; cv=none; b=Kjgbu14XigU3VEjbtQxyjn1ezik+GCxuRTONfR6So7/gW9IvBnHBOJjK2R86YUGwT7sfvktdOS+RSzRsq86wo+UmCuJZ5oKXtMtead+5oPlGpwMHCWdS1pgO4CxSuRNJCBNANc20lggj2nz+WwbCgLt1ySQYIRAErHHo6rlqCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708784; c=relaxed/simple;
	bh=5SoBCMLqJWuyWATtMDNa4KVSaD+kEtz8tDeOGFyKmy0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHA1IUrg8PHNE9KjmZdt4H2kXZPzGX1DcINfqmkrcZ2X/O7sy5IuMwj4IG+UfxUrJ65FpmjGsbPo6BZ+j5fGuJCCupC2OVJTMh9cngIkzJgwKMvKdhxVQnkZxeJ/qu/UyotHkqagmq6IclwNqd4cq+i/YryOtx+8KDoa6T0jfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=qVMWwBfk; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qVMWwBfk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v07BjRNtSgIFHfNKjRxaH2hUT2n1wwcfJIueqh4bfZk=; b=qVMWwBfkLteExbwHpXDvRwyDv2
	Oy1AQzZ9nD6M1UM18T1hisX19+OP/UW+XlAluPv++hYTdZ4dCeXIQGgetLpdr/JYHg4ieC5wvPQ6r
	gLZHtKqanGEtJFwUPyZEAWk0duJS20KUvg/dk1Orwtw91PsYoqGUG9KwSzpwm4l2haUA=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHQ-005AHx-04
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 07/18] wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset
Date: Wed, 22 Jul 2026 08:25:59 +0000
Message-ID: <20260722082610.2699628-7-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_full_reset() called wake_up(&dev->mt76.mcu.wait) without first
setting MT76_MCU_RESET. The MCU response wait condition only checks the
response queue and that bit, so the wake-up released nobody: a thread
blocked in an MCU command against the dead firmware (typically holding
dev->mt76.mutex) stayed asleep until its multi-second timeout, stalling
recovery. Set the bit before the wake-up, as mt7915 does.

Fixes: 27015b6fbcca ("wifi: mt76: mt7996: enable full system reset support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 28a69c8c1fd3..4ba088e8907f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2443,6 +2443,7 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(hw);
 
-- 
2.53.0

