Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D9E40B6E5
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 10:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785924465; cv=none; b=SyR/x7Tt7J9KRKDo2cxiuaWbnnPNNkqpAEj6OUlGrbRw5LCK4B9okfH/Gzd8K1Rba27iKXhBXVZ0JFIEV0m+GYGFN3K8LodCotJYaWOcg+QmWs1mfZKgUBUc4fGzYuaIJYA2M4593nnYfafndefA/VU1PAio8lb8E+Lu+U56IuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785924465; c=relaxed/simple;
	bh=dmK4SExRnYcicfzWeZcuHjOVX0icKw2TA06Fvrt/HWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KgJx0E0yvrgIeeEm2ZhceUlEzvYxCXLkR5AOIXZ2UuFjzP4wjScQEYJhdbr0aNg7kuIwzz86eAmJnrnA/WMm7wB2ZnCYVTu0XoJJyXgaOCIMBgoZqnROCwcwGZEaXFKe6BelMC7Fi32IjUjqI7wjm501KfeZ1AoP/t2neR+G7H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K7+mtetm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JnhXyQc+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K7+mtetm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JnhXyQc+"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6758dFwe2074103
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 10:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f7TvXrEwxNxYGHqagweuLdI2HuNVd9ApPoKl7MTkzyU=; b=K7+mtetmpPkwGFpC
	UQJsPX3k2m3A5VIwEfEa1AIJ2ObBPCo2TOm5j7d7VDYyJlA+TLee2feIB3rKZrFT
	X7Be86pOe14DbB3Uj9v6crPfkTlungcBLIkm78pacIkVrkVwVAQKSlpEjHdcvdvN
	cz0oavodhmzcBfHz9ZLFgSsxjqnCnimsSvybG6K9Dboh3yw0X4/EpxfvUClJGwU6
	rOx4PajwdDtGYTU87i0bmhrCHrQ9SUM/CJHBMC9IxjTgFdLPAEVYh6qRMjjHto3M
	NBrU5UtbNIY/7llR4SDWMTOmx4Qj+fA6Ob+aqvQORc/r78iIw1Kx/uSupJ9vv7Ad
	cg+vbg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fuk9u48c0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 10:07:42 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38fa7b09921so1380719a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 03:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785924462; x=1786529262; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7TvXrEwxNxYGHqagweuLdI2HuNVd9ApPoKl7MTkzyU=;
        b=JnhXyQc+TJTUcsYTxrgin9SneJoGDSn6e2cddk5wZauPXBj+ZqbcISNL9JjdQr6d8w
         uJilbqeOWeNErAi3e8umbn0+j0ozbK4WwwUlg7Iu5SgwfN76yTVxmhmFkqK3Qx97LAgg
         7bLhjYUFHJ/JpVDLV0pNBxJxkLgT+w1EvM69qhdw20IsiPZ21i9NI5FaIiq8efuEZQ3h
         B6M8P7qYEOmdFLYPCD6lrzA2fAlWasxmBDaJCLvS8X0J9WFnKCpPr1sGiLZDQjEvc+fO
         UtPhzQLFYLjLXCXeoLjCgH6GVB3+6Sv22m4QLZHWYVT94e9yLuH/Jb34grAXCocwq5i9
         F2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785924462; x=1786529262;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7TvXrEwxNxYGHqagweuLdI2HuNVd9ApPoKl7MTkzyU=;
        b=KaQoCY/2JBfoQMHeMTG/Tp1n01Aj26BM6GGTo9BvRFi65hnko0dc/GmStVGuuVhmca
         an/WP6NO20cw9UKvGFCnkRpYYlWcN6duznVpTWmIlA0HPmU7sa6w4N72CAssMpl27ilt
         E3S0EKiCHFnquiBk//wzpaxGc1GtMS00tFn94C0cxGeETVLUJ5gbVOfr4jJaYmtrQa4c
         CDXBha9QQIzfSdV6MIxyubfxTPYp6VEFnFEqIRExUsd4bgR4r2MWtj936xW7RNRfOPM5
         A7JdYG4bSLHR+fEnie4LntV4woy92Bd5fmAnjy410NtcYbKzqCcY0M9ToDkVuIQb1cVh
         i5pQ==
