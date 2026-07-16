Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF10F30C158
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 03:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784172141; cv=none; b=K3ekbBPhEyrRVVkrBZOAE/q/x/AUpYnLQiA2VeXP42lnx+XXRz/GCns/69dVLS4dboErBBVTzhh6eB08+hUaf4PEOS2fiAKxgf5zPrd5e5UR5iY8kERAx8TLXw4Eu3KXqUkTDHpYhGmWWNBtlPWd8JkDcBCY4tdZl75iOHFoUYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784172141; c=relaxed/simple;
	bh=elJNDpCx9A/ond//LPRjsJyfG8dwc8CRwQsb3uFhM1g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OQjN94fg+NNa3Upm4QPRI847R/bmEdrh5dDwVRkEYR3Ef4PvmCklGHQ7a8+UVkucLZyXnaG/OijNJnzo/YEoD1JMx1x0VcTmoSbJsEOP/gJt6syih+YUwha8eGOh7PC9VZlSW7Ohcv+O3mqZ7cYpgfoOrmn8FBrzSgVUMdYIQW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=J6Ik8eSu; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="J6Ik8eSu"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81e6f0b4610so66160957b3.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 20:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784172139; x=1784776939; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KmLTscAEY1O1j8tiZ/+N1t1kAFbbT11AKs1SQQgixyU=;
        b=J6Ik8eSuFh/1cZpGV9JPf7sYDwmS4U6P47jPX3VKNdcP2ylT6VNr/HMsNsaglt/Q0E
         QH2jU+RdLFcN0TZPQm9JY9U1BBpNLoJKJHCmmn5WbpP4f0D3xF1DT37MioeeVg9m7LTf
         4FlMgvIY5h18rQAyotTR/Q9tDoPOA98/rp/gXVwX68pvK6mRVKXDlMMd6LkIv+DPa43H
         ghS2uuhX9T10WJWUbRIIAU/5oYNdiMD7NOiTDLDQqmmSggk9oCMVcYgPIsPOE3iTPvju
         BoyX8kilw5I2qQjbNVL1/yAkJrXVDQMAwZujaDCI0UA1zePNAc3PtkTmoc8CgnGG5FAx
         Kk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784172139; x=1784776939;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KmLTscAEY1O1j8tiZ/+N1t1kAFbbT11AKs1SQQgixyU=;
        b=svU+rzDyaKefitoT2i9c8aeh/AnqB3N5+AgkkVV+lFygGFONKd7g5fksEMUNu9yKhv
         ob9EkMd50bbH6yc/gztsJSQAQKDqnS7ISJB7MRpFKxPBjf3X1I/kfro6D1n2kh8GOXIg
         8zaQ74HekMB4cbVncE1Dr5I3cvEHvXv3YAM2numxdEbNVk2fVBCBRtkHY/sSKM3QvbW7
         mK1yl0eIWyE3XRc0vOJ41GZ3MaZCMvKAdPZjHtkS5BnRPtEbTrrAILFWFndaRrh9+56X
         WuNr7nVCaFhXndl8Ef8G+E4xEKTvD8dPm9WruwkWmpKKDm1UOHmyTKoMZ78u8PEcjxpN
         O1IA==
X-Forwarded-Encrypted: i=1; AHgh+RoNx/07byDHA4r2v5DFaDkbeKGrHb1M3En2TD1Oll9nCGoi3VGdpUjZd3ywWORULqvprcwTIGzpQEk+mBD9ug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf1HD3B79GdZd4mPSxCkTuVtPOD1ZSDPpQ/RkDhJNAzAvETxWy
	GqVAoKHv4Kdl6Nu3tur/GsUVuA/2jMKrBMV2ZBRMBjmCEQh8p/rEkWVMeCPT7HBs2Jo=
