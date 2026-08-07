Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4560246EC60
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117178; cv=none; b=GPI3SZqm2Pp96+lO12NPYuPZDmt1Iszvwp/4OB7iymrMv7lnwRBVkVzDXOus3wmDi9DQBJJk+F4fIOVmY72Kfn5iuG/OHH9O3AH2LtBZZaft9Fn4mp6iHjtLhRjyIAyY1OTr/ij4vHZZSWcfod3A261rr0/LLCNVQLCMVWf7J5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117178; c=relaxed/simple;
	bh=GdVKiMCQghSY1NieJgI71129C8QrU5oIWcv3bmolLJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FurL19SzFPicvFrPMhzQfMV48kNM4HR7mtsAmU8qIJeu5ADTZtJ27P2luRA8avILU0+63Bj+O9kNGcs/WDOLtuAlfnwTygNwUpSbF3bCDW6tMi5fERdHPYtd9zMmwHrHB1ElxdaeITe8hW+ldMXydelEmr0YPnnJ7LHq1Os+10E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bAK2Qd4D; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L6epNIY4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bAK2Qd4D";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L6epNIY4"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677FRMUo2532512
	for <linux-wireless@vger.kernel.org>; Fri, 7 Aug 2026 15:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FCRWjh1yZDl8I8dIWG38FEvpFTulB4/sCRQjieQKxAk=; b=bAK2Qd4DlymE7U38
	WUHXfSxWgwQt9R3qkCujwKqXKkIONZwYaSmuoxGrEeCpK4SWAdpPvKtBbZuAXF4O
	sp4hL2gJx77QXsc++9UIAHuZ7zwur4Q+uzYOhhPO3StaCdWeJIZmQab7gzhvJIue
	sI5qn5cjbH0Pdww8G5RtPulpxx8/rU8nclmxGjYawXAwHs34JXywmE/eFx1z5dDQ
	+t7+F4y+M3pRQRo0/O5Alfde2XEA03TZTBt7mj5P3D/efQeeBo7W9sYhxwDBZgKq
	7wRvkaIZN8LgNG2ADmTf0HWdmcc8A7OAxrq4Y47uSalb1KgPKXXB0AoGJfYxbNKx
	1L9/tQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwhpy84ft-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 15:39:36 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-385d2703b64so2195152a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 08:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786117175; x=1786721975; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FCRWjh1yZDl8I8dIWG38FEvpFTulB4/sCRQjieQKxAk=;
        b=L6epNIY4azLCSZ9d3kIhAnA4UtXOX9E/5+3oJ/uqHmNKP5fCfZHfH49F1IRJKDxARi
         hmcXJc83GBah9NRjYIq9/TsAx8qjMuSFdWQsrKdVYduGvCm++0mzTryigJKpXQOgPcBq
         +glhoOTqfFUG60Juv61XfLBJVHW+o3yraDGfcq3Ot8nrnyKXrrWGzF/O4kgp7ANkAQy0
         mH980R8ODznFUNn1Juq7XWYB+W9na5pP+IAN9H2oTm8gr47Bj0s10NIL57VPdlG4sAYb
         k1pDJg0vA8Vh34pqp3nMJxkg5BBrk8FZHiDqF2sqJpPCbmHagDIim5mt/5pARXaT6aTW
         pc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786117175; x=1786721975;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FCRWjh1yZDl8I8dIWG38FEvpFTulB4/sCRQjieQKxAk=;
        b=HZVA4/JaTfLSGQ4a+AIUx20pcIUl4DSg5NeNvD3E6vTD4lFiqeVjb1amNHpiHLJR+f
         iBWm70ZVBN4aZBLpNaLhd3PKpw7qkKAhPOAQUnU2BERvULHXhRjPkdAxZnnNV8GUBdk0
         bUHDVx7ahPWSZ1E8xRrVV7dbgHyXw1xEkEeidALyjafD0nB8caUDplgGd0jw6Who2Bdz
         qy/V9QmfUFELXiija29nqzNdWyuBnqd4+4vL5kj1vHPCCZzV8rvY0M+JdKdtoHWLjsWR
         gsRY4NrVtlARHGiswidLgIG5G9z3ATJUouTiZUi1s/J7lQHEJGoB7bHg1ixWkooo20Sq
         bqeA==
