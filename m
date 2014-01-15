Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48597 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAOTzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 14:55:52 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so2224900wgg.25
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 11:55:51 -0800 (PST)
Message-ID: <1389815739.3027.18.camel@canaries32-MCP7A> (sfid-20140115_205606_395539_7FFA98B3)
Subject: Re: [PATCH 6/6] staging: vt6656: sparse fixes: aes_ccmp.c missing
 header.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 19:55:39 +0000
In-Reply-To: <20140114211929.GD28705@kroah.com>
References: <1389630555.2590.6.camel@canaries32-MCP7A>
	 <20140113234614.GA16467@kroah.com>
	 <1389733208.8159.9.camel@canaries32-MCP7A>
	 <20140114211929.GD28705@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 13:19 -0800, Greg KH wrote:
> On Tue, Jan 14, 2014 at 09:00:08PM +0000, Malcolm Priestley wrote:
> > On Mon, 2014-01-13 at 15:46 -0800, Greg KH wrote:
> > > On Mon, Jan 13, 2014 at 04:29:15PM +0000, Malcolm Priestley wrote:
> > > > Add missing aes_ccmp.h header and move device.h to
> > > > aes_ccmp.h
> > > 
> > > Why move device.h?
> > device.h is needed by aes_ccmp.h and only currently gets away with it
> > by the include order elsewhere.
> 
> Then fix that up first.
> 
> > I didn't see the need to include device.h twice or fix
> > it with the include order in aes_ccmo.c, there is enough of
> > that already in this driver.
> 
> Fix it properly, as it will have to be resolved sometime, right?
> 
The headers are just too tangled to fix just yet.

There is still a lot of typedefs, duplicate and dead code spread across
the driver that need removing first.

I've just realised that aes_ccmp.c is dead code, it is part of the
non functioning hostapd code in hostap.c, I am planning to remove it.

Regards


Malcolm










> thanks,
> 
> greg k-h


