Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF234C33D1
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 20:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591693; cv=none; b=cz1+4X30gJOWzXH+IHrny2iDFfqg322TSb3TsJeYmwHdy9hJiwkqJzE/SqbSOYDJwRKWzDK6EB9t9xetLeHd1xIFb1v9rvorbnQHsNuYQR95kgULpTVM8+CFRc5u/QuhuQeHO4I1ghjsSe0oSSHQINiBc3gZeYZ70u36lZ2OoRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591693; c=relaxed/simple;
	bh=4lvKNYTPZnKUQTDURfO/WcEbCRwuP4txv8QZpJ81C8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z0phvmZNOuHaSTctaajgQM11Za9wTnnwsAXUWsfKC8LAPwzWVvztABxIrnrGwSHil23Gs7wdUQI2RRt5G5slXIwtJi5vyO/zHGs4Njzb3FOTSv4KEMNMr5xxgPnTFXIifiqQTYNT6EuZA7BIqiH91DDCTAuXU2Dn5EAkNCs2URs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=OgYAcbkE; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="OgYAcbkE"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D19CEC0006A
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 20:47:55 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 581C113C2B0;
	Wed, 16 Sep 2026 13:47:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 581C113C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1789591675;
	bh=4lvKNYTPZnKUQTDURfO/WcEbCRwuP4txv8QZpJ81C8w=;
	h=From:To:Cc:Subject:Date:From;
	b=OgYAcbkEMNyxxTM1ii6heKjciKul3QrNNwmq+MuGrQ7gMjtK20UPXYC/TINYb+BaU
	 tkUW1rUB6HwkL8asuSfhUkjYMk0HXVoDQoVzNksEjQTJR7BaAs4RXJy0b+vaZXfJkm
	 nAYXWWX+QHQjxQ9tYLTXLmQOBXCcq3vBME1ZajWg=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] wifi: mt76: disable NAPI before deleting in dma_cleanup
Date: Wed, 16 Sep 2026 13:47:49 -0700
Message-ID: <20260916204750.1439984-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1789591676-qQPDdYwVy33Z
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1789591676;qQPDdYwVy33Z;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

NAPI should be disabled before deleted, this stops
a warning seen when trying to rmmod mt7996e.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  Seems to be regression between 6.18 and 7.2, haven't looked
closer yet.

 drivers/net/wireless/mediatek/mt76/dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a67880a9281c..6de3f28219bc 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1217,6 +1217,7 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 	mt76_for_each_q_rx(dev, i) {
 		struct mt76_queue *q = &dev->q_rx[i];
 
+		napi_disable(&dev->napi[i]);
 		netif_napi_del(&dev->napi[i]);
 		mt76_dma_rx_cleanup(dev, q);
 
-- 
2.42.0

