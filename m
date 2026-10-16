Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BA43AF64F
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120972; cv=none; b=uwaaPYv+3fKiwGg0M01MU7hixeSwOs0x90AM5f+wr2g8llXKPoRTKSK1xCe1TF1DF1SVcY+8kNANy7Mj4eEkbLLNftG3qaVvMtiztsYIHxL6FXNC+afjH9RxnieEsvPPVoX8wmqnY5hJtR+nktboqAxhvpKSf8Uxkagnr95tuhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120972; c=relaxed/simple;
	bh=yH0gebSEKl8KMIfmCoNHM/L4KD4vVS1Ee4B4fbxGFUQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KCbhtzkeGZhGsQqB34Bgpzlgz8vgOzwESoLbdtR0z5GqylLPq0C3dxSHAsTZBB5aplyI/Vzp1omuEEWoY/fGMuecuQ+5+2DM9h0EjKpo69XyMZ5PYSWvhFHM0Xz6wgYdUVq/bv8Gz/TKiryrPZM0MWu6yJuxVDmSDXtMmvJgceg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RcGTFCu6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eV80EgrW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RcGTFCu6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eV80EgrW"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G2FE9o3202275
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5jzFs2jsU7MleU78XBmv/Fx4038TvlijVorZRlgQM6I=; b=RcGTFCu6BPSu7NSY
	RJRc/fN6LAyXuTUo2h952EGqCKLDvm1M22sotm2vrTdeEfL9dfUceZYW4vV6fNqH
	KBobJcO6tcPhBMZvF+ucPKaFjFCXwK9SxhLveeU3Rq7855Hn0NrXnM4y4CM9dA8p
	hAz95yNSEDmJCIuiXtvuX74VfFf97T+ztesWjLyfb504IQvdby4TGWGs4D3ZRJCB
	Gq2wX6Fe9FoJb7MYQcv1AuLibGAuDHuxrLsl+Fbh+v+1KtzJ31zhjFKEV/vJfHMQ
	YZTfUt6V15rbgn2N/tvoms8WByCtPxSbEIcWmHgHwCdrYsCC8pGHsyx2k92dkIsi
	I8LaMQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb3r39u1p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:49 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c0d568830so12130512eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120969; x=1792725769; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5jzFs2jsU7MleU78XBmv/Fx4038TvlijVorZRlgQM6I=;
        b=eV80EgrWJ6FyKZWMBCkiVGt9L0MSiglar8EQbvNb07soUfz+gGuotGB7OIMGZHzZMW
         Z8KN3r94RSKZePro+viztx8U+VkxtQYYnD4w6bShILuPpmtPuUdsw0HZpEP11zFQqee5
         x+2vu34nZbHNmaMUt+/GpzthJGLYRx7cCdg/gYxluxTnjZjePj1bpDK9OEaJH67r9gQl
         fl3fTRkLKt4o8ZV/n+anbDRFsJQUp1V4a/QyIokJnoWbvwaIxKVDLiGCW0Kv//0QpBJo
         0U20Hr6OVZ/qPzb1tBraPwKNg9JIQhzgAqGToD3DEvetkrQy8K+Ys2dzxP7vqdDrZicA
         Lajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120969; x=1792725769;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5jzFs2jsU7MleU78XBmv/Fx4038TvlijVorZRlgQM6I=;
        b=KIt5sGX3RFHtH1rNDW05wT/CrDgXFtfdxrzct1yjbJbPvUrXUX+68q8qUKL7p2sIAt
         x9quRBmxDjAG3UxxoflIAVALRQhij5qULrhG5k6d2AxFk3VPUu7MnkK8TaJCUYDQrIdA
         YFOwNPiQmf1A2cItxstRAy+/sfowuspTaWv3202JYETLi0Tk7tI5ngtCnbKOqGe3w73B
         yxZcFJR2xwB90XIr9LEZJDxdNUfe/5iCv3jFCIBMwsfWApP/SNrrz4uYWtRpmVK4wscl
         bw3JlLskLpkrvqO35+pyKqs+ExHOhGNTqVrSNoUF2hpc3B9HETEYXDst4fKI+7UpoJwz
         2etA==
