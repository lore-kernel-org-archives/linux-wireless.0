Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07621381AF
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785092501; cv=none; b=by2pVAmMy1ipwypQI8214wZvRESRq2bZXE1pXsdzkI0e8FJ0JuBphJYQMqlvaH4AAVL49Y1elsgT4F72yb3Wyew5Qyfm+5xSsP/VfZh+FNIj1jnGh7wOHpolN52JdKlVplPfPFtOK6HmtAc0vjN+EYvCEY4HHG44nKf5O+mEEQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785092501; c=relaxed/simple;
	bh=YXUnOyUZnOFuiy9tbyqWaFjoL2cwQ3jVk+Hm7lKFEr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CG3rZIWR+LsLXnyRj5sTOFTXqoHUtRAW9uejyU5rYPq0QqDk2o4yYtE4sGcY/H8LiRtHoMbqjKzfo4UJJ27SmrVPtcnXpV5U9Ia2n76Av6k2uLUsQCqnOBGYNewJfg4DNr1Fbg2n6UHIjRiFdWNe2DDIO/bp77sEpzAuW+LTum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Xr8lNFLn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VuFT2wv6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Xr8lNFLn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VuFT2wv6"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QH70sK1090696
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OM2orbDlhm3YFBnFC23eCT4mEbL7eF4VVSgAozJISpc=; b=Xr8lNFLnvxzkR+iy
	GI4sfS8o+cb5oCdIuAQvbkpkFIHauKzdfjbSNWEdu9r/h7MLzUlfOZTEWGBqbo6V
	JjOCV4j5co5OUrP2CO5YhFPkNtd5TYSVYRpo85xtXOYcnGjhMU1pHE6DetBLe8xt
	VwI5Jz3KoSCu3ifyqmMb8OgLbpWAPrwQ0VW2YUPnd/cZrgyMZhJeDI9mY+eVrJ/P
	LwKVv2749D1sIFFtoMtf9HKM2lrg3t7vFiQTQPoHR+gjyKnACQUxnzQ5PqbW9n/D
	gY9jhOFitUdFq00Y1Cd5LEgvbWQ+EBXk+QsjF9ygqMEgL2vjt2HVuNoyyWaZOt6S
	1aKlHg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnh7uget-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 19:01:38 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cfca8558d2so28434115ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 12:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785092497; x=1785697297; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OM2orbDlhm3YFBnFC23eCT4mEbL7eF4VVSgAozJISpc=;
        b=VuFT2wv6ZRQ3eOSBO29Z+0TGVZiM9C6nH4079FO6PLWVi7oJ98BBu4QknrXlpjLDeN
         5MdsXtqh/9sHfzBToSvoR5yPLptrZHEGZWCsT8t7tfUdpfXx0IFV5x/RusTwYUj/bKfz
         jDAvJBddEza1KUOYTPPxeizJeUFS5Tft78RDT+iLgpr8worV5RAT6mQjClGL0YBxwP27
         Yna16eUyOIi1m7qTv8LacGHVyJPSJ1RLTtXLAn2C08yfAiNZLybqFp33ihiUAs9TG8oE
         Yw6mC+ZvmxQToXrtqyL3CT0M+aTK1ESw9AHzLL+2d/OGWH1eSIvwkFcVn7ZkBuXeHNL+
         ovqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785092497; x=1785697297;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OM2orbDlhm3YFBnFC23eCT4mEbL7eF4VVSgAozJISpc=;
        b=bURq/QLDpwutAeoIJg9e2v2bePe2HmKuK/9Lg1+V6VklbpMPFTmg9HkTuBdb7Elsr6
         zCaKc38pQl7cfJ3qidgAFu8/VUDWBE2RM4ueYeOwku8Jji80Kd9qXju7hsH3CF7wN6qC
         4zG+JQBV+TW+4hgx0rbmZdegTfgkCTdvQN/UIy/imjjqlaxXQr7hJLwoE5eZZBoOM/lz
         mBD+U1TBoUUoXU/TP8JEzYXOY4dJeavk3MnYPk3fLCpmSkaN3gM4nxczYzidakPpd8aG
         puWU5hD7WjVUH7rYIeC8PfcOBHLpGOQTtTcqQgvt5YwIuD4A/CX/SDZynKlZDMwU+VR5
         /nXg==
X-Forwarded-Encrypted: i=1; AHgh+Rry2BZgyufeNrKtyhdh+P+qt1AAiYaqBp0tzxQdpikfdQI2JvkGX9F/fiCp/2JTkKU6XR1LUkHBC4TGwoT+Cw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxo0djrcLwsVR4v354cVx5gfzeoWq3+n2/RjJ2uu8ViarOtAs4
	mh2yXe56xW9RrV70kIZG25Y2MeZwUqmSRokrMk1fkvUuTKpHOtOaQrrV79ETFidTqJBRwGalnh6
	b6wQvVzKcv2qKEYk1ks+1uWBbQNhPjOL8ixJG/nay6kvFmAJLNnDzG4B4GOd/bmaw/Fd+Pg==
X-Gm-Gg: AR+sD13UoMGMJGYQdHRkLP9mVa3fsKtFMJHY7DFPHDTRz6nYmLWNiIKWHjMmXsr+zpy
	RNBIT6GKudn2/FUOXrrn9yzr7+AyF+4LxDNFFX90fQjvX6JlonZRcxzghrXaDc9ZLgwZoocZG4P
	nJ3NgKbM3RntPegWBSlxvvvdcshsR9vYU+v+Vke0S4jlEFjEMo7GHasVhqjIBYvXZIJTSt6DhoY
	F2phIKDEZJ+tc211qABVQTYqcdKeU+pLOVn7X1qoCw0lQxGohO9D9I8KmhRuFxsar2GjT13KgZa
	z004+3iYiW9zliTPH7Q8/bc6GjZ383CfF0GM/GjqWk+9FZr1f+gxGn+n2UamxjFk6imofQR2yij
	ARvQmtQA5gyjuwj2iCex91jq70vwlCdZ/ZfTqqewOyoykz7sOWB9YTG9FpA==
