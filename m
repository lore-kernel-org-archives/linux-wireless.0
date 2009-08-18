Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZHRBNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 21:13:42 -0400
Subject: Re: question about ieee80211_tx.c (fwd)
From: Zhu Yi <yi.zhu@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Julia Lawall <julia@diku.dk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
In-Reply-To: <69e28c910908170450l65d493dbnb1d2e8f14d29dadc@mail.gmail.com>
References: <Pine.LNX.4.64.0908171000500.20447@pc-004.diku.dk>
	 <69e28c910908170450l65d493dbnb1d2e8f14d29dadc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Aug 2009 09:13:41 +0800
Message-Id: <1250558021.9651.35.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-17 at 19:50 +0800, Gábor Stefanik wrote:
> On Mon, Aug 17, 2009 at 10:03 AM, Julia Lawall<julia@diku.dk> wrote:
> > The files ieee80211_tx.c in the directories
> > drivers/staging/rtl8192su/ieee80211 and
> drivers/staging/rtl8192e/ieee80211
> > both contain the following code in the function
> > ieee80211_query_protectionmode:
> >
> >       if (ieee->mode == IW_MODE_MASTER)
> >                        goto NO_PROTECTION;
> >
> > Elsewhere in these files when there is a comparison against an
> IW_MODE
> > value, the field that is compared is iw_mode.  Should that be the
> case
> > here as well?
> >
> > thanks,
> > julia
> 
> I don't know; rtl8192su & rtl8192e use a modified version of the
> libipw stack, rather than the mac80211 stack found behind non-staging
> drivers.

This is clearly a bug. The question is: who is maintaining this driver
and why it doesn't use/extend ieee80211/libipw?

Thanks,
-yi

