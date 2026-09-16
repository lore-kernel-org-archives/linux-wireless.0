Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7C13E0C68
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538655; cv=none; b=hcBXpA09EqOkYtAJ5KR1GrK939oM6mubu7oWfBj8oytrH/56ABxNl5sU4CWujw4KzPZFfbaqoOY7TE3ZkK0GuJoBnYQprfYbe2GuqMdCcFmAbanP7Nr/AIZwFIk/ZXk5rU7IQcrhjMpUaXdKHRGmD5ME2MjPyQ9rOt5iBHQGmkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538655; c=relaxed/simple;
	bh=AMheYNex4adDyS6ha2UUylD3+atLcawiVAZZx93WtxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RBu5lJC6+7iHgOilTmb5VDBtFWzwKrHZmBDOjSIty0YOXdWbzH/RCBnmKloS2LcxIKgszzTJcAep0bpqsXvAaU9tGQbqx8f+uvj5XwcPAy6Ki8u3x2xIs5lFqbLB5dEoXGgQYQ1i5WXEJm0P3PP+gHqlyT37MVnuvmrh8eapefE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CuqpJo4Q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WJlUY4PM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CuqpJo4Q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WJlUY4PM"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLYufl079854
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=DcY7HrNKpuW/oPnpYSwA2JrQ2wfWf7lfynF
	fW4JODuc=; b=CuqpJo4Q34LWejQcrWokvGnC5Va4CEViLGkDuwioEE1rWLPxF4N
	bOGUFIU4qQ0TXi1es3li1PMkLHQHuord3qazv4GDKGcX8NJgIZIfWq/ogVVzcSHr
	vSKE4u0JgYA0fj+5X3cwl6ddM5Bxat+KRko926iv3DTqALwzu4dFs+isXG2IS+6t
	b4zbk4EzUuZuoqKjFgC60DKB6LRFDHmCzxWfkkRZAe/5vp8xoxxos/rsd6oF71xh
	OBA0AsrTC+exZj9nPuNrTzM612Ir6kI7kGnsu4QwhDGSBaRPpJTsXA0Cg8vbSwM+
	ck70lWzpEl8rasZQ+CougfOqmjhGHGOH2IA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqagejmrg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:10 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so5119445a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789538650; x=1790143450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DcY7HrNKpuW/oPnpYSwA2JrQ2wfWf7lfynFfW4JODuc=;
        b=WJlUY4PMk9Ud4TIQSvRWlmbkIa5mS98OQtr5MJPVDqgoc/fSVlSfRNlmdkTlwUqjs1
         0h0tGsJiQAhJVEzJCeaw4L9k/VREtpsrPSlMRGrg+/UpngdSncLb3jCGq4ovgeGxBWdc
         ljFHIlWzeQoRRTt7vtIuKSBrCySAmuIPsl4i2XEmYvE7BgMHpjldeRlDrWdNyzpus+c9
         dfFLOIJMAXdzB7jNN4I6eHZNOljIm3QIu3yVo1eA13zrgN2ABjVIeFMwEu6E+W0TcmiC
         aqnXfYvjlJKFMR6wByNapiGi3+AjGgVUmRHJqNW5v0wnf8MBnPwcev6hYhWJp7zeCTxr
         de/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789538650; x=1790143450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DcY7HrNKpuW/oPnpYSwA2JrQ2wfWf7lfynFfW4JODuc=;
        b=xyzYYWTqZMU1umST4acIWuhjofJzIdQB99NwT1amtgGNccgMJZaaq1GVNJZpBG73lj
         trsU0eGn9jc4t7rRwuzFMI2kBb7fZzNL8O/BqTrSNwLwVFt6sGu3ZFeWWWXCoykOWvDX
         G4EsutJ1Y328qrJTEmuea7FnidDUqMWMTPfehmFkoUaQJDWzxo1QUU90InFRG6Q8CudU
         BtvorMsAMmD2Cpe6F0aU6318UZIjFGYjuix6CcRt3o24mjlRotgZ9UMWNKhVdEb75MLe
         EM4tQV8KtySnmcreuMpotQXIpE5EiN9KR252ZK+GixUuK8++b1zaE8zRHp9U+UTFNTYr
         hnFw==
X-Gm-Message-State: AFuF++l0tyToll2+bl7R7ohioSuj/ftoAhhTqAGt/SgWeCpmY351471+
	Buk1Ub3JFwNLAxUGFs45cpckTbpv7lshvh+W0aZQCx6rthpcUIERV7762OA0ulMMKauiG4LHsx/
	pmFhhqzx76uBsqCK+6LAeJRxjPu34UpXH8NDTZbf1exNdpj53lApdqv2zspLR/kkU2KUJeA==