X-Received: by 2002:a17:903:2f84:b0:2ca:2079:91cc with SMTP id d9443c01a7336-2cfde6880f2mr55129285ad.5.1785092497619;
        Sun, 26 Jul 2026 12:01:37 -0700 (PDT)
X-Received: by 2002:a17:903:2f84:b0:2ca:2079:91cc with SMTP id d9443c01a7336-2cfde6880f2mr55129035ad.5.1785092497145;
        Sun, 26 Jul 2026 12:01:37 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc548f5dsm27133333eec.17.2026.07.26.12.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 12:01:36 -0700 (PDT)
Message-ID: <16ae1829-1d0e-4006-88bc-5dce2d935415@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 12:01:33 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Julius Bairaktaris <julius@bairaktaris.de>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Baochen Qiang
 <baochen.qiang@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
References: <20260725141757.1316877-1-julius@bairaktaris.de>
 <20260725141757.1316877-3-julius@bairaktaris.de>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260725141757.1316877-3-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Cvy3DXbzKKrfTuYbBAuSb6duqz001iPY
X-Proofpoint-GUID: Cvy3DXbzKKrfTuYbBAuSb6duqz001iPY
X-Authority-Analysis: v=2.4 cv=f/54wuyM c=1 sm=1 tr=0 ts=6a665992 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=ZkeNHXiMe5RA_guOz-8A:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE5MiBTYWx0ZWRfX3WAlrtsYghgP
 tiFEtUUfmuIsgdBEwy3Fra655cftU6BYgnOQ/FPSSiUY5OPRfJs5w+EAjUlAyMfyVA1LhboA2Ks
 qjpdqDpyjpWL2p01l4lkN6F1vtOgCqamsvEcHpdkjhQNDB3pXo56Qi30G7iS9bhl85pjlVdTMTp
 QbkBPtd3ipmZ0oJVl3hiwmRjmSch/9cpJZ9EJ6g2pSgKRvH+Tzi8t5feJGb6i1sWEysk7lf2Zb5
 GIeKwG7UU93K3dTcQkYP74xwBLnIS1wo28vFmL0BpVshdzmCDB1GcHmvwpg0NjoG1NzZ6L3P17z
 9VCLmHHbjQ1Pk3a3op7RLzceAPA/eVjKKcJr/BtSuUeY4e43qwzlgtjcdncf55KQqbZnT348ESY
 JQzKCeheoINyCDgOzHfWSxIOag0PItqNR2RDp3JX2Han/by+HYwJ9UT7ctCIpE+TuT3vwUFR2PC
 tsPdcCsgmpJW7lgn4Cg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE5MiBTYWx0ZWRfX8js3KPwPLwrS
 wwWd4cTiv0G1YQr2UstW2vABZrBCdi6c3EHIBZcgqkT5OeD4I0RiXQghmbpMB+b11PZ/jlEzU/8
 UHCrbWQE+sOWyNUlhfA9VmxIuXnGNio=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260192

On 7/25/2026 7:17 AM, Julius Bairaktaris wrote:
> On IPQ8074 a firmware assert reboots the SoC:
> 
>   Unable to handle kernel read from unreadable memory at virtual address 0
>   pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
>   lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
>   Call trace:
>    ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
>    ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
>    ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
>    ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]
>    __napi_poll+0x38/0x188
>    net_rx_action+0x120/0x2c0
> 
> ath11k_core_reconfigure_on_crash() tears the data path down with
> ath11k_dp_pdev_free(), ath11k_dp_free() and ath11k_hal_srng_clear(),
> which memsets the ring list. The DP NAPI is still running while that
> happens, so it services a ring whose address pointer has just been
> cleared.
> 
> That function used to disable the interrupts first, until
> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> moved the disable into ath11k_core_reset(). reset_work is only queued
> from mhi.c and from the debugfs hw-restart handler, so AHB parts never
> run it on a real firmware crash. Their recovery goes QMI server exit ->
> restart_work -> ath11k_core_reconfigure_on_crash() ->
> ath11k_core_qmi_firmware_ready(), and nothing disables the interrupts
> anywhere along it.
> 
> Disable them again on the crash path. The reset path has already done
> so by the time it gets here, hence the ab->is_reset check.
> 
> This is also why the debugfs hw-restart trigger never showed the
> problem: it goes through ath11k_core_reset(), the one path that still
> had the disable.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1

nit: Tested-on is not and official upstream tag (it's ath specific) so leave a
blank line between it and the official upstream tags

> Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  drivers/net/wireless/ath/ath11k/core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> index 8039124e7832..8c24fc8828d5 100644
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -2334,6 +2334,15 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
>  
>  	mutex_lock(&ab->core_lock);
>  	ath11k_thermal_unregister(ab);
> +
> +	/* ath11k_core_reset() already disabled the interrupts on the reset

nit: networking code no longer uses a special block comment style, so this
should use the standard kernel block comment style with /* on a line by itself

> +	 * path; only the firmware crash path reaches here with them live.
> +	 */
> +	if (!ab->is_reset) {
> +		ath11k_hif_irq_disable(ab);
> +		ath11k_hif_ce_irq_disable(ab);
> +	}
> +
>  	ath11k_dp_pdev_free(ab);
>  	ath11k_cfr_deinit(ab);
>  	ath11k_spectral_deinit(ab);

Do not post a new series just to fix the nits, but incorporate them if you are
requested to re-spin.

/jeff