X-Forwarded-Encrypted: i=1; AHgh+RoMTEoZ4s5bjougH+mexTAGEk6LDbMiLNN4LstWRvcbBSHAYZu8fGYmRAkio4Fab3e8Q8PVq6UQNLUbZ3xsYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YziMeVw5GREveLouOVm76XBOjkKq6rTxkfmZvZIgA964pTmVPbS
	utJwDq7K3i488XnpTCFAfNk8ONXDr1NbV3LnvR9XWq82ymyoFVBLV0f6W8Y3VEZgveLxxtKJIDJ
	SIDdjKIdqmM3M0OVn0B+yQNghDEcSGgfpc88Pk2gw/wyesvH+PQNMHyW/JTrX18q1C//U4Q==
X-Gm-Gg: AR+sD12W1SV/DtX6sA2cGjagzR0VOyioDt9lDwHtM0O57tpyqREjMI8sivr6Z7V/O2A
	PW4TbkwzauQGwwuDqr07+FD+AKUd7dWJ+hJVh5cXK90hU1BQPRAWY/Kr4k/H8cBj3/8rVMhY6ww
	UVZCQvhnFJmwWpSfTyU3xCQaNPhPAlkJAXLSkp6D3ffOB6pQ1HSnQNxgw4329dmvTPrIm3wPrsk
	8gO4QqrMNcn4OjCUnSGUBMMmC7heFxVTPtQFGVpqjfqnJdxYWXH8jgj3YWa9L0tZIfh9WykwOgH
	8BMbUFR5A9gvJQj5x54gU6xWD/sT9FeiEqHtjq2k8u2N5YryVoMGpZRqYxLZVCQLVk+nazjvyjs
	HdUd8gMatFRc1XkOSTYe2FuCbYqP9USKmq0KVZA5e
X-Received: by 2002:a17:90b:1c84:b0:38f:1e1a:515e with SMTP id 98e67ed59e1d1-3903c5b1688mr5154522a91.14.1785924461689;
        Wed, 05 Aug 2026 03:07:41 -0700 (PDT)
X-Received: by 2002:a17:90b:1c84:b0:38f:1e1a:515e with SMTP id 98e67ed59e1d1-3903c5b1688mr5154442a91.14.1785924461194;
        Wed, 05 Aug 2026 03:07:41 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca6576b7sm11507202c88.7.2026.08.05.03.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 03:07:40 -0700 (PDT)
Message-ID: <3214559e-a9a6-49ea-a421-c41698fc2114@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 15:37:35 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH ath-current 2/3] wifi: ath11k: fix NULL dereference
 in ahb remove when QMI init incomplete
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
 <20260730030948.147892-3-miaoqing.pan@oss.qualcomm.com>
 <114b5ae4-002a-4f35-8fb1-0ebf44e9250a@oss.qualcomm.com>
 <61e47242-7615-4bc7-af80-c671318b3c0d@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <61e47242-7615-4bc7-af80-c671318b3c0d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=NInlPU6g c=1 sm=1 tr=0 ts=6a730b6e cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=u_1nGVd5-Qw513d467YA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: kqGANH4Cif5Ja1DrasZYLFCFBCvq_AyV
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA4MCBTYWx0ZWRfX8ZlrpnhAg4ng
 rpDNEYRAGLxi8+XWW7DwZZRDFxCCccXJtN9vqYW7LoJowYmPdPGDv422iU1VFTV3MtBsv2JZFt3
 dobI1rS7ZFlLC6Ve95T3G/OCN92bgkc=
X-Proofpoint-ORIG-GUID: kqGANH4Cif5Ja1DrasZYLFCFBCvq_AyV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA4MCBTYWx0ZWRfX8w2KCnwDuREQ
 OBuF87HkRSNtfuAz+0Di7gZZnATR9pa0HGRjg+aDWlT/RyvMCNrTyXUcQG13LlOKdzs1ug3Vf9m
 rRZcsnPb6i2A8UcsdAkXUhIeCvhZMKFnpQTENAJGS7YJx09k80bEUEpOXFtUWl1OsTLf9VgwHNR
 raT6L3fFOIHaWo6ZcmyY04pJ61tlD9wfHKvQQaVREYd4ZGIk7xw3vnqMgg17Z1xxUNfEWI3nEUJ
 RDxzXrCnLgG2kL9vEdishksxHQXb40Z9ZV2Q2yK60Rj4I3JAS7q7aoBanUEb58/zrS/ygpw3ooL
 fAAFZ/b7iOAgVTEEZgdavrpk0Z0l+FsP6NkYrNnvVRwua+NFducsH6NTYJTuLdKJ18WUb6+NWqd
 HLICDPGSG7Haji5WX8OO23pajMqR88XvzFaMQAfdYotdnl9QOmWs6CR6TY3VQV9PLhZ1M/rmS94
 frlAI29q1qUuRFkwOcg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 clxscore=1015 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050080

