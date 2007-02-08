Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:63191 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423483AbXBHV42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 16:56:28 -0500
Received: by wx-out-0506.google.com with SMTP id h31so618121wxd
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2007 13:56:27 -0800 (PST)
Message-ID: <43e72e890702081356wa0350een2617d067efe15325@mail.gmail.com>
Date: Thu, 8 Feb 2007 16:56:26 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <20070208195526.GA5319@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070207004626.GA23096@tuxdriver.com>
	 <20070207004747.GB23096@tuxdriver.com>
	 <20070207004832.GC23096@tuxdriver.com>
	 <20070207004929.GD23096@tuxdriver.com>
	 <20070207075420.GB14703@infradead.org>
	 <1170940386.4385.49.camel@johannes.berg>
	 <43e72e890702081038k1d4f226eocf28c5faf6b79dc5@mail.gmail.com>
	 <20070208195526.GA5319@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/8/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Feb 08, 2007 at 01:38:02PM -0500, Luis R. Rodriguez wrote:
> > >> in the series actually converts a driver to use it.  Both to make this
> > >> code not dead and give people and example on how to use the cfg80211
> > >> infrastructure.
> > >
> > >I guess I could make softmac use it.
> >
> > Another idea here is we can provide a configfs frontend to cfg80211
> > therefore any device which implements cfg80211 will automagically have
> > a userspace frontend (/configfs/wireless/foo) ready to test cfg80211.
>
> Huh?  We already have a wext fronted to nicely test cfg80211, what we
> need are backends.

Yes, this is true.

> In addition to that I think we should agree on
> one primary userspace configuration method for the future instead of
> adding lots of them just because it's so easy.

Its not just that its provides a means to allow easy development of
userspace applications, that's just the cherry on top of the cake. The
real benefit of this is entirely architectural. Here are two examples:

a. Handling of private data

That is non-standard data, ie that doesn't go in the cfg80211_config
struct. Think of how iwpriv works and how nasty that was. Now granted
cfg80211 would still need to have some infrastructure for handling of
private data and nl80211 can be used as well but I find it would be
more convenient to scrape the available private set/get information
through a configfs tree on the device than have userspace applications
use nl80211 all the time.

b. Radiotap field selectivity

Although we currently do not fully support radiotap and although
radiotap currently  works by tacking on ALL the supported fields onto
the beginning of the skb if we want to provide selectivity of fields I
think configfs would provide an elegant way of dealing with this.
Think of echo'ing 0 or 1 to some /config/wireless/foo/radiotap/bar.
Alternative solutions to provide selectivity for radiotap can also be
to provide different levels of verbosity for wanted data, which would
make selectivity implementation much easier.

> If the public opinion
> has changed 180 degrees and configs is preferred over nl80211 that's
> fine by me as long as the implementation is sane..

I don't think the opinion has changed at all. I just think a configfs
frontend would be good as well, specially for some cases as
illustrated above.

  Luis
