Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A323E63BD
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538658; cv=none; b=YPh3NALQNBBfkB3TklIZt0ouY79Sqkk9Z0NetUc1K+PVOeSaqwXaDwW2oDA356M55stteHG2y9MXAMruFRGWB9Bo2p5I76PwXLsJSrTV8Ww+oLxH7B4QYYrGlClyXuxI6sCSDJ+RfqUSIt9hEEPa/oFbo2Fg8OaJjgydxvR4aYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538658; c=relaxed/simple;
	bh=/vWpa+X/GttVMEkz3DrVEFxwX/61Y6dbYwiE+yvh+Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTT2/pdfgbj/9dKW7Q08IdSwzRcyuFkCQ66EkSAUjcwh5Vzt+xaxC/XjBa2vj6vWkKUbvEp5+SvzyvRFyBiyLT8Nv3+sbFRAbM30L6yqYkaOC3qc0ZF7p/SdDgoO0Wy+uIFOP1OzawrwqJlgsfT/QEDTjK7a4K+MRNDpr2X/0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RBzz5Zn6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=azaNSG1K; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RBzz5Zn6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="azaNSG1K"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G5gFt6841285
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=RgG/G9lC5KY
	80n1GDmC0kSRTyio6uYTz9hujgM4SQxg=; b=RBzz5Zn6ORBPmrdv0WLbcUQVa67
	/R6YFn/S0+fnL6yb3OPPU9jNOv8ltNhLizX/f00dJ4rlEucVE4bgWgVXcy+iOAR0
	Yd8NooaWTLWelOIiWRLyXhOgRFjk3IAW/sjANnl9WIMa6Cqlxx3W0kyJjK4OAYRc
	u2kFXkAPU8ZUdafBIhyKtXazxpMouozLUIuqu9Ql6QSaQNEzUvnveGSkJtv/hrxd
	hwnxnnudEG4u4SjEylskdz56MzjsYdxKRirih54af3kAeCwCG90tt7UXqWp8AMae
	CocFxdYmXCPN6G+6JTgO7ReuyBMn53THc8MJ8F2HXoV6dcOFet1aGV+kuaQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqdyw9n8j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:16 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39d8646b10eso5542008a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789538655; x=1790143455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RgG/G9lC5KY80n1GDmC0kSRTyio6uYTz9hujgM4SQxg=;
        b=azaNSG1KtFn04lMonHUoNpa39wkvbdcFOrxep9qEYSnWF1BNR1L+ClWiotmr/Eb1le
         o1qz9Wnv076l+Extz9FKkRfTLKFO46q/qQCwhxzLTTtxlC/KbqbExbMb7WAiqW7VgP7u
         CEuQB01ulwSrKtRMJqDRA0gEAdrwQSMVR8a2at3ZZx123JqU40mnSq6XCF8IiKEhY4el
         A/x3dZt6kOWa9sSLIYTrGsA7TFgC70y+FBP1Ow7ctDQNy/sS++eInCn5xt6XsEgSjdFH
         lnxG0DMCehzg+0KS2QfsjnocVnIsfXeT4i3Q6X5DwHPWH5S3bT7tTUkw0lNWc9NXHADW
         LK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789538655; x=1790143455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RgG/G9lC5KY80n1GDmC0kSRTyio6uYTz9hujgM4SQxg=;
        b=15o0VsPj34NfgkD/Eaaoj7utUpOupg58nvUZYih11IzJh+pD8QeGPub/DWqdZzV65L
         6uMgu/0dWIW6XSb7nYxuwJqeyXYfivazMG/10oNBGVCMwkc38gnQC3u6OJ91hIKFDtel
         hlAUTCbToS6WmGPP/0BMuwjbdvq+DWUVi0JCUYr6Vwh5mvGcVuvyLSNfXcm5r2pKMNTo
         4A2qqsMGkCt4apepYtYtpZYLUzWhnIYvLpJiumei5s/ZmI56/FvOvxojHXiggiHtE/jg
         HFy5hFwfEXkhdVLJuwjWI7C2RcW08hAHS5XMwjKxeQwn+yIJC7O1d6oAzIEV/jdNRi+r
         cylA==
X-Gm-Message-State: AFuF++lK14G4SU0lzVtI4+VPggjEU9Wk+u0YQ2hXwFjTCu4VCK+U+gK0
	Gz1nU13AIYgU3+OLWx7DAZWZbqvNW9dO8xh6PZGPlZu8EEVWXnUdfhEOpcXVNq9nrbYGamOuZHv
	iWrqjF6dWSN2pRZinYoMuaFjoFtLbhtgR0QaV2TvSY1KyS5UARSrQsATUXXQSDYsHeXDOVQ==
