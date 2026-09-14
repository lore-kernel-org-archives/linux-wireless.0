Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA1039EF33
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370589; cv=none; b=HPNmnEISVcHJ1lurd8Mo/LzDcDqjyCywzkjGRQ7kzoCfIA3vGOl91Kyh6NJYjZ/horUfID96ytFaigXzG9J6/CS+HKOkj5IVoX3Sj1vj4frpf+Gg+KVRL9NxXjaJGZGD3kf+i6hEVGlHjghN4pBT3TqmOdXMoFJ6AFLzjnsVVAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370589; c=relaxed/simple;
	bh=FnU9ichWYEjozILma7OYnJjuAdPWbu+UPyN1G9ab96c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=c56e/O4dmUuzC0+C+3mVPH79ksm8W9RqnOzND63/kDRWtLYhT6rMJ1c4hTJS7el81qGqMAtHymyo3/kgkmGcpNPBoMjCsN5GLo8uPHy7Hn+17qvF7O5iy637ZOkQV3nY5qxIsnwz/LwZeOXUog1th7K1xeOTsUXviJnaqQyeM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Eq9wuug2; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Eq9wuug2"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260914072258euoutp02a1e68457a839d1c0322c77d284dbf933~VHw_WeXLo3189031890euoutp02b
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 07:22:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260914072258euoutp02a1e68457a839d1c0322c77d284dbf933~VHw_WeXLo3189031890euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789370578;
	bh=0/6RCCDtwLCKcqeCu9KvevKknsNmCR/SwvuGvps+Mao=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Eq9wuug2emOXPQr+i3Vykg/gBpVJ1LVY+nNPDI+8ZDOYOuQ0H3KTXgOA6f4g1wW/0
	 OqdQeEs2jxBV76keBbbif0eTAAkYC7B1OyI9ttGS+nnO9Ms3DLXkjkdgzmvGJI2vqk
	 yCs4ueN7M9fekY2KgxBkmy/K5YaSkgeHna1e6a6g=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260914072258eucas1p2157e6cbd4061445c7d05ae5f925eb552~VHw_Ie3gN0970209702eucas1p29;
	Mon, 14 Sep 2026 07:22:58 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260914072257eusmtip291a3c37a1c79e1dcdcc8c2548f8f826f~VHw9mGU9f3114831148eusmtip2g;
	Mon, 14 Sep 2026 07:22:57 +0000 (GMT)
Message-ID: <10491411-b500-4e89-bf85-5142ced60aaf@samsung.com>
Date: Mon, 14 Sep 2026 09:22:57 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, Julius Bairaktaris
	<julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260914072258eucas1p2157e6cbd4061445c7d05ae5f925eb552
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3
X-EPHeader: CA
X-CMS-RootMailID: 20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3
References: <20260726221908.104873-1-julius@bairaktaris.de>
	<20260726221908.104873-3-julius@bairaktaris.de>
	<CGME20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3@eucas1p1.samsung.com>
	<a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com>
	<dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>

On 14.09.2026 08:32, Baochen Qiang wrote:
> On 9/11/2026 3:53 PM, Marek Szyprowski wrote:
>> On 27.07.2026 00:19, Julius Bairaktaris wrote:
>>> On IPQ8074 a firmware assert reboots the SoC:
>>>
>>>   Unable to handle kernel read from unreadable memory at virtual address 0
>>>   pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
>>>   lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
>>>   Call trace:
>>>    ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
>>>    ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
>>>    ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
>>>    ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]
>>>    __napi_poll+0x38/0x188
>>>    net_rx_action+0x120/0x2c0
>>>
>>> ath11k_core_reconfigure_on_crash() tears the data path down with
>>> ath11k_dp_pdev_free(), ath11k_dp_free() and ath11k_hal_srng_clear(),
>>> which memsets the ring list. The DP NAPI is still running while that
>>> happens, so it services a ring whose address pointer has just been
>>> cleared.
>>>
>>> That function used to disable the interrupts first, until
>>> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
>>> moved the disable into ath11k_core_reset(). reset_work is only queued
>>> from mhi.c and from the debugfs hw-restart handler, so AHB parts never
>>> run it on a real firmware crash. Their recovery goes QMI server exit ->
>>> restart_work -> ath11k_core_reconfigure_on_crash() ->
>>> ath11k_core_qmi_firmware_ready(), and nothing disables the interrupts
>>> anywhere along it.
>>>
>>> Disable them again on the crash path. The reset path has already done
>>> so by the time it gets here, hence the ab->is_reset check.
>>>
>>> This is also why the debugfs hw-restart trigger never showed the
>>> problem: it goes through ath11k_core_reset(), the one path that still
>>> had the disable.
>>>
>>> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1
>>>
>>> Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
>>> Assisted-by: Claude:claude-opus-5
>>> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
>>
>> This patch landed recently in linux-next as commit f7a74e131d3f ("wifi: ath11k:
>> disable interrupts during firmware crash recovery"). In my tests I found that it
>> causes a regression on QCOM RB5 board during system suspend/resume cycle
>> (s2idle):
> Hi @Marek, can you please try if below diff can fix this regression? Also, @Julis, can you
> please also confirm if it can address your original issue as well?


Works fine in my tests, feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>


> diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> index d2ed6a0ea7e3..1ad0a47653de 100644
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -1275,9 +1275,6 @@ int ath11k_core_suspend_late(struct ath11k_base *ab)
>  	if (ab->actual_pm_policy == ATH11K_PM_WOW)
>  		return 0;
>
> -	ath11k_hif_irq_disable(ab);
> -	ath11k_hif_ce_irq_disable(ab);
> -
>  	ath11k_hif_power_down(ab, true);
>
>  	return 0;
> @@ -2333,17 +2330,9 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
>  	int ret;
>
>  	mutex_lock(&ab->core_lock);
> +	ath11k_hif_irq_disable(ab);
> +	ath11k_hif_ce_irq_disable(ab);
>  	ath11k_thermal_unregister(ab);
> -
> -	/*
> -	 * ath11k_core_reset() already disabled the interrupts on the reset
> -	 * path; only the firmware crash path reaches here with them live.
> -	 */
> -	if (!ab->is_reset) {
> -		ath11k_hif_irq_disable(ab);
> -		ath11k_hif_ce_irq_disable(ab);
> -	}
> -
>  	ath11k_dp_pdev_free(ab);
>  	ath11k_cfr_deinit(ab);
>  	ath11k_spectral_deinit(ab);
> @@ -2605,9 +2594,6 @@ static void ath11k_core_reset(struct work_struct *work)
>  	time_left = wait_for_completion_timeout(&ab->recovery_start,
>  						ATH11K_RECOVER_START_TIMEOUT_HZ);
>
> -	ath11k_hif_irq_disable(ab);
> -	ath11k_hif_ce_irq_disable(ab);
> -
>  	ath11k_hif_power_down(ab, false);
>  	ath11k_hif_power_up(ab);
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

