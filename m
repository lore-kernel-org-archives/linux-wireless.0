Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DE339795E
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 02:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068463; cv=none; b=MAOVN8w/5l1u5ekxvv2SShsUuK9UWgVRLBR3bEBi+xoL0mdPjR8pymznfl2vNujoCSftFlTOX3HBYeqbtgDopzTtgXTX0yL3wKeaZQZzMuOBKrD3/E3wBRFz6radwx7PYAodFH0EMHJU5PmYmIKgTtLcqNThpzs88hyKCb03M9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068463; c=relaxed/simple;
	bh=2mBJ4uI5LXwpIfvmlDr9knErCterNiRa1fIGLxZbV24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJ9dPzkonMWTdlZN4I0xQlZh/XUmIt9FDiTjRQTuHE8z8HP103xeE2FsnCSMsaDwaFho4C42OWUJjTuVXQBQ+O3W+3+u54N4BJm90YTuJ2VA6up06UmPfKeYdb1Rf3gPpLg+jgehe3MrZ5YslKJubg5JZsiD3W2ZC8S6b36zzdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NobmaMTC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KozVW9cT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NobmaMTC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KozVW9cT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770HBIv3478244
	for <linux-wireless@vger.kernel.org>; Fri, 7 Aug 2026 02:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GD8595lgSiHvhXviq07/tLE2YzvzMFQRx/B3wtsHMOw=; b=NobmaMTC1+uWdjvI
	Et7Ws7/nS4d1Vkvuk2b2gkadZKwVIcwtfTgRoY/wRYqn9NbWEwtsORVcWLLhxEP4
	Gcluz2GHkkiaHwYbZG0KO5lOFCUnVsj9TU6ktUFb4PTsI0sHL0izU/p0yMoKJS9n
	IJ88+XplTWohqFa/2Z8JfwcNwPUcLy3BhZ8MDIYt5itU8d9XQpxZOGNGqSKhJm10
	q1Kea82NLyK5j0lqwafaIIvXpq9zcBM6zq8VR+HfbrjuXOhZxzr4GHbheCAIXcJk
	biOTfsKU/ZClq0lmpGDkBZNShrGu/0dx9ij3U3W6l0Bjti5288tu4GwzXZEAhr3z
	Eb1lww==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvy6h9st4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 02:07:41 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6ef846b33so1245015a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 19:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786068460; x=1786673260; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GD8595lgSiHvhXviq07/tLE2YzvzMFQRx/B3wtsHMOw=;
        b=KozVW9cTX2gbZukzrfJ3yK67kuZVsQ8AOG83nWTpf2dTnhxYJ+cZbpzAjaLkpIy4j9
         eGM+YbUfTVGYcXUjrdDBzVW4mYk1M27+qx6pEwDKgTH6QVHM/8W4M2W97P1IADrV5ivp
         I+TUZuxi1Old7EQUetZWOxXufsMV7WPOsZbxneHN0tgsyZJ3J5fCZCR+8INx6/JP4Oay
         z3x27jqdgBdpBiDVDmtKG9kqYV0d/5rox8ORaaGeJROJ14heOCtP370hPJs/OtXBW/db
         k3hpdHR4ne8w9L8LSmqNnoZVTLJAX2/KgjNKepMyuz8naysOZ1YVSwucMrjCHGjl7yb6
         QFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786068460; x=1786673260;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GD8595lgSiHvhXviq07/tLE2YzvzMFQRx/B3wtsHMOw=;
        b=GKmTQtTGUXzVXF7Sk192DTnZnvfKnmjtDof7pS7mZyruZr+UyLPPr1hZeuyB4nHZiF
         SeyYIvj3zGmvnadIf23qiPT1jofreOGmvWM/LdG2K/1DxEgql8CgBqglVEfAh2ohslz2
         a6JL8p5I9929+PIIX/ld90KZzPnZ5pRZYoyDBmBxsdoZ4hX1CcK3+0iB2jzODPYyMxbx
         ld75+UouSeajQDWi9LFhuvOfWapLRwmoBEU/TsMNX8dhudd/PIW8ypSXAaE3D/13rXPX
         FVRdxI2Xsh0ZH0cVTeb3uivk3eZoejXCVl3NadjMJ31ZaB/QfnOSWGLz1iE+AaAPhWHT
         ILsA==
X-Gm-Message-State: AOJu0Yyrx7n+F6QKpvwI3sXe3rto12J3JPMiL18M8y3A0U0a/1VvQF+5
	RHEKyPo5qXUC/3x0TVBDGZ2GX//8DoEli1U6WN1wO2Bghk02qVq0ImSp5H9/eT3ZZb+Lk6m8PRz
	LDHkuOS7Q0kWA9jVw7SgjRx9io7KMkfdRDCZuYXGDlBwcnVHOnNeKhZDOqG1Y/+3lyWlu2Q==
