Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DC749551A
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455073; cv=none; b=mVn8z5Ird7RKPvOQj37Z07x0ZX2t8AZRfUu+a3FL2QYQFSKaQTbEc9hjYFMpvJiBaP371L/LjzznyHB5rGWm0PkPSHiJkqVh/+oF4XEt5/RKb760sSbAUpmcp9aYCQc47Mt3HCOjydw+XofUHDJqU1aKtqPt+oszXJhSyvGQU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455073; c=relaxed/simple;
	bh=JOFX2Z8zRPVe/Qn1jsMwiuZo9ZCIJeIaopeipkRwKSw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JT/ICT8BPyHpiVjnaYfQqciCFEPKRFtBzIJA2iGKAkcpbh1JLAFfQXJ3o044RVNcDZ+/mhpdrLMxCXogfueMckyHwcOAe/FaKGN21HnugynIID3xjlYDxaPB9xL62lLIQDLYlrMnyQeLx1ApP29Xhs7gDXLafCsOTGv+sID3izE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n9x/wqRi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Eek6k8kw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n9x/wqRi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Eek6k8kw"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KOr61846063
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=; b=n9x/wqRiwM5tM9wC
	qdlXG5lb9ksM+FH0A4Q4XqPnoRCVvwSD6mpTNGdLBDlDM0biGUi2QtRuKUQErwQu
	kaTPBaquooTGN086ARTuXI4H7PmJQ6frdFt2D367KerL2KJ0MVjP/ZDQhS0QwK5k
	zX4DMbWqbmuYGFgnFe4bEeF/+GuzpgWxx77vEPpE7bG80AYfjCVLKjvFeMpS5/oa
	qJLjtn1M04CqsKk6GiTpbLifUZ5WxbAewx1HM1haCsYDLaWrjR18BM/DTganmGTo
	8Te4D/V4rhL34KxlwnjHdekYrPVehhChRCHnJTxtRiuiFamJncP4dSGfq0Y1hzQR
	i1Vb4Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe3jhgr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:24:30 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e80ef3e0a3so7333785ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455070; x=1792059870; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=;
        b=Eek6k8kwgjyqYmPZyQ3y55ZLhpnKTordznhHYDfpHkrVM3HwM6dLU3151iCsWLWDKa
         tTsTDdbIKV8dp2+5A5PkGBgsGN+OimfHoMkWmK4t7ijtDwAM5yD7K7JOvNHkeQTvf0dV
         kqWr4GMEfe0CAfeR0pktXsh9JhZ5W16KWvQ6LM+obqHaHdhWliyicBlwDSEa36O26O+y
         CmeOY5rYngwKR4HGo0A4f9KkrLw0dvvRYm4sMjoP7gGsUUrCHygrDO2xBP/zbqqD0srP
         ht7STTVBtF3o0DyQy3bo+Xi/O93I3TLIQFYU6TXCynhDd+LATqbmJ2KTukv2Zh4CJLEd
         iqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455070; x=1792059870;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=;
        b=SHuDqB+g4SSXPxOLj/aHJzCeyuu5OTU9CSnHxoIsNxssJzueQiHmr+vykelmYfZcb9
         eiNiy/rnT896UkGaIsbE3QwoYSw84Ak7ovry0VuuUhPiOjK2pnq5T/iKJndb5pQ8wBFQ
         GsZwR32Fv1K8ZnWt1qqDuAZb0q+89JnnZN+8MnnBEYrZa0HESSMIAGtwVLbwpVFur7xP
         Aug9EguHX4U3EwGfOLAgsbPJb6SX79q0a1cYrpR2WE4QlV4ny6DzlCK3WZNgCMXFIY2R
         GbtVk49rRSGXQbC4+BZLYOb9oOM6SqfPUFihKZr/k3zsOxPxIy2zoaSQiTkL+Xk8TVVh
         grmQ==
X-Gm-Message-State: AFq9FYJg9qkbEExo6J023mN5I8ePpPu6TUlkq+pjApwzDVCxsqHvt5WP
	RLfQLqu/rZ7KujnpEj85enj3eCGNjitqrDU0FmYDqt0MMqyobHENdAwrTlzsFLkw/8eB2DJmxwb
	1eFdyXRJwpp+YUu4IYnV6sG2T0e7ZZYqlDbu5P9rVY9jMT3ak0c1MMtVuVDeh63/3wZ+tSw==
X-Gm-Gg: AYBFou0zL1FXskotGJPZvXwasQWu379jM3nAaQJz7CeEOzPxMvxq3toChymCrAdtb+n
	aEpdmpaFbYWzD3czs4xOvUgB/vEORL6xadi5nSrJx14dLhXoU2u1gEAg2s3pIxxraVNm2kWqI3D
	mgXWR9qThHNWNWS2niQkHhlKziWlqPMXCYGyRDx9oqIixKzQt1TBI73xxtChIYK2PmehegL4YpE
	l5HGDgVy6eBAT1zrvee0bsRDQ2fmAlZ0nGmfoZ2B9IViYGrYVh/Ej3nDSqdrsBRz4hdNoa8Kj+E
	NuMdhhDTsWEw+JXBhuxkD5TLgacJBQCcg437c/ZvhDJUn9xDyrwziI1tJx+usyA9aYknPmrRIuU
	wlhJwXuqq80r6g1v0FmxwH+GFNBVjrbDFj1Fd60xIIt/ju1spDzmL1N34ldfP0nX9Dg55Vanymu
	DDGvHPretKF1zgzE/QZHiXpQ==
