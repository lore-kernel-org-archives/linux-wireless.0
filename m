Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EE34D9F72
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351947; cv=none; b=a6AlqdFrbi/pzwQnSbs+MQo3GHVOaaEr2Pep8syE9rR2A6fmc4IuTz6W9uXa+PrwK/6HmJs/vdDAtj8silwFQhEVa+/JnGZVQvt7VIlA5+RWn9lelEBXQRWoWVotLgWW3mI2IgQfxjM7uDyYgewGYA7QRIb/0H4tUEdKjqHWvZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351947; c=relaxed/simple;
	bh=QaVcCt7Cl7nU6VeWY+Vur4I+1RuVSN+tC3sOeWr2eqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEQPU9LSckXRH05jW1iRGOeNIvbPL10uDDwIiXKWW/u862+dZ/uYcL4rGklH6AI62j4O6uKRhveZJSPEKQA9gnuyevfl2IgF8G5LPGylvl2MLTjjE++5bHsdnfXiof5t645zRDgdh8eonOYicWTz98LkxVFa14nRFDNYNCu9JeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Je5YtJ+Z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DMxhH4OD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Je5YtJ+Z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DMxhH4OD"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PEFNK8756679
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=p+LQPvJJTeU
	1GNlByxbclHTDDGT157UOusSi7k44uBE=; b=Je5YtJ+ZLvxiFAY66mMnDfFDIQN
	R9qeiE+x6COa9tg25fml5sOLY1QiFg24hhrXIruKfUNtaKbitUT6no5g0XOTJOcB
	EFcm6/LaLj3XVn595RsvDa/Afmkmw68JlIvx53aBg9smhjQ92PhP5ZTV6tDmqr99
	21njqzbQ9k/Lpvo5QnrpunBoc4FaTYMtv0zGxTJl/RiTfBOjIsMnWiACLxLUeF8L
	wbVas0Rf/I5utcdI3brpB6B+TY5M/+QWQJCNYcAjE3hu/A+sNeN/qyXRM36f8aVe
	LKgfdh8K5Ks0+olNeJw6im3zs54wUQhAvbbMJ93Gght8pmCmfSMFmLMgNHA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjq0a3p9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:59:03 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8663802b58fso803201b3a.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790351942; x=1790956742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p+LQPvJJTeU1GNlByxbclHTDDGT157UOusSi7k44uBE=;
        b=DMxhH4ODAamwNSj02yc5WXAbLjAJPecZ0rmiDaTFbWuv0d318s04F8/Yn8gRWjbuiR
         FAAlhF6zixn6QNpLbcJKfKa/0oizzipvELjrvotWJr8YdzOpXL0InzbLgyn7uFwm1tQG
         Ogl7Kt9po5cqDesywuqtURm3PqwVkaBAsi1/1PVmeDCDhNhnR+loaAFxzB+BMJCoV7gT
         dSQ1bDSwl6rJ3G6lJ4OOGs7zML3/w8mmRu7V6zENRYcnPzbuTNxmvHk7tr/B2ZS+9ZM5
         +QPaFJZs2jxQefPM/sMgaKfOBfT7xc6T91++4Dgb4zUE1NAitU784HIE2wcB6PZGgjAD
         Fm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790351942; x=1790956742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p+LQPvJJTeU1GNlByxbclHTDDGT157UOusSi7k44uBE=;
        b=szgtUpjXTnPdDBWyvWx4KAMPIlRaY19YeiBpeUC4G1pEyK4I28/s3C1bwrXNkfRgG0
         PTqRi04fcdSSMrxtfE+xTlsQk7MsicFf4eVLvp6mAMflUn2s61DLVK03WQjg2e+RZloJ
         5np0hUB5gRT+Bwa+irDoHGcedbYEjw+iVbS/cZxc2tFutrgdDesBUUk/DbFmRxQcWjqo
         Jl0+gPkYPDQm/xy0EvS/Wl2w7b84xd8yqHpePvLkMpO9hHFUFYymrnoWRV89YjInvbej
         ivRI18o1qUBJH9Gj7hor+PT9GCASTB2WzQ9pRIgE2fEWRwdQcpOZoFIsmNwld1Pylpk6
         uzIA==
X-Forwarded-Encrypted: i=1; AKwUvBzjv656jRCafxQ3IluPT9OAyRPsVCrrqcMWgHwhVVSyxAd886UU0ZVe+qCQHkzyHCcqhmE34jJtNkn9Di4qPQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kTXe/cDCUi9WPHso2J1KxkwYLey+ISzL6SoaMsALl157b1+cbh
	GKQcUDzubzf6S4G1b8fxOHjHTLpt+pjOpHX0ZhE+K0FmTv0e3gh+gWopu7QnydPzyTqGBNfXga/
	gJ07luBHBY5ZTGZ9htVCjYd3R2HBYtdPE1ozOqxmAJg/R1xwwW4C8dFV9NiL4mKYXnn0Zzg==
