Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759630;
	b=M6bl14if5lCacn8TgcwwyAKMA7nxhZjrCYyv7AbDMKaFk2xbmkmICjCcDWlPUF/RvuO1
	 GsLfQuR6Y1zIT4LZWRnfzrUkQDbqzGP7RQlGvjcmiwM8yxZBm7aymt9eukJTRr8n1TNl+
	 Am9NA1uTrDL5oh+OQMePaTXEcLXEzrd52EGB4WylDD1VABHNtOmgltwSwdPwwS0R1MY8R
	 ojau6DIkBaQzFlEZK6M+GC8Jc/2JR74qYMFM4YGtPULPYUIx0YQcEJT52NYmvheHj7R0V
	 QPLHVd9pqmmdHCIoILhBm3z/SwuqGyIFRv7fi6EkGg5azikuvgBv7umFQFT2jBQq37Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759630;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=7LsjOtSFfh2NlyzX9thx9qIfkA/SfAfsf3PEzAZ0vbg=;
	b=k8riAHIdJE6HEsAurJZlRqJLFFNcYCd1poNb20XlcZgLpLPqOtX8V9Tu8N050axc25wL
	 I3xAsjwkAC/Nv9FK8qvMfnkmjBfN9nAajr1erI3fuF/A24qWc3gv2hRcMLt+I9IToi6IN
	 amVlUss7GzY49Vufju1i4HfQYoB5M2WpHcZHdUaDamRNEes8XCYNCvqA2ep8NiLrF49BY
	 SYcb9bXoFu/DxU3Sgt84FFz6LbAEa61QfE0MFMAHQNLHK9/O2g404pgsUmyWoR5AuPvUc
	 /6q4DvYFSppldQCJFmZawhobcGfdyTdNDMEPb6zL3gz73x6tn+2fBocZEjZ1uglSLOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=gdFR6Dtz;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E231606D804;
	Wed,  4 Nov 2026 02:33:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E231606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=gdFR6Dtz
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536858af8;
	Wed, 4 Nov 2026 10:33:45 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: Fix potential SRNG configuration leak on init failure
Date: Wed,  4 Nov 2026 10:33:44 +0800
Message-ID: <20261104-db9e3c75b3-wifi-ath12k-1@mail.sdu.edu.cn>
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
X-HM-Tid: 0aa1a467c1d503a1kunm8831a46e1636fa
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSR9MVhkeHRlJHU5MSEhOHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=gdFR6DtzfEExiqT1N++04TlU1WsxHI3HrcffSv0EPKKjJr3VAhVfNSputBzwDR9VMbZ6TmDKhOxsVMPqhRB0zUtFqCGvLr3iIieDTI4RWyBkwNfwLG9PTRToHEQQesJNGrqLnNGGstIU3Xv8KQVE7q0wsmI/cLNKElnTjhvK1CM=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=7LsjOtSFfh2NlyzX9thx9qIfkA/SfAfsf3PEzAZ0vbg=;
	h=date:mime-version:subject:message-id:from;

If either DMA pointer-buffer allocation fails after the SRNG
configuration is copied, HAL initialization returns without freeing
the copy. Its callers skip HAL deinitialization on this error.

Free the configuration on both allocation failure paths and clear
its pointer before returning.

This issue was found by our static analysis tool under development.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
Validation: x86-64 Clang W=1 changed-object builds passed with
allmodconfig and allyesconfig. No hardware/kernel runtime test or full
linked-kernel build.
OpenAI Codex assisted with source review, patch implementation and
commit-message drafting. The submitter has reviewed the changes.

 drivers/net/wireless/ath/ath12k/hal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index c0c3d2f047ef..8dafbe44df38 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -744,7 +744,7 @@ int ath12k_hal_srng_init(struct ath12k_base *ab)
 
 	ret = ath12k_hal_alloc_cont_rdp(hal);
 	if (ret)
-		goto err_hal;
+		goto err_free_config;
 
 	ret = ath12k_hal_alloc_cont_wrp(hal);
 	if (ret)
@@ -756,7 +756,9 @@ int ath12k_hal_srng_init(struct ath12k_base *ab)
 
 err_free_cont_rdp:
 	ath12k_hal_free_cont_rdp(hal);
-
+err_free_config:
+	kfree(hal->srng_config);
+	hal->srng_config = NULL;
 err_hal:
 	return ret;
 }

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
