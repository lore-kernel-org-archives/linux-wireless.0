Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A043B38A4
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784785620; cv=none; b=uivpyz7ebNN0Ek1ouSfcKdUdP8QDUbr624VeAqb9N3SYj56I/dsLy8cUG+GdXzkvlDyO1CgIxD42g2I+TK5ZbKqFYShzSfIZMt2YdR9xGkUD0z0/KdwBRHNIYjJkHZqu1NN8U12Wn5ZSvIl/PiHfpBYwG0ZnWV5sqqLn8fkU18g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784785620; c=relaxed/simple;
	bh=nSOnklMxi8w3S/NwRdn7NiECncPAbJ5GHzGD6vQPdtQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eetIprdmBN1qfbPJ/qDyfY0+GKdKhBjd6CN3TsA7LSk/j4+A9l8cwWV1g37BFlEm3H3i4V6iVhOtIi3g4RLo/zsjiY0VbNwhtNXWiVfhG8gMqQABTAZ/L+/kmDqoZYx5oRHOzS1JSqXc3SjrxtfchivIr3xfTR4tk3o74W/uXbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K+0n5YQD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TB2SCgTB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K+0n5YQD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TB2SCgTB"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vHb72725701
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=l3uW30kCIOs6Eb/LpaF0etfTCQFf6lMp8xu
	g9C7mWkA=; b=K+0n5YQDyto6YsEVhonRt+F9aHOm/hSLvMYpRWcVfg0+j62OQzm
	bHmrEufaEoQfWX1dTmp7KrqKFAeCQfdwX/4CNcHlXVMX9z/x2Il+s8shlCr7svWw
	MxROWSdBihDXsr/2pPHWfobDogVR5fDWpli+Biu7aye1RUQvdeweIAQepIvytOUp
	vdljWGutQxjOaLZoEyhAQSbKt8QPI5mEDJivJ7EM0CwhK/4ovtgJh9MGcmFxx5v2
	5POVO3au6h5bYggxsB8DGLt4FMCs3BxYOgwpM7OWdN+fL9xO089jMlk5gY2YVnCe
	ewmSlDI3OzMFSxl4eo7hWMmFmZ0Nr+6o7sA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkafw0jua-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:46:58 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb835525b10so473381a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 22:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784785618; x=1785390418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l3uW30kCIOs6Eb/LpaF0etfTCQFf6lMp8xug9C7mWkA=;
        b=TB2SCgTBH8NLaTR2cofl3CKEx7hJislDioODCSFAb3jZvQ8fmeCj/Il6Pid/JYZKfh
         eGr+X7p1UVxD1ngb1CEwLQEOQDwx73uLa09DR83qhyWb6dcS1zlcQR5rIo7sQ+6o8mjW
         NLBzj8feSzpGp6u11gQUP1I7IJNTmWWHwmkv0t5NpeaXb1QBJzyHqJb4mJCediHkoaZH
         a5SlokpLDtA8w5LAIsFkja+HWKAqNN3tpL2aPIoPG8gl80pej/6P9x+p3RUeVAfBcAL8
         yMdJWH0KU/RVSfPAJfvF+13K5ZNB/eCJDxgSveSjsJHb+/9dWvH9sD8SU2YsIRCzD6YS
         +8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784785618; x=1785390418;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l3uW30kCIOs6Eb/LpaF0etfTCQFf6lMp8xug9C7mWkA=;
        b=J+e1YOylEpaZQ9xSAZ5oHEJtStZzIYaTwfPjWONPxJvI5tpm1azGzcszIX1Xc5lvk6
         nNNpcc41yo5qNoWrqa4Tol59lvGTiXkgnBXv8jtz7n+8DwZls/Xmz5Ty7vMbhyqwQoK8
         TOPt6VMne2nVgqwjyRyxZQOg8ZRNsK1vEMdHcutrvVEwgiErS2XbPkEA18Wnahj8LW84
         WhiGRyPi3wDn8Z4VEyCLtp1bK+VZoeXcjlM7xCVzCcAMu/5eIOWtwdvFOIJbVTjd82vL
         W1MLQ3bZT+//x/PXX4pr03ENEsLf+1tUXoAbSYI1DbPkgV+Eg2Zl4/JOH0GATAowLySn
         P/SA==
X-Gm-Message-State: AOJu0Yz3eOzQ0EVfh8+dRINsuOLBaG8GSf+bdQmDI8cLwgrLPOCRScvX
	5odoJG4x1cROCZmrw7B4hrGKAfBrgsaNYgHqi5R8nfgi7SCeKI9TLN0ePBvtNtXbmcVy1VGSmIp
	GhR/O1knrkDrMXFffqSZbDte7dOWBMjBQzcbTQ9DHJxp9Qk47s0i66ybO3N4Wa29PgWbFtw==