X-Gm-Gg: AfdE7cn6KXJAmz+/e3Hpw9+yACQORM/Oe3NmS+hfvqL2clQbj0gk2HKix63o1ZcbX/q
	wwpvwYzFxia7EDd/KnDerLrY20jVv7yROJCGQz65RY0xMZJNwGs2PNItzmQFNCinAQFamN3Ekzq
	uqDGG1i6Mfug8bHwa8zZCKusLYR/HvgxmJSn/1Mc/ZwDOkKh5QELBthLqeKOsg+CcaB2eLEDk2w
	s++bO+WNSR2I/lPKK9h5wOjRypYYjzu/D3HM5plE4A3EFWVPCM33iloVM7QrBjyRIkqY27m0FCU
	ju3CUCvn4S5jzQFoup8BHg1tn7ts2y0QYbPifmbhywJ0qjdd8nmP1Yzmsgf34gHqSnVrRI3v+pA
	G5yloaKL2pTBYxIaOj7R+xaR97XFeG4wZ4b7ZeO5T637HKj5kTy+C6+C1SrdMGAo9Q+3Zh3XIPC
	6+FpbQYkNoy47Gwd8afmrECJpR19YOOVabkKXq1OHGNdv17uizM460fXpKjw==
X-Received: by 2002:a05:690c:c86:b0:7f5:87d3:c38c with SMTP id 00721157ae682-81ebb136b12mr83075437b3.21.1784172138727;
        Wed, 15 Jul 2026 20:22:18 -0700 (PDT)
Received: from [192.168.2.129] ([2600:1700:220:59e0:56e1:f9cd:8869:2218])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6befb688sm185039127b3.14.2026.07.15.20.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 20:22:18 -0700 (PDT)
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Wed, 15 Jul 2026 22:21:54 -0500
Subject: [PATCH 1/2] PCI: Move Spacemit vendor and device ID to
 linux/pci_Ids.h
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260715-rtw89-spacemit-k3-v1-1-e577bc63706b@oss.tenstorrent.com>
References: <20260715-rtw89-spacemit-k3-v1-0-e577bc63706b@oss.tenstorrent.com>
In-Reply-To: <20260715-rtw89-spacemit-k3-v1-0-e577bc63706b@oss.tenstorrent.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, 
 Ping-Ke Shih <pkshih@realtek.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Inochi Amaoto <inochiama@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
 linux-wireless@vger.kernel.org, 
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
X-Mailer: b4 0.15.1

Move the vendor and device IDs for Spacemit PCIe Root Complexes to
include/linux/pci_ids.h so that they can be referenced elsewhere.

Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
---
 drivers/pci/controller/dwc/pcie-spacemit-k1.c | 4 ----
 include/linux/pci_ids.h                       | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-spacemit-k1.c b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
index 680acc93f5395..7b0bc1802954a 100644
--- a/drivers/pci/controller/dwc/pcie-spacemit-k1.c
+++ b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
@@ -21,10 +21,6 @@
 
 #include "pcie-designware.h"
 
-#define PCI_VENDOR_ID_SPACEMIT		0x201f
-#define PCI_DEVICE_ID_SPACEMIT_K1	0x0001
-#define PCI_DEVICE_ID_SPACEMIT_K3	0x0002
-
 /* Offsets and field definitions for link management registers */
 #define K1_PHY_AHB_IRQ_EN			0x0000
 #define PCIE_INTERRUPT_EN		BIT(0)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1c9d40e09107d..d6f26cacc8e35 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2640,6 +2640,10 @@
 #define PCI_VENDOR_ID_SUNIX		0x1fd4
 #define PCI_DEVICE_ID_SUNIX_1999	0x1999
 
+#define PCI_VENDOR_ID_SPACEMIT		0x201f
+#define PCI_DEVICE_ID_SPACEMIT_K1	0x0001
+#define PCI_DEVICE_ID_SPACEMIT_K3	0x0002
+
 #define PCI_VENDOR_ID_HINT             0x3388
 #define PCI_DEVICE_ID_HINT_VXPROII_IDE 0x8013
 

-- 
2.43.0

