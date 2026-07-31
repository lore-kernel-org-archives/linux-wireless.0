Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93053403E3
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785480558; cv=none; b=lx5lhbHm6vo3LHsOuGBsvh9zA8mFBApSSlIkByuTeYMT+GItyFSwknqYFdRhSb3M63KTcnpFXArSY0D0worPpu/SanJ0ousjf4ksJzxdXGfBfXt6nELSXTT56/mzJsbFpnc4EQG4Cmc1XuEybiMZzfV8nKvblGoR+jKd4c2v2Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785480558; c=relaxed/simple;
	bh=ZzVQHm6/Q75NiGGt3tDQiDJyIdBPIo9qK7c+2axhghY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WXbIvcChFLALjIkSBoWBxfLKRSo7oYO3KXkZftuQyeB4ZI22Djidcw6RtXZbag/fxVgK/nTT+Vo6AkLGu5llAv2HKKtCsvbiH29cx8LSVU1Q3jIRQ69VKOTZa4XWnIaC8y9YDwKS3r+Fk7+qSbHbZlaqDv4gifM6nbqlYBGOcPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BnHeCT3+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YuxdgNUC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BnHeCT3+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YuxdgNUC"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V6BSkR3310368
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:49:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+j0OGu8yNND2r1cN+Lm4pSp6KVSulbgFN7qITczYf78=; b=BnHeCT3+YvVeaVcK
	KHzzUB0Qc7jdP18Yjx6MjfycwLJDsSdVfSH6I0uuRGq7Tr1b1f7abcYdIotvKyRg
	eCjqS9QfbLIZCaFARX0g9n9D+RoHdRnurnaa8dz+jtwWiVzupof3QCqI3kWTPf9B
	0qRsXcUkn5QeSs0092bEBaj6djiIzPPoDqac1LvKJPTisMYRP2tTtTsJlE2VPdlj
	6skeXJO8ZVi0AMjbwiXBVzmhnunguPMUzmVXB8iCnEPhL2iB9Vn/nC7ISwAL3AKy
	4lp8H1kds3xydj3dFnvg8re7irer9RzDWkH1/kSrklHOB90KVqbNJcBcXXeF1iz0
	lbwEnQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frp7g8547-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:49:15 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc86a9ef97so11706465ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 23:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785480554; x=1786085354; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+j0OGu8yNND2r1cN+Lm4pSp6KVSulbgFN7qITczYf78=;
        b=YuxdgNUC5xCK/StHc3ZBeMC9e+h1+l047+BXa/6sRadqgQw81wu5+720kGMzUlvvzJ
         FP/d/mXjLkJBufWXmejJqUuCirQ/FudRaXaL/clqRSujM/XNKc+GrWWOnUxVBmD9K9mi
         ttfHtFOYVKcxIDhkdaPVU7x2B98M/dwFncBSA8d8odFxvaAe0t9rWUYVxDndWViAeHQe
         iN07Y4PDh+U2Rw4Unw+jurp4IEbj905LAVGyPgs6JE1G5IFfQQx0/R7opFutYCYHjZgz
         SxPLilH4N3nnItbUZ//zBN5oPh8gLvJVHYu8XeARmhN+7nBIgUiTjoZZdZgmqKhScVM/
         snOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785480554; x=1786085354;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+j0OGu8yNND2r1cN+Lm4pSp6KVSulbgFN7qITczYf78=;
        b=n4rVnC8k0yyohfCII9ixc9IWYxl6I2UBlA7j0qcH9K/XQKjG0tfdr1cWbm5FL4Bj8z
         wPRobZ4o8MpSCQgDWzd5wmCIEldyZN9fS4shr7VpNIZQKxyBSg+wn6tDgNLUk2kOnP2D
         OpGTDoURIOMi9hjfP4wwSxY1u1v6mTuk54OTGXMDiJrQ5QcUkyHGT/lzAV2eqsf2D7OV
         yIf5jae0xIcKuc1zunS89/+6asSbsYu6M3mtIHWst5ZoPlTrn5cofKTtJqHN57Cd50/K
         +iI6+i1Ifx2pclkfYiBzL+IRYO3MeKCc/7uO2xLUKPqb4PjU6JfPkt5r2olMa7XF7as1
         t+CA==
X-Gm-Message-State: AOJu0Yy2KqAEGT3jdNhoHMett0U7n3CiTL29lgyCpwVgdsDeFJsZNIak
	Vn+Ra8USTORwwxtAgIZV+B8tpk8/2wz5t4rg1MJcSmTjyamX56ziVn/28VFKIeRH7g4eT4pkz/Z
	CqsPAQzp7BOAkhdhw30ejE1Bg533U2+Al3Q6G9OtbBCDHCWwijMGjuCnsii1aSBj9ZxjdCT0thI
	R9Mg==
