Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC7E2F90C9
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 06:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785739653; cv=none; b=Ru9qZrn1n24ZvXiVbZM0sX+doebsNlJjgGXK0j+FcnCukGraCbgVWofloUwpCFlrxgjw4nKthUtGP8MaEQprmrB5vV35huqXXtX9JNqu+K1UagFiDMEAfPHuPH/QRjzh6d4V6ytisgkrVa2l5Vh09+2+IIx9ntSwhgCVGgvOL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785739653; c=relaxed/simple;
	bh=7Rar9p8zy/XKOFE+ClxuwHy1EqGANRUWWRaGYqI8Pbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nX2/ligs0rZO2qCe3XUsbpaNVvxyDV2wrIZngRLyVAaQmFZZnQE2M/NJjv+mJ86RgQ9NaN1LcXj52ofXML9XJyP3F90A/yOCIev7IUEs4Rkj1oyeTutuDIFp+71un/4lM9uWiKo24c/TK29FvU2TZ3UxBkCX1YpJwslf0n+3Ge8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L6PHEK3Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D69G4TGv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L6PHEK3Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D69G4TGv"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6736SAxO250146
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 06:47:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Qw0W65FpIA946+bV4CaxyQ5WtsNBLoyMWlGxSArzdJQ=; b=L6PHEK3YJQdw3ylI
	R+Dbq3s1aGW3SsWmYtNA8wHdMqBDaUwbHc9+3CrppPyVLM6Zc3gK8N3bcsLdJUlf
	Rua6wPN3wQ9Wxni6X4l2izk/r2pYaES4P9ifBNoc95C5FBE6tklvLHe0OvS02ZSs
	eWrUwvN1du80Shr9WF9aphocQp3Wm0Q316OGPc9i/4i0qsBH/9RuUWCApG/vzfAh
	pFLVqZMGrddQwdithliac3tF7OsE1kug27WtEB2ALxJVT6/bzNWf831fuwn8i/2p
	z51eK1NQoMnjtrsNwWqe9tgiuMsKfqZGy4DZw1YJpgFVJzKfWgDANpkZxeE2nzMn
	emQ8yg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftnrd82e5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 06:47:31 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ccb6f6a3f4so41639645ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 23:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785739651; x=1786344451; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qw0W65FpIA946+bV4CaxyQ5WtsNBLoyMWlGxSArzdJQ=;
        b=D69G4TGvz2F6eA/3GQKWJHZNVq8hBa842Eo1vJfvXF8zGqULxO1Iqw4h+B/KsQWbF8
         Gr5gbewUfK5WG0iYKUBrDUXM7HxfegAnnNDc+7MX+mD+WIeQhE7PyBIQxzkPZ81+JsW/
         YP/wT6KBUFUqCIRD+8sF7ffh9D8WYLZDMhzWMApTuxKhhbNSwZ5HSC2eKNdE1o3oZsQy
         DFX70/Lq6ZiBFa5EoxVQM5AYzDpzmeqAfofJloPWCWKSXCnHXqczFcX/pa68qqzRtVZa
         zshivVkPYdydHcaclFcw9gDlNPxmKvBmroIrXFVWxceAo7U1oqjuKyUY9hAKkLLicMpo
         cr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785739651; x=1786344451;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qw0W65FpIA946+bV4CaxyQ5WtsNBLoyMWlGxSArzdJQ=;
        b=k2LrI31bh89TGD0aLkE/Y8RNMW/L/MXX0gI6zp6YWZhfcsRVbkMvxX5yQAQt5NMtHs
         uQTM+TKHLrO4DaEk8FjJBoA1CcTuGLkW74tcLEXllDAfcOauMpQBKcLYcw1fgh2MbYJ4
         Ayb1ce/3ch65nXEsmT6InI6KIuUd+M93xXSrzpD5hPcbdNhoA0bMNS//Aekn091U1fv/
         wFxts6hyj0NYLkBxcPpvFXSN06iBRAKceztU1djzS01jvtubPTNDvPm86lDTmR9QhDJ5
         buneKrQlXs8xtvp4gFRNrfRTaNt2TeNrbV0jim1DXmo9BGrNvVhLWQEFHdQ7WqwKF8n2
         3P+Q==
