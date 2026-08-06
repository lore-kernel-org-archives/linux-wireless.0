Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0801C433031
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 09:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010143; cv=none; b=GvgNTj60QyDTQGND6ArlvpdUTg3HU5gkLDg+a+3qUKvXDym78UL3wfmicKGEpI1/iLTD1Q3xgGPj3dhs1CF62Cg6gBIbCE02rNX/k01KyhDPzYsTTrGI1Ul0rQXxQfWukQvuTLnNigA7L/DPEFiZc5XkH8dL02fGU8FsSHkqEhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010143; c=relaxed/simple;
	bh=o1lqmjaIKOxHXoo5DrtNKefXDDvGobyW2D5jtFvkr6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ho3ptTMZRCkY6Y9Var1GJFzlxCcEWDzofUpahvlYQZw7/ukxeoN1OpcoKOUcfoJuN8kdawV6QsfhMwY8+oGbjnMAonNuyjz678HZFA06pBv1pGjNlIFX1L5yLeTqnE5YJFHN5Wk2vtynL6LWOwQs9FwWjM0y4o2LoYvykC32U7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E/P6DXeu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i19ivNem; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E/P6DXeu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i19ivNem"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nv7O2725115
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 09:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ay8uYOaBQdPle+ZgQFRxfmvrviTk9ovPSjnn5gt1Cuo=; b=E/P6DXeugsFXrIZN
	jjk91DBAme5pX4b/55NQU6w/SA3CWGIe5IJEyCfjkFN1KOkhO9fmZE005/F9pU6R
	pn37L+EjvTn3Max0QqzV9n2zhNLXPwOtDbLc/sTxL39bdp8EETrjFS8wYIDH0yut
	Km0qofdAzAdc9PDk+yDjtZhpuVZG2l5wWLE+c/UnUJGL+HOp32l98OccGEvKUT6h
	qQ6c94GgIQ/NActQ0o4UCT6ClL2FX5HcrUdcgZMshzvNLfWc6eW9tc+u2cZa7eDU
	U6NfbY0yH1+00SsxEYkiut9MBebyiX14fjehcFTAarhN7eNJLyrpn5tfH055FLqQ
	eV5DkQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv9dmkjkt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 09:55:37 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c89704da8c7so2996478a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 02:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010137; x=1786614937; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ay8uYOaBQdPle+ZgQFRxfmvrviTk9ovPSjnn5gt1Cuo=;
        b=i19ivNemLLeeKgO+pXqcjIFzNf4VX3zfdoLugmQX9ELxfzrxYCuesx8zhqEkLezxau
         SQgq42LKA+nkgCqDfZHJo9mC8bBlMd0dEMFPHAaZiJTXtfDAiiYOCTDTwaiHCACLxcGx
         7B9C5b5Y18b9VUKHHfcRBJ0FCLE3Xbn25CMxKg44zwgf43F3IavVghRgt/+8aSJMH7AG
         IyBZKpfDzef29aS7jASM/NYTU/0C0oggC3NvisPNZJ07L5c8K+zlZ7ghbbApGOX6azC/
         dOwwQcp/6erX0+I3Zgi/rpFYy6AgCe6y7cUb+cBrnY9J5VZYnP2/zlHxJpp1fRqAGgwf
         PA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010137; x=1786614937;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ay8uYOaBQdPle+ZgQFRxfmvrviTk9ovPSjnn5gt1Cuo=;
        b=DPz34hK+xKuw4sBtg7UGbCMkG7T5J2P1gZJw5QHajlGzzLHqe7raMRFppKxY8aG9el
         1qhDke6rUaUTiB4pF7z7pyTYRpbfiDgFakR+FNuFBArzxrQxyxldeNc/xj7G2Y0PLZWS
         ug++AsK7Qa9fsKAtLXBZc+UiVRUA/CJhhhwL49kKzPvvoUKhRL2ipuucQIrYq/LJngPL
         F6dhWl0xc0E+rIFgZ8E/Hm93Y4mhpG+NVh6+/a1VY7wYo6M+3HtB+4cGs5zCr9C3tmbn
         Ew5Fq8CHBOTkwhq9g3Qc/29GdC8J0mPmqMtpH2fupU9mXKj5bOPw9McxYm9muIlPao8y
         vfig==
