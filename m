Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD13E5EFB
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538656; cv=none; b=j1rObIWpZnTHa6KaVx9OleMeUPEOUMYk1tUNbamn+zwL/fs4qmHhfFEZlAUNN4wExCDyBsLpS7L9arBMoZD1lwB0vfoQM3fqT1OeV2rZhtIwoTO85Jmr2VAfwcVOY2GdBhbE0w5Z3TniElaX/94KUQKA7TsO/Tp980ow+I4atkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538656; c=relaxed/simple;
	bh=YY3NtJSyR9fIlTo4HIMy69Fs83FL5UPaWC+HtDGoBew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1GNKFzY9r3+Vrc7C4ZCjeEkJBl1wavgtdTzxYQkKtG0ZePc5ICt7cfqQSlfI2BnRVP5CZuCNfnKZ/kbuIjg541/lc9l9Sz3/jXiROcPo6qSs9+bn/arrQYsRsPUYMvqLxjdn4j8pcdQY6HIKp+zU47GUmsGY7L5ZfRUhEIMIMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QXfvLZEU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XaFBm4EL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QXfvLZEU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XaFBm4EL"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLYlqU3680481
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=/yu/yUWW3DF
	WQfNHsE8kMQ/JkOFm8oKBvm0htLAQF9c=; b=QXfvLZEUvQuxgaSgLUi0MRHu/Dd
	fac7LAQIwt5yky5xnLLR+0qqy783iOMtc2ej5xhlls501Y4X4YkVrBq/EuIR3DO/
	wuRnksdwU01xRiz50+1maV+Aymj0Rz5vvPSSjHbwFDH3puCJVdu93/o44c2xX4zv
	g+sS+mRtYakSVMQTK2oepRnMwt6fiYXbioM3pgtBySGD6Ucykwmvv9Lie41ca874
	QCykx4uoqGvpPLJf06BA52lAL/P3UeSDHbfNe/ENRjMWLG9hJ2WepDrDqwarnJCZ
	Bw3IE8yfCiL8vtRVqXiuatTbktS9mkMRYdj+TXY/m1iCvVsg3UAyu++cmkg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqe1r9m8d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:14 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39512608fb1so12133109a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789538654; x=1790143454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/yu/yUWW3DFWQfNHsE8kMQ/JkOFm8oKBvm0htLAQF9c=;
        b=XaFBm4EL+DS0affPKbYxiCMYprorAu7hch6vw8UxDkBvXoHY/o43o5wTFQyuPgWzPT
         VUsTMWHG/xjxjRrRwiFwxW8dSEIt3am5CSS21MvpJx0XGVXjDjEcYVBudUXBSifH8Cs5
         P3LCNnDYeIr3Xzy0RDrc74ZzzIkkw0aRMNRgcnhpcilFlu832Qa1XGg3qXWdg3wEKHJc
         ZMuekGRa85l4S+QwAZorNPWRL27LLqR26vPvOJDrkRCZwCb3gtJeGf4FwdyqJTJG5ngt
         XKG203fxy/qmEibe4PaiOEA12U/4Uet8Yjhf5N6wtKqyMD2BJdPmNFKoAe/+IwYO4O5C
         OQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789538654; x=1790143454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/yu/yUWW3DFWQfNHsE8kMQ/JkOFm8oKBvm0htLAQF9c=;
        b=GTP7PKo1v09hKez3VbHNsGjfpMgeUqXcoLyiZ9eX9WzUR6+iVoqnwRxgZM6KKsJ/Ay
         lKC99ifwVSXOGEQkzfehpYhHKC7tBjJ2tZltnV1pwpiSQGjml08Ob8jkmc13/rVLBvqM
         s8f/0K+/IYr39IOl8dEXKWV1b6knelkRw2cdf4AETGf4iLWKygSI5CrVCh3Fha6sAURN
         SKpdZet8QcdWGlVbORoyfd+ZTlZPJ+lCuEYXuWZpzLcDYHdme9QUGnvyWE2HVFOmhBMH
         qPQ3uKZjvq9J8BiLtOTT3WDzD1pF4mSwTw/jKvrpp8aqpFkhfDCUdyx9u4ytqy2wqPmy
         rT8g==
X-Gm-Message-State: AFuF++ksU4Pg4KgmbTpKwvSRR1copPYi7A9LKLH2OEh/edPtFYf3zr0Z
	MkqickciBkK5tgL3zy+nqaOpUnqM38dIyrCqBGNqvFPtNwYFeTMcBBiLmK52oIwrbQWqqn4EmyC
	TiTNDvv8uWgyryIkuRGgSO5SwWVQLaKoAfXcKkvlCw2QeQxIXxWCkdA+QOqH9WeCgzI6CoA==
