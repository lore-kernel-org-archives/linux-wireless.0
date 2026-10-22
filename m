Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792634115;
	b=SwpT3k5EbF2SbqkE++fzxRr0tSsS/A+WGutU9gLP2139rFYZcpxTfvEZ9X1wtwueVQ+J
	 Bgo4dyLVflpQ87RW3vNj4qXRxIZ/OrSOX80zOOrzO8BgLycZCBQfrBYldh/7p2knDSTMr
	 9TzGLGoi3GYMSREda/5wiEfvxAfMt0tt3NWR1PjuCOVkrFz5HGFuR2FHO64etczV54SFi
	 L/ue6SLhPwvBO+LgEjZfSliqbQc70IHN28aOsD4JlXhSPTnAjD274i3+8FJj7MZUIVHCa
	 LT3wEisb+dz0L2r4g9Wij78XF1QvgxOEoyqf8cLTiJ919SQFyD6hQeUixrGxBwFaDMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792634115;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/kyJHXtwMquLIO/WZE44AGG8CwDkp2gKhuwbsZ0JjBo=;
	b=npbgzk53zMzmwyvR5kh0wb2is224dpHj2eUGmcHWHVUhPwQoHBUwL/39d/jQx80NuBzz
	 XpqPI7OCsVTANmZpTSJdpP2NIC89VkfQlmZJ0EG8lfm8SgyNbope/c/YJOJ5McGvABvsr
	 kvj1ukzQmmGi+lAe0heuGwGkySYj4cfUuS1sh4gkkTY/L463vnLzF9QR+Enh1MnViVVgg
	 0ym4+3r5mED7uy3Wxh4fAlIXc8EtzGTxmWcbc9CqHxm8Rtuj71727sChT2HNGspmcNBbt
	 L948QU2oV0FAowF9cWTHS1r3C1ZfAHbklx3IE9NYPGCg6khxb+jgJWAzcpTLRJIT82Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VXu1HsDp;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bKxFyM02;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB732606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 01:55:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB732606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VXu1HsDp;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bKxFyM02
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M1iIKm3411897
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 01:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/kyJHXtwMquLIO/WZE44AGG8CwDkp2gKhuwbsZ0JjBo=; b=VXu1HsDpxucSwKvA
	oXY86BlMf3HXMDHeoADE6kXGfdLmNrGr1md8hQTvOjKrkJ6nlsd5WnFWz1m/EOwY
	lebxhpOH6H1qDT6rcTNLSWIyjEfZUkHbClGqh7zHeGM0ugETxJtW6zRcCmoVC7+Q
	YZxiL/Piuselb1g05ggxVZMDtQxlywOnGFnDdhXYs2yHs/4LHa9YCRbiQpCVoDmA
	NuzTcQGhD9XRXOGI/Fv4NKPB52MoX6/KjvjEWmMzxp56NHSFlSSpiESA1PzhR/pR
	Uu9LbMROjg9CsZuR9e074ZUrN/Rf5wbaUOy7MABD8vdjy+jt+mwc/wO9I+T395f6
	fvuXJw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93ag2qx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 01:55:14 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ac6795617aso1174046a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 18:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792634113; x=1793238913; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/kyJHXtwMquLIO/WZE44AGG8CwDkp2gKhuwbsZ0JjBo=;
        b=bKxFyM02RB4omEtbB6Pdnn0sxOVB+DziKlo1lSPIvEz+eMLCJZ33xp4+HqBID282Pf
         hsWvSn8Nrxde8irF7nxNA0J7G7SNsRET3Ri/znQuuDV+HkXwC00CjfjGA2uFTNmF2sT0
         g0MasbNi/amwgVJK4zdMx8+uKO1o4B/GvBblApN7lsEh1jjAGcytU9d+kHAcgbFxvnHb
         JrQ54UXDM9Lvwm5NAa3KOAHXeI4inYqSLbxXRaZaUcrfvXKx4QUiyYVBfBsBROViQNjH
         vTKGtFfBgMqJXRpO34KtJ/pQeoeK6TfdUmGhihvuEicdhievcbMOZn9uNRJk3yoWGrrh
         L+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634113; x=1793238913;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/kyJHXtwMquLIO/WZE44AGG8CwDkp2gKhuwbsZ0JjBo=;
        b=g/ZGh5woCzOsi0fedazHwvMRd2MqoLWqMr9r8TcbGtosXOXtNilCzBqmTGwseNl48K
         HMzrfadowWtMhktTKmpN9erCzuohGZVp41R2+/7eL3fCYzX55uRn9hLFprLCxMimF4BG
         ZqvnTjW48v4JsjP+Cqh2GljgVgYklQ7K7hpaQbfBAEQDPn/IBBHHp/NlV2OAvoh4hFY+
         l6kDrhwuo5UFnktVZKw/NLlLiutrKaRJvL+yP2GSwDovN1UB/+jGfUtrtmzrRHSuS0pw
         cZHciI9+pWa8wDzW9eBr9jW4pnk6zBMmWGTM8CVWy8qqrAitdeOCtpUyTBsHR+Px4GH0
         apwQ==
