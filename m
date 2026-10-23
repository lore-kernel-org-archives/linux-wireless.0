Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738932;
	b=WOtvi44Zswe36bnYmWcZ1rLkSPmfOZY74yM/uw1j830FEwm6Cw/pikmeTb9F1ugvyZpk
	 eObWOl7l639wfOlBp6Ar4yn/SogmQLI1ClgiHPLA2pgydv0td61OTod3JOqys2cspp08O
	 4Nn+M8sKoloqyeuf4mt4bNXuQ0OsPBFCpwi7A0yC3Y3/p7sFnMEA93BiblrTQelnAY/fR
	 99+6HM11SGqu7eZ+fovenjQZ9xzM6aUmnzb/Xz2wqQfsCBLBD1BUeveJ6pnvlPZADkwiU
	 mnCK9vdmL4670IixkOdUp4LRUYpwQDcqjjbEDbqigOpGhurTQLULCRhpAd6cWyT7z1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738932;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=5jzFs2jsU7MleU78XBmv/Fx4038TvlijVorZRlgQM6I=;
	b=qP1l+JtNsj/mlN4vyv8xhwTI5mN+CD7XnGnsiwhdYFNe1RsQnWk75QKCDkTdFaJIdUzK
	 HLhO7KE7XHb9vK/Su/OXQgsr6QVYL/+ZkV4ipHk2s1oLqqk3Xj7Go52w+54bKt2XG9U7T
	 YMrzpo2O+ya+wWzkItEmEgU5gMJwf0SkeXMPcODvIa+HzrN8Z1m2J2BnFEbjn34gjUqBB
	 MtpWdQwFC0+W0toMT+ibsv3w6Iw3WVaaUV9I6poJzPgtLQT+79lxmKf93akEmAQg3WVdB
	 masci2GT+ujgRl8XpS2e+M2E/bTLB6sdhcyVVofJMAuXe5BOQ5NLbvNT5xXC4E7+2Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BmIybA5L;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GDpkCYmy;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D7560A2603
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1D7560A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BmIybA5L;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GDpkCYmy
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1F5rF1336156
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5jzFs2jsU7MleU78XBmv/Fx4038TvlijVorZRlgQM6I=; b=BmIybA5LNPjbOAIc
	0Wivavpe5HSCZMshL0jUJf/WlUpJULjTEhXrHa1qBqkBrLrCIudR3WNfh/8BnfIO
	xVBnNXJ3DE1KNQfksDKlnxG7rlXIz4ddOzS+cqBovjIh2WO96NvsIEG2hOvjYia2
	nP3TjDFlolTfISpfp4cdGl5gidF4Y1j9mt+ZgCI0xzIbDoyoISsOhLf2r/XwcgpT
	XpeMKgblSIGfoOVAZPtAguY5HJclylJw4AfGWYzhoD6Dj3XpKolRCKY/I/f9qgHB
	+WTP86ge39R42HJnIyTbOyKHpMD1tPEByPULPDHLQGZXpLVC+cDX2iLoKIeUqT8G
	rJ+ucQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsyk9ta7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:11 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ac8f449d1bso614621a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738930; x=1793343730; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5jzFs2jsU7MleU78XBmv/Fx4038TvlijVorZRlgQM6I=;
        b=GDpkCYmyyH3Rql4yFP7QklsPmFvePDvd9/3dkmBTeHAgAMwT+ch25GIQwsOK/BWFZb
         Sk+SYHcN9Gc3LUjiPrOr4ERgJtjApfzps+DCxF8DyB/mJbLqHN29/vIL7PY8zo3kOiL+
         qYUnWwYrIbBG2Sjzy++hBHqdwzcdecI0tR7rgJNOnldsWebawjv07G/TiPNPCRwUEkEt
         a2k64ftCRlBTZNlVd6qlOvFrDgQu0XuAJmBhp9CPUxosV/UBGnsyH2nM7YHjkCjJoogv
         /15TKSdVIU7yLo4L7K5fPhbchYB8Gqlvt3VcdyCo5/CppbGyNzN+wPGgEcEIGnrZS2Sx
         d0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738930; x=1793343730;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5jzFs2jsU7MleU78XBmv/Fx4038TvlijVorZRlgQM6I=;
        b=I/qNmCIQk3gh4cqiTAEVH3TrWSridKh1pFft78lWmv+5/A5ASr3cQ2ElgO0Fdaq62P
         pffujE0NfHJIFREot/CthinkEs4A8l3Bb88uQYxFqne8ng/rpvu7iF9VS0Ggw3wXQKCw
         Dwkj4qn+TrlaOwrsQgkd5+FMRwjHRP1+R/DzI6F49kz8WUoGqKteBqmhqhJ6CFQ5bRpD
         fAIesjGLrPTqSykaPNvzN3cmYvk3o7eV8rsHrsWw45czgS3ztZkZj1HvsElaNx2hZg/h
         FEipOOSyFbx84hATxWWgFC/F4deDr3TQ1E8m5o1VunfCj7a/FBRg+3W4vXpihPcz9Cid
         iBSA==
