Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A0C471CE6
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 09:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365193; cv=none; b=HSl46dTH3L7ewIvGhn8VGbPYZyT+xZPYmgLQqykGwrUTT29w7/WAT07JlfGt5MXYuCrBcLo0cD3xCuRRa/6wXz0VqF1h9O5bcisa/U2s8mqID2jp7NVEjVudRUUUGkdWoVA0lSdABg4S4rEmFgXVZzVeau05XqEDbEIKdIvsvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365193; c=relaxed/simple;
	bh=36BExIcS3er/y0jorYgoz0YcrCOEOstH66XbKIRSceQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rvKkFIICpHvCsOIHRvG2H5gfeMCpB5VgyDCjFWSbobMo0upwg+/u1wb78FbEk3TzU+FOsE98xYnQcFpYh24sLUt/svq+p1puJjmaz/PKNVlpH6i1IOxUQb4unritY49CqeJ0sw4Qo01a5cizx0pZ6tCj+1IpgiiUyb+83Ebz0rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dL+TY5DM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Hi0qa8ID; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dL+TY5DM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Hi0qa8ID"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6977juI82312990
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nfH7JOcpjrJI7edYv859MWGoxNpJwE5LbQPeiejX188=; b=dL+TY5DMr94OyHV1
	zFtpHaewGEBY5fmV0lDs5JmKK+Y6M0QgFFPSsZLlhYD3jTa1NW5ZSCpCXh8cyBQV
	jJnt5hFYcopZfUQ+Pm7W3XRh+mqLWIHXXM5DhWx1d0+WwcJj0nBoVzJuq4IuCUSq
	wkgEa+Vb8jG7jMf6Z69pQk4P+Crsb7Y/YeM4FlMuCNF/IBNrwxj1oSYcDo137r+3
	S5mo4ZoSGerUV0RrvPlaK84C45IZkhNP2Bm7XOab3SCDBc3nwwFxnOwZhUxJj0gP
	eyzxQeRhY0Xk9yX8vt64WLlA8axwYVDAtowXnXcf6uZcLvg1dGuEGpmV8gfqVMrf
	XEyXHQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h53askr55-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 09:23:56 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8883dcc671eso2878162b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 02:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791365035; x=1791969835; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nfH7JOcpjrJI7edYv859MWGoxNpJwE5LbQPeiejX188=;
        b=Hi0qa8IDT6pzf/rE6852JiwTP7A9IixDYYrvQEY3FgPgvaCM7yTHVIlbit1IVAv8Zv
         KSbZ8nOrIhUfaq/dKJqscIv1/2M2x7ib5tFwwnoRt1iBVFZjc/sUhYuOzMFudrM8+6oM
         onk0jTEBL64CRs1se8QnbeNI9PatyYlF2JvFU4fp2/uMdXFFCMh6Q/qdgGi7RdHkhSuo
         diP3K4MmXlybtJsOYSV8w13lQbM782pM1GTa47N/9eRFixE7GOvL6I8cdJklst7f3sC+
         rRm4Qv8JXcQHXahxjXkcIfPVY5MiTtxEgMPYQrs5adwZ5usZ3AKRIpe0I6H4+YFfnqjd
         GhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791365035; x=1791969835;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nfH7JOcpjrJI7edYv859MWGoxNpJwE5LbQPeiejX188=;
        b=NmLrEpaVhZneUTNZifrlBvg1NciyCyKL71AQu9vGttYpIsgaNV4QCvZnCi+UtsBXbF
         5kNRhWH8ray1ky+iXNcvBweC08aVIvUuRy1CmiqT5nVuqxkQyG2wHSwCAv+J4EQjeTqf
         Fu/r431Lidv+RAinGS8v+JmCIN6XNroefNDIfwKFgcRnJFywhfucjrPlv7FhMWj8ohgj
         j585qs8240aOuiP8SbIHMkLok+2W2kM+P2aeqCwz+63BC6E5F/shKjy3SK1oV7G4mvsn
         a5n1fcmkXR6gM52TXEicGCHtyZFSk7x9OPRwzTIoRYUxdpZge30GMZTv02lbfxfbpngT
         lxyA==
