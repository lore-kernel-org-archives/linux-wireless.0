Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738898;
	b=3LjSDrzjtk7DMGA/Y3H/WhO2o8D0uPoRtzVlx4dBtsbWkmUusDDCIgnLSOdjvq82Pa9C
	 xVhDqT99gu36BCop0ezD3Co85qlCoT6SfReimXW+1gAYsU/l6G21MkHrmdIl93OoW5N7f
	 Bxm4Sxvhioj/LuGxJKqYWDQtX5xeo/Zmvroyy5brlhVPVcxspZKBl67SFoz33Ai3WbqRy
	 PvSsXcF8o/WSBOP9SsVwefwXiuTC17ifTpj4XkMvpzT9wyYUquPSa75S9uqSFBlQNrFdV
	 YKd7tXq8oxzMuQRrXR4dpPci5sQDi11/CVuV+cGU5uZKlZ+ZOeCeAc5s0WiFMDOxJvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738898;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=;
	b=eYu8/ftharBfPa0MX7T1cu2roBh9+cG87K8RC6OjLB88gwuwcTFOIVGm0Mr1jpu96P2f
	 Qd0Ul4Rte3tgQdZPmCMzCSouW2Y5W339VBWc8l2AkP1vnqVUz6Ms4odVu6duSEV5MwwSn
	 kjkyFVPE84Wud18WkxkEZwhGzz+ozJeNjzfINllA2OPn8ehnubRJwyYIp9H5idhcHtF/k
	 R0LqSdbaBD6CYyg+F3rX2liKJfyd0v67HFj8L1tIabgKyokbqcfVmWgpvYwHj02XH/DJz
	 oCjkSULVh9my9awwE4k3tkUuWZ4TDWi0Sv6AyawmoWGHb92o2vKGPpzyF5xMH2zjIUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OFxcrFkj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EweA6zw0;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA3360A2610
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACA3360A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OFxcrFkj;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EweA6zw0
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1FmwC4008248
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=; b=OFxcrFkj/0KvfZ9+
	+IjW23BCE+F/fcqkDU9JqkifJNhm4PRQjFTCF3h6a9Mo0kzenX4Rl6DOk/fph0ow
	LHE2Q7C6t2ev/fXjDGy0XyVi5ALwlXGqK/sGdnfgqARN7zLWSTixPio4m9FyIk8w
	qcA7SCg+1l9hCfsJqR88lpMCACc6/AF3Lj3uMWZxxzo1RZHUBP+lcwZg/v2NzUQ6
	tvWP21Sn5wKcvTWeHv+14Pd+xm9c373yhI4uusfveLyhhFgnUxPYa39MNLE4QHPH
	QfKctnnuaaDcAV9iOxAR0ud/BLS3JGNocn6n2rcLuNQs1S4RjDCT00LADG49mEQL
	2fOK2A==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsmasuus-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:36 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc7e0321ec1so759284a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738896; x=1793343696; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=;
        b=EweA6zw0tM+uZqkyq4SjmVWSUQsXXTNbG3d6VyvnlY/a1+NtsFSeJ/jOLDpzidP2Q9
         gODXc3i/MIPDlctSG/QUgVNGFHMgBpb5mUEisFyWzUgiSqFa+/jLkGEflnP26L3+JmiC
         Qfod6C1wALShkXY4SZByeBp5UW2lDIjRR3RkkAp59cQlLJRkqZBNMG/VlyDXpm1twoNv
         KtC74ZIKGw46UF4+T5xXsaMYekLTI0LEJzIN9LvC99u1LbhJXkYxL24BgtaMYaxsB3A2
         zAxoPjD0YIm3cuMwtqhh66sqbgtbyTX0PvQ9FMW35OTq2cbsgtTEQPXeW2/7IN8GF8a5
         jEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738896; x=1793343696;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yb6jb8LtpaG9aoBoetLFIOgA/OlOCRhdtmyPDaQ8Ovs=;
        b=GmugqIXgFcRzsU2ap+hzoE25yDfVTYULdA/NyMopZiROZ0gHzHFPKhLmnG9wH1A8tV
         nyGf1nSMgIQnSfFTVZUiizsOM928DZjQHs9sABXFkUsUTA8x6Lexz/K1hqf80fVYdIfS
         itTq2F7Qrvbt5CtMC6tcTWRRVJhCAiySMsagISYDkbJQQnKzJfGCDA0Atdggr+Zi5H9+
         pvlBEgGsoayFdTwpT0pC4ScAeuXhvphbI2Sy7DKQSyyQkhi5EcyEj3BMG4OLsvJ4q/8e
         6ZdsLDEZoTlYPn6E9gdSTQZlE0dCiOPpduhTpwQmBBR5ZRqg2z3AMPlUkvWVYeSrehRT
         GYKw==
