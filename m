Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C373A9D95
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 02:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787018639; cv=none; b=NQgl7I+irb761jrLmCSglDPRck6HjKIS9gWBLBLfQuFxSJQG4y9WEUo9Tw1sY71uuiPPP49aHdWLliOpH+4WPgTXOI0Kaf3iJZ6HlqjwlXVZG09/ClRn0DxIBNNF4Sk+yx0DVVSNiwbMIpkGyonIvmIS9EIA2icIDtRMNiq9/90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787018639; c=relaxed/simple;
	bh=z1GTKBT7lHxBqy0Gz9m7SoVzxRReM/v1O8qRSi5V9vc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=PeAIgryQ1OYI42XJUQOlBlf6w867o5JJoZvldPQ1SolvNU2icHkdSV2EAFbSyw8d7h4rql8DM2HKykmCofa6hmYLACCkI3O8fmQi+wnJ37sZXHydF1LCU5o7rI+GyJKAQjYsoRNgMSawrkYfGBEImR/yXQtcqusf3c0ofJJjPPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HIsLnpV7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Yj1Ts3wf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HIsLnpV7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Yj1Ts3wf"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HLkoYa2331302
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 02:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=s6Mh4rsBhYYdv8SvEYieOR
	TXS4M4H8dESnuK4qRW0IE=; b=HIsLnpV7+dSjTg8vid7P8o8ut5RdHRHPKDkF58
	HZlIQfQDyXTcz5DuQeidLT/ub2yzXHvN33Rvv2Wr1jYRuKebkH1CnkciMJRUoRab
	vRnsEMWhGic77eO+g93c0iZvEPOo0oS6pPXezdg7vg2A6P0VxIHVbvM9w/7bksw/
	KwK+OMkigT48D7HHemFMKfE1r8u4JQthFTIGZCD929hGyTy6kibLYvwp3owHiku+
	Yqsyj6UAzO1y67zZkLP5nbXwb2DKM5KqiHA2SSnq/7zWZI9gmDpu3XnqmUUTkk7e
	h8YfL3dR3gq1wwfLXtJEkwtca8sRywZn57mjNw9mn9WaxjOw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g3wke49n4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 02:03:53 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d54187d8b0so79758215ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 19:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787018632; x=1787623432; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s6Mh4rsBhYYdv8SvEYieORTXS4M4H8dESnuK4qRW0IE=;
        b=Yj1Ts3wfG6qiYXD92aG1qPbcL5nw0HWXhslp+QFoTkf55pmCOk/myqqEl9ezUP6Vmw
         HZBm7GJrz5ckkPok4esRkqDvmjLn2050d8ufcAHmBmWrmr8j08KvIhQ/zuIdgOJ6r+OL
         TtAR4nH5tkFcHL7TDmAUd77GWUNEJybsXpQRqdpq4zvnDVRhH111IjXba6Uca+oIZmml
         ksJA/MV5/3pwkDvEbpzrS5ijO9n/yMdAwlZkZ3dmXop9SfkbKc5QHjchcZy+np3GiRdW
         fQUAsmyIUA/WypfUvV0j6rgNZEyxK5aVDfNEC8BV+sZZ0o3AgNxwiOLEuHDV8PksKGCN
         Ev6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787018632; x=1787623432;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=s6Mh4rsBhYYdv8SvEYieORTXS4M4H8dESnuK4qRW0IE=;
        b=o02AfVQA/gHT6hp4kAigdnJZlOaYYb/7AemRzA8oPsShN1rwZx6/wgKxDQ/Z7xs64q
         HbXtJUU0kOzU14yi/swAluijt09NCIt+J/InMumNYfz1PuKCFc1Ye66eltjgT8O4/CY4
         3DAQVzfgcShnrpx+Jp42w8JKpclY+0A1l2QYIGBrPMSJP58ER/O+eGnQHP7O7StPJo9I
         je1dU+XAmRun48rVnndo+cI08WVQ4J1qcnNxsj53yxeGI8hWhwARVbDTEsoB4BTc8wzZ
         yTgu+DV68dUmesvOcRnULN0U0Y7FgVAEws7vr8tjnyR5ckiQ/F+bp67MlrrXDtEjOPGt
         Daxg==
X-Gm-Message-State: AOJu0YySGBM+ed6lsd0j8bIHOCeM7vUBtCyz7vT9R1EiJ2CYs5W7mTsm
	du1d9TP95inrJdQjJrOdlBhbzia2+fSmz3UQDj5MNAZEJHf9DfoD96st/C08J9REKIqxt7WFQ6u
	xedmKfO61WUG5AUODH3jmVzcX9jOaRz2gmJiBwv07X6SJH4Os5JUWAwWUkPoO4EmTPobWkA==
X-Gm-Gg: AR+sD10vJTxZ5aaIIaIHwZqCTpV/MV1cfmmJt9lyo1r/xTtPE0boDHAkslyNwujVp9n
	vVHFtUrq4KX1zeu6jwtZOPYKjIMQ2wi0P3fwAhZzsCuykcmSWKlI08YykFrBl9sW3ocB3rP+61c
	eNfwbtrXllp54NKeBkltr/y2TKBJreDgHLN8cEyV4jhaQ3PXUQcRZvcdFSAQGpr3FqKGe4lQKAr
	X87SVuaZ3u6h/msxGQSGE7+mri5AZeM1Wg9FRt6ZEdi9ev4Pu/8cg/Q0McL4G1gGNY5c9bbzCwv
	Qt3B9EAfC88YBZp63d4s6XM+PjtrJAI+rM8ni2bTlDmcqvF6FMMvk2IIWLI8Q8J2rqvFbQA5U6/
	UBuGXks+gC3edjiH6BG/NBMiXvht2Y/Eu9L3qwy3RDazrl4F10y1UHA==
