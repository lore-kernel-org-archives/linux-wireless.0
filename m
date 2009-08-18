Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZHRBio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 21:38:44 -0400
Date: Mon, 17 Aug 2009 18:35:02 -0700
From: Greg KH <gregkh@suse.de>
To: Zhu Yi <yi.zhu@intel.com>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question about ieee80211_tx.c (fwd)
Message-ID: <20090818013502.GD20566@suse.de>
References: <Pine.LNX.4.64.0908171000500.20447@pc-004.diku.dk>
 <69e28c910908170450l65d493dbnb1d2e8f14d29dadc@mail.gmail.com>
 <1250558021.9651.35.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1250558021.9651.35.camel@debian>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 09:13:41AM +0800, Zhu Yi wrote:
> On Mon, 2009-08-17 at 19:50 +0800, Gábor Stefanik wrote:
> > On Mon, Aug 17, 2009 at 10:03 AM, Julia Lawall<julia@diku.dk> wrote:
> > > The files ieee80211_tx.c in the directories
> > > drivers/staging/rtl8192su/ieee80211 and
> > drivers/staging/rtl8192e/ieee80211
> > > both contain the following code in the function
> > > ieee80211_query_protectionmode:
> > >
> > >       if (ieee->mode == IW_MODE_MASTER)
> > >                        goto NO_PROTECTION;
> > >
> > > Elsewhere in these files when there is a comparison against an
> > IW_MODE
> > > value, the field that is compared is iw_mode.  Should that be the
> > case
> > > here as well?
> > >
> > > thanks,
> > > julia
> > 
> > I don't know; rtl8192su & rtl8192e use a modified version of the
> > libipw stack, rather than the mac80211 stack found behind non-staging
> > drivers.
> 
> This is clearly a bug. The question is: who is maintaining this driver
> and why it doesn't use/extend ieee80211/libipw?

I maintain it, and I am working to convert it to use the existing
ieee80211 stack that is in the kernel.  Remember, these are drivers in
the staging tree, they are usually "crap" :)

thanks,

greg k-h
