Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522EF36F434
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 06:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789368486; cv=pass; b=tqmLRNtlpZEK0CDSq2JZYpRaaIv1E3IxLIlVsuMG2gtMkyxQxTGEWzYWhxtEE1yl8K6KKLF1c75cnkLVrQjljY4HNxI+mRGeHLeGYtVgDMiRSeeEhnM38OTH6UCkrgaIMrCKCNKiTZC4fSxPDv4hiqt7KuHDbQm8KTiRjq6PPkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789368486; c=relaxed/simple;
	bh=k+adlSyQyqCHc16yk2+TlsZYUekWo+KL53XZm5SEa1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Izy6CpRnT3gG9NHYOMt0u2QygYp3FxBWalVkctiqPfBx7X2TYH+qe2LOa+6Rd4jtBLUCH7o1EgBXipzVbt3R9hxUVappdmLdYNsNrhii1gYVeUQnlfRFZcjE9UC3WAadyZW75LS6PjFv23gsgolJF60eW4EMz2AwYstpL+x2pic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=OcMBnIvd; arc=pass smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="OcMBnIvd"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d4ddd179eso12271437b3.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 23:48:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789368484; cv=none;
        d=google.com; s=arc-20260327;
        b=RqpgYajPyB/Nvpnmh2TjSBh+9CMPuXBcsDR8kCkSI9GNkRpd8DXDbLKws2FRuPuwkx
         9EVNZevd0+fmhsP1c4kKUOB1KZb2yIm1JXK/+pIXLtC6eUWH+8rTbILDoEQxrmOYndES
         FzFwr1CU2PPLLz/aus3qPNGt33jJSed333nKs1sAEInDIxGZa3JFzovhTpJNxBN/L+FF
         NdIsokJTQViurl86LuyjRtf54sjLQWQ3Re5TnAEC20JjA4LS4mhJCvs26YQ0Xbxrnhvy
         Qt4b2RbVYU7FbuSKAEbXFJoBJG1FUHNxfMTMr6WN+4i6b0KzIWtj/hFgm9S3Cn/r0ynv
         KYmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/6vxNJgFB0kAwZIfG9ct3s/oIXV82N4VnXyA7jWGSXY=;
        fh=37gwBREf9Q0ycTt2gz3dwzuqSJ11d/ZYXhEj5ymSt+8=;
        b=W6acU2sd2xFzKqo0sczaPrvOwBlO4+QxcSx2tW/B23Bw4ShKq+6dYdIFr3QGEwOHlI
         SEkh9V2oH/LK4BTUPis7CQ2qNk5tnv+LE14fJs27+rY6eWQNiWwXwdrBzdRh6OtrixPw
         mkGmAnjyG5VM0GEBwpxoK6DmHMFdi5046RSHiafVbGXQOGOofcrjFNJTHQ7T1m0gwZgu
         fjNnguWwelZzfefAMVZDHPhe1sTFNCxOPTATxqbAD8MdfATu9UuQZFooBZVJ5fpBGtVv
         QTVHmOz4qhA4OKcrRFkvpLryqj6aOPr+X5tI/2B1HlEt9LPRow99O0uL9edY9isVt/s9
         AVOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789368484; x=1789973284; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/6vxNJgFB0kAwZIfG9ct3s/oIXV82N4VnXyA7jWGSXY=;
        b=OcMBnIvdQF1uFDoGiiDEfX0anWANvvl4WADVG61xq+ghMj+CqUnolpwLhyNyhNm6A9
         Pacf6ByiBZSxgCw3+fSTo+fD7E1S7YeVqeBwQKuFKIQ2DAPgrJvbLghgIwf1RFmVD0Hz
         pryaCRroH/osh7EPxajiV+vk0aOd9IOegoxoU80uY5Ghtfma+pgE6ONDRuKxKzwu4Tdf
         UbJd1XXYLqjL34vCCp8czR6RiHtk6Wqt5LEKUFPrXgkHpbAD6FppRfkGN/xgjdLq3BAI
         G72eLJJ+CoQozBxxNbnOjLhfvm2o9T2tIs/JUgfWlpex2fwkI1bJipDZF1sq5zGrG5K0
         n2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789368484; x=1789973284;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/6vxNJgFB0kAwZIfG9ct3s/oIXV82N4VnXyA7jWGSXY=;
        b=mZOfv7Kw9uWxaEx+QuzrrLDFLbtbAz7Mrz7lmWMPstXl2k52VKqWsqUe8qozgyqrbg
         wgd18rMRq77pGrceelgMS4LKHas6WBtn0gzj6zouurR6zlMyLzSgVbaKE/ulucD/wWbJ
         +2C5DXVmD5G86dkosgthM++KmSLgEROP6m4UfDyT45Ly98AAKAnQgYmbpgWSvU5G3oKi
         00Afy4nFqKj5H/OZx1YbwxvtGLaNyHvKRUyj1anBFwurSeJHIpKBBCxot5EAM9o6W5yZ
         2k8ULFtRe5E0xma9qHp6Tm0W5ahgt+twCWB52ri3hnDHBWFbYqIpVaNDX91x6jy7X3qE
         1CYA==
