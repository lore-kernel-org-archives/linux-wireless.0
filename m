Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF15F3793A5
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789922565; cv=pass; b=RRAf/2NH2YZ6WLeCLmw+RbC/hWfr/zihOVBNOEFktGSdOdcFseg7JMCjKXdvbaX6fjndbV8urANKrPQ/QJds34njZHPPyqYHv3cDebSoVCX158CTRr+rS55m8S6mW4XJjDkBfdhLY58JRSZgf8w5QJjVbz732RYeLHHJZboXwx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789922565; c=relaxed/simple;
	bh=EkL9YWU3McSB/6TFR7GezgerqmTkHK4AZdOGAsISNn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BGA4v9MYop90ehI9apqd3EC5g3G0C0Pyz8tBQYXFYA8Vk33r9Fn/qGXn+e+m2a1sx0/f5uRSdjYgH7SvhQWV94fmJCqjuKelYA5NPaG/X8tlWHqzSucwd7mBX6r5zIiOk49ZXy6dthAiH/zNyVT5yqgnVSGnNW5ai9OzPz4TRXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=wOFinIyw; arc=pass smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="wOFinIyw"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d440939e3so13844717b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 09:42:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789922563; cv=none;
        d=google.com; s=arc-20260327;
        b=AK7XemuNTFINeG3Vry8UKvH8O/47OI+vKDB4acZoRuxti3q+1YZX0+6JgU2m7tZ5qE
         tGRHC75nb7EtC8k7/ujpjzXAzrv49YNzlmfxX07/XSB0iIUO3xYk0Xtbc4gCvcv9YgYe
         CyeepUqithCRwTv/po4hAGL8T+VFI17YLFJ9g2iHqt+QS6EZWOswhaWwf6TG2WNjk3ph
         +pgFHh/Xeu4+gAcab2t3NaT3C7X08FWqeuchT0ycQIHV1ddk/ox8kRHrVlInb1LeOzUa
         CtBTsp8B5Ma+zx0mVV1Lr1R230E/S1YNewN7Wo+DAqifKSdHZ02rGXFWZoW199i2v1rN
         mJeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=nHza7uhFopdEpXjnPqVhCbEMpK63s/WOhYzeeG3B/+A=;
        fh=3pRAVsp1n9xfVavEEhMak9KDmPwFp75nnRL1bVXrUuE=;
        b=RPSIIeDr66eRb3p7WonQmhDq0aBHJUEOGEPzyQ0ZWFYSnWpx1QRAT5n8tRvuTNKPVi
         +ehGVN8MvaaVYdWIncMR4E7ttjlC4Bo13GU/hC7aggcYo7bLkiUErHEAMg5Qx7o0Og5R
         PuLdoAe9ouyVfux9m9SnyuGRuTRZnuDvmNzrLJuB2kPyEm6PyAS/ZOT4C6SxbiHKlzED
         bViIto/aCrNTossuuAPOO+K/Dp0/Ev1J6I2vkWLPTYclsbw2ux0QHJ69dCb1Y7rAB37B
         /tyBCFAjeKtq52sjRebmTwjfYSP3DMdT4m4/Cv6OBUNVyJahXJ2E+MDPUUsrF1pYj2Ju
         Xw5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789922563; x=1790527363; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nHza7uhFopdEpXjnPqVhCbEMpK63s/WOhYzeeG3B/+A=;
        b=wOFinIywN+7CPY/DG8xaJj1czKt4fI0fIP8kFDQyqHZCMaHCTSUqWfmSRy+JL4vjO2
         9QfYE/f3s3WNXclty9vTTrHpeTRYpIU5kdrDvo88dH/9WPVbrkwwm4TwJLEBAZG3SdzU
         hDOXR/7Cz7QZ1ufdk1sE2YUheQ3u0rdatuWR6oDaLvgzIyLeglOd5ljr0lBHHiDPNPEW
         kZtJp7iz8tfhn56sOYOgF/zuvIetyiarCaHqeMInh0BKn9zCwZPNSv60zLr5PpgneHN+
         zarRBBUaJ8eVS8mQCgH30ukKXRiTt+xNRv7x+1/omrU9/KDBHHUCfpn/+ipFGfKrw13z
         8ZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789922563; x=1790527363;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nHza7uhFopdEpXjnPqVhCbEMpK63s/WOhYzeeG3B/+A=;
        b=Cj72+WYFBXh/mlyq/V4/w3fMhzuIwDny2wfUVZi+/48iQ9kBES3d1rIcw3KyAIUF/o
         uLrADD3GBQLT+GqN9yyXZiWNzkY2R+VA4YkEN4FJ0CV+On3uz1gg5nb7KrbQu6lLaqX3
         QMQXaeSEFSB8M+/8TTHH+61poi1OduR17UMbCK6Y1wHWNh1nVcN+vSCGRLeK6dMAj4kt
         szgjpqWNGvgs/6aUi8wi9e9VjY2c3PqSmaM0+9tYuC4NQyLTuRnUwnk+GIGkw5c7KouU
         IemQ6TdpFRz3VeTex3MvW+Rwg+eggIO4yHlUO0lSdt1miCruqUOVkhmLvkHJ8hrlRGGu
         gCpA==
