Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A590232F75B
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 03:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784172142; cv=none; b=DpIF/YQ/F7QLMq5PeHbQVXVIy5I3L9Nk4/hp63douMe3s1JaD2PY1XeiKR42mSRX5csVllcuccHoNeE9/zCBTsNe3y6NT3haWfhCEjJ4MNoPwkz6IHspQRnI1BfUMzJs1A1D8dlR12E7t6TDjBp1OccEKp3TNW+L6ULl2oYSl6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784172142; c=relaxed/simple;
	bh=5D1qVSBbWfn7Tpv6gHBIf1HEIkdpFl8pWYg+EmhZk/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OgCUWASrmBANZIST/cn9tyqehZ/+rMxpmFBtHCCEtqiI4Q9i/XNoFbUYmskD/hp75iPn6qQrNbscVNuozj4Jt/BM91n6FRm3kiE8SIoDky26zHyMkXE0t9QEmzFE3jj1dXl6aJCPT0xF+1hReQj6EueEOXk3QELsQ0e5zX6M0Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=APx6jKgy; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="APx6jKgy"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81ed2a00f12so24446867b3.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 20:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784172140; x=1784776940; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=48efBL+/zgjdRX5eeYvPyEwynq80yeCCfHgWW6gkRZI=;
        b=APx6jKgy3e3irQbP7akXPxudNatD3FbH8rTwQY1L/YzoFVygepfHdKg/wqPdaqfmCi
         zN1ETIo9hWn7pteW4wWRp4zosDU4GlBe5oIX1LnX/su/HzCSOlME+x6exnuhGhVsD5ER
         vxLudYLeGPOQvPVVkI13tdZOpTho+aVGpNsJpBLx++997HaD+Yl27Re5VbqdXIWecVlV
         UmI2ixb7+wYYcRg6QMiAS7Kaw3dJWkrUalHWlPsVL7p310zEk6oLv4A4i0R/xV0754cU
         Ivs5EYGtMA0IqNNj6bTGOm0EjuF4coy8r8mPT51FIjmgojD+3Na6qOzdCJ9YULe7WbTa
         /F+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784172140; x=1784776940;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=48efBL+/zgjdRX5eeYvPyEwynq80yeCCfHgWW6gkRZI=;
        b=dd+qQ4MislHMoP6X+vOfn7SbJO2EJ2hq0L1HujoVW6CEz3cp1A1Ur+xfEUt1zmzABc
         11bB+iEIu1TnGVzy0MftzIWt9DpIwLu0yfF9IlxCEjqVNdBUQwcP0dk3scB9ITnLWAQ0
         l+opVU3CX2byKKRHk0PrYMjZXe55LsDQ1nRWq+jr4PuV+iZpgvs6P/vgBIQ9Ypyondn7
         TfLgRwh8BbQ1yl+MG14dTtB6CrmbpIHMl0+3UIUOThpf+woToGs6M0g+rZhCSy5/eHtL
         Kbt4vdTIHX0NYWQ5xBHkH/3L6eXhAgusr1mlNpzDCYqUnVwpCmTPGVIfedPnCscQc1y6
         M8mA==
X-Forwarded-Encrypted: i=1; AHgh+RoVVxaEveMWtxrXJ/kR629whUkdL8syDB8vBicHha9sWVQt/Lt9r/C8uPvY2/wboHIy9R9MEbAJVk4q4j0USg==@vger.kernel.org
X-Gm-Message-State: AOJu0YybGzBGs7GbQ7R3jHzFVfFIDtsez8XY7M5BWkUTm98k1aw8pr5O
	Bl4xKLAbfjdV0dWKzAbU1zom6fpHvwSJiRGp7jXf2HAzpISL3YtsN5wkqyFaCrDbRlk=
X-Gm-Gg: AfdE7cmTVcvKYYxYr/djGkF2noFaOUOf9fH8feKOjuy0X+MJrTGwjdNx5ejJ0Rhnz+r
	wqEBr9z1xD0QbZMfT3K5XaPLa99O3+Ukt59G/+xiPMVEK0l7M3MzLhT0zws02Kcki4qZpQOueim
	ESvKCi6hDnFPLRQ6memkNFm9Ey1XuvVhi3vd1HgUIVEBLNMUhSiMKz6ZpZvob3wo/nBRcTFpjll
	fI+Zf7WtIRWmXOT850TNM7qddXzTIgyutN69oF4Nk2OatFDzpluaBiwhgxrVCW7LQEcFSGBku4h
	u2QbF1D5wxr/9O4/f0pPS65ysnfpN6lVyQ3B+7dznFgJEm/7f4252HALb0BzxvwsccnvwwmyeIR
	wbVOy6Q8pblp9T+F+8KLvMkuxkjxIcyl6VH94o2jsL2KlaReuZS4BRVOAKQJlPRBak86TZnEXhh
	HKsLN8HXPtFEH0ST8oHQFdKTUwa1Cy3hK63LQRJReUFAmp+d9ZY8XmdjBEyQ==
X-Received: by 2002:a05:690c:9313:b0:81e:d300:f427 with SMTP id 00721157ae682-81ed300f4f5mr29106957b3.5.1784172139650;
        Wed, 15 Jul 2026 20:22:19 -0700 (PDT)
Received: from [192.168.2.129] ([2600:1700:220:59e0:56e1:f9cd:8869:2218])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6befb688sm185039127b3.14.2026.07.15.20.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 20:22:19 -0700 (PDT)
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Wed, 15 Jul 2026 22:21:55 -0500
Subject: [PATCH 2/2] wifi: rtw89: pci: enable 36-bit DMA on spacemit K3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260715-rtw89-spacemit-k3-v1-2-e577bc63706b@oss.tenstorrent.com>
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

The Spacemit K3 Pico ITX Board has a RTL8852BE pcie card behind a PCIe
root port, but the SoC doesn't have any 32 DMA addreseses which the
rtw89 seems to use by default. Enable 36 bit DMA ability that the driver
has when this particular root port is detected so that the driver can
probe on this SoC.

Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 102bae4881805..c5b82fc46d063 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3326,6 +3326,10 @@ static bool rtw89_pci_is_dac_compatible_bridge(struct rtw89_dev *rtwdev)
 		if (bridge->device == 0x2806)
 			return true;
 		break;
+	case PCI_VENDOR_ID_SPACEMIT:
+		if (bridge->device == PCI_DEVICE_ID_SPACEMIT_K3)
+			return true;
+		break;
 	}
 
 	return false;

-- 
2.43.0