X-Forwarded-Encrypted: i=1; AHgh+Rq55uHO/y+0iFjmz3W55h6h5Iv7wyUDJ6UOTth/KDwH/YGBC4PB7ZGbNaViq0xUe+rgQ7dW9vAsY4imNvMgRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvLorfFBqGe95ndhwtVLlnU77VeZmtQe3k6DAPpC1dp9+b6/iK
	TNSzcWzZFwTIR6xWBPgEz/fRs7ATmFZRBUYyuJN9uelEngFvQ8LSAAbS35m6DonpB9+Qgyj98yD
	YXejvX65nzNdCVPciiN/QORpbwiFeHZWHLCPILZE5nCb3nSJkuaDbHkeHWSSY5HZcsFWqWY1TP9
	xQBw==
X-Gm-Gg: AR+sD11C0VqFhcacKz5suf7IDOXUQo/sAhMmaZxT+/t1HTiXeVuiSXEuJvajCyQ0RBg
	7XdLlP4/gq74Rj3L5xMuK5R/8JBzw5HSI37EMMFuEjijAEhvoVBaChO9HRNBFUCXnfyGkeBj8vg
	tAI8lu54Yu5HZDyA9sfmjzTCdzMaonBZPq9au35cRINSgz0PMSE4gDGY2sNsGAVGsghhEmj4Hk2
	rpBxwHyShRfaRyi3M9xzsev/fnwy06sFs9am/H05zg0/LC9hdHkaoPB5F15DipQ7etayNBQDsM8
	UAqMP5eP+6NaTVA7leoVYdOy/Q/fKkc39ANNt5tgk6Zn2Cj1H1qVYmagRV9vdkG5WAkaQmmts33
	aqMwOKjzLfe1xAt6ZRsbfAJywsSPsVj+35s/XiKOAWV5VxkDQiu/ts29B4WwIyOSCecoU6Wqc
X-Received: by 2002:a05:6a00:3a0f:b0:848:3f07:c5a2 with SMTP id d2e1a72fcca58-84f2dfd0a06mr13523394b3a.4.1786010137030;
        Thu, 06 Aug 2026 02:55:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:3a0f:b0:848:3f07:c5a2 with SMTP id d2e1a72fcca58-84f2dfd0a06mr13523356b3a.4.1786010136540;
        Thu, 06 Aug 2026 02:55:36 -0700 (PDT)
Received: from [10.133.33.160] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0adfsm1062537b3a.15.2026.08.06.02.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 02:55:35 -0700 (PDT)
Message-ID: <32516b72-cacb-4c4d-a23b-a8dc6489dea7@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 17:55:33 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH ath-current 2/3] wifi: ath11k: fix NULL dereference
 in ahb remove when QMI init incomplete
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
 <20260730030948.147892-3-miaoqing.pan@oss.qualcomm.com>
 <114b5ae4-002a-4f35-8fb1-0ebf44e9250a@oss.qualcomm.com>
 <61e47242-7615-4bc7-af80-c671318b3c0d@oss.qualcomm.com>
 <3214559e-a9a6-49ea-a421-c41698fc2114@oss.qualcomm.com>
Content-Language: en-US
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
In-Reply-To: <3214559e-a9a6-49ea-a421-c41698fc2114@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=TJR1jVla c=1 sm=1 tr=0 ts=6a745a19 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=qvQTsly1c9rGXFxJrb0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: 2nvxW4kkIdT6EcXhIxCRxaX60UUk8PYg
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3NiBTYWx0ZWRfX3Mri5GD1Xibt
 xebh7SZ1zQu8sdWFrLppfOlOkYzBtl/VX5OSQ7hjWNdspE9lNctMvrgnxBH+oMFMZ6dcygW2TWp
 mLfsGmxEZmtFRzk/zc8Sq2TBaxItxtE=
X-Proofpoint-ORIG-GUID: 2nvxW4kkIdT6EcXhIxCRxaX60UUk8PYg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3NiBTYWx0ZWRfX3DYAqYlxu82G
 4CjW9AM+c+x07TbFHAZIFoGhvox7n1dU9fy263iimCLzjAU7rD69EBLXRfkbiqLtySxvGlUhcRB
 GOXkqESdEeBLV5A2NZ75rgENppENazgO9S9R8vddmpmxQ8zZiespqcRQowt/kQdtJi0qRgTXMW7
 YGzNkFe3UHm+oz26IedoED1yRcaRPBMWnQuKVuRpOyyzxsHBPJ2SV7eFm17pjUPYEhrPtncWOYk
 d1KX9fFh/MH93xzxkhIAZZjW3aQL9cOGdA0fIR37sWuEdn/0xZN3BVUJLw2ko5YzKqfj2gnYN1g
 JYhTWCPZ2UxPo9atHGs17maBwIBpb1DlKuEyZJyFlaABINjZsDxdOtn0c521C3XNm7VXJlYD4No
 LqsvA/4H/hC2/1Pq0sih1QyxStVX+spRnL10Eu1eJQdJGtjXO4E5/rtfrRGP4la3Ij4bNQuUNJU
 wY5OstkCpmQe0d/Lfdw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060076



