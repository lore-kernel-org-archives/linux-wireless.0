Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759628;
	b=X0GGZYmftebG6QTLFJHKIleatv/8VMJOIbhouZ2s8Uwj3jn5Glg8splhcxY6gE82Fbgl
	 cbN34ngk7AWe3DpT4MUG1DvPLxmtsMB0o+jLWTUHVL8A1lfifBJ/qLnjQGsw8w6CzF8SV
	 MbkIfPHQZ3ZXXe+UkggV0FMQ/IPsVfq4j2ARzQEEPO5+Ko9Kmn2M0IdJyY00pF8AfGi0C
	 UML6aronqypQx862QKLZlK+qvMDHMSPYKnTZOvnBz/v7E6EvzTwh/7V98rVMh5FrHUZyJ
	 5GNNyr/4YBxK2fguPUKCvPwB8LTb2cadCUwkQodtgzsY6SPLEwKAF1k6sYO8vy2vFtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759628;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=00pDn8gpWy1cmRkiYLDWSOCJsKkN0Wkf4UzyiZzW/0g=;
	b=C7QlJe0kngeGsHyDTMPE7Q38CM4V9Oww7ZKjo6eoctXor2r/OYBrqFTHFN9cNRhuP9cG
	 4i/xPEmO6Kox5/Zrhlke4G6dYWgJKYIT6pde8estT+hYZ4hDwJBNb0AxtV8uBDbd7bXQj
	 fW4fpw49Ei//PkUYh2REXD/vXG8RfnVQiNdSdYen+7DcRVQPX5VPjQqbfOk38o+RLd9zo
	 5ucBdCnLKWMfMIqwkdW+koA2bGzYHUYZOuJBjt0vYH13jBCUERhJCIQtSTycgBUegO2v6
	 OoYZA2b5CXv4WHbzEdOikKlmVt1U3Z3qbI0sF+wvFy8FFJmlE4X/af3GceMkTV3myvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=b6EW8j7X;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868C0606A338;
	Wed,  4 Nov 2026 02:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 868C0606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=b6EW8j7X
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536858af4;
	Wed, 4 Nov 2026 10:33:43 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath11k: Fix potential SRNG configuration leak on init failure
Date: Wed,  4 Nov 2026 10:33:42 +0800
Message-ID: <20261104-db9e3c75b3-wifi-ath11k-1@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1a467b9e203a1kunmaae2da131636f3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTEkaVk9OS0NCTkJOGhhCGlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0hKTE
	1DVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=b6EW8j7XEFdsKNAiwEUbKbKqi/1IDrcwSLmlLU230HT8k4ypGyGCGP/fSsed5tmxnUDBO7C0IhPoabx71I10UZsL7mwNCMmob82kO8TaOMehT0e2FjAg8kZPm7a0PyidZQRhBLzK04mPR++ROeGz0I24z4rC2/5GclrwusAy71E=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=00pDn8gpWy1cmRkiYLDWSOCJsKkN0Wkf4UzyiZzW/0g=;
	h=date:mime-version:subject:message-id:from;

If either DMA pointer-buffer allocation fails after the SRNG
configuration is copied, HAL initialization returns without freeing
the copy. Its callers skip HAL deinitialization on this error.

Free the configuration on both allocation failure paths and clear
its pointer before returning.

This issue was found by our static analysis tool under development.

Fixes: f7eb4b04ce6f ("ath11k: hal: create hw_srng_config dynamically")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
Validation: x86-64 Clang W=1 changed-object builds passed with
allmodconfig and allyesconfig. No hardware/kernel runtime test or full
linked-kernel build.
OpenAI Codex assisted with source review, patch implementation and
commit-message drafting. The submitter has reviewed the changes.

 drivers/net/wireless/ath/ath11k/hal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
index 98bd9e3f0aae..8a4e5042d89a 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1351,7 +1351,7 @@ int ath11k_hal_srng_init(struct ath11k_base *ab)
 
 	ret = ath11k_hal_alloc_cont_rdp(ab);
 	if (ret)
-		goto err_hal;
+		goto err_free_config;
 
 	ret = ath11k_hal_alloc_cont_wrp(ab);
 	if (ret)
@@ -1363,7 +1363,9 @@ int ath11k_hal_srng_init(struct ath11k_base *ab)
 
 err_free_cont_rdp:
 	ath11k_hal_free_cont_rdp(ab);
-
+err_free_config:
+	kfree(hal->srng_config);
+	hal->srng_config = NULL;
 err_hal:
 	return ret;
 }

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
