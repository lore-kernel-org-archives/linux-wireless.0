Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3338E36C0DC
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824377; cv=none; b=reJQldJjMc19Wd/N0eCaYt/XAvzj0b9wpUcllrCyhiPkcphG5YUss7H4HC60a3+Zx3i8nqzdL05wgXIaHilKzKBxDjw9C7aAPB9TZWhsas0ByL10LPCA1QpA/AW+SHXpSsPSmjCwiMWcAcd0+fXPB4OibMQE/poWCiE48y6SN38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824377; c=relaxed/simple;
	bh=aN+xbxj0aCkAihbURhNM4JHsv/Tq2X9x16GY4E9Hcek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZXvsaXQIm8eRLb4DXwQJWpyLwMHuCO20Qq8pE9VyXazzTTKI2NPbaNf5F1clezQcyF6JjS/qUv8BhzjeFJj0/DJ+GHgGU872Rsd/ZTJiSwcQQV1+7XE2+3opqOFPNPXvQVtsnY3cbSb2gvZ+g0KuRcupW3/IGiLS4V7SFSRAH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=Fajt2Zgt; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="Fajt2Zgt"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso289237eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 09:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791824371; x=1792429171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B50ZIxaB0P1k35+NQhIdQPJS8AyS5zQSlPA1ktBSYzg=;
        b=Fajt2ZgtncbSzzBY2Ju3Jj7YIs/NLO8mirQlV84+hg7Ue/PGIcmCgxzlbGpPbEGDRl
         43raNW/5y0ZVFvjFyDuFXqUfCL38ygMJQJZ2Nr/CH+uf0E3VsUNhUvNj+i2h4vOrbDj3
         JhYatY/fOJpbE0/5hgLmc9B6S34pNTibMS/MhObPlFAQhYrOL4yNa/NnwgUwJ/CsXLjV
         zn9kuZQNRICxcWIfWpzksnYZ7ef6+XrQfUXc+RyHMHnYUsQnasLurv4SwRGK9rExkTZg
         oLuCs3K3LWiEulqNwDKBECZslN0ndSc3EZmorNXYLZaJzV0qtfJ5GEuqDVyr1x1KVSP5
         QWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791824371; x=1792429171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B50ZIxaB0P1k35+NQhIdQPJS8AyS5zQSlPA1ktBSYzg=;
        b=n6U2iVppn5tyD1jYp6KFa1lb+yBnghJblPK6DwU75k5vSPj5ZQCmUYSszlkD6zI6u8
         oN/qTE3mXCXD+PSJQIz5O/GUy57TI2mYXdnRscKoJcBLvbnttQElxSXOCBRg71f+K2q2
         4PIq00UCXkYcPgZIqKzbQqVDCDDq5XyuWJ3KiD+d/8CYEVml6ggjd5uydKh0tZ3rpcAB
         orqRWT9HrdUEsW6QxGYhxfk95bYYqf5jMQoDedTtG+RRIgZ+mlZyBt/3uQDR4xDcaesG
         +esYQonqYoSeNBOYqwDxvCWBx0vf9Z1kwPh7diGG6qMX81md4j9IyOCfD+peStUumlek
         fC4A==
X-Forwarded-Encrypted: i=1; AKwUvBylPWP1LDxBkwn+Wn4cQagkiQw35UrLnmsx/tl5RwgoBcdI/o/QzninmCJ2XrsSMJ85VqDmCVNEqLIzgBIc/g==@vger.kernel.org
X-Gm-Message-State: AFq9FYLhj+TOvvTetEsDuPGsy7Nxg9qt+QOYZbZMtzLG14UmBp/+9/dH
	ZZlRQkqd10f8V1Kub3IXirDBDFdDaW1Hw7gQ/eW1Qz1n+8YOboQOKMFPelIzZf7QupI=
