Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576F539CCFC
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116874; cv=none; b=IQhF7NQAXFcV/eaEkitUWExrbLPPEbTZCcWzuKvsz/ma5Cvz8/pj+qtz3UZEprVuCm9zrsxHshsqHljD0Q/rCwXFnfHZihmESqLxY7ARJHs3aCv9d/10dvZKd0qcoFokWq7/NtcPIoFaDhNZ8i4gt1rjIdfNiyF1Wuy369bazPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116874; c=relaxed/simple;
	bh=9X3u3JeiyUTOSntpB5hKEhouFVAl2MzmFpbK9+5vz/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4xJOKty0dysjZA89MrAXc5D3G/84k54BhSE3mI9/2TKpv6WlJ3F18QrO8Bzbix1bIj0YMqTWIYk8y9uTpK7/7RXB2E0jo6Jo6GMkr2/39MtvJKjBEs5Z0G5h/ZSccAqj2s+rsf40IP9eiXZzxfDdf0WjGEx3aGsrjO1WHsgRkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g/z7B60q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fZLO2M73; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g/z7B60q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fZLO2M73"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677FSL1x1670656
	for <linux-wireless@vger.kernel.org>; Fri, 7 Aug 2026 15:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gIddRI6I3UgdaoHJWoQKU79TFFjI8K9m8AKLiWVwC58=; b=g/z7B60qvKSVVrtj
	Xr+tP9DYF+lHZ47l3knGGj5bdffPA0sXig23RGMplZeIigLBwcZCABpHOl1Hdf2w
	h6VSEDG/JYxFmRyi5q3lN6k2mFlH6YV4Z23Dmjvm1TuIRAy2A3LBbd1lSC5r9p4b
	8rPWr2+BIxMC6GUTHhh7h/s9N0JKkHe1KQl0PmxIxFJe8E4He6yGMk5GA64VknZD
	z7sDgMuPIV0BKOcPuRZKjsv/G0ltxR+ZlGzrRfNw2z4pmogxamQhFnz4El/J0gsp
	ZEbKEJ0QoqVW6uMJne3+NTG+XnXmBmWROMe1CWii6crEjPU6inyV7mDTfD9Mmi3k
	mPg4oQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvy6gvp53-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 15:34:31 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso4510512a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 08:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786116871; x=1786721671; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gIddRI6I3UgdaoHJWoQKU79TFFjI8K9m8AKLiWVwC58=;
        b=fZLO2M73NF3Pq6m/vKY0bK7QciRLJAO+lpIyvE4gehofBtFuXuUShzMrovcZ5iJJnh
         tlCZh+2pdFJJrza9aPTnoQs6f5PG7G8x8RULn7/Y3hLh0MXvlc9LT9T2YIYECsIvehO1
         kqw8fp/jZrMaPxWTTcgIyMxgf62w1xv+/NVXxkfu571atf/XYpR7mxbnfHrWllBiPSHy
         M+JeNRK/n0dcsxC1VvBrXU7+bRqfE1HvbcODEHVNoGoCzqBwG5sfI7jknqp9U11nBwiX
         AO74fORBY8sZ5z0vj9esohGTf9xVqq7JJGHi1Rsr9lIc8u9rKIDNBglHI/eiV8hBJP/Z
         f7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786116871; x=1786721671;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gIddRI6I3UgdaoHJWoQKU79TFFjI8K9m8AKLiWVwC58=;
        b=IQPluhXKaxDyF9etqVXdoHgy1aFbNq1uGiROJgTYvnCOxolJFiSVBnH3mJq7K7CBD4
         tm+8nwO820z5NVPQ5ymyLrzlhMFBhA/3cjEKC3vTBeGO0wiyVZZmDZBGub6PBrZB2SqO
         H5yI5d5hG9d/WmsUM9rmywXQMtsWZ9P/vYo+JMFzsLI0vtQVKTXOecJzF1tQ6Bgj2eRo
         f0OozFfFoKjCsnqpii2Ga2Dh1RflXzmbvv32vXFTd5RKoPQiVrHFh8gwNtK66Qb5x+IW
         vt025taLg1BCo8vG2monAwomZnpZBmQZGTv6Khcl/WW9N62b2RC5+SBOt7A00aTDwPeO
         TNXw==