X-Gm-Gg: AR+sD12OJBnLMUxr5DJ+5wcroipA8KOHX9pacS40COQFdDQSjYRDX489imCGELLM4B1
	EYIpfATalWJLe40cZfFOn155lLgBK6sMXNeqKxyZl9UB5S84kHTs35HI5n1qlcONcZDt3xoCTvK
	vo1zB4eVGZONcYtoPM9QGqoUwha5KNoGGuANW0Brqj5QF8ckx/BUctSsiC9CzLNyZGud5L8xBEb
	2Aywt8BsxmWqkQHNyE1jLCap2PW7rk/CODm3YRhROz2QCkxVg18/Gm4WUBPehwO3ciLjMkQOwKQ
	G5GqdcdAcuZc+n9+qgjyRapA3LTiTkCAeMTId0GN+N/c69L/qxbIl41w4XfVF+6KkqMXmzRGYKk
	eIn3QiUtwMN2KdDdtWicc3A3jP1CT2GmOSwVnImaQ5/6kmZGyfNkuCQYELrehVQv0B/BQBGv5A/
	5aqnVDer8pTLItcqfqD2aA9TBxzjlya7DD
X-Received: by 2002:a05:6a20:a11a:b0:3c0:9c19:65b4 with SMTP id adf61e73a8af0-3c44b2ae267mr1550616637.76.1784785618009;
        Wed, 22 Jul 2026 22:46:58 -0700 (PDT)
X-Received: by 2002:a05:6a20:a11a:b0:3c0:9c19:65b4 with SMTP id adf61e73a8af0-3c44b2ae267mr1550597637.76.1784785617570;
        Wed, 22 Jul 2026 22:46:57 -0700 (PDT)
Received: from hu-pnandesh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e088d3fsm16053063eec.25.2026.07.22.22.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 22:46:57 -0700 (PDT)
From: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath12k: skip MLO multicast links during crash recovery in Tx path
Date: Thu, 23 Jul 2026 11:16:53 +0530
Message-Id: <20260723054653.2794550-1-pavankumar.nandeshwar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=XNkAjwhE c=1 sm=1 tr=0 ts=6a61aad2 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=BTM6Z11oJFv7UA5KYW0A:9 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: y19H9ojh4ST39fnBvz1rySO0vNL8nGSq
X-Proofpoint-GUID: y19H9ojh4ST39fnBvz1rySO0vNL8nGSq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA1NiBTYWx0ZWRfX5UeFkzTn+PO7
 jTP2lfasW8tRO4RyHfyDFveziQTBqQ+ULz5dPbw9hgK3aeoCBfs9S1RHWB5tIuj4+K1FDJ9xM2V
 +/jD7GTVMBU0oqQ8VHWQeqBo1v6yxVU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA1NiBTYWx0ZWRfX69z9zah23n9g
 T0krtkgYySlqKaF3Ziwj5qKUXCu24bmXCuy3TAvFj+X2+6Q2NclawnoDvmVJrMgus5Sc/goJpJL
 m7ZTq5agQTRor8KwNHhwqwwA/eSlGxdJOO+AVDXLSKVShjCtOTh8z/qMc6vZaF8p3Ouzs1Zp8Wc
 CzDOXChS3NvyQ/rtNibQ1S6UImHAv5F0HKvKJ071Af/xGnOFBAomWlvRIBPBHfuQ5RZk3G/1ipm
 JDV1d1yX3rCOtn37SCSzDjogy83Rv8OeSMBjeAJAsmn/0SCnxBx/FWMVgpbrTyMEu73SMDvos8q
 RWnMvmnjgW1K6EeksLWyGKCdGI4xFKK8+T1LuqzBq08+8mSG95ElxQ6TIxAMNZSejQfZ9E4kvcU
 Ug2hEKQ5S3BVelqT5nxc+qlpzM4gbgianhmOo2PagZvdHVl92EZEI/IVSwzRJeWq+Y4agpAC131
 VnfkWcCXxnMdgXwFYfA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230056

In ath12k_wifi7_mac_op_tx(), the MLO multicast broadcast path iterates
over all active links and copies the original skb for transmission on
each link. When firmware crash recovery is underway (ATH12K_FLAG_CRASH_FLUSH
set), the per-link copy is allocated and partially processed before
ath12k_wifi7_dp_tx() eventually rejects it with -ESHUTDOWN.

This wastes GFP_ATOMIC memory and produces spurious "failed to transmit
frame" warnings for every active MLO link during the recovery window.
The unicast and non-MLO paths are unaffected: they call ath12k_wifi7_dp_tx()
directly, which already guards against the flag at its entry.

Skip any link whose associated ath12k_base has ATH12K_FLAG_CRASH_FLUSH set
before performing the skb_copy(), matching the behaviour of
ath12k_wifi7_dp_tx() but avoiding the unnecessary allocation entirely.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 1ab1168510aa..2e17bd665dc9 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -1029,6 +1029,9 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 				continue;
 
 			tmp_ar = tmp_arvif->ar;
+			if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH, &tmp_ar->ab->dev_flags)))
+				continue;
+
 			tmp_dp = ath12k_ab_to_dp(tmp_ar->ab);
 			tmp_dp_pdev = ath12k_dp_to_pdev_dp(tmp_dp,
 							   tmp_ar->pdev_idx);

base-commit: 90883c513ca01e77c56b8d94be7de11420c1dacf
-- 
2.34.1

