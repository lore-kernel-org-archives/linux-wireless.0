Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32768 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752104AbcLFHNc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Dec 2016 02:13:32 -0500
Date: Tue, 6 Dec 2016 08:13:40 +0100
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
Message-ID: <20161206071340.GB10292@kroah.com> (sfid-20161206_081351_756318_C98DB65E)
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-11-Larry.Finger@lwfinger.net>
 <20161205213447.GJ8176@mwanda>
 <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 05, 2016 at 04:34:08PM -0600, Larry Finger wrote:
> On 12/05/2016 03:34 PM, Dan Carpenter wrote:
> > On Thu, Dec 01, 2016 at 07:48:29PM -0600, Larry Finger wrote:
> > > --- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> > > +++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
> > > @@ -27,6 +27,29 @@
> > > 
> > >  #include	"../wifi.h"
> > > 
> > > +#ifdef CONFIG_RTLWIFI_DEBUG
> > > +
> > > +#define BTC_SPRINTF(ptr, ...)	snprintf(ptr, ##__VA_ARGS__)
> > > +#define BTC_TRACE(fmt)						\
> > > +do {								\
> > > +	struct rtl_priv *rtlpriv = gl_bt_coexist.adapter;	\
> > > +	if (!rtlpriv)					\
> > > +		break;						\
> > > +	RT_TRACE_STRING(rtlpriv, COMP_COEX, DBG_LOUD, fmt);	\
> > > +} while (0)
> > > +
> > 
> > This sort of macro is exactly when the rtl drivers spent so long in
> > staging...  Subsystems should not invent their own tracing but in
> > particular these macros are so very very ugly.
> > 
> > It's just super frustrating to even look at this...
> > 
> > There are a lot of staging drivers I feel good about when they leave.
> > The HyperV drivers.  The IIO stuff.  A lot of the media stuff and
> > generally the media tree is getting better and better.  I like comedi
> > and unisys, those are in staging, but they are great and could move out
> > any time as far as I'm concerned.
> > 
> > But this patch just makes me super discouraged.  What are we doing???
> 
> Dan,
> 
> It would not matter to me if these drivers got moved to staging, but there
> are a lot of users whose distros do not build staging drivers that would be
> very unhappy.
> 
> Can you point me to a driver with a better way to conditionally dump a
> debugging string to the logs?

Just use 'dev_dbg()', or 'pr_debug()' if you don't have a device pointer
(hint, all drivers should have that pointer).  That can be turned on or
off by a user dynamically as the kernel runs.  No need to invent fancy
custom macros for things we have already for many many years.

thanks,

greg k-h
