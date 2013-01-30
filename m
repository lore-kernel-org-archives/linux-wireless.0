Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48224 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab3A3OR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 09:17:26 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k has buggy promiscuous mode
References: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be>
	<87txq1crst.fsf@purkki.adurom.net>
	<1628374.rykW5SrKvm@sylvesterjr.pats.ua.ac.be>
	<15452550.1ttGSZchYI@sylvesterjr.pats.ua.ac.be>
Date: Wed, 30 Jan 2013 16:17:25 +0200
In-Reply-To: <15452550.1ttGSZchYI@sylvesterjr.pats.ua.ac.be> (Erwin Van de
	Velde's message of "Wed, 30 Jan 2013 11:09:32 +0100")
Message-ID: <87622edabu.fsf@purkki.adurom.net> (sfid-20130130_151729_860652_D844130A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erwin Van de Velde <erwin.vandevelde@gmail.com> writes:

> I have had a look at the source code of the driver and as far as I can see, 
> the driver just never looks at the software configuration when enabling 
> promiscuous mode and thus does not pass this information to the 
> system, which explains why packets are never captured in promiscuous 
> mode, even when the user configures the interface that way.

I don't understand, what do you mean software configuration?

A quick grep show that at least ath9k checks for the promisc filter:

ath9k/htc_drv_main.c:   (FIF_PROMISC_IN_BSS |                   \
ath9k/htc_drv_txrx.c:    * Set promiscuous mode when FIF_PROMISC_IN_BSS
is enabled for station
ath9k/htc_drv_txrx.c:        (priv->rxfilter & FIF_PROMISC_IN_BSS)) ||
ath9k/main.c:   (FIF_PROMISC_IN_BSS |                   \
ath9k/recv.c:    * Set promiscuous mode when FIF_PROMISC_IN_BSS is
enabled for station

-- 
Kalle Valo
