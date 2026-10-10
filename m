Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64D12877E8
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 01:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791595894; cv=none; b=PUC1zHIeQYk3B18V7ipxd3QhR7WFOtfQ1tpg0X2wPKlAsNMfe3umdUp/swsDFYdEftftrXxuPJf7ovBoe2HyKE9y/FCS+BtkwZ61TlXg65+vJttE+AdZ+bhAmMlufI0Vl1hzyuKejI2ZOVydJKget6nihp1E+dC1suKwDZdwX7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791595894; c=relaxed/simple;
	bh=9Oj3OO0PoA8FvwZ8xVp9kH5Qf5qqRHi54PdwaQelYms=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EyitNrc1vHlk0Qk6rmhMAFd2PnDc1+w0sJkBK6lYBA374dA8j+xR6y7GZ5eJYm6GFF4uOEqghbZwZUUeqdfwMPI/w65PQEThGCgDzNHfHrwUMAsv6v1s6vpSWjRZCdbcKiRTTtJZD+lNn0Xt0+uHDZjR6JwoUeGk7n68wiAhmdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AQAxz723; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CqzknxU/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AQAxz723";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CqzknxU/"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69A0KG883154903
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 01:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nhKP/nvNUspfn8Zy7OHsWTm/Pieq02Mp5rrslHg/DSs=; b=AQAxz7236qI1puhx
	L7I2zsr1Rl88YB2Lh9nbUF5lStsmJfKBibLUQ83vH2/Dp/jK815yh4CO5kDzrGvI
	PTvtejdMWSX/Ik0cwON9Lmz03h0Qm0t/5GZVcTlh2UDYy035pjMHMol1EUj3+IRu
	um+JG5K3BOJKNgeZ507vSgEHlzVmHFik0UptH1sjM3/uhFVnyhEGZkSDJJRSmYgy
	5Y+Rl/8C1TFux+EoaePJl07OLTznBFxUvvBOdqAmi9Xsx2kuqsw+piVnAx9vVa/+
	FiG287qPDQtyR3qUT0GIUWiZRc2W9Fmgd3XGL0QNHjp8K+exZHAjKA5ZYe+qHIjI
	IIBk+A==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7aqmr55f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 01:31:32 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3552883bd19so1112995eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 18:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791595891; x=1792200691; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nhKP/nvNUspfn8Zy7OHsWTm/Pieq02Mp5rrslHg/DSs=;
        b=CqzknxU/wPKUq2CvBOoox1ExQq1J3/TSINCq+OAORScOuFP9xxAsVZjR+lEladumbH
         rDgBl5BYdio7EDVX2Ry5CZNUapbvfsakz0j6EjBaLHhML0n0CDRaaICPHAXzAbSxmzWT
         bzDRjgY6upQTUw8HSR3MLLte+b5K86dLHr09kS+qylwMSNmV2sYy7gn5hT62Sn7N5j8G
         tDtUYaiBjS8QVhL0SjO4HqhhRJrfBdL22cr8meMGU6mkQpMMz0aY9bWEQu0+j99oAcyc
         3Hh4tWWIDw6JpLOgiq9GJwB9HixytNb3OSuJqcPNpncEnxyRGreRqq4mwJ1KkQ+21/fI
         7h3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791595891; x=1792200691;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nhKP/nvNUspfn8Zy7OHsWTm/Pieq02Mp5rrslHg/DSs=;
        b=ATERv9m22G0rRsHeW3ffusrTBDqMxOV4sOws+SZjqPwAWOwEgfPx+lbgHnjDHb35DQ
         0ZBxLkalMBDQ7ML/668PQafFl9NPQbuwQO42l7f82lUDflzoyAJX9gye5SzYzKnX442s
         MPKxclAjGFsvM2BLBETQk1B453o0u0eHOVSQtO92AHTzty1xZRI4v10yC2aG4ELAtzDi
         IutyOvrp79kLreraouYu5GBH6ixno1ZVzZQJWt4SbPDQo9WC6l+Lxlgo9TlBt6fZB639
         CYVEzNC/eSqxvu6MqnWPmioKa2wpd7mbs6L4eJqbyQrfEex2uEZRoiyfjAKC0avJLFUx
         Ryaw==
X-Forwarded-Encrypted: i=1; AKwUvBy/R1bosqWnRCB0fP7aHs5kaYuVV9brtPZdEWA3EcgN4PLDhds2WoXsLZ7zDcGIUMW+cY227FaM43OIRcSdvQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI45AqO2i4QYlwQQQwLvIp7q5USYAYz56L0czI/YEO1kd+J9rug
	Fss/QXeT+Vy9YvbCHwrhHwgDDzgxc73smW4gMLD5luzHuAaWBwtmpuM3Qy+xsL+ZlwAtKKyrqxA
	DyjYASCni2va7cyAxfdA840F9mlS2UINgKNLXt5PRHKjVJoDO+ZhSz17oBD3jQh5aOy6LLQ==
X-Gm-Gg: AYBFou22VRPPd7VcjVRxJNOKbnVC2HegWWtIKJmB86JiSJ/ejhHPX2zBKs5nDokOvkS
	OlJDMI+MgjfEVEGJ//58x++TPooE7+kRIn/sYE0mTKU5CexhnggumKNDeudkzeYoMg4HFQVHUz/
	QvW76b2UskCcwDD/ZW2c9/yMEHKe2KCJEq/T+XR/n88wYUMzGuhk1W1vMzBLuYqSVk6XG3ZR/Ef
	1hNaLVa4DQ776JjxoZWtprDQSMytgH5qm9aQEf2GOYmH32s1TPKZeaP3IIHWhLnIwbnFmxi0ZJn
	g4zypuPlhbRYvNnthQJlichaP6dizPq2GRCTDHOeFjuh6hKc1HAwbRb8ttpMiw4N6oTEAB36I0y
	89fHKO2oCfNW4MQrnULIt6+vTrXc6mpm2O3ApKzZqbytg9cZG1vXG/9Uljw==
