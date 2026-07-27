Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B5D41D20A
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=aWIyBDm17WiEZPpFobpnodj+UZWBhsY831tFdYrcHcHoSTR16j2a9rxdNakf/wqntlejzxJzxONS1/UvSOMD06FB2iELTZrPIs+VcRmKOyjUn+JUiIILKLfYDkNHTgQcszMzGmRUb7Au6tTE1rEg5zeQd1G3pccz9M47Rf5SNRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=yyyUujoYSFiytFIUe6nn+ol80qXRjBagFhyR6xR6ZVk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJEZWe3UcrxfrrNPePGysVWTqm7tNh9DduSTjcTOieOcHiC2oBDp53k78goksBTgvUrTEueZaABjo5r/So4kprfW524hhQ6nXsaLk9GlLsh7V87l47Egsy+HHaGEH1m8r4we9EvjICpeFilbT2JXeXufi7l2S3OCSqsY5FB9yr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=N9W/5Hn0; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="N9W/5Hn0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wJR9WY5OHxDxuMoNrOtJ1y/NPCXtWB9J5LJLP5QQKkw=; b=N9W/5Hn0C7y28hunVuMBsB4zTs
	AQRR6xkdzAhFkk50YF2qNw6q0GgkjUesm0X4JcZmTDS36L3eOKq0OjPivAle2J5mzFQX0oGkwRajx
	xiYH3fRFZcYf2hL4bzEzHgykhX82FU2ycHkQm6G9/NY9ezW9GQacR+haAxuOFFZsH2bw=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsk-008KN0-10
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 06/15] wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed
Date: Mon, 27 Jul 2026 15:04:25 +0000
Message-ID: <20260727150434.1778520-6-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the WED attach for the primary PCIe function fails, the probe path
still attached wed_hif2 for the secondary function, leaving the device
in an inconsistent half-WED configuration that crashes later. The hif2
call also re-enabled hwrro_mode, which the failed primary attach had
just turned off.

Skip the hif2 WED setup when the primary WED device is not active.

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 0d7521d06981..ba064324a7cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -490,6 +490,9 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	if (!wed_enable)
 		return 0;
 
+	if (hif2 && !mtk_wed_device_active(&dev->mt76.mmio.wed))
+		return 0;
+
 	dev->mt76.hwrro_mode = is_mt7996(&dev->mt76) ? MT76_HWRRO_V3
 						     : MT76_HWRRO_V3_1;
 
-- 
2.53.0

