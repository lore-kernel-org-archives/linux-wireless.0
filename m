Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793726769;
	b=m6GQOypOgyUkYBdjKKAyOcx5PqNe1VF3WErRKlvkrnoaabJG/Fr1DqsCPUaAaJ1Cp0AV
	 /G/0bIlePfMgtdtyR2DRJwlsdmpUHUeWxvTXuZmQAA5S6/U+mLkpox3BOQquBq6PFAxwr
	 BiWrslWw+nHjGosljWTYonzqJ1vFP2B/UrmkgoaQxQC9X+MCuccVPeAtb749aYdyIfLsd
	 UmHy683nCRb7tIWMz+W4/6EGgl8Xr0BRpGHUTRmhwTe+qC+KdEZArikjpI5ysTd44mGk3
	 4jTcAWQMMIOJAOz1hgyERRgnssZ0+8uNAIGUzPuXs4gc77GObCN8jQ4IMFK3PpQ5cSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726769;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=;
	b=azuk2JcOAlliuBO7G1cFmJ8N1HmSs/5mhD0nj8jE5E7VDIVB/ENs8Emg7NnmkQZA9CLk
	 5ZFhBVCW6GbIIA8YJcqvSBxRiJNWAGypW1rJukqMo+vg6XgSWclPwNdoXbgPeYbSmU4Ei
	 lj5xwMwwfWqv+QHhjh3+3Iib3ZxKsoE/cgY0tTmyPc24NmnzB0nSlJ9OFF+3RuSGxj94V
	 fRaW7CaZyw5N5R+SEDNEIB0evEmiErTPx99AFvWQFwSThO3HD8IxsJ13G9bPBc2VTwIpw
	 f+jotY5HSNeAM3gMWbvRo9uAwC3NdIAJOaxPZxqQDROPi5zHqI+lX6srO56zMjjwggw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aPyFHDBs;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J79yJ2Kp;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7236B606A33D
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 17:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7236B606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=aPyFHDBs;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J79yJ2Kp
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3HPXoG344455
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 17:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=; b=aPyFHDBsXRkWmU9q
	eWjGabTYD70+YC4gdNFEPcZClMGh1E20RTDAHigJtsgcoDts34GB0MiPkUpkufsh
	OWuqk/WWngQeKza9d8JUzA/XpTW9PIfW5iCr1ugnBfXmYOzAWZkO05igoGLDYc2n
	tKpxrcgUCaabRyZ6c36Ip2U60w2EktU+9m+4kL9qdBODF3dmmUNpi1w37hJ8KhDT
	mDzs+XDI7ozEA9pMj+pu4lmcdk9mYzV8oeQg9JISxeREsFVIKRWstschb9DgNOnV
	KXKJ/Luv6Egmy5BzJpHt1AQ3PuF6Ijp7m7CK71Y2vDg/+r0siSJpT0/Bc6SD3Bp0
	kCt+yg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq76dbce5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:26:07 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1af203073e0so4898575c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 09:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793726767; x=1794331567; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=;
        b=J79yJ2Kp5bR7GLTyfmL+nmeqiy5y2xITGWfQAo7nR0uhYkKpm7WhhyHzdmJV1zAfCz
         vHRmSHNTqwa36Pyl+G1IvMfHTkM5QFfzqt1xbYUKqW7uPgn+UWxH2LYw3Ae5k7uoYtG+
         yVcI6LwgCWUX60pYhE/7IL7BKant+J8lQZTpXXUUcALA1nH27PZ7Dy9THXW4K8yXCH2u
         oSKyXK+CIFkIz0B75eC6+Ci9aA7q7WX1SILNgEaWYrJsD0laZBKywMEEnDXamMeaQlhQ
         y9V8h+Q08tQ07InyzhmF+dzZts7jowkzrdAla0jwrdZwvndW7qrWUBp0/AnCmTVXets8
         7c4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793726767; x=1794331567;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4AMJnvFK8SwRYDl+HuoIp6UsfOovvQiFEHmiINggHuA=;
        b=F9jJoIrm3pb9jFpocSpf4LoiudUw/u7Xp8HU+j03J1NwMVAFVlu0U7pa7uT/5g+WyV
         6N3IEoz1jWWqRmglqKM7Ys1x8C1Xotj7aXuuW7TKULDFLEhXTwuoHxsEMJXsXbthoV9s
         LnKCffYRb14RHsALZR5/wTC8fZTuOwdMmbrU9tXYVKk7DhyL6EirY1rWfRgKDEIyWtnD
         FLbO0qNi9EtZK1IuBJEUzGln3fekz1zLH3FkLQzKLOCZttBh/TSUHUyXmYd2Z9w1tgLC
         l/2mpUb/B6AVwZmRpAbh1zFmTmJNOezkX5ZcQ0mNWP+1gZxiJgSXm9rklwd88sfReCh5
         aWUA==
