Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57415.mail.re1.yahoo.com ([66.196.100.67]:31191 "HELO
	web57415.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754558Ab1CVCpr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 22:45:47 -0400
Message-ID: <760599.40938.qm@web57415.mail.re1.yahoo.com>
Date: Mon, 21 Mar 2011 19:45:45 -0700 (PDT)
From: Joe Gunn <armadefuego@yahoo.com>
Subject: Re: [Orinoco-devel] [PATCH 2.6.38-rc8-wl RESEND] orinoco: Clear dangling pointer on hardware busy
To: armadefuego@gmail.com, Dave Kilroy <kilroyd@googlemail.com>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <4D87D3E0.4080408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your response(s).

--- On Mon, 3/21/11, Dave Kilroy <kilroyd@googlemail.com> wrote:

> From: Dave Kilroy <kilroyd@googlemail.com>
> Subject: Re: [Orinoco-devel] [PATCH 2.6.38-rc8-wl RESEND] orinoco: Clear dangling pointer on hardware busy
> To: armadefuego@gmail.com
> Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
> Date: Monday, March 21, 2011, 6:40 PM
> On 21/03/2011 08:21, armadefuego@gmail.com
> wrote:
> > On hardware busy the scan request pointer should be
> cleared, as higher levels will release. This avoids a crash
> when that pointer is erroneously used later.
> 
> I think you need to add line breaks for the git log
>

Sorry i am new to this.
logs on git don't have a column length  restriction. Is there a "80", or
so, column restriction suggested for this? 

> > Signed-off-by: Joseph J. Gunn<armadefuego@yahoo.com>
> > ---
> > When the hardware is busy the error is propagated to
> higher levels on the stack. Those layers release the buffer.
> Therefore the copy of the pointer must be erased. Otherwise
> subsequent events checking this pointer ma crash.
> > ---
> > diff --git a/drivers/net/wireless/orinoco/cfg.c
> b/drivers/net/wireless/orinoco/cfg.c
> > index 09fae2f..2022815 100644
> > --- a/drivers/net/wireless/orinoco/cfg.c
> > +++ b/drivers/net/wireless/orinoco/cfg.c
> > @@ -151,8 +151,17 @@ static int orinoco_scan(struct
> wiphy *wiphy, struct net_device *dev,
> >          
> return -EBUSY;
> >
> >      
> priv->scan_request = request;
> > +    DEBUG(3, "orinoco_scan():"
> > +        " scan_request
> %p wiphy %p, dev %p\n",
> > +       
> priv->scan_request,
> > +       
> priv->scan_request->wiphy,
> > +       
> priv->scan_request->dev
> > +        );
> >
> >       err =
> orinoco_hw_trigger_scan(priv, request->ssids);
> > +    /* On EBUSY the hardware is busy.
> We aren't processing the request */
> > +    if (err == -EBUSY)
> 
> We should reset priv->scan_request on all errors, not
> just -EBUSY. Were 
> you getting this in a particular situation? If so,
> highlighting it in 
> the commit log is useful.
> 
> I notice -EBUSY is returned when we can't get the
> orinoco_lock - are you 
> having an issue with lock cotention on a particular
> device?
The calls for orinoco_lock seem to be well placed from a software point.
 
There are other cases where the low level hardware routines return EBUSY. When the hardware can not accept the command. This is the situation i can
reproduce.

It is possible, probable even, that all cases of error do not propagate
the scan request. I don't know the driver that well yet.
I chose to limit the effect of the patch to the case i could prove.

> 
> > +       
> priv->scan_request = NULL;
> >
> >       return err;
> >   }
> > diff --git a/drivers/net/wireless/orinoco/scan.c
> b/drivers/net/wireless/orinoco/scan.c
> > index e99ca1c..698e9ff 100644
> > --- a/drivers/net/wireless/orinoco/scan.c
> > +++ b/drivers/net/wireless/orinoco/scan.c
> > @@ -230,6 +230,12 @@ void
> orinoco_add_hostscan_results(struct orinoco_private *priv,
> >
> >    scan_abort:
> >       if
> (priv->scan_request) {
> > +        DEBUG(3,
> "orinoco_add_hostscan_results():"
> > +       
>     " scan_request %p wiphy %p, dev %p\n",
> > +       
>     priv->scan_request,
> > +       
>     priv->scan_request->wiphy,
> > +       
>     priv->scan_request->dev
> > +       
>     );
> 
> I'm not a big fan of scattering DEBUG statements about, but
> if we're 
> going to, use __FUNCTION__ (or whatever the C99 incarnation
> is) rather 
> than explicitly naming the functions.
> 
As per the above the patch only fixes one possible scenario. I left the
messages there because they could be used to help prove/disprove that another set of events could produce a similar error.

It appears that some recent changes in user space code make it more likely
for the driver to hit this condition.
> 
> Dave.
> 
> 
Thanks
Joe



      
