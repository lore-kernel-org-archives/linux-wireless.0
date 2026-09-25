Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2AA4E2F18
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351929; cv=none; b=HvTzFGVgU5Uu0mqTpeEXT3zZPAme+h/+jUZvE7BJBg3joomrEOWS1cODePpeYHURLTyBgS3osiNGqq1UINmqHaE2iis+7wkGnkfLsavc3wF2dE+MMJ6lztLQYQamDd/pQs3f4p8eSHbFx32WcksvYKsvb5QnOlJ31mxzTBvkdgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351929; c=relaxed/simple;
	bh=Or/odA96EXtI3VIrzDdE2gQFAGxcRWCX0rIBvqgN0kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tj+0CrL5RIt1cSEqrBST+2X+5vUbl0nY6WHUrnRhpcvXrUNvF0toa7GOZ3jT3te2RGyzbeXUthgpyGqa7skJqMdzOnnBrinBdvsA5CPwBqzkus39t4yh7PA2Rlt6D51uDDDla2q5nDXRrumdpV1Cl8D9ogpJmf5Nm3SkWZkmNWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jIh+/103; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jm2FUYhp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jIh+/103";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jm2FUYhp"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PDUF5V757087
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YsHFeSAp3CU
	eDC6/pijBcy66HKE+cMN4f7sayTp0/R8=; b=jIh+/103IYUgxoTwAISVwVI9lYA
	8X9dPiweKj3Cj0ivXSMIKmEEEYGRkUWAlt253f8PyQYc5/C5IXZKTsHM/umc7NKA
	2qHjdlZledxNycrIjw0fOBEbnjABaVvwICnn0YA8AvagzVYEbEgDNlPIGtXsrNyp
	jsm/bGVdqYxHfYx7CxYfX6L5j0HxotN3Xxhv15jXbjs9NG6eni44ZN5Na69g4V6i
	y7nAIjsa5GyCEmkP+3JLpXFcMhqq1R7qf8iIV7LFudxHOYebTl9UKNvj0Wf590Zv
	pvNmY0xMfykGXoiZlTQXIYgWC5D+/2MeOiaVPRfK8in7WG24ohov7Ck8oZA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjq0a3kd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:58:42 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8710450f731so775837b3a.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790351921; x=1790956721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YsHFeSAp3CUeDC6/pijBcy66HKE+cMN4f7sayTp0/R8=;
        b=Jm2FUYhp70IgtCToukAN4xk6FJLyPtgUlswTLt41RdUPfWGaLz2LTqTR0dy2b4n6kf
         qRvBoxw2WKJ85iP8TCfO/31nYDUPWFarvYiVYaW/sRF46CRtF/1XZuUdEypxnkKIthdn
         IA2m0QofR8HNHLVYcwUjaxkQ9RHXT4IplckRLNkxNvTaackhDoqnVfese3U5Cn637VHx
         51pis08OTRQjqyIpV7y0RPG0yCPKVrGCYUNtOuqsg6P5KfrIpjXHrxFx59YrNS5uC0K6
         z516ly9Fg+1Nx89dfml+9SW/XB6bx6Zk/E5m3VLPs5xrSL4d5mDO/CHe0STVa6rl+QjN
         yt2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790351921; x=1790956721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YsHFeSAp3CUeDC6/pijBcy66HKE+cMN4f7sayTp0/R8=;
        b=oYNvcz9Xn9GscA49BQYuclSTdeEm1ytRbpLtmcKZNhhj9x00GhL2BpjXLkIMwTzMdQ
         MMl8oLKMNyT6dccf+3+1DYE3J5O3gdaBUG+2tyob7+Ev3tTFUddpemKmyX7Z0rCcSPBA
         qbV+rPxvOCw6muZhwgWcXk0HB3upObqMcpSc7qZHktxOOBW0mj2+RatMPwB5xF+3mwUd
         zT1Q1uPzWJRXcsxvFvNPNA7rfEt/McJo7b3ERa6RcOsq9V79deiFAZXSkkTVwI9oav9W
         zSmw1jtONnFXMwyja477w1IcMJEfJalIKxi2R3ZmcT6cgMY6zDZsmSjumzpqO16zXYtP
         XCLw==
