Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D873E49F8
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538664; cv=none; b=eK2Z2fV173qPrTzD4OT21ZVuD+XATfpMWQxV84ZAGgQ0l60lfiXGQBkFvhyy4b0/iGZHCn3lYPODAw1Arv3MA3TjVWPIzo0jA1cmENmYGTAgTFOIpmRq0ZTEGd6k6h1aC1h5iKmuBY0LCbg80bBu6zcwba6KnKw9+A2syc3KOio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538664; c=relaxed/simple;
	bh=2RTXAsDhHUugowE2+D7qCivQhNjoQK2a6/YlIn4hIuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVRu8tHdHxqyZQmv+Zfcs2ek4Z6ocRFs9j4FlKrdaYlhvCltJjFm8NU//SrW+6UjYX5h00ZQ/UvanqTKiOIhWGOVEnfWYOcgtcUXSYGrbhFt846OQN4h8Gh0rQ9ZjkVrHNehvvvlryw1UuRCR2vzFA5y667ag3PB3n7aO9/10io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ExzoRywm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lc5swXpb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ExzoRywm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lc5swXpb"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G5na7C1933843
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=6jltbE1hVtV
	VdIn3MjmvnG+LBfhowYYbfh3rA9HqHXg=; b=ExzoRywmGt8cz7B261rdmnvvuvA
	CIfje0gLFiwkUce+z1ghf/sJb8zyGgjdEibRTqpM3+Zazqo+LJwhJv8EGARqWihR
	0k183cOXpybg4KxAxHqgTJvyLk3DFKff0Wn0YzC/3wuX4WWSgQNsXf2SVVtwTpSO
	Yhpifnw56SgxgrKJeFC7XFESe0eAZvJviJ0dN7PMfCCQPvkLlp9ZONYlDmZ81bSn
	XzM9EwspSEiSs1xDyPUgBMG8zpe87nR8YvxoOE3BYsnlVz7yfSZo+b58VsBQkMtK
	5HyK+xWKpCQQSJNtzM5jp2RnZ2z714ZkELIuRCZIh3i51Zf1GIDHznteuPA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqefp9hs5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:19 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so4187154a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789538659; x=1790143459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6jltbE1hVtVVdIn3MjmvnG+LBfhowYYbfh3rA9HqHXg=;
        b=Lc5swXpbC/NuidU14SUGdoCtthwcg5kBjgiXAZ6+mZ1vXrxirEBuRsDMuLT5pTUCP0
         YHT5M08q2PiDDl50LRVbGf7dXdNJBJsVyh87IWCJT2eqNlmIXZJbjRXWH6EweiDWWCTJ
         egntsrBI6G1lROIAynTHwUXla9mHVVMvwqOkykqGIa6Mn1kw4SrI/js/FMSP8ce3w/0G
         biT3tFs/Gb2MugTyvNSHqu56BeYmOiN7lJTgWasvH2Y4cM5VBkHy49JlMdUvP2Njsk7s
         c1JJZK+J0FC8Ifxk+QFH4kS+BlozX/eojqiGMQVXGsgZCqt7NbQaGJ6eDROLHJ+E+esu
         SuAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789538659; x=1790143459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6jltbE1hVtVVdIn3MjmvnG+LBfhowYYbfh3rA9HqHXg=;
        b=zD3XWsj/3wD6Vyg2lU1r40Fwszx3KTSaa2ffmS3Enhh5hPD8vIJ9xWCWlAHSAxq1Us
         178oEj7u2HoQjUL6wrIdMQIkdnWtfx67Z2TXkQD6YLqpxUNO4/dmzY5jhWnkqBBXOX/d
         cBVttYscIDhAlPtHko6pG10M+PwdT8AwHTBunGRd33mIVU6dEWJgRkSFKijusGvh6FPp
         oLn5rBI6IBcoQkldCxUmkB6ZnYVR+VoxhSCmeYJpNAFQTHUZoUo2Iu0C7LgFxzNdXAJr
         kMMsG01XXfU6JCke8J4RM0NyMfiXG5t8zaU5etNywQdthEFcLS7uYYDVYwp0spYDvU/2
         WhXg==
