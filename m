Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D284AA584
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792158415; cv=none; b=JbfMkT10Eq6LFzOUD/km/+wZhRCzYUOj/VA2W8XJHz9WE+5ujtcPj2Wtfkzp8D02Y81I7Ji2qAlLS+ZYUF7uEh3iAuGQbj9GWlWM9XxH4REn+dStQYKtmvOMAxb/xCX86OgTAbBDMKpa/v0O/U+LnN6QdZ/1pDEOMKrxGmHMzuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792158415; c=relaxed/simple;
	bh=VZm/E86dEnTEbDrP8Tc8qD8DejCMeBMrGyBczaa/+S4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eYTrfYapFKuEzYF/4r9p/FuX/CSQP3OZPNMps66j+IhuYgvJ9cyT3XXvYZ1vQ7PG5YS3gzLjC2Btiwf3DweVaNnGOlC69Tl5t7ToTV8t+m+OgPHDSLT9i8VN2cblOhsxifUdLitsqxUCzS5pyizvnhLTcsArLjGtr4D5sDnPnxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i0HCQa8l; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0HCQa8l"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b1b34ed603so1095599a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 06:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792158412; x=1792763212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NlNceBhNGGeImb9EhUU1eWWHmVe+LlkK2oIgSPXYbKY=;
        b=i0HCQa8lO83s86MhZ5kDqKZ1rdNR+J5LJWK+zf6WjuqlAmNcLmu4Np7+RnY+kIjP99
         yO4rOjBSLYuTybO9gTxaKVJAFqQq4BnHU3WCYMAlFzsrz6pshqdPjdXLpd/3Gj9gl+zO
         M0bljjgVR+WMiFfYLRNO6xjWN2Am0sECi3LuPJ62fCJ5qAvStR+4GiRdLRBLTtDDat9J
         D0HgEWTF4GgDftytFtlDJ1gVsAXBD46PATxiwWT+TTQhyXkFImz85YfVzbLVa0UGMUE5
         wT4D5vsr96Aiv9D4XUa/oe4AyrqQWJvXsEMhsO6Lz7sFZMRPEAtmtSUMcSY20IytyA25
         oBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792158412; x=1792763212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NlNceBhNGGeImb9EhUU1eWWHmVe+LlkK2oIgSPXYbKY=;
        b=T/NFe/fO+U9Zj+nW6f8uSkYjzHrmm9c19FK6/4VG4H5sCNs0rWc/G+yFUit3kKoWy+
         McBDgxclfKpj5yXJXZJWcr8mzz1ALJiXRUunY1a3+9dVuTf0OlOQ4OXb10jL1YQg1Fki
         0C2NxeVrNtY7X1zAORLe6cSOG89goAtkcN25P/jUzJ/wbzRIk0tOusyFe6qO67qFV2t0
         KVJDR4VOK3017RJtUj+1bzmpUi1V4sMm/MpHGK4e/12f6zxicGnPDlh5FNn1y6RmuijH
         fSQSafQO0TynzzJ9+9zPW3OT3EgVwafnxfejN3o9MOIMiK+gov/OJ5N8WlgMv0pv0t4q
         phLQ==
X-Forwarded-Encrypted: i=1; AKwUvBw95CGxTlosraWT5oirt7kbuwcNpSlz6ks4bReKiqkt2ZHVYdo9ZYhEU0017vU/cbWe8rxfl28MdmzMSS7knA==@vger.kernel.org
X-Gm-Message-State: AFq9FYITdmuYm4njGjs578cUCxdcghaBQFZr8gP6kUHTa7hitav6sMuM
	XC/AWckHC0HL2QcGd4tYsXx2wSCg3p5qdWvEPLdH9n5PvH3G/OoDzdPB
X-Gm-Gg: AYBFou32lFT+V9b0e9sn69ykKcV+ZDeXQm7y/ep9+NQXv8qthyPZInSqAMfTE7NuNoH
	NznHcPtmri3Rhc3y13OO5eOEurEksOYSKwREBrTT8kSFPblMR6uVAWx+uEFI4UeBB+5BIb9r6BN
	cXw8h9Vcw7cO8Zu/2lCQRTdbivJM85Oq2YkhtuUS3QGx0shgpfufy/gCd8oR6jBi+4tSzW8Niq+
	R9UI0VYWZyslZzuGobDG5HwNWnNvRAb+6njw0rr4JNjpjPlnFSdRVdUC2ZvHRFst5I+OUtNfgok
	0uVzdjXK92AF1cDvmo35bF2/AhjdkTNo9iF6A/UTe8EVBwvitgBIlvEiLFTz30m6nmP9OxtXD3m
	mIWZn0xm7b34TCSTbATWRIniVXTbwo3Max/FJuIdqIDU5VK0n+W1yDWDdGbwpcjtKzQFBztgXdK
	LdU/Fv+lulByjOrSYgaMCpUggXJALxcqK1D6h3ZyRsBU7T5dKvTDSIPRKM+YfHOTlSdItkdFzsv
	eRqHJ9hYxs8KozgYWFOI0EG6WQcWp8jCuqXdQc4CqIZrekYUV0tLa+KAzbvPPhIaEI=
X-Received: by 2002:a17:907:86a4:b0:c34:db91:aa1e with SMTP id a640c23a62f3a-c34db91c6e1mr1507691266b.4.1792158411627;
        Fri, 16 Oct 2026 06:46:51 -0700 (PDT)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-149.paris.inria.fr. [128.93.83.149])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8bd9sm5347093f8f.35.2026.10.16.06.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 06:46:51 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Andrey Shevchenko <ashevchenko@quantenna.com>,
	linux-wireless@vger.kernel.org (open list:QUANTENNA QTNFMAC WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] wifi: qtnfmac: topaz: Fix dma_unmap_single() size
Date: Fri, 16 Oct 2026 15:45:32 +0200
Message-ID: <20261016134538.42940-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In qtnf_pcie_data_tx(), the SKB is mapped with size skb->len, but it is
unmapped in qtnf_topaz_free_xfer_buffers() with size SKB_BUF_SIZE. This
could leave parts of the buffer mapped, and thus leave memory exposed
to the device.

Change the size of the unmap to skb->len.

This bug was statically found and compile-tested only.

Fixes: e401fa25cfa2 ("qtnfmac: add support for Topaz chipsets")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index a3a285f17dca..2e00bf68d001 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -322,7 +322,7 @@ static void qtnf_topaz_free_xfer_buffers(struct qtnf_pcie_topaz_state *ts)
 			skb = priv->tx_skb[i];
 			paddr = QTN_HOST_ADDR(0x0, le32_to_cpu(txbd->addr));
 			dma_unmap_single(&priv->pdev->dev, paddr,
-					 SKB_BUF_SIZE, DMA_TO_DEVICE);
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			priv->tx_skb[i] = NULL;
 			txbd->addr = 0;
-- 
2.53.0