X-Forwarded-Encrypted: i=1; AHgh+RqM7W6o4VnOLaZYzGrG9ZyQ42+0hBrfrGEjCemhicRG9L43YeXXsKly15+hejEj3+a0KBo0apPyIchoKlrHMg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy8Cu+VnB2F6R6MN2npBpQN9pQjPRonWbq3cKgF5TgWaqdI+Un
	PrX8P+ZmewR9+p1Yf70JiLww8/GU/K+q0f7VXXtPykAdsIkO8hIY+ytg8L6wgxS9s3+J7Hzzm0m
	kGBSIIp32WVcOAllDJ4lT/cuBpwinrx4wakqjQKjQPOpQkwQb62OoKfZ9b+o/FJL5J4m6OA==
X-Gm-Gg: AR+sD12X0LARIerjIxThy3K/TcCvSR3HYJiBHz0Xb2+ora5GwE8w/ce3T51yU0exq6c
	uKvBFVnTbuMbsetfT3Mv1Q/XhMRwezwiUjHUm5kt+1eMhL37Wa3AguCGDfPNI5zZYkbbrGPIL60
	9Odw8PIoyFt5tI/2lHy84M9dIzkNlsar59J/hG3XlF0/0Zl16EFXmvDPXs+VANaciClljn3pDAw
	WOJvh9skA0Z91unP2lR1jpM+o5gyLGy5rqlBe4yGo0IWSMD5jMn1eyvMWfhp9B0Cw+33nMfMTb4
	gbFKrCbVufGpqu/sM176phBaBtScGruGnwLR5lnL7XRVczhb3yGKQi57MfbljI+mu0PZJjKHoer
	szHqer49FVpIkYSoMMjLLDeDpn8+MoA0rh66Bl8Daog0in2xt5F/WqYAXasj1MMzVyyT2GFQ=
X-Received: by 2002:a17:902:ebc6:b0:2c6:8d95:fd7e with SMTP id d9443c01a7336-2d047d1e722mr123426805ad.6.1785739651074;
        Sun, 02 Aug 2026 23:47:31 -0700 (PDT)
X-Received: by 2002:a17:902:ebc6:b0:2c6:8d95:fd7e with SMTP id d9443c01a7336-2d047d1e722mr123426635ad.6.1785739650679;
        Sun, 02 Aug 2026 23:47:30 -0700 (PDT)
Received: from [10.133.33.22] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5ac3dsm33274995ad.23.2026.08.02.23.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 23:47:30 -0700 (PDT)
Message-ID: <61e47242-7615-4bc7-af80-c671318b3c0d@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 14:47:27 +0800
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
Content-Language: en-US
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
In-Reply-To: <114b5ae4-002a-4f35-8fb1-0ebf44e9250a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA1OCBTYWx0ZWRfX9GsB3YgwZciv
 kzbfuxYI9uzTP/z4dUl3jM1iT9iXGBD7g6Xh11h+gyaBOpBQYOjRNh79d3BQ8XpYCoxUMdVfQu1
 xuCFc0t0a0sua8owQMCA09ed3Auc9D0=
