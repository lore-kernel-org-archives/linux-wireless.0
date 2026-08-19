Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C977F35A93C
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 01:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787103816; cv=none; b=Iv6zyrTDq024VEUQBj+s/bMoWddXOC0crDhfwgRcYeZfmE5T71Jy08KDUA32ujT/jO2uryHC9BYzDewau0d08vknfEfQZ4wtXvrZjKCpQBJdZDbgzNE/ctPGm45rHByH9u2PIiv+ccKMwhvGD8RnTO0v++51HlZvdYKn/+VCsAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787103816; c=relaxed/simple;
	bh=pQbb7KVUuISxVujusTmCJxd2oMXhc39+WMhuxftegAo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=TxOOppci4ToKRGZBrUZEWUoPSYnM1PLLYOhNameZDFds+HQlcMjTn02e+v4dYcq/8oC0AUjsBl1IuKSuM6BFEYahRpkZYKaj+yfcUg1MZUPmsoBDMVePr8xw9kd8psP+0DZh+0BjXU70gI8d/2utIgBQ3eVAlb5ojwbVf9tDsvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AYyXJnzd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fMxnMD06; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AYyXJnzd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fMxnMD06"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67INl5Wm2799135
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 01:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Mp4ZhMMjfijtoqQ1OmkqH9
	ytvM2yRZTPmG1EfzLALiY=; b=AYyXJnzdZ62vf198FMuA7fBGXIxnpvQIOYLOkQ
	sUvq09s1608MsE84b1wDJQvNP33p2OHCjVZmL3p59qHRL+xcSAiQXuZQUeQp0Dp2
	SAO4AJ4DKLGmIojyWkn/w/lgFXjMV4J3Qk1pzEKA7LUfdNjK0dhVesDxNFCQ+JPV
	lBQNzRZziKLhzydOHXnLwh76KM2UEUeq4j+p/V3LiM/VlEhoI6TnLiUOaOk8BiPJ
	SdXnN++03Jd50oFQQnlgvxBsw3GaFg/3d0hDZDImFKE5gWE50IUcwauCzRqpUyks
	kdSBu21aYE9oXGHDuwpECErXwx6v5AXhiO41UieESX1Wu36A==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfk8sa1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 01:43:33 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso715653a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 18:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787103812; x=1787708612; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Mp4ZhMMjfijtoqQ1OmkqH9ytvM2yRZTPmG1EfzLALiY=;
        b=fMxnMD06/+fW1kubSPhs2m2HPLfhdTkpoIetOREQt88MSWaVyrXe5Q59+SOXx3x99g
         TCQlGn06g5FicyBvvuk4E71yrht8ZZsDLS3jwJ+6s9uzEKc5EIMqBVMSOH1YOp7pR3WI
         HpXBHEwKr1OuiD02p8parrPW30SB27Jsbk1OKtTKpXVVHMgPuXfwWVIwbq+D+MON4WGu
         WIqNvXw1vjvxQ1pNCxC/X5iVdj+iGWGjzzDmp7Y7Jd3M/GnAlfPW9rOqbSl1oKbCGSfr
         apLBRZ03JVwlG/8mdJ5Ef2e+VYhc1aOgveXGjs9VZac8y5nG7Sz44BOdzsgpkaw8dZbe
         5+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787103812; x=1787708612;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Mp4ZhMMjfijtoqQ1OmkqH9ytvM2yRZTPmG1EfzLALiY=;
        b=SrzRz2u+pFlWgSvji7f3prU1MoDwCFNMax1eT2YsiDCb4pm27jC233GcN3AcfvRh0j
         Q+Glz9GueH1V/WCVsYsvwGivuPiACZEDpBtqazIe6qkYUpi+6A6VCgpWKzGdD3aVI/KP
         JX1KSXr0JL4gFBe2oFavlyg8+Z/d2OmHEmT88QJ6EcdqGY6eYsU1ldriNbFIgy7OkK5c
         gzYFvYCqkUvjiPB3sRU05Sj6GlGtsCCsLnidvEIALwnrSyQhevgyZcjf4S3vlLbs9BTj
         giCGYlIvMg4U83jv+qX3pJO67hhLFhOhnjG/V2DaNVFD0s3og3hUrRGdBOEIV2V18oTH
         A9tw==
