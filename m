Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793773828;
	b=peYqmWDJmuwMV/BKfYdpJjShZW/z4zeh3Lyixs2EaftVwlsVqDhFgsfU8vZ6iE/DbLpT
	 gUl+SKnuwpORKWGjb/+jZpNPAB4449X6aoTweHRxv6OXBFSDsLdwGF9h1VIA63xK+boyM
	 A6r4T5KcStjVmV05Pk6aDu/YUtadkPYBd+0OJOl7rxBVGiQqLYY4SvwwQZCfpRpVDSGEk
	 Lo8fy9EcP/pmDYHr5FmZqu4igfMITiml3wSPXT7oQVkdrizh6fYoTd++O9JMzwgnSDWMh
	 jyahTN1tWna3KCMMhUpCvQJ6oar2YgFoft6N5EcuHxmN6KztGdOCtGlpvrZHVcZ9qcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793773828;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=;
	b=4AWlB/t5HrzJ8laHjxgu9NIT3VOrUMN+nlvTlH0dvs6nN5IbWZOgGAdhOmaL24rDwUcI
	 nu7GekNyHm0oEh/HW9zZcu0UnegspWcTwfdccT3lLutszT+QGi4zmErGhyjmtuX0gXsQk
	 ixT3cGo1+jeym59hTfVXOPE2tzT1xLoc9FXWHgJufdC/EYdKCmfUI5Fq7HUhA6xrEALW5
	 lnf2AabDcngfCrfTZpIpom0fvfibuijUNFSHQlCUaaJojqMoAfjbUCbXptT7scYkgDBLU
	 ct4ZT8PEfVMU0nUWVby5OqAH+RJkQGa64f2Or/RfiRjEgws9PCbcZptu0pHpEkI/o4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AEpwSuDB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y0Cq44EM;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59387606A32E
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 06:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59387606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AEpwSuDB;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y0Cq44EM
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40R11M1191097
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 06:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=; b=AEpwSuDBXBr893DP
	ptRuIdI3D8LXLves0VONr22OECRU+8fQ6tQXNqmQRhEon144OlZYFQTyYVpngLRG
	CnakAe2vXFdx8O3hW3OHDa/opRpxnyjxrWmDnMqfWcXTQNyPy9927WWd8dY1FrMi
	ur8WtKlyQ507Y3UmMNPE/Nm15ZHbMN+wN3Het9ttmrMaZwcQ9mS7Yb50HXJKKAYl
	Xmkn+QkhgIrpXGaKkicVDsHI0dDkG+CB8KL8+TmHCF6ZrTvJUF48M6JbqUFXV5HT
	3X2Skc2RLUXmVete/9zZEHj3yDJd7IlYptco/tyzQPOUTqGaRdg/l5akxbdyySWm
	I6QDZg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqm2pjnj6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 06:30:27 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc7d2ff0087so330734a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 22:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793773827; x=1794378627; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=;
        b=Y0Cq44EM4wFtZNpR+jEooBpqfjrtWXKmhR5jxgZWVKYAtfhyphkYjoY/V4ooinuwnB
         +/UIRr2egxQRPtK/+NbO3xuCEp4gtTq+ycxixG92XdtMj439PqGhCIgPTuNEtLZNbaUd
         5zatXcPRqk2Csqoo8kMW7CDS2F0Mx3viq+VpzVHmIIp+nIUJOWe2JOoMmvZdHZ4cY5YJ
         EJf3QH7vt0/OvjxGRWg8a9njvjFRXeUWyDEeF9O/+23dTsEDET0wZrYCWRAyNQbDSti9
         kTBCzLVkr3z7/y54qt9XwlowXmaQQdEvsmG/pgNGfPv3ovolzW3MoBL8D4w0MLLl/07j
         21Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793773827; x=1794378627;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=;
        b=VTqL356ccP4KbmRbDyKO7+QNN+IwevMGeO4PtbdvSJx6IDv3LMB9umHvDFr467ZEnz
         +oF0INo8PLoxzLPUDT8b1N/9PZHrfwoNIB9D0whLojcuZArhKXLrk3JvDoia2sCkgrr1
         Z1hrPmt6DZKE6pqoXJlPZZc1avRsHiOHsiACvWb2v4Lcvgrl2cWlTN/gEECRuto2kbBm
         3AHK6mNh9o7e82ppR8f2KyJT8rq0LvmKK2HS6v6loWXl/6vYSdda+3S0AeNzfmOeMl/d
         CbSDbEArARi0aOL6UhxxSzlVoRbBqhEU9W96rlDXBgxrN+gZ+8L1yMjMzP6y7u8H4+Ha
         XCQg==
