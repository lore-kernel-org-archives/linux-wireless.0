Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:48632 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbbASI1B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 03:27:01 -0500
Date: Mon, 19 Jan 2015 09:26:57 +0100 (CET)
From: Rico Derrer <rico.derrer@neratec.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Message-ID: <1748015898.90209.1421656017853.JavaMail.zimbra@neratec.com> (sfid-20150119_092705_220075_E90D773A)
In-Reply-To: <1998405401.90208.1421656011302.JavaMail.zimbra@neratec.com>
References: <1421241456-29085-1-git-send-email-nbd@openwrt.org> <377854068.83121.1421395226029.JavaMail.zimbra@neratec.com> <54B8EAD9.5050200@openwrt.org>
Subject: Re: [PATCH 3.19] ath9k: fix race condition in irq processing during
 hardware reset
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2015-01-16 09:00, Rico Derrer wrote:
>> Hi Felix
>> 
>> Felix Fietkau wrote:
>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c
>>> b/drivers/net/wireless/ath/ath9k/main.c
>>> index 9a72640..62b0bf4 100644
>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>> @@ -285,6 +285,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct
>>> ath9k_channel *hchan)
>>> 
>>> __ath_cancel_work(sc);
>>> 
>>> + disable_irq(sc->irq);
>>> tasklet_disable(&sc->intr_tq);
>>> tasklet_disable(&sc->bcon_tasklet);
>>> spin_lock_bh(&sc->sc_pcu_lock);
>>> @@ -331,6 +332,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct
>>> ath9k_channel *hchan)
>>> r = -EIO;
>>> 
>>> out:
>>> + enable_irq(sc->irq);
>>> spin_unlock_bh(&sc->sc_pcu_lock);
>>> tasklet_enable(&sc->bcon_tasklet);
>>> tasklet_enable(&sc->intr_tq);
>> 
>> This part completely blocks the system on a AR9350. Loading the
>> module works but configuring it hangs the system until watchdog restarts it.
> What kernel/software are you running on there? When I committed this
> patch to OpenWrt, it uncovered IRQ handling bugs in MIPS kernel code
> (both generic and in the ath79 platform code).
> 
> You can find the fixes that I've made here:
> http://git.openwrt.org/?p=openwrt.git;a=blob_plain;f=target/linux/generic/patches-3.14/130-mips_cpu_irq_disable.patch
> http://git.openwrt.org/?p=openwrt.git;a=blob_plain;f=target/linux/ar71xx/patches-3.14/736-MIPS-ath79-fix-chained-irq-disable.patch
> 
> I've already submitted the first one to linux-mips.
> 
> - Felix

Thank you, these patches fixed the problem.

Rico