X-Gm-Gg: AYBFou3x9zb/cNyCPlsUHbg5xL+vDgYX3oLpzYJ70oYwHHaWTZdYTl0YOsy64B4xCwi
	ME4VN3ufWLa3LtNON5Oq4HL1E41KsL/XIiwJRZLOZ0nc9cbPr+rxETwIWwoVQVaDQ7D89e6ITch
	xYNwbLEiLRO0x/btWk39jDimxDvGio6Kxy8jMTjY57Z9/SGcvDTKVvespweyCqQliMFk0ZGQ0gl
	xi30mIZ3tgXIsO9HHRSay7DSdFIYfaBJ4MvHRDjj5U46t1X7XH8Iszt1x0HeM5lYWvJ60Cp65pr
	Xx1FlMSMXI07TpRmOO0bVjT9xbEevitNKcSI8mFCNLEHLvkWovvaq3RX/VMQL0WGLaA/aEp9MDl
	tka8S1WBzttSJJPYSCcySZrwRZ6w=
X-Received: by 2002:a05:6a00:2a0f:b0:874:705d:f640 with SMTP id d2e1a72fcca58-87e9b89660dmr4973930b3a.34.1790351942105;
        Fri, 25 Sep 2026 08:59:02 -0700 (PDT)
X-Received: by 2002:a05:6a00:2a0f:b0:874:705d:f640 with SMTP id d2e1a72fcca58-87e9b89660dmr4973873b3a.34.1790351941480;
        Fri, 25 Sep 2026 08:59:01 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87ff354d854sm1361299b3a.2.2026.09.25.08.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:59:00 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>, David Airlie <airlied@gmail.com>,
        Simona Vetter <simona@ffwll.ch>,
        Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
        Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
        "Bryan O'Donoghue" <bod@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alex Elder <elder@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jeff Johnson <jjohnson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Abel Vesa <abelvesa@kernel.org>, Sean Paul <sean@poorly.run>,
        Akhil P Oommen <akhilpo@oss.qualcomm.com>,
        Abhinav Kumar <abhinav.kumar@linux.dev>,
        Jessica Zhang <jesszhan0024@gmail.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-remoteproc@vger.kernel.org,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Subject: [PATCH 6/8] wifi: ath12k: migrate firmware loading to qcom_mdt_pas_load() and qcom_pas_prepare_and_auth_reset()
Date: Fri, 25 Sep 2026 21:27:35 +0530
Message-ID: <20260925155737.4161358-7-mukesh.ojha@oss.qualcomm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925155737.4161358-1-mukesh.ojha@oss.qualcomm.com>
References: <20260925155737.4161358-1-mukesh.ojha@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfX4XjJrG73ahXM
 uec/79o0LYNpbEdctQBpmtEohtOyeWF/kkjgWXxGVwZvcQtIHgiWBDISZuzdOk6R+eItNANBTlq
 9yw+vz+1DtKH3+Ms0ILK7j8ImMX8CPs=
X-Proofpoint-GUID: SQHIYTWm3qUtaIFG1QJI07OOY739U6Lv
X-Proofpoint-ORIG-GUID: SQHIYTWm3qUtaIFG1QJI07OOY739U6Lv
X-Authority-Analysis: v=2.4 cv=LNPz05W9 c=1 sm=1 tr=0 ts=6ab69a47 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=MUQpB1KlM5cd8qnWRq8A:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfX4zEdmO31Lde4
 htEjuCV85Nq1pG7/Y/AGJ9FscXBVLItmqtAPnRE1jaah6NTP0wIMpWqbu7ee7x/+OTk5xvqSY6C
 RQom/fVysb2x0N54NRFN90FHLjmHBxNGtrxb2kmL8fU7QKcAzLUB9X3mgWT1HChVt0iUyPG24ma
 5SgnB+nwZO16Hz+yxCuMTcO1aLf7YjI54ekzDuPsJHgWZTGPERB8ezzxqaeW//sKyL9vorw6UES
 VxqfR0tmr5DKJfwivZ0rOhpYJWhMl9ZNByLbSBUmq0GPrnB/17IIY75/drNuJJy4VC0Yya7ACFJ
 f66QciCgioLW7WVRQpDBb1Gb5BcKKyiCE3MJ7YW0DSTF/x/wvnw/w9vagDqZzXkhje/7Wbml09r
 8hXPRxqCKNwBZ0Ncs7nna5p5TSIEqrgR9eMni3MUdttkZPgX1l3damdQm0yv3j3773mMHOur1qk
 nbQ7C5IrG+VjbzFBQWA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250063

