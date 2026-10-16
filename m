Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF53377A87
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120937; cv=none; b=H+s18VG8dIxLu4Kp9TYkgsWlkiNsvfGkrdf7iRgY2fCpM2krJS1oQjEntKL4uoBLevZtwQLCOfJsdDgJb+92cg74X3FZUyBsIPE1k4Mm9XG1dnXwHpYoTZ5qm7uBmC9rEYvDwOHHamz49F0ypjWIxNcI+Z8wEDLP9j/dWK6Foi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120937; c=relaxed/simple;
	bh=JOFX2Z8zRPVe/Qn1jsMwiuZo9ZCIJeIaopeipkRwKSw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AbC4jSx2ancMfKWMbP3fwxQOR082CTGBYbvbQcci13QKoOgiKFtgKuxX5aqF1QuTbojQvN+eW90m8LXNjLNI3J2VeoBY25njUV2XhOrlSIA/FPfJ293UTlJwIyT9+O5MFE0pPvEqwpkUkZFVd8a5vql+PDnM3C3Da+Xdt0PbH70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QlWPOELU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DIt1uXwQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QlWPOELU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DIt1uXwQ"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FNfwkP1635300
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=; b=QlWPOELU34KqE/h4
	P8WYzgtlApk3V49VeVe/Ri+7OqNmG92EyV0+9McsJVhZB7SlDzemu9iaLMpj5anT
	9NNA6PNn3QSiFlEdqqL7fg7+ZaVO36gmm0QsM+dvJOqgJNwjF4L+AB/XxmW5TEjB
	BJmFtuGhVstuaTkm4vgEMYQZdRl+DwOFhCNOGcwLzZ9rmuROriGoSw5CjRhk+GYz
	NVqSu+O2dwVqzDXLvrkfc5nIA9SAQSdQqADC4QSNklionLjntOD8Zv4c5wx0/7vq
	9Y0K2nwcEpFOCF+E0CRqgqQVL8FQ3mEboMivwu9JAeTrvhPmfzU21Cmh40qkFf6D
	IHzFkg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb8r10m1c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:13 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35a04491c56so572275eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120933; x=1792725733; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=;
        b=DIt1uXwQmeCPXgVDiyvqJeSaakq/fDQjGaqQqNf2/IwlRLXZaQKYAI0j+yv7EzCqpl
         td+A31gx+bvMadjdnn/arRMcdVuyKfgzNIpJa/w64Vy0vdWesKquVH121TRUda6dEKcH
         64v75uys1Ss9Zttzk5XUczTZf8Uq/6/sB6n5QEAjoJ/HAB3s4n/UbhoAbKdyVgL3wxQn
         5E547fqk9t01IeM3Whrxl4LOmB5NF6obVCsyhsrhAoGNwc/70TktAkkfEQNf7/TNKCOB
         h8qwS/vzb+SHAOiTYTERZduMln0lmK1qNGzS5vEWmXbCSA9NV1YKLHzYKHTaRwo6HIa7
         Pi9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120933; x=1792725733;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=;
        b=ZGR8dZuIfC2NUx+WliEbjz2hIpHPdnLmmcNmK+RSD/mPLGlRg/9nHbGtfPP43qiveI
         X2ZH9PfIbV0NdE/dcOtPciJWhfp0rOYaqUqGO44mVbwO39Nvy67kEqfPqI2btJ5ndHku
         8hMxd3BrVGdHG94M296rwA7ZMv/f/z7KDO4XHCPXSojaA+1JmlA9mBhpi+kwN4eT0XjZ
         m77x6Q4lZQSsl1gE5SpoX1J9ggyA6HKY4/4l4vARePsKhvNcjqeKtA4b7BM+xUBIrkpS
         X48WUJGtcA1kAwyXLmEyyIOk4XhZwOcctxR9aRx3qlhopmWaG0hKv1+TRcDYSq1cur2B
         YUUg==
