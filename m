Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEB34AF175
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791470070; cv=none; b=ZaZNBr4cMq+WQxKCNhKTyHKY8D+Fxq0QAGQpZnORSBHM3fbDEUvxNQuMe4rQBEYkXIuuQmc1eoBQR7URm3Otit4IKR1fPB+21itr3exOTUMDPQViCR9Fi2+v1cBrQxw7IZbRFQmLj/495hJ0mMygxRAp/BCh/SVTKeT92EXHqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791470070; c=relaxed/simple;
	bh=0iAvbfw7yOCsz7RUlTn0P1uzRogiLaZC6xmi+uboQL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Th1+oEmjZl+4TuQtP4adO2BDiWWJflDZu/D9m0Y/Ptjcqf1v+Vmi5FC+CBdFIDrkjLj281m+ANTfdz7nX0AhDFGG8odwM4fljR7TmZECAT9ykla4V81f6Cd/aP8b0wGgIrUchwlyd6uf0gjt1rG0aFk5MajsK+gaJpjkOpUL4r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fXf9WYo8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J6p5fayi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fXf9WYo8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J6p5fayi"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698EVQsa3121551
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 14:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LkP2Uy4v+MaznWGPgPFaft+rB/OWiWwtvQUiasO0HZQ=; b=fXf9WYo8d8d+SQUz
	gvYV2cDepGd/czjo3alOy4XjoCFPxdbyPPth8D/SCZDXI8zbH1yz6UGzVHfWI8Kv
	VudKWSYNJlmp2LiAA00j/9XKCWUhfjs1hzanJoJGy/0UcVZ+9UC8WpsDzSQ/vlcK
	MUxmfgU1IEyWyyxtLBZ3IOKWThK4qo7CU2+QOYFTSiAav/6T6z25NWT+j91paqvv
	ncBGr0x5nVrcgg7G+FAyd4jfIX8vs53gH/SqYx2D6mi85CLGg1Tzv+ZUiVu1aoKI
	cZZd456EF3/MJxW8desZM1nHoBYxUyFmJw65W7C1R4cojgKmzk5JQK0nSsq4UgXI
	RHPrIQ==
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe2udpv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 14:34:27 +0000 (GMT)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6e0063e7a02so6734627eaf.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 07:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791470067; x=1792074867; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LkP2Uy4v+MaznWGPgPFaft+rB/OWiWwtvQUiasO0HZQ=;
        b=J6p5fayi9qfI85MU+zrNTz2KM3+NQ0JjZTHZGysw+NJtJbPdoWFJj0XrtuznXaVrV5
         192iZEx+pOEy58IiP2MZbqh5+y/660ilDVnceYndvb0aLd1aSS2EpvSK8vC/PTagcugp
         vI+ww6LRIPMX+ejTMceFUqcC7KoSHlfwDcowAIDTL9eDPM38FeIjBn0TyAJBY+jt60Kb
         eq6ckRfA0YkswVPz+NpSflYSBqkIga/Ca+YMq+4lLNQffc2SeL0aGE2yiwKAT3sQErp+
         IB+a6GBDpbIYuNZIx2mHb9R5p3oMAKMjYTMroq3Ze+6cYZZYVmyAbwChjgiarJvjxhe4
         A+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791470067; x=1792074867;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LkP2Uy4v+MaznWGPgPFaft+rB/OWiWwtvQUiasO0HZQ=;
        b=el4AulvhDtVpPY/83xYY5TH0vU1ilYCh9LxdNrvPZnsCro4G2/7deqNVH0JS3DPc5Y
         rkX3uEe+GwOQziP49H/GDdnh+V7LKYzWUQp4ewmk/pKjilPOFFZ4aJ/uyaXuKdTDs2fE
         /TsC9NL2EvGOuGPYD/yWFa9Q/OF3oW96ji3pNRlFFVkuqhH6DTooQlFtxF60ykL1z4oB
         FJ+y8J7dlD3HCBi+mba4oCtSplR6tDQn8loCZxTS7PHRCB21UKj9Ybx8RNRx52oRFeGG
         7DKWtHAHiJSx+uq5EvmZurQtjpXACNq68s/C2R3b/LvUwrE2drWSsrOuBCPH+2ZCE3XE
         fL+Q==
X-Gm-Message-State: AFuF++m2eeoZOhsIiwRq7/j92dvKBz4GpiDn4hVnZPr15kwbFkoU5Wfm
	YG9Ai4/Sf0yUatj+CtHefYKAdSBuoZhgE+OJMI6m5ap+EvF/9VoNOeicYhPPRuwP6bchnBHsGnR
	NM03YtDJ6A61s5uI2BDLBVun2AL14n1P4D8IM+qV0aiyz29Hg7wISI17WUSi5O3vDesgIqg==
X-Gm-Gg: AYBFou3FwW51orrJFBp01cOdL49R/aeWOwMQRoRJcD6IcrwOPIJqz1vMbq0EEd/njxm
	sWj5rJnJ70aNdET3R5CCOcv7IW8i+/pLjtxCC8w/dPW23UFT/tGXZc3elk0CuiTQ2XBihku0i8p
	eFtVRGGeswvq9fkEH+yidDrHrTvZ5C6PxuSZyY4/9pICd0wYWEulkTiCWqHA9tnFUn/J4u51iZn
	n/xZloyFt6QBc+JKhobnoWPQlBtmp5kel3ytTZDwY2IzzplKu0d0u/+4EgxhxiVYy3CCIhp7e79
	Dho92cFD0wbBKQAwreJN720S9wgH3oLKVO5gtHp6OPHQy2Sr8kwszVF3Yz7b7aL6mro9s5Fiowc
	UYG0FhJvDkPP8yCOQ0NvnFzSc7Yi2g7Br6dgKpHq/rwhaXjDFOhDuvBUN1g==