X-Gm-Message-State: AOJu0Yy0TSHdJLdSe3bI5uZt0rxYQx0uo38ktmTt9GiRzyiMI/jijdEQ
	AebzNrQb5gpw8pz9DoNwP1Q2737gAoNXasN8gr3UGIVbcYZ8EQH2AJL+XvbwRKVmd7oNmo6swX7
	/4lFLjdUs7It+uwda7yDqFHN1QUJ810rCmviB2sEW35jY13xARENeTFSoW2UuIlydLnZetw==
X-Gm-Gg: AR+sD13hfXSSU2ifiQ9eq6EYF6qn5UxtsIY5VcEtorRbRbrCJKTT6F7h5qqO6BZUkCx
	mJmDIK0v4vrlfljtv7x8ePLElcxr2S6jEiqbX3V7QbpnIcumxthikkC5DE1RCJ8Z48OGlK1eakq
	DAVlnspW8O5/eA0aIsrDkhU4IkKgA7uU5hJR9TgQ50efWE//7QljEeCKvY39SXsmyW6Ev2ru15c
	F7WPl2JX7LGGDfqCeXhOUu67H3ySZ50dFsnQqUcN53Ck55CBYmSrZJBT4ucScpPITYzLXJ3Dsz+
	u1MtmqN18H6ccd4EAxIgZQ5r985j7M/PR8QkmTNZn5LN+vJN++oY5ReWtTxlf0fV5G/Pqo0mfZb
	CgPKHLwteGcL9gBSKjxZ0bRNd8XB4UxIV+9qMh1PYEW92e8ll7y8U5ien7O1T
X-Received: by 2002:a05:6a21:1193:b0:3c3:7fa2:9618 with SMTP id adf61e73a8af0-3cbce9e8db5mr1615456637.37.1786116870545;
        Fri, 07 Aug 2026 08:34:30 -0700 (PDT)
X-Received: by 2002:a05:6a21:1193:b0:3c3:7fa2:9618 with SMTP id adf61e73a8af0-3cbce9e8db5mr1615381637.37.1786116869996;
        Fri, 07 Aug 2026 08:34:29 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec29672sm9015596eec.29.2026.08.07.08.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 08:34:29 -0700 (PDT)
Message-ID: <79444a54-8500-43df-b0c6-f6a98c230dea@oss.qualcomm.com>
Date: Fri, 7 Aug 2026 08:34:27 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: run ahb shutdown() teardown only on WCN6750
To: =?UTF-8?Q?Andr=C3=A9_Valentin?= <avalentin@marcant.net>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        Kalle Valo <kvalo@kernel.org>, stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
References: <20260807094858.1548216-1-avalentin@marcant.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260807094858.1548216-1-avalentin@marcant.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=EYH4hvmC c=1 sm=1 tr=0 ts=6a75fb07 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=7bAZdoCWAAAA:8 a=AjWrOC-rRSFRPpuMgMEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
 a=TjNXssC_j7lpFel5tvFf:22 a=7DsIbQzYVz3x35o7bboS:22
