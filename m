Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53203 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaANVA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 16:00:28 -0500
Received: by mail-wg0-f48.google.com with SMTP id x13so926717wgg.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 13:00:27 -0800 (PST)
Message-ID: <1389733208.8159.9.camel@canaries32-MCP7A> (sfid-20140114_220032_524114_612AA080)
Subject: Re: [PATCH 6/6] staging: vt6656: sparse fixes: aes_ccmp.c missing
 header.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 21:00:08 +0000
In-Reply-To: <20140113234614.GA16467@kroah.com>
References: <1389630555.2590.6.camel@canaries32-MCP7A>
	 <20140113234614.GA16467@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-13 at 15:46 -0800, Greg KH wrote:
> On Mon, Jan 13, 2014 at 04:29:15PM +0000, Malcolm Priestley wrote:
> > Add missing aes_ccmp.h header and move device.h to
> > aes_ccmp.h
> 
> Why move device.h?
device.h is needed by aes_ccmp.h and only currently gets away with it
by the include order elsewhere.

I didn't see the need to include device.h twice or fix
it with the include order in aes_ccmo.c, there is enough of
that already in this driver.

Regards

Malcolm

> That shouldn't be needed to fix this issue.
> 
> > sparse warning
> > aes_ccmp.c:221:6: warning: symbol 'AESbGenCCMP' was not declared. Should it be static?
> > 
> > Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> > ---
> >  drivers/staging/vt6656/aes_ccmp.c | 2 +-
> >  drivers/staging/vt6656/aes_ccmp.h | 2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/vt6656/aes_ccmp.c b/drivers/staging/vt6656/aes_ccmp.c
> > index 61b9f7b..3dbf458 100644
> > --- a/drivers/staging/vt6656/aes_ccmp.c
> > +++ b/drivers/staging/vt6656/aes_ccmp.c
> > @@ -30,7 +30,7 @@
> >   * Revision History:
> >   */
> >  
> > -#include "device.h"
> > +#include "aes_ccmp.h"
> >  #include "80211hdr.h"
> >  
> >  /*
> > diff --git a/drivers/staging/vt6656/aes_ccmp.h b/drivers/staging/vt6656/aes_ccmp.h
> > index ed6a9ae..4cac3ec 100644
> > --- a/drivers/staging/vt6656/aes_ccmp.h
> > +++ b/drivers/staging/vt6656/aes_ccmp.h
> > @@ -30,6 +30,8 @@
> >  #ifndef __AES_H__
> >  #define __AES_H__
> >  
> > +#include "device.h"
> 
> If you can prevent it, keeping .h files from having to include other .h
> files is a good thing.
> 
> thanks,
> 
> greg k-h