X-Gm-Message-State: APuU4Z+7VpTq/tfRyrpIwngO2JjlPsouPbFWXsu7BWtNOsOi1L18wEs7
	v4oRZ53MgBcz1inpfREzsdezkIpuwAjJc1bYNK/Kt2uZraL0XwPaPO8rJGAxBp6LNFBWzR+GbFj
	3dIfaJwUjOcXiDRQtZeuultAUUqqIW6zCW1e6cpq3a8doNAenQyRnLl5MZ5D6bs3Ae7tjpQ==
X-Gm-Gg: AYBFou3+iZx8N7fMszeYho0wft0BrrITefR/Kn1YOdc+jxNbadPLfyqhFXS4XfR1xnF
	xeoI0aolgQGP1pw1fFbnoMmAb1QPbT4fz4zLQRXL1FvoJZM4KnA83+fcgoFNvkfz69cLwb2YSM3
	tLExJGZpCTWJkBjE7jAwdQD9lsGpzeXnlTU8KC1a8Chh7hiwAoowoAIRFrSnKZZUFKbzDQNW1i6
	SRwiSXDCGHbaJYtajan68P9u1wbm+U6Y1J+ImglimjLzrifTjo6dYdAvoRGzt5ZEuL0dAwOFwiN
	XJGd2/M6NNtB/3XIdkaIMKaDhmf65qqNywY4ZotYJNVnShiDfg9PBn5FMMNtHohZP5ZL/TwyYQZ
	Ru0Tn7ipaUJdj7Y1s4t/zN+5+RJe7IYFwhnuJDs7WqvPE17v2djSx4NAKlHQttRd5dmuedmxLO7
	VzO5nNRhG28AdlH7exVPKaLQQAVwUNGjmC3MSnR8Z5HpEV7nYZrVSVrphoyZ1i9e59kHOfpm/ON
	qc=
X-Received: by 2002:a05:7023:90c:b0:138:30b1:4c00 with SMTP id a92af1059eb24-1ac56d95448mr22902678c88.3.1793726766703;
        Tue, 03 Nov 2026 09:26:06 -0800 (PST)
X-Received: by 2002:a05:7023:90c:b0:138:30b1:4c00 with SMTP id a92af1059eb24-1ac56d95448mr22902633c88.3.1793726765841;
        Tue, 03 Nov 2026 09:26:05 -0800 (PST)
Received: from hu-madhgane-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c272sm357310c88.8.2026.11.03.09.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 09:26:05 -0800 (PST)
From: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 22:56:00 +0530
Subject: [PATCH ath-next 1/2] wifi: ath12k: rename m3_mem_region to
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
Message-Id: <20261103-m3_and_aux_ucode-v1-1-e14f13fdfa41@oss.qualcomm.com>
References: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
In-Reply-To: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=KJTPn1Fo c=1 sm=1 tr=0 ts=6aea192f cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=J5wuaM5RjebvB5ep-PMA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA2OSBTYWx0ZWRfX+EJ954dkgcXR
 sPVAS5JIhyFmktqLfIPRf9CI+wh4QFoEotNAYUaDCa62nlyzW7WFG9qbqdgsjpl3FyJUjkomVuC
 b+xCjv2B3YP6GrnK5pMnnwuR9yMa78s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA2OSBTYWx0ZWRfXyXCoLXordIF6
 gwJUMR5Kosv2iP6HcRGsbWE9uc4ea//uyOVclB3uHdMJo/CxGXztw68arzMLLX0u7hYvBtrd1+h
 0W4t/osDdmOTFrqfW9MvMNHoGD2Y+uoiFULOFDjMBfAVfbTKjPsE7/q0e9QIaurHjE3KC62vlHr
 h61/IRvkTZJmPbp9VN0CXG43IF6uz5FbnRoRK8/6VFPemimKvnV3RlRJqC9fUPm5vUAK/aSp/T8
 fB70L9VzUzp/EP3zb58S1vSoO+8kTfCzvHQRq2J8DgYjdgOnDoe2dO1D5fRRsSTpHXhGP2aP9z/
 m8Ap7KbjxdowYPQcbrmZ0+FZ8VQlMHvxecvjBpsLCpd7D5jj2r2RXoC8AS3bLryLXTXx00r2R1E
 kYhC8mN818iBEP8ETNB6Gtsn11fx+v07hpC9C56P/SUsl71yV9hfQAdAOKZaY+jd77dEMTTBioY
 P5I8ihHpL+c7MIwR6rQ==
X-Proofpoint-GUID: XxzKL_oDeUie-zYZHShjC1EfNk0Sq4Nt
X-Proofpoint-ORIG-GUID: XxzKL_oDeUie-zYZHShjC1EfNk0Sq4Nt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_04,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030069

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

