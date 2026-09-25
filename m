Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B46C4E06F9
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351920; cv=none; b=TWotHpk00E+a1VGtWAcPYSik7QKsKgK7FjD5rtlbosHCFzBKWuXzy3Qo4+Q9xhfKnr6x+wi/6vlNdF+vNTibN8fkCKHV4sdu1nZkrfYbA46Ad9QhzoBBUKiQIxviKmb7Msfk2DbxyZrMfuw1VZ0gm0DKmwQCV1hdtOuXD21hBdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351920; c=relaxed/simple;
	bh=snaS/I4Hb8yCdgn5ECyoCKvWNHrkWAmTGwXoXARznGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh6tCxicdqCS5N8ITFHR+Q2xk68xUBnIRHAZqsNxzp/zAvlmtHJ19PY4JG4/HDMRxD2ydW0Xw7a59m8EWLb8UUQ4+cKeGvLlskzvY5BsmISUU4bMK6xY7vLmcrO4WkWO+3mi9Svl9y4r43UC9AYmUOICmY399FkuNSJHAbrZ4tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bxg0wKFs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GaN456T7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bxg0wKFs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GaN456T7"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PDQuTa600599
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ySc0a6RXUPc
	52wNB5/s9LfTmLDyBrV82ex9cPFNjiSc=; b=bxg0wKFsHNjDYHIiEqmTvQWvwMV
	5Nifc4KXUahwyZDMhJ/Uuv5GKjp8sFZ8QKLFvqvDfE4Jr6/hNahGwU4YFgOgkcJL
	RmHMUOfwVKkFGKgiVKweDgJ6OGD6x3Wxb/PlEvoB9uEGmlJ7FU/UtNjegP9Bmxu8
	TANC9W6tQ+pigu6YmdqkRDDgAUrCwATF1hLkBu+CeP+CwZ6CmL0bDzxqLJGrAv6b
	teICyY4UVEPGmxSLnAjq/s6PUZ52w/fcExzJie8VlICxt7Vtmiebx+VtmrN1XiPH
	3hYl6njSsDCk4We8i6S+Q1t0x3tzNMkcQ4YvwE0eG0EmKym71sZBEd8euvw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjpvt28k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:58:31 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-881305e5c98so3693b3a.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790351910; x=1790956710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ySc0a6RXUPc52wNB5/s9LfTmLDyBrV82ex9cPFNjiSc=;
        b=GaN456T77RCBmPIgeuN1bJHsC9/SOV2FeP826CMEgZjhUdSoLjNGIJ4hjx/mjSeC9Q
         66zRyaOu1zCNxrKYskMkrmpjnAXy1DDjvIzaQZK8W17OHH850VFzem6g00BdEu4K8cN+
         FYHsPFFxpUfxSVBMbH9oXPeY4u6gpTYwhkx4/hHtDg8qwhsasbsLS2qyn2xOUK59KsOy
         eur0QUgJ7rNVHMBOvvk3MaU46Y5x/VPhgcGvukSzhvkneaBNEJR7Q3ngYRLDVbWgwIG5
         vKahEunchpUjpHNsrwOM8qHjQ3bEtbn3eEz8mJPH5TbDO7Yr/z0vwsxf2+WozmBdFkjU
         IXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790351910; x=1790956710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ySc0a6RXUPc52wNB5/s9LfTmLDyBrV82ex9cPFNjiSc=;
        b=jygv4XNECTQK9HC3tZBXMU0QTx7ri7ub2atYq8nXFazSLfcFAZfd+PWSu/q7gQIukO
         FAOAx0zNhfIVFCA9zStR9XlvrODM62Jq9/JHgWBN9ZuHdKKIpAQz4+9RVzG5wK7DXgg9
         ZcOF05CkAuXYcVucNmSCXni/Rnjtlrdx+EyhmbNodZr6K4QgdhqUSVy8No/5TGt9OUcO
         TP0q4YKyfazBvGsjtiacRa12eRhSXrnKNbkv+K54VpM3IMvwM/dzVaHMpKRB91Mp4nPk
         njh0nSyvUUtea89DU785MWyaT+r73Q1dpzecpvXXPTRTsDYyHNPFxLfRub6p5ugkHqhk
         D2bA==
