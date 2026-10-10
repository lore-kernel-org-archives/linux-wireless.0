Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0328B7EA
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 05:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791609098; cv=none; b=TtK5cv+NixksiI64EESqmTmvpf8CKAs7zc5sxDmXAOcuDK18vgnvQunp1IIJg9a9cBOcMzpCnki855jKpOvN400Da/ekVKV4ctl3YEc318XUplroPJqjvAepecShQwj6+UjgRjRzMnMqbTMq7olYvaZr58Wvwovti3w76pnLOrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791609098; c=relaxed/simple;
	bh=MPMOwI0vvc3InXLYmyscm1qhTxNxhoj3Og1mIRJVW3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y8n+1JllhnTT0BNirK/cE+OQpvckWlChf344/Z4Nvwq0YJ4c2j3aWI2IMd1NvlUZzo1Deyp5ppV0SKAVFVfYG51l6Zd/3shn3fjYSYHgKP+UFzH4J2l7Yw+CrhaWw4HlkODARBAJAxvooSLAHznU3C7if8XOa5hGO/LnNhKYrH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=MIrQUGQm; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="MIrQUGQm"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-141395927feso577753c88.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 22:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791609095; x=1792213895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EPzUTBNIsG1vnWSfHU0KClPEm42wHLDDcUKF5FSqaVc=;
        b=MIrQUGQmn1voPhPxsYHh+FVhHCvL6u0DNJWUTSgGPauArowvGdvRDvnc8ZLjFMccUb
         amFixag0+zpNQQraVOq0msl0A34p8yTvF0lgNk60eO8d8rrsFQO9lNDyBOuIRFtgxQ5p
         VDh07T4dNosr4ajAGtU86HjCiPdzlrGhwKZFlN0mpa5sjqos6kG05YgZmk1pqpTWwNSH
         L6HEEIOOfNVQczTkpPjOOwMcbj+4amxlULNAcBGMD560wLKECi1RAWD6gZgnLtiVFY2D
         iS+qRoNf39Uzi7yQWRqaquVN2+JOlwCiKDGGJTTYKkI0lWvYN/9Fg0rgAwSQxb3m1/Vh
         gkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791609095; x=1792213895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EPzUTBNIsG1vnWSfHU0KClPEm42wHLDDcUKF5FSqaVc=;
        b=UtoiaovdHwuM62uG9DS+sbn4xOmqHhGkRUYte+LsJmuge28N0/DiFimLpEJ9ORLSab
         eVgSCUAnWF2SrQ1x5ZvWdpTRdkB0L5+/yh2G7ZoPB/WEj6WvTuC1TqbDp6XUXzDZYOvG
         41exgLPZ7ihMXiwL96foSnC7H5sFdOIGSmKysr4i7oIcaTXN17KEyVjDSKKDDOPbkffj
         2xbyQ3uWk1gV6LAz6NibUb12is3xZi/UKxJCFywMj3uB007bcuCUXOEpzJ9AhsLaytGD
         y/vRR+Nsa8GvPyH0gAvvuR8YWARBg1E1MbZygmGWenZ4XKdPEdZq4vf9Q7yy7KFsEKoD
         2uQw==
X-Forwarded-Encrypted: i=1; AKwUvBxF23pYD56Zx2BeJP2DvI5a+IYnOnBKRLGZ25++JoX6gLLnGxSfEmC5o/n5/1FKuU4JnqA1za4bHclyX66oTg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKboYVbx1eXqKCWY8vA+ygKVsmVOWSBpdLyHD+7tRYdsQnBsNzu
	FvMIZrVRea+pzjprZys9c4c03hhOctQIX9rFwlApRnHWRiA+RWJKxdwZ9H9y7bjsS6L2Q+9N+5E
	z3Ujxn1oJeA==