X-Gm-Gg: AYBFou3genjZfcUAPTLC7xys6yMJNaNlHyCBgdWfh+BvVvRU0f9vD5EgUUiHV3mV/Yz
	GvN938v3Q6dllyNKwlCO/DkqH/WJ7hnF9o0YUNsc/XvN7eoSpUqznYro7hNDrCme7V/bbx5K9y0
	qeMg+4BwZXmDBly3xf52jlkhGnfUO3PF0LDR2CPt9086JEC7BxRnDqQWoFtFkUcd3R3nHPYakTH
	56tjTtWjV9Vc7qHFef/yiVjzP3yjoLGj2TsOfjKCMypsuTqhcuOLi/9oyfpV1S1G2o61p7iORc1
	xCF00YTpMTwnYo2sTwNsvpXrHk8vznls489wgEliy0GHHe48As9CYRdOglfKIsD2M9tPV6T3mPK
	RnebhhaeRKXHuKG+pm1COKk1RVuaTM3fP+cf1CWn3C+puEHtwb7Dg0zoL4+y4wHCz5605DVvxJ1
	2CpTepAT8X0F9AqB/hqqKeGI/8UJ3K/AcecX60bZ09lxTDJsglAJU3+lzpAn5yjVJ0o9yZ4lUmx
	TmzE2QIVUsU4be4J0MfN0rITYXy+BXIsRbYmYeWV0pX5zTBVhOmo1T9G/nT4aroCQ==
X-Received: by 2002:a05:701b:2058:20b0:15c:20b8:7964 with SMTP id a92af1059eb24-16a63386d86mr14785713c88.27.1791824370766;
        Mon, 12 Oct 2026 09:59:30 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:1464:826f:d188:9e33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2fd33sm34296900eec.28.2026.10.12.09.59.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 09:59:30 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.6.y 1/2] wifi: ath12k: fix reusing m3 memory
Date: Mon, 12 Oct 2026 12:59:24 -0400
Message-ID: <20261012165925.32575-2-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012165925.32575-1-artem@trailofbits.com>
References: <20261012165925.32575-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 00575bb44b2c2aa53d0a768de2b80c9c1af0174d ]

During firmware recovery or suspend/resume, m3 memory could be reused if
the size of the new m3 binary is equal to or less than that of the
existing memory. There will be issues for the latter case, since
m3_mem->size will be updated with a smaller value and this value is
eventually used in the free path, where the original total size should be
used instead.

To fix it, add a new member in m3_mem_region structure to track the original
memory size and use it in free path.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

[ Backport to 6.6.y: 6.6.y only loads the separate m3.bin, so use
  fw->size where upstream uses m3_len. The upstream change to the
  allocation-failure message only matters for the firmware-N.bin path,
  which 6.6.y lacks, so it is dropped. The copyright lines are left as
  they are.
  On its own this changes nothing in 6.6.y, because the reuse path
  currently returns before m3_mem->size is updated. It is needed by the
  following fix to my 6.6.y backport of 05090ae82f44, which copies a
  possibly smaller image into the reused buffer as upstream does. ]

Fixes: 05090ae82f44 ("wifi: ath12k: check M3 buffer size as well whey trying to reuse it")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251029-ath12k-fix-m3-reuse-v1-1-69225bacfc5d@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 7 +++++--
 drivers/net/wireless/ath/ath12k/qmi.h | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 48d0043fcee9..86cc61dba094 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2518,9 +2518,10 @@ static void ath12k_qmi_m3_free(struct ath12k_base *ab)
 	if (!m3_mem->vaddr)
 		return;
 
-	dma_free_coherent(ab->dev, m3_mem->size,
+	dma_free_coherent(ab->dev, m3_mem->total_size,
 			  m3_mem->vaddr, m3_mem->paddr);
 	m3_mem->vaddr = NULL;
+	m3_mem->total_size = 0;
 	m3_mem->size = 0;
 }
 
@@ -2542,7 +2543,7 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 
 	/* In recovery/resume cases, M3 buffer is not freed, try to reuse that */
 	if (m3_mem->vaddr) {
-		if (m3_mem->size >= fw->size) {
+		if (m3_mem->total_size >= fw->size) {
 			release_firmware(fw);
 			return 0;
 		}
@@ -2561,6 +2562,8 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 		return -ENOMEM;
 	}
 
+	m3_mem->total_size = fw->size;
+
 	memcpy(m3_mem->vaddr, fw->data, fw->size);
 	m3_mem->size = fw->size;
 	release_firmware(fw);
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index a996c6d57aa7..62c7a526f111 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -119,6 +119,9 @@ struct target_info {
 };
 
 struct m3_mem_region {
+	/* total memory allocated */
+	u32 total_size;
+	/* actual memory being used */
 	u32 size;
 	dma_addr_t paddr;
 	void *vaddr;
