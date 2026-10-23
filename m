Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738949;
	b=xw7cMfJLo+jcC2qnd+Z1PTiVe9lhnzm1+OBLU9vHzomQenorrfCD5QwUomEZJiY8diJz
	 aVLg+mzzfIsHvV8AdUDBoRp4AbqciFDYFR+ZthyoovnFjB8w+gGDDAnVzgTSMhTsTEAgF
	 0zOlM3E1TxV+lnEHUeqiJPJBA4PMA6MyZzQ1osD4sDWqOsGCqCD1Rkx3qMhVV0+GZDy/P
	 qMhFsz9TwcVhL+zXlrcvs+34WNd5OVIzY2kd9qFZynhy2Klg373G+VMGk6nlaZDYkypB5
	 CDFyTIiFvQbv7764SwCWov5MOrIbs7dxBZk3h1+TLhQpmmo8ERYgf7XJb45xfBEF7AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738949;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=LlYuG6WB38gIzmIC/YDa25c8nS2xNNSGEFoJZF8X6UA=;
	b=sttGpKUziD44bhmHYd2EkmvEJCwZZTxrsCCyhdR/HT0GJFWYJlgbQUnOHdZWu/W+H/aV
	 Y1teObZcT7m+kEtf7IKtTuXbP7p9fUpQcrfTgTp53G5cjJDpOOsGVHBwtocA2GvzI/hBK
	 KA4Nw6Gn0zl/0Q2fTeSf/HZXP1bdXaYIPlVaz/nL0NwUmjGKW+YG9pggbavyDyvDVeKb3
	 yN0t6Lj3VvjEMLYk7DaIu3ZN22WMwD+7cld3i6BHUvX8yWeUV8NcI7v2M1SMMYNA1Mixy
	 /I9PJiTSI5vGdFLZFCFztSkUNwQS2xxTyZ2OsPhE0XfgQ88X5t2qNVdVAcggJjQPEMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IQYopkuj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Uc5DWruR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD645606BD08
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD645606BD08
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IQYopkuj;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Uc5DWruR
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1FmN91293756
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LlYuG6WB38gIzmIC/YDa25c8nS2xNNSGEFoJZF8X6UA=; b=IQYopkujZvHpVxHY
	b1d4rQf0efoSQLNWgNV/ZRRuDpKpgm6K4s+f4hyEn5kMwRatTdJ53MDZWlxHus6r
	+mDBbR+VDPpH6wXC/UuSoDKc5NGMFmUNSE9/9EOdsYdRE7q0cIme9Vn66aw23j30
	mhm9h0wVOXKzyn5kxX5XJrHhr6SFGK5vhOWm5CiFWm78tYK/G637mXTeGWVTfS+9
	qdjotwmZURqGLLtlhZn+5kl5/VekGUQp8cR5XtzD+jj2Jo35Jdz7q+4vZz0/wp1Z
	IOy4M5ZV4XQqe8ScrYGf2MusHCqS1unN6My7L9n5JLKDSBHm2DPLXt+XC/WRH8C0
	3EsexQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfnyw2vm5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:27 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ab2395f104so594519a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738947; x=1793343747; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LlYuG6WB38gIzmIC/YDa25c8nS2xNNSGEFoJZF8X6UA=;
        b=Uc5DWruRU2/f3OrTSlCRRWVdCvVedeAeVTV7siI5d+Dnj/Duh49KeLkFqgKkUdh4lz
         dTATIEuvc8cbeCLn6cLusuA+oi38hjkzMC0tqKodJvbEV8OjFxHbD1KPF4Du7w5/42ZA
         NnINFvUejnuobAefKlOhWrRNCBcKYus+6uNwUCyQVUgYg1W2ExhypNTO7jXBPWOaCc+D
         G9esh5xxsZ84sYGuDsWSJEuO6lrpxY7aT3aPwuBnVRX0OUhlcIjQkzOPtZxaWp51uvcm
         4Enir6npudVrT2XEMO3QnvBvXdjZxowgVSdETUV17Qf+FtDyiRo60dkt8f0JgB+TN+ve
         vUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738947; x=1793343747;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LlYuG6WB38gIzmIC/YDa25c8nS2xNNSGEFoJZF8X6UA=;
        b=dugZ6kFgGb3qRL5kKhm9GujpAhNF6VuE9vgwYEBzzoRowXLlRIzt+1ECEGLpg2b89Y
         lQZwu9JVG1GTfBJqpVWSpoQ758bjHxJubMRR7/vFKvX8UKrnW68ONBzqTri4olevHSk4
         yafiGKpsUxRpqQLQdiLiHOFB8MUW51JTItFD9JU+N6F4s9/TEtTkro9/EDQ9/Eud7tv+
         F/YDdv2bGMK8yfHNJQvHu3sYE/8zxEmZK7ilfRG5BImXOI58VH8QhhcX/tpxfZY/F4X4
         BYR2lsoQMINLL/Aux8r4Vb1ugq+k3C8m3YutISMea5G+r+yKZ2Xx7bd5gkhUlk1+8yov
         wb+Q==