X-Forwarded-Encrypted: i=1; AKwUvBzly38Hjhjot4J91tK7y6lulunR/wGiWWdB+q8pMaN8bFLE9Ke/UvkowkpPILVdmX4x3eZTkWKQePzzCxzb5A==@vger.kernel.org
X-Gm-Message-State: AFuF++m7rYW2OUZU9Ty+qy/d5YPWaSEvu88fA0NSUJt0U0ZzPEswkVe+
	RyKIlhno5c0wuoSDK3wMsQ6YUYXg9Rli/WwdAmZpNhSX5I5IuZstZMFm4q/m2GRPxAaKbeeNffx
	7a/nFBymmUE7m8h7zia0wLCfzLjziXZCRSoOavzFfZHx9c9/sQN0Cj59wv5CKYUSJ2kg0kw==
X-Gm-Gg: AYBFou0em+RoUF5QpUYw+7GiL7hRG21pWB8i1ZtoWCSCAcO8MRLYEgYg7S/Byaozdp6
	LHAW9UiU1IHsulepJ6/IpGTsAvsjiiRJGHXdnGmr7T3EepSFYm8RdRsPCltOgsq/vZ8WK/MzLxt
	EjKbDFBDIAf/fjY8Mlk06+muHWKLHrEkgUPqPj0d2NXbeUlAWbY7yOEm+cv9LDRw0kZzaYWrExb
	+5ZuS1oIgRW/uxtozPA16NFAWVw3yWF6M7DXew/FZF4IdMTW2v5EchJdH5PchJMISVW1C04c8Oi
	YEIPEbXGxHcLDcpgtQ7ovvvTdwfBM1SKUpM1welZztTpEbx61QDC6zgQT9AzxAHDCUPJnkAYagq
	8F9t1oQB3jJS8kR2Nq029vKFJSpI=
X-Received: by 2002:a05:6a00:3d4c:b0:86b:b06a:d3ad with SMTP id d2e1a72fcca58-87e99568559mr5209970b3a.23.1790351909930;
        Fri, 25 Sep 2026 08:58:29 -0700 (PDT)
X-Received: by 2002:a05:6a00:3d4c:b0:86b:b06a:d3ad with SMTP id d2e1a72fcca58-87e99568559mr5209932b3a.23.1790351909300;
        Fri, 25 Sep 2026 08:58:29 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87ff354d854sm1361299b3a.2.2026.09.25.08.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:58:28 -0700 (PDT)
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
Subject: [PATCH 3/8] media: iris: migrate firmware loading to qcom_mdt_pas_load() and qcom_pas_prepare_and_auth_reset()
Date: Fri, 25 Sep 2026 21:27:32 +0530
Message-ID: <20260925155737.4161358-4-mukesh.ojha@oss.qualcomm.com>
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
X-Proofpoint-GUID: 0LWHbo-_FMeeOM3E-Dr_DRU66-L0OyIQ
X-Proofpoint-ORIG-GUID: 0LWHbo-_FMeeOM3E-Dr_DRU66-L0OyIQ
X-Authority-Analysis: v=2.4 cv=aLBlOr9m c=1 sm=1 tr=0 ts=6ab69a27 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=Wu4PtPgZBy_53pNpwMMA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfX871TpTE7LNKk
 sr4nRuAx5LgaYIkNI4tJ2bBZyzy/3tW6GID1p8FzGg3XmmZ+otqXMqbQXvbVUH8MBLR0gmYfd3Z
 aXjX+wUyWnyocRjFxVH6voX4S9RJdEc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfX1175aKICgclM
 iKSWf1vt+aDTzykcGILUTpP3cfRoMb0Qw5h0jo5t6mRv0wJYLt8ewtyKiO5oHzouMkFZNRlStE2
 sSET+Gj6kLcKKJjn+osNoi+pStL/Jz+TrO43MdB0PfOtQozQozbF1OzrWukTWEPEefmI0SgW+6x
 AXklnfnouzcg2bN4PYL1kh8OFQTSzB66DJEHTQS61raSBtUbbZUXQ+1jFmOAuHyGvtEJSB40LNj
 1KkWXNRsRzCn76yU7+/UfKHk/um10Ps7BFYrdVu+IVcLItPmlh3ZoqTfnRgIkc/rd+qz/c1SIcz
 fFf5MoyEeiA7pwYajVndE5ApT3iX5k9vnP/bxaSifs/g7KrjWwmtI9mcAQaUB2odLqTEqYxLgjj
 taDVIekPx0N35Q4IYMInqnAhx13CUbU79DjHM8zMNzbamDDGJyAY/CqhezILjjCX2xSD1XdmYwT
 D4YopxeyQ7qNJaF3U9g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250063