X-Gm-Gg: AYBFou0Idmeg61iUUdPVMzbmb1nGyNKEQOvFbuQe6wUx5PD4C8blDn8uU3dBVWe6kbw
	ZL1KVVpzBG832a8/HKlcWBGE5Gd5sgDaBXeGFVVR4hNIc7WDAl2RT7eEJIkj/ucBwJ+ZhJ0/GmR
	HdvkqgMMSLJI+KgYR2Mzjf+FrsJdmr0MYgL4UJopCfwYB2xoacGeTn2PeYiFr8p9h4oGucfjAkV
	bfH1mxVMhLJdHIDvqE5jBH6EfhHSCl5ifUogb8NpeNIsZmStltX5K4DWbjzdt9Z53jiGWjrX/Kg
	2yxi2pRZRclOK8zhkHnHf7LTR4FNOs/lRUgq9FfZPHjWTuZamgG+gD/7RU/210w/BnyGSy8p0m/
	acWiYb+LKaVseF0zot6ZomEiFdKI+X283kvGFdR/J+YyhgtFHrXBWTec0geyqzG3tVVZtgS8xT4
	eyg/8eg2SXGVoRcrzfANoYfVwxyviqINczTNmZdi/AfGpsLCM1b993SbJ7dCOXvHFlng3o8ymC/
	HMwGVs7Kc/17GWkS5zi1wvb4RevnyfUSjB8Keo1eff4yS+5eaO5a4YTXWVCkPMkbp/PI/Q=
X-Received: by 2002:a05:7022:7f0b:b0:14f:4b01:40a1 with SMTP id a92af1059eb24-16a4f627a7cmr5226042c88.0.1791609094685;
        Fri, 09 Oct 2026 22:11:34 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:fc0d:3183:3e45:a830])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a1becf08sm11181963c88.5.2026.10.09.22.11.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Oct 2026 22:11:34 -0700 (PDT)
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
Subject: [PATCH 6.12.y] wifi: ath12k: fix reusing m3 memory
Date: Sat, 10 Oct 2026 01:11:29 -0400
Message-ID: <20261010051129.14918-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
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

[ Backport to 6.12.y: drop the copyright-line hunks, which do not apply
  to 6.12.y. The code changes are the same as upstream. ]

Fixes: 05090ae82f44 ("wifi: ath12k: check M3 buffer size as well whey trying to reuse it")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251029-ath12k-fix-m3-reuse-v1-1-69225bacfc5d@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and ath12k maintainers,

Please queue this for 6.12.y.

6.12.y has the bug this fixes. When a smaller M3 image is loaded into a
reused buffer, m3_mem->size shrinks to the new image length, and that
length is later passed to dma_free_coherent() instead of the size that
was allocated. The patch also fixes the allocation-failure message, which
reads fw->size even though fw is NULL when the M3 image comes from
firmware-N.bin.

The fix is already in 6.18.y and 7.2.y.

Testing: applies to v6.12.112 and on top of the current 6.12 stable
queue. An x86_64 allmodconfig build with CONFIG_WERROR=y is clean, and
ath12k also builds cleanly with W=1. I tested the M3 load and free
functions in userspace with firmware and DMA stubs under ASan/UBSan. I
did not test on ath12k hardware.

An LLM helped prepare, build, and test this backport. I reviewed the
results.

Thanks,
Artem Dinaburg

 drivers/net/wireless/ath/ath12k/qmi.c | 9 ++++++---
 drivers/net/wireless/ath/ath12k/qmi.h | 3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index b93ce9f87f61..5b02d1d76a36 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2724,9 +2724,10 @@ static void ath12k_qmi_m3_free(struct ath12k_base *ab)
 	if (!m3_mem->vaddr)
 		return;
 
-	dma_free_coherent(ab->dev, m3_mem->size,
+	dma_free_coherent(ab->dev, m3_mem->total_size,
 			  m3_mem->vaddr, m3_mem->paddr);
 	m3_mem->vaddr = NULL;
+	m3_mem->total_size = 0;
 	m3_mem->size = 0;
 }
 
@@ -2762,7 +2763,7 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 
 	/* In recovery/resume cases, M3 buffer is not freed, try to reuse that */
 	if (m3_mem->vaddr) {
-		if (m3_mem->size >= m3_len)
+		if (m3_mem->total_size >= m3_len)
 			goto skip_m3_alloc;
 
 		/* Old buffer is too small, free and reallocate */
@@ -2774,11 +2775,13 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 					   GFP_KERNEL);
 	if (!m3_mem->vaddr) {
 		ath12k_err(ab, "failed to allocate memory for M3 with size %zu\n",
-			   fw->size);
+			   m3_len);
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	m3_mem->total_size = m3_len;
+
 skip_m3_alloc:
 	memcpy(m3_mem->vaddr, m3_data, m3_len);
 	m3_mem->size = m3_len;
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index 0dfcbd8cb59b..e9eb186441cc 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -118,6 +118,9 @@ struct target_info {
 };
 
 struct m3_mem_region {
+	/* total memory allocated */
+	u32 total_size;
+	/* actual memory being used */
 	u32 size;
 	dma_addr_t paddr;
 	void *vaddr;
