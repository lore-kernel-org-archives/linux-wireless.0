Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63093803E1
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204902; cv=none; b=EJlcNKASLa4ksOSisQPJJ5BHTutDAB2naqy0kjcTF4qPh9Q8/qnwzNtEyyNm/xrCZQC6/pEIX3vBE4PJUeh5sJhaymUXxlgZoNwQbbjQ+/WVS0X7QteKgS5edmODKudKJeb35/FRFxOxNwxeQoTl580xoFD6f+cVh+WjEeR9+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204902; c=relaxed/simple;
	bh=FFrcoH63jg3HsjJt6SPpuhRtjP3YhYRsRpfJLFQwv0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UL+bBI/X/1pE6ZbwhaZ9t0V7tKspeJHc6ByyvZpGNyCQlM/5u9kONda/TQEsVNwnGu6UP8OVBlr7U2DSbpbMwRAB9wh3R8KcLmN4F4MljZ/GLfTqKj+W9bE6nSxgZiT3QTrDChuS4+VQEQlalsHrxyyw5Kyt3fq/hNCB8kG1Umg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fNmel1eM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IvyIPgL9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fNmel1eM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IvyIPgL9"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JL8NrA231838
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=LI+zMU/xwwj
	59NCF/N4Oobwx22bmI/6oZGvoHLMIKXY=; b=fNmel1eMMxyZX2bGYKrER51K8Ih
	ZPAL6Rd+wBT7ojGN1ZNhCIgLsiPEW3/4pxZZlWTxeDOz0rU1kFOwvf9Y2g1M9B9e
	qMd3CwN2Ni6f39rPNIOcUKDd+xHJoxTllpbNTCWoZ9A/8gWCI6E2G1+W6fLwlWVm
	AiKbbKxIvUnmvTKG87U+tsIcGcfSVv/xCWfHTBX2UzKlze21GEAYSr4DWCKHLO/b
	dmtuUSUP0FLx7EqByUIxt8WK6X0MIeHuNktmXCx/NJFYhXCPmziesWa3U3/xGlee
	bwnLBlYRtkZjVBv+O/YNpxQaycxq7oiOB+uGQIApdpR0EivfPR4krCkekhw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5esauaxr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:19 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-385d2703b64so625832a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204898; x=1787809698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LI+zMU/xwwj59NCF/N4Oobwx22bmI/6oZGvoHLMIKXY=;
        b=IvyIPgL9pFWY2jFnEvNVBooir167FoXRdyR5LR/EAtkcV7UVC6pzqXQZ+rAVRb94Gy
         B5VRD6tQQ3f0Ar1Cd+Q8jh11marJN0acdzWh6vlezdehqBiBlGyXpcp9FhD6uzx3vFE0
         YRwjZ2oVnvkOeliDZu3Ywij6Qlefb0MgjmoFhmSOeFOuHz0pA+k94KWWtDl4+u0i7/lp
         P9rL0zIPehLchF/8iEj9E9QnBwnOd0kzptQHttbYLeo4OFaZkf1e90srxIKehvIatwer
         x4xV0OveGboWi9fDi9Ng8wGKhRvBMVwUinipNe4jYlIImzqqms45I8IwNd8gwtrzwpDz
         8gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204898; x=1787809698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LI+zMU/xwwj59NCF/N4Oobwx22bmI/6oZGvoHLMIKXY=;
        b=NT8zH8Jko67RoHjsvsUy5je3+CKhuOwBGORVHCM70dQZtVmLSNhdtlVMlNRtXuZj9i
         iN90yUq1XOaNksUgfmxtKypDFI3RAh1ARjHVzAV2r+PEONITnKGxjzP8DWyYARsyE4Uy
         bP8w59u+v98sgqSz0qpZe42LfDKypsvMb7zy0HgIiuGPzAUAMVOub0imlZbWNQry8ORo
         WAg8C/xPP/Sg58FG9w6x9ktRLe8OUWf1JJBaF1cEGgnZcgSdkyuzQIhuZcAcvSzZ/1h1
         3O1GtxhZrfvRfNoNQNXPUz8Y3ignTLFd4tO/orX0te9IU/TcwrSO+PCHZwWJNExHLdLV
         9kEQ==
X-Gm-Message-State: AFuF++nEkiF4weak0gQ/gp2p1haFlpTo5eX+iEWOEt+oPQpaf3Wo6LyO
	sV+uDSnXzvNZUqGDSET76SXMAahA7Iapr4h7KUlaGlqyZGMhcKNj93XimDUabWF4DOMzPmPj3rj
	ySPNCgrPwv/xIDHR5NHrUMZxbI1cxK7FrwaP4fM4nQJ/9msGWrCgE150NumS2ufit/Nk2UQ==
