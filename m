Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45901 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab1KNWX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 17:23:28 -0500
Date: Mon, 14 Nov 2011 17:23:24 -0500
From: Pavel Roskin <proski@gnu.org>
To: =?UTF-8?B?QW5kcsOpcyBHYXJjw61h?= Saavedra
	<andres.garcia.saavedra@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] force AR5212 to sleep
Message-ID: <20111114172324.511d676a@mj> (sfid-20111114_232331_551994_C713B20C)
In-Reply-To: <CADxqDgFoO63RG67McnxUJSmxZ9ZPPnE7obKkn+MZAsoJ4UMQtg@mail.gmail.com>
References: <CADxqDgFoO63RG67McnxUJSmxZ9ZPPnE7obKkn+MZAsoJ4UMQtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 14 Nov 2011 11:42:24 +0100
Andrés García Saavedra <andres.garcia.saavedra@gmail.com> wrote:

> Hi all,
> 
> I am testing some custom algorithms for powersaving using
> mac80211/ath5k. I am using  Dlink DWL-AG660 PCMCIA cards for my
> experiments. For these algorithms I am notifying sleep/awake events
> from mac80211 down to the driver whenever I want to. For the case of
> ath5k I followed that code madwifi was using to force the chipset to
> sleep (full sleep mode), find the piece of code below:
> 
> The problem is, the card (and the laptop) totally freezes whenever
> this is done. According to
> http://madwifi-project.org/wiki/Compatibility/D-Link this card uses a
> AR5212, and madwifi driver does use this piece of code to force the
> chip to sleep (in that case when resetting or stopping an interface).
> 
> Undoubtedly, I am missing something I should take care of. I'd
> appreciate any "clue" you could give me.
> 
> 
> /**** CODE *****/
> 
>     struct ath5k_softc *sc = hw->priv;
>     struct ath5k_hw *ah = sc->ah;

You must be using an outdated kernel if you have to do this.

>     unsigned int i;
>     u32 staid, data;
> 
>     staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
> 
>     ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_ALLOW, AR5K_SLEEP_CTL);
> 
>     staid |= AR5K_STA_ID1_PWR_SV;
> 
>     ath5k_hw_reg_write(ah, staid, AR5K_STA_ID1);

Just try one or two of those statements to see which is causing
trouble.  Obviously, you'll need to print staid first so that you write
the same value as ath5k_hw_reg_read() returned.  It's also important
when you read the registers.  Try adding your code to the code that
already accesses those registers.

-- 
Regards,
Pavel Roskin