X-Gm-Gg: AR+sD12/0C2BChyNFlTzWh9Q+Z8cvs2yHpRwT/yuh+W8Nmw4aolY8vSZaFQ+0OpZnIs
	UY09fX2exxDu6elxc5rXZQhSJrwRzy0idQMvsy5/vGvHNH+0f8NczNkHb9nLp9QFg71QJ0oPWxc
	wAnT4tWC9ozYKnZDiHSsWDRtUVbZBS2s79I/cj3VxRAIGgQWo+PF46xxhp3y359p4QRDrLIgrIr
	XCwAOv064pnQ40ICZeudB00lhkq8BAXgInA7CdMURkrlEZnSfEPzgHbykCfVkVlny2SwNVnkfCx
	FeftzBRl3kXGFWomD817rtJf4RIi+wG2zLcj2fpp4L1FhtSut0Rv2LIUAOZqP3Xfa4iBUyGAYj2
	qrSX9Hc7OMujVltw7Jfv59ZdTB7ZxxOqRgrurR413sF/6963VIGIFcYF/42nkFcsbjMebt49TCQ
	==
X-Received: by 2002:a17:902:ea01:b0:2c9:deec:f564 with SMTP id d9443c01a7336-2d046d915c4mr9637595ad.13.1785480554232;
        Thu, 30 Jul 2026 23:49:14 -0700 (PDT)
X-Received: by 2002:a17:902:ea01:b0:2c9:deec:f564 with SMTP id d9443c01a7336-2d046d915c4mr9637435ad.13.1785480553680;
        Thu, 30 Jul 2026 23:49:13 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b0eb5a3sm1235665ad.46.2026.07.30.23.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 23:49:13 -0700 (PDT)
Message-ID: <387b4bb6-b0e4-471a-9276-211ecdedb58e@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 14:49:10 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath11k: fix locking problem in
 ath11k_dp_rx_tid_del_func()
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>
References: <20260729085741.3485711-1-nico.escande@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260729085741.3485711-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BcLoFLt2 c=1 sm=1 tr=0 ts=6a6c456b cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=pGLkceISAAAA:8 a=Z6wsjZpKeX7lfRFmj2oA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: Jf67AWYIJHyXJGn9Ba20AuGtMVOQ97QZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA0NiBTYWx0ZWRfX4WktVGd6Wtel
 eK3mKc4JXomrKCpAHy8CsITJLDCRLtUyr9Fyu7hC9M/3HtJ7cGcFyft1T5VEcOPJQQLhFnHakj9
 d6A5VaxiTnHmwd+gszVYb9ar+kL+vp4=
X-Proofpoint-GUID: Jf67AWYIJHyXJGn9Ba20AuGtMVOQ97QZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA0NiBTYWx0ZWRfX4q4Y6Ybg3o+o
 pQHiLmnS+kbi+9wNImh9jc+fGE+zsz7PL50+j1LBTXOqZ0tJpV4TcTeRLRpuhMZPYITer9OY28q
 4hMlDnNn5EEH2Sz8iWNAVH1ykqht+vvOedW98z2a19u92Mx2KEO7ok2SWIwbt1JBMQl43to4n4Q
 WzFz8NWaUmN/ygvtlElBf3Zkad0WNZC9mf8eheacOKJ6iCepSt7Mri5eGgkqtNCKkUSVzlH2RAC
 Hr2QYqUqwJEEAHLVfvZaaQSUftHClUNwcQDfD7ZXZg0ts5k+CC8JFi9rW5nNZHddwvQ/yqBSAOa
 YGyns77cuMg4VlbdY9+d9ThkS6TCbz4Ex1r4JcEg1cgByG42nvfH3exC1YeQdq9Ga8JdjmUW+eX
 JVRzGH1+ZFbfIu1NBaSAAkL50M/bZv5gKMJiBf9tkoIhSPEp5B9+sW5GYWqomtP9zhPr87SFCF4
 U0THO5zVDs9+Wskmo1Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310046



On 7/29/2026 4:57 PM, Nicolas Escande wrote:
> From: Maxime Bizon <mbizon@freebox.fr>
> 
> In this function, we iterate over dp->reo_cmd_cache_flush_list using
> list_for_each_entry_safe(), and for each expired entries we call
> ath11k_dp_reo_cache_flush() then free the entry. As this can be called
> from multiple CPU we protect for concurrent access using dp->reo_cmd_lock.
> 
> The lock is dropped to call ath11k_dp_reo_cache_flush() and taken again
> before keeping iterating over the loop. That is broken.
> 
> The list_for_each_entry_safe() protects over deleting the entry being 
> iterated over but does not protect for concurrent access. So another
> thread might have taken the lock in between and modified the list, leading
> to a crash (see bellow). 

nit: s/bellow/below/