X-Gm-Message-State: AFq9FYKzTYJuK7OyEQ3M/i2MuCyOY3nhvdSupaNE7K+WiFfC9aSeqf+u
	En3Rcd8ScDbVOPiLCNm8RTIaksaIKeTwexHhd5e3zsDIYyYgtj7OkjWi7eIzFbSJIs5PxpOyru0
	KbKJByOVt2gkmSOnxv5kyekZyCjHL43gr2oPaKm0P+k/zaYYZMl6MEjLrpMeYfsupy+fPig==
X-Gm-Gg: AYBFou3IuuULgnWuHeneKW9UCrBFB7ftxPtydLhPWsJnRZcZhq+VX3U5IFHJdPuP9Np
	nLngiEDb92+rdZLDn1TehW1KD+yrHR1uN+cEQN8/Vt1eLqWOB+4fkKBHeMtpjTSEwwSfUfYlLcC
	uWZioLWfAW8AxKfPalSjI/5CXiQHUYs0864g+WKD/S++iJXD+RHK21qgMBf3SazbsTRbTgjVJde
	gjkhZpzmKA9mKDA9wD9WkaLeXuHykD9rcrddepT1lW8UiH2vH/xeTSEcQFGC4C1iJjKeK2ycBh/
	iJOzQjxiZ78A/4AiPCAyh4kxdsi6NXZX0/dHoSlHMjzQjnoQubwy2BxhY3QSfxJCfSH1ZPKkULG
	iLPzQ84oVayCvrV+tB7lLpuxyDgrCEYB0IGZo/5QYJd5g1G7vVfP6M/uot5rYCkpbp/8IdappcE
	2KXH9yGRpWVy6cwBIbHi/pfA==
X-Received: by 2002:a17:90b:2d8c:b0:3ad:4bfc:1e77 with SMTP id 98e67ed59e1d1-3adce150b14mr1050608a91.66.1792738930281;
        Fri, 23 Oct 2026 00:02:10 -0700 (PDT)
X-Received: by 2002:a17:90b:2d8c:b0:3ad:4bfc:1e77 with SMTP id 98e67ed59e1d1-3adce150b14mr1050592a91.66.1792738929816;
        Fri, 23 Oct 2026 00:02:09 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:02:09 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:16 +0530
Subject: [PATCH ath-next v3 13/17] wifi: ath12k: use CMEM write for PPT on
 hybrid bus devices
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
Message-Id: <20261023-mpp-bringup-v3-13-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX3lJXdrbVCes3
 FhxIXZgR6TlmS1oOaINIoO8MbpCbMxhvNtbpz5JVTTqVP0KjypXSy3+y21JMc8EQytyAjKx1HQa
 AJjjwh9O+jPNXFyzk3/BQfR5QKMQixlWSNfAE0h6oBu0fCePrK/TKsWEs0HhaAivIJHfs52I+2e
 rG2nNXa6ER24xwVnB6OQdUZgupO1TtBSmsXAeMcVMAVLd3gwBZu0DY5FUOpC+lSeu1LlQHtB9YT
 64XaUd+hq0Xr3Pejr9Bo84dMXeYb7QqkKVHtNFEycDowJbprva1Nlq3W+PnTtUVCe9gjaWjjVDW
 UVBfhHjiS/oxIwjOjJwI5FoxkqzHm5IM/ywdDAiulu5awv22Ljq999/PUwX0zlmETXj6c9JraAh
 Qf9c4DtBHR0mld8QQus4LG+8+WI43ruei2Izm8AtEVS9pfy80dfl9CGTZdBUFPIDbMWG2DubPYi
 18j5KOOjuRyK/jJJTLA==
