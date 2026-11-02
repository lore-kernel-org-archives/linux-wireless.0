Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649822;
	b=boxTSxEooAtAtAYCHKKMHVgNiZTiDKnGWt7TmnAAxz4fkj41HX9xqy5+gRBnt9NROIUp
	 3BP+ZhxsahhWoogpD0Ipsd5i25ueG5m20BYcwDAcYm69+TeOm6E6M/BJzXlf3GRo2Hw6e
	 JB8fU7EINiyhdWEIjoEJPwNtgOlGlH+mZVlHKMt5h0+4yiX5HjCsPOMbDUBTARXQBdg+O
	 pQa6IAHLHnavl1wZEmynr2rgGezIdKCbM24KjLloPVUITKwu3ucGriVGiIFZ86GYeS/d4
	 OYW6tbXp1FK+J97x7v48RLEZVVdupOJTyuQ9JuTiEN8H/y0ojWeHXhb5mtCE+y/RwcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649822;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D/Ms9ONYznkwN2YshUZVtSjU9I6nxLEmmuHZPDFXFTY=;
	b=N90+cTjUNIv25pLrs40uQ4zVqIfJsp8ie95Fam/SbIQ1WCa0tbKFKLWh14+BJXUhMy/s
	 joIIec3f7gwqcEiCu+Mfi4UABqrOWcrKzSVkE1dwTxFEZk6wm+cYTXtKyhk4oRnYbnF3L
	 yzJjO58QV9RE2kkeipay3lLrxNzeAkBPWzIwT47HrEO0pixQwIpyolETLzrKFhw4xaFx2
	 dT97SJfG4YkDmufDWmf6Pp0ZY9JnlEqwg8ep4Vhp205DKerw4KBxnJkTy5PFuhUo+bzRI
	 jz7xsIghHyCrVpQIM+Xok+XREFK/bS4x6/PxqmKR+RKefAhspUNCE9Pw4aFuxc2BC4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LkHMNo61;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E094606A32D
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E094606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LkHMNo61
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so3527468f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 12:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793649820; x=1794254620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D/Ms9ONYznkwN2YshUZVtSjU9I6nxLEmmuHZPDFXFTY=;
        b=LkHMNo610oiWCzS+1m/1PUvgxODcRNNRZlzzhI6gsQC8v5zGfrPiqF0zIk9w21BvjP
         n9hRpvtqfYewStOURLOmqFvb3TdiFkBw9jn2Ms630KDJ+VjP0OSDZcwB4zBkBK2FvZx4
         jIqoLnT81pawmzS1ChPOPVUkFV8s3eKT1UNWboyZSiDnjskDfX2c7o6WqKpjRuyOMOdA
         hoMDc7m/5JR1iQB7s8O7Nu4dDHFSo3aGrkjMCSY1nV/l0ZtgZrAvU4NojeT/Hh53IKCQ
         wCxHwIz5z5J6QPOR7xKt4hh8kg1fGJ9o3Di6095bL42Pzh3RUu/XKMpkagxxevxueY88
         FyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793649820; x=1794254620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D/Ms9ONYznkwN2YshUZVtSjU9I6nxLEmmuHZPDFXFTY=;
        b=PbzWAZivizZNAbdWCULXLjirDuFdh26ZXxQwmfnF/kL8w+F7iYC5gs5POvSSjfD9kw
         M4gY18/Ts98UEQVCuniFoBeSKhGzRObjS05kxdhCnha7uQC0+MQ/7njFW+aobMy84Xo7
         3BdzsSAGU6HMokUMpId0IKimCNCOYZV9TRfMVWTCGoQT2rHhnZGFKgl2q4IlmpgLMRq2
         t3+BlWt0PYJqt/gLu3f3IYaESlewpKyJ4lVweW31yeKLyfBI8Yu81Pz43q7gEKp0PKJ5
         E2wtUf6PpemPBcui9/nPNTNbQ0N83XuHl7ddgiSut+VKeRm2ZeY/alv2OoylyWMUJ/xe
         EdqQ==
X-Gm-Message-State: APuU4Z8dqcb0eQ/gigWLD0djsn6HF/xmh6iC9fdNRU1LZRvaZ9l2d+i3
	jSYXW3gV62nCXcvmeJ/7V2fEJxguXD3LIIs/Ph5VyaR//2WT5eb5/gB/