X-Gm-Message-State: AFq9FYKReme2bA/p9Qs9OvYlsdg6TpkPsBYqyRHR0MDgbd9zkBgtv4Pu
	y8vuq6pqrnRqlLNwLYbZPrJXUi2ZUBhVXiI/hPCo6Mv9I+6b2RoKketWZn0UHuuxOiGcE9rQeMt
	MhkmvuhAgf5FoOjxE7VuQSe+rN6yPQ/n1HgIOwp4u3a6y6izJ4lJc0ozW3z4yq1AX2f5MTg==
X-Gm-Gg: AYBFou01LDuCidATRFLpALm1bqU6QtPmG1xNjehsX1Gs8EUWHCngegFF1PyPWoxgisw
	DKfdYPBdejop6B6g63bwSCQVD+LVkgAcVXGxkGDxI+1wZZUXSi+7V27UvbuMn7d/O5SswyMvFN6
	poE3xZ08QbDgzWvyf4Nel0CoXBZR2Hhq1C1LYsDUWrVofDL6tTxYpKfHRl4hbadBJ+0W79iwazB
	ipE3lD2uDNzfe84HsXZJ+6KPCSCmjvWzmvqVVNVzRdNfigE6I//QwNCyopRUEMdnMevldAVL/cM
	H1iT2V7YC/Fz3Tfk4KuQq9hP+t/Spj2PdBO/4yY0Z9cF2eC0K3NgcrK6T1PIIXwdSCstcLmwrC3
	HOtIQtH7llFhX9TjO791T4GTr5zagnBq6tWvFzVrZynrExx3QRbdGJCbsVbxqjptybNBmBEkA93
	p7nFOwG8MeOh97Jm5Qfy0IVw==
X-Received: by 2002:a17:90b:2887:b0:3a0:516d:9f87 with SMTP id 98e67ed59e1d1-3adce5ee37dmr1056171a91.13.1792738946644;
        Fri, 23 Oct 2026 00:02:26 -0700 (PDT)
X-Received: by 2002:a17:90b:2887:b0:3a0:516d:9f87 with SMTP id 98e67ed59e1d1-3adce5ee37dmr1056152a91.13.1792738946137;
        Fri, 23 Oct 2026 00:02:26 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:02:25 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:20 +0530
