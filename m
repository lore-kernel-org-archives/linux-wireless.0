Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870023B42D1
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489861; cv=none; b=LLY9vFEmgzKcutCvv9eACM9HOFwF3p8dPD/0jw9NmRsfOlKpJJrrXv66ItmCm+x6O1Pnddwj/xEWLaB4jqkLpYP8W4rdBYRyhaFtTK6vrCJOR59CBWMmAD8a00lkWwULfNz7OyaNnsVwyP+GjsdYfHqf5/GvOwFBbkuKPzmwCX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489861; c=relaxed/simple;
	bh=sB7BIRVenuzSOGybmi0BrmfcROx6Sh69TqId644Xz9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N3e0ylHyoW4gwhIAH+obejx9J7xSSW8kjE4AxbR9y6/KWS96+YE4uKbXlGnqXEXQNOfVeEIVHkF39Q3VTlBdid4nNdDtT//XbDzjSDy2VQgF+yfziLL8J5Fe6cxrDb9r6/7u7yAM2+cMEzU8NgCEo6HtFHGeD7VVdgTPDRAoCDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TWXXb+iS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DmqY7mWO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TWXXb+iS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DmqY7mWO"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8n3Yg3993579
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fBbt58it9lwrasUx+0rlFP3m0rR06R8No8JhxzBeIV8=; b=TWXXb+iSfen26tuB
	uj2KnrebNi0K7q/BhhyODxFWBOBnF3sHx4hbpwk9l/vjl2RGPRdLk/ZWOVYwhl55
	W119NeQAhzLOzGIHU9FWJwNFNE/z5JMe+kjasnmbyf1Pra3/MYvx8Ob4iGst78tz
	UqpwcPKGlisdv98vdDJs/aiUxJW2icm7oX55j+bYq4FEGvwI0Ipf0dsyTPolSvZ6
	n1ebUKtlak9+i0b9lGWU8HWPdrMD93ldRwh9a9jZ+jfNYqt6f0BBx2/8BcUiLg1R
	CCTUI39YkjMa/K6IF2+wa87MF5CTox2I9jIr6Ae2wmTCDXAMPvisOr3odj1TrMAO
	Y3nr6Q==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frrhar4vn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:24:19 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb20f82a0eso1088686a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 02:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785489859; x=1786094659; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fBbt58it9lwrasUx+0rlFP3m0rR06R8No8JhxzBeIV8=;
        b=DmqY7mWOt5juJsAPG+l/wql5+Fj2QZ4E4F8QyiLZ5dnsQ6M2Q4a58gQL6u7+jNHUEF
         ZnJYJ8vRjVPhict3Jv5P0OHXUOdNEr7gDL/xzAI06T6DB8TUnzt/ZwdGmWKbSBkLbQbK
         7eclAHvbyD1Wmsx05j3n7SQzuHxTdQVk3/Wc6SHPDxpjJG2BWbTVuefjMrgsi5a3KXcf
         cntuBu+v7sY7q1mLFZCYotjEDSmAs2JsSExlYaNI/PCzQlnwV3tPYcfiMICPDhRwIt/3
         qMnAQiwqfeBsjxtyWY42GSdTKg2M8v3R+ZrLaqy+OZApB1BXSdBTyTK8CNSgPZ83oME6
         sk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785489859; x=1786094659;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fBbt58it9lwrasUx+0rlFP3m0rR06R8No8JhxzBeIV8=;
        b=b+kMNdFDfV7LeaNrB/3WLFU5BK0EScbnqp4JoJlga+lii2/q9Xu6iURl1LdVGq4psI
         gVdnUXoa8QglrpQ6EmPIaN33EktwjmEk1cKvofXEri9Ic+aPdK5vyAFEb9Kry8Hsjkxe
         9LHCNqwVGL+vmT2f1dQ3n1cAd6VZQ5b8FVz8lJCx/pGIEoIoIHNdpSbZTUofJMUiBLRr
         4N+di4x5NOqQsv+i40j2D7bDcO9V77D6fyi8n/ZaMzjXoEriBxgpux1I5+nuRKJKu5eI
         Zj8dIo73V0QnYfLSfgKQdEbbV3vdzcdM+qcWmFdx5Q1VfkTGip4j/xXOMPeXtm5oteHy
         xbDg==
X-Forwarded-Encrypted: i=1; AHgh+RoUuZtCWV4daLWVrmdUMnXpnAHuM7JXF3QJOrZ62PbH+xCqZJnbgUbHZw0AUllvXbkTV8g1IrNCIlM1LLk6Jw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlujgk6dTDjErPxulVTHUMulHfowUIpwUE8jOMJwCoi6uUdQHx
	5jyabGYis99OFiB1gKL4P6wpxGCsL/nVvZ/15KTTxM3MJAj9BRnpvHWd8m8FfqC4g5gnaP/UXpK
	eErWMGGPtWzpaXUkfRmnzzrBHR9MgJTFixOMqXN2OXHF3VgmbJuhG1x7aCRJXg4wocGiUHy7M7o
	84OQ==
X-Gm-Gg: AR+sD122T1JWB/HVnnnOi6npBa6H4vO7A4BBWnyGwGzmCcwnSDvQQQm6rS+s1J8ystD
	mTvGF08M7GChxNiVl9zJhS+/lInoY18AzOZvRJ733bgRSSwgu86XNg2ZQ4hm+xgLWO0tSbIQbhJ
	jWfl/1bpOM1ANFxhIlmJoRfxFxEExPK15CMJ9ex6AxZfxGOJqX+647cL17DtKicv5N223TEk/nj
	GIHbWvMGGLzs5wShqlzGIbvbvZITWGCAaHq5nB0UUQ0tGHUGZi9lGPidkqVCwfbiBc975hoJfsx
	7u5oLZ2udi8Tk19cVK3mKMvN3APiEMpAAx9dQCEPPDRkKX48DLVFyM3jf1w0OSsCx0jTcPxtucH
	FdZvZGs2G1cQk8b4ZUpCW0gG4aGfzmytbI+CwLNpW
