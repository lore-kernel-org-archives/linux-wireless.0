Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0574D3F4DD6
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 07:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113201; cv=none; b=MUxzAYE+eM/XzpznbJvyuNNjZXcVA4yEAEA0WSIKeM0vNP7deeotkqMKovhZBygwjNwRMIo8c7LFeFVIMwetLBR9lhVXrloOggHhpIvXDQnIhssd3BGJoEZ6479M3KL0U8KFPWrWhcFGk6mYhMOvmYA7jtvtYulStGqFgd4mPxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113201; c=relaxed/simple;
	bh=ZkeLunK8BWxdIYsiTJWNEJ94fx8pdlSad7atTglylZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=kLj3wnHZRE2smFAqc8MQfFrwPS5YFiDaOB4RR7r/LQvxHEiuDzaz3suNZDWv3oEo8alLfBe651BdIOuou05OyW0LAdYzO4ghtfSsImG30USSyZsKMtT6RIQhfRJzgUX3QdXASEp2dmvu63vrPsWIUSHGDC+PIQDXm/i5/scJes0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZSwKxmdY; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZSwKxmdY"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260911075315euoutp01dc3c067c343f4866443f912e2c0b8c33~UNPjxlf8R2600926009euoutp01_
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 07:53:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260911075315euoutp01dc3c067c343f4866443f912e2c0b8c33~UNPjxlf8R2600926009euoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789113195;
	bh=HZhffQ4VlVGWQrtBKfTim4erabsKWzErMs9i+1dn2ko=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ZSwKxmdYU6yn5jlwD9WbMuhEA3SXyluNKUQ+0MJhgWekoEOOHtQmlJbIyRYf3AF4p
	 rYPCtpy6U3VDeZ1/PHipXy1/KzRAHVzIM+ikwzCCkFvb0oeHaQjWdX2/dBaZKOlPHH
	 NL7XXUevslOf0n1t+HCVZrKo6lVeP15oGkdYjujw=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3~UNPjd7MnK0646806468eucas1p1s;
	Fri, 11 Sep 2026 07:53:15 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260911075314eusmtip22abcb52098d9c41021aaa4fa3a70a096~UNPird2rc0250002500eusmtip2Q;
	Fri, 11 Sep 2026 07:53:14 +0000 (GMT)
Message-ID: <a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com>
Date: Fri, 11 Sep 2026 09:53:14 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, baochen.qiang@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260726221908.104873-3-julius@bairaktaris.de>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3
X-EPHeader: CA
X-CMS-RootMailID: 20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3
References: <20260726221908.104873-1-julius@bairaktaris.de>
	<20260726221908.104873-3-julius@bairaktaris.de>
	<CGME20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3@eucas1p1.samsung.com>

On 27.07.2026 00:19, Julius Bairaktaris wrote:
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
>
> Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>