X-Gm-Message-State: AFq9FYLcKTZ4w09oSREPh1JpZvHADt3kwVl3OiZyCCdZ/QPC2AqqvLDW
	cdAuW6odgYEFjLGOdKF0QKAmpE7yGczuA9Ry07e7NdvTZmPNWzXEDiEazpnfTESSK+wfH40vXKY
	QvdI94KFkQ4rTudgLdwT37nFNkDUECXZSsIZwNf0CcKfmJLm5YeGp7XuTaTMeBxtaJ87R7g==
X-Gm-Gg: AYBFou2F7zHbeDyX61F21NwiH/eu/5iIu2oEskKaJ9I0OBNF3+LUtenp/P6H2lt1yOA
	yCeZZzNET+3nWil/jyLJu2RPhXNZprWfVH+8pZPQWOEKYG0W319j2BzrfKXLtqQBG1Rpfg4TQoL
	kQmyEUKZ4dQwngJ5WVU7GtUgl7zwKLAnSTBth2A+8UWmW6Nn0icmglttEnqtxWjgLNmCO4iK8PJ
	Ouow3ICknhKE7hq0vFRRvf7Qtex+lzKuF7GNAmTXa9TUSpyyajq4JoY7BpDvTu4SWk8UY/O4rvZ
	Koa5vZ2hS0IYPD1OrfO7inRmENUT3b7zjMLwml1arRT/iwEV/v1LaL+tWVsdaNZzpHLK9afkgui
	GUkgVdAi2gFyt99H3YSfKKcVKYV5koVz+8HH/n1OMytg3ol+z3vzwf8b1p3D5s503xyl6YFBsVH
	zndT+lRBWe5fqxK15vZqsZAQ==
X-Received: by 2002:a05:6a21:7985:b0:3e1:8890:8400 with SMTP id adf61e73a8af0-3e369227e36mr986082637.15.1792738896066;
        Fri, 23 Oct 2026 00:01:36 -0700 (PDT)
X-Received: by 2002:a05:6a21:7985:b0:3e1:8890:8400 with SMTP id adf61e73a8af0-3e369227e36mr986057637.15.1792738895563;
        Fri, 23 Oct 2026 00:01:35 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:01:34 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:08 +0530
Subject: [PATCH ath-next v3 05/17] wifi: ath12k: add hardware registers for
 QCN6432
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-mpp-bringup-v3-5-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=V7LoQuni c=1 sm=1 tr=0 ts=6adb0650 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=4ETC605TzGOYwJmJ72kA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXwM8AsUDGYQC2
 h80w5vJhaScnsimTng0jyT7h9Yj+7BtiPJf6gRR+QgBz8teiOtHyhULNWIkSdN2859rHU1e0rFl
 iatvmOlKxz6JBfi7F+9ip3qpq1v/gv0=
X-Proofpoint-GUID: WYFjLaOcX0WqwVVO7zBPhNDEldPsUafw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXyNplAmLw+yPL
 crEejQji4pLE/6vkTZ+iBo8fP+7YHb3l1rBESzkybWtzYkgmd3FuZgt+6O9fleAFqtNKF3SCOSH
 IMauz0tcQwFo3KzL6CpmN76ZUoaMS5fx61YqQ5U8pCs4Nbo90uSONsWNYNtENKYsWvZxEug0Loo
 BjCo2YH6/Mc+S1UnzXQGvJ5QZvqWdrQQn/ikb2G7Wo7HCJuK/t18iQM6b2lqmrCqJTOpl4avhx9
 ggyUM3VP1JpgiAslFgksFuUWk4daF1DKYOYThzfiBWD2+4vtagpz/y0FycpMMP7jfHHy0Qlo4Uk
 izmmlqIlmsuK30aFdKPxE36HhqsO/H+Y5ETRCtZo8wI4s8Ff/3pnc8MmXr9t/PNL3YsLDfikJRr
 5le9uxc6BIrBXkgSwFS0Lk9b3idwSza8vYvZAEUa2z5TnkRPWoa5c0w90T598iTW35MrATj7pnY
 zePDRqsqvfnXFD7EdSg==
X-Proofpoint-ORIG-GUID: WYFjLaOcX0WqwVVO7zBPhNDEldPsUafw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

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