X-Gm-Message-State: APuU4Z+cYdDOfB0IUrawSzNWG0ybR2mFsoFLUP0cKdeHd8+mTUW1RFqT
	2pv6UrmAF2IoJzXJxmi1iBcKI2GZCH1a2axqHajz7/7fNKY7uU79G/uq8Z12GkZKtnMyw2SF/hZ
	tw4hlQMpTRHE/HtyQd3z+hb+5msDrc9SVPY5PZ5FDOyAZ7QO+KGNiyf9yxQad+0jPe94K6c/Yyh
	qnFw==
X-Gm-Gg: AYBFou0oLeqmMObBo7Qw6iRlV+ni7XgHW8LdJUVooRHGi3EqlqF9DAgtqgiWK3Zw9oC
	CjQW+nepwE/AV4Cg0jwNj32DARjpd6W7Io8Dg3kz8/pC6Iraen65PAvVXHlWScl1oxj42LzAJMy
	UYek8BbiTjsJABhesIrpgAQeyZrIWG5lzroIzUNMvvzRQpS5v4nIbM0QXbl3tERWh+dUFrsL1Xn
	YmL8BxSlQWSx3y1KEaYhV+5RT681wEzR/YWrgkKM2I9LN7kxk6dkKhEff/V8vkZ5GJR++7xgm7T
	LQ7CAdJFxDIri6O0Q7aTl4keozRxxo+xmY4WolY0JAj6pG+TfenT823MGRaIGKIJXKtRh/+tlWY
	rVLcCdJbUUxCH/nzynbhawA9yMiSUoAV3Bn+AbDgvvn5nrqlrIO0Kk0le8lariIodTMwKgjGkBz
	KFVf/jxgPlQLBLAuGprXFeCEAF8P/xW9xhgoL4bXCST0YTJCigeqBqPssakYj0k5KPgfoh/fakw
	Q==
X-Received: by 2002:a17:90b:1a88:b0:3ae:3f20:7056 with SMTP id 98e67ed59e1d1-3ae89746c9cmr13784752a91.31.1793773826563;
        Tue, 03 Nov 2026 22:30:26 -0800 (PST)
X-Received: by 2002:a17:90b:1a88:b0:3ae:3f20:7056 with SMTP id 98e67ed59e1d1-3ae89746c9cmr13784734a91.31.1793773826046;
        Tue, 03 Nov 2026 22:30:26 -0800 (PST)
Received: from hu-madhgane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm2420646a91.5.2026.11.03.22.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 22:30:25 -0800 (PST)
From: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
Date: Wed, 04 Nov 2026 12:00:07 +0530
Subject: [PATCH ath-next v2 1/2] wifi: ath12k: rename m3_mem_region to
 ath12k_fw_mem_region
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
Message-Id: <20261104-m3_and_aux_ucode-v2-1-b6c335c14dfe@oss.qualcomm.com>
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
In-Reply-To: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyNSBTYWx0ZWRfXwTs67e1qG9tj
 HikrbDoCB5l+bh+zAd9U9/TSpW32XiQi9qsqK0nlUcWLfOjDBFysOftrIofl1fMzUROM7jCCrjO
 v/7J7orwzsVV/bl0YeSmJQ39BoLctT329rsphldnmeW3ODeQV3Ro02HiohIy4Uw4DwX1KQ0BTxw
 HXTSuUZmyfx9SadBb8N5iY+XcEki2ajb6aOVOki/43hvKjjhjhhYVkbNaECYuiHcjt5Lo83ZPsc
 ofHkeK2oni6wguCEBom4yNrO0m/A1vsGPq2ncpd9Uq23pcCJAMhh+swJXXHNrGbflFxLPowtrgj
 dxntuNGOSA2nJABhGx0U8Kjd/99o8W50q0RBB1WApcpttmgOzwCMgm+RbEGXHuC7kGuo7r3/Ogu
 F3at4AxVuDMMhGiMIyDNuw5ViNHLrHWH1knE+ix/mSDZ3XNTPiE1l9PUNiZmeRreOUG0hy8pG7I
 3oFD6l8MYSx+O9uglcw==
X-Proofpoint-GUID: QNY2Aa1CHfGqoa-U9o0aVM3BFnaoYe9D
X-Proofpoint-ORIG-GUID: QNY2Aa1CHfGqoa-U9o0aVM3BFnaoYe9D
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyNSBTYWx0ZWRfX8ebW45R2/fTm
 /mDPpwXA72BR65jPhqsU0Js+3RyYsaz6GV9Wb9Lif4dhW9zOuMmeNMhRoC6oP4TtBmUsGWq+5OC
 jlqiKrLfCFzO+P30i3UpJBnWnyjx6Gk=
