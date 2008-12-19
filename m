Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw-instruments.de ([82.144.60.34]:37104 "EHLO
	redbean.intranet.gw-instruments.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574AbYLSRA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 12:00:29 -0500
Date: Fri, 19 Dec 2008 17:57:48 +0100 (CET)
From: Peter Wippich <pewi@gw-instruments.de>
To: Andrey Yurovsky <andrey@cozybit.com>
cc: Harald Welte <laforge@gnumonks.org>,
	linux-wireless@vger.kernel.org, Colin McCabe <colin@cozybit.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices
In-Reply-To: <45e8e6c40812190831k7796e240w55c47d7ca6417437@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0812191745460.18864@redbean.intranet.gw-instruments.de> (sfid-20081219_180034_427854_120ED2D4)
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
 <1229398052-27465-2-git-send-email-colin@cozybit.com>
 <1229398052-27465-3-git-send-email-colin@cozybit.com>
 <1229398052-27465-4-git-send-email-colin@cozybit.com>
 <20081219160836.GQ9285@prithivi.gnumonks.org>
 <45e8e6c40812190831k7796e240w55c47d7ca6417437@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Andrey, 

> The '8686 requires us to assert CS# and then hold it asserted for the
> entire transaction.  The transaction is an arbitrary number of SPI
> transfers.  Most host controllers cannot do this (they'll toggle CS#
> between individual transactions) and therefore we chose to not use the
> controller CS# line and use a GPIO.  Can you suggest a different way
> to do this given the current SPI framework?

This can be handled by the SPI driver. See pxa2xx_spi.c as an example. 
Look for cs_control() to get the picture..... 
Perhaps this should go to the general driver and not be handled by the 
chip specific code. Seems a problem general enough.  

Chears, 

Peter 
