Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52051 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbbAPKlp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:41:45 -0500
Message-ID: <54B8EAD9.5050200@openwrt.org> (sfid-20150116_114148_505024_3ACF43F5)
Date: Fri, 16 Jan 2015 11:41:29 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rico Derrer <rico.derrer@neratec.com>
CC: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 3.19] ath9k: fix race condition in irq processing during
 hardware reset
References: <1421241456-29085-1-git-send-email-nbd@openwrt.org> <377854068.83121.1421395226029.JavaMail.zimbra@neratec.com>
In-Reply-To: <377854068.83121.1421395226029.JavaMail.zimbra@neratec.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-01-16 09:00, Rico Derrer wrote:
> Hi Felix
> 
> Felix Fietkau wrote:
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c
>> b/drivers/net/wireless/ath/ath9k/main.c
>> index 9a72640..62b0bf4 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -285,6 +285,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct
>> ath9k_channel *hchan)
>> 
>> __ath_cancel_work(sc);
>> 
>> + disable_irq(sc->irq);
>> tasklet_disable(&sc->intr_tq);
>> tasklet_disable(&sc->bcon_tasklet);
>> spin_lock_bh(&sc->sc_pcu_lock);
>> @@ -331,6 +332,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct
>> ath9k_channel *hchan)
>> r = -EIO;
>> 
>> out:
>> + enable_irq(sc->irq);
>> spin_unlock_bh(&sc->sc_pcu_lock);
>> tasklet_enable(&sc->bcon_tasklet);
>> tasklet_enable(&sc->intr_tq);
> 
> This part completely blocks the system on a AR9350. Loading the
> module works but configuring it hangs the system until watchdog restarts it.
What kernel/software are you running on there? When I committed this
patch to OpenWrt, it uncovered IRQ handling bugs in MIPS kernel code
(both generic and in the ath79 platform code).

You can find the fixes that I've made here:
http://git.openwrt.org/?p=openwrt.git;a=blob_plain;f=target/linux/generic/patches-3.14/130-mips_cpu_irq_disable.patch
http://git.openwrt.org/?p=openwrt.git;a=blob_plain;f=target/linux/ar71xx/patches-3.14/736-MIPS-ath79-fix-chained-irq-disable.patch

I've already submitted the first one to linux-mips.

- Felix