X-Gm-Gg: AR+sD10FAzfk6fnqL5UiBAMOqZCoiO46ndLflVedX1PCfVQjv9IlDjXQxCmnng1bQUb
	jnzD9WwShoKwi7KJPOz0gE0MeapHAosZQ2HgSQXmObbCiLjfPKMXU8rg9rbsZmhdLMSywdhZX4G
	CbVE09wp2HxyBu5TxZclOYQm18DGpuXx7FoliP8PDWEJ2Haw0pg/52yJSjlG9putvRKC4V0DBnH
	guk9P9a5Lijc56UPwHnmSI+M+VH8wlaAU5r1quZ99zwm5PbZKmfl1j7aoP9jTxqFXLt9s3MLaMT
	DOkQD4Cvfj0NJSJmMgSINXwV8BwAgDCz3Bgd0qHIGvpLXZKYBF3zB0xTafvpGi5mJQiqYXF0enF
	fprI68EBAMUDQT9aogBMeY5zhIVnGP93is8GcxDdWI0x4Lb4F3C8LOteGCd2r
X-Received: by 2002:a05:6a20:9381:b0:3c3:750f:3cf9 with SMTP id adf61e73a8af0-3cb9c1a4e31mr13305970637.11.1786068460035;
        Thu, 06 Aug 2026 19:07:40 -0700 (PDT)
X-Received: by 2002:a05:6a20:9381:b0:3c3:750f:3cf9 with SMTP id adf61e73a8af0-3cb9c1a4e31mr13305901637.11.1786068459393;
        Thu, 06 Aug 2026 19:07:39 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb883d9sm1235955eec.15.2026.08.06.19.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 19:07:38 -0700 (PDT)
Message-ID: <34ab0833-45fc-4e21-bbf3-bc5a167d9bde@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 19:07:37 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 1/8] wifi: ath12k: fix out-of-bounds access on
 TX stats arrays
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
 <20260806132427.3704828-2-pardeep.kaur@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260806132427.3704828-2-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: of2WJqwgzY1XtD2NHoRcVc9cWeY-wusO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDAxMiBTYWx0ZWRfX/iuPfAkpR1Yv
 gDYhTlQTjaQG1Cc/oTJfFJ7DepGFx9M5tf5ot4DAKLLDTP900armoEF2vpqGDaJ07lS9xAmD1/9
 Pey3dDZfAz4GSVMIyQa/VR/vuQ5UN6CrorlpuP+1IH5vIzAkc9MXzwIbHm1eUby/07Ca22nKKRQ
 MhukoASSpT/VPFlq4iZpq/uqeOogKzDekQitIGIH8/COpFWpKQLZk3Z+e8ctuqe6Ms9PKsKjlEH
 GklihXRRmWgIbzwIUBG6H2m0PSriA4UYZUekWC/S98m0XcoMoJrlo0a8Nvp6A/v7yzdYGWCn0UF
 ec38h9/0ILOlz1KzSyX3cJ9ET84kFOZrrRi0KJfCP6QBJPjsnlWiwITp/PpkTKv7DHfXjD8h7oJ
 Sa9QI32hslaJptJ1o8Q/igTx5Ut8sT1cYeAIPAWBiKmvKZAU2yVSYj9reZrDNWj+5vdqnn+/2LF
 RUHXmhl2+GGCiiSR+mg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDAxMiBTYWx0ZWRfX+z3KApbMmw3O
 +QC95OHCICyMWe6Y5uqq+0rNnMJug2XJMuyRxIo7gMhcuKaW2A8dfF8omVpT6UQaCUdOCyuKO5p
 LfA0PFwI9I1dZUW4gEDbQ8MWZTTYSTk=
X-Proofpoint-ORIG-GUID: of2WJqwgzY1XtD2NHoRcVc9cWeY-wusO
X-Authority-Analysis: v=2.4 cv=MbpcfZ/f c=1 sm=1 tr=0 ts=6a753ded cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=o7SAn5tmqHmP8Y5xtFAA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070012

On 8/6/2026 6:24 AM, Pardeep Kaur wrote:
> From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> 
> The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
> are indexed directly by values read from hardware without bounds checks.
> Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
> MAX_TQM_RELEASE_REASON respectively would write past the end of the
> arrays causing memory corruption.
> 
> Add bounds checks using likely() and WARN_ON_ONCE() before incrementing
> each counter, consistent with the existing pattern used elsewhere in
> the ath12k codebase.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
> 
> Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> index 587d58eeccfa..632230e77802 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> @@ -582,7 +582,10 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
>  
>  	wbm_status = le32_get_bits(status_desc->info0,
>  				   HTT_TX_WBM_COMP_INFO0_STATUS);
> -	dp->device_stats.fw_tx_status[wbm_status]++;
> +	if (likely(wbm_status < MAX_FW_TX_STATUS))
> +		dp->device_stats.fw_tx_status[wbm_status]++;
> +	else
> +		WARN_ON_ONCE(1);

My review agent tells me this will now double warn since the default: case of
the switch (wbm_status) that follows will also ath12k_warn()

So for wbm_status warn in one place or the other, but not both

>  
>  	switch (wbm_status) {
>  	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
> @@ -984,11 +987,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
>  		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
>  		buf_rel_source = le32_get_bits(tx_status->info0,
>  					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
> -		dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
> +		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
> +			dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
> +		else
> +			WARN_ON_ONCE(1);
>  
>  		rel_status = le32_get_bits(tx_status->info0,
>  					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
> -		dp->device_stats.tqm_rel_reason[rel_status]++;
> +		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
> +			dp->device_stats.tqm_rel_reason[rel_status]++;
> +		else
> +			WARN_ON_ONCE(1);
>  
>  		/* Release descriptor as soon as extracting necessary info
>  		 * to reduce contention
> base-commit: 691e5e43b2aa
> --
> 2.34.1