X-Gm-Gg: AYBFou3nWvgul9G8Exda2NjJdkWGRK8yL9E1+6aDpGp3ybgRXUZ27vRkZ0wWiyp8TTK
	vA4WgsH4J2m6AKb2AH7QQXLxz//blZ4T7ByOGgWZqT+0dmhfvyZ7gnie2Kjfoa+cr51w5u+SU0E
	LuSlGwLMszB/KP8bzfjexnKJO3P+BzTuyu4hsv1/CMy8pS6/QBDMkXn3cDWMktVy56d6TmkxMLL
	X3OCnmWGMLQTEhh4+LhNHf7NKdm1tIKSEKLjyHHQ026GjOBGhivoaFpQjG8G0gabRqMwoxGq8OE
	hH3g9bhwtWdunCfZUP0V3UR8OwHEpiFLT2qhAkm6mfpAckDlJvSc65gmfsEiUVIMT9AVz36nfU4
	ajXgLR59e+UvchiabQdZd3rmHHAEIa7OII4EIyeiZrNXB1DL5eLqaAoauVHUVGbnt4tNN97gPFh
	4wkKMfB0/90PdAs6vDQOKo1l7tcuY33RmbCoBw6MRLb1uFcFAv/KfoI0z0dcWtoiPKYrjijWY8Y
	8L0jaDKeutjjPyinoX3Ua2E6Sjk56hkKYwDZK5meAhUOYt7qj8ybhzRuEI+CXp3jF6CsN1YZqmk
	3Tt4mpldjr4LbbtoznpnVzOnRIvcR/tGgg8IdaA73o/Dl10C8t3qzOeInn7RTLFQ8IdP04dqcNp
	Cr/hCZDEJewM9Z5zwhHMVoDK6P14RDHIj3L0V3MQKW2hgfkjdyEHq+G2mj2MBjvLMCgJS43FAOz
	F/0GI7QCkODS8=
X-Received: by 2002:a05:6000:1786:b0:48e:6c09:cffa with SMTP id ffacd0b85a97d-48e6e50b221mr26395521f8f.48.1793649819769;
        Mon, 02 Nov 2026 12:03:39 -0800 (PST)
Received: from ADM-D9YH122JTV.home.lan (158-199.dsl.iskon.hr. [89.164.158.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9b54dsm21191574f8f.47.2026.11.02.12.03.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 12:03:39 -0800 (PST)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: [PATCH ath-next v2 1/2] wifi: ath12k: report no AFC memory region to firmware
Date: Mon,  2 Nov 2026 21:02:34 +0100
Message-ID: <20261102200235.48973-2-gsustek@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102200235.48973-1-gsustek@gmail.com>
References: <20261102200235.48973-1-gsustek@gmail.com>
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

QCN9274 firmware WLAN.WBE.1.6-01243 requests a target memory segment of
type 0xa at every boot. The driver does not know this type, so it logs

  ath12k_wifi7_pci 0000:06:00.0: memory type 10 not supported

and answers the request with a NULL address but the requested size.

Type 0xa is the AFC region: QMI_WLFW_AFC_MEM_V01 = 10 in Qualcomm's
wlan_firmware_service_v01.h. The firmware asks for 8 KiB, where the
host places the response of an Automated Frequency Coordination server
for 6 GHz Standard Power operation. ath12k does not support AFC.

The firmware treats a region as provided whenever its size is non-zero;
it does not check the address. With the current answer it therefore
takes bus address 0 as its AFC region and maps it for its own use.

Name the type and answer it with size 0, so that the firmware sees no
AFC region, and log this at debug level instead of warning. No memory
is allocated. With this answer the firmware sends the memory ready
indication, reaches firmware ready and brings up all radios.

Tested as part of the series.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Signed-off-by: Goran Sustek <gsustek@gmail.com>
---
v2: do not allocate the region; answer with size 0 and log at debug
    level. New subject. (Rameshkumar Sundaram)

 drivers/net/wireless/ath/ath12k/qmi.c | 12 ++++++++++++
 drivers/net/wireless/ath/ath12k/qmi.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 817bd820623d..55952da4343b 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2755,6 +2755,18 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
 			if (ret)
 				goto err;
 			break;
+		case AFC_REGION_TYPE:
+			/* The host does not support AFC. Firmware treats a
+			 * region with a non-zero size as provided, so report
+			 * size 0 instead of address 0 with the requested size.
+			 */
+			ath12k_dbg(ab, ATH12K_DBG_QMI,
+				   "qmi AFC memory region of %u B not provided\n",
+				   chunk->size);
+			chunk->paddr = 0;
+			chunk->v.addr = NULL;
+			chunk->size = 0;
+			break;
 		case MLO_GLOBAL_MEM_REGION_TYPE:
 			mlo_size += chunk->size;
 			if (ag->mlo_mem.mlo_mem_size &&
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index 1b1c88906f1e..9d9174c6ee60 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -177,6 +177,7 @@ enum ath12k_qmi_target_mem {
 	CALDB_MEM_REGION_TYPE = 0x4,
 	MLO_GLOBAL_MEM_REGION_TYPE = 0x8,
 	PAGEABLE_MEM_REGION_TYPE = 0x9,
+	AFC_REGION_TYPE = 0xa,
 	LPASS_SHARED_V01_REGION_TYPE = 0xb,
 };
 
-- 
2.56.0

