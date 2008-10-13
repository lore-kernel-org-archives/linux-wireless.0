Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36251 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYJMTO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 15:14:58 -0400
Received: by gxk9 with SMTP id 9so4112843gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 12:14:57 -0700 (PDT)
Message-ID: <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com> (sfid-20081013_211505_832057_44548983)
Date: Mon, 13 Oct 2008 22:14:56 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts per second at idle
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	yang.y.yi@gmail.com,
	"Vikram Kandukuri" <Vikram.Kandukuri@atheros.com>,
	"Jothikumar Mothilal" <Jothikumar.Mothilal@atheros.com>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <bug-11749-13098@http.bugzilla.kernel.org/>
	 <20081013150525.884BC108058@picon.linux-foundation.org>
	 <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/13 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Mon, Oct 13, 2008 at 8:05 AM,  <bugme-daemon@bugzilla.kernel.org> wrote:
>> http://bugzilla.kernel.org/show_bug.cgi?id=11749
>
> ---
> Bug description from kernel.org bugzilla
>
> Latest working kernel version: None
> Earliest failing kernel version: Unknow
> Distribution: all
> Hardware Environment: Atheros wireless chipset
> Software Environment: Fedora
> Problem Description: ath5k driver has many inperrupts per second although the
> system is idle.
>
> I used AspierOne to test it, interrupts are so many that CPU's C3 residence
> time is only 20 milliseconds or less, there isn't any valid traffic on my
> wireless network except beacon frame.
>
> I tested X61 in the same wireless environment, number of interrupt is only 1
> per second, X61 has the latest Intel wireless chipset and 2.6.27 kernel was
> running.
>
> So i think ath5k and ath9k should can do as Intel wireless driver does,
> otherwise, CPU can't stay at C3 with longer time because of wireless
> interrupts.
>
> Steps to reproduce:
> 1. Enable wireless on platform with Atheros wireless chipset.
> 2. watch cat /proc/interrupts
>
> ---
>
> Folks, ANI is not handled yet in ath5k (and won't be on 2.6.26). What
> I recommend is to try disabling MIB interrupts on the stable kernels
> where you won't make use of MIB statistics, which you need for ANI.
> Once you have ANI please enable the MIB interrupt.
>
> yang.y.yi, please try this patch (also attached for your convenience)
> and let us know if you see a difference.
>
>  Luis
>
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c
> index 0676c6d..c18ead9 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2246,8 +2246,7 @@ ath5k_init(struct ath5k_softc *sc)
>         * Enable interrupts.
>         */
>        sc->imask = AR5K_INT_RX | AR5K_INT_TX | AR5K_INT_RXEOL |
> -               AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL |
> -               AR5K_INT_MIB;
> +               AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL;
>
>        ath5k_hw_set_intr(sc->ah, sc->imask);
>        /* Set ack to be sent at low bit-rates */
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
