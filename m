Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F6123ABB9
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786327604; cv=none; b=oOC8XnBD+joFG5TBYBHVEwohr3RXpiWCdKR4ioSME5S74nWMUsZZHy5M+H7clOYqUIgRq+hpa6xLh7/2QIEc6ws64WQLVan90eZ0m2ER81rwxKmqH1gjFcA0SAQE3NFb29+9bi+nB40IdbPVGvwMg5zBwRJ1sbIpi2D47EwiJSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786327604; c=relaxed/simple;
	bh=HKhEGlRWUoeqOeWPostcxDGoh/+KZcQ0ItkYkN7/kZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sHR1zveDjAZTlN41GRysKoZctBD522HYEtvaI5WI0tR8NQ/98MADDqDPL025GQ3lcIr7qpiiyoZIS7R2ni4zn2QniYLoxp95XexpuCSOs764AhI5FfbG0OQ2RIMiHBkX7zFeuln2HC9yw6D38ReGFwyTXFZov3ijXWTkJoJKwss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XPpzjKOn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FNakcnw2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XPpzjKOn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FNakcnw2"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679LECCs761149
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/PxKp6PWvSiSLplxnSx39IQh9eiIjjfLviKP4m50M4I=; b=XPpzjKOniF2EFRtC
	Z36ldXsA54iQArrIi6hniej5c9izgwo1l2EKubFAL3SXtUlGnK2tvllDnnGp2oYh
	OdClVHnzsN9BsY1muRd/V2fbUEjnYa33FzU6W8G9bJI5QdbNZzSlFGzdSQaIymoi
	V6hIaWTIyv8egFSA3xkIAwpH8pamRxHH8AzEYDwiHdBCkIx3ARuJPqiQtji+j8Ac
	I5k9OUSYNv/pGt5w8coP4wvKfvsmPCci51y0zAJ7oTK92RXJR0BJzjaaz5a+joFX
	vDmKCMYGNHKfgIljF+KzjBatqqalKuVx63vspKuwWwe4YdaUT81H0VBpGJjCbq/J
	ZUSXaA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy19kge0m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 02:06:42 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dbf293831so4106421a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 19:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786327601; x=1786932401; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/PxKp6PWvSiSLplxnSx39IQh9eiIjjfLviKP4m50M4I=;
        b=FNakcnw2gS9ddJyCrg7PzqqLUzNDQ5nbROVX4xvym9pS9xXwqVJkZMEbpm7cXDfSgu
         zdUaOI374knHQzFrKf8eBBvW1SBneahFM9r9oU5AdgnXIfcACqxaNFatZU/tQbBHvAd8
         BG8edTcTsaPgm8AvOJGvq1SJY8uy4gN+3lG/R9QNRKJLfRoxKOrX2s+8miwJkNwhq9LI
         b70c+jQFjK43oc/8+EDWjGfVyvpczCjm/Wl4Kr/mQ8yUbD4pEopGNiRcGZsIvLcX/0My
         hI45TyRv/a0xDZsMbhpEp3L78qngG3csAJ2w0rGryEiOp7B/iaD+dK+Z/ydwGVVan5ER
         9djg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786327601; x=1786932401;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/PxKp6PWvSiSLplxnSx39IQh9eiIjjfLviKP4m50M4I=;
        b=tGfhgXZeToc8lyKzYWyA2MmXwQAR6fxkIliB1IcAmVZYDM3UnFgxa7gDbGelKs5Qr0
         Uqtov0QI1k0qK++HdvsHUN1wVMcb2GKXPvZOlTCq6X6UkxycgOQsAa1H/zflHNYRtCpI
         UsyQaB3/NQhoNSTJ/cCahdludFm5cyVlqIVI2j8CwCbsyiBILY1uL34hR8IhzjRUtFDa
         OrHP16IXHrkotzAcyTxm9gQ4alEYgma8bxjKZhrvxazdOOKAbrUYLveMEvFut1UB9wzU
         RFqVN8Txr13qCF61mNdM+PLh08PAu1w7L+X1Ndkjpcz2SEC4ElaS5+o6zlMH7uNDcf3r
         R1rg==
X-Forwarded-Encrypted: i=1; AHgh+Rq+7rwNYpaViUGehyz30T/R0bQ4POIX7NoLyxfYz8bUajoyNuLM/sAS9HcMo/j4QdhzLaw3Rr1FRNr9+kHREw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuPxQ3ZJU/E/oD9f5hBJLnM/4kmJfnO2459W6yQ86b87yEewVb
	dbhO4ZFfWV9tHIc1Dz3MVbx7ota7Bda4CxV0NgUjKeTgaAct/Es0KerPJ6Rw72ivvdGoVPFq6tY
	rX8wxFlDqZ4kBhEdS3qWtyw5YXFWpi6t/l9X41lWpHlttQO3xqYS2VLgELGZaLIXhr9Ok0A==