X-Received: by 2002:a17:902:cf4c:b0:2dd:c100:943e with SMTP id d9443c01a7336-2e6005979d8mr43173515ad.60.1791455069799;
        Thu, 08 Oct 2026 03:24:29 -0700 (PDT)
X-Received: by 2002:a17:902:cf4c:b0:2dd:c100:943e with SMTP id d9443c01a7336-2e6005979d8mr43173285ad.60.1791455069288;
        Thu, 08 Oct 2026 03:24:29 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:24:27 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:01 +0530
Subject: [PATCH ath-next 05/17] wifi: ath12k: add hardware registers for
 QCN6432
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-5-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX+vVuyOznYxqQ
 /+qZ34kukd7A0ca36XQ9SZDncQds8vQzj/r2nz4LvII4rvy62RT4qJC0pYt5QVWd43UXzCX5l27
 mn4GdxQdp6FZ71v6pgaZmudcyBmj604=
X-Proofpoint-ORIG-GUID: BE_Y62RAG5a7361obOVF28Lof6ROCiTx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX0wOYTvehlx6A
 uzmsdQ4ifa5paG+FkC+K8jhOQKmXV3j2da3ztL6kLdwhP1rYCYFEJEpLABGRZpMBELQaL0kLFMa
 akNSOHL2D/nWxldy+0zNYvBJfBLsbfbES3tDV6bNALLDpbdWNBUHqQsyjqa4kaLQAapseeHD1CK
 4czLKYmgOc0NaSiak7ip8WHqubPtJYC8+2yNYPV1Vk2eB5QPKpVkFp4G3N/HxVvZR4A2YcvC7zn
 v/SHd64FoPC4PXzxf5jZ/KxJbleD8p6lPXplTXVo0pXIwbtqkZm+pFKyq2KDTc2OuGRXYMOhUfM
 BKgxINGC2l9g8YJQO+zOHpgqN1Fg4kE9ZONh/qo8tJE71H4w0O1Bf2kLKVfEoS9h4uWLGt0hD3/
 dBDWvHeS+veDbhUKs0mhBOG0MYtWDRlVVXOcSOgDPA1WhWQWEb38U+fM542/cjQEJLIw6LLPe87
 TmIj87wwymi/WYA+r2w==
X-Authority-Analysis: v=2.4 cv=IIuXmQvG c=1 sm=1 tr=0 ts=6ac76f5e cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=4ETC605TzGOYwJmJ72kA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: BE_Y62RAG5a7361obOVF28Lof6ROCiTx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

Add hardware registers and populate the hw_regs field in
ath12k_wifi7_hw_ver_map for QCN6432.

Also populate the HAL operations, HAL descriptor size, and HAL parameters
using the same values as QCN9274.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/hal.c        |  7 ++
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    | 85 ++++++++++++++++++++++
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.h    |  1 +
 3 files changed, 93 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal.c b/drivers/net/wireless/ath/ath12k/wifi7/hal.c
index a0a1902fb491..7c468159085f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal.c
@@ -57,6 +57,13 @@ static const struct ath12k_hw_version_map ath12k_wifi7_hw_ver_map[] = {
 		.hal_params = &ath12k_hw_hal_params_ipq5332,
 		.hw_regs = &ipq5424_regs,
 	},
+	[ATH12K_HW_QCN6432_HW10] = {
+		.hal_ops = &hal_qcn9274_ops,
+		.hal_desc_sz = sizeof(struct hal_rx_desc_qcn9274_compact),
+		.tcl_to_wbm_rbm_map = ath12k_hal_tcl_to_wbm_rbm_map_qcn9274,
+		.hal_params = &ath12k_hw_hal_params_ipq5332,
+		.hw_regs = &qcn6432_regs,
+	},
 };
 
 int ath12k_wifi7_hal_init(struct ath12k_base *ab)
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
index 052b59265af8..34f6be922479 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
@@ -572,6 +572,91 @@ const struct ath12k_hw_regs ipq5424_regs = {
 		HAL_IPQ5424_CE_WFSS_REG_BASE,
 };
 