X-Forwarded-Encrypted: i=1; AKwUvBxZiUMhEEiBHn8Kjp6+0CSt5KQYdR4pfMUWFJXjpxsMx9qBCGjwS8LwiKGTFZ+vODsSZYEr30Gx1D27SKeqMw==@vger.kernel.org
X-Gm-Message-State: AFuF++nG3JlAcZ38KLLQYUGXyj7U6CYrbny0TnRsmqM6XMjBjlJSCTCg
	67Vg8shW4A8d3odnwUrLpYpRSNZwqDkCvx5hrQG1TuZut3dF4CUsLhw9dATyFRR1WMHwRGYYa35
	wYx32ZPqaFAPpfkufVtqobn7pt0MmbXOAHd1utzhe
X-Gm-Gg: AYBFou1PuLdWm9lqKs00VodwYSsIlPzqX61NH/RK/Qo4/otaoRPvu6pQ7iqEWBoMkXE
	lZMgaP7YZBs+Wpb2XyH5jPsCHTzjohWoVB/LtxW7QPoZQHvKnRj2C6bFo8rxX/9CEoyMsvJ54qA
	jSkOap+M2utgJIJ2bvqbcBVxhWW/3F8+RysC9Mv8mpg0RfJiZLfaAmAqxvExs2DgdxuALEWChU+
	VbFeC0wDxoq6WwbEVBy4DUninwYCP44VhkbC7tiepWZO5QhYk4E3r44FC/0LAULgNWfExqIMxvp
	qbiiFSAWqREyWZ4wrYqYPnKlue6nKflByVWcnfWWAOF5jq8GnWbaGpmwunO0xOR7AfI1qitzLqL
	sf7iz3pFuUOTHLV1XS28pGl6h4G4GWvfs/Ebsj6Jl4+jBI7zKVDBVbMJ5x3q81EIYUhTIqwIttd
	xl6znZK6luyNHHiPzQPCal2yUVYHTfT4VP1pXLKxIN8IQg2V/V7nDAr/bdotiKIhzdux3R+6Oh3
	HqGzPy24t6XnONemPvFNFBzY6fdgM8nnVpl9+JBXBTeTPVVY68KCmBbRKjDMH7HTxbyQOjIn0sO
	eEap6a0Kh5U=
X-Received: by 2002:a05:690c:315:b0:86f:3b4a:f8b2 with SMTP id
 00721157ae682-89730eed53amr31830807b3.16.1789922562709; Sun, 20 Sep 2026
 09:42:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726221908.104873-1-julius@bairaktaris.de>
 <20260726221908.104873-3-julius@bairaktaris.de> <CGME20260911075315eucas1p1b4ffb1f57ef187e0a055072ccc0983e3@eucas1p1.samsung.com>
 <a068a857-a549-4cc2-ae0f-3ef119d3a859@samsung.com> <dd342f3d-36d3-4a85-95ca-6cacb7b834ad@oss.qualcomm.com>
 <10491411-b500-4e89-bf85-5142ced60aaf@samsung.com>
In-Reply-To: <10491411-b500-4e89-bf85-5142ced60aaf@samsung.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sun, 20 Sep 2026 16:42:08 +0000
X-Gm-Features: AcwNN1X9njNa5bud7U1eFhRRabFMS_lFHDaJorC6mykzTt2Nulm24Bp200Rb6sM
Message-ID: <CAC1t37Ltrh+BBaEPi8grXnMrDt3qGDH8BA56av-h7=yPCCk0Nw@mail.gmail.com>
Subject: Re: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during
 firmware crash recovery
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, jjohnson@kernel.org, 
	ath11k@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, vasanthakumar.thiagarajan@oss.qualcomm.com, 
	rameshkumar.sundaram@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

Hi @Baochen,

tested 5 times and it solves the problem. Thanks!

Julius


