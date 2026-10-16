Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6809F3845B3
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163811; cv=none; b=K/qC1JjRKRoehfBcUbUcOrz4dwNKuNTvrMsR3rCiX4gumKlV3167ljwFwkYEct2NmT9cxeFoHAawlqy8bThDNaNyBd3opd0Dl9PRh/ZlcGRjDuanU7btSf0/+2LD+3GF7FLU6VQ4Q4OSGj1lZ2yyJppJnLW7i36q0uWJfmxa/jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163811; c=relaxed/simple;
	bh=Gryz0CYcUM+vxlGxJhiMatAmV1le+lrqxaERD0nyZ/8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EX+a/im3WLMlBm5EWSNRAQqyp6VhUU0ONj67WWqrtRanaYio8CXssj7dydBE2BrIjQrsgU7WBkIb58xwJUU7PlPTS6aekTJDdFUg8b6FDsTOlp6HfZVw5yvHqazOYyvPVMqyCwElKw8mPsovY7zkBRBmkzirEpyJ2hFvnd3nlXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h3I2Vinw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=b+LDP0Fy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h3I2Vinw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="b+LDP0Fy"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE683w2455288
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9hCi0ui3NHwMAJmdO0y8zdttkG3wSqNgrdODmZuaJX4=; b=h3I2Vinw4TzYKP6X
	3Th+/yM26fxNoVs5SMfEJuuK7jMkDAwBOlJhARvrk9RqX7RQwbNt+43aacyg7+ws
	Aw909K64hsuRvL2v0eERwuVLpgaeitrjgBn3G87nnYBJUdaX0cvGtd87za+nN3P6
	XYJ5Ja3TgS8jbgosavkjYPIplxY276i6AWy3NyClwGvdMfE2S1MY7fRXS6Gf/hZ7
	kHTPvNOCWxsHNvBlkAekYz/i/U/ktPKDTpsHcc+DC6CneJBVfyTxmOKnZ/CFFHtw
	vxXejV3AAm7zd+o5Zo/ZfwwCkLcvRGk8depzVRqCeZug+geCfX9QDg10qVtyQAkK
	282jWQ==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbg5yskbv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:49 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5e93fab204bso3869e0c.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792163808; x=1792768608; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9hCi0ui3NHwMAJmdO0y8zdttkG3wSqNgrdODmZuaJX4=;
        b=b+LDP0FyrOaThab0sBwo5CB4IqZsduUMEtnuB61VdVaatBMWMCpD3iiVSMm9G/GzSi
         NkRZX8HqCs54bjLsSuW+TzuqPaBED4yuiQR7RGxmoWUsE8+hUdbg5NFPcIn4g28CkyKB
         8WYGkxwnP1HYc1GSLUMT6LBcJ2N4Y2MFSRXB8ndOUic9XfKz/PR+7zNrhD7fpNmgfaxR
         6kNk4/natSAr11TQqYi8zR7z/YFjGeFAN/zlN+tMKOr1ZpgYWK6Ey/WhdEN2993OS6oH
         /lM2Ltkgh4U4WkQ/4YvULacfvSXQ8SNBjSr/IcELYtDAgrJ5Cl7iLYa8EGZ6JgGPto6A
         QE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163808; x=1792768608;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9hCi0ui3NHwMAJmdO0y8zdttkG3wSqNgrdODmZuaJX4=;
        b=EW2B4Wuoyh8xduYl6j73HGw8kzA9On4xRjjJF84wB6J18PPzMmZilU4qUZsWYjeUDe
         aBfL/YPAtAbx8Ktwpn897AJlH0QBAasdE7u9wjIaVqOSIiG4IxX0vAEO6CM6LlVQrK/Z
         N4jIY5TjTKNk9vNVL9tyNKDvKLIGbe8i7rb2czdKaEuBIFVHcv2mP+I5594s8z3ikQjK
         nMygYo+Cb2meYRwmuC/34+ChZdeOrlo9GPY+v5YGaZ1rbp1bDGhscAlSgQq//RR2O1GD
         rCvDGpVG+9E0WGkV9cj2hW1zUyxLG2xfyWzQgdUxGEIF40HsuZRNP9PdshSPjCI2RHnM
         i/gg==