+const struct ath12k_hw_regs qcn6432_regs = {
+	/* SW2TCL(x) R0 ring configuration address */
+	.tcl1_ring_id = 0x00000918,
+	.tcl1_ring_misc = 0x00000920,
+	.tcl1_ring_tp_addr_lsb = 0x0000092c,
+	.tcl1_ring_tp_addr_msb = 0x00000930,
+	.tcl1_ring_consumer_int_setup_ix0 = 0x00000940,
+	.tcl1_ring_consumer_int_setup_ix1 = 0x00000944,
+	.tcl1_ring_msi1_base_lsb = 0x00000958,
+	.tcl1_ring_msi1_base_msb = 0x0000095c,
+	.tcl1_ring_base_lsb = 0x00000910,
+	.tcl1_ring_base_msb = 0x00000914,
+	.tcl1_ring_msi1_data = 0x00000960,
+	.tcl2_ring_base_lsb = 0x00000988,
+	.tcl_ring_base_lsb = 0x00000b68,
+
+	/* TCL STATUS ring address */
+	.tcl_status_ring_base_lsb = 0x00000d48,
+
+	/* REO DEST ring address */
+	.reo2_ring_base = 0x00000578,
+	.reo1_misc_ctrl_addr = 0x00000b9c,
+	.reo1_sw_cookie_cfg0 = 0x0000006c,
+	.reo1_sw_cookie_cfg1 = 0x00000070,
+	.reo1_qdesc_lut_base0 = 0x00000074,
+	.reo1_qdesc_lut_base1 = 0x00000078,
+	.reo1_ring_base_lsb = 0x00000500,
+	.reo1_ring_base_msb = 0x00000504,
+	.reo1_ring_id = 0x00000508,
+	.reo1_ring_misc = 0x00000510,
+	.reo1_ring_hp_addr_lsb = 0x00000514,
+	.reo1_ring_hp_addr_msb = 0x00000518,
+	.reo1_ring_producer_int_setup = 0x00000524,
+	.reo1_ring_msi1_base_lsb = 0x00000548,
+	.reo1_ring_msi1_base_msb = 0x0000054c,
+	.reo1_ring_msi1_data = 0x00000550,
+	.reo1_aging_thres_ix0 = 0x00000b28,
+	.reo1_aging_thres_ix1 = 0x00000b2c,
+	.reo1_aging_thres_ix2 = 0x00000b30,
+	.reo1_aging_thres_ix3 = 0x00000b34,
+
+	/* REO Exception ring address */
+	.reo2_sw0_ring_base = 0x000008c0,
+
+	/* REO Reinject ring address */
+	.sw2reo_ring_base = 0x00000320,
+	.sw2reo1_ring_base = 0x00000398,
+
+	/* REO cmd ring address */
+	.reo_cmd_ring_base = 0x000002a8,
+
+	/* REO status ring address */
+	.reo_status_ring_base = 0x00000aa0,
+
+	/* WBM idle link ring address */
+	.wbm_idle_ring_base_lsb = 0x00000d3c,
+	.wbm_idle_ring_misc_addr = 0x00000d4c,
+	.wbm_r0_idle_list_cntl_addr = 0x00000240,
+	.wbm_r0_idle_list_size_addr = 0x00000244,
+	.wbm_scattered_ring_base_lsb = 0x00000250,
+	.wbm_scattered_ring_base_msb = 0x00000254,
+	.wbm_scattered_desc_head_info_ix0 = 0x00000260,
+	.wbm_scattered_desc_head_info_ix1 = 0x00000264,
+	.wbm_scattered_desc_tail_info_ix0 = 0x00000270,
+	.wbm_scattered_desc_tail_info_ix1 = 0x00000274,
+	.wbm_scattered_desc_ptr_hp_addr = 0x0000027c,
+
+	/* SW2WBM release ring address */
+	.wbm_sw_release_ring_base_lsb = 0x0000037c,
+
+	/* WBM2SW release ring address */
+	.wbm0_release_ring_base_lsb = 0x00000e08,
+	.wbm1_release_ring_base_lsb = 0x00000e80,
+
+	/* PCIe base address */
+	.pcie_qserdes_sysclk_en_sel = 0x01e0c0a8,
+	.pcie_pcs_osc_dtct_config_base = 0x01e0d45c,
+
+	/* CE base address */
+	.umac_ce0_src_reg_base = 0x01b80000,
+	.umac_ce0_dest_reg_base = 0x01b81000,
+	.umac_ce1_src_reg_base = 0x01b82000,
+	.umac_ce1_dest_reg_base = 0x01b83000,
+};
+
 static inline
 bool ath12k_hal_rx_desc_get_first_msdu_qcn9274(struct hal_rx_desc *desc)
 {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.h b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.h
index 03cf3792d523..5c593773109d 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.h
@@ -18,6 +18,7 @@ extern const struct ath12k_hw_regs qcn9274_v1_regs;
 extern const struct ath12k_hw_regs qcn9274_v2_regs;
 extern const struct ath12k_hw_regs ipq5332_regs;
 extern const struct ath12k_hw_regs ipq5424_regs;
+extern const struct ath12k_hw_regs qcn6432_regs;
 extern const struct ath12k_hal_tcl_to_wbm_rbm_map
 ath12k_hal_tcl_to_wbm_rbm_map_qcn9274[DP_TCL_NUM_RING_MAX];
 extern const struct ath12k_hw_hal_params ath12k_hw_hal_params_qcn9274;

-- 
2.34.1