X-Proofpoint-ORIG-GUID: TwWnzO95RueK9TWlfuQ3cGIBFjiRHLzL
X-Proofpoint-GUID: TwWnzO95RueK9TWlfuQ3cGIBFjiRHLzL
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDExOSBTYWx0ZWRfX1E02AwdAgdB2
 Tlvs3O4K5+mQDyB/f7jH5burVz7TQ//o5VSeFQkmUpM9r9RCwrAp36Tu3VF915FzKypfxVqGzo0
 ExkaeuPqVGWyOxkCBQ3Pu89PmCsk5xE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDExOSBTYWx0ZWRfX4bbOHHo5oojj
 Fv951Y59GvYo0lw68ucJeujeMgbhFnYFNsSzDiQ7wPUi02tPUYu09oQTEKFPUDyeNvH4/H9Etq1
 0+TxEtBDYrUVpwZ3eF75In/i0ZtPN8TwAWxJiBLbvulSeadRke+v99umzBp6CQjgc1ZG678Z0zt
 dzVImG8AcckjDoVVHrtQFr+RE6kHRJCrTjjglQKda3Hl8Y/+TLuw0k2cn6mbyaj/bxSjrz0psyF
 d86w8V3yJxAmOF3PTn++nYw1hcsLFLvwjUTh4DafjjxHeghC5vPkEsfRzAQK3cM/XzWXCHwzx+R
 bgReIZZPs9K8OfcFJkPsCGJ2oDT9uv0TMq8BpUFxwR7+LJyfOvT1dBzQ3Rni+HdRUP87r221tGv
 J5B3csBxed0sl74OG0207vDBte92q1MoT2OFaX+SC4aNIPBN+ogDUYs1Cxcc0HYFwEDYAe1iFXb
 fGnc91QvDV3gc2esYhg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070119

On 8/7/2026 2:48 AM, André Valentin wrote:
> The AHB shutdown() callback was introduced solely for WCN6750, which has
> to stop DMA before the SMMU is torn down at system reboot/shutdown. It
> was registered unconditionally in the shared ath11k_ahb_driver, so it also
> runs on the IPQ AHB targets (IPQ8074/IPQ6018/IPQ5018), which never had a
> shutdown() handler before and have no such SMMU requirement.
> 
> On IPQ6018 the shutdown teardown stops the WCSS Q6 remote processor
> firmware. Stopping the Q6 firmware leaves shared WCSS state such that the
> boot ROM (SBL1) hangs during DDR training on the following warm reset;
> only a cold (power-on) reset recovers. A plain reboot therefore never
> comes back and needs a physical power cycle.
> 
> This was pinned by bisecting the teardown at reboot: skipping
> ath11k_qmi_firmware_stop() (i.e. not stopping the Q6) is what lets the
> warm reset train DDR and boot normally, whereas none of the q6v5 power,
> reset or clock steps reproduce it on their own.
> 
> Restrict the shutdown() teardown to WCN6750, restoring the pre-regression
> behaviour for the IPQ AHB targets. On reboot/shutdown the whole SoC is
> reset by the boot chain, which re-initializes the WCSS from scratch, so no
> teardown is needed there. Module removal (rmmod / remove()) is unchanged.
> 
> Verified on a MikroTik Chateau 5G R17 ax (IPQ6018): before, a plain reboot
> froze in SBL1 at "sbl1_ddr_set_params"; after, SBL1 reaches "SBL1, End",
> trains DDR and boots the kernel across repeated reboots.
> 
> Fixes: ac41c2b642b1 ("wifi: ath11k: Register shutdown handler for WCN6750")
> Cc: stable@vger.kernel.org
> Cc: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
> Signed-off-by: André Valentin <avalentin@marcant.net>
> ---
>  drivers/net/wireless/ath/ath11k/ahb.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
> index 1e1dea4..749d8bf 100644
> --- a/drivers/net/wireless/ath/ath11k/ahb.c
> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
> @@ -1288,6 +1288,18 @@ static void ath11k_ahb_shutdown(struct platform_device *pdev)
>  	 * remove() is invoked during rmmod & shutdown() during
>  	 * system reboot/shutdown.
>  	 */
> +
> +	/* The shutdown() callback was added for WCN6750, which has to stop DMA
> +	 * before the SMMU is torn down. The other AHB targets (IPQ8074/IPQ6018/
> +	 * IPQ5018) have no such requirement, and running the teardown here stops
> +	 * the WCSS Q6 firmware, which leaves shared state that hangs the boot ROM
> +	 * (SBL1) during DDR training on the following warm reset -- only a cold
> +	 * (power-on) reset recovers. Skip it on those targets; the SoC reset
> +	 * re-initializes the WCSS from scratch.
> +	 */
> +	if (ab->hw_rev != ATH11K_HW_WCN6750_HW10)
> +		return;

this is not the correct approach per the driver architecture.
all hardware-specific operations should be driven via the hw_params structure.

/jeff
