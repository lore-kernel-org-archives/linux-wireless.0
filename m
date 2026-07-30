Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8322365A02;
	Thu, 30 Jul 2026 05:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785387984; cv=none; b=mZUeXIFF9AU4eJie+S9S56Ce8aLQORXtzo6epOb+7RrXsrJAq52Yn0COkLzNUZI1/v0Y0IzCLyYmUB4wl9f5utk6dZtLaBOZKO2Jnp+PiWCMoQd8rSKOzfqw9DGpK63pH1Md8Ad9QTD9YRNJM5NFpZKeQ2UhG19OnIvesu+UfeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785387984; c=relaxed/simple;
	bh=a8r5fvRS3b30rRiB80xchr2f9SsqV67jICw9rMXkb+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgxhjOvQGKj2ZzJZVQ9QHH64kK8D4PJkSXObbv97V15jRAHyAiSOoQVSULgAG7OoI855trcD/e53kDDgmy4nAS8WGf1SsxeaA0GrqRn05HRukaXIZsPnNLf4yW9YL4ZAxA69Ungo4FBqUuRpQ8yk858K46Ee5yfDtTELClelG0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kH2at8HM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH2at8HM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D351F000E9;
	Thu, 30 Jul 2026 05:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785387982;
	bh=6JnGdARcjRcMJ3O9A32uILN7Cw3AIHsSKXJfkvtHhQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kH2at8HMR4uwrVXup1Zp00j4kwAvjDr1tx5qYFIBw85TsBvEOOilGY4OP8OFs4AP/
	 fibkKm+nJjpGCYWWKmk9z40IBc3+Hly9K9tyul5IS3fTlq3dRw3DMry9GK1dv/86Gr
	 +Betj2xeDN4ejWxyr3limNrvFeqXAIBxnPl5nNCNM5BaztBkgGll8+vTkAhxZ74znG
	 XSImsFFIvw0bzbrtjtsYvATBxxo7/KSdp3r+wwxT4cc8eiSFVVCRhUVrt/yxXXrz9p
	 PlzDexCfbY8UzdF+xgspRpltTBlPmEq1TXb4bbPUg6U7PKo/9r0rQYgp2TYGL20syk
	 RrnRVhx9PFO0w==
Date: Wed, 29 Jul 2026 22:04:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bert Karwatzki <spasswolf@web.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable()
 in unregister path
Message-ID: <20260730050428.GA73812@sol>
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>

On Tue, Jul 28, 2026 at 05:20:48AM +0500, Mikhail Gavrilov wrote:
> Commit 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
> made mt76_dma_cleanup() disable every RX NAPI instance before deleting
> it.  mt7921e_unregister_device() and mt7925e_unregister_device() already
> disable the very same instances and only afterwards call
> mt792x_dma_cleanup() -> mt76_dma_cleanup(), so each instance is now
> disabled twice.
> 
> napi_disable() is not idempotent: on return it leaves NAPIF_STATE_SCHED
> and NAPIF_STATE_NPSVC set, so a second call without an intervening
> napi_enable() spins in usleep_range() forever, waiting for bits that
> nobody will clear:
> 
>   task:modprobe        state:D stack:25720 pid:7954  tgid:7954
>   Call Trace:
>    <TASK>
>    __schedule+0x11b8/0x26d0
>    schedule+0xe7/0x2f0
>    schedule_hrtimeout_range_clock+0x218/0x330
>    usleep_range_state+0x133/0x1b0
>    napi_disable_locked+0x37d/0x5f0
>    napi_disable+0x43/0x80
>    mt76_dma_cleanup+0x2b4/0x860 [mt76]
>    mt7921_pci_remove+0x17f/0x350 [mt7921e]
>    pci_device_remove+0xb6/0x1e0
>    device_release_driver_internal+0x38d/0x540
>    driver_detach+0xd0/0x1b0
>    bus_remove_driver+0x127/0x2d0
>    pci_unregister_driver+0x2a/0x280
>    __do_sys_delete_module+0x36a/0x5b0
>    do_syscall_64+0x11c/0x6d0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
> 
> mt7921_pci_shutdown() and mt7925_pci_shutdown() reuse the remove path,
> so the same deadlock is hit on every reboot and poweroff.  It is silent:
> the stuck task keeps sleeping and rescheduling, so neither the hung task
> detector nor the lockup detectors fire, and the last line on the console
> is "systemd-shutdown[1]: Rebooting."
> 
> Drop the driver-side loops and rely on mt76_dma_cleanup() instead.
> mt792x_dma_cleanup() stops and resets the WFDMA engine before calling
> it, so RX is already quiesced when the NAPI instances are disabled
> there.
> 
> Fixes: 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
> Reported-by: Bert Karwatzki <spasswolf@web.de>
> Closes: https://lore.kernel.org/all/20260724151419.26014-1-spasswolf@web.de/
> Suggested-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

While this patch fixes the shutdown hang for me too on a system using
mt7925e, Sashiko found that this patch introduces a use-after-free
because NAPI is now being disabled too late:
https://sashiko.dev/#/patchset/20260728002048.19351-1-mikhail.v.gavrilov%40gmail.com
Should 13b7e6a96a00 be reverted, then fixed in another way such as
calling napi_disable() in mt7915_unregister_device()?

- Eric