X-Gm-Message-State: AOJu0YzCasObA/ldM5dN7jw//gtsHrcpeRNwS129scu7OTK+u47CD98l
	diCNfhmBIkyRhMmfBDm60iENRGLNNsC6YXryEa5WwFa8fOalvNTKE1mlmHqTpI9sBa2j7gusCFr
	0Qv7mN4pzEEinqiNBpdwxgnjQ4cQoFcBrYbtMnuZxPkq59UP9kiHWRPVGW2M+RiSRDNGf6w==
X-Gm-Gg: AR+sD13PGIGs344uX83HKT+qI3czxZFb2ODnawpKjVMPb+Kbj/ALbGmfiT4j0YNFsRf
	EnXJ+h73yNy/k96Z0xpOckcPQOUt3u7ddJbwYYml4NeVSZct0vADrg2oZXRlBY07pbbjcNpJ+2g
	ZXv6IokC+IhvUss/vVXDMci6BeSVepQ6A77DOw2oY7yrVRcW+ssP+D8ePeolwsRpe5ZAeLmeRpG
	sogCHnV1AEYlU3MNsBvIOVSKho5CTb07ydv44YEgvIRMkehCp72fxYX8DFX/gLCLhUhjyw6ocvx
	tyEpL65VPLWGoPVzR+uk0HAsJMpSatLwgnwn9iHkCIJ+KniDzMSAcuCXrpDMHghAzOBETgbbONa
	IgCpcfrml1tNpRxgpbdLAlcdzoNh0aDVGZnbkYsB5KavFWNTVM47mjYdits70
X-Received: by 2002:a17:90b:4c89:b0:385:3ab:fecb with SMTP id 98e67ed59e1d1-3928221e3d3mr341646a91.4.1786117175556;
        Fri, 07 Aug 2026 08:39:35 -0700 (PDT)
X-Received: by 2002:a17:90b:4c89:b0:385:3ab:fecb with SMTP id 98e67ed59e1d1-3928221e3d3mr341595a91.4.1786117174898;
        Fri, 07 Aug 2026 08:39:34 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bebde353sm9696021eec.23.2026.08.07.08.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 08:39:34 -0700 (PDT)
Message-ID: <8a152b94-d6c4-4d51-8362-1047ef311c70@oss.qualcomm.com>
Date: Fri, 7 Aug 2026 08:39:32 -0700
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
        Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
References: <20260807094858.1548216-1-avalentin@marcant.net>
 <79444a54-8500-43df-b0c6-f6a98c230dea@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <79444a54-8500-43df-b0c6-f6a98c230dea@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Cb44Irrl c=1 sm=1 tr=0 ts=6a75fc38 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=7bAZdoCWAAAA:8 a=EUspDBNiAAAA:8
 a=sz1l3bY0xy_xST6I20UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=TjNXssC_j7lpFel5tvFf:22 a=7DsIbQzYVz3x35o7bboS:22
X-Proofpoint-GUID: p3lrqBhQhMQMhoT36ipGqi_RzdFXoSBH
X-Proofpoint-ORIG-GUID: p3lrqBhQhMQMhoT36ipGqi_RzdFXoSBH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDEyMiBTYWx0ZWRfX1QDeZF9rHAaK
 T0ajyAcPGVmQayq8exZ0gplW06FngmhzKglWUVPQ2ZoWjh0HOWqnggvYDAXWFjck8OxlmVs5Mhc
 tThRfQx9sORRGnSzUywqesp0GuW4mfzu5mwz3AWZuHRxFpjM0l3VJgi06Mt+9ltVxb5vMnLeGNU
 dM46YI7Q+sfDcisl91WLSJnrUYrP8E6GsaKa4xJKct1TuY+XzpOrDlKaTcUlhUZ9zOtN/iqLi+0
 QbVDboi8qhUrxVLnXd6BVQrd4ZOiTs/Cz7VmGmN33bnwWQO2sn3ZuSnE0WsqfRcsRcX9tUneKQm
 qxiPgAUZQqRNZBkFP7A6lqQ5mUSDvYX81zSphUG9i4kWl+WRKrSzeuaXtNvQQEH8t7InfyQI/SI
 bvPSiU4aJwHyhKFb8AlC0QEoxSVnZBUyuwJ+JPyaeEyAd+3t8pk7/qBPiv6gjYtZsWJX+ddELGy
 sEG5dUjrq35PDcAXmjA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDEyMiBTYWx0ZWRfXxOxomTK6SgPA
 zCOhWFTJH6yOElYUE+u++xOsE85DNdNqJVR4YqwGXpZF08h6pM7wKNNnzZfAqbRbGF6XLM8Jzib
 pV86dR59jvMs4oWLIXer91mqyDkvZCU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070122

