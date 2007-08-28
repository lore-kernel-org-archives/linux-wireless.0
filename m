Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:32961 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbXH1Nhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 09:37:43 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2029020wxd
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2007 06:37:42 -0700 (PDT)
Message-ID: <1ba2fa240708280637q6383ee53l2907b68039d87d40@mail.gmail.com>
Date: Tue, 28 Aug 2007 16:37:41 +0300
From: "Tomas Winkler" <tomas.winkler@intel.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	"Jeff Garzik" <jgarzik@pobox.com>
In-Reply-To: <20070828122838.GA16906@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070827131026.GA21137@infradead.org>
	 <1188285945.13078.242.camel@debian.sh.intel.com>
	 <1188291015.7837.67.camel@johannes.berg>
	 <20070828122838.GA16906@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/28/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Aug 28, 2007 at 10:50:15AM +0200, Johannes Berg wrote:
> > On Tue, 2007-08-28 at 15:25 +0800, Zhu Yi wrote:
> >
> > > I know the method is not common used in the Linux drivers, but this is
> > > decided by the hardware layout. For 3945 and 4965, 90% of the
> > > hardware/firmware layout are the same and only 10% are different. This
> > > makes it possible to support two slightly differs hardwares in one
> > > driver. If the hardwares differ a lot (i.e 2100 and 2200), I won't even
> > > think about to do it in this way.
> >
> > To be fair, that's not what you do, you're building two drivers from one
> > source rather than have a single driver that supports both. I'm fairly
> > certain Christoph wouldn't object to the latter.
>
> Absolutely not.  The right way to do it is to have a least a common
> driver core, and if the device-specific parts get too big they can but
> don't have to be separate modules.
>
> With s"light amount of duplicated code" I meant possibly duplicated bits if
> the split between common and device-specific bits doesn't work out perfectly
> because e.g. both device types do the same kind of operation on differently
> layed out data structures, which AFAIK is the case for some operations in
> this driver.
>
As far as I can speak for next generation of Intel Linux Wifi drivers
the #if IWL == will be killed.
3945 will be probably dropped to it's own module as it is abg NIC
unlike other 11n NICs. It differs quite a lot in data structures and
mostly in flows.  This wasn't clear at the begin when 4965 was build
on top of 3945 so we ended up with IWL == which was much more
efficient at the time. We had the library approach before if you
remember.
The mess stared somewhere at the point where HT was dropped from
submission to mainstream and we rushed to create something that can be
submitted. To much code was jungled in the air and still is... Hope we
settle all this now to the right path

Tomas


> >
> > johannes
>
>
> ---end quoted text---
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