X-Gm-Message-State: AFq9FYKqU4WCx2BUaM4InEEPou/k0J/CswQymsQlyXRARfciR+FwlWx1
	ttmNJYsbdnZityCFLXhw9MCE6tpcXH/d93jGoorpkLIynbbkprxChW5bk88t5gUUtfupR5aXeSG
	VwOwa09jQWm92aqoCQtBmAdXou8Ovxvy8II26ROMoN79C9ovSDnR6+Ak3RbYFtdVQd6a2DA==
X-Gm-Gg: AYBFou0No7DeSF3W1N9qKGtfuYDGij4IC7xQFgwn2vE5SrJby6s9Gk8pX/9qgtXHOee
	5zV3eTL8r8gRMrccTYW77kc7ze0rTCcsX6z3gJdPCWPxC0S7lC1rF76LQptdKqNqOFSwt3G8CLu
	MgQyk5u5SuXJsZfUR+3XlQXObRCfMwhOJIY7UpqRpGkqgk26fogO6jj+MAqdClA9jyl0Z4isZWg
	3WcEj/j87JwYl3WXEmpPNevxK+2YZ42jf7P7386M1H96tTeAedWJa0DrnDPnQcAxFBmjmcDeJtr
	fUzyEUhHGCETJOWGgHyJDwj3AmMFjLrmwRFUA2GZkTH2/MtFvRyzk/3ZBcitheb7KlRol69Qz+M
	yrf85kQ3hia9rKMUiZHBLOLW0At8xHV8eQGqikukPXLPvacJlAN9+jZF8r5fF7+/q82OnLMX/tB
	AicFboInu+tDt1FQprJQZUCA==
X-Received: by 2002:a05:7300:cc14:b0:353:7b68:4f6e with SMTP id 5a478bee46e88-3537e03ce89mr37864246eec.12.1792120968775;
        Thu, 15 Oct 2026 20:22:48 -0700 (PDT)
X-Received: by 2002:a05:7300:cc14:b0:353:7b68:4f6e with SMTP id 5a478bee46e88-3537e03ce89mr37864218eec.12.1792120968280;
        Thu, 15 Oct 2026 20:22:48 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:48 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:50 +0530
Subject: [PATCH ath-next v2 13/17] wifi: ath12k: use CMEM write for PPT on
 hybrid bus devices
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-13-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX57tqOYuPkT2a
 0kS+gt/WwFhoM6HeQMJQ8+FiAWm1ldnJLZS3w7gWuDxHcT7oGkGD0qC/6nG/XhTT4gZIaEJZaWO
 AklVRwlCG/30lg46ZURgKxi2hnm+QGR1MuaDCX2FQ64ERZQs16O61gjL6HxKpVbPib4+bSfoUml
 xnaTJUuFYTxnJDOVkGYNdfmcG7PA9Qejn/BTCQxT4kv1bdraoN0zV8F9Uqz/9wIyDRR9pNpqiON
 bTnKayzli63l3LEsGIpdoW+YqTBiVrhsFRBUAB5rD6m2xQr5SaKjwYapuqvkmJXL/uGOPP6F1WK
 uL5RiWzpnbU5RUnGFxiM13dXbPkTXlE3bgX1JrDuPSbcEz0otoN1kU+sEXwEqSkfi7zxMsNLS5M
 l3HtwV67DJBxsxSYssox2yAUFOj3R4mSolasWtvRrVVT+bsKgad1TWXk1QYEe5Em8aKU/g8VmJA
 LpNelBncM0pL10MLZqQ==
X-Proofpoint-GUID: N6rupSvI4qY2HRKhklb8NJBN6w0oE9w3
X-Proofpoint-ORIG-GUID: N6rupSvI4qY2HRKhklb8NJBN6w0oE9w3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX9yiGgjUhUDHT
 4y09t0obp5nOX/PKrhT9Qc/I6lwRFUywwP9/fYUTZ3/cq2trFiH1K6lDkWTQrZfRvG/MSXEnHdg
 jd7HyqEaQpcDcx8QyOMJ9S7u1AB5P6M=
X-Authority-Analysis: v=2.4 cv=INGXmQvG c=1 sm=1 tr=0 ts=6ad19889 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=HzkBA2_z9QidxsSae0AA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

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

