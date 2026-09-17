Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D0034750F
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 03:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789614491; cv=none; b=jlXeQN5TKJEWZ+BfOaGao/ogGEWw5jx0zGqo4z4oI27Zc+adCk9vk6PtT274vgCAqt4wn8KlzNm2qeMyAekVPtFpxOOtv9bRFBTh6HHXNLA+etL8kxG0gmhIYjRA5XMezlBGfchFnUIdNHNBgNPasI3GxI+uqNjLTdL451dpqy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789614491; c=relaxed/simple;
	bh=BFWJBTnLF1aE8X+tLyBABld1kYZc7ehMNU4s+4XJNu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lHHk3mZRFBBCHWrnuv8yZiNZkV/VtPHXxGUk0NGg1eU/adyvBx5oYL3d39D9/BcXa/fh0K1//V+6PuRbfXQxCBumCsZngHh2tqTlobANBB44Zd9Xs/61mq3dL1LjsTVytB5IVIcaM8heVREw+4FafL3g1g8O9rVaZnBKfzIWUkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XGUyAhsi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AhYRd0NT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XGUyAhsi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AhYRd0NT"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2sh7C3302568
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 03:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/2v5Ij2HkXLd7w5QHHLHFy8fu/Zau4E+h+giE13eitE=; b=XGUyAhsiSSf4ibJL
	HJ8s5IV447hEWu3UaG/napa2e7oeGY2/hn73H06enD1j6ojitvTEhejF2dW++lIj
	GxIiwVm07MLDhvwm45r1LAu0Fu5DP5BRIS4kwMSYEagMHrLLxZH7kELO6PqO70Ug
	gBCz4hCSi8f1YWLAXDKBYWrzF0pTLev9GCaocAu9TH14CT/+PlDIH92MXeaLm7N1
	ePVHzWCMN6vilRGoYrcPUT1RS5x52BfshIRNxNMVcMAMq9I4CKpd1WnqNjNRTPVx
	1tpjoQQwPUw63P932dObFXjSxKqybcBVBMrwIkOUnqW2G3kUysRL28EVG5H8NqC1
	2W5jVQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gr7uc81bs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 03:07:54 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso465514a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 20:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789614474; x=1790219274; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/2v5Ij2HkXLd7w5QHHLHFy8fu/Zau4E+h+giE13eitE=;
        b=AhYRd0NTIH7oyVPBFXTkSA7EGe9O9QL9kopnn1H9vFbsFCxRTpulraWKNvsqF2dj71
         t5e0/gh9mTNzldCkOOY1pzbD5cWjzkge+WxLCmpPui/TfLp/FJhcApMrq8K2GTgtvu9H
         zxFUbgQTpSz83EOteY56qS3nV7Yoe9oavDc02KOWSd3Ccagu1bbP1GOpCWLVcJx2Fwpm
         1jtIlUIKM2Ub4zzZ6xraRpqEVoEEXu9gy7DTUIUwn+mPkioNK/a9JYVEj1/hMCPZH6O/
         O1kt+Lxi3VTlnNwIUsOJQ/5HNBAr7aM3oUTwVBb3K9/t6kr8lb3HloVq/rC8DpEzB/G8
         C0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789614474; x=1790219274;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/2v5Ij2HkXLd7w5QHHLHFy8fu/Zau4E+h+giE13eitE=;
        b=H9mLyX1YjOLeYInHUsBKSbKrQm0EU7Bvpp8pAdokswvKinIJPpHBWiiqZo8QvAxQL7
         cqFqsfU5sm50ZsRyt2VCR//pf9QIo+U5nCQXa8ZFrrI2SDZ0GMdjnJCZawwEFT+lfSHm
         6Y5C6UspuKE0cL/XXZdWwVXR+7Z/lJ5R9JJ0lM7lHYRGpDUWbPx7pTBr1ZlqMVP8bTdK
         /rxkJLY/rTX4lP92YI0R5zDU8GgjWdluBPeqFdS7xVLCBuV5jlaS4ACCPI/4ZrYxDuhW
         lb93mMwmOSwVSNYtsYkV4f7yW8VbQGkVgdyf8lp+ItbB/auo1EnIs0wlrcMGEXScxUfu
         pq5A==
X-Forwarded-Encrypted: i=1; AKwUvBzdNz0EFUQkzrFESdiDCLYyjYjikEM7OhzVtG5qpp5+CtxU8bSpR2rKwAp7kG5963aaVPGKH/JyTfxG9Uq6Fg==@vger.kernel.org
X-Gm-Message-State: AFuF++n4kjQkCdYbRuUIb1U0qJ7A5K6MNCQC+XHNyn9bBOJ3VaVSM3G7
	bSU4yN3quqs8vajhC/Bpai2ZbkyNsfg1y5fvlzaFEbD57/0pvL53E8cqHCLeNQsJZzuf9k21g1b
	28U3ym6cNzzutPGyVphgWi1m/q0urGiGh1pmmNXcJzXVsWxAikz1/AsKRDtAXZGHtet6fOA==
