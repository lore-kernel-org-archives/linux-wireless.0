Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2754937FF7F
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465387; cv=none; b=TuSPv7ufzjN7V0pYUSTG/2l9LmKJo3KLVcQyoxI8kjGooUVO1SegJ7BsGnMkuZ/BT2LKvG33DCkEO/U3eJbkWpFA0GNvE8IwCrCPhd/0H1T8dOtnMG9O6GTH36hoSzBR2wkohntO5n02J3lyIbkoR9fPY3+dPrXgWRx9HezyjG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465387; c=relaxed/simple;
	bh=5y/kKt3zQpTzM3vdB8L2UgSC9z11kdDDzRKReYX+rpc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kNfmMJmb2d/3u7EkpqRr2yOtyNNyB32XT0edkjKTfZSqFyg+WHU4vjQ6ozHiwSah2p7uoxfVOZ5oJ8G0i8vOyjiyQg/a3s2mPOxzhsxMBZVuUnmNuBx8Mdvgy7bsD1ZdyhbTBYC8zc4jpz/lP29LAsZJhHXILxVWe001cfZCFDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MfIe4L82; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IdRAsWbb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MfIe4L82";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IdRAsWbb"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698BK1S53846986
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 13:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	J03fkmpeEz5ye7BuQP2h4h49EgLI3UnhSBSUqTVuQxg=; b=MfIe4L82uxjCUQaF
	8EUjNOFYVhu7RAZ4JhOwBGjkHX3rjrlheabaN7m/cnpeI2/6acpQoj2myhAl+8Nq
	hcrlrx0lGgXu6Z6FZbePDVJrmV1j9IHUqu4GZOcU0zwDoMSZf7HjbHDvpBn7z4Kr
	iU8hifPbtvg0d9jBEj7iFq3T7eNBH2zAn8NSIPGdrrpYPbXvmUIQJeOwY/JHogfC
	F7iA4duxX8mPwXh8zFEe8BT+v3AmuwZMILFblnZersNzLqEOfs62l9i2Zil0NGJ1
	i0n89+lJRMd2QH/DJSGViToFWuIN1bqyRxWiZ7qKfsGii3HRk37vIvcxfjo3xcdM
	lhOvFw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h60sgakdk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 13:16:25 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cc5f70c8dso599408285a.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 06:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791465384; x=1792070184; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J03fkmpeEz5ye7BuQP2h4h49EgLI3UnhSBSUqTVuQxg=;
        b=IdRAsWbbS5qOEijxtHT+D3vvA7lx8sgkIXkFB44S6UjsHOs/K1TKVx4KqQV0zbbslA
         WG+Hjylz0TmbrP7H0Bkv8XtHSs6/HCaqdn2j11HRFv+9CHKvRPdsNoLyl0NfH3gv0L6f
         6N2yloJ2zbvuZ3E9bsRsQB1OPWu4oO6xgyK59wEmO6nmqdrEannJiz05BERRGJw7kGEF
         hZmez9tBLGLqflx0b9t78Wn0xbgqvE6TZ3j5mmNSR1pJMHFPs+0kWl+AnuvjQmG2aCSw
         Phi9FmZMcU/iCe3lsEvVZ1sObLtJT0xgF5zbAK0c0+2vEv1yW041ud4BK53pDe/grafp
         AFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791465384; x=1792070184;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J03fkmpeEz5ye7BuQP2h4h49EgLI3UnhSBSUqTVuQxg=;
        b=WHQzRF/EUI45DsjsPUCJza2Ow+zC8R2qJQOwsgdRjhzPCD3eEct+el05pk9C3bileG
         gksRVDGhfR8xSNEoVBC6AELI4jH9yIFjfXEr0wd6cpO7zE0Jb8Q9Y4Fc8hRQ6kw+LqEn
         +pSLM/FHen1QNLfJ3L532W+x/2To+KQfunem8/tSW7hD2jkCHQVMVURGuQmmNbjZC76s
         7ugLkoB0S4HUk0Y35KYYKnS8v9duUGDLMa2hfbv2+iNMbK87s1lnsZU8LQ5YlpVet49/
         E+qkNCtcG/Mea8kTj3Qsfhpw2OlP90hPKeEFP7W231lrkyy62lUBU8Y6416hquGOltby
         N/fQ==
X-Forwarded-Encrypted: i=1; AKwUvBxRLEPPhMTPQ+217o54y7+HefO1vl6ckfFHgD82/nLnPlSvdwmpkdM3Lm6SCVvwLgFGSR0xaZ2qJp8zrR2HRg==@vger.kernel.org
X-Gm-Message-State: AFuF++nmmLcTqli6jupU/5lIbMBc4p2vDvLpMv2rnLn3sAuBh/jsxAQc
	I7fz/iiMxzcB5gayTWT6YWzWa59mp2oc4Ttm8UiATZan+aEP0M01QAFPol1LvQX314A0Zki1crc
	baQOrBuKYpTrKNUAbkqcmAb+Gi7EXF5EaOTDDkvruHtVWeLbtEkk5ywqu+DgHfAJoLWmyBUZPaF
	rlVA==
