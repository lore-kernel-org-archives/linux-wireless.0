Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1929D2D3725
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 11:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785584962; cv=none; b=MA8HVKaSS3g7blqZOqiaz2hiYEc7SpWznFzSfeuuhdjItVaD7lg/ewOdKlYp04CwpkdrqE/7XiRQWwNhLE5RL2F2Ad02HO+JHPi3P4Ra4bloNvrlDfELHCQYejUhcvxi/lvvlWDhak7ZQXHGXP5g0jz8X+jSoj0hyD4ZKC3Rh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785584962; c=relaxed/simple;
	bh=4yyAcVknUicAHnNFBh0eMnF/hJea/MMAc1JgVYj7fY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=utqnjleCagDIAWOAAH1n/we6NbLOVDv4RuG+MCdzP2BEYa7n2zW7Rmk7oW+dTDTaUALRe+eGdPdeAOZGi3K8dibGGNqoIRf9cvxJup/n8Y5MFdn75t6MbtbgeMXY3qdVAeFVtZtMysg8lgecOr/bFZRQ529DfUDLbK8hPVsatdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=TRhifgad; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="TRhifgad"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce98cb8165so19739345ad.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 04:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1785584960; x=1786189760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y/htim8H+8x9oNbHl26vDUAIesN+LBlNBvkdejEDGrc=;
        b=TRhifgadxAPmJ8/U0T62YS0UNymQDKERmTM6pNtHE//EmZ1tJ14HN23Q66I1ZIRlZg
         q+RD1DyKETOEEsNm9nQrRhCW36JXB9Egl65uJo1e0FzzXl5gAE3aLjgduWk/itkNe4py
         xFa9ac3gz9JilSRxQ3vmk8+s689CWVwiL/dN2e2CZCuitH19daimUhsqItQIsMObjQvc
         Sq8+4UteJ7R8Q261nRkBX8f/Kf2SWpH0ryxLrPrVMcUYxtvnlX76xAyqBUwAVwvBFqa6
         BcUOR6zZmgGSwDE88gse0jPwfzD/ih/nzG/sYDIIn9MKN0oCZviiSCRR6EtU0MGCgXGh
         8/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785584960; x=1786189760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y/htim8H+8x9oNbHl26vDUAIesN+LBlNBvkdejEDGrc=;
        b=WE1JTAuSga600KTjfslJFLmB7boRYlvuP+lq7qgrdS2LH883jdvVeeYaqhpH+n8goz
         JXAeZ4JFJAJl+oIm18eN/c8GRKPOdAgGFWoIyojGV9afapq6HWCk5lrvxfSs2GEu9v4j
         mcLGNP0B4XmeV1JwsCBQwWxM+GllzO60T3durfi2MT534ZzTgPG0cgs3ASJLVdg6BcgA
         sEwF4zN22fdV8NMPTalpcdIf/TkgSukRGRN9t65DittVBiQqdV8i1HZxvRxR8UL3hF/W
         vFJzX25/iWKj40kDoBmDjZrQScRu4Vy8vLJ7yq+fJXPSyi3bFEl7va/edQgEjRn66Bjy
         Y3vg==
X-Forwarded-Encrypted: i=1; AHgh+Rp83XQYEBSKqpCygZ7nGUnRuI+IJUblT14QAgi6uoDea6jlYXlJXvVVFjP8krAqHzHYJdVYARkGIFrUXQDNzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMIruh3QCbUiQ0b/fAI8KjVzCZwSEb0XU91dRPqKddPRhiwbOm
	XfgKhdVQta4FvOv2J9XITdNvJPz+kNTicaPu2ilO2L37MrELVpJyBcd2GRPWXA7q4Ww=
X-Gm-Gg: AR+sD13feClVc6npFfnwRg+yMAUa9rvC+1pk7HFKM2GanU/uwZijptJPVKcoDUFgUVk
	v0UIwF2fT69dvsZgTDix+goEVrDkkZGow64iywdXMgnBsAtVMKLMVmpVhbH3pFrq08c/rkP8jT9
	WN7UF7I5UG11tQBW7H/IQ7yEskcpLDv5X9usBVe2RdFZsUPZ1DWxVvU2eOyOo9f69lFtNx6goCB
	dfhEWRx9Nd1w1R3RNbquAlOBSImkDvPjZG8Q3AcB1QWfWovvLsGyQwVyO+JyJl9LZ09s0/mVSwa
	ORNI3GSkRLHCpZeKzOVC0cv6+uEMr1lPj0dlL2oky9j+Vcp0WgOEN2K2/CGJIZLIpi5tJy+ud9d
	iYiSvthaQmdNIrSQDbS/dteWfr1abXzMOg4t56yR882kRF1PnsSRo1j3rgz4fUXY4lrHbP0x02D
	ZgG+GodkHULaVh8DvzjpoAVSr4FJUsv9ZJmIY7dgWG3ZyIFvE6nyLoGzBuKXCaS2nPby80KaEQt
	6edXVbry/T8fKbF5xHivd2Or0LbUxVIeg7mJiEnsybdT1Eu1nMpVuLVmgJlCFzu/19a4g6dlV18
	SA0k4+agzTNueHk=
X-Received: by 2002:a17:903:350f:b0:2cf:461a:3863 with SMTP id d9443c01a7336-2d047e6fe24mr51267725ad.22.1785584960370;
        Sat, 01 Aug 2026 04:49:20 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-3153e06f8dbsm16967624eec.22.2026.08.01.04.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 04:49:19 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: jjohnson@kernel.org
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	baochen.qiang@oss.qualcomm.com,
	stable@vger.kernel.org
Subject: [PATCH v2] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Sat,  1 Aug 2026 17:19:09 +0530
Message-ID: <20260801114911.91483-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ath11k_dp_srng_setup(), the memory allocated for
ring->vaddr_unaligned is not freed in the error paths that follow.
Fix that by calling ath11k_dp_srng_cleanup() in those error paths.

Compile tested only. Issue found using a prototype static analysis tool
built on the LLVM compiler infrastructure.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---

v1->v2:
- Moved the information about compile testing, and how the issue was
  detected to the commit message, as suggested by Baochen Qiang.
- Add the release function in the switch default case as well, as
  pointed out by Jeff Johnson. Also add Assisted-by tag.

v1 link: https://patchwork.kernel.org/project/linux-wireless/patch/20260727105532.118164-1-nihaal@cse.iitm.ac.in/

 drivers/net/wireless/ath/ath11k/dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index f389b97acbdd..be65d73b904b 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -313,6 +313,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 	case HAL_RXDMA_DIR_BUF:
 		break;
 	default:
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "Not a valid ring type in dp :%d\n", type);
 		return -EINVAL;
 	}
@@ -324,6 +325,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
 			    ret, ring_num);
 		return ret;
-- 
2.43.0

