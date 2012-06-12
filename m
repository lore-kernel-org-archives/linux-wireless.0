Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50582 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2FLTsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 15:48:07 -0400
Date: Tue, 12 Jun 2012 15:44:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix softlockup in AR9485
Message-ID: <20120612194429.GB1932@tuxdriver.com> (sfid-20120612_214812_417994_3E268602)
References: <1339512223-17514-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339512223-17514-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do you have a version that applies to 3.5 and earlier?

On Tue, Jun 12, 2012 at 08:13:43PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> steps to recreate:
> load latest ath9k driver with AR9485
> stop the network-manager and wpa_supplicant
> bring the interface up
> 
> 	Call Trace:
> 	[<ffffffffa0517490>] ? ath_hw_check+0xe0/0xe0 [ath9k]
> 	[<ffffffff812cd1e8>] __const_udelay+0x28/0x30
> 	[<ffffffffa03bae7a>] ar9003_get_pll_sqsum_dvc+0x4a/0x80 [ath9k_hw]
> 	[<ffffffffa05174eb>] ath_hw_pll_work+0x5b/0xe0 [ath9k]
> 	[<ffffffff810744fe>] process_one_work+0x11e/0x470
> 	[<ffffffff8107530f>] worker_thread+0x15f/0x360
> 	[<ffffffff810751b0>] ? manage_workers+0x230/0x230
> 	[<ffffffff81079af3>] kthread+0x93/0xa0
> 	[<ffffffff815fd3a4>] kernel_thread_helper+0x4/0x10
> 	[<ffffffff81079a60>] ? kthread_freezable_should_stop+0x70/0x70
> 	[<ffffffff815fd3a0>] ? gs_change+0x13/0x13
> 
> ensure that the PLL-WAR for AR9485/AR9340 is executed only if the STA is
> associated (or) IBSS/AP mode had started beaconing. Ideally this WAR
> is needed to recover from some rare beacon stuck during stress testing.
> Before the STA is associated/IBSS had started beaconing, PLL4(0x1618c)
> always seem to have zero even though we had configured PLL3(0x16188) to
> query about PLL's locking status. When we keep on polling infinitely PLL4's
> 8th bit(ie check for PLL locking measurements is done), machine hangs
> due to softlockup.
> 
> fixes https://bugzilla.redhat.com/show_bug.cgi?id=811142
> 
> Reported-by: Rolf Offermanns <rolf.offermanns@gmx.net>
> Cc: stable@vger.kernel.org
> Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/link.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
> index 0cc4c70..a105c94 100644
> --- a/drivers/net/wireless/ath/ath9k/link.c
> +++ b/drivers/net/wireless/ath/ath9k/link.c
> @@ -136,6 +136,14 @@ void ath_hw_pll_work(struct work_struct *work)
>  	u32 pll_sqsum;
>  	struct ath_softc *sc = container_of(work, struct ath_softc,
>  					    hw_pll_work.work);
> +	/*
> +	 * ensure that the PLL WAR is executed only
> +	 * after the STA is associated (or) if the
> +	 * beaconing had started in interfaces that
> +	 * uses beacons.
> +	 */
> +	if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
> +		return;
>  
>  	ath9k_ps_wakeup(sc);
>  	pll_sqsum = ar9003_get_pll_sqsum_dvc(sc->sc_ah);
> -- 
> 1.7.0.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