X-Gm-Message-State: AFuF++kk+P4i1r7zO8QvVhvTTNIkrtjtXSY6uyzH/SHlwPVmE00jFBGo
	P83rGbrVU9EfEuMbPdxMerwO0k8IYMxlYZY5vzu6oO5o+oH1lzJ50f6hiO9d08lcTAd/4aORnkf
	CdioN/XnXry+ZPGZKwPLpxHRk5gbQvsd5877tpJ7Ok8rSOp7xVmIzfSvPJ1YiXyBXweS2zajlnz
	kiKg==
X-Gm-Gg: AYBFou3eCjkH3u0IIn1bsJ7iUtzI3Pq2bjU7sSLsFxuih4BzhvxUaL1UhDLxirFc01m
	RcqhRL+9e2QQTA9fgWFpGuveyuFJB8n5OX9+mSjVzZaszTJzzaNF9ovqZ5Np6Bd/2cnb4Y/66S1
	jEdk+9XnDEJj3uQvbyA3MD5vuWwySIwwFkc4/itbty09l8gEeCzG5Dfdi3h23lroaparqZGfAVI
	ThTgqvO5AsZPv+5mpfRtQeNm5E785CVgpSlCqLX1dQvRY8XrVspCo22PTXvJdgV62nr/pZa/rYz
	OqNQaiLVpzwyt/Iu6zKVUUD0qOiNOREM3IQtaz9T2+60tJpiy228Nj27lxeu7XRXDXmdQ21vpS/
	zLaCp4c6TUqSn559dZQkmLeQwYinDvxaY5rzq0SpB/c8m9FbC6e+e3k0cSgKSCQ+YhJofdg2ZTJ
	4CT7cPb1wtI2HZzCBKlxFBIcs=
X-Received: by 2002:a05:6a00:950a:b0:881:4b47:f30b with SMTP id d2e1a72fcca58-891b354d5d4mr1318715b3a.12.1791365035353;
        Wed, 07 Oct 2026 02:23:55 -0700 (PDT)
X-Received: by 2002:a05:6a00:950a:b0:881:4b47:f30b with SMTP id d2e1a72fcca58-891b354d5d4mr1318696b3a.12.1791365034890;
        Wed, 07 Oct 2026 02:23:54 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89271257af8sm119128b3a.41.2026.10.07.02.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:23:54 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Wed, 07 Oct 2026 14:53:32 +0530
Subject: [PATCH ath-next 1/2] wifi: ath12k: Make RXDMA buffer ring size
 configurable per memory profile
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-mpp_ws-v1-1-739b1fb87d24@oss.qualcomm.com>
References: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
In-Reply-To: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: Q2rd-Bk3qBnPf84DzuFlLttr2REXKXg6
X-Proofpoint-GUID: Q2rd-Bk3qBnPf84DzuFlLttr2REXKXg6
X-Authority-Analysis: v=2.4 cv=Xt5vqlF9 c=1 sm=1 tr=0 ts=6ac60fac cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=mg1aV8qigFYmQh57PbIA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAzNyBTYWx0ZWRfXzC5ZXRQmjFHV
 4vl8sc80JqvpSS33hM+0GBlCe184ECjrEMJKbgoqavicIj3LxC+wx8AED4T1VNB0MPpCd5tU63Z
 VGy45sck7peH6pmPOBnrCS4wnp5WogSo7CoH895Ca7WoUf91HQggQZwkAo515H98+R4xH6c9bib
 5IqMJPmjQEepFRTCihWuAEPyuhj14pw48/gKBTuX+6mj5ncROT5xVK9Bo6dtChdXaoXzQdiZYaP
 WoHOd5Qb4eLpD8ft5VSNjJE2oeh6BWO6YEjBqyFRYTLQ5TvfIRs0nzgQfC1hthuOyjOj9LHfQGd
 cwz/2WkTtIuQ1jFT8Uklcw2VxZWaQcDXqSYALW8GfjT2BUSwYcvPnViNkOfDzwzjB0s5LqAIRGB
 3BpNzYpxvS0YwjBya6/bXlGgWSKy/gl1h5potYK0AEAvreWHqkrtmnLd4tJFN8Fc2zhUakPUWIz
 hmsSiaBtkYEZzaWt5mA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAzNyBTYWx0ZWRfX5v3mpX9YpUIv
 csxFg4yzc7MQvEOBx0vHK+B04DjDZrZ5kvX6jBPwcVMRh1tUtD0U8tnl/AoB4EF/M1uombQMCQh
 npuj8TDwoiSP2C+OeCjpU1zAeRXbkc0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 malwarescore=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070037