X-Gm-Gg: AYBFou3UyvFzW87ExgJtA4SHmUab+muIDHbtNWdOHAKw4V00C3iQBOKSaxSmXUb/fyn
	KhVFMFun/Vqe+8HBtHX8FHgT6XrjY06Eo19bQZyyqD4Vv+Qae6rqGcnO4+GeP+l6gFWOTfkISGF
	GWtBHiwEi9oMmKsOLMujXeVI+V0+Ydk8SUroYdNsII6bVMrcUM8uL7LByENNYsBsbmAqeBMeJXa
	VsjCpNIerKVl5yYcOHh+hOgPx78DFyPp2KQ8qxQ6Df0JEthmYuubNtGycuckIDdspSAGsSZkLoz
	LR15pAyxjgYqatovJsGQvQEiysCadQ3GPfTdM0MNTO24nGVM3ajhdQlMUE6REtRzQzrogqzXJyP
	sVc0hpaHlcRpNMgi8/DBGaJoh2tqldDOOoYPuk8aZM0vgeG6zjRDHrX4+E0gZdF1MlgLMmwXh
X-Received: by 2002:a05:6a20:4311:b0:3cc:f008:8123 with SMTP id adf61e73a8af0-3dd5f448831mr11834377637.8.1789614474154;
        Wed, 16 Sep 2026 20:07:54 -0700 (PDT)
X-Received: by 2002:a05:6a20:4311:b0:3cc:f008:8123 with SMTP id adf61e73a8af0-3dd5f448831mr11834312637.8.1789614473570;
        Wed, 16 Sep 2026 20:07:53 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50abae95csm2452404a12.25.2026.09.16.20.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 20:07:53 -0700 (PDT)
Message-ID: <670a6d6d-2d95-41b2-b64a-997a39d4f320@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 11:07:51 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: fix chain-mask shift on 64-bit big-endian
To: Michael Pfeifroth <micpf@westermo.com>,
        Jeff Johnson
 <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <aqqoAVbsVu574FwT@mpf-ESPRIMO-P9012>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <aqqoAVbsVu574FwT@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDAzOCBTYWx0ZWRfXzsd/EMok0Q47
 ZlMlb2lqkZ/gAnCQA6tFAsIUZ39OVd/i6IUxSqabRfTymaj1Q7MzgrVuhUh+VhlITlOzA4qCqsj
 FUk6lUjm7ie19+zA64Fybnc2O5ipc8Z9eaK0t/vUHITLaGfDDxsSQh/D0wR825kZ0l4ddfguwHW
 WCBE6fi3ODnPyU/OB5gErJEz9NCpt3+TrbA876kcOX9tblGu1sgSHHDnJ6fgrE7nEXz3lSJ+jnB
 CGlVy1kIhdrF2DHWZxM6pL5ZQ8qeXIqLMsO3HaIGFk0TeXSMJzp9+WpmPm71s/9fj1Gp8NsK2wb
 MBjLY97FDt0izGbjNAGo7i4uwTECzieyAOm+P+i+Kf7KULgL9EUvH6sQSIOVGRDih9+QZ9bcNXa
 QQjAeuvGzvhSXnUlLYpNYsIdKwrdl4EIA+GC/jU6H7nH5DlLUCxuSYTzW0Ncn3OhZ0I/LtcB+0G
 L3z/eMNZwTkTJk/AmJA==
X-Proofpoint-GUID: ued90zcDIs4O2xthyUu8J24JSIlWaxPs
X-Proofpoint-ORIG-GUID: ued90zcDIs4O2xthyUu8J24JSIlWaxPs
X-Authority-Analysis: v=2.4 cv=F9zC5ahN c=1 sm=1 tr=0 ts=6aab598a cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=EUspDBNiAAAA:8 a=81S0BUt_Dk-okXjJcTQA:9
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDAzOCBTYWx0ZWRfX9QE5V8U43Axj
 p5drJvm4+XGTyPLO00AwcxKbtxwPsP6tPI7XEDx8/Ju2pmz5/gWj25KazRCSIfl9IaOQPtow2DW
 MjxOs2xLlVtIjelK93uC6ks+uXhP4U8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170038



On 9/16/2026 10:30 PM, Michael Pfeifroth wrote:
> ath12k_pull_mac_phy_cap_svc_ready_ext() derives the tx/rx chain-mask shift
> with find_first_bit((unsigned long *)&pdev_cap->rx_chain_mask, 32).
> 
> pdev_cap->{tx,rx}_chain_mask are u32, but find_first_bit() treats the
> pointer as an array of unsigned long. On 64-bit big-endian, unsigned long
> is 8 bytes, so the u32 value ends up in the high 32 bits of the word while
> find_first_bit(..., 32) only scans the low 32 bits, i.e. the adjacent
> struct member. rx_chain_mask_shift is therefore computed as 32,
> ath12k_mac_setup_ht_vht_cap() evaluates cfg_rx_chainmask >> 32 == 0, and
> the driver advertises a VHT RX-MCS map with all streams "not supported".
> mac80211 then rejects the VHT capability ("Ignoring VHT IE ... due to
> invalid rx_mcs_map"), so the link only comes up as HT40 and never
> negotiates 80/160 MHz. tx_chain_mask_shift happens to scan a zero word and
> stays 0, so only the RX side is affected.
> 
> Use __ffs() on the mask value instead of pointing find_first_bit() at the
> u32's storage. __ffs() takes its argument by value, so the shift is
> computed correctly regardless of word size or endianness. The chain masks
> are always non-zero here, so __ffs() is well defined.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Pfeifroth <micpf@westermo.com>

ath11k has the same issue, interested to fix it as well?

anyway:

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>