iris_load_fw_to_memory() calls qcom_mdt_load() which bundles metadata
init, memory setup, and segment loading with no PAS context, and
iris_fw_load() calls qcom_pas_auth_and_reset() which skips the shmbridge
prepare step required before TrustZone authentication.

Since the auth call is in a different function from where the PAS context
is allocated, add a pas_ctx pointer to struct iris_core so it can be
threaded between the two call sites.  Replace qcom_mdt_load() with
devm_qcom_pas_context_alloc() and qcom_mdt_pas_load() in
iris_load_fw_to_memory(), storing the context in core->pas_ctx, then
pass it to qcom_pas_prepare_and_auth_reset() in iris_fw_load().

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/media/platform/qcom/iris/iris_core.h  |  2 ++
 .../media/platform/qcom/iris/iris_firmware.c  | 20 ++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_core.h b/drivers/media/platform/qcom/iris/iris_core.h
index 24da60448cf2..68e6adcc1dfd 100644
--- a/drivers/media/platform/qcom/iris/iris_core.h
+++ b/drivers/media/platform/qcom/iris/iris_core.h
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/pm_domain.h>
+#include <linux/firmware/qcom/qcom_pas.h>
 #include <media/v4l2-device.h>
 
 #include "iris_hfi_common.h"
@@ -123,6 +124,7 @@ struct iris_core {
 	/* encoder and decoder have overlapping caps, so two different arrays are required */
 	struct platform_inst_fw_cap		inst_fw_caps_dec[INST_FW_CAP_MAX];
 	struct platform_inst_fw_cap		inst_fw_caps_enc[INST_FW_CAP_MAX];
+	struct qcom_pas_context			*pas_ctx;
 };
 
 int iris_core_init(struct iris_core *core);
diff --git a/drivers/media/platform/qcom/iris/iris_firmware.c b/drivers/media/platform/qcom/iris/iris_firmware.c
index 21cdf1c39835..e73a5dd98b88 100644
--- a/drivers/media/platform/qcom/iris/iris_firmware.c
+++ b/drivers/media/platform/qcom/iris/iris_firmware.c
@@ -115,9 +115,7 @@ static int iris_load_fw_to_memory(struct iris_core *core)
 	struct resource res;
 	phys_addr_t mem_phys;
 	const char *fw_name;
-	size_t res_size;
 	ssize_t fw_size;
-	void *mem_virt;
 	int ret;
 
 	ret = of_reserved_mem_region_to_resource(dev->of_node, 0, &res);
@@ -125,7 +123,6 @@ static int iris_load_fw_to_memory(struct iris_core *core)
 		return ret;
 
 	mem_phys = res.start;
-	res_size = resource_size(&res);
 
 	firmware = iris_detect_firmware(core, &fw_name);
 	if (IS_ERR(firmware))
@@ -134,21 +131,20 @@ static int iris_load_fw_to_memory(struct iris_core *core)
 	core->iris_firmware_data = core->iris_firmware_desc->firmware_data;
 
 	fw_size = qcom_mdt_get_size(firmware);
-	if (fw_size < 0 || res_size < (size_t)fw_size) {
+	if (fw_size < 0 || resource_size(&res) < (size_t)fw_size) {
 		ret = -EINVAL;
 		goto err_release_fw;
 	}
 
-	mem_virt = memremap(mem_phys, res_size, MEMREMAP_WC);
-	if (!mem_virt) {
-		ret = -ENOMEM;
+	core->pas_ctx = devm_qcom_pas_context_alloc(dev, IRIS_PAS_ID, mem_phys,
+						    resource_size(&res));
+	if (IS_ERR(core->pas_ctx)) {
+		ret = PTR_ERR(core->pas_ctx);
+		core->pas_ctx = NULL;
 		goto err_release_fw;
 	}
 
-	ret = qcom_mdt_load(dev, firmware, fw_name,
-			    IRIS_PAS_ID, mem_virt, mem_phys, res_size, NULL);
-
-	memunmap(mem_virt);
+	ret = qcom_mdt_pas_load(core->pas_ctx, firmware, fw_name, NULL);
 err_release_fw:
 	release_firmware(firmware);
 
@@ -166,7 +162,7 @@ int iris_fw_load(struct iris_core *core)
 		return ret;
 	}
 
-	ret = qcom_pas_auth_and_reset(IRIS_PAS_ID);
+	ret = qcom_pas_prepare_and_auth_reset(core->pas_ctx);
 	if (ret)  {
 		dev_err(core->dev, "auth and reset failed: %d\n", ret);
 		return ret;
-- 
2.55.0

