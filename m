Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE5226A0D5
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 06:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367565; cv=none; b=rd7qYZ5NujWrOnrG4bPVVS1f65dpDPh6IaA+2t0HhIALsZ7sJ4mRhpFibCsIMV/QHN28o+3nJTllUYSoTR8wxMgASJWaN8eVKex9zlOvUerFXzGgQCbkN73pJjBJCNUuMzcusd25CWTUysAxz8FzgN5UqtoHAkNVulV7kFh3k8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367565; c=relaxed/simple;
	bh=8P8agGseUBV/hQkxI7eBNwnlBJEbrU4dhhrXvN8aPPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NiYdKCiji2iFY8is2/P9UP9cSCuURUIK7VxTc8d2lrMz9kZtACkltp3/Zr/0d5gRY79WaU0vRG+jx/2GvxDn8l10n2nOWem1fbeISMIy9KLGlTVHjDCzp7IeG+onwWl+m9i16S2wiIrYbzHbnkmz22SLjYNYBA0BHCuwFkM/6xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H6IzJbIy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K5/xNmHe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H6IzJbIy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K5/xNmHe"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68E5jYno237710
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 06:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yxpww4PsWrQfLBdJ0//BJx7bMEXgGPZ3hXMqdr6a/8Q=; b=H6IzJbIyyEs2fDiW
	czjRwtavp+EgRixByOuyThU185VwMjb9guaErkjcMXQvPxn8MB/wrboXUuK9+UnG
	FhvKyaEcP300I9o/JMzR0GTjEUIvHCs1Ph2pdrM4zXVjjFZLqnPBxoj4Cgk0iyas
	K6sKbahwGAm10tJLHnHrgR4r1I3o1z0Ge5D9afzZ/U97f0x8oQvm4gDzgOJ/ltt2
	gifOJpQ50wjsCC1KyBdbawizsrGETzDgEejWvTQFzp+djvRUDoKAoZmVvsBadMlA
	oKjSJYKQWZ7QWrwBRPpW/2WNHZDtheGpbqbi6XQxX3szETXcLDyiizNWCn+oY+a9
	OpwIjQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmy9dnbt3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 06:32:42 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39d865b11b4so1292624a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 23:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789367562; x=1789972362; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yxpww4PsWrQfLBdJ0//BJx7bMEXgGPZ3hXMqdr6a/8Q=;
        b=K5/xNmHeFbr3D78ddnY51WmRmnytBI/wgAOxZz1q35RgzUn5gYo1gZT8SpkhVS+8Dj
         9hzXNd6NkjJhrJteLDTsCXlkvcPJUiazBnyu3KY9vnHzpTKTOK2NtUdLb2dehzDtXW/q
         oe1Yd1LtqSi9TDMljhMYqWruJbbkmTpMD9uRzzED9PzVlLs2hY0BZ2sYnLWTq7EGa/sV
         CNHrRZ9GEUwr+n95yzZKOOEck0D3UO8ide8DdtusXeRD+jsNZyxj1nJEjrED0U2s3lqu
         8LFPHvTBjHrs0bKRy7Nrb42lhgdzts9WrRIP+0TxoXUHrjpihicd0P8QlNn+3Psafr5s
         J/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789367562; x=1789972362;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yxpww4PsWrQfLBdJ0//BJx7bMEXgGPZ3hXMqdr6a/8Q=;
        b=RpAiq2DccU6oucDB6esE1YiakBYuf+fQJ717ZRpK4b6PKIUPQE/9YLqDawBc4fBJ0H
         GPUQfODy/kseBqoH7RQBwrPYV0qW5KSWEdID9Gr4bI/aBkSNFuTZlYhPrqRRa9+VktRC
         w5LO0c68CFGlNiBO8l4U2LWyZG0dactdoEUgpEltHszyZr2lHwLN04DYDxAc4aoSv+HY
         Q9OcbIs05pazT2DMiS8C48mfsCeltVKnj8jhhgTwBWmpLjkwTUWn2oXPcPjkYqrlkyc0
         gd4PnsvMiGC3h+EiQ9TaqRDXq1HeoMBdA+U77/bK2J9P/gqkcjPzSDRXSkrs4O/nZn8A
         UkUg==