X-Received: by 2002:a05:6820:1f03:b0:6dd:6d12:2317 with SMTP id 006d021491bc7-6e7a65ce8eamr5150897eaf.25.1791470067209;
        Thu, 08 Oct 2026 07:34:27 -0700 (PDT)
X-Received: by 2002:a05:6820:1f03:b0:6dd:6d12:2317 with SMTP id 006d021491bc7-6e7a65ce8eamr5150867eaf.25.1791470066608;
        Thu, 08 Oct 2026 07:34:26 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6e7947969bfsm4634414eaf.13.2026.10.08.07.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 07:34:25 -0700 (PDT)
Message-ID: <5f55176d-12a7-47aa-97ae-9a2ea071d815@oss.qualcomm.com>
Date: Thu, 8 Oct 2026 07:34:23 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] wifi: ath12k: fix datapath lookup in
 ath12k_wifi7_dp_rx_process_err()
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
 <20261008-ath12k-pp-v1-1-68f888cd7eec@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20261008-ath12k-pp-v1-1-68f888cd7eec@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=AbMkjHXG c=1 sm=1 tr=0 ts=6ac7a9f3 cx=c_pps
 a=lVi5GcDxkcJcfCmEjVJoaw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=4Fw9wu-kcVuC5YJyYxcA:9 a=QEXdDO2ut3YA:10
 a=rBiNkAWo9uy_4UTK5NWh:22
X-Proofpoint-GUID: MSrqxCfImlzgP5N7PmmDKY0s5rxhE9os
X-Proofpoint-ORIG-GUID: MSrqxCfImlzgP5N7PmmDKY0s5rxhE9os
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA1NyBTYWx0ZWRfXzGpJJ2KT7q1H
 lPTv6pgR3IMbshM07q2STc5DFESlAJCgBYpxLIGL4ibbdyPzhzojU8ONSUZEjJqHKoFG9Ro2MQR
 SACxjyn7Z9Dipph8NTi6Pm6E8TUja/g=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA1NyBTYWx0ZWRfX/Fyrt8IYPW1e
 B4zseTV+HqM66zw6ZxeUq79VlyajiAJFQL4QH3YcS8Lnhh0+6Flu4GXqC4HVEAKRLhoV+dHLNAy
 uDZpcm8XixWsqdgzDOC6rsKYTLrcVk5sCEnyTb9azYa2OUE/hyGpWXhCdqMp02OpehntdrhhDDA
 wDpxwu4CqCTZwrFmd0RUEZq9ZSiYOmzR7oxMoSnJv9OZc2NRJgJzu9jT5eUmUkDHXdcfehEx82y
 msbfk/SGmLeq+DseoAjhVr3Yhmuj/D+nuRIvE60NFOQEmGwQ+clB3J3Ti7t3w9gTfzCqhnuB89v
 3qkQSj7YJIqKvJd4l9jemS47kQ94cL+yjqG4wAUJ7Glp+IlHiGvKZrF79Q7Yohy/VQ/w84K19sx
 /ppYLetEFyAyOMw/6i9HuTNQcFJWtT0ekImoo9pnEU/ZPuZO3ngbFS9qwUzW6RWAnX4YFolT1FK
 EUE6ooIMI9DEk6X7DvA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_05,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080057

On 10/8/2026 6:15 AM, Lorenzo Bianconi wrote:
> ath12k_wifi7_dp_rx_process_err() resolves the per-pdev datapath with
> ath12k_dp_to_pdev_dp(dp, pdev_idx), using the local 'dp', while
> 'pdev_idx' is computed from the owning 'partner_dp'. As dp_pdevs[] is
> indexed per ath12k_dp, this picks the wrong pdev when the REO exception
> descriptor was sourced by a partner device in a multi-device group.
> 
> The error is currently masked by the drop condition that only processes
> same-device fragments (partner_dp->device_id == dp->device_id), but it
> is still incorrect and would misbehave as soon as that restriction is
> relaxed.
> 
> Look the pdev datapath up from partner_dp, as already done in the other
> Rx processing paths.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Tested-on is not an official upstream tag but is an ath-specific tag. There
should be a blank line separating this tag from the official tags.

No need to repost for this, I can fix it in my tree.

> Fixes: 9e0ee04f818f ("wifi: ath12k: Refactor data path pdev struct")

If this issue is masked then IMO we don't need to backport to LTS kernels and
hence should drop the fixes tag or add Cc: <stable+noautosel@kernel.org>

> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> index a32c804403e8..633cb91b9e5d 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> @@ -1536,7 +1536,7 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
>  
>  		rcu_read_lock();
>  
> -		dp_pdev = ath12k_dp_to_pdev_dp(dp, pdev_idx);
> +		dp_pdev = ath12k_dp_to_pdev_dp(partner_dp, pdev_idx);
>  		if (!dp_pdev) {
>  			rcu_read_unlock();
>  			continue;
> 