X-Gm-Gg: AYBFou3DpjNu7DAKd+r0Ejsjpb9UBKUxj+XbyCseOvH8f8S9zZzKKDfBrRsyJJF2cfU
	6XXQNgOn01m6MErza6P3sEbzO/vwAQILtqtmN7O8epxyF8UlDL1E+DEy7A1dkpaogC7zYOmZlsU
	9sye4NhZe4bpXp+BsYNZpjKTUKWwj+vqFoOOPPlKUuqqKRLo4LndWmPrObfvpWALUvkLnFf0gVo
	Hwv5YZuYpgkgrg2LjOapoSaEj0WMQNxJ+x1GCX660+kSCCskupenkGTTveB6yN0kBKI/Tg7rHQU
	fGSKwlWeig4dsu+CcySr9pZ0iW3uME90wIrrcGuJMboZmMzkNYA/wHah+aN+4pdQRtveUDyiIHQ
	juMIJp2Rq592blq0u1jyTDqyLzRA+RY+KJucE93Uvr0R5BUv9/lNY/fgtNf6QxyJdWqgZrP/aI4
	5d/EvYyJthqAV+pg==
X-Received: by 2002:a17:90a:e18e:b0:39e:ac:b776 with SMTP id 98e67ed59e1d1-39e1e5187b4mr2918497a91.25.1789538650077;
        Tue, 15 Sep 2026 23:04:10 -0700 (PDT)
X-Received: by 2002:a17:90a:e18e:b0:39e:ac:b776 with SMTP id 98e67ed59e1d1-39e1e5187b4mr2918437a91.25.1789538649597;
        Tue, 15 Sep 2026 23:04:09 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7a7a1csm2661491a91.15.2026.09.15.23.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:04:09 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next 0/6] wifi: ath12k: fix monitor RX buffer lifecycle issues
Date: Wed, 16 Sep 2026 14:03:19 +0800
Message-ID: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
X-Mailer: git-send-email 2.49.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX7khN0FZCAtw1
 jNK5rNuS18MKGE7HsP7B6k3WrYRY9N8D0AO4rNHahjs49B1Lkh7vkPXEFDTrQIBXbKpwzFDkgT+
 +ayNvd93q8wdO4vPhqXrP7A0iTIRImg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX66OhE/A+0D7R
 xO1iDgOL6LLGE/pwPwoWgnAvMPV3bHZiS+JsdB+zN1kqkHWyhNdG3VeKkgrWB7QVDGvdxnISMp+
 SKgRIqJFuGzfeZbExEJgIml6BMmax42cU+Znj25/yVNYaMcxIS73LsSJhC5Nf5qAs2+WFnigl9d
 +EJ0Q4hqtjSSDMbX2pEZgRdffHh+qqd9KGGq93q5G7WMmjnTpDA6ZEtiHTwsK02J+WgZ4/Yx4sz
 rofbOa5+RpEdaEF57O1q9wzrIBKNMYThQfJx84h/GQFjeOw/a8rlzpvJgMFUqMfkZRUs/KAS6G8
 NheKRO3BFsZvpl+7zox6w/oc/qqisuJ5xGHqGa3kzInsut6J2K4R4AqtEBQNWwEujx3dESNIVZV
 vj5O6tnyB7lDM/rLvsRlgXMvXfm8FUVqBBFaX7hA+5rpHGwDN7+bEN5LMALXoZfCTXLsY3qW0mP
 Nt+SC/Z58CkgMK1fWLg==
X-Proofpoint-GUID: hKoggj2ievhu8Q5nZBGdrISIjnN6phhe
X-Proofpoint-ORIG-GUID: hKoggj2ievhu8Q5nZBGdrISIjnN6phhe
X-Authority-Analysis: v=2.4 cv=PcZqFShd c=1 sm=1 tr=0 ts=6aaa315b cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=cAceGTCcrxCDDuk2mPYA:9
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160076

This series fixes several monitor RX buffer management bugs in the
monitor destination path.

The fixes address leaked skb buffers, stale monitor descriptor state,
object lifetime issues, and incorrect DMA unmap handling observed in
various error and corner cases.

Kang Yang (6):
  wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
  wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
  wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
  wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
  wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
  wifi: ath12k: avoid double DMA unmap of held monitor RX buffers

 drivers/net/wireless/ath/ath12k/dp.c          |  9 +++----
 drivers/net/wireless/ath/ath12k/dp_mon.c      | 15 ++++++------
 drivers/net/wireless/ath/ath12k/dp_mon.h      |  2 +-
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 24 +++++++++----------
 4 files changed, 24 insertions(+), 26 deletions(-)


base-commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c
-- 
2.34.1