X-Forwarded-Encrypted: i=1; AKwUvBxtaTyKzZ9ev13GAgAVN5kxbgJ+pW5Y9FOz78pRgJR8eafZ9VMg6gcquUDNDu2l06SROUqrB6/Qx7tULo+KoA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJj21GoAwZSsc2h2/00pxXPMHq+/oVNvaCDumXflLBx7yB3X0rc
	vkY+u4guyHSzq5I4yvhwF7V5K6AGTnX3d4EWqaLUI0u/2PnZ5RjJGvnWjANB9tUNzhiqEGl4FBU
	DzmMdFC+BHyAFy+ARECwxEKAbcNJIqXe7u/bNipCXr4MmPHBsrPLXhs8Zj3km3zvTq/0KKw==
X-Gm-Gg: AYBFou1gHdrQ0OBAnWWZXMh3bLfVCPOlrM/pdwhkslSAi6C5zkpdkM1nLDkjUMzzaBN
	SY+uvAjqfsaVTbHpw8lFA7UNCrOBY79n/dPUlBCS0F2xjQN21Fd/HQX5NQDh3QepqLWRleXFhoj
	3p0iSEZMYhDeR5OL7H/q5utjkTsy9CcYZ3rtu5tLnTnlqe68FNLvWsIJKR2wa6VTIzH6/XKpdyp
	Qe7wq38AByeKoHATs9ZlGGChTUArB9Zg6Wno1fTn+n9AVCw2yuck/yQOmr3TRqiz6bXv1ZO1nyl
	HMnAtPJ2ENtm+rFDhbCgoIAUUy7UxKQhAvVlKPBYjTf3035TiAe3wlwJ7un0fBd5ODmpZIHYWuH
	KeT/bNNuJEdxD0afKTeBfwJ2VSun3Ly9yD9mBTRuTRZ3s/JvqGkR8lSijKCVnD50TVAo=
X-Received: by 2002:a17:90b:548e:b0:3a8:59d3:530f with SMTP id 98e67ed59e1d1-3ad86f23619mr3099482a91.57.1792634113346;
        Wed, 21 Oct 2026 18:55:13 -0700 (PDT)
X-Received: by 2002:a17:90b:548e:b0:3a8:59d3:530f with SMTP id 98e67ed59e1d1-3ad86f23619mr3099454a91.57.1792634112731;
        Wed, 21 Oct 2026 18:55:12 -0700 (PDT)