X-Gm-Gg: AYBFou3a7dp2CuN2qtxp91l75ZY+TEIJGKhUVZxI0kOWtKYJXZxazV72r6hZuaa6pWm
	XJf8d8kHSVkIGjQQr84qe3bMKgxDdSvghb8+99HvHYgxNUbXwGsiaIyDx/v997E0MNdZwJzGm2B
	FkI535EDh0INJzd2/fY66w56mQ7KOtJ8iMcCuxPhnwXNyCnhsp8pZnFTxiRlH9Ty1iK/+DIp2KH
	3HSzMLYuvtca+/9ew1QZBmS7FR2N86F3zPjMqjTfddYJkgtoV//lO6KtUfbWuNvoJa5GBUCwkxx
	4/AXEFBpYx5Lc3lOAdrvy06UNvWiliH+7npe2XSlynnRF9i4Oi3EW+nKe00/n81qzfEBmoCxZE/
	DmiaSdufKDNBQAw==
X-Received: by 2002:a05:620a:254f:b0:93c:b7f3:9f5b with SMTP id af79cd13be357-93e9b78abdfmr1087522685a.45.1791465384352;
        Thu, 08 Oct 2026 06:16:24 -0700 (PDT)
X-Received: by 2002:a05:620a:254f:b0:93c:b7f3:9f5b with SMTP id af79cd13be357-93e9b78abdfmr1087510285a.45.1791465383581;
        Thu, 08 Oct 2026 06:16:23 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843cb261sm72311075e9.3.2026.10.08.06.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:16:21 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:15:58 +0200
Subject: [PATCH 1/3] wifi: ath12k: fix datapath lookup in
 ath12k_wifi7_dp_rx_process_err()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-ath12k-pp-v1-1-68f888cd7eec@oss.qualcomm.com>
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
In-Reply-To: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        P Praneesh <quic_ppranees@quicinc.com>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: lT1yhmwbtC9TVfpBJzTCkjPtceSCMBqN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX/QmukHy3HHjb
 E6eKNTCuF73b7y9u/T6gjdo7VPlKF38heajfQ3hLZ+SgMBSjxrlBWsYWlKhCUG/G08doTZE20zO
 r6gQMGsDR0uGafQRQQZKxjWWrSQfsOo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA1MiBTYWx0ZWRfX4yg7RSu6oPeU
 w2yMiL27LVSkYRUSXhnd9vMRhgkLPjaUDAcJa/ORxRX7ggR54aEJiN+BpiugwmCsofnhVHUbufa
 5lRJza/dNj1aeNTBHiPy9LmnxazBji/stl7HExnE6dU2cp43sb7yJQcM7gXCK/jGImYn17WgrVq
 XQrXfRMBPeESz2c2+/FfimMKaUv/OOY2fkZfnMZd9nqBGOJ1+uD67vSpD4f5mXXRYkExbDiWuYm
 ZY6lLRV4QZnSetKLVG7smQTyqraYJE6fj2ef77lEXnLh9CIStrytp4dpgktd545ApvI14OtVtAm
 In337zte3lIAU0cLHJefLm53im8hzyUS+VH1AG34JYiSzeqF98818yconVGJSZxfWFUVINdgusE
 Mk6LcQuxZ2Pt4bfVLH6auL69psfUiZMPs+1ZHmXKsaZjs08Qk6E1pUSE+AMsoGURJj2oMDdOvaI
 EpLucHX16xbKLxMHpfQ==
X-Authority-Analysis: v=2.4 cv=DfWCOftW c=1 sm=1 tr=0 ts=6ac797a9 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=BLTNKAuSIvEH_jb1uykA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: lT1yhmwbtC9TVfpBJzTCkjPtceSCMBqN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080052

ath12k_wifi7_dp_rx_process_err() resolves the per-pdev datapath with
ath12k_dp_to_pdev_dp(dp, pdev_idx), using the local 'dp', while
'pdev_idx' is computed from the owning 'partner_dp'. As dp_pdevs[] is
indexed per ath12k_dp, this picks the wrong pdev when the REO exception
descriptor was sourced by a partner device in a multi-device group.

The error is currently masked by the drop condition that only processes
same-device fragments (partner_dp->device_id == dp->device_id), but it
is still incorrect and would misbehave as soon as that restriction is
relaxed.

Look the pdev datapath up from partner_dp, as already done in the other
Rx processing paths.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Fixes: 9e0ee04f818f ("wifi: ath12k: Refactor data path pdev struct")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a32c804403e8..633cb91b9e5d 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -1536,7 +1536,7 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
 
 		rcu_read_lock();
 
-		dp_pdev = ath12k_dp_to_pdev_dp(dp, pdev_idx);
+		dp_pdev = ath12k_dp_to_pdev_dp(partner_dp, pdev_idx);
 		if (!dp_pdev) {
 			rcu_read_unlock();
 			continue;

-- 
2.56.0