X-Gm-Gg: AR+sD10aHbi96MawUrFRZxtDQ6V9PLJOHnJwdysl2YmZb/z1iY6iIoB+fHFx+GVnBVb
	5GvM7wVAV2N/a0eA2w3kSlLJUbD/Jivan2y92TEpA+bL9NUrwII5XeEXy9CvBR2KQ5GdHGjF6+M
	hyyfZD23oOElcM6u91HbJDg/Ikzmj1+WCwE0PCfn6QUt88buxMnuPb8dyiOMzf/wy5ZMfovaR4B
	XXG5YlJHCUyGPw2InuOoTwrkHDzZPqD9Q7/i2r3MgFTkbGE2noCTjYwZOpUZkihdCDk6TG8GM8g
	tIjjFORplr5u0kiKNm3fDyLHCNmWzGTOt5MLiqrbrlxDmn5m7LFcQPtv7Y6LxFuXG2ZbM8EllfG
	X3wfvtNTXPEIP0WM5chEfcJvvN0i+jUBIs8h6ZnkA1VW2rfKRuFKFkRVrB9mrXsdNOwCBsUZ+3K
	0FYQZLMqJ5QOt+5SW8QZviHxM=
X-Received: by 2002:a17:90b:5104:b0:38e:c232:9d2c with SMTP id 98e67ed59e1d1-395a04e3ff5mr4570176a91.2.1787204898227;
        Wed, 19 Aug 2026 22:48:18 -0700 (PDT)
X-Received: by 2002:a17:90b:5104:b0:38e:c232:9d2c with SMTP id 98e67ed59e1d1-395a04e3ff5mr4570141a91.2.1787204897733;
        Wed, 19 Aug 2026 22:48:17 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:17 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 2/7] wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
Date: Thu, 20 Aug 2026 11:17:59 +0530
Message-Id: <20260820054804.3222296-3-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfXxdcNnMWtrs41
 Rha1jrJ/x1iQzvkah7EwsO5zaiRQTU7iumX0G2AHhO9+de5EXzbci1Uvb9OiPRdUkiJ4XNFEN+S
 Zn79fvvqJmv2Qd3sS5+R1Vq43T7xHT8=
X-Authority-Analysis: v=2.4 cv=fKcJG5ae c=1 sm=1 tr=0 ts=6a869523 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=DFbXMaSh9_sXDkJ5NroA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: RErXbDSxQ5KZIuy7SJxFmZJyEclPlbw_
X-Proofpoint-GUID: RErXbDSxQ5KZIuy7SJxFmZJyEclPlbw_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfXyc7hPY++Uwtj
 RGmFZE1+YoNIXbJ3qNgLEdU42FAuGEn1jxi+C1uUQfFJ9qVty4zuJTKbG9mCuvdzm8j1zCOp98J
 ifCxF2AU0BwIJgW4NVR99aLuEZBm3tu99FrXvPr+CB8AKwJKq/T23c5fl+p48KBsZSLD0m7EO6f
 7yut8L/dwGKIenRCeSURrcq2739h88F9laISLvKlU0CnASHEoufNYvFypA2y1JzTZYZMT78xIAe
 jpFlb+EuC9+13AQ9IgH9zNjlq8O2Kfd6HaaAdikk83ZRNE1o1OPspH0UQE1eMl2etS1dcFXQyxl
 1dWg0zEcpPJhrzYjFLk5w8K9HA2x5nIMSAHYya0ypBRSTeqAkYFyO26oNgDldN9pIH0Mpf1idIQ
 /ce3YsNz7DeCnXmPtU/js4aE4cv785GbFtnke96A32JmZD+p3z52Xj4vv5DjnGLil33NTWTdvQJ
 IO9a7qwUfYFnTn/pPVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 impostorscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200040

Replace DP_TX_COMP_RING_SIZE macro with ath12k_dp_tx_comp_ring_size()
static inline helper. Pass the DP profile parameters explicitly to
improve type safety and make the interface explicit.