On 8/3/2026 12:17 PM, Miaoqing Pan wrote:
> 
> 
> On 7/31/2026 5:24 PM, Rameshkumar Sundaram wrote:
>> On 7/30/2026 8:39 AM, Miaoqing Pan wrote:
>>> On WCN6750, if QMI messages never arrive (for example when qrtr_smd
>>> is not ready), WLAN initialization stops before the device is fully
>>> registered. In this case ATH11K_FLAG_QMI_FAIL is not set because no
>>> QMI event handler is executed.
>>>
>>> When the driver is removed, ath11k_ahb_remove() still calls
>>> ath11k_core_deinit(), which eventually triggers
>>> ath11k_ce_cleanup_pipes() on uninitialized CE pipes and results in a
>>> NULL pointer dereference in ath11k_hal_srng_access_begin():
>>>
>>>    ath11k_hal_srng_access_begin+0x14/0x68 [ath11k]
>>>    ath11k_ce_cleanup_pipes+0x184/0x190 [ath11k]
>>>    ath11k_pcic_stop+0x24/0x38 [ath11k]
>>>    ath11k_core_deinit+0xfc/0x1c0 [ath11k]
>>>    ath11k_ahb_remove+0x38/0xa0 [ath11k_ahb]
>>>
>>> Fix this by invoking ath11k_ahb_remove_prepare() before the state
>>> check and skipping ath11k_core_deinit() when either QMI initialization
>>> failed or the device was never registered. If ATH11K_FLAG_REGISTERED
>>> is not set, core initialization did not complete and CE pipes may
>>> remain uninitialized, making ath11k_core_deinit() unsafe.
>>>
>>> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1
>>>
>>> Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
>>> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
>>> ---
>>>   drivers/net/wireless/ath/ath11k/ahb.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/ 
>>> wireless/ath/ath11k/ahb.c
>>> index fb5640882b98..7f5f5c8d7c56 100644
>>> --- a/drivers/net/wireless/ath/ath11k/ahb.c
>>> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
>>> @@ -1265,14 +1265,16 @@ static void ath11k_ahb_remove(struct 
>>> platform_device *pdev)
>>>   {
>>>       struct ath11k_base *ab = platform_get_drvdata(pdev);
>>> -    if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
>>> +    ath11k_ahb_remove_prepare(ab);
>>> +
>>> +    if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags) ||
>>> +        !test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
>>
>> Can we use ATH11K_FLAG_REGISTERED alone to decide the cleanup path? If 
>> REGISTERED is set, ath11k_core_qmi_firmware_ready() completed at least 
>> once and the normal ath11k_core_deinit() path should run. If QMI 
>> failed on recovery (say before FW_READY or INIT_DONE) this should 
>> still do core_deinit() isn't ?
>>
>>
> During SSR recovery, it is possible for a QMI failure to occur after the 
> device has already been registered, which could result in both 
> ATH11K_FLAG_REGISTERED and ATH11K_FLAG_QMI_FAIL being set at the same time.

Yeah so in that case current code will skip core_deinit() which should 
actually run isn't ? Though the QMI has failed on recovery the core was 
already initialized and should be torn down.

>>>           ath11k_ahb_power_down(ab, false);
>>>           ath11k_debugfs_soc_destroy(ab);
>>>           ath11k_qmi_deinit_service(ab);
>>>           goto qmi_fail;
>>>       }
>>> -    ath11k_ahb_remove_prepare(ab);
>>>       ath11k_core_deinit(ab);
>>>   qmi_fail:
>>

--
Ramesh