X-Received: by 2002:a05:6a21:a346:b0:3c3:875d:704d with SMTP id adf61e73a8af0-3c91b267ba5mr1156595637.25.1785489859056;
        Fri, 31 Jul 2026 02:24:19 -0700 (PDT)
X-Received: by 2002:a05:6a21:a346:b0:3c3:875d:704d with SMTP id adf61e73a8af0-3c91b267ba5mr1156577637.25.1785489858618;
        Fri, 31 Jul 2026 02:24:18 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e06fe9fsm3355290eec.25.2026.07.31.02.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 02:24:18 -0700 (PDT)
Message-ID: <114b5ae4-002a-4f35-8fb1-0ebf44e9250a@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 14:54:13 +0530
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
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730030948.147892-3-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: q3DRyffZsgNxyo6JdcvMBdpq2bxk2o5V
X-Proofpoint-GUID: q3DRyffZsgNxyo6JdcvMBdpq2bxk2o5V
X-Authority-Analysis: v=2.4 cv=DvdmPm/+ c=1 sm=1 tr=0 ts=6a6c69c3 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=-97xbg0PSBK8MHoIRpsA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2OCBTYWx0ZWRfXzvuR8Ampaumo
 DIj+ZTtWfdWgpIosXFYtyR0kfEy6U/QI/MvnYqvgK8hbqHpSYEeXmxTVxTFxKuyXdqFtbzpLKhx
 ro0er6kmhiQ7KFdTp5VT4tFjCa/VSdNrs10hdXP8CnrixWHVcMi+BepRdKRackKWJ8wVED5d0py
 NRPsmKA8uY2N+rwovMioEKObwAwQdT7hb9aExSPGcuaL/0uFyXV4lkUBPbLuBCeMvu1q/vOHAjb
 ZO4+LQz7duEhRNKiDj3qsG/H5l6/HhcakdKvaDnhUuw9A3rmA02cnMl98bAn4gnJsYNehOA0Fbe
 0EBiCEnEgVdeY9+eulx5fv0KA4LLwZcyD0gU3nGXb4ADLfpU9/669M0YRZFlICB+ZIpeSi7/3Z/
 k9P8mTP3iLMcpvg6PxEd3hvqYBlLBiFhiBhQPhTLehsFtARnC7Y9zHTadiSyq82DG/pwzMC5BQ4
 Pt6WfFa60N8t5+rmHJQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2OCBTYWx0ZWRfX9W3iIEhBooXv
 i2UiIX+aTjcIUqLoH/rM1liEsA89TbbtCDRFLq7zmu+7wt/CBiN34MJUjUTGhVFhExA/6w8o6+d
 4fDtw3CRfty9sq4Euk80HYqeY6qq6VU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310068

On 7/30/2026 8:39 AM, Miaoqing Pan wrote:
> On WCN6750, if QMI messages never arrive (for example when qrtr_smd
> is not ready), WLAN initialization stops before the device is fully
> registered. In this case ATH11K_FLAG_QMI_FAIL is not set because no
> QMI event handler is executed.
> 
> When the driver is removed, ath11k_ahb_remove() still calls
> ath11k_core_deinit(), which eventually triggers
> ath11k_ce_cleanup_pipes() on uninitialized CE pipes and results in a
> NULL pointer dereference in ath11k_hal_srng_access_begin():
> 
>    ath11k_hal_srng_access_begin+0x14/0x68 [ath11k]
>    ath11k_ce_cleanup_pipes+0x184/0x190 [ath11k]
>    ath11k_pcic_stop+0x24/0x38 [ath11k]
>    ath11k_core_deinit+0xfc/0x1c0 [ath11k]
>    ath11k_ahb_remove+0x38/0xa0 [ath11k_ahb]
> 
> Fix this by invoking ath11k_ahb_remove_prepare() before the state
> check and skipping ath11k_core_deinit() when either QMI initialization
> failed or the device was never registered. If ATH11K_FLAG_REGISTERED
> is not set, core initialization did not complete and CE pipes may
> remain uninitialized, making ath11k_core_deinit() unsafe.
> 
> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1
> 
> Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath11k/ahb.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
> index fb5640882b98..7f5f5c8d7c56 100644
> --- a/drivers/net/wireless/ath/ath11k/ahb.c
> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
> @@ -1265,14 +1265,16 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
>   {
>   	struct ath11k_base *ab = platform_get_drvdata(pdev);
>   
> -	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
> +	ath11k_ahb_remove_prepare(ab);
> +
> +	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags) ||
> +	    !test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {

Can we use ATH11K_FLAG_REGISTERED alone to decide the cleanup path? If 
REGISTERED is set, ath11k_core_qmi_firmware_ready() completed at least 
once and the normal ath11k_core_deinit() path should run. If QMI failed 
on recovery (say before FW_READY or INIT_DONE) this should still do 
core_deinit() isn't ?


>   		ath11k_ahb_power_down(ab, false);
>   		ath11k_debugfs_soc_destroy(ab);
>   		ath11k_qmi_deinit_service(ab);
>   		goto qmi_fail;
>   	}
>   
> -	ath11k_ahb_remove_prepare(ab);
>   	ath11k_core_deinit(ab);
>   
>   qmi_fail:



--
Ramesh
