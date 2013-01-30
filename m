Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54493 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3A3O4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 09:56:39 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so906008eek.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 06:56:38 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>
Subject: Re: ath9k has buggy promiscuous mode
Date: Wed, 30 Jan 2013 15:56:33 +0100
Message-ID: <1606478.o2vcQdheiZ@sylvesterjr.pats.ua.ac.be> (sfid-20130130_155642_993554_35478F4C)
In-Reply-To: <87622edabu.fsf@purkki.adurom.net>
References: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be> <15452550.1ttGSZchYI@sylvesterjr.pats.ua.ac.be> <87622edabu.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 January 2013 16:17:25 Kalle Valo wrote:
> I don't understand, what do you mean software configuration?
> 
> A quick grep show that at least ath9k checks for the promisc filter:
> 
> ath9k/htc_drv_main.c:   (FIF_PROMISC_IN_BSS |                   \
> ath9k/htc_drv_txrx.c:    * Set promiscuous mode when 
FIF_PROMISC_IN_BSS
> is enabled for station
> ath9k/htc_drv_txrx.c:        (priv->rxfilter & FIF_PROMISC_IN_BSS)) ||
> ath9k/main.c:   (FIF_PROMISC_IN_BSS |                   \
> ath9k/recv.c:    * Set promiscuous mode when FIF_PROMISC_IN_BSS is
> enabled for station

I tried understanding the code, but it is hard without decent study of 
course. FIF_PROMISC IN BSS I saw there in comment, but not in the code 
:-) For monitor mode there is something like:

if (sc->sc_ah->is_monitoring)
                rfilt |= ATH9K_RX_FILTER_PROM;

Best regards,
Erwin