X-Gm-Gg: AYBFou1BnjIbM5G7WKFwgS5aNMFniM3yftZu2KQvkMOB+hx+CDtcnGh5g9Uj3Awbdbn
	rZnTPbLNUyTzNdBpeDT4an28i8SlQ7/ndbds/+H+7IriaMgOxsVTb4SmJRa+nmbVYRk9lm8bTsL
	F8dvYbIBZHTzzxAKaVc5DRVuW9a4CYBMVaUGBzjpuHb84FQmHbB8rdaxQlwh3ABCaQJCOOsd/pA
	ZU7eGj1H770k97lqHzyu4JMAWthdTMu+GvdEXxA5h2o9EUnj1qJoT/JNefJvzgnvlCLItDfDE2j
	Avi6MZqdlRHBMhWW52LBu0vT59CvXNucs1QApvNktzAHuxxwZz6xUyM3WRq0lWfHY3UCzyyw+0F
	MFV/kV0xYOJns1blYDcYiqM8j93asTlX6w8/atlUf7bK1V9Wdlk6c14AbJ3OBbAKbjX8r0K5Uge
	/dynJ6N4RfvJaS9A==
X-Received: by 2002:a17:90b:38c8:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-39e1e3005c7mr2611425a91.8.1789538655264;
        Tue, 15 Sep 2026 23:04:15 -0700 (PDT)
X-Received: by 2002:a17:90b:38c8:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-39e1e3005c7mr2611388a91.8.1789538654842;
        Tue, 15 Sep 2026 23:04:14 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7a7a1csm2661491a91.15.2026.09.15.23.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:04:14 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next 3/6] wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
Date: Wed, 16 Sep 2026 14:03:22 +0800
Message-ID: <20260916060325.854-4-kang.yang@oss.qualcomm.com>
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
X-Proofpoint-GUID: VpIqf3WWoGZI5tb0KcGpOM3VhNwDXsEb
X-Authority-Analysis: v=2.4 cv=aJ1lOr9m c=1 sm=1 tr=0 ts=6aaa3160 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=INwfhUETP9GVDNSjyDIA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX4uQEL2l7mQfp
 NZ7mAfC/imHEJPX0Bck9Q9XTogMRaEnhUyHxAxJjnIwMUqS4JNkKMltB/fuXDuPA3ibPEgOG9mz
 8+ovxTFE4949R2CS+xS0PxuOnJGz9JAXsfGHSzDq7L5GEO8jGhKJ9QNa9wUuaXZ46XjJe6V+t4a
 UJwgJN83K9yUhL1QL4dJ7M62jSQaXV4BDJj5voZhY7BFk3fYFAQTrdamC/65RJARoXigSulBne4
 AdRswNyC3fkTiyFEe51a57aqiBfXPvQEF4SJRdaVccQiP7NDUz5xTyWvbfYakkAFrAovth/Ymhu
 zpPPbH8GGqrBhrVTFrlqvGDOHrfSJASmMgWeNJOO5Xne4CStC4WJjla2rWdu/YyVNWZ26qIDX0L
 VK63avb8KiPgpv77V4ja5loHq/EVt/aEwYI6LFtLgZi51GOQ8drlhyKhjJA8KW+OmoNh2ci3zuf
 tpCugPKLjnFKld2kY6g==
X-Proofpoint-ORIG-GUID: VpIqf3WWoGZI5tb0KcGpOM3VhNwDXsEb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX0HyGkRorl9tH
 UirfoUrA460etOluF2mxUpDZmlztCQTjP5Ut9D1wd8rcd/IHGcIMQuhJMc4up+Z3C+28/CCcCRF
 RrEg9m7OpWC2L3i6uWBLQECSDyD2c4k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160076

ath12k_wifi7_dp_rx_mon_mpdu_pop() assigns *tail_msdu from the loop
cursor msdu at function exit. That cursor reflects the state of the
last msdu_list entry processed, not the end of the accumulated MSDU
chain: on next_msdu paths (invalid skb, drop_mpdu, first-MSDU rx_desc
invalid) it is set to NULL, and on the set_pktlen failure path it
becomes a dangling pointer to a freed skb. When these occur on the
final iteration, callers see head_msdu populated with a valid chain
while tail_msdu is NULL or points to freed memory.

The chain end is already tracked by the local variable last, which is
updated only after each MSDU has been validated and linked. Use it as
the source for tail_msdu so head_msdu and tail_msdu are either both
NULL or both point into the same live chain.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 08f2fba3e680..8fca777041d1 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2802,7 +2802,7 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 	if (last)
 		last->next = NULL;
 
-	*tail_msdu = msdu;
+	*tail_msdu = last;
 
 	if (msdu_cnt == 0)
 		*npackets = 1;
-- 
2.34.1

