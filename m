Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793537946;
	b=ioaL9pqk5eeoEXQEsKOPcip+2ZE83SGCucmLVwxer5Xj1JRYXRD2CgZQZrfvrpbNCPzW
	 5NMGxWKPQJ/JQKdpsQg2Ci3LaFK4ek3FeOCze8sZmltIKjcf8K0XEHmd1U3RE4mrZDyEz
	 ab5B9zbKNgYpHMyR9qEu40YE5dKjeXTmkQN81xEVhrxFAoLmkKpsBFUgE9I/RV3VxwrIk
	 ZgzgjBFJLtGv/r79AiK6S9Y5XwKM9jZNmYmEHhBS/S+h0zdeAviuphgVP0X+ywMnColJk
	 zmNbcR7/T35UkDSzDkTI71pElN/MeZfqqWu/6mgf68tlLuUTHTIm+1Em3PGjr9UZU8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793537946;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pIfNXUUzAnEW9sxlKVU/Fkq4i4DueIMJmUOwFcKXTyc=;
	b=dbAmNDxTifMf0K6QHPFKFalD3umtuKx3mJANiP5t8olCDiCPWhYlLSwvJJpQDoryQelj
	 BG2wamqth4Jol98Uah3r3kH6nZDBZiIxT4LbzjPqWb+IOr9YcX9LIsbwIQQmNVmZJDnz4
	 Xpd48xdX6BH5MiyIOuwC3yd7pHtNjg/4o9Yr3ZmfMqE1IeWLjAPis9IxLkxsH3DhDEZeG
	 fdwlu87eh3EZHutDsHx9fpDR0NWjloUFa6peArD57V5+PyLKaLxYbfssij8eE7oG2dJOC
	 VOPMuGPg7rI/Q2NN6K2v/tVkFngfK7rIDfCYC0ONMBgzAb5mHwKpnZGOJ4eYMst9hfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=E5EJZPSK;
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089C3606A333;
	Sun,  1 Nov 2026 12:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 089C3606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=E5EJZPSK
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 9B01880715;
	Sun, 01 Nov 2026 13:59:04 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id Ln5FNz6_F3d3; Sun,  1 Nov 2026 13:59:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793537943; bh=08DVDeHKnEqf8i6ckLfRqESk5630Gfkt4/33SEzgJpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5EJZPSKJCuDhs5OYCMjPhWYXSovkPubjVeWJODxe5wLfoQRXEowyHQw22Ueb3Afn
	 8jiTiS5SCXQT/VNRWxg1DjepGNp20ZBE4kXLJnf5pfuayUtVDXGySCGuoJ+iqWvO21
	 aRN+kGdaRba1bz8gsNILN1Do8BYHsi5eVHXV9ifarT6l2bfOrzET42yZ2xlTPacUjI
	 hKKvb6DTBL1liC4bcMz8WaI+jBq6j/Ri7oEjbvyKN4J8cP5C4qiz+BK0Su4GCkHAdt
	 qAunr/V77sBvwiWY6VUEnV7hOCQpCjwZdfvrhbsMq9xlvunVVwr2Gjx6aO2nZzrKRh
	 lyBkrx5tk07kA==
From: Florian Maurer <fmaurer@disroot.org>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Florian Maurer <fmaurer@disroot.org>,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: [PATCH ath-next 2/3] wifi: ath11k: depend on RPMSG instead of selecting it
Date: Sun,  1 Nov 2026 12:58:02 +0000
Message-ID: <f3a540b59266f444ccdf0be22afc9f29edb7b967.1793531790.git.fmaurer@disroot.org>
In-Reply-To: <cover.1793531790.git.fmaurer@disroot.org>
References: <cover.1793531790.git.fmaurer@disroot.org>
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

Commit 32ec8488d75d ("wifi: ath11k: fix sporadic WLAN initialization
failures") made ATH11K_AHB select RPMSG, QRTR and QRTR_SMD. Selecting
RPMSG makes it impossible for ATH11K_AHB to depend on
QCOM_RPROC_COMMON, which is needed to use the remoteproc SSR notifier
when ath11k_ahb is built in. Adding that dependency gives a recursive
dependency error:

  symbol RPMSG is selected by ATH11K_AHB
  symbol ATH11K_AHB depends on QCOM_RPROC_COMMON
  symbol QCOM_RPROC_COMMON is selected by QCOM_Q6V5_ADSP
  symbol QCOM_Q6V5_ADSP depends on QCOM_SYSMON
  symbol QCOM_SYSMON depends on RPMSG

RPMSG has no prompt and is selected by the rpmsg bus drivers (GLINK,
SMD, virtio). ath11k_ahb needs one of these transports anyway, so it
can depend on RPMSG like QRTR_SMD and QCOM_SYSMON do. QRTR and QRTR_SMD
are still selected.

Signed-off-by: Florian Maurer <fmaurer@disroot.org>
---
Build-tested on ath-next with [1] for arm64 and x86_64. No functional
change for configs that already have an RPMSG transport enabled, as
IPQ8074 and WCN6750 do (GLINK).

[1] https://lore.kernel.org/linux-wireless/20261018210153.1925962-1-julius@bairaktaris.de/

 drivers/net/wireless/ath/ath11k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
index 44b520d2e66e..84b7eb5df253 100644
--- a/drivers/net/wireless/ath/ath11k/Kconfig
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -14,7 +14,7 @@ config ATH11K_AHB
 	tristate "Atheros ath11k AHB support"
 	depends on ATH11K
 	depends on REMOTEPROC
-	select RPMSG
+	depends on RPMSG
 	select QRTR
 	select QRTR_SMD
 	help
-- 
2.47.3