Am Mo., 14. Sept. 2026 um 07:22 Uhr schrieb Marek Szyprowski
<m.szyprowski@samsung.com>:
>
> On 14.09.2026 08:32, Baochen Qiang wrote:
> > On 9/11/2026 3:53 PM, Marek Szyprowski wrote:
> >> On 27.07.2026 00:19, Julius Bairaktaris wrote:
> >>> On IPQ8074 a firmware assert reboots the SoC:
> >>>
> >>>   Unable to handle kernel read from unreadable memory at virtual address 0
> >>>   pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
> >>>   lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
> >>>   Call trace:
> >>>    ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
> >>>    ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
> >>>    ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
> >>>    ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]
> >>>    __napi_poll+0x38/0x188
> >>>    net_rx_action+0x120/0x2c0
> >>>
> >>> ath11k_core_reconfigure_on_crash() tears the data path down with
> >>> ath11k_dp_pdev_free(), ath11k_dp_free() and ath11k_hal_srng_clear(),
> >>> which memsets the ring list. The DP NAPI is still running while that
> >>> happens, so it services a ring whose address pointer has just been
> >>> cleared.
> >>>
> >>> That function used to disable the interrupts first, until
> >>> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> >>> moved the disable into ath11k_core_reset(). reset_work is only queued
> >>> from mhi.c and from the debugfs hw-restart handler, so AHB parts never
> >>> run it on a real firmware crash. Their recovery goes QMI server exit ->
> >>> restart_work -> ath11k_core_reconfigure_on_crash() ->
> >>> ath11k_core_qmi_firmware_ready(), and nothing disables the interrupts
> >>> anywhere along it.
> >>>
> >>> Disable them again on the crash path. The reset path has already done
> >>> so by the time it gets here, hence the ab->is_reset check.
> >>>
> >>> This is also why the debugfs hw-restart trigger never showed the
> >>> problem: it goes through ath11k_core_reset(), the one path that still
> >>> had the disable.
> >>>
> >>> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1
> >>>
> >>> Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> >>> Assisted-by: Claude:claude-opus-5
> >>> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> >>
> >> This patch landed recently in linux-next as commit f7a74e131d3f ("wifi: ath11k:
> >> disable interrupts during firmware crash recovery"). In my tests I found that it
> >> causes a regression on QCOM RB5 board during system suspend/resume cycle
> >> (s2idle):
> > Hi @Marek, can you please try if below diff can fix this regression? Also, @Julis, can you
> > please also confirm if it can address your original issue as well?
>
>
> Works fine in my tests, feel free to add:
>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
>
> > diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> > index d2ed6a0ea7e3..1ad0a47653de 100644
> > --- a/drivers/net/wireless/ath/ath11k/core.c
> > +++ b/drivers/net/wireless/ath/ath11k/core.c
> > @@ -1275,9 +1275,6 @@ int ath11k_core_suspend_late(struct ath11k_base *ab)
> >       if (ab->actual_pm_policy == ATH11K_PM_WOW)
> >               return 0;
> >
> > -     ath11k_hif_irq_disable(ab);
> > -     ath11k_hif_ce_irq_disable(ab);
> > -
> >       ath11k_hif_power_down(ab, true);
> >
> >       return 0;
> > @@ -2333,17 +2330,9 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
> >       int ret;
> >
> >       mutex_lock(&ab->core_lock);
> > +     ath11k_hif_irq_disable(ab);
> > +     ath11k_hif_ce_irq_disable(ab);
> >       ath11k_thermal_unregister(ab);
> > -
> > -     /*
> > -      * ath11k_core_reset() already disabled the interrupts on the reset
> > -      * path; only the firmware crash path reaches here with them live.
> > -      */
> > -     if (!ab->is_reset) {
> > -             ath11k_hif_irq_disable(ab);
> > -             ath11k_hif_ce_irq_disable(ab);
> > -     }
> > -
> >       ath11k_dp_pdev_free(ab);
> >       ath11k_cfr_deinit(ab);
> >       ath11k_spectral_deinit(ab);
> > @@ -2605,9 +2594,6 @@ static void ath11k_core_reset(struct work_struct *work)
> >       time_left = wait_for_completion_timeout(&ab->recovery_start,
> >                                               ATH11K_RECOVER_START_TIMEOUT_HZ);
> >
> > -     ath11k_hif_irq_disable(ab);
> > -     ath11k_hif_ce_irq_disable(ab);
> > -
> >       ath11k_hif_power_down(ab, false);
> >       ath11k_hif_power_up(ab);
> >
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