X-Forwarded-Encrypted: i=1; AKwUvBx1SN/Vickg3i0yzICGA9EVlblnQSENXP/h0tKRo6EMDREiXf3aHuU7BVXuvFywLOmbOq0dezSEogYe1k2p8A==@vger.kernel.org
X-Gm-Message-State: AFuF++lMSU2/buVwth23Uw6H5Jojprh6CgkQe03M1/M8x+aaz9cCfvNN
	hWrI8y6JGB21lKR0NCVNFmvvyLzeTCOXN97meLaSXLVsU6SXqTWCmoQwzwVOxmhSpVfTGD427Yh
	XvAGw8dmVuRjg2ElDAcbCoR4RZ5h568iGAZUWy8myn1EL3qSynIupqNNJcMjEK8h/HDNMRQ==
X-Gm-Gg: AYBFou34L24JUlmnNhc3NYPxVBVWKG/X3/nc/cakke7NSv2V21cJXrTLZlnW7WSJyP4
	0d4Qfp9ctoSKqweSaQAkEKDL1E7OXP1h9Kt75LJhaxoeDRPucE1GIOiu0H10i0L/P2T2sdqAeMb
	uSTM2Xrlr/2FLEjx17XyeWh4ZL+L2gL1rxNx3Sw+BWCFwGphSFoNiglX9q14EMefdLV+HulArID
	V1vXvlcvQBSlWJbUKpYQXccrL8uz3jjYoGA4tUtLFccQQHIRzcxVUZRcmdtoyUQqiJI2G6wWgZX
	gNB+kaic5i13qorXCOqwHnhTejZjKjWmCopqAH2LJftfx7NoyoD2CRBJe9rMcNc+wPKbD3qFzg9
	p2YVapu+W1/nLKIRetGx0bHmRczcMi7hMoamEEOUcpFwbf5WPgJYafTS8ZtDar123NvX8EIKo
X-Received: by 2002:a17:90b:35d1:b0:39d:f189:48d6 with SMTP id 98e67ed59e1d1-39df1894982mr783859a91.4.1789367561881;
        Sun, 13 Sep 2026 23:32:41 -0700 (PDT)
X-Received: by 2002:a17:90b:35d1:b0:39d:f189:48d6 with SMTP id 98e67ed59e1d1-39df1894982mr783801a91.4.1789367561416;
        Sun, 13 Sep 2026 23:32:41 -0700 (PDT)
Received: from [10.133.33.62] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dada5c76asm17463531a91.12.2026.09.13.23.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 23:32:41 -0700 (PDT)
Message-ID: <dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 14:32:37 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
References: <20260726221908.104873-1-julius@bairaktaris.de>
 <20260726221908.104873-3-julius@bairaktaris.de>
 <CGME20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3@eucas1p1.samsung.com>
 <a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Yt8Y6GVBesqxXXwDWqiDEDZuj-HnInay
X-Proofpoint-ORIG-GUID: Yt8Y6GVBesqxXXwDWqiDEDZuj-HnInay
X-Authority-Analysis: v=2.4 cv=NelzRGD4 c=1 sm=1 tr=0 ts=6aa7950a cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=KAfsIobKxm3l_v_usUoA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDA5MCBTYWx0ZWRfX7FpzOb4BGEom
 mTUx3roFccIEB2b3uO0/xOpJ1flKA3jldoPl34M5U1REL7ioqVPd4C7jFwCR7IY6q5fydOvxCWl
 bhhFfxzDB2dtNn2jWz0gC8pCfGGTWuA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDA5MCBTYWx0ZWRfX7Ewu2kW44hL+
 U3GuKL4gmOyzhpZO3JIquxSJABuUNds20Ci+5EpLMilnSVIpDhZCn3izoHigE/PahBEr3CnzP6R
 mQ5V3i78ZZs4YkqTCvooI2ioqUPUG69V4CHD+hO8fFSZfe8nkwoZzrcCgRUQt3bWw1GLGdPRDB7
 kSOppUia8bdY8rjW/Cg8LtSlSuo2hKmqEyE0hCFkSvqah2J9+ycYl/SIfM4r0dPh6QLw7Eq22Wa
 ZUZ0XieJfG+J7/9t5HHkHmrS+deRGHoD+wXQFaNVfi1TYdJ1dDtjkkwHR824Cxr+wSRdexNwF/L
 Gmria0AiQj/D6V88e2kgACs+U1TJhS9hwZkS/BkkpS7xCRqt1Yl4iVFIezq3YW4WvBEtHA+xuUe
 LCC8KkAGu4aBv+13CMXZB3E9IVoaulRy5BMymvseMwDLqaz2cmUDfuVOag/FVgBF/4+hPvi6zUc
 PT360/i8IfFoVJ5QZSg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_02,2026-09-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609140090