Received: from [10.133.33.35] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad85f9e392sm2529254a91.2.2026.10.21.18.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 18:55:12 -0700 (PDT)
Message-ID: <25cac2ee-7696-4da0-abb5-cde8a21dff15@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 09:55:08 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 6/8] wifi: ath10k: hard-block the radio when
 entering WEDGED state
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
 <20261021-10k-sdio-crash-v2-6-5df80bf16e86@oss.qualcomm.com>
 <CAFEp6-0WLtOCGQbhybo21WWX_ZbE6_nRVQLq-Hqddc-+Vvvafw@mail.gmail.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <CAFEp6-0WLtOCGQbhybo21WWX_ZbE6_nRVQLq-Hqddc-+Vvvafw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAwNyBTYWx0ZWRfXxA5mKZSvEi11
 LjnknSWPlWOLCBlMLhhzdyE/BwAmyaFT86E4UNIRcDwFXZAUoZxZgZKk/S/uegmFtuxR88OEgll
 iHBe4qJqGAZk5AvkjfWKgoJxQnYRGpBsc6C7YPNEmyu7yMHbwdnKmDLcxFWhuKIEjctzEAhgFsv
 Lor0UPIg2wZfwRPe034xKWVJYpPEWjJMDAPT69Tla25gGbg9FQs5zGLrrJg3OLoe2/7tY55i605
 vx1MV/OLocp7UHDriq0bt2li21XYMzXY2Ri4tG7voX43jidr6liNax8qjNR1V76hgDbxrMdAQ0s
 Agp5HJaz5odrgojX8AksrqfCElaL/SNRfoInEHCaOPtGosi8I1FRU/21hLLORUkzJTQuMFGQpu9
 4mD+MShSWVbrNf9W3GPjBz5XkvCeJrX/97Vk8hR5eGOTCoE4tmB08SLE+9naoP9N+qG/q3UW0kQ
 MhQirzM9e8yMnuzCAlQ==
X-Authority-Analysis: v=2.4 cv=H7FOUOYi c=1 sm=1 tr=0 ts=6ad96d02 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=ygjDnIpqFwOlN7mGrjAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: g57hpTXhH3IotqQSWzjJuKIq_43TfSXE
X-Proofpoint-GUID: g57hpTXhH3IotqQSWzjJuKIq_43TfSXE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAwNyBTYWx0ZWRfX4yKvcd0gY5px
 XQDnnq4QWcsvfuJVATQ0I9lpZ9aywTLGMbTqeL7jb/CN9wn+rZMer489Ie06gEXlQ9pU5dIqrSl
 36uLOu275rQC/j83qsR6zwKLYYRG30Y=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220007



On 10/21/2026 9:54 PM, Loic Poulain wrote:
> On Wed, Oct 21, 2026 at 11:10 AM Kang Yang <kang.yang@oss.qualcomm.com> wrote:
>>
>> Once ath10k reaches ATH10K_STATE_WEDGED, the device can no
>> longer recover and remains unusable until the driver is
>> reloaded.
>>
>> Userspace daemons may continue issuing scan and connect
>> requests, which the driver can only reject individually.
>>
>> Mark the radio as hardware-blocked through rfkill when
>> entering the WEDGED state so userspace stops retrying
>> operations against a device that can no longer operate.
>>
>> Both WEDGED transitions already route through
>> ath10k_core_enter_wedged(), so adding the call there is
>> enough to cover them consistently.
>>
>> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
>> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189
>>
>> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/core.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> index 6b6b80242cd1..66585cfa6d96 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -2521,6 +2521,14 @@ static void ath10k_core_enter_wedged(struct ath10k *ar)
>>
>>          ieee80211_stop_queues(ar->hw);
>>          ath10k_core_wake_all_waiters(ar);
>> +
>> +       /*
>> +        * Signal the radio as hard-blocked so userspace (e.g.
>> +        * wpa_supplicant, NetworkManager) stops looping scan and connect
>> +        * requests at a device the driver has already given up on. The
>> +        * state is cleared only when the driver is reloaded.
>> +        */
>> +       wiphy_rfkill_set_hw_state(ar->hw->wiphy, true);
> 
> Using rfkill to signal the wedged state feels like an abuse of the
> interface. Have you seen similar handling in other wireless drivers?
> Wouldn't wiphy_unregister() be more appropriate here?

You can grep with 'wiphy_rfkill_set_hw_state' under 
'drivers/net/wireless' and you will see dozens of related calls.

We have tried wiphy_unregister() during internal review, which will 
generate a lot of call stacks(more than 20). wiphy_unregister() will 
call into ath10k to perform many operations, but at this point, the 
ath10k driver is no longer able to perform any behavior properly.



> 
>>   }
>>
>>   static void ath10k_core_recovery_check_work(struct work_struct *work)
>>
>> --
>> 2.34.1
>>