X-Gm-Message-State: AFq9FYK4qNUBLf1RC//gfNRs35Z4JknD56l06NBtFYeyOfHKdaUtSVpR
	Id2z0Xnob/Cao/NXFT6f/p4SEgPbC8BiVSR0MN0NTLr5fl/QG2LnVx3+DWYeVopDfUeOIchvICc
	lEBgbL1Wyj1To49MV02OvStRxuUiWxEhlxjiRp/bWMictu5fRG8YhxKBb1QPo1wYlY9+YIQ==
X-Gm-Gg: AYBFou1K2Pbi9WPQCQeYINGoRQJE4RHotF/7C6M18vy3IuKV5WLJc7G6tWhc5ta6hhm
	cpixM/QZXG03xunNMVpscYLua7BorG8uEAnOJ21md3iLGbLN1dO+k62L+W8lZB0LwcFjGack3a6
	ks3X3kDrGoN6L11iDdOKLJqlI3Tuqng5VPQHN75H2j0jGO+Zb59yg7YsnS/8KhvN2f4fGcrm4Dj
	oQMh5f9IEQ76GpjujPePTjo4NEicXya9VQeZIuNdWe9ukifM0/kXNPS6wjJ11l++5qDjW6+uG00
	n8G4XNDbvfiTFptQ3gzdCqoTCGFVHSQC5uT4FP62yGD8+y/RbfDuHMmJiGpYkBbZ1CcfcWG3zOY
	E9knVA7VrYDjh/F4DgNi21BOiiu4FTEjD1n4kNPyIjYn3IHGuanFM602zE8TCqEx4KXMknL16Mx
	o6WVxMp6PHpgoaWcVinAZtsQ==
X-Received: by 2002:a05:7301:6198:b0:35a:e354:643f with SMTP id 5a478bee46e88-3602a780f07mr2413099eec.4.1792120932425;
        Thu, 15 Oct 2026 20:22:12 -0700 (PDT)
X-Received: by 2002:a05:7301:6198:b0:35a:e354:643f with SMTP id 5a478bee46e88-3602a780f07mr2413070eec.4.1792120931904;
        Thu, 15 Oct 2026 20:22:11 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:11 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:42 +0530
Subject: [PATCH ath-next v2 05/17] wifi: ath12k: add hardware registers for
 QCN6432
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-5-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: 04IIfWFXuXleuR9r1-z_96L9pIEQvXJc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfXyL3yshedDZf3
 BUuNfoz5vX/E2e/rmoO0PAWHprAoOsK/tup+5Kc4qAoYqqob8sE3/zsxb/Q+2sIXYM+R23/odrr
 tEH3f86h1HpmLOUPAGFt7EYe4wr1z5w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfXz9rsMVuMPzOo
 HOUlWG8ABWWZwNMY/who8u9TtaAZHMeyP5LqPgvHKzxrmASdbCNsV5myv+958dJX/1lh0iQjmbi
 CnX9PcTuGiIDvo19UGUVq53eTw8AXfu1jD65eN9gEg+sH0FLjUebxrBLVS+YieU/FB+ua2Fa1j/
 XpFDdE53oQmlUB0Paqqt90yrZdKpxVwbr2k7Ktjzhp1YZTgt7lMoQ7g0fuxSd1x0oHklf02gMPl
 d6ZowzfWK6O7M83m//3hJJUCDcEixyyTeHfwKTY6OmznUHdzyjp0J6eTC8dJkZaRMquNmBs7F2i
 QhR7cEaDOMIsSQNf2gos1bitJ4OLgXH0/APgmqNtibB+q9ef0h2kq4+OjCGleAsZM/Efk/32OWs
 iVSDJwpKhPvfx9sVaH8A0rztumjyEVeAzJ1IBLo4yQ52s+nyZIObZN/VN5KAYwyrbVFuufV+I1x
 FMYeyEJ/mKAZAfJNV+Q==
X-Proofpoint-GUID: 04IIfWFXuXleuR9r1-z_96L9pIEQvXJc
X-Authority-Analysis: v=2.4 cv=L/CI0OT8 c=1 sm=1 tr=0 ts=6ad19865 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=4ETC605TzGOYwJmJ72kA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

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