X-Forwarded-Encrypted: i=1; AKwUvBw2UF00uyib749rK1K2Ej/YAl4rROMw+2ySV505T2CZfw2KwtMpjr0wd/NTsIp3oKL29Dvy+QeYBArdjDRujg==@vger.kernel.org
X-Gm-Message-State: AFuF++nYZ8c3xdJmC4P+iP39WI8UB9JuL1HeVbrZ4K27tccI8bI6BU/z
	k00NpknbTyv9YC59AXMDBHcpxlMTL5VOGSzhVwdM2CsM+pOqr+W+tVUKogFbprL3TPr8udyxOlD
	/oo7fwnZbNK0j6HGmru3EkwuMNBvqKrSzis+IuMk0UQsZzxEVbJ9HzI4MxcP9WROGtZxXmQ==
X-Gm-Gg: AYBFou3MhvyG6QxexXkOYh0F2CODwtUqAS4NcNeSJ6rQ5upk8qvyTOxSCeO2mRUbjCN
	lDmSyQvvfUnYgU6PGMtDd8VSxUZEditN9fD/c/MBC+sVAJuIFaz8e32F9mxFyjeG631EZF/Aene
	2Co/2oceWOPnBMKMWosIDuq9Ed8i7hQuJC4I/G/92ZywH7wORNY8tsh0WHJG/76DSURhWspiGQD
	bQFTBdT1gFIZ/oinMqBskqGAkSExmiBG+ybn1NslZ5gzdcnULgYHHaOrHWX01T8PSrTJp47/D4Q
	UEWvWKcg+tQrffMcNhNAq9mAEVqTyJCMu66fXTeUJ06JaAkTDoMD98uXi/pZupLKShw34I04iWo
	J5PF2qfr8krw6pnRAq0FCxmskihc=
X-Received: by 2002:a05:6a00:301a:b0:874:708d:b631 with SMTP id d2e1a72fcca58-87e9d8da4dcmr5253176b3a.29.1790351921257;
        Fri, 25 Sep 2026 08:58:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:301a:b0:874:708d:b631 with SMTP id d2e1a72fcca58-87e9d8da4dcmr5253154b3a.29.1790351920637;
        Fri, 25 Sep 2026 08:58:40 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87ff354d854sm1361299b3a.2.2026.09.25.08.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:58:39 -0700 (PDT)
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
Subject: [PATCH 4/8] media: venus: migrate firmware loading to qcom_mdt_pas_load() and qcom_pas_prepare_and_auth_reset()
Date: Fri, 25 Sep 2026 21:27:33 +0530
Message-ID: <20260925155737.4161358-5-mukesh.ojha@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfXzqJNh7oz/CqS
 nGeIe96eQ0mavxnffVI2HzNUJBSaJcKo6hiLIlKwkp8IfKozYqT6XLLBktmWLaLh+lhKIg59hMk
 I7/eQ8u6NvGj6Ssel0jQxyiBtQh49zg=
X-Proofpoint-GUID: cZSDXTTZ7nnsiWdQiTzOLtob4YkbRWYl
X-Proofpoint-ORIG-GUID: cZSDXTTZ7nnsiWdQiTzOLtob4YkbRWYl
X-Authority-Analysis: v=2.4 cv=LNPz05W9 c=1 sm=1 tr=0 ts=6ab69a32 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=KXBF9D8WR1mqcvW3O5AA:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfX19FCYu7LELQA
 vkXutDbGzzpD1QdAXaYYngykZOltsyrLWYBcBxtQsrCGizc7MjQhZtoiVil233ipAfuujS2u+0W
 GP/StHWX1nWVuHHW4GLixP60LoMZ8z6uEq8Ngvxa62iZ5jFKXolz+nbEXeaRGB7xjUTGO3FnsTI
 UCgxsoq8eZjLg02AsgjZ6uMqNcnWhTJjtPlaVBQ2gMo/iPBjTTXlKP3jVWzliW00EgrqRvzsI8V
 +toakmFHlcFv6P8XQKPJVy/YaILigxX224XiLg28vqxPFX57qsQyOLG53k07iH9JQ0h0nmqvl7X
 mb8ExDQuhpdjq6nk+7USkkM4ZOIIpWPxfRjFaPMsj7dh4uGV1l9Rm6RxYl3fl7MP7jEovP9O/be
 E938xAwdH+2Hip2qQazXr9US4Uved56BaiDRSi0HM1+C1HR+2s1WxijMWyvgi6G9CitzI97DcSx
 dkJhIpCYTFvWEsFiaNw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250063