X-Gm-Gg: AYBFou2k/Sbcihh1zXofSJSDYQoBJYUpjwlkyK6dRinL8aNeSKroiJbl7CEhP6iSAzT
	+QEijXVdgethAQVgsnO4uY5jD1Oa+y7irtmPckcY9u+LlZhz5HMU5ogQx+Fpq5VhF0ygFmnnykf
	kM3dmehtMRGynDAV6PZ/xEkKEK92NOhVBbK4IKzlvxq5n4eaOcqrbTEsWrV4FcqyeltAgiQxrE2
	DLDfgqJZ89wfXixmVWXPkegpr390KCckjFRc4ByGxi+U793BPOqFs1GKZP/R73CYDOFD7cbngtR
	KkkBWLXJ8HQM1P+jdmpBccrnilJ57c194XkTgjYUd0BXiyyCjusEK6vL88DnjxmhBDccJZZY5BR
	WBaNGD/hjftdDZrslK78jahw03QPkpwMcz3X8WD2GGFewpRAs5RnGfZxoBcoE5IxCpmvFjixTCL
	gQgR0gTgIA99WaxQ==
X-Received: by 2002:a17:90b:6d0:b0:39d:e213:9dd3 with SMTP id 98e67ed59e1d1-39e1e27ad18mr3382473a91.1.1789538653716;
        Tue, 15 Sep 2026 23:04:13 -0700 (PDT)
X-Received: by 2002:a17:90b:6d0:b0:39d:e213:9dd3 with SMTP id 98e67ed59e1d1-39e1e27ad18mr3382414a91.1.1789538653234;
        Tue, 15 Sep 2026 23:04:13 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7a7a1csm2661491a91.15.2026.09.15.23.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:04:12 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next 2/6] wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
Date: Wed, 16 Sep 2026 14:03:21 +0800
Message-ID: <20260916060325.854-3-kang.yang@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX2jUX1NrYkOn2
 CtYgAB8RFm3FzmaZZ+uYKy9nFuEgDQkCpVdRHIgPryDHIRBZFvKz3TEQEgKe9smmbtcC4mcqfHT
 pNPDfyDdVkUaSXH4dYvzM1m98nXsbRQ=
X-Proofpoint-GUID: VfVVToiBxbr84JOJ8mw2g4SzVZpup0Ic
X-Proofpoint-ORIG-GUID: VfVVToiBxbr84JOJ8mw2g4SzVZpup0Ic
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfXxhykKHqWPc/5
 LZdLUjspuVX2tHEgpazguIK7FOVW0qmoLb1OFU+Xd0fzbRIV9Rk2SAmhC2xBRSvDyUlZLAmHQMT
 WnY9cyR5slmDu1MLB5rAdEQEuVqbJw067QcrRR8suq14dJEkWjmBSUhLlE8f31tDwad7ZpaYB/T
 njYjQMFVvy/zdZbY/T99xx46kyyVy3OqApbpIrmpq/xkG9kp9RfkuW50ny3WlvQkPI6MykyuMgs
 uOY0dbvjMb4JUU0a5BBPP9lCS+OiiuDED3Ijdk6FbPSkFyTcWsR5PZWNliLNlOWq57bqlwCF+Ux
 FB3yg1DIWQ7Kgi8/UVIPAn1/unOpX7xO3z3MXMlNnUgdYQ9a2UWsNRRh523Vvnehm2qmrzOMVQX
 IVS80/1dmV9oUpfrHDV0QA1TCL23xJyFNw+jPCsJT+Wh80kkHS2Z3V3FkLdr41f5VATJlfMsydH
 dlAySILFPYc05i8yNKQ==
X-Authority-Analysis: v=2.4 cv=ZIhCCn7b c=1 sm=1 tr=0 ts=6aaa315e cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=RKeApao1t3Rrg6TELU0A:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160076

ath12k_wifi7_dp_rx_mon_mpdu_pop() aborts processing when a duplicate
monitor link descriptor is detected.

Previous iterations may already have linked MSDUs onto *head_msdu
and detached the corresponding RX buffers from their descriptors.
Returning without completing or freeing the chain leaves those
skbs orphaned, resulting in a memory leak.

kmemleak reports these skbs in field testing:
  kmemleak_alloc()
  __netdev_alloc_skb()
  ath12k_dp_rx_bufs_replenish()
  ath12k_wifi7_dp_rx_mon_dest_process()

Free the accumulated MSDU chain before returning and clear
*head_msdu so callers observe a consistent state.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index ed6686746605..08f2fba3e680 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -2675,6 +2675,8 @@ ath12k_wifi7_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 		if (pmon->mon_last_linkdesc_paddr == paddr) {
 			pmon->rx_mon_stats.dup_mon_linkdesc_cnt++;
 			spin_unlock_bh(&pmon->mon_lock);
+			kfree_skb_list(*head_msdu);
+			*head_msdu = NULL;
 			return rx_bufs_used;
 		}
 
-- 
2.34.1