X-Forwarded-Encrypted: i=1; AKwUvBwPG7Y132sNA6ECpzGdQh4rrVtvaTThpzuRna+LX48xahD7e49LAmoYHEAse+iX6+cAnGlpuFgLyVP1r8y4jw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLyMWr6hxDDBYwXaBr143fUpoL16fN4Ne/Q0R9XJEA70K0MU4QK
	bpSN7k+Oq8/aZaWUnQNpkKrwaNEmnHb0Nhyhz0AsCTD97iuUB8vUG93SnKFgvhGFAiO8N9VBHoD
	wqBBKfEd9qpiBCOftifwpRiBi5ieh2PbvXA0ufE0GYbuGHQ+/ug2oB6du5u6j+A9HbBW3JQ==
X-Gm-Gg: AYBFou1wNCEi5x9qFM81jEEDp6tUV3R1vrfHUADuyI548rOo1I3t+lG7s6yoPNaz6TV
	V9KHWZkag4aEfuLJI3gCvCjOj+9hSR1q4LiNdLuzy3XPFSJaPdZiQlleJhtkbfrLWZTaNYU4sbM
	vir/vfeI4IrsoRzK1DcaVGYj9PlPdClkdY8SBr1Ce78PIzywrPsd3DBwrWWMT3ngXn4Fq/qdioB
	ouXua2OwHMYmN8777GNzW/nHVKw3nNQkvxCk5S/f0VhpZcUEt66sT4rZWyhSQ2Sdctol/7CC2CP
	bkVfQqznss26fSdzSXHD7/lx//Rww11waodkJNf52LcEP9IlxyXnzvGL83iy4+4SCahguTxNJOK
	dUV3gNfrZBA31DA==
X-Received: by 2002:a05:6122:30f1:b0:5e9:5e79:cdf with SMTP id 71dfb90a1353d-5eaaa90ff0amr196592e0c.12.1792163808286;
        Fri, 16 Oct 2026 08:16:48 -0700 (PDT)
X-Received: by 2002:a05:6122:30f1:b0:5e9:5e79:cdf with SMTP id 71dfb90a1353d-5eaaa90ff0amr196524e0c.12.1792163807638;
        Fri, 16 Oct 2026 08:16:47 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4c5957sm5538473f8f.9.2026.10.16.08.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:16:46 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 17:16:28 +0200
Subject: [PATCH ath-next 2/3] wifi: ath12k: rely on pskb_trim() to trim the
 received skb
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-ath12k-rx-avoid-realloc-v1-2-0ce6cd99dd5f@oss.qualcomm.com>
References: <20261016-ath12k-rx-avoid-realloc-v1-0-0ce6cd99dd5f@oss.qualcomm.com>
In-Reply-To: <20261016-ath12k-rx-avoid-realloc-v1-0-0ce6cd99dd5f@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
Cc: Wen Gong <quic_wgong@quicinc.com>, P Praneesh <quic_ppranees@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: vGAmyrQZvh_mLGxzb1ge2I9KxphY9HYf
X-Authority-Analysis: v=2.4 cv=M+HYuCws c=1 sm=1 tr=0 ts=6ad23fe1 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=PbDebaSGg_hcJSwW8RsA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfX42bEYbWokkEN
 ztOeTMDxj1tbWK98866fu62wYT5iKehD8yK3rX6c/RXKSlIWmEouZZZA71iZQaQLnEuUqYu60cp
 SSjT9jCuC5kYUCr7PyYr8qVBbsZVW2k=
X-Proofpoint-GUID: vGAmyrQZvh_mLGxzb1ge2I9KxphY9HYf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfXwdQm1cgD6ZTF
 3/255HOXvYoCOpHtAhtayte0os7IdncextK1hHwhOWewiaug6RgwGCOlCO3vg5u/mz/Bx4YcsGF
 M+oHz1xaF8Dmm9EZRJom/bn+dXCCrXdcErmHthL4Mo/Hl8QgORfrM+A+l/NjbHXTxufxrQTpngE
 EHWGaTDANYfezqRMi83WfT+77DdsBJB/fCwR03jnPUGjZ/hlJzwSN+CUqiE6gkdnh6k5DPearlo
 d2xJ1s+RXj4JZxZRr40AGsSKynw4m5S5vv2gukEVDJG+oXknWCcbuQhMWQ0H5P8FS6w//eN51Kq
 z1dw7v7oA3RqDlD7QF55zWlrksjZbG2rqdcf1ke2qKyGXMx2ISk+SQsNOm16JTRJfeNZMGd41ug
 qlFaUzgWRiEhXGXrXhhoxtOD5mZIFeqfn9Wv45R6r16gHaKkiDyda+EAFu9Ie+5L0fegHTIb7WU
 x3clgZ0zrxEWIxUzNIw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160060