X-Proofpoint-ORIG-GUID: _OzTdt5QMt9vwtH0D_FVvLpuGaO_zrBx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXxces3ktYWOKF
 yxDNsx7xkYaUrxkSLTse4dT7rUBviKxG06CjMergWUKyYbrqZkyc1bEHOFa45qODdyin+ag7dCo
 KcGEZDpl6KThtl3ExnYVpZeTdJ+BdIc=
X-Proofpoint-GUID: _OzTdt5QMt9vwtH0D_FVvLpuGaO_zrBx
X-Authority-Analysis: v=2.4 cv=GLKdgeNK c=1 sm=1 tr=0 ts=6adb0673 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=HzkBA2_z9QidxsSae0AA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

Use CMEM-specific write operations for Primary Page Table (PPT)
initialization on hybrid bus devices, which require special CMEM
access handling.

Propagate errors from CMEM writes during PPT initialization and
partner copy cache initialization. Abort MLO setup and perform
teardown if partner copy cache initialization fails.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c |  7 +++++--
 drivers/net/wireless/ath/ath12k/dp.c   | 30 ++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath12k/dp.h   |  2 +-
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index d2ce01e0d7ac..cd0aa24848d9 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1174,8 +1174,11 @@ static int ath12k_core_mlo_setup(struct ath12k_hw_group *ag)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < ag->num_devices; i++)
-		ath12k_dp_partner_cc_init(ag->ab[i]);
+	for (i = 0; i < ag->num_devices; i++) {
+		ret = ath12k_dp_partner_cc_init(ag->ab[i]);
+		if (ret)
+			goto err_mlo_teardown;
+	}
 
 	ret = ath12k_mac_mlo_ready(ag);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 83f9edfabf69..6cf254b2d2a7 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1307,8 +1307,8 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 			       enum ath12k_dp_desc_type type)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
-	u32 cmem_base;
-	int i, start, end;
+	u32 cmem_base, val, addr;
+	int i, start, end, ret;
 
 	cmem_base = ab->qmi.dev_mem[ATH12K_QMI_DEVMEM_CMEM_INDEX].start;
 
@@ -1328,24 +1328,38 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 	}
 
 	/* Write to PPT in CMEM */
-	for (i = start; i < end; i++)
-		ath12k_hif_write32(ab, cmem_base + ATH12K_PPT_ADDR_OFFSET(i),
-				   dp->spt_info[i].paddr >> ATH12K_SPT_4K_ALIGN_OFFSET);
+	for (i = start; i < end; i++) {
+		addr = cmem_base + ATH12K_PPT_ADDR_OFFSET(i);
+		val = dp->spt_info[i].paddr >> ATH12K_SPT_4K_ALIGN_OFFSET;
+
+		if (ab->hw_params->hybrid_bus_type) {
+			ret = ath12k_hif_cmem_write32(ab, addr, val);
+			if (ret)
+				return ret;
+		} else {
+			ath12k_hif_write32(ab, addr, val);
+		}
+	}
 
 	return 0;
 }
 
-void ath12k_dp_partner_cc_init(struct ath12k_base *ab)
+int ath12k_dp_partner_cc_init(struct ath12k_base *ab)
 {
 	struct ath12k_hw_group *ag = ab->ag;
-	int i;
+	int i, ret;
 
 	for (i = 0; i < ag->num_devices; i++) {
 		if (ag->ab[i] == ab)
 			continue;
 
-		ath12k_dp_cmem_init(ab, ath12k_ab_to_dp(ag->ab[i]), ATH12K_DP_RX_DESC);
+		ret = ath12k_dp_cmem_init(ab, ath12k_ab_to_dp(ag->ab[i]),
+					  ATH12K_DP_RX_DESC);
+		if (ret)
+			return ret;
 	}
+
+	return 0;
 }
 
 static u32 ath12k_dp_get_num_spt_pages(struct ath12k_base *ab)
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 108e27dd5797..5e9cdf72670f 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -737,7 +737,7 @@ ath12k_dp_rxdma_buf_ring_size(const struct ath12k_dp_profile_params *p)
 }
 
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
-void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
+int ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
 void ath12k_dp_pdev_pre_alloc(struct ath12k *ar);
 void ath12k_dp_pdev_free(struct ath12k_base *ab);

-- 
2.34.1

