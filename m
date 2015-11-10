Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:44360 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752695AbbKJXrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:47:06 -0500
Message-ID: <1447199222.2701.109.camel@perches.com> (sfid-20151111_004739_130769_4D07AA8C)
Subject: Re: [PATCH 01/20] staging/wilc1000: add struct net_device
 declaration
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Nov 2015 15:47:02 -0800
In-Reply-To: <1447198960-2760143-2-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
	 <1447198960-2760143-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-11-11 at 00:42 +0100, Arnd Bergmann wrote:
> A recent cleanup added a reference to struct net_device, but
> that structure is not always visible in the context of the
> declaration, so we may get a compile-time error:
> 
> In file included from wilc1000/host_interface.c:5:0:
> wilc1000/host_interface.h:705:46: warning: 'struct net_device' declared inside parameter list
>  s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
> 
> This adds a forward-declaration for the structure name to avoid
> that error.

why not #include <linux/netdevice.h> ?

