Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E3825E469
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 02:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786932924; cv=none; b=XuP0BfCL2+5/jn8b6VvwxPrAtOKKbjyqP4H7klqDIrKCtq8gOrU+OhrorkemzlMtnkFnXaOBh+I5IHHtZKd7WIae5UeIhpI7WJSlsHnr8xi78kti7yKg5Xpwgn/BX4fjNdjahAcv9HrAIozCBcYuiSgY5zBUYuRmPII15c1dZhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786932924; c=relaxed/simple;
	bh=QTsv3bLEDu7fxShMr6FsFe5toFVid0KDTSPNFkvfuDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VEVW0zgNGqN3cz/szNLQDA9BNCD3ojLq+uViFSFx/A9LvM7FnjnubHMYsFmRhlJNz8xETQ4rCyDv8QXXOjOWAj9qzJg8gbaOzm0AhKAs0GI3sH/YiXdX13b88B7jQC/gHT/KJxYhwI9yCQkD6msRJXqUiZAkMVmc8R9X7bqwsls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HbP/v6/Q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J2tO1/2V; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HbP/v6/Q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J2tO1/2V"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLDQkU4059911
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 02:15:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QHSyTy7+lPt7jM9CyTGB+K/hqE93UVBEgfoJwKdc0GE=; b=HbP/v6/Qsng61Ycb
	W4E+U53Bz8Bg06MKtXezb4OwLOVOLi74eqijtmyGQyxLSuessgF0szzUewdO1jW2
	l1SDOsqOey0+6/4xK0wjj56JcTD30Aj3ZkxJs508aWtrsxYhmpv9w5p4bj8dEhQ0
	H5XSUE26MnnzDIkyGbOgP4U2LU/zkHPk5E1AsXCk5Ma4//qow0FUQrcRQI77wguW
	j5OTaAK2UzJagR1M8tO6GAmElWRrNY39mYS4zMnizf2KsH639GBea5EsNT9nl+Zl
	NugdhQg6Ipa1+MWPRdHyLLv+WY6qw03WCLdt21t3Nh8NKKNRAWPIMi69i9GnsXlF
	54MmIg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g2hd7vnsv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 02:15:22 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso2569725a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 19:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786932921; x=1787537721; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QHSyTy7+lPt7jM9CyTGB+K/hqE93UVBEgfoJwKdc0GE=;
        b=J2tO1/2VodKbE9xYcDop3tqbl2SxLCIGswywwX0wxAFNeeVmREdXR1ahS1zG8Wx7Er
         ViKr878lKQ9fFpKvic3wzvhsh5/3k7Rv4bi69ykiwL6B+gCvR3WGa8LsYIXkDmbF9rqO
         035/mt//UHcc7Vf3kZBj7SVqnA5fWMeGwSS0W29+iIzIJMJ8Ln7NcyuAEY0jrAGxdIiq
         GG9QR7nVHR1jB7S3kQNIOO5qIRV8MU6FJ02dWIfjAXGhjtS87DxHH+VHUDy4/VxhJgdO
         RIjGw8rBmri/f+/AQpCXNTmERkAk+8HKjdhMOoVjgqCK471UwArDta1CUXoFxBiC665v
         ak7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786932921; x=1787537721;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QHSyTy7+lPt7jM9CyTGB+K/hqE93UVBEgfoJwKdc0GE=;
        b=oxBGyoDg2r2+C7ls7ZSHeMycCRuaqTSMufzWgJYmSTSNYYqvQz2AS4s/6Ke7zsWT5C
         S8crACiq3hFXyq96nUr3aut7T48b4OXW0Mi/3H0qM4wx6GEyF/Dg8QkASz8YXDTj54Iz
         LkEqgeXtC8xxQxm+fILTY4mEu0CB5ML03ytqhkOOWfXI2ftCQrIolf6w71Pm146FtO2n
         lE2ygBZBzkw4vFp72x88xZGa48eOD/qwiibCAP2Ubx/cWhridR4UOSP4A+0X3wkx2vkN
         oamaMhwQJhSOY6f9ohGTuncBOs5TvkqBMK/lsPQyM7u2WPy1vsaxINzEV9tvNPgV91Qq
         njgg==
X-Gm-Message-State: AOJu0Yx/mKlAXIHqc+tYD0FlgiH/sVFcjaDOkzVKH4tyKwpnJd55WIuc
	V9yZzJiFFKI8ihIcxidfUb0a4B8KPF0Ex7VzI+ROgtnErXvy7MwBoAv7KceKjiudbas2/riAkDk
	w01An82mVkET/0ViSXHu+q6YZQZzq7FJGLqqB4bDfntLBZ33ZCAtVVS59LTw7KMS+Rx97Ag==
