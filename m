Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58D73D9550
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 11:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787915754; cv=none; b=pjgyRwMRLB1WrggCDwIg//IlzpK7FnLNy8xA9Gflts+IS6XjENW6uPktgs2xJyuIJ1m9xL5c6IUlf7kSGOvebxFxlZg/+ok+UB6odDeLPu5UuLZyEEoLbjRvfjGt20HUoF761ej5su7rIoJJIvUVDnDLjMepqghGr47GC3Q87ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787915754; c=relaxed/simple;
	bh=LbwSdh6R2dBOwvLGQb1nFehByoMDHDuoL76968xCAAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WX3neN48hkbWxWytC8SCQQy9xxd74AgUf2MTIlEcoLHe4F46vTwssIExNU6YUi2FRIiB+lauvhQVRYmc9m4MlXC+rthMULOALhFqnTQ34fmiS3zVUeVtX/IqYWdR5S1dP+6uq9vbmRMC3Pbx7OzVvpZZtaOeXJPinswV14/mM8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OFqCTftI; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OFqCTftI"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso706793b3a.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 04:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787915752; x=1788520552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jYj6RkLZusaHKjs259c4fa5IazaGtg6pAsDeKhHoJb4=;
        b=OFqCTftIolbTP/gChAsXqrd5efEgtdhG8lqHijP7sdUu45/rhs/nzEg90Twir+rtVs
         lWVWgSZmMpz0rN/DYzNCPo8M+lI/5f9iXD61/Dx6UXb/mv1Z7/JSg8+4TUfa2RI9yUZF
         5RQC3WDkDs6saENBvexjt2+5V2wAf8+6IFdUlF/CtdhTWrKx9pPxN045UtJQw/jsOL9q
         v3pI0Zxl0h9DfyorIW+2oSk6e5mbNAfSwAYhM5KPWxwDnSE48wdzM2iDHgTCwbrpNNXw
         iGtNUqigaLK/7cs9Pb3HcRQn8fEh8eN8XOYJ+T5MrO7I5kylehzgOnfPacgOp2ukr4wC
         0FeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787915752; x=1788520552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jYj6RkLZusaHKjs259c4fa5IazaGtg6pAsDeKhHoJb4=;
        b=o+A9vBfvPK9u/wV4eb7FLXpfMsXFIAHIJXBvCO6T3eS7LId8Bm8e6py3TmYb+7f0W3
         L/NvfIvL78yosDN92Wpn3V38bf9iTvnW8rMbY5baPc2R0Eieg+b+Dgq0V5NNPMjOry3R
         jBDX1a5/fQlAEwXuJajpHSpC1/P9Xxt29Q+X4mkw5/2tl6P9Oeg2k6uh+b5DZ9hK1tto
         rgktLjOaVuZHb6WkekkmpMwWaAaEAJoRWMwQn2aCqr3a7xRBIW3eQkfP22/X4uSR6YlJ
         +k7YLHVVD0Adul10P/PtDW0KUlxw2+s4or5X5n+9cZklAPUJipubVWRvKkyx0gcFxW4r
         8ZYg==
X-Gm-Message-State: AFuF++nJ5mPaQIDpaGKbEdejVNAa6OJeniUuRe0Ig8sK3FcEB1ST3k5T
	EXCCD19mEqcpImaHN0hccWrK17O8Cc2ZKiEBYIltcWnvtJi51gNIsWvh
X-Gm-Gg: AR+sD11cSordwr9SMF4SOBr8BjYcDKjOK6XxdWAfz6MAkrekvLo4/49Fmu4oyCd4YuO
	AH4BZSQxJDlZmvYoure5AN/gsaEMOB6ZqZQmun7ILwnJKchs4hloJYmHFN/4eawDXTRBMHGcg/R
	LWpKFHQnzrU44PXg8xaN0ND790CikdJPVqbxRaRxwC5rBwFzRCEN2FHJjAgQzT81nHgqQ3iJAVb
	BU+LDh/7oXIwEM5DpoPTnmLKCHbOylAm6R+ECjv9nMJSYPE1OOrfCKdhb5p5xOylcAk+HWfoVdj
	2ELknMIcQiKkwnC3meLKm1EFVMBWqyslc3uX8treuKV7oEkH2AEDjqYSIrIcfPTdHAk6RU/c1Q9
	wiZKZ60sS/ib0e3qzA6g9zfZctuxzCnFifHm551sefinyomfMSRIXhBslFxiaXGRDnIvZPrqoq9
	ED3VohBXrwCD0EHl0CURfNvZxRo0JXgH2yIiC54x51urCna3Ix3QewB3shR7j1rw9buBPOEEX3t
	6M0GJENe4AjujndxaxLy5nLaYXTiMx51JHiqHzC6jM=
X-Received: by 2002:a05:6a00:4109:b0:847:7f3c:b5f5 with SMTP id d2e1a72fcca58-8562a6e1024mr12521963b3a.11.1787915736033;
        Fri, 28 Aug 2026 04:15:36 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea7666sm445780b3a.30.2026.08.28.04.15.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 04:15:35 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: briannorris@chromium.org,
	francesco@dolcini.it
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path
Date: Fri, 28 Aug 2026 19:15:31 +0800
Message-ID: <20260828111531.56723-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mwifiex_pcie_request_irq() registers each MSI-X vector with a per-index
dev_id (&card->msix_ctx[i]). On a request_irq() failure the cleanup loop
"for (j = 0; j < i; j++)" frees msix_entries[j].vector but passes the
failed index's &card->msix_ctx[i] as the dev_id. free_irq() matches on
(irq, dev_id), so it fails to find the action registered with
&card->msix_ctx[j]: the already-requested IRQ j is not freed (leaked) and
free_irq() warns about freeing a non-existent IRQ. Use &card->msix_ctx[j].

Fixes: 99074fc1e67b ("mwifiex: enable pcie MSIx interrupt mode support")
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a760de191fce..a9425e9a94f4 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3068,7 +3068,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 					    ret);
 				for (j = 0; j < i; j++)
 					free_irq(card->msix_entries[j].vector,
-						 &card->msix_ctx[i]);
+						 &card->msix_ctx[j]);
 				pci_disable_msix(pdev);
 			} else {
 				mwifiex_dbg(adapter, MSG, "MSIx enabled!");
-- 
2.43.7