X-Gm-Gg: AR+sD13Xy1VjkxgUAfb6RnHst4tJ8vDd9QDNyJQv5OiF9FWyUawRkorC32sjRoBw106
	G2eW/IZuVlRl/Ei8KyPU+BMFnAeGOEXoz/l/PDHzx8cL2fD8KWlT8K6ivoB4tbTAI1HrOBBQC8y
	RJAjapdFI0i9LtYwbK5ADFTif8OdZCdmcVzRRwUMUN6oLXXAY9f9+rLZDk6hmVblXZwghQmb1ON
	RfdFEIFxU11pyLE/Z0MauNQMnp8cdfjHePn5+nxtjNJtk4Mfwg2sJtu9kdC9BdZn7jgox7060iq
	KtlOMRhQWk7CosMzIYZX4jbtLgJ89a0EhE67t3/kMfQt4ciocJ0VRt61zgZgQtkBBFWi9qqbZ+J
	Amib+Qdbxg6UgEkJVChNDZx2KTf2/TWxLFfLKMmiHPKLn71YZfMDCZXjmtaqmt2bn1kfH06/j
X-Received: by 2002:a17:90b:2dc7:b0:380:fead:448d with SMTP id 98e67ed59e1d1-392620e6e25mr22815689a91.13.1786327601461;
        Sun, 09 Aug 2026 19:06:41 -0700 (PDT)
X-Received: by 2002:a17:90b:2dc7:b0:380:fead:448d with SMTP id 98e67ed59e1d1-392620e6e25mr22815634a91.13.1786327601014;
        Sun, 09 Aug 2026 19:06:41 -0700 (PDT)
Received: from [10.133.33.47] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-390b31fc026sm5514327a91.3.2026.08.09.19.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 19:06:40 -0700 (PDT)
Message-ID: <83354f8a-9906-48b5-9487-fc00213af5ed@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 10:06:35 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/2] wifi: ath11k: guard copy engine access
 against a cleared srng
To: Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
References: <20260805192129.61113-1-julius@bairaktaris.de>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260805192129.61113-1-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: tw3boT6mMWgjv4LYvKxYtGrmEjNxffr9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDAxNyBTYWx0ZWRfX4Y0GVx50sZr3
 2V+b/lV12mVp3clNw9u3yHfdYJ59hDw7s2FkEr96G9KvX4ZVPVs4V7FBMJqJmiFznvOMPXtHxjE
 BRddA4+nmG4BEB6x3avt/iZ58z7LG5xkyFqW80B+ZY+Mr6LXGsko02RQDedZ6tyAkmH8bCK7QD2
 e9YB5ak/YrP9V6Ek/H2GV8s0B6Ln7TAUqEh02/6ADffh8QTM8so5J82i2rbQpjzBPvec2i/6dHT
 O7ciZcVj6XZDmKMMV2hgIEpEtI8OKz1W1vACeJI6cRJiN9sMhhK5twFnb5L+1rM+xoVsb9uc1aa
 3epDRAQE+1beCoSbEPGuzL6sR8e/z72LsnMcNKYwjBsd++gz9A9vrZ18RgempSIVN3Fy34USHjP
 Q5QmE03zOYI65TF/asj7ysohvolLGWcRw6t6/E4DNJcORzQ6qpdmzibnwVVDjHva3KEHIQIVHgQ
 46VSw1xvuULsBe0WXgw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDAxNyBTYWx0ZWRfX9bgU4SNe/Wc4
 Q08LxjYFpUR3rSagSHX1h7f2EgQuzEh2SkgV03xj1oNrQEc2QzbE8vBL3rizvxGq5RLKXzbLFo/
 z0TJM7pU/yQ1G9CYiOD4qHUTHINd91k=
X-Proofpoint-GUID: tw3boT6mMWgjv4LYvKxYtGrmEjNxffr9
X-Authority-Analysis: v=2.4 cv=abxRWxot c=1 sm=1 tr=0 ts=6a793232 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=clZncOENtWtQyurloiQA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100017