X-Gm-Message-State: AFuF++mcR0qnSSlg+ZbKy+x3j1sCNrSTDbAlMf9aqYDGDfnzCEB74DcH
	NBW89m9eZEPAZXWBTc8nQTkC4I5KRkQ+pprwwLvcb0c73CqKO4fWknPPbPSqp4VoSCXm3HJPIeb
	ay/JOrekmYaOlZEHdDAjLczHORCvSmSuCqiOaP9a6FjmfONo3KzD+MlNQyCAtrgsIYYqILg==
X-Gm-Gg: AYBFou1CEOP4tnNhlZIOKFk9BaSRSUSXzrS5vi2dqgIw2QysKwnWU8STcfJNSBiZ/2L
	aWp0nh4eJ5SjHysieftJA7yCIkFZRjYy0G8uIYOo10E+3DomgJ5tUnR4hv3sMjQt0CJrqgMqW4l
	7A/npdLaIshhk4UEqhF5s8ktYAfVsuzW+eVOKbVb7jVVpUl1dctTu4GWnsLq1ONfQAlPP+ElGO2
	A7WYfMJd1bN5GPRDtUp3ITVW+SRFEwRLPjoTgEBRW5TYxAugG+gbiEz7N8QdIIpvxxDZtUcf4dj
	eAqvibpUKg6XI2x0+WzL8b9mEfpvrmJjRmLrFd6fbUzBqjOk7UrH2IsK8hXMblFwDaG+ZNBcp9X
	Nn3wvW6i8OdeNlgfE6/XMGSVDpiVrSwSeFp835m2b54A6lG1iE48RnPe1yUpiZlseH7/DVI0yMa
	9Pwv/6mzX/gFsKhw==
X-Received: by 2002:a17:90b:4a8c:b0:396:41d1:cbc7 with SMTP id 98e67ed59e1d1-39e1e27df3amr3289239a91.3.1789538658698;
        Tue, 15 Sep 2026 23:04:18 -0700 (PDT)
X-Received: by 2002:a17:90b:4a8c:b0:396:41d1:cbc7 with SMTP id 98e67ed59e1d1-39e1e27df3amr3289196a91.3.1789538658229;
        Tue, 15 Sep 2026 23:04:18 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7a7a1csm2661491a91.15.2026.09.15.23.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:04:17 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next 5/6] wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
Date: Wed, 16 Sep 2026 14:03:24 +0800
Message-ID: <20260916060325.854-6-kang.yang@oss.qualcomm.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
References: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX3XKbCpw6F8pl
 tF0fsAPHaU5ZPSOjMeEkFcONu/4EHytlDkD5WYIzK8mxId+Aaj+xK2ZsbkwrsOtwE5gh/2phxbD
 /UDXBEhz9QO90MqvZt6R77WLllgGcDc=
X-Authority-Analysis: v=2.4 cv=HrTjiETS c=1 sm=1 tr=0 ts=6aaa3164 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=R2i7fhb4lMgSbN6yfxMA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: xwiiJc26q9trUXvQ3FUIUEOKsOnJWHuc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX5fzgq9YLXxK3
 lli4Mp3AgvydJlbr9wULadeV6rUjeDvHXyfxEKQsdfgluDHglBAnMXAunpBXw3HH5xpKESQGzwF
 qjJsiOVwxigB6sti/jbIFv02iuX48vwll2Xy3IT1bL4uGq3Qr+pxdwmzRjkuxped+3Zy6MTOMz2
 bbl2ffWNKf/YiAQOOzKHeFike4hnWcnp7ZBXpvMfhjmC8AFCZgSKExAPdga9fDR/gZF0ZsZ1fjN
 h9FDFhXTlXNdiv0J+dRzFwhTUE5FwlLg7HpTElAdEKfCo7B7glGlSDK7mLO5nhwFSr8o02dxc8p
 UvW+Ks798F9xTwtR/AXp/sT6rPuVPEsL9rV9BmBfFeCCwaN40XYzyAKij/s8uRXuyn1T338p/A0
 0+sIEcdBLXSQd5W1sxNeEzVAqqcPic+aeEAe2cjBCEIfaAf4pMoEQaOCwo38zkgML7fWLFtC75W
 WZG/p5gUd/S/ZyCMBQA==
