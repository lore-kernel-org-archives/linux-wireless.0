Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B6E43E097
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786718048; cv=none; b=SWL4RZAKE10bbNaUWfUPhf/TyEE5VVpVymuQXjIJbfmlO5sqHd2rkhWy5GLW6S0/q1nzP6s3h+K2KnXIj5pB1cr37SuBP2o53z2cW5siU9prqPSnlyN/fH/WNIo9Ox7pCVQFXVA5uTa/viUzImVQe8a8LjmiyvxoDPVwHw8dxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786718048; c=relaxed/simple;
	bh=4apH32HwDzWFbHFvaNXTgvgNok3BBq5lHykqjRsWPis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qwm37FWzbMDGl9kRSEn4I8zk5NM9aGlmFZmoyP1W2VK4qzP1qVJY1t2gvnhBPcXMUxnHNg1euPpZZOBmKzkBvCC1HgxpsCc/RNjk36wrL82P6FJ+LptSRVGojMZk0tyRpZ+SzYMd5tWm7PLDnwJDySnJaEKmE4OZZqAeWs7j0jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TocuYtvG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AFhPXbu/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TocuYtvG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AFhPXbu/"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EDx2ZD2433174
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 14:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vZPQOGeETtND76wXlTALy1Tl7jMtH10MFsj5iXkLt3c=; b=TocuYtvGkRg2kZyd
	4EkpC8lbdaSB9iK86BZ1IiNUq5ReDiOwdcYgIjI9oGTV0S7nfriO+hiOkmFac/DT
	9NcYxMc0owaafQbF4mAWSUX+LdiGG2Dv4trfykZpMvtEug/TY5G8C/S9gVpX36U/
	9ukvYymxwfHHdv0sxLMD1109vWQJWKUINcrKxiaD6lEp4NVfo4uVdqr2KSn0w9Yf
	dX0uGM36vgOvCyNs4Z5PG0+QBZ7sXGzI/9m/lQvAET+7VX3RvRrUjIQntVpq9b/l
	KWIPhecd42+pW/TfcU0YQW7/1jQnuEd5f4v8d/X9wqvbNgUHBEY73Rbqz0qtIS/8
	vt49cg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g1nugukf0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 14:34:01 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38fcaa5f82cso1243917a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 07:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786718041; x=1787322841; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vZPQOGeETtND76wXlTALy1Tl7jMtH10MFsj5iXkLt3c=;
        b=AFhPXbu/m1z02+r4zCi6nMyyqBmNeHKRDUxDIgn5KLinIcJXb9uhFY0PyjCn1crX5K
         NFg/zrV478ltgeENhb1sjbThnFYmSPb9wwZ6s9BP8+1WGxHQdMMUInFcwNNBDgD4Ycwg
         7AXURRdwUMt6s6rz31LoOLFZ4CY5MfYbjR27OqsNCk8i7QCkNT3bQl9tc6+s16/+CuBW
         C6Ugp3ET4H1m/42kBB8RMYn0X7HLOxejQ5vu9Ebr8mEyBYwNy8S6KA3E/oAgeOQ7mO2/
         31k4rZnHIoxNQEhRK2wDMtWdyGEJHv2cVu7obj4kPikNzhAX2Z4kTSLKVbLKW+GEm+14
         vOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786718041; x=1787322841;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZPQOGeETtND76wXlTALy1Tl7jMtH10MFsj5iXkLt3c=;
        b=YqV2YBcHyfsg2VeYCncvDvzLGW/k6yqXHs8cKsHJFBD3FDvtE4GZl3Kn30Bz6x25vC
         aMADLnTMz2ebeqnToE9F+PDKa0rN4jfaAGMYPIevE5VbYYHNQnmuL8zUi11ypvwcClHk
         00g09hFsXfezzPmIQHRK+vqrN/cRpcMcMAtXmVQUNpZkGaeo+WNL6VJ3NLGl0TXmHQFS
         yUcDIm0ic7fljiMTgSZkCfkQA1X7RXTW7ZJye6JtNW7DCcFUS8AiDICHxPL8DVPbG6V7
         t88PrCv6KJadRaMBe+HKWRVzX/ev0ANFTKDcxPSgwmBLUdfaxWQo/2VkFmYGHcR/6zhG
         p0ow==
X-Gm-Message-State: AOJu0Ywhp8WZhWBQVWEUWpm5iSTFJTnqdmVkUsxXt4sbOx5FEmvbgKHO
	dFzBNDY7oiYBTSmxzFak4Wm7lnBUUrMfeZz9pP9XfpseSZKMuvxaaQFyPBVvq36VlLrjWTqYo7r
	Zpe1vg7cref2EeXxKUtwajZVGB0X98Rp8t1MiF42cG4qAPSbxYtxEVcRqwd/5irc0VarqSw==