X-Forwarded-Encrypted: i=1; AKwUvBxG6R3QOhLytv9JxXvxMrwFFmDq8sZDaAzqqAZPW9A9gdVYorMjahp9d5hZH0m+mRyfxgdyLD+HmqhiN1aA/g==@vger.kernel.org
X-Gm-Message-State: AFuF++m26QBF5EvYWtlpFJ7fXW0Bxx5cpvfhZeKHKq5D7nUa1n79fhJf
	aCJpB4AWJGrhjt+alCpB3B25txxpgfGoNCPJGPtEqkpfntBj9VjbrtNV5jGv+IjPZOFy+76Ti4c
	WIu8Ujh1qGDGkVmtfAV8DP+72N3snMDM67hAI8kHd
X-Gm-Gg: AYBFou0N3evJWZPn+IbvutndruKADgelylth1cPG+XrbovQxzCTAu5W9krfSuMNDQEs
	pMQfGR3YUZWtEAa5Cz8fe/NFY/7/Ho9l4lmjfNhR2vaIxNJXjxf0QLjt5rfIwi4jvZ2Au8C5kZt
	MUDuLqbm5REiWYgkxGsHB7Tlq1Zx2GhWBrDN3papv9qVUCL4V6CSwR15sdboTFSHEJVnUrVo7zE
	hfxn6UyfLHYLIelP5zyUh31Q9kqphM5Gm8kF3QwOq95nrKZr6HZgNZMieIfR8Bpd6lWUIO3Lk71
	T8j4HDmMmk0uzSgcx99Tfr9ptT19N1yf5ycBXlWw2JnaLrQVo0Jeb4fRskERb3OG2sJxR5USfHU
	tJtrG2qLI3tKsUFmm1kdV1C0GCLGm6cLT1TYYCo6waRSzgql3xf0sAsARiecG4V92Gl2AVoY4IO
	wemux2Y6f/yUCI+IKCm9ORCrSVbfgTiCdZbXVqsvdkjdy4ROFH9hOPLVrJcy9yNrb3OUC1KfgM1
	8aKDuW3gEdmHiiq2kP/JFSZ4LOJmRSkJVCGt5y9XGR5a4/Uo7PtoKg5z4edemBmauHd8PUac/9V
	ReStOzKCXzJyHxx86YEpTQ5q
X-Received: by 2002:a05:690c:60c4:b0:882:1d1f:ccb with SMTP id
 00721157ae682-88d1f9e215fmr5331177b3.8.1789368484215; Sun, 13 Sep 2026
 23:48:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726221908.104873-1-julius@bairaktaris.de>
 <20260726221908.104873-3-julius@bairaktaris.de> <CGME20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3@eucas1p1.samsung.com>
 <a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com> <dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>
In-Reply-To: <dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Mon, 14 Sep 2026 06:47:25 +0000
X-Gm-Features: AcwNN1UJxtZXAgjAG7UR_9O9cwtb9zT-R7CtVzX75Tvg07K3khGsBYzjwWq2LnQ
Message-ID: <CAC1t37J2N1OWkPUthz4XGkeNK47+QeV1siU5s=WtfsqbE=Osew@mail.gmail.com>
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, jjohnson@kernel.org, 
	ath11k@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, vasanthakumar.thiagarajan@oss.qualcomm.com, 
	rameshkumar.sundaram@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Hi Baochen,