X-Received: by 2002:a17:902:d4cf:b0:2d0:cc92:f7ae with SMTP id d9443c01a7336-2d3b080bb30mr299376385ad.3.1787018632478;
        Mon, 17 Aug 2026 19:03:52 -0700 (PDT)
X-Received: by 2002:a17:902:d4cf:b0:2d0:cc92:f7ae with SMTP id d9443c01a7336-2d3b080bb30mr299375655ad.3.1787018631901;
        Mon, 17 Aug 2026 19:03:51 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1ef83d6sm8768185ad.78.2026.08.17.19.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 19:03:51 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Tue, 18 Aug 2026 10:03:41 +0800
Subject: [PATCH ath-next] wifi: ath12k: fix truncated TX buffer DMA address
 in MSDU ext descriptor
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-ath12k-truncated-tx-dma-addr-v1-1-ead978969371@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAHy9g2oC/43NQQ6CMBAF0KuQrh3CtFTQlfcwLkqnSKOAtqXBE
 O5uw8qFiW4m+fmZ9xfmjbPGs2O2MGei9XYcUsBdxnSnhqsBSykzXvB9USOCCh3yGwQ3DVoFQxB
 moF6BInIg20NJ9aGihhNLxMOZ1s4bf2bpEwYzB3ZJTWd9GN1r24249f9NRASEupWCk5IoJJ5G7
 /PnpO567Ps8nc2P/NMUP0yeTE2lImyElkX1xVzX9Q2+RU7cLQEAAA==
X-Change-ID: 20260811-ath12k-truncated-tx-dma-addr-5f94d897db2d
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDAxMiBTYWx0ZWRfX/GfySHcMhGwP
 5f2GkAEp5hS1RV/V63TnZ4+W+UGE37Fb+RePS2fEKlfC9u4m5myXznQTr7jOmbKOvhEkO4NFUy5
 fkRoD8DFLQwkfxwk1EfvKWHvB2mkf8fbhfZWUPELBLxV4w+qhyYoKmQkWEeCUmR2/q0qYmfOCSJ
 uQloCwg6YF7TRf2aFpxFlFfJRCeZNqJ/Aj0s/1eYd5Dm3aojmCRARIeAoH9iyx8A8na1UnVcooh
 NCcMZUR/tk2JzWUWs7/pihDdwtmdR8C+FBuPWtwgxVJFD/2vv1rmYNKuSljzxfhZQ7aVCrlDV9P
 Y2MKSO8G33paFotzYNVQQpYL+6p7a5JS52AMglNKoHXso45J1ZEh4Ecum6SVJM6UtKnx9gUmn8Z
 HkbZBh5F24x/gk8k4BCL8Qwz3ARY9zxjbEVJQrKNJKtJntbsBgqJGV7VhWJBfmaZf57K4xlaQBv
 OevB8yN5VEKa3cQOTaA==
X-Authority-Analysis: v=2.4 cv=QetWeMbv c=1 sm=1 tr=0 ts=6a83bd89 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=KTYYIFTkhO9gwAdvEP8A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: _nPjN7fWgyUMlg3O6KxGcXKVscp9Kk4y
X-Proofpoint-GUID: _nPjN7fWgyUMlg3O6KxGcXKVscp9Kk4y
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDAxMiBTYWx0ZWRfX0II09YVoTOEW
 6th5xYBMlD+Cy60XJexH0fStipuvqhJOidUE1OoGGXyiCWAThfZM/UvPJujp7wkDQ8o/MMjlf3i
 sKF4bs5G0HGBDUsHv+6xyLPjhudIaWo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608180012

ath12k_wifi7_hal_tx_cmd_ext_desc_setup() programs the low 32 bits of the
TX buffer physical address into HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO but
hardcodes the high bits field HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI to 0x0.

dma_addr_t is 64-bit on platforms with CONFIG_ARCH_DMA_ADDR_T_64BIT, so
whenever a TX buffer is mapped above the 4 GB boundary the upper bits of
paddr are dropped and the firmware is handed a truncated address,
leading to potential TX failures.

Write the upper bits of paddr into BUF_PTR_HI to fix this issue.

Issue found during code review, compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index d2749de44553..87edfcd3672d 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -20,7 +20,7 @@ ath12k_wifi7_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab,
 {
 	tcl_ext_cmd->info0 = le32_encode_bits(ti->paddr,
 					      HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO);
-	tcl_ext_cmd->info1 = le32_encode_bits(0x0,
+	tcl_ext_cmd->info1 = le32_encode_bits((u64)ti->paddr >> HAL_ADDR_MSB_REG_SHIFT,
 					      HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI) |
 			       le32_encode_bits(ti->data_len,
 						HAL_TX_MSDU_EXT_INFO1_BUF_LEN);

---
base-commit: 4fa10e991f77b4c929d1959900a6ed422b9e2ac5
change-id: 20260811-ath12k-truncated-tx-dma-addr-5f94d897db2d

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