On 8/7/2026 8:34 AM, Jeff Johnson wrote:
> On 8/7/2026 2:48 AM, André Valentin wrote:
>> The AHB shutdown() callback was introduced solely for WCN6750, which has
>> to stop DMA before the SMMU is torn down at system reboot/shutdown. It
>> was registered unconditionally in the shared ath11k_ahb_driver, so it also
>> runs on the IPQ AHB targets (IPQ8074/IPQ6018/IPQ5018), which never had a
>> shutdown() handler before and have no such SMMU requirement.
>>
>> On IPQ6018 the shutdown teardown stops the WCSS Q6 remote processor
>> firmware. Stopping the Q6 firmware leaves shared WCSS state such that the
>> boot ROM (SBL1) hangs during DDR training on the following warm reset;
>> only a cold (power-on) reset recovers. A plain reboot therefore never
>> comes back and needs a physical power cycle.
>>
>> This was pinned by bisecting the teardown at reboot: skipping
>> ath11k_qmi_firmware_stop() (i.e. not stopping the Q6) is what lets the
>> warm reset train DDR and boot normally, whereas none of the q6v5 power,
>> reset or clock steps reproduce it on their own.
>>
>> Restrict the shutdown() teardown to WCN6750, restoring the pre-regression
>> behaviour for the IPQ AHB targets. On reboot/shutdown the whole SoC is
>> reset by the boot chain, which re-initializes the WCSS from scratch, so no
>> teardown is needed there. Module removal (rmmod / remove()) is unchanged.
>>
>> Verified on a MikroTik Chateau 5G R17 ax (IPQ6018): before, a plain reboot
>> froze in SBL1 at "sbl1_ddr_set_params"; after, SBL1 reaches "SBL1, End",
>> trains DDR and boots the kernel across repeated reboots.
>>
>> Fixes: ac41c2b642b1 ("wifi: ath11k: Register shutdown handler for WCN6750")
>> Cc: stable@vger.kernel.org
>> Cc: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
>> Signed-off-by: André Valentin <avalentin@marcant.net>
>> ---
>>  drivers/net/wireless/ath/ath11k/ahb.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
>> index 1e1dea4..749d8bf 100644
>> --- a/drivers/net/wireless/ath/ath11k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
>> @@ -1288,6 +1288,18 @@ static void ath11k_ahb_shutdown(struct platform_device *pdev)
>>  	 * remove() is invoked during rmmod & shutdown() during
>>  	 * system reboot/shutdown.
>>  	 */
>> +
>> +	/* The shutdown() callback was added for WCN6750, which has to stop DMA
>> +	 * before the SMMU is torn down. The other AHB targets (IPQ8074/IPQ6018/
>> +	 * IPQ5018) have no such requirement, and running the teardown here stops
>> +	 * the WCSS Q6 firmware, which leaves shared state that hangs the boot ROM
>> +	 * (SBL1) during DDR training on the following warm reset -- only a cold
>> +	 * (power-on) reset recovers. Skip it on those targets; the SoC reset
>> +	 * re-initializes the WCSS from scratch.
>> +	 */
>> +	if (ab->hw_rev != ATH11K_HW_WCN6750_HW10)
>> +		return;
> 
> this is not the correct approach per the driver architecture.
> all hardware-specific operations should be driven via the hw_params structure.
> 
> /jeff

+ Mani's current e-mail address @oss.qualcomm.com