I am without my router until 21 September 2026 and will report back
then.

Julius


Am Mo., 14. Sept. 2026 um 06:32 Uhr schrieb Baochen Qiang
<baochen.qiang@oss.qualcomm.com>:
>
>
>
> On 9/11/2026 3:53 PM, Marek Szyprowski wrote:
> > On 27.07.2026 00:19, Julius Bairaktaris wrote:
> >> On IPQ8074 a firmware assert reboots the SoC:
> >>
> >>   Unable to handle kernel read from unreadable memory at virtual address 0
> >>   pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
> >>   lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
> >>   Call trace:
> >>    ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
> >>    ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
> >>    ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
> >>    ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]
> >>    __napi_poll+0x38/0x188
> >>    net_rx_action+0x120/0x2c0
> >>
> >> ath11k_core_reconfigure_on_crash() tears the data path down with
> >> ath11k_dp_pdev_free(), ath11k_dp_free() and ath11k_hal_srng_clear(),
> >> which memsets the ring list. The DP NAPI is still running while that
> >> happens, so it services a ring whose address pointer has just been
> >> cleared.
> >>
> >> That function used to disable the interrupts first, until
> >> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> >> moved the disable into ath11k_core_reset(). reset_work is only queued
> >> from mhi.c and from the debugfs hw-restart handler, so AHB parts never
> >> run it on a real firmware crash. Their recovery goes QMI server exit ->
> >> restart_work -> ath11k_core_reconfigure_on_crash() ->
> >> ath11k_core_qmi_firmware_ready(), and nothing disables the interrupts
> >> anywhere along it.
> >>
> >> Disable them again on the crash path. The reset path has already done
> >> so by the time it gets here, hence the ab->is_reset check.
> >>
> >> This is also why the debugfs hw-restart trigger never showed the
> >> problem: it goes through ath11k_core_reset(), the one path that still
> >> had the disable.
> >>
> >> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1
> >>
> >> Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> >> Assisted-by: Claude:claude-opus-5
> >> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> >
> >
> > This patch landed recently in linux-next as commit f7a74e131d3f ("wifi: ath11k:
> > disable interrupts during firmware crash recovery"). In my tests I found that it
> > causes a regression on QCOM RB5 board during system suspend/resume cycle
> > (s2idle):
>
> Hi @Marek, can you please try if below diff can fix this regression? Also, @Julis, can you
> please also confirm if it can address your original issue as well?
>
> diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> index d2ed6a0ea7e3..1ad0a47653de 100644
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -1275,9 +1275,6 @@ int ath11k_core_suspend_late(struct ath11k_base *ab)
>         if (ab->actual_pm_policy == ATH11K_PM_WOW)
>                 return 0;
>
> -       ath11k_hif_irq_disable(ab);
> -       ath11k_hif_ce_irq_disable(ab);
> -
>         ath11k_hif_power_down(ab, true);
>
>         return 0;
> @@ -2333,17 +2330,9 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
>         int ret;
>
>         mutex_lock(&ab->core_lock);
> +       ath11k_hif_irq_disable(ab);
> +       ath11k_hif_ce_irq_disable(ab);
>         ath11k_thermal_unregister(ab);
> -
> -       /*
> -        * ath11k_core_reset() already disabled the interrupts on the reset
> -        * path; only the firmware crash path reaches here with them live.
> -        */
> -       if (!ab->is_reset) {
> -               ath11k_hif_irq_disable(ab);
> -               ath11k_hif_ce_irq_disable(ab);
> -       }
> -
>         ath11k_dp_pdev_free(ab);
>         ath11k_cfr_deinit(ab);
>         ath11k_spectral_deinit(ab);
> @@ -2605,9 +2594,6 @@ static void ath11k_core_reset(struct work_struct *work)
>         time_left = wait_for_completion_timeout(&ab->recovery_start,
>                                                 ATH11K_RECOVER_START_TIMEOUT_HZ);
>
> -       ath11k_hif_irq_disable(ab);
> -       ath11k_hif_ce_irq_disable(ab);
> -
>         ath11k_hif_power_down(ab, false);
>         ath11k_hif_power_up(ab);
>
> --
> 2.34.1
>
