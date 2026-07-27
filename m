Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8181841D114
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=tpFU6IqxFb0ZBjhT3IoX63RIBjEddcxp+tI2ob7nw5pTkKrm5G3NOQ4LD0xq7roYANOT1ssizC92tvovPu2xtSsOd0MHJkvQ9YjjUs8jCZhx7O7YTy2GUgM3rbS/jzCtZqTv7QiAH8I8bKtzTUK7ix+xHpXfyNtw4/VMQV6RDcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=10cHIlb/xAdQCbtqX7jEO2AxEITs+H765o7rJbtbrWw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrFrYoBSZkiAn+KLR+DtBlZKlSorFYxReTGtYC9uUGXBhMBe1++dR++fRohXnUaHMvMQXdU8Ov2jvEReF2inLiXlavYHdf6vpyMFv+wyfFp7g+1Og9jKdT0yeVxnR/pZ00kjbbc/VS4fTWu7hDtaxP6VllfVI0rbwVNtclTSw7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=pQsNFkz1; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="pQsNFkz1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qcxIcFAfi7ntnVtuotqCt0ciEg/oo5S/YL1XCOathe4=; b=pQsNFkz18Zjvmkkvm5Y20hjGsd
	rJh9tMUdr0i5nfk4ri5mctgrRdYqtmfS7Fjhq4JiPUI/kY8luz1e0ks/8GexSlHdFNWllVcBYzxgu
	4DZ84X8TLgPEJK3/LFtWWRIqK62iXtmyK6NL7iyJPjcrfxYqfJXM2C/sV43uZy+q2KK8=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsj-008KN0-24
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 02/15] wifi: mt76: mt7915: fix double hif2 init on the non-WED path
Date: Mon, 27 Jul 2026 15:04:21 +0000
Message-ID: <20260727150434.1778520-2-nbd@nbd.name>
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

mt7915_pci_init_hif2() was called unconditionally and again inside the
WED-inactive branch. The helper increments the global hif_idx, writes the
PCIe RECOG_ID register and takes a get_device() reference via
mt7915_pci_get_hif2(), while removal only drops one reference. On non-WED
dual-hif hardware this double-incremented hif_idx, wrote RECOG_ID twice and
leaked a device reference. Only the call inside the WED-inactive branch is
correct; drop the unconditional one. hif2 is already initialised to NULL.

Fixes: cacdd67812c6 ("mt76: mt7915: add mt7915_mmio_probe() as a common probing function")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index f6b03211a879..12b3e2dd530a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -135,7 +135,6 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 
 	mdev = &dev->mt76;
 	mt7915_wfsys_reset(dev);
-	hif2 = mt7915_pci_init_hif2(pdev);
 
 	ret = mt7915_mmio_wed_init(dev, pdev, true, &irq);
 	if (ret < 0)
-- 
2.53.0

