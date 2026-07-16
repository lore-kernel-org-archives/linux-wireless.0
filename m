Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869593D7D88
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 23:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784243137; cv=none; b=BjLy2E77CkrHhAWgJJm+wsaJ+ytI+Wz5fiDL0JbDNYi0dctlFsXGoS68Bb5alvzOO3TIIGbnWC8K2SpYM4+ztGS0F3f1h7mI/bGi8Hh2c/I2rXWRY7cwKpSykhdZ1MZ8zjOuIik62vn7xkpJplYe9iKVxp06yX6RKi7/QfmaUac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784243137; c=relaxed/simple;
	bh=5kEJIrTmt6UgJJ9EIAIP1lfd2Jytm7zKjTI/lyAE8bQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KObrPr/ZTE5lkYvj1qybQeci/fscMRl8pWnKx0T3+r4R2IcdGW77+O6ybLhA/KA6Y3ey5Jvc45dKSJ1IHLraay/Wmgzi+a9jtRefd8wVbrYBArazZzDvu6eGHuzNIbS1ONRKVOsoGiPlmKq0Qr4j6zACuNmz9e/DxXi69k5pILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=USUgnn1f; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="USUgnn1f"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-80bb41f7f3cso38034627b3.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 16:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784243134; x=1784847934; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bk3USZv12WGxErumeiIAVcQcqRoeJeqlNLEHc8GMv1c=;
        b=USUgnn1fp6ns2J4HKi2/h/N3cPUV7CioZ65s6Qn5/mObPZfFbsVtQidiriFx5ULViN
         x0lB5OpGrT3qosA5bP7zHf3xyFBnXPBJFvL8TbG8vZAAxCkbLu8IOiwbo9uMpdAQqW8I
         SCcQZ48Fh8yuvALKCMkh/LXkx63Iulr+V8dKM53ckoB4gEInoaJ2SaQL5GjcYQ1wMjDw
         UveH5nBODOgPcV2TVqRneKSRJ7XXi7//uBk95CkmMe96htdZu5EM5OCmobeqYQWG/30V
         +KWTZd5ZeZ7cnwpBdtVE5WrrUCbPW87E2xr0Wn7TcugKjiDpvQM45z7JbkUWQlX1MRcg
         8FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784243134; x=1784847934;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bk3USZv12WGxErumeiIAVcQcqRoeJeqlNLEHc8GMv1c=;
        b=Kg18EKIqRTPaVGlOb4yE+Vnr5kD3s9qUZaBdu3QJ2Yq2ev9II7/jKtMfuIxFGgtEc2
         bSpVv638R0VirmLalW7P5Hxpa6uGXWYSjZXINJZJ9zievjiMxaPL4VF3Zpu/frDp4rwn
         0tmKr+3rdboXKaZt/nNMiBgXMXEXF4Q76V5sndxpAgMZGX1m8GftY+Y0jwwAxGn9ekJA
         FzL7vtKoBKpUKydVSGtmCFs1vDeHv+XEa7i02IzUyK/dIa7BoyIIocH94L4PY7xjmMwM
         s+fCLQb8ybALpWT5ywTfwbLraJ1aVLCR7EsF4YQ1vIfKhiE/G+8OrQVSfYBQxQaQQpJg
         1M/w==
X-Forwarded-Encrypted: i=1; AHgh+RokwwrnFEg6pYQjGL9tsaGUdhq4zbQZP40hOpzNi08xWq32jm53Chz0ypAVb0XVlxaX94iimVLd2NYNn+PevA==@vger.kernel.org
X-Gm-Message-State: AOJu0YweZL6/n/AbFoHOpUu2lslbU/zajECe07gOj/0KppmnabYzHp+w
	4aG3TIa7QchKfSteYgGWa3iu2fkxENQzrfPBgG491K5CtHvZQG/0c1Q9kLd09mUexmY=
X-Gm-Gg: AfdE7cnYnXXQbGhHxjUXBsWdDtLS4fp2NqyvhlrVUzCUH2abrCyYLZ0Md9oJgUG4Pxx
	Tp9N17HjlI+gAg2nMnh+wBn8AoouYsNoxxiIAOu2V5g9IU54lz3JqHioZNe8VSjwiInmwvLGMRV
	HhOizK0z1aynWe3w+3UFuGX8GdaW2zWbmfkvTEs3GmJ/p8J9a5qWe3OX7aePVHvDge7vLJLB/NM
	/Sth9bg+RDqzCPtt7kAndqxfIAFYiHUUjdG3ZrlOXwCGpwV+zg6CDitj/KlM74PWCRKEx5CyOGP
	tLq9yXSHY21Y9CRJtJLv36BAHrJHlKFKzOEmkkT3mzZRO6/umtR0mQZ0S2okSgTBnOxm6urG6YF
	WXh8vdBQN2kSxYsnQIcRya8Qt8JZfO/PUYj1D7Ih9y2M4fpzVjoib0J0lWL9gZgLza64xSUSc+t
	VDnxGWvzGbBoWOAueU+nr5836rRpZInO8gayBnozhpKyqADiEw83WM1Gk4Lw==
X-Received: by 2002:a05:690c:6101:b0:81d:a1e5:a498 with SMTP id 00721157ae682-81eedf06896mr7708727b3.62.1784243134324;
        Thu, 16 Jul 2026 16:05:34 -0700 (PDT)
Received: from [192.168.2.129] ([2600:1700:220:59e0:40df:d071:3a06:1c14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6be90499sm207006837b3.5.2026.07.16.16.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 16:05:34 -0700 (PDT)
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Thu, 16 Jul 2026 18:05:11 -0500
Subject: [PATCH v2 2/2] wifi: rtw89: pci: enable 36-bit DMA on spacemit K3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-rtw89-spacemit-k3-v2-2-392b577ebf75@oss.tenstorrent.com>
References: <20260716-rtw89-spacemit-k3-v2-0-392b577ebf75@oss.tenstorrent.com>
In-Reply-To: <20260716-rtw89-spacemit-k3-v2-0-392b577ebf75@oss.tenstorrent.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, 
 Ping-Ke Shih <pkshih@realtek.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Inochi Amaoto <inochiama@gmail.com>, Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
 linux-wireless@vger.kernel.org, 
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
X-Mailer: b4 0.15.1

The Spacemit K3 Pico ITX Board has a RTL8852BE pcie card behind a PCIe
root port, but the SoC doesn't have any 32 bit DMA addreseses which the
rtw89 seems to use by default. Enable 36 bit DMA ability that the driver
has when this particular root port is detected so that the driver can
probe on this SoC.

Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
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