Subject: [PATCH ath-next v3 17/17] wifi: ath12k: Add QCN6432 AHB support
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
Message-Id: <20261023-mpp-bringup-v3-17-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: 4YU_qFa8WFymzAk8vzS1QAzO5784Ajgs
X-Proofpoint-ORIG-GUID: 4YU_qFa8WFymzAk8vzS1QAzO5784Ajgs
X-Authority-Analysis: v=2.4 cv=dphOmFg4 c=1 sm=1 tr=0 ts=6adb0683 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=R6GObu012cZLLkk_EdgA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXxvoJVxN+ZpXg
 xHrOHhu6JhfUkcSx6SKZADJZ/9gne/i4MjhvuJZDlOKz9SHRefdu02gj/+57Ax3mPvBUdV0IPMX
 vPHoz6Ihk6+DoV0w227cIwUnB0u6pZg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX6QLHp/kHD68X
 PoXj0+oet3jwiJQwv3vLda9vC02HguQ8V2w/ZS8QeiyKF3HWP5dsMqR2U8Itsdx/VS6tmkX/KCQ
 8u5arbY4b4VrY9BALEGX0x02nC4a5yNO1PT4Q3GxDMeR5686IWIvr9pJ4r3C4UWC1KGULb4cvtg
 A1kjcmND8N2GMwwx3UEL1FNexPYNyKfhWg5xtWQ/FYV4NoyhES9xlDWpxDgG9YMi0pP/Q5nKMPY
 V5owdO9H8WIgH3CLkqRhInMsKRkyx22PTB+LhSUdg51T1NCuMX97a14zJlNW8PxjjZH7XXUEm0f
 AsWMWuKPowHW25JW+lCTGwHOlS6Dw+puMviGGqNsjLD5YB1BbU2yd/XDTCmHbaPx24HV1MZnf1l
 qM/Aosv2EhcCV/fXB6I5B3lbLllkJcl+8Y6O1RdXlD5an1A6N4X7tXH6gDOgm1384uQfJNBJQCK
 U8W2qvilbDJuxYB9adw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

Add AHB support for QCN6432 by adding its hardware descriptor and
device-tree compatible entry.

QCN6432 uses a hybrid bus where the CE memory is handled through the
PCI interface. Skip the CE remapping and cleanup in the AHB resource
initialization and deinitialization for hybrid bus devices.

Also add the UserPD mappings required for the QCN6432 devices.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c       |  9 ++++++++-
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 11 +++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index cecafc12e8a8..b55590c64a2c 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -1233,6 +1233,9 @@ static int ath12k_ahb_resource_init(struct ath12k_base *ab)
 
 	ab->mem_len = resource_size(mem_res);
 
+	if (ab->hw_params->hybrid_bus_type)
+		return 0;
+
 	if (ab->hw_params->ce_remap) {
 		const struct ce_remap *ce_remap = ab->hw_params->ce_remap;
 		/* CE register space is moved out of WCSS and the space is not
@@ -1289,10 +1292,14 @@ static void ath12k_ahb_resource_deinit(struct ath12k_base *ab)
 	if (ab->mem)
 		devm_iounmap(ab->dev, ab->mem);
 
+	ab->mem = NULL;
+
+	if (ab->hw_params->hybrid_bus_type)
+		return;
+
 	if (ab->mem_ce)
 		iounmap(ab->mem_ce);
 
-	ab->mem = NULL;
 	ab->mem_ce = NULL;
 
 	clk_disable_unprepare(ab_ahb->xo_clk);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
index 889361e637af..ae5380eb6f8f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
@@ -18,6 +18,8 @@
 
 static const struct ath12k_ahb_userpd_map ath12k_wifi7_ahb_userpd_map[] = {
 	{ .io_start = 0x0c000000, .upd_id = ATH12K_AHB_USERPD_ID_0 },
+	{ .io_start = 0x21e00000, .upd_id = ATH12K_AHB_USERPD_ID_1 },
+	{ .io_start = 0x19e00000, .upd_id = ATH12K_AHB_USERPD_ID_2 },
 };
 
 static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
@@ -33,6 +35,12 @@ static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
 		.ops = &ath12k_ahb_hif_ops,
 		.supports_multipd = false,
 	},
+	[ATH12K_HW_QCN6432_HW10] = {
+		.hw_rev = ATH12K_HW_QCN6432_HW10,
+		.auth_enabled = true,
+		.ops = &ath12k_ahb_hif_ops_qcn6432,
+		.supports_multipd = true,
+	},
 };
 
 static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
@@ -42,6 +50,9 @@ static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
 	{ .compatible = "qcom,ipq5424-wifi",
 	  .data = (void *)&ath12k_wifi7_ahb_desc[ATH12K_HW_IPQ5424_HW10],
 	},
+	{ .compatible = "qcom,qcn6432",
+	  .data = (void *)&ath12k_wifi7_ahb_desc[ATH12K_HW_QCN6432_HW10],
+	},
 	{ }
 };
 

-- 
2.34.1

