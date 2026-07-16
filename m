Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4122D47E9
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 23:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784243136; cv=none; b=b8Rk8q6duwSFTg4+PdAkDImmkaCmXvgt8KCba8cQxctJNtk28Zk7V3UWNru+oGVNNgVi/9tIVb/dBakU2ELJ0+5aaQUbHV4urmWPfn8CuEkbrumhP/xJ7UrdUfUOj+6Mlf5iglRe11hRdWiixkSmOyjnMs598nVHLaNyBrijay0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784243136; c=relaxed/simple;
	bh=4QUJGefeX7v0wFAUJrkXQvo4SJ0LD6S+CCRwZONXwZw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R420jB21L5GA0iC6wG0oEkDyyw7eZSb6LSS9ug+CdTJOj65IYO4kZoTXA36Ypvr7kNQ0dqLQDQMskI5SX//XhkQvWyi51CZg3z2dqt8EuLGKN5RwXizI2VJpIUtLc1DHBiIL3CqS2XN/jD6acAolaEN6rV0BMUgc6UKYfAbZ3uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=X8ZsV6Q9; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="X8ZsV6Q9"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-81e9d8f3289so49390137b3.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 16:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784243133; x=1784847933; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XhKY29My7f0UHkdvHti6xaUzqbFLMYcjf/PtSfS7aGk=;
        b=X8ZsV6Q9dzI5hhx4kLbM6C1l9XKDSw14CeDpDbUN4vW5i2WJF0Rt2Yn+rPiZA03Eg0
         xWKUiP5zSjTRIVnRTrvk1Lq8DpaPGaM1OQXeUmJvoKMkJ0V5qt1HnIcU9tNRq8j351tD
         EbcYWpdnn6xzQTAC/+MTHOCTL/Kad3WPe/Vifp56xmdkf7F6ivoWz8AL/AUbIF48Cctq
         ZQeNfsd72m4IM7S9tSBPplxzSYVYmYM6m9f6Y3tk+gJQOKuM1Zz3YPo0CNjNevYgY5MN
         bRNyArOm9t3YS9pZuaymYbqImzqW2BlHS3/2L6apfvBbctjk17pMoC9YgX3GD9Kooa9L
         IHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784243133; x=1784847933;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XhKY29My7f0UHkdvHti6xaUzqbFLMYcjf/PtSfS7aGk=;
        b=dU2vV13RqSIkFYOAiGMTi3Q3QT5QAkFvGYn5hq4wt8nIc1dc4Z/3i187l35tkVqi78
         Jay5qXY8VZpUAJBfVyVAOpmEiNqU/Ot9BBxrs50k12XxKlEm81vaYr9+oayt9V55Auyk
         7zQotCwv2VdWXZ21ExuPihuAzd9lvUetInWzHyn9LlWCnBrv6wb+TkU1EUIy8d9zLBrT
         wmkVGb8GCIO9QzzTSYztWZ0zishoxQ1tjhMveSMyCJt2SEvkSEhaZgubcICDU+NxeOME
         gRP6PqYl+LQdvKiQBdowhI3yjEu/kY9rtWGL5Fnq2QAiZAAefLgk3Mqu/wrDhUz1F/jw
         nM5A==
X-Forwarded-Encrypted: i=1; AHgh+Rp47ng/pw5N2RQaX+iI6Cou4c53fuSv4CAmgusqDH/jvXCgZwcjPrXbfBV/QbFQjWohX6364ig0TeHl4Jydgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpulpKKe+gtMtNcRaTzZ7PuJhY2L7v7X1yLQts1Bm8L5360r2k
	XWg2ZlDolgYoxwzrwn7FlaW4eaDpakudCTV2AA/N2CZBhSoIBKuZ3dCO0tRbGPzK5IuLE3wDkJf
	0Mz2+Y4M=
X-Gm-Gg: AfdE7cmdQmiDK7aU99K2wWBVGNKe5lcFUUeTlIM4WRkbMxJdDH3C25Xw5CXs02wImLy
	rxE1cHKgcqaTr7SkRSMygjYGoPxLCDerP2Q7827p7mSKHZMW6d9hMs2vYQCZm2Yc4/L0lyCajue
	+Dt7ohetOTwPqw2MgtumTRDHwv5M5Y4q02nVbw1SnGpIXDSipKP+MKmHh20zCqskfJJ307VGNLe
	MbnTt9gnjc0fKoZyAY7VeW/4oTyz2Iize00MobfxFS689cVP5vkQSxj2f+yoEN3VrR22wyIvK5X
	xVJFJmMQDaGOuvz8L8h6hSDGgj/YNWyp+OMbLs+A1CkvMEDvM7vMqe7yUfg5gm4/tfCqNhiPLsZ
	88Pfn7LMWqxOUacR6bCjrHFn2BuW+yCqhTui6Whqqjl9HP55R79lXfxVf8UVV34w0DfMDM0VUJC
	8zMQgbgbx7/QsZ2Kw+vrqQqmffMheOsUZRXHHU0BgLtRwhKh3vXv3iIi0uj1pNK86nGn52
X-Received: by 2002:a05:690c:998e:b0:81e:c998:9c9a with SMTP id 00721157ae682-81ecf7eef26mr66141867b3.17.1784243133409;
        Thu, 16 Jul 2026 16:05:33 -0700 (PDT)
Received: from [192.168.2.129] ([2600:1700:220:59e0:40df:d071:3a06:1c14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6be90499sm207006837b3.5.2026.07.16.16.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 16:05:33 -0700 (PDT)
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Thu, 16 Jul 2026 18:05:10 -0500
Subject: [PATCH v2 1/2] PCI: Move Spacemit vendor and device IDs to
 linux/pci_ids.h
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-rtw89-spacemit-k3-v2-1-392b577ebf75@oss.tenstorrent.com>
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

Move the vendor and device ID for the existing Spacemit K1 PCIe Root
Complex to include/linux/pci_ids.h. Also add K3's Root Complex device ID
to this header. This is done so that these values can be referenced in
the rtw89 driver to enable 36-bit DMA ability in it for WiFi to function
on the K3 Pico ITX board.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
---
 drivers/pci/controller/dwc/pcie-spacemit-k1.c | 3 ---
 include/linux/pci_ids.h                       | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-spacemit-k1.c b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
index be20a520255b6..f89c6d46c7684 100644
--- a/drivers/pci/controller/dwc/pcie-spacemit-k1.c
+++ b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
@@ -21,9 +21,6 @@
 
 #include "pcie-designware.h"
 
-#define PCI_VENDOR_ID_SPACEMIT		0x201f
-#define PCI_DEVICE_ID_SPACEMIT_K1	0x0001
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