X-Gm-Message-State: AOJu0YzZWg+UY0hKG5+UbaW77eqTmGQzVrwlrJqHwHlg4+TUJyUlUH6C
	ZrG6MYBHLM8B6gGy0MDwiD87vWolMknrlgz+49oJ1wn/tnadJIYv+WFXvxyfUTEHXf8nWDXRZTt
	g7F8rBgAbIJAmb0Qwhpsv+eRTnDdpFx/Nkwx37jfSD3W6Tj5277mFqIZiG9V/tv2VVwZMqw==
X-Gm-Gg: AR+sD11YpO0Kon69tlXdfvngssDcF4BAC0ORU1iBvzwhr/mwRrLPj3AjvQZRF/DVVhN
	kMI3qlkGNIBwyG43l8UzMxJdQ5jpTsXgFYn5KY6qAQ4/TvjQaSGN8yLXnf/cetbA61Hm21Qf8Wg
	wJ+6eYL+ZFsyJBJnP8FhUwKGEwzCJC2lW5+hXLy5Z0nboMij8eCm8LCeSQJMj/ienCSE9OSRqig
	5XZ55uyhtDGZIau9jeTiwjaTGDlChdOVbgxSDNsSdxegbeOXUwOHhuaoXwigP/aPunjbg3AUSeB
	Ffv+ATFgJJse2s4SErp8N6HVOBnvVb93VRwyRLjJ3EHTh3yEKN3W09ie2F3lnGNj7ZPdYE4Mq+2
	bs50601hMKjpydJxOW8uILXhRKw3GDZANMscKoEiz2tAR+XGriVZryg==
X-Received: by 2002:a17:90b:1dd0:b0:395:4e0d:bc60 with SMTP id 98e67ed59e1d1-39580f3bcffmr2074766a91.9.1787103812339;
        Tue, 18 Aug 2026 18:43:32 -0700 (PDT)
X-Received: by 2002:a17:90b:1dd0:b0:395:4e0d:bc60 with SMTP id 98e67ed59e1d1-39580f3bcffmr2074708a91.9.1787103811898;
        Tue, 18 Aug 2026 18:43:31 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb3069csm780660a91.15.2026.08.18.18.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 18:43:31 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 09:43:16 +0800
Subject: [PATCH ath-next] wifi: ath12k: use kernel types instead of
 userspace stdint types
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260819-ath12k-cleanup-userspace-types-v1-1-161a1e8910f5@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIADMKhWoC/42NTQ6CMBSEr0Le2kdoq4iuvIdh0Z+HNGJbaSEQw
 t1tOIGbSSaTb74NIo2WItyLDUaabbTe5cJOBeheuhehNbkDr3hdNUygTD3jb9QDSTcFnDIfg9S
 EaQ0UUdBVCdUZw28G8kkYqbPLIXhCZtHRkqDNS29j8uN6mGd27P9KZoYMu0bUZBSpy7l++BjL7
 yQH7T+fMge0+77/AGU7tY7dAAAA
X-Change-ID: 20260813-ath12k-cleanup-userspace-types-3e7b3bfdd29d
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: GDI903COEEFE-6aca1qfi1rAhg4YFOHL
X-Proofpoint-ORIG-GUID: GDI903COEEFE-6aca1qfi1rAhg4YFOHL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAxMCBTYWx0ZWRfX6C2y2lMzFrwS
 9HUT/rcxNj4hyiIU/S9umzrfCQKUTLTs2r3RtSwcpPI9NUu3Tr9NIYYjPL734KoXi539O5E0ISH
 ElyXQv0rEj+04T5kT6Mz9KP08XmdAXIV3xGNp0HJCMy/xQbn3D2DcWlSl8NXFXa9x5MejgJg5NN
 QcRTKIt5JFnj9hoySFl192lJeLwaEoMrO9bt4/uyuo8B3mJeYsvqZ+TtUcTw53wjIJFMvIpDKkv
 uYreUlgT3WBh7EUDtD0pkyKGSzDUbOUtxXFDJpXGIC4T86n2UpXq/uDIkRPLb8oedxuixjBa8LX
 HtcSy5kn+7zG/NnIMKwcUZ/DyMeyUTPHTRtVpb8772u/H2AYnCmxxR1uTYgN0rOca+juctDpseX
 8SGqzUAKbRNkN86+iSStvJePnOSJVCK8jJf7MEBBsuX99SWJZcfOQkjW0ziz/XZID+XzATkv1jB
 9qKTZvx83G5lR5jxISQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAxMCBTYWx0ZWRfX862bZQbMM1K8
 HquRpkz7z7CNKYJP7v/5ba3UvRbb9upAyfbOPDzvp0aqEV0/atHL+3mSBUWoQaCacmvwHXRUqG9
 7skMFrzQYSScxUleK9UIHvq5ONQD/jg=