venus_load_fw() uses qcom_mdt_load() for the TZ path and a bare
memremap()/qcom_mdt_load_no_init()/memunmap() sequence for the non-TZ
path.  venus_boot() then calls qcom_pas_auth_and_reset() which skips the
shmbridge prepare step required before TrustZone authentication.

For the TZ path, add a pas_ctx pointer to struct video_firmware so the
context can be threaded from venus_load_fw() where it is allocated to
venus_boot() where authentication happens.  Replace qcom_mdt_load() with
devm_qcom_pas_context_alloc() and qcom_mdt_pas_load(), storing the
context in core->fw.pas_ctx, then pass it to
qcom_pas_prepare_and_auth_reset() in venus_boot().

For the non-TZ path, pass NULL to qcom_mdt_load_no_init() directly,
removing the explicit memremap()/memunmap() since qcom_mdt_load_no_init()
handles the mapping internally when mem_region is NULL.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/media/platform/qcom/venus/core.h     |  2 ++
 drivers/media/platform/qcom/venus/firmware.c | 29 +++++++++-----------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 46705a666776..adcf67043bf6 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -9,6 +9,7 @@
 
 #include <linux/bitops.h>
 #include <linux/list.h>
+#include <linux/firmware/qcom/qcom_pas.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -223,6 +224,7 @@ struct venus_core {
 		size_t mapped_mem_size;
 		phys_addr_t mem_phys;
 		size_t mem_size;
+		struct qcom_pas_context *pas_ctx;
 	} fw;
 	struct mutex lock;
 	struct list_head instances;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 3a38ff985822..4ea4c7769ac3 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -86,7 +86,6 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 	struct resource res;
 	struct device *dev;
 	ssize_t fw_size;
-	void *mem_va;
 	int ret;
 
 	*mem_phys = 0;
@@ -117,21 +116,19 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 		goto err_release_fw;
 	}
 
-	mem_va = memremap(*mem_phys, *mem_size, MEMREMAP_WC);
-	if (!mem_va) {
-		dev_err(dev, "unable to map memory region %pa size %#zx\n", mem_phys, *mem_size);
-		ret = -ENOMEM;
-		goto err_release_fw;
-	}
-
-	if (core->use_tz)
-		ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID,
-				    mem_va, *mem_phys, *mem_size, NULL);
-	else
-		ret = qcom_mdt_load_no_init(dev, mdt, fwname, mem_va,
+	if (core->use_tz) {
+		core->fw.pas_ctx = devm_qcom_pas_context_alloc(dev, VENUS_PAS_ID,
+							       *mem_phys, *mem_size);
+		if (IS_ERR(core->fw.pas_ctx)) {
+			ret = PTR_ERR(core->fw.pas_ctx);
+			core->fw.pas_ctx = NULL;
+			goto err_release_fw;
+		}
+		ret = qcom_mdt_pas_load(core->fw.pas_ctx, mdt, fwname, NULL);
+	} else {
+		ret = qcom_mdt_load_no_init(dev, mdt, fwname, NULL,
 					    *mem_phys, *mem_size, NULL);
-
-	memunmap(mem_va);
+	}
 err_release_fw:
 	release_firmware(mdt);
 	return ret;
@@ -237,7 +234,7 @@ int venus_boot(struct venus_core *core)
 	core->fw.mem_phys = mem_phys;
 
 	if (core->use_tz)
-		ret = qcom_pas_auth_and_reset(VENUS_PAS_ID);
+		ret = qcom_pas_prepare_and_auth_reset(core->fw.pas_ctx);
 	else
 		ret = venus_boot_no_tz(core, mem_phys, mem_size);
 
-- 
2.55.0

