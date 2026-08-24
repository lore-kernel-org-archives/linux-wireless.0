Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9540240F74B
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581474; cv=none; b=fSEmYC+UjjNcNmG4cXlx/N6q9bliZbXbPoOby9bODp5Sn+2WhlW2HWOIMpkbRA7470OptkcfCtQB0iTmCqOhc7zPA+Qc2VW7Ni+02CIMHoKJwlerj0OAfrAqRpmmZa0q2uqT9D9ogFULLhIxrRiL9rFRljvM8Nz6r7hcnl/kWHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581474; c=relaxed/simple;
	bh=8aX8jcwue7vsqzSOH5L6v0CdUfBEnLitNpQPDNzgBf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tb9Ioz4g7cpqOXRQUbFVnRhrrQ/nFoapUqVDysw6B9Zh6d+2nWb4sQcxS2J3i9GHNoXanj6CjMsTemDWn+bay1a5WQFPQwU3/TyO8FP+BheWzKC4rCoZaM14FOROI0MrrJyekrQMzaph21lSgkjgrxjGzi1xAjWbSjWomGjjopM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=eL0A0IM6; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="eL0A0IM6"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15cd3fd760so425051966b.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581471; x=1788186271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZXlIR70MotY7OfT34O+UemzHWb+H2mqTXl+J9INafOM=;
        b=eL0A0IM6DmjckMnLoVjWfI7peEuBXc1Fj1Wp9+eP3EHj6dSK+wK8pQQHRAz57a566L
         MX1UjR5LUEDQDZuxmONSchrqzjAY/CkFIiuC0Jw51paKu2MFsua9lAOHpF4jhlItuWOa
         2j3d8vZ5M9LUahaXjyOe8DoyaMOG1bPYVLT69IyEJm7BVH0zJjGQTwaZ37n63zc/McUm
         YmAXPMBy6Q0C0kF7zM/il4uBmzLiN0H9FnTABKgdGmpXyFKLR6Qsn6Fgk44org4Im7Rl
         OH92T5EOqj1X1ArwcxGTEmBYZK2EzM1Ioa/QMzxPKiyzTppbD43UI0CrrXCykhW0SjHI
         I7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581471; x=1788186271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZXlIR70MotY7OfT34O+UemzHWb+H2mqTXl+J9INafOM=;
        b=NlJpyvGaYAU99GqupgsnODDRKTBzzNAKM23zjfRLh5sbjm4N86qjT1IzNM+Q3NhGiT
         gFWEnRMIRn9t9leQSI1uZ4DHJb9DDJkYP46ZeWXDnZNXxI7/bkI/QJPm2ZEUj0b60TGV
         N+eGS4B08AVxLGmPOD3COj6ozG4Hmk4fepcAJEQmzlnNNJ//qGklkFEpnVlzZ2DnVxly
         WkL1joseZyZ8QnoR8mFH2NiNBOsacklN4H+YH+uviLumAlsF04m37EeEazCJcNDvGpIs
         bY2tRhO7WyPGtBw1klwmZ00G8uAoh4RTAEubzmMXX8KZHV0pz5QxaRwIrl5xJ8eJPgHZ
         brQg==
X-Gm-Message-State: AFuF++l61q9q7fdyKdzvbqGfffgpyVn/ra0QrEfaT2VV3oyUYZdO+U05
	LAqs7SkY3YzNIv1/G19mOYkX9S50poWiOpg8Bew+Lj14rgMo+02N3b14kdRnQeh59A==
X-Gm-Gg: AR+sD12huzuwnlXaI/tv2AbpzSfnQoCPPf5lIKM/U8r622dLAAo2uvVgJxtrpdyzdWU
	r9pTXr0XT3mXxmfLLkY3JFWuYERgSBF4Gun0QWr7/aiv6ohxq6tkFqOmQ+DdbJuW2JOedP59j0g
	QjK4SVFtB1zO1aUhpiqwkBjdT+m3vqoyx0q2nfQ+u6ZR2yJOXyHJFFR3dZDpxocwEe5uc9McWZT
	40z5pSR1QdKtLDCUcwFuOzibhjs1lWmF71ufIiFlxwV2EDGsUGJRPCJ/YtivT73B8fjsU7dA9cm
	K6DovO8QcIfwCGEjyTzZJ0ywTUb/fbFaWYgd38aB3VasfNm13Zn9Wh/QPvweALmCm6lzBw2kqPY
	q91pd2eqAC8vZw4SDyRSqFMPnW+pnC7XVFuqUvzmRXDgCxE+/le95OMA+7ecnIvLzunE0FVtn1h
	kGKHwVUJchzJ7MSGjbuxW5XssCM9Um4v4FaFHvsA7NeYaC3CY0H0XypMHRDJQzhVxFMgLrzdTct
	nWdsw3igV+IjBkg/QFbDFOVisRAZw0vav2HyLmtIZBNeS2qMdn3JQ4LRVnl3/mDxZbrOlCfFwnY
	kQ/D+G/msqrJh9nAHl7EMg38q650eAcBK+F6kt/kcv0yNGvRZwf7rLzMk8WHIPnRATyYrVN4AiG
	9bfDzPx002ssFm++njVYrXPwsrNk4RsxACxfn4ufOl9/xIfdnPJgCcZ7yxZ85KpE4ebKlxfDi
X-Received: by 2002:a17:906:6312:b0:c24:6445:d19 with SMTP id a640c23a62f3a-c24926f3cf9mr2273907166b.17.1787581470246;
        Mon, 24 Aug 2026 07:24:30 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:29 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 3/9] wifi: ath11k: report the pending tx MSDU count in soc_dp_stats
Date: Mon, 24 Aug 2026 16:23:44 +0200
Message-ID: <20260824142350.1757379-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824142350.1757379-1-julius@bairaktaris.de>
References: <20260824142350.1757379-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ar->dp.num_tx_pending counts the MSDUs the hardware has not completed
yet, and is used to wait for the transmit path to drain. It is never
shown.

soc_dp_stats can therefore say when the transmit path overflowed - TCL ring
full, misc transmit failures - and not how deep it is at this instant. The
bound those counters report against is the tx descriptor idr, one entry
short of DP_TX_IDR_SIZE per ring, which is large enough that occupancy
rather than exhaustion is what characterises the path under load.

Print it per radio, beside the failure counters it complements.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 70922612d3fb..9dc586b68136 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -714,6 +714,18 @@ static ssize_t ath11k_debugfs_dump_soc_dp_stats(struct file *file,
 			 "\nMisc Transmit Failures: %d\n",
 			 atomic_read(&soc_stats->tx_err.misc_fail));
 
+	/* What the hardware still owes a completion for. The counters above say
+	 * when the transmit path overflowed; none of them says how deep it is.
+	 */
+	len += scnprintf(buf + len, size - len, "\nPending Tx MSDUs:\n");
+	for (i = 0; i < ab->num_radios; i++) {
+		struct ath11k *ar = ab->pdevs[i].ar;
+
+		if (ar)
+			len += scnprintf(buf + len, size - len, "radio%d: %d\n",
+					 i, atomic_read(&ar->dp.num_tx_pending));
+	}
+
 	len += ath11k_debugfs_dump_soc_ring_bp_stats(ab, buf + len, size - len);
 
 	if (len > size)
-- 
2.53.0