X-Authority-Analysis: v=2.4 cv=c64+0h9l c=1 sm=1 tr=0 ts=6aead103 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=J5wuaM5RjebvB5ep-PMA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040025

struct m3_mem_region is also used for the aux_uc firmware memory
region, so the name no longer reflects its purpose. Rename it to
ath12k_fw_mem_region to make clear it is a generic firmware memory
region descriptor shared across m3 and aux_uc.

No functional change.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 12 ++++++------
 drivers/net/wireless/ath/ath12k/qmi.h |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 817bd820623d..b1efed1702cb 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -3227,7 +3227,7 @@ int ath12k_qmi_load_bdf_qmi(struct ath12k_base *ab,
 
 static void ath12k_qmi_m3_free(struct ath12k_base *ab)
 {
-	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
+	struct ath12k_fw_mem_region *m3_mem = &ab->qmi.m3_mem;
 
 	if (ab->hw_params->fw.m3_loader == ath12k_m3_fw_loader_remoteproc)
 		return;
@@ -3244,7 +3244,7 @@ static void ath12k_qmi_m3_free(struct ath12k_base *ab)
 
 static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 {
-	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
+	struct ath12k_fw_mem_region *m3_mem = &ab->qmi.m3_mem;
 	const struct firmware *fw = NULL;
 	const void *m3_data;
 	char path[100];
@@ -3309,7 +3309,7 @@ static int ath12k_qmi_m3_load(struct ath12k_base *ab)
 static noinline_for_stack
 int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
 {
-	struct m3_mem_region *m3_mem = &ab->qmi.m3_mem;
+	struct ath12k_fw_mem_region *m3_mem = &ab->qmi.m3_mem;
 	struct qmi_wlanfw_m3_info_req_msg_v01 req = {};
 	struct qmi_wlanfw_m3_info_resp_msg_v01 resp = {};
 	struct qmi_txn txn;
@@ -3359,7 +3359,7 @@ int ath12k_qmi_wlanfw_m3_info_send(struct ath12k_base *ab)
 
 static void ath12k_qmi_aux_uc_free(struct ath12k_base *ab)
 {
-	struct m3_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
+	struct ath12k_fw_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
 
 	if (!aux_uc_mem->vaddr)
 		return;
@@ -3373,7 +3373,7 @@ static void ath12k_qmi_aux_uc_free(struct ath12k_base *ab)
 
 static int ath12k_qmi_aux_uc_load(struct ath12k_base *ab)
 {
-	struct m3_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
+	struct ath12k_fw_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
 	const struct firmware *fw = NULL;
 	const void *aux_uc_data;
 	char path[100];
@@ -3435,7 +3435,7 @@ static int ath12k_qmi_aux_uc_load(struct ath12k_base *ab)
 static noinline_for_stack
 int ath12k_qmi_wlanfw_aux_uc_info_send(struct ath12k_base *ab)
 {
-	struct m3_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
+	struct ath12k_fw_mem_region *aux_uc_mem = &ab->qmi.aux_uc_mem;
 	struct qmi_wlanfw_aux_uc_info_req_msg_v01 req = {};
 	struct qmi_wlanfw_aux_uc_info_resp_msg_v01 resp = {};
 	struct qmi_txn txn;
diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
index 1b1c88906f1e..e43e4a42aad7 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.h
+++ b/drivers/net/wireless/ath/ath12k/qmi.h
@@ -118,7 +118,7 @@ struct target_info {
 	char bdf_ext[ATH12K_QMI_BDF_EXT_STR_LENGTH];
 };
 
-struct m3_mem_region {
+struct ath12k_fw_mem_region {
 	/* total memory allocated */
 	u32 total_size;
 	/* actual memory being used */
@@ -152,8 +152,8 @@ struct ath12k_qmi {
 
 	u8 num_radios;
 	struct target_info target;
-	struct m3_mem_region m3_mem;
-	struct m3_mem_region aux_uc_mem;
+	struct ath12k_fw_mem_region m3_mem;
+	struct ath12k_fw_mem_region aux_uc_mem;
 	unsigned int service_ins_id;
 	struct dev_mem_info dev_mem[ATH12K_QMI_WLFW_MAX_DEV_MEM_NUM_V01];
 	u8 dynamic_ddr_support;

-- 
2.34.1