On 8/6/2026 3:21 AM, Julius Bairaktaris wrote:
> ath11k_core_reconfigure_on_crash() zeroes the ring list with
> ath11k_hal_srng_clear() and only rebuilds the copy engine rings later,
> inside ath11k_core_qmi_firmware_ready() -> ath11k_ce_init_pipes().
> 
> ath11k_ce_send() is gated on ATH11K_FLAG_CRASH_FLUSH, but that flag is
> cleared before ath11k_core_qmi_firmware_ready() is called - it has to be,
> since the firmware bring-up itself sends WMI commands through the copy
> engine. For the whole of that bring-up the gate is open while the ring is
> still zeroed, so any WMI command issued in that window dereferences the
> NULL u.src_ring.tp_addr in ath11k_hal_srng_access_begin():
> 
>   Unable to handle kernel read from unreadable memory at virtual address 0
>   CPU: 0 UID: 101 PID: 1846 Comm: hostapd
>   pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
>   lr : ath11k_ce_send+0x114/0x350 [ath11k]
>   Call trace:
>    ath11k_hal_srng_access_begin+0xc/0x60 [ath11k] (P)
>    ath11k_htc_send+0x188/0x3c8 [ath11k]
>    ath11k_wmi_cmd_send+0xc8/0x2f4 [ath11k]
>    ath11k_wmi_send_peer_create_cmd+0x78/0xe0 [ath11k]
>    ath11k_peer_create+0x138/0x500 [ath11k]
> 
> The caller matters: this is a command issued fresh during the recovery,
> not a task that was already blocked in ath11k_wmi_cmd_send(). A blocked
> one sleeps through the whole window and never re-enters ath11k_ce_send(),
> which is why hammering beacon updates does not reproduce it and a station
> associating during recovery does.
> 
> ath11k_ce_completed_send_next() has no gate at all, and
> ath11k_core_reconfigure_on_crash() calls ath11k_ce_cleanup_pipes() before
> anything else, so a crash arriving after a previous recovery already ran
> ath11k_hal_srng_clear() reaps rings whose tp_addr is NULL. This is a
> different entry into the same dereference from the one fixed by
> commit e8d85672dd7e ("wifi: ath11k: fix NULL pointer dereference in
> ath11k_hal_srng_access_begin"), which stops a successful bring-up from
> being repeated; it does not close this window.
> 
> Test u.src_ring.tp_addr rather than srng->initialized in both places:
> ath11k_hal_srng_setup() publishes ->initialized before ->tp_addr with no
> barrier between them, so an ->initialized check can be true while the
> pointer that is about to be dereferenced is still NULL.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 32be3ca4cf78 ("wifi: ath11k: HAL SRNG: don't deinitialize and re-initialize again")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  drivers/net/wireless/ath/ath11k/ce.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/ce.c b/drivers/net/wireless/ath/ath11k/ce.c
> --- a/drivers/net/wireless/ath/ath11k/ce.c
> +++ b/drivers/net/wireless/ath/ath11k/ce.c
> @@ -472,6 +472,17 @@ static struct sk_buff *ath11k_ce_completed_send_next(struct ath11k_ce_pipe *pipe
> 
>  	spin_lock_bh(&srng->lock);
> 
> +	/*
> +	 * ath11k_ce_cleanup_pipes() can reach this on a ring that
> +	 * ath11k_hal_srng_clear() has zeroed and that recovery has not
> +	 * rebuilt. Bail out as for an empty ring rather than dereference
> +	 * the NULL tp_addr in ath11k_hal_srng_access_begin().
> +	 */
> +	if (unlikely(!srng->u.src_ring.tp_addr)) {
> +		skb = ERR_PTR(-EIO);
> +		goto err_unlock;
> +	}
> +
>  	ath11k_hal_srng_access_begin(ab, srng);
> 
>  	desc = ath11k_hal_srng_src_reap_next(ab, srng);
> @@ -750,6 +761,19 @@ int ath11k_ce_send(struct ath11k_base *ab, struct sk_buff *skb, u8 pipe_id,
> 
>  	srng = &ab->hal.srng_list[pipe->src_ring->hal_ring_id];
> 
> +	/*
> +	 * ATH11K_FLAG_CRASH_FLUSH is cleared before the copy engine rings
> +	 * are rebuilt, so the check above lets a send through while the
> +	 * ring is still zeroed. Test the pointer that would be
> +	 * dereferenced: ath11k_hal_srng_setup() publishes ->initialized
> +	 * before ->tp_addr without a barrier, so ->initialized would still
> +	 * race the rebuild.
> +	 */
> +	if (unlikely(!srng->u.src_ring.tp_addr)) {
> +		spin_unlock_bh(&ab->ce.ce_lock);
> +		return -ESHUTDOWN;
> +	}
> +

I understand this is a real issue but both changes look not a proper fix to me. at least
we should not test hal srng fields at CE layer since that is a layer violation.

>  	spin_lock_bh(&srng->lock);
> 
>  	ath11k_hal_srng_access_begin(ab, srng);