This patch landed recently in linux-next as commit f7a74e131d3f ("wifi: ath11k:
disable interrupts during firmware crash recovery"). In my tests I found that it
causes a regression on QCOM RB5 board during system suspend/resume cycle
(s2idle):


# time rtcwake -s10 -mmem
rtcwake: assuming RTC uses UTC ...
rtcwake: wakeup from "mem" using /dev/rtc0 at Thu Jan  1 00:05:43 1970
PM: suspend entry (s2idle)
Filesystems sync: 0.037 seconds
Freezing user space processes
Freezing user space processes completed (elapsed 0.008 seconds)
OOM killer disabled.
Freezing remaining freezable tasks
Freezing remaining freezable tasks completed (elapsed 0.004 seconds)
printk: Suspending console(s) (use no_console_suspend to debug)
dwc3-qcom-legacy a6f8800.usb: port-1 HS-PHY not in L2
qcom-pcie 1c08000.pcie: Device not found
qcom-pcie 1c10000.pcie: Device not found
qcom-pcie 1c00000.pcie: PCIe Gen.2 x1 link up
mhi mhi0: Requested to power ON
mhi mhi0: Power on setup success
mhi mhi0: Wait for device to enter SBL or Mission mode
ath11k_pci 0000:01:00.0: chip_id 0x0 chip_family 0xb board_id 0x4 soc_id 0xffffffff
ath11k_pci 0000:01:00.0: fw_version 0x10121492 fw_build_timestamp 2021-11-04 11:23 fw_build_id
ath11k_pci 0000:01:00.0: failed to receive control response completion, polling..
ath11k_pci 0000:01:00.0: Service connect timeout
ath11k_pci 0000:01:00.0: failed to connect to HTT: -110
ath11k_pci 0000:01:00.0: failed to start core: -110
ath11k_pci 0000:01:00.0: failed to reconfigure driver on crash recovery
ax88179_178a 2-1.1:1.0 eth0: ax88179 - Link status is: 1
ath11k_pci 0000:01:00.0: timeout while waiting for restart complete
ath11k_pci 0000:01:00.0: failed to resume core: -110
ath11k_pci 0000:01:00.0: PM: dpm_run_callback(): pci_pm_resume returns -110
ath11k_pci 0000:01:00.0: PM: failed to resume async: error -110
ath11k_pci 0000:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
ath11k_pci 0000:01:00.0: failed to enable PMF QOS: (-108
------------[ cut here ]------------
Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.
WARNING: net/mac80211/util.c:1957 at ieee80211_reconfig+0x508/0x1ed0 [mac80211], CPU#0: kworker/u32:1/61
Modules linked in: ...
CPU: 0 UID: 0 PID: 61 Comm: kworker/u32:1 Not tainted 7.2.0+ #13652 PREEMPT
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: async async_run_entry_fn
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : ieee80211_reconfig+0x508/0x1ed0 [mac80211]
lr : ieee80211_reconfig+0x508/0x1ed0 [mac80211]
..
Call trace:
 ieee80211_reconfig+0x508/0x1ed0 [mac80211] (P)
 ieee80211_resume+0x4c/0x68 [mac80211]
 wiphy_resume+0xb0/0x28c [cfg80211]
 dpm_run_callback+0x8c/0x158
 device_resume+0x128/0x36c
 async_resume+0x24/0x3c
 async_run_entry_fn+0x34/0xe0
 process_one_work+0x24c/0x844
 worker_thread+0x1bc/0x368
 kthread+0x134/0x140
 ret_from_fork+0x10/0x20
irq event stamp: 701092
hardirqs last  enabled at (701091): [<ffffac645b5ec938>] vprintk_store+0x3e4/0x49c
hardirqs last disabled at (701092): [<ffffac645c7dc11c>] el1_brk64+0x20/0x60
softirqs last  enabled at (701078): [<ffffac640ef2c358>] ath11k_htc_send+0x264/0x2f0 [ath11k]
softirqs last disabled at (701076): [<ffffac640ef2c344>] ath11k_htc_send+0x250/0x2f0 [ath11k]
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: net/mac80211/driver-ops.c:41 at drv_stop+0x24c/0x264 [mac80211], CPU#0: kworker/u32:1/61
Modules linked in: ...
CPU: 0 UID: 0 PID: 61 Comm: kworker/u32:1 Tainted: G        W           7.2.0+ #13652 PREEMPT
Tainted: [W]=WARN
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: async async_run_entry_fn
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : drv_stop+0x24c/0x264 [mac80211]
lr : drv_stop+0x23c/0x264 [mac80211]
...
Call trace:
 drv_stop+0x24c/0x264 [mac80211] (P)
 ieee80211_stop_device+0x80/0x90 [mac80211]
 ieee80211_do_stop+0x614/0x960 [mac80211]
 ieee80211_stop+0x68/0xd8 [mac80211]
 __dev_close_many+0xe0/0x224
 netif_close_many+0x8c/0x1c0
 netif_close+0x70/0x84
 dev_close+0x38/0x60
 cfg80211_shutdown_all_interfaces+0x4c/0x138 [cfg80211]
 wiphy_resume+0xec/0x28c [cfg80211]
 dpm_run_callback+0x8c/0x158
 device_resume+0x128/0x36c
 async_resume+0x24/0x3c
 async_run_entry_fn+0x34/0xe0
 process_one_work+0x24c/0x844
 worker_thread+0x1bc/0x368
 kthread+0x134/0x140
 ret_from_fork+0x10/0x20
irq event stamp: 701378
hardirqs last  enabled at (701377): [<ffffac645c7f21e4>] _raw_spin_unlock_irqrestore+0x6c/0x70
hardirqs last disabled at (701378): [<ffffac645c7dc11c>] el1_brk64+0x20/0x60
softirqs last  enabled at (701366): [<ffffac640ed4dedc>] ieee80211_stop_device+0x2c/0x90 [mac80211]
softirqs last disabled at (701360): [<ffffac640ed4dec8>] ieee80211_stop_device+0x18/0x90 [mac80211]
---[ end trace 0000000000000000 ]---
ieee80211 phy0: PM: dpm_run_callback(): wiphy_resume [cfg80211] returns -108
ieee80211 phy0: PM: failed to resume async: error -108
OOM killer enabled.
Restarting tasks: Starting
Restarting tasks: Done
random: crng reseeded on system resumption
PM: suspend exit


Before that commit it worked fine:

# time rtcwake -s10 -mmem
rtcwake: assuming RTC uses UTC ...
rtcwake: wakeup from "mem" using /dev/rtc0 at Thu Jan  1 00:05:42 1970
PM: suspend entry (s2idle)
Filesystems sync: 0.042 seconds
Freezing user space processes
Freezing user space processes completed (elapsed 0.005 seconds)
OOM killer disabled.
Freezing remaining freezable tasks
Freezing remaining freezable tasks completed (elapsed 0.003 seconds)
printk: Suspending console(s) (use no_console_suspend to debug)
dwc3-qcom-legacy a6f8800.usb: port-1 HS-PHY not in L2
qcom-pcie 1c08000.pcie: Device not found
qcom-pcie 1c10000.pcie: Device not found
qcom-pcie 1c00000.pcie: PCIe Gen.2 x1 link up
mhi mhi0: Requested to power ON
mhi mhi0: Power on setup success
mhi mhi0: Wait for device to enter SBL or Mission mode
ath11k_pci 0000:01:00.0: chip_id 0x0 chip_family 0xb board_id 0x4 soc_id 0xffffffff
ath11k_pci 0000:01:00.0: fw_version 0x10121492 fw_build_timestamp 2021-11-04 11:23 fw_build_id
OOM killer enabled.
Restarting tasks: Starting
Restarting tasks: Done
random: crng reseeded on system resumption
PM: suspend exit


> ---
>  drivers/net/wireless/ath/ath11k/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> index 8039124e7832..d2ed6a0ea7e3 100644
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -2334,6 +2334,16 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
>  
>  	mutex_lock(&ab->core_lock);
>  	ath11k_thermal_unregister(ab);
> +
> +	/*
> +	 * ath11k_core_reset() already disabled the interrupts on the reset
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

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