On 9/11/2026 3:53 PM, Marek Szyprowski wrote:
> On 27.07.2026 00:19, Julius Bairaktaris wrote:
>> On IPQ8074 a firmware assert reboots the SoC:
>>
>>   Unable to handle kernel read from unreadable memory at virtual address 0
>>   pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
>>   lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
>>   Call trace:
>>    ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
>>    ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
>>    ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
>>    ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]
>>    __napi_poll+0x38/0x188
>>    net_rx_action+0x120/0x2c0
>>
>> ath11k_core_reconfigure_on_crash() tears the data path down with
>> ath11k_dp_pdev_free(), ath11k_dp_free() and ath11k_hal_srng_clear(),
>> which memsets the ring list. The DP NAPI is still running while that
>> happens, so it services a ring whose address pointer has just been
>> cleared.
>>
>> That function used to disable the interrupts first, until
>> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
>> moved the disable into ath11k_core_reset(). reset_work is only queued
>> from mhi.c and from the debugfs hw-restart handler, so AHB parts never
>> run it on a real firmware crash. Their recovery goes QMI server exit ->
>> restart_work -> ath11k_core_reconfigure_on_crash() ->
>> ath11k_core_qmi_firmware_ready(), and nothing disables the interrupts
>> anywhere along it.
>>
>> Disable them again on the crash path. The reset path has already done
>> so by the time it gets here, hence the ab->is_reset check.
>>
>> This is also why the debugfs hw-restart trigger never showed the
>> problem: it goes through ath11k_core_reset(), the one path that still
>> had the disable.
>>
>> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1
>>
>> Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
>> Assisted-by: Claude:claude-opus-5
>> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> 
> 
> This patch landed recently in linux-next as commit f7a74e131d3f ("wifi: ath11k:
> disable interrupts during firmware crash recovery"). In my tests I found that it
> causes a regression on QCOM RB5 board during system suspend/resume cycle
> (s2idle):

Hi @Marek, can you please try if below diff can fix this regression? Also, @Julis, can you
please also confirm if it can address your original issue as well?

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index d2ed6a0ea7e3..1ad0a47653de 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1275,9 +1275,6 @@ int ath11k_core_suspend_late(struct ath11k_base *ab)
 	if (ab->actual_pm_policy == ATH11K_PM_WOW)
 		return 0;

-	ath11k_hif_irq_disable(ab);
-	ath11k_hif_ce_irq_disable(ab);
-
 	ath11k_hif_power_down(ab, true);

 	return 0;
@@ -2333,17 +2330,9 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 	int ret;

 	mutex_lock(&ab->core_lock);
+	ath11k_hif_irq_disable(ab);
+	ath11k_hif_ce_irq_disable(ab);
 	ath11k_thermal_unregister(ab);
-
-	/*
-	 * ath11k_core_reset() already disabled the interrupts on the reset
-	 * path; only the firmware crash path reaches here with them live.
-	 */
-	if (!ab->is_reset) {
-		ath11k_hif_irq_disable(ab);
-		ath11k_hif_ce_irq_disable(ab);
-	}
-
 	ath11k_dp_pdev_free(ab);
 	ath11k_cfr_deinit(ab);
 	ath11k_spectral_deinit(ab);
@@ -2605,9 +2594,6 @@ static void ath11k_core_reset(struct work_struct *work)
 	time_left = wait_for_completion_timeout(&ab->recovery_start,
 						ATH11K_RECOVER_START_TIMEOUT_HZ);

-	ath11k_hif_irq_disable(ab);
-	ath11k_hif_ce_irq_disable(ab);
-
 	ath11k_hif_power_down(ab, false);
 	ath11k_hif_power_up(ab);

-- 
2.34.1