> 
> So fix it by restarting iterating over the list from the start once the
> lock is retaken.
> 
> 	BUG: Unable to handle kernel paging request at virtual address 00000010ddbeef8c
> 	Mem abort info:
> 	ESR = 0x0000000096000045
> 	EC = 0x25: DABT (current EL), IL = 32 bits
> 	SET = 0, FnV = 0
> 	EA = 0, S1PTW = 0
> 	FSC = 0x05: level 1 translation fault
> 	Data abort info:
> 	ISV = 0, ISS = 0x00000045
> 	CM = 0, WnR = 1
> 	user pgtable: 4k pages, 39-bit VAs, pgdp=000000000593f000
> 	[00000010ddbeef8c] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
> 	Internal error: Oops: 0000000096000045 [#1] SMP
> 	Modules linked in: ath11k_pci XXX
> 	CPU: 1 PID: 1775 Comm: napi/-29 Not tainted XXXX
> 	Hardware name: XXXX
> 	pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> 	pc : ath11k_dp_rx_tid_del_func+0x164/0x3c8
> 	lr : ath11k_dp_rx_tid_del_func+0x2a0/0x3c8
> 	sp : ffffff8020c2fb90
> 	x29: ffffff8020c2fb90 x28: ffffff80207ae910 x27: 0000000000000080
> 	x26: ffffffc00861ebe4 x25: ffffffc008cefb88 x24: ffffff800d701b2c
> 	x23: 00000010ddbeef84 x22: ffffff800d701448 x21: ffffff8030e22d00
> 	x20: ffffff800d700000 x19: 0000000000000080 x18: 0000000000000000
> 	x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> 	x14: 0000000000000026 x13: ffffff801958a100 x12: 0000000000000000
> 	x11: 0000000000000001 x10: 0000000000000001 x9 : fffffffe0081eba0
> 	x8 : ffffff801cc49300 x7 : ffffffc008f87130 x6 : ffffff80207ae900
> 	x5 : 0000000000210d00 x4 : 0000000000000000 x3 : 0000000000000000
> 	x2 : 000000010024519a x1 : 00000010ddbeef84 x0 : ffffff800d701b08
> 	Call trace:
> 	ath11k_dp_rx_tid_del_func+0x164/0x3c8
> 	ath11k_dp_process_reo_status+0x1d4/0x2fc
> 	ath11k_dp_service_srng+0x334/0x338
> 	ath11k_pcic_ext_grp_napi_poll+0x30/0xc0
> 	__napi_poll+0x34/0x184
> 	napi_threaded_poll+0xb4/0x1d8
> 	kthread+0xdc/0xe0
> 	ret_from_fork+0x10/0x20
> 	Code: b946e2c0 7101001f 54fffe29 a94002a1 (f9000420)
> 
> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

hardware version missing betweeen target and bus type

QCN9074 hw1.0 PCI

> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
> ---
>  drivers/net/wireless/ath/ath11k/dp_rx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
> index 8e2abc7b8383..b8f939f7c04b 100644
> --- a/drivers/net/wireless/ath/ath11k/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
> @@ -784,6 +784,7 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
>  	dp->reo_cmd_cache_flush_count++;
>  
>  	/* Flush and invalidate aged REO desc from HW cache */
> +retry:
>  	list_for_each_entry_safe(elem, tmp, &dp->reo_cmd_cache_flush_list,
>  				 list) {
>  		if (dp->reo_cmd_cache_flush_count > DP_REO_DESC_FREE_THRESHOLD ||
> @@ -796,6 +797,7 @@ static void ath11k_dp_rx_tid_del_func(struct ath11k_dp *dp, void *ctx,
>  			ath11k_dp_reo_cache_flush(ab, &elem->data);
>  			kfree(elem);
>  			spin_lock_bh(&dp->reo_cmd_lock);
> +			goto retry;
>  		}
>  	}
>  	spin_unlock_bh(&dp->reo_cmd_lock);

while this seems the minimal fix which stable team might prefer, how about refactoring as
firstly detaching all the expired entries onto a local list under the lock and flushing
that list afterwards:

  LIST_HEAD(flush_list);

  spin_lock_bh(&dp->reo_cmd_lock);
  list_for_each_entry_safe(elem, tmp, &dp->reo_cmd_cache_flush_list, list) {
        if () {
                list_move_tail(&elem->list, &flush_list);
        }
  }
  spin_unlock_bh(&dp->reo_cmd_lock);

  list_for_each_entry_safe(elem, tmp, &flush_list, list) {
        list_del(&elem->list);
        ath11k_dp_reo_cache_flush(ab, &elem->data);
        kfree(elem);
  }

This fully decouples the concurrency from the flushing: the detach phase runs entirely
under the lock, and the flush phase walks a thread-private list where no concurrency
exists. It's a single O(N) pass instead of the O(N^2) worst case of re-scanning from the
head, and it avoids bouncing reo_cmd_lock once per freed entry.

Also this seems simpler and more direct — its correctness is obvious by construction;
while the fix of this patch is less self-evident: a reader may not easily grasp why the
code has to rescan from the head after re-taking the lock.

Non-blocking though — either form fixes the crash. If you'd rather keep the minimal goto
retry for the stable backport and do the detach-list version as a follow-up cleanup, that
works for me too.