X-Authority-Analysis: v=2.4 cv=fvfsol4f c=1 sm=1 tr=0 ts=6a850a45 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=N7lZ1fd5K2eDO5c5ewYA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_05,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190010

Replace the userspace stdint types uint64_t/uint8_t with the kernel
types u64/u8 to conform to the surrounding ath12k code, which uses the
kernel types everywhere else.

No functional changes, compile tested only.

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ce.c           | 2 +-
 drivers/net/wireless/ath/ath12k/dp.c           | 2 +-
 drivers/net/wireless/ath/ath12k/mac.c          | 2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hal_tx.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ce.c b/drivers/net/wireless/ath/ath12k/ce.c
index 67bbc6d8d0c9..c99e915e3885 100644
--- a/drivers/net/wireless/ath/ath12k/ce.c
+++ b/drivers/net/wireless/ath/ath12k/ce.c
@@ -269,7 +269,7 @@ static void ath12k_ce_srng_msi_ring_params_setup(struct ath12k_base *ab, u32 ce_
 	ath12k_hif_get_ce_msi_idx(ab, ce_id, &msi_data_idx);
 
 	ring_params->msi_addr = addr_lo;
-	ring_params->msi_addr |= (dma_addr_t)(((uint64_t)addr_hi) << 32);
+	ring_params->msi_addr |= (dma_addr_t)(((u64)addr_hi) << 32);
 	ring_params->msi_data = (msi_data_idx % msi_data_count) + msi_data_start;
 	ring_params->flags |= HAL_SRNG_FLAGS_MSI_INTR;
 }
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index fbc0788b37a0..ae4ba6948f96 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -224,7 +224,7 @@ static void ath12k_dp_srng_msi_setup(struct ath12k_base *ab,
 	ath12k_hif_get_msi_address(ab, &addr_lo, &addr_hi);
 
 	ring_params->msi_addr = addr_lo;
-	ring_params->msi_addr |= (dma_addr_t)(((uint64_t)addr_hi) << 32);
+	ring_params->msi_addr |= (dma_addr_t)(((u64)addr_hi) << 32);
 	ring_params->msi_data = (msi_group_number % msi_data_count)
 		+ msi_data_start;
 	ring_params->flags |= HAL_SRNG_FLAGS_MSI_INTR;
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 54056dd37409..75ecdb7648bb 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3517,7 +3517,7 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 							   IEEE80211_EHT_MCS_NSS_RX));
 	}
 
-	max_nss = min(max_nss, (uint8_t)eht_nss);
+	max_nss = min(max_nss, (u8)eht_nss);
 
 	arg->peer_nss = min(link_sta->rx_nss, max_nss);
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_tx.c
index eeabe9db776e..def540529872 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_tx.c
@@ -36,7 +36,7 @@ void ath12k_wifi7_hal_tx_cmd_desc_setup(struct ath12k_base *ab,
 	tcl_cmd->buf_addr_info.info0 =
 		le32_encode_bits(ti->paddr, BUFFER_ADDR_INFO0_ADDR);
 	tcl_cmd->buf_addr_info.info1 =
-		le32_encode_bits(((uint64_t)ti->paddr >> HAL_ADDR_MSB_REG_SHIFT),
+		le32_encode_bits(((u64)ti->paddr >> HAL_ADDR_MSB_REG_SHIFT),
 				 BUFFER_ADDR_INFO1_ADDR);
 	tcl_cmd->buf_addr_info.info1 |=
 		le32_encode_bits((ti->rbm_id), BUFFER_ADDR_INFO1_RET_BUF_MGR) |

---
base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
change-id: 20260813-ath12k-cleanup-userspace-types-3e7b3bfdd29d

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