X-Received: by 2002:a05:693c:87c4:10b0:356:4b46:9393 with SMTP id 5a478bee46e88-3564b46940amr2348008eec.24.1791595891210;
        Fri, 09 Oct 2026 18:31:31 -0700 (PDT)
X-Received: by 2002:a05:693c:87c4:10b0:356:4b46:9393 with SMTP id 5a478bee46e88-3564b46940amr2347977eec.24.1791595890583;
        Fri, 09 Oct 2026 18:31:30 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-353814b556esm9483336eec.18.2026.10.09.18.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 18:31:30 -0700 (PDT)
Message-ID: <2e271ffa-99b7-4c1f-9d17-96242a51d22b@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 18:31:28 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] wifi: ath10k: avoid IDR mutation during TX cleanup
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo
 <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20261003092104.520135-1-yaojiale02@163.com>
 <20261003092104.520135-2-yaojiale02@163.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261003092104.520135-2-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEwMDAwNSBTYWx0ZWRfXxeZwhqE1o0YW
 uScNEMPsrFxIcUD22bUZdE2Ov3XtMqx6VPuNwxxVH5JEk3rvPxWSyo0CwbJV54QF/KHsFHfnmjr
 TiBlXtB2+oHGnzqcKyUN8dhDVgLTkT8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEwMDAwNSBTYWx0ZWRfX0PM1qh/x04/5
 XFKpx/80gNBB1fhA58kd6KMGJ3VzP9O+Hmn8Z7rIjPPdU53AEhAedxuu6oGcwllu6uAuTkVjT+L
 yTsa3yN4V+hnsh9fvHwBx3IfX89nF2aGg3I1wz7ZrXimBMz5ZZ7txprijbBSfX6yZoRk6bUqhGW
 Eo/IOicsE6vJfJ0mMG6kBRco0+LVbacoufBmmT/222tQupTpThdVvrj20ZmAwCZ8jCmllCbeXwk
 T4Db1ok4PFPY8WJszG3fyr1o3TcIAYhhjZCMNuG2OY3dzEv0gzuY9VPkJAY0XC71nuDjR35+EcQ
 h/jBDpDy3JpQuzmJznmnAVbjWrsvaUtr/Ik3fOuIbc1+zJWaBvDFtjADmipv6i97LGugfK80LLk
 9JkCCfqwT22qzcZDGd+ZHF5BQ73VfLpDxE0PI8Du8VYFdJ7VjskZaUcYx6cHc8encEJMiHCL1tJ
 Pg+GqVv/ObkjzD05jbA==
X-Authority-Analysis: v=2.4 cv=Uq32pOwB c=1 sm=1 tr=0 ts=6ac99574 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=Byx-y9mGAAAA:8 a=vxfaGprF530-xfLAvAgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: qc0eKLxaW9-mGxiGhRdQ7oXfoIztH_7Q
X-Proofpoint-GUID: qc0eKLxaW9-mGxiGhRdQ7oXfoIztH_7Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_07,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610100005

On 10/3/2026 2:20 AM, Jiale Yao wrote:
> ath10k_htt_flush_tx_queue() walks pending_tx with idr_for_each().
> Its callback calls ath10k_txrx_tx_unref(), which removes the current
> entry from pending_tx through ath10k_htt_tx_free_msdu_id().
> 
> idr_for_each() keeps radix-tree iterator state across the callback.
> Removing the current entry can therefore invalidate that state and
> make the remaining walk unsafe.
> 
> Use idr_for_each_entry(), which starts a fresh lookup after each
> callback.  The current entry can then be removed safely, while the
> following idr_destroy() continues to release the IDR itself.
> 
> Fixes: 89d6d83565e9 ("ath10k: use idr api for msdu_ids")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_tx.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index e46f579d745d..9993c5a2f96c 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -535,8 +535,13 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
>  
>  static void ath10k_htt_flush_tx_queue(struct ath10k_htt *htt)
>  {
> +	struct sk_buff *msdu;
> +	int msdu_id;
> +
>  	ath10k_htc_stop_hl(htt->ar);
> -	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
> +
> +	idr_for_each_entry(&htt->pending_tx, msdu, msdu_id)
> +		ath10k_htt_tx_clean_up_pending(msdu_id, msdu, htt->ar);

my review agent notes:
**Actionable issue:** `ath10k_htt_tx_clean_up_pending` retains its old
`idr_for_each`-callback signature even though it's now called directly:

```c
static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
```

The `skb` parameter is completely unused inside the function — it's not
read anywhere. Since this is a `static` function no longer used as a
callback, the signature should be cleaned up in the same patch:

- Remove the unused `void *skb` parameter
- Change `void *ctx` to `struct ath10k *ar`
- Make the return type `void` (the `return 0` is vestigial)

As-is, the call site `ath10k_htt_tx_clean_up_pending(msdu_id, msdu, htt->ar)`
passes `msdu` as a `void *` that the callee silently discards — confusing
for future readers.

>  }
>  
>  void ath10k_htt_tx_stop(struct ath10k_htt *htt)