Update code using ATH12K_TX_COMPL_NEXT to pass ring size directly rather
than deriving it from the ath12k_base structure.
Also remove the unused DP_TX_IDR_SIZE macro.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.c          | 10 +++++++---
 drivers/net/wireless/ath/ath12k/dp.h          | 11 +++++++----
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 12 +++++++-----
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index f9b37d75956d..5980946d1e82 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -439,6 +439,7 @@ static void ath12k_dp_srng_common_cleanup(struct ath12k_base *ab)
 
 static int ath12k_dp_srng_common_setup(struct ath12k_base *ab)
 {
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	const struct ath12k_hal_tcl_to_wbm_rbm_map *map;
 	struct hal_srng *srng;
@@ -469,7 +470,7 @@ static int ath12k_dp_srng_common_setup(struct ath12k_base *ab)
 
 		ret = ath12k_dp_srng_setup(ab, &dp->tx_ring[i].tcl_comp_ring,
 					   HAL_WBM2SW_RELEASE, tx_comp_ring_num, 0,
-					   DP_TX_COMP_RING_SIZE(ab));
+					   ath12k_dp_tx_comp_ring_size(dp_params));
 		if (ret) {
 			ath12k_warn(ab, "failed to set up tcl_comp ring (%d) :%d\n",
 				    tx_comp_ring_num, ret);
@@ -1465,6 +1466,7 @@ static int ath12k_dp_reoq_lut_setup(struct ath12k_base *ab)
 
 static int ath12k_dp_setup(struct ath12k_base *ab)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_dp *dp;
 	struct hal_srng *srng = NULL;
 	size_t size = 0;
@@ -1474,6 +1476,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 
 	dp = ath12k_ab_to_dp(ab);
 	dp->ab = ab;
+	dp_params = &ab->profile_param->dp_params;
 
 	INIT_LIST_HEAD(&dp->reo_cmd_list);
 	INIT_LIST_HEAD(&dp->reo_cmd_cache_flush_list);
@@ -1528,7 +1531,7 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 		goto fail_dp_bank_profiles_cleanup;
 
 	size = ab->hal.hal_wbm_release_ring_tx_size *
-	       DP_TX_COMP_RING_SIZE(ab);
+	       ath12k_dp_tx_comp_ring_size(dp_params);
 
 	ret = ath12k_dp_reoq_lut_setup(ab);
 	if (ret) {
@@ -1540,7 +1543,8 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 		dp->tx_ring[i].tcl_data_ring_id = i;
 
 		dp->tx_ring[i].tx_status_head = 0;
-		dp->tx_ring[i].tx_status_tail = DP_TX_COMP_RING_SIZE(ab) - 1;
+		dp->tx_ring[i].tx_status_tail =
+			ath12k_dp_tx_comp_ring_size(dp_params) - 1;
 		dp->tx_ring[i].tx_status = kmalloc(size, GFP_KERNEL);
 		if (!dp->tx_ring[i].tx_status) {
 			ret = -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 72d3de2db5d8..6540b3453cc6 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -61,7 +61,7 @@ struct dp_rxdma_ring {
 	int bufs_max;
 };
 
-#define ATH12K_TX_COMPL_NEXT(ab, x)	(((x) + 1) % DP_TX_COMP_RING_SIZE(ab))
+#define ATH12K_TX_COMPL_NEXT(ring_size, x)	(((x) + 1) % (ring_size))
 
 struct dp_tx_ring {
 	u8 tcl_data_ring_id;
@@ -201,9 +201,6 @@ struct ath12k_pdev_dp {
 
 #define DP_WBM_RELEASE_RING_SIZE	64
 #define DP_TCL_DATA_RING_SIZE		512
-#define DP_TX_COMP_RING_SIZE(ab) \
-	((ab)->profile_param->dp_params.tx_comp_ring_size)
-#define DP_TX_IDR_SIZE(ab)		DP_TX_COMP_RING_SIZE(ab)
 #define DP_TCL_CMD_RING_SIZE		32
 #define DP_TCL_STATUS_RING_SIZE		32
 #define DP_REO_DST_RING_MAX		8
@@ -689,6 +686,12 @@ ath12k_dp_to_pdev_dp(struct ath12k_dp *dp, u8 pdev_idx)
 	return rcu_dereference(dp->dp_pdevs[pdev_idx]);
 }
 
+static inline u32
+ath12k_dp_tx_comp_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->tx_comp_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa..e14f1d190ba8 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -922,12 +922,14 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 	u64 desc_va;
 	enum hal_wbm_rel_src_module buf_rel_source;
 	enum hal_wbm_tqm_rel_reason rel_status;
+	u32 ring_size;
 
 	spin_lock_bh(&status_ring->lock);
 
+	ring_size = ath12k_dp_tx_comp_ring_size(&ab->profile_param->dp_params);
 	ath12k_hal_srng_access_begin(ab, status_ring);
 
-	while (ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_head) !=
+	while (ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_head) !=
 	       tx_ring->tx_status_tail) {
 		desc = ath12k_hal_srng_dst_get_next_entry(ab, status_ring);
 		if (!desc)
@@ -936,11 +938,11 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 		memcpy(&tx_ring->tx_status[tx_ring->tx_status_head],
 		       desc, sizeof(*desc));
 		tx_ring->tx_status_head =
-			ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_head);
+			ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_head);
 	}
 
 	if (ath12k_hal_srng_dst_peek(ab, status_ring) &&
-	    (ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_head) ==
+	    (ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_head) ==
 	     tx_ring->tx_status_tail)) {
 		/* TODO: Process pending tx_status messages when kfifo_is_full() */
 		ath12k_warn(ab, "Unable to process some of the tx_status ring desc because status_fifo is full\n");
@@ -950,13 +952,13 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 
 	spin_unlock_bh(&status_ring->lock);
 
-	while (ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_tail) !=
+	while (ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_tail) !=
 	       tx_ring->tx_status_head) {
 		struct hal_wbm_completion_ring_tx *tx_status;
 		u32 desc_id;
 
 		tx_ring->tx_status_tail =
-			ATH12K_TX_COMPL_NEXT(ab, tx_ring->tx_status_tail);
+			ATH12K_TX_COMPL_NEXT(ring_size, tx_ring->tx_status_tail);
 		tx_status = &tx_ring->tx_status[tx_ring->tx_status_tail];
 		ath12k_wifi7_dp_tx_status_parse(dp, tx_status, &ts);
 
-- 
2.34.1