X-Gm-Gg: AR+sD12WwwuQ+9g4V1Co9ZdGBMgKTxwKEGDUWU8A7bpMsYUiuPUp07iLGtfTnRPtwmr
	u1F0i8YJj+YZ6+2uyubxRqr/+J5/No459htDEx8jYlgsI9mGLTwxFAFmxuYU8aXN0gye0j56cpi
	ocnoKImHKFiMfNqRbrAP6CnOiYsvJnDC5bJPLqwwVyZ0Wc8eG+t7VDRJ9/x7Hfh0CeuSH3VKKWZ
	ZCqAYOxnHnwF432Pkwt296BbG/sJarb7CFHWomm9hyzZJ2/h0kDdQ6y48Sbs6hsy4CXLqR/bK3y
	WuP17KiPsDETZAt373gSakUeezPPoq+fE+Q7SMQyEGNJxW5HZJW+KyU1+0l/sBguopZ4YL9Qllh
	p2mg0y+7HEFaTVUBK4dkHzzj844oMC4g0PBONBlS0cGiIEGjqX6mphJ9EsNLCvfCJb5OX6ycRbg
	==
X-Received: by 2002:a17:90b:4a8c:b0:381:bc4c:da56 with SMTP id 98e67ed59e1d1-3933b95158dmr20932986a91.19.1786932921437;
        Sun, 16 Aug 2026 19:15:21 -0700 (PDT)
X-Received: by 2002:a17:90b:4a8c:b0:381:bc4c:da56 with SMTP id 98e67ed59e1d1-3933b95158dmr20932952a91.19.1786932920895;
        Sun, 16 Aug 2026 19:15:20 -0700 (PDT)
Received: from [10.133.33.152] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e3184bsm2961046a91.1.2026.08.16.19.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 19:15:20 -0700 (PDT)
Message-ID: <1366848e-ed50-4584-a056-054459b75bed@oss.qualcomm.com>
Date: Mon, 17 Aug 2026 10:15:17 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: fix locking problem in
 ath11k_dp_rx_tid_del_func()
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDAxNSBTYWx0ZWRfX69de+00HgYWV
 hWk7xpI/8B404dNhOP2nfT/i3Lia7ME+XnFVfV4oX9MDNr9DqFkq5fOWZSYA56MufkDsw2SdWK+
 UfDY1Eh8ZZWFhLXew8CTYOi+uLgCmrqGU+Xu2MM4y6O0+X6YKGLUbrhfOvzSaYdhdT6frrpXZKR
 SElqdL2cszgUWTI8dZrFLKrnsRieFerWBxeGAQWp4exTeTytvDfKN2X7Ad1bcPlQtSz4O3RfW02
 7DA5BLaiBgqF4QVIG8vGjhVM0wOPy6lswYIWDJUCBDoofD9p/0/QhKHZNfqSmyz+k6zj91q0t0P
 MR7ELhoBL4RPGbjmf+Cb+SGDBu1nYIlShmet9S5fqdk7Du4lCNWpi0AtAds02I1e7XZMr7O+nmm
 3atd5ruyWOXKt5UvrpDKy5U2gpVaIoSDhSNWXgA9XcTgxqhFRZGJAh/3ncEaTz/okgApKhKw9mc
 MRsaAA7UpoidJfcO1jw==
X-Proofpoint-GUID: wI2OA8Sv2WAiAm-6rj3USd3QBTGfRrhH
X-Authority-Analysis: v=2.4 cv=Ja2Ma0KV c=1 sm=1 tr=0 ts=6a826eba cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=27b5MfB6VpTch7MquCMA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: wI2OA8Sv2WAiAm-6rj3USd3QBTGfRrhH
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDAxNSBTYWx0ZWRfXyqQizUdYNVJP
 C5YwPnc1bzTbllOri/VAYBtjSbYLjUfyk9Y4qGpP6gbsE+e88QR0Bcp+CpVvhnS8DMkOJsm69Oz
 sYtwAXPO3x79WS1ZMaU0gKOVkGT2Ok8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170015



On 8/13/2026 8:15 PM, Nicolas Escande wrote:
> In this function, we iterate over dp->reo_cmd_cache_flush_list using
> list_for_each_entry_safe(), under dp->reo_cmd_lock for concurrent access,
> and for each expired entries we :
>   - drop the lock
>   - call ath11k_dp_reo_cache_flush()
>   - kfree() the entry
>   - retake the lock to keep on iterating
> 
> list_for_each_entry_safe() protects us from deleting the entry during
> iteration but doesn't protect for concurrent access. So another thread can
> take the lock and modify the list in between and crash like below.
> 
> To fix the issue, move all entries that needs to be freed to a local list
> while under the lock and then iterate over the list to free the entries
> without holding the lock.
> 
> 	BUG: Unable to handle kernel paging request at virtual address 00000010ddbeef8c
> 	Call trace:
> 	ath11k_dp_rx_tid_del_func+0x164/0x3c8
> 	ath11k_dp_process_reo_status+0x1d4/0x2fc
> 	ath11k_dp_service_srng+0x334/0x338
> 	ath11k_pcic_ext_grp_napi_poll+0x30/0xc0
> 	__napi_poll+0x34/0x184
> 	napi_threaded_poll+0xb4/0x1d8
> 	kthread+0xdc/0xe0
> 	ret_from_fork+0x10/0x20
> 
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