X-Authority-Analysis: v=2.4 cv=f/94wuyM c=1 sm=1 tr=0 ts=6a703983 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=NB9-HOlxhKWhaxssQNMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: jvAcwCsb0WseWpD-SIq5yZBt60mGKfft
X-Proofpoint-ORIG-GUID: jvAcwCsb0WseWpD-SIq5yZBt60mGKfft
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA1OCBTYWx0ZWRfX4bExqbIgUWDJ
 r78IMX4+Nnm4ZapOMZ5q5W6oXJKFHtqcEetv1DRGuanqPgRmHyIb3C6ewsSYeUw7eMiFT93nc0D
 IkvCFsCvagFZXwbvgAdnEzWoDOwmFEcLqzf84qssQctU3NY923hxGTXix68G+CVEi+JxKOxuZTR
 f6vxuIh795RJzdAURbRLO1ZIjAWw8H371KIeqHJDaLStE0GGIi61WAM/lUGE4LcVWqe2RKnqvZ4
 FdhfzNv9VnP/9xT1/TWufg/Lndh/QGJfndUnBaEz8hExnYBU50ihFYqnwqUntvb4aMbRAX+Gah1
 A7zrGNg3HdTIG38iGAZoxhQ9d7LTh8rUdc7xo9iLrrfc3bDHqitGl2nd77HRBzRCAJpryGCAFkR
 jbifhe78hbTjWrLal46a5es+h5pagYXFJhP6qCXYe81HAz2xQneFF1RTb/KMe3KoFTs1o1kmPPF
 6N/7WZWA+KAMe4ChDlQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030058



On 7/31/2026 5:24 PM, Rameshkumar Sundaram wrote:
> On 7/30/2026 8:39 AM, Miaoqing Pan wrote:
>> On WCN6750, if QMI messages never arrive (for example when qrtr_smd
>> is not ready), WLAN initialization stops before the device is fully
>> registered. In this case ATH11K_FLAG_QMI_FAIL is not set because no
>> QMI event handler is executed.
>>
>> When the driver is removed, ath11k_ahb_remove() still calls
>> ath11k_core_deinit(), which eventually triggers
>> ath11k_ce_cleanup_pipes() on uninitialized CE pipes and results in a
>> NULL pointer dereference in ath11k_hal_srng_access_begin():
>>
>>    ath11k_hal_srng_access_begin+0x14/0x68 [ath11k]
>>    ath11k_ce_cleanup_pipes+0x184/0x190 [ath11k]
>>    ath11k_pcic_stop+0x24/0x38 [ath11k]
>>    ath11k_core_deinit+0xfc/0x1c0 [ath11k]
>>    ath11k_ahb_remove+0x38/0xa0 [ath11k_ahb]
>>
>> Fix this by invoking ath11k_ahb_remove_prepare() before the state
>> check and skipping ath11k_core_deinit() when either QMI initialization
>> failed or the device was never registered. If ATH11K_FLAG_REGISTERED
>> is not set, core initialization did not complete and CE pipes may
>> remain uninitialized, making ath11k_core_deinit() unsafe.
>>
>> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1
>>
>> Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
>> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath11k/ahb.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/ 
>> wireless/ath/ath11k/ahb.c
>> index fb5640882b98..7f5f5c8d7c56 100644
>> --- a/drivers/net/wireless/ath/ath11k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
>> @@ -1265,14 +1265,16 @@ static void ath11k_ahb_remove(struct 
>> platform_device *pdev)
>>   {
>>       struct ath11k_base *ab = platform_get_drvdata(pdev);
>> -    if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
>> +    ath11k_ahb_remove_prepare(ab);
>> +
>> +    if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags) ||
>> +        !test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
> 
> Can we use ATH11K_FLAG_REGISTERED alone to decide the cleanup path? If 
> REGISTERED is set, ath11k_core_qmi_firmware_ready() completed at least 
> once and the normal ath11k_core_deinit() path should run. If QMI failed 
> on recovery (say before FW_READY or INIT_DONE) this should still do 
> core_deinit() isn't ?
> 
> 
During SSR recovery, it is possible for a QMI failure to occur after the 
device has already been registered, which could result in both 
ATH11K_FLAG_REGISTERED and ATH11K_FLAG_QMI_FAIL being set at the same time.
>>           ath11k_ahb_power_down(ab, false);
>>           ath11k_debugfs_soc_destroy(ab);
>>           ath11k_qmi_deinit_service(ab);
>>           goto qmi_fail;
>>       }
>> -    ath11k_ahb_remove_prepare(ab);
>>       ath11k_core_deinit(ab);
>>   qmi_fail:
> 
> 
> 
> -- 
> Ramesh