X-Gm-Gg: AR+sD13BnQf5q+NUbQHL4Bl7zoTFwLN53laAjjywlAy+YqNPMPcqxfMkMxaAVO3rBUk
	G2KJrNoelBoDkZFdbw1aO0UKE9EOG4dXFStyZcaXGlcA4dyp8BO8J8+1/EG+k96+8rEvL8iXNq6
	U6qGngJWATfbeFV2rmqHPSDTdgmHHBHH+rZmZBbBpxtOoKHjQm9CTmIDn/81oOjx3XakFtjhsz3
	YS1gEnjDDHdTHBcTRgFsJNv4tmT4H2ljlGEyDbHvF+CFhyBsXSB1RjovB2okEFqV5UmJIBDRC5I
	nOD3sJ3O/ZzVfQqFRk81lGDFK3T29A7rCpcordaQxvzN8M5m7j6jPmjVvU1QYMJLHRUDSiXtiLT
	pU5Cl2Mm/wmzvM3u5qyfj99DtNCqOqgNbOgg/TJkUNnh4
X-Received: by 2002:a17:90b:2f86:b0:37c:607b:2cd9 with SMTP id 98e67ed59e1d1-3933b84973fmr7159669a91.0.1786718040833;
        Fri, 14 Aug 2026 07:34:00 -0700 (PDT)
X-Received: by 2002:a17:90b:2f86:b0:37c:607b:2cd9 with SMTP id 98e67ed59e1d1-3933b84973fmr7159583a91.0.1786718040310;
        Fri, 14 Aug 2026 07:34:00 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ead105a9sm4999350eec.31.2026.08.14.07.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 07:33:59 -0700 (PDT)
Message-ID: <37c6a556-42ff-4f9d-9b95-d7f6b273e93b@oss.qualcomm.com>
Date: Fri, 14 Aug 2026 20:03:55 +0530
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
Cc: linux-wireless@vger.kernel.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
References: <20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260813-ath11k-locking-v2-1-f4113a0bd0f4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDExMSBTYWx0ZWRfXxTPUmkiuz7LF
 MlCMGOSKxHs6BzZheb4ODbVmFJaCuzEUvv5iPvS1yNhqy8DU6tMO2AWaf/4a4M3+SP0kVhOJRiD
 skGnV+guArC4wZlx/sDhr8LosuUUkiQCVMK30RJMSBBsRqN5ovJOfKzH7WiW33tgJdg/jdrnMl/
 Oj1iZ5mC1R8XwOeK1FYhDeNQv763SnMYhmjeWPsNynRMvwZEY9ofZNIjzu46nrZThsATnidSFe/
 e9JwUi5jLinI7VGAjODIzx5HIpMtB/chsn9qkVBxeEzq+8sCpt3GIYEK1rOWj1QNrRbPLjntRL7
 B7NVJsKfNY0LGQudLnL9NDhRxYalayFojlLtKHT/Wn/Wj7884/ZeQFYeAffDKqRHz/Cg6TG+RRE
 cCLtRT2y+XpUeySwE1oOhiUUqkgWWRnxG/ktrjRR9VBVPp3OCcD0kp/W/s1Da/LrR6q/gEE2LnH
 XE7q+48iBKbb6897BBQ==
X-Authority-Analysis: v=2.4 cv=drfrzVg4 c=1 sm=1 tr=0 ts=6a7f2759 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=27b5MfB6VpTch7MquCMA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: Spd-d0fT-S10x3Vo10hTCtDSPkQW9zJP
X-Proofpoint-GUID: Spd-d0fT-S10x3Vo10hTCtDSPkQW9zJP
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDExMSBTYWx0ZWRfX4HUGcsnsYzV1
 1stNLMgUjrB96hxApUDqAK8TXLCjKsEzIWsCKlITchC1p8C2tTaTWPVbRsLbj+RzvjCFSBzu+bi
 ayQQzjU19Nmp9y/cZnd2+FIzMT9HOvE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140111

On 8/13/2026 5:45 PM, Nicolas Escande wrote:
> In this function, we iterate over dp->reo_cmd_cache_flush_list using
> list_for_each_entry_safe(), under dp->reo_cmd_lock for concurrent access,
> and for each expired entries we :
>    - drop the lock
>    - call ath11k_dp_reo_cache_flush()
>    - kfree() the entry
>    - retake the lock to keep on iterating
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
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