ath12k_ahb_power_up() and ath12k_ahb_load_auth_shared_fw() call
qcom_mdt_load() for SCM-authenticated paths and then
qcom_pas_auth_and_reset() which skips the shmbridge prepare step
required before TrustZone authentication.

Replace `qcom_mdt_load()` with `devm_qcom_pas_context_alloc()` and
`qcom_mdt_pas_load()` in both call sites. In `ath12k_ahb_power_up()` the
PAS context was allocated inside the first `scm_auth_enabled` block; hoist
it to function scope so it remains visible at the authentication step in
the second `scm_auth_enabled` block, then replace
`qcom_pas_auth_and_reset()` with `qcom_pas_prepare_and_auth_reset()`.

The non-SCM-authenticated fw2 path and no-auth path retain their existing
qcom_mdt_load_no_init() calls with the persistent mem_region mapping.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 31 +++++++++++++++++++--------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 85360365aa4b..6f0ad29a83f8 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -391,6 +391,7 @@ static int ath12k_ahb_power_up(struct ath12k_base *ab)
 	struct ath12k_ahb_rproc_info *rproc_info = ab_ahb->rproc_info;
 	char fw_name[ATH12K_USERPD_FW_NAME_LEN];
 	char fw2_name[ATH12K_USERPD_FW_NAME_LEN];
+	struct qcom_pas_context *ctx = NULL;
 	struct device *dev = ab->dev;
 	const struct firmware *fw, *fw2;
 	unsigned long time_left;
@@ -424,14 +425,20 @@ static int ath12k_ahb_power_up(struct ath12k_base *ab)
 		ATH12K_AHB_UPD_SWID;
 
 	/* Load FW image to a reserved memory location */
-	if (ab_ahb->scm_auth_enabled)
-		ret = qcom_mdt_load(dev, fw, fw_name, pasid, rproc_info->mem_region,
-				    rproc_info->mem_phys, rproc_info->mem_size,
-				    NULL);
-	else
+	if (ab_ahb->scm_auth_enabled) {
+		ctx = devm_qcom_pas_context_alloc(dev, pasid,
+						  rproc_info->mem_phys,
+						  rproc_info->mem_size);
+		if (IS_ERR(ctx)) {
+			ret = PTR_ERR(ctx);
+			goto err_fw;
+		}
+		ret = qcom_mdt_pas_load(ctx, fw, fw_name, NULL);
+	} else {
 		ret = qcom_mdt_load_no_init(dev, fw, fw_name, rproc_info->mem_region,
 					    rproc_info->mem_phys, rproc_info->mem_size,
 					    NULL);
+	}
 	if (ret) {
 		ath12k_err(ab, "Failed to load MDT segments: %d\n", ret);
 		goto err_fw;
@@ -465,7 +472,7 @@ static int ath12k_ahb_power_up(struct ath12k_base *ab)
 
 	if (ab_ahb->scm_auth_enabled) {
 		/* Authenticate FW image using peripheral ID */
-		ret = qcom_pas_auth_and_reset(pasid);
+		ret = qcom_pas_prepare_and_auth_reset(ctx);
 		if (ret) {
 			ath12k_err(ab, "failed to boot the remote processor %d\n", ret);
 			goto err_fw2;
@@ -994,6 +1001,7 @@ static int ath12k_ahb_load_auth_shared_fw(struct ath12k_base *ab,
 					  struct ath12k_ahb_rproc_info *rproc_info,
 					  const char *fw_name, u32 pasid)
 {
+	struct qcom_pas_context *ctx;
 	int ret;
 
 	const struct firmware *fw __free(firmware) = NULL;
@@ -1012,14 +1020,19 @@ static int ath12k_ahb_load_auth_shared_fw(struct ath12k_base *ab,
 	ath12k_dbg(ab, ATH12K_DBG_AHB, "loading firmware %s, size %zd\n", fw_name,
 		   fw->size);
 
-	ret = qcom_mdt_load(ab->dev, fw, fw_name, pasid, rproc_info->mem_region,
-			    rproc_info->mem_phys, rproc_info->mem_size, NULL);
+	ctx = devm_qcom_pas_context_alloc(ab->dev, pasid,
+					  rproc_info->mem_phys,
+					  rproc_info->mem_size);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	ret = qcom_mdt_pas_load(ctx, fw, fw_name, NULL);
 	if (ret) {
 		ath12k_err(ab, "failed to load RO firmware %s: %d\n", fw_name, ret);
 		return ret;
 	}
 
-	ret = qcom_pas_auth_and_reset(pasid);
+	ret = qcom_pas_prepare_and_auth_reset(ctx);
 	if (ret)
 		ath12k_err(ab, "failed to authenticate and boot shared firmware: %d\n",
 			   ret);
-- 
2.55.0