X-Proofpoint-GUID: xwiiJc26q9trUXvQ3FUIUEOKsOnJWHuc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160076

ath12k_dp_mon_comp_ppduid() updates *ppdu_id and returns
msdu_ppdu_id to indicate that a PPDU transition was detected.

When PPDU IDs wrap around, msdu_ppdu_id can be 0. In that case
the function updates *ppdu_id but returns 0, causing
ath12k_wifi7_dp_rx_mon_mpdu_pop() to interpret the result as
"no PPDU update" and continue processing the MPDU.

The MSDUs are then linked into head_msdu while their RX
descriptors have already been detached. Later,
ath12k_wifi7_dp_rx_mon_dest_process() detects the PPDU
mismatch and exits with the partially built MSDU chain,
leaking the SKBs.

kmemleak reports the leak through:
  kmemleak_alloc()
  __netdev_alloc_skb()
  ath12k_dp_rx_bufs_replenish()
  ath12k_wifi7_dp_rx_mon_dest_process()

Fix this by returning a boolean value from
ath12k_dp_mon_comp_ppduid() so the update notification is
independent of the actual PPDU ID value.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 15 +++++++--------
 drivers/net/wireless/ath/ath12k/dp_mon.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 7d5be77b081f..db20d27b6333 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -81,24 +81,23 @@ struct sk_buff
 }
 EXPORT_SYMBOL(ath12k_dp_rx_alloc_mon_status_buf);
 
-u32 ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id)
+bool ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id)
 {
-	u32 ret = 0;
-
 	if ((*ppdu_id < msdu_ppdu_id) &&
 	    ((msdu_ppdu_id - *ppdu_id) < DP_NOT_PPDU_ID_WRAP_AROUND)) {
 		/* Hold on mon dest ring, and reap mon status ring. */
 		*ppdu_id = msdu_ppdu_id;
-		ret = msdu_ppdu_id;
-	} else if ((*ppdu_id > msdu_ppdu_id) &&
-		((*ppdu_id - msdu_ppdu_id) > DP_NOT_PPDU_ID_WRAP_AROUND)) {
+		return true;
+	}
+	if ((*ppdu_id > msdu_ppdu_id) &&
+	    ((*ppdu_id - msdu_ppdu_id) > DP_NOT_PPDU_ID_WRAP_AROUND)) {
 		/* PPDU ID has exceeded the maximum value and will
 		 * restart from 0.
 		 */
 		*ppdu_id = msdu_ppdu_id;
-		ret = msdu_ppdu_id;
+		return true;
 	}
-	return ret;
+	return false;
 }
 EXPORT_SYMBOL(ath12k_dp_mon_comp_ppduid);
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.h b/drivers/net/wireless/ath/ath12k/dp_mon.h
index 162cdcaa57a7..f352655eae9d 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.h
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.h
@@ -100,7 +100,7 @@ struct sk_buff
 *ath12k_dp_rx_alloc_mon_status_buf(struct ath12k_base *ab,
 				   struct dp_rxdma_mon_ring *rx_ring,
 				   int *buf_id);
-u32 ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id);
+bool ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id);
 int
 ath12k_dp_mon_parse_status_buf(struct ath12k_pdev_dp *dp_pdev,
 			       struct ath12k_mon_data *pmon,
-- 
2.34.1

