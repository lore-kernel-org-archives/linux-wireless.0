Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54464 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab3A3Pnt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 10:43:49 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k has buggy promiscuous mode
References: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be>
	<15452550.1ttGSZchYI@sylvesterjr.pats.ua.ac.be>
	<87622edabu.fsf@purkki.adurom.net>
	<1606478.o2vcQdheiZ@sylvesterjr.pats.ua.ac.be>
Date: Wed, 30 Jan 2013 17:43:47 +0200
In-Reply-To: <1606478.o2vcQdheiZ@sylvesterjr.pats.ua.ac.be> (Erwin Van de
	Velde's message of "Wed, 30 Jan 2013 15:56:33 +0100")
Message-ID: <87zjzqbrrg.fsf@purkki.adurom.net> (sfid-20130130_164353_629590_F2982D1B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erwin Van de Velde <erwin.vandevelde@gmail.com> writes:

> On Wednesday 30 January 2013 16:17:25 Kalle Valo wrote:
>> I don't understand, what do you mean software configuration?
>> 
>> A quick grep show that at least ath9k checks for the promisc filter:
>> 
>> ath9k/htc_drv_main.c:   (FIF_PROMISC_IN_BSS |                   \
>> ath9k/htc_drv_txrx.c:    * Set promiscuous mode when 
> FIF_PROMISC_IN_BSS
>> is enabled for station
>> ath9k/htc_drv_txrx.c:        (priv->rxfilter & FIF_PROMISC_IN_BSS)) ||
>> ath9k/main.c:   (FIF_PROMISC_IN_BSS |                   \
>> ath9k/recv.c:    * Set promiscuous mode when FIF_PROMISC_IN_BSS is
>> enabled for station
>
> I tried understanding the code, but it is hard without decent study of 
> course. FIF_PROMISC IN BSS I saw there in comment, but not in the code 
> :-) For monitor mode there is something like:
>
> if (sc->sc_ah->is_monitoring)
>                 rfilt |= ATH9K_RX_FILTER_PROM;

To be honest I don't know ath9k at all and I don't have time to look at
it either. I think we need to hope that either Shafi or Sujith notices
this thread and jump in.

Or you could try to debug it yourself. Sprinkle printks everywhere and
see what's happening inside the driver :)

-- 
Kalle Valo
