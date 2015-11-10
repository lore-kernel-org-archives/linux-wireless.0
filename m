Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62479 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbKJXxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:53:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] staging/wilc1000: add struct net_device declaration
Date: Wed, 11 Nov 2015 00:53:01 +0100
Message-ID: <15534132.UNG42q60hp@wuerfel> (sfid-20151111_005331_327377_AE65E4E5)
In-Reply-To: <1447199222.2701.109.camel@perches.com>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de> <1447198960-2760143-2-git-send-email-arnd@arndb.de> <1447199222.2701.109.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 November 2015 15:47:02 Joe Perches wrote:
> On Wed, 2015-11-11 at 00:42 +0100, Arnd Bergmann wrote:
> > A recent cleanup added a reference to struct net_device, but
> > that structure is not always visible in the context of the
> > declaration, so we may get a compile-time error:
> > 
> > In file included from wilc1000/host_interface.c:5:0:
> > wilc1000/host_interface.h:705:46: warning: 'struct net_device' declared inside parameter list
> >  s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
> > 
> > This adds a forward-declaration for the structure name to avoid
> > that error.
> 
> why not #include <linux/netdevice.h> ?
> 

The headers in this driver are still a bit fragile, better not
add in too many other headers, especially before the rest of my
series is applied.

	Arnd