Prepare the RX path for handling non-linear SKBs introduced by the
following RX batching change.

pskb_trim() can fail when trimming shared fragments, so propagate errors
from ath12k_dp_rx_h_undecap() and drop the affected frame instead of
delivering it with an untrimmed FCS, MIC, or ICV trailer.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 48 ++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 40b8da34268f..4f37ef12e40f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1010,6 +1010,7 @@ static int ath12k_dp_rx_h_undecap_raw(struct ath12k_pdev_dp *dp_pdev,
 	struct ieee80211_hdr *hdr;
 	size_t hdr_len;
 	size_t crypto_len;
+	int err;
 
 	if (!rxcb->is_first_msdu ||
 	    !(rxcb->is_first_msdu && rxcb->is_last_msdu)) {
@@ -1020,7 +1021,9 @@ static int ath12k_dp_rx_h_undecap_raw(struct ath12k_pdev_dp *dp_pdev,
 	if (msdu->len < FCS_LEN)
 		return -EINVAL;
 
-	skb_trim(msdu, msdu->len - FCS_LEN);
+	err = pskb_trim(msdu, msdu->len - FCS_LEN);
+	if (err)
+		return err;
 
 	if (!decrypted)
 		return 0;
@@ -1029,28 +1032,47 @@ static int ath12k_dp_rx_h_undecap_raw(struct ath12k_pdev_dp *dp_pdev,
 
 	/* Tail */
 	if (status->flag & RX_FLAG_IV_STRIPPED) {
-		skb_trim(msdu, msdu->len -
-			 ath12k_dp_rx_crypto_mic_len(dp, enctype));
+		err = pskb_trim(msdu,
+				msdu->len -
+				ath12k_dp_rx_crypto_mic_len(dp, enctype));
+		if (err)
+			return err;
 
-		skb_trim(msdu, msdu->len -
-			 ath12k_dp_rx_crypto_icv_len(dp_pdev, enctype));
+		err = pskb_trim(msdu,
+				msdu->len -
+				ath12k_dp_rx_crypto_icv_len(dp_pdev, enctype));
+		if (err)
+			return err;
 	} else {
 		/* MIC */
-		if (status->flag & RX_FLAG_MIC_STRIPPED)
-			skb_trim(msdu, msdu->len -
-				 ath12k_dp_rx_crypto_mic_len(dp, enctype));
+		if (status->flag & RX_FLAG_MIC_STRIPPED) {
+			err = pskb_trim(msdu,
+					msdu->len -
+					ath12k_dp_rx_crypto_mic_len(dp,
+								    enctype));
+			if (err)
+				return err;
+		}
 
 		/* ICV */
-		if (status->flag & RX_FLAG_ICV_STRIPPED)
-			skb_trim(msdu, msdu->len -
-				 ath12k_dp_rx_crypto_icv_len(dp_pdev, enctype));
+		if (status->flag & RX_FLAG_ICV_STRIPPED) {
+			err = pskb_trim(msdu,
+					msdu->len -
+					ath12k_dp_rx_crypto_icv_len(dp_pdev,
+								    enctype));
+			if (err)
+				return err;
+		}
 	}
 
 	/* MMIC */
 	if ((status->flag & RX_FLAG_MMIC_STRIPPED) &&
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
-	    enctype == HAL_ENCRYPT_TYPE_TKIP_MIC)
-		skb_trim(msdu, msdu->len - IEEE80211_CCMP_MIC_LEN);
+	    enctype == HAL_ENCRYPT_TYPE_TKIP_MIC) {
+		err = pskb_trim(msdu, msdu->len - MICHAEL_MIC_LEN);
+		if (err)
+			return err;
+	}
 
 	/* Head */
 	if (status->flag & RX_FLAG_IV_STRIPPED) {

-- 
2.56.0