Currently, the RXDMA buffer ring size is hardcoded to 4096 and shared
across all memory profiles. This prevents individual profiles from tuning
the ring size based on their memory and performance requirements.

Add the RXDMA buffer ring size to the memory profile configuration and
implement ath12k_dp_rxdma_buf_ring_size() static inline function to
access the configured value. This allows different memory profiles to
select an appropriate ring size based on available system resources.

The function follows the pattern established in the previous patch for
other DP profile parameters, taking struct ath12k_dp_profile_params
pointer as argument.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c  | 2 ++
 drivers/net/wireless/ath/ath12k/dp.h    | 8 +++++++-
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index e527b59ecba5..764e646d0090 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -54,6 +54,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 32768,
 			.rx_desc_count = 12288,
 			.rx_release_ring_size = 16384,
+			.rxdma_buf_ring_size = 4096,
 		},
 	},
 [ATH12K_QMI_MEMORY_MODE_LOW_512_M] = {
@@ -68,6 +69,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 16384,
 			.rx_desc_count = 6144,
 			.rx_release_ring_size = 8192,
+			.rxdma_buf_ring_size = 4096,
 		},
 	},
 };
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index c53eac20b989..108e27dd5797 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -31,6 +31,7 @@ struct ath12k_dp_profile_params {
 	u32 num_pool_tx_desc;
 	u32 rx_desc_count;
 	u32 rx_release_ring_size;
+	u32 rxdma_buf_ring_size;
 };
 
 #define DP_MON_PURGE_TIMEOUT_MS     100
@@ -210,7 +211,6 @@ struct ath12k_pdev_dp {
 #define DP_REO_EXCEPTION_RING_SIZE	128
 #define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048
-#define DP_RXDMA_BUF_RING_SIZE		4096
 #define DP_RX_MAC_BUF_RING_SIZE		4096
 #define DP_RXDMA_REFILL_RING_SIZE	2048
 #define DP_RXDMA_ERR_DST_RING_SIZE	1024
@@ -730,6 +730,12 @@ ath12k_dp_rx_release_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->rx_release_ring_size;
 }
 
+static inline u32
+ath12k_dp_rxdma_buf_ring_size(const struct ath12k_dp_profile_params *p)
+{
+	return p->rxdma_buf_ring_size;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index cfaf26ae2720..36be543b7c50 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1699,7 +1699,7 @@ int ath12k_dp_rx_alloc(struct ath12k_base *ab)
 	ret = ath12k_dp_srng_setup(ab,
 				   &dp->rx_refill_buf_ring.refill_buf_ring,
 				   HAL_RXDMA_BUF, 0, 0,
-				   DP_RXDMA_BUF_RING_SIZE);
+				   ath12k_dp_rxdma_buf_ring_size(dp_params));
 	if (ret) {
 		ath12k_warn(ab, "failed to setup rx_refill_buf_ring\n");
 		return ret;

-- 
2.34.1