On 8/5/2026 6:07 PM, Rameshkumar Sundaram wrote:
> On 8/3/2026 12:17 PM, Miaoqing Pan wrote:
>>
>>
>> On 7/31/2026 5:24 PM, Rameshkumar Sundaram wrote:
>>> On 7/30/2026 8:39 AM, Miaoqing Pan wrote:
>>>> On WCN6750, if QMI messages never arrive (for example when qrtr_smd
>>>> is not ready), WLAN initialization stops before the device is fully
>>>> registered. In this case ATH11K_FLAG_QMI_FAIL is not set because no
>>>> QMI event handler is executed.
>>>>
>>>> When the driver is removed, ath11k_ahb_remove() still calls
>>>> ath11k_core_deinit(), which eventually triggers
>>>> ath11k_ce_cleanup_pipes() on uninitialized CE pipes and results in a
>>>> NULL pointer dereference in ath11k_hal_srng_access_begin():
>>>>
>>>>    ath11k_hal_srng_access_begin+0x14/0x68 [ath11k]
>>>>    ath11k_ce_cleanup_pipes+0x184/0x190 [ath11k]
>>>>    ath11k_pcic_stop+0x24/0x38 [ath11k]
>>>>    ath11k_core_deinit+0xfc/0x1c0 [ath11k]
>>>>    ath11k_ahb_remove+0x38/0xa0 [ath11k_ahb]
>>>>
>>>> Fix this by invoking ath11k_ahb_remove_prepare() before the state
>>>> check and skipping ath11k_core_deinit() when either QMI initialization
>>>> failed or the device was never registered. If ATH11K_FLAG_REGISTERED
>>>> is not set, core initialization did not complete and CE pipes may
>>>> remain uninitialized, making ath11k_core_deinit() unsafe.
>>>>
>>>> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1
>>>>
>>>> Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
>>>> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
>>>> ---
>>>>   drivers/net/wireless/ath/ath11k/ahb.c | 6 ++++--
>>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/ 
>>>> wireless/ath/ath11k/ahb.c
>>>> index fb5640882b98..7f5f5c8d7c56 100644
>>>> --- a/drivers/net/wireless/ath/ath11k/ahb.c
>>>> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
>>>> @@ -1265,14 +1265,16 @@ static void ath11k_ahb_remove(struct 
>>>> platform_device *pdev)
>>>>   {
>>>>       struct ath11k_base *ab = platform_get_drvdata(pdev);
>>>> -    if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
>>>> +    ath11k_ahb_remove_prepare(ab);
>>>> +
>>>> +    if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags) ||
>>>> +        !test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
>>>
>>> Can we use ATH11K_FLAG_REGISTERED alone to decide the cleanup path? 
>>> If REGISTERED is set, ath11k_core_qmi_firmware_ready() completed at 
>>> least once and the normal ath11k_core_deinit() path should run. If 
>>> QMI failed on recovery (say before FW_READY or INIT_DONE) this should 
>>> still do core_deinit() isn't ?
>>>
>>>
>> During SSR recovery, it is possible for a QMI failure to occur after 
>> the device has already been registered, which could result in both 
>> ATH11K_FLAG_REGISTERED and ATH11K_FLAG_QMI_FAIL being set at the same 
>> time.
> 
> Yeah so in that case current code will skip core_deinit() which should 
> actually run isn't ? Though the QMI has failed on recovery the core was 
> already initialized and should be torn down.
> 

Thanks for the review.

You are right. During SSR, if QMI fails after the device is already 
registered, core_deinit() should still run for proper cleanup. Will send v2.

>>>>           ath11k_ahb_power_down(ab, false);
>>>>           ath11k_debugfs_soc_destroy(ab);
>>>>           ath11k_qmi_deinit_service(ab);
>>>>           goto qmi_fail;
>>>>       }
>>>> -    ath11k_ahb_remove_prepare(ab);
>>>>       ath11k_core_deinit(ab);
>>>>   qmi_fail:
>>>
> 
> -- 
> Ramesh

