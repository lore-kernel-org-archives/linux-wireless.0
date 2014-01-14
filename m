Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:60249 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaANU0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 15:26:55 -0500
Received: by mail-we0-f178.google.com with SMTP id t60so923586wes.9
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 12:26:54 -0800 (PST)
Message-ID: <1389731210.7960.5.camel@canaries32-MCP7A> (sfid-20140114_212658_302281_BF094CAB)
Subject: Re: [PATCH 2/6] staging: vt6656:  sparse fixes: device_get_stats
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 20:26:50 +0000
In-Reply-To: <20140113234212.GA3066@kroah.com>
References: <1389629930.2590.1.camel@canaries32-MCP7A>
	 <20140113234212.GA3066@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-13 at 15:42 -0800, Greg KH wrote:
> On Mon, Jan 13, 2014 at 04:18:50PM +0000, Malcolm Priestley wrote:
> > sparse warning
> > main_usb.c:1442:44: warning: cast removes address space of expression
> > 
> > Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> > ---
> >  drivers/staging/vt6656/main_usb.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
> > index 4cb7aa7..59c2430 100644
> > --- a/drivers/staging/vt6656/main_usb.c
> > +++ b/drivers/staging/vt6656/main_usb.c
> > @@ -1418,8 +1418,9 @@ static void device_set_multi(struct net_device *dev)
> >  static struct net_device_stats *device_get_stats(struct net_device *dev)
> >  {
> >  	struct vnt_private *pDevice = netdev_priv(dev);
> > +	struct net_device_stats *stats = &pDevice->stats;
> >  
> > -	return &pDevice->stats;
> > +	return stats;
> 
> This change makes no sense to me.  Why is sparse complaining about this?
> 
> Is this a bug in sparse, or am I missing something obvious here?
Yes me!!!

Sorry. that is not line 1442, a case of number dyslexia.

That is fixed in the next patch.

Malcolm


