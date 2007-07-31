Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47938
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbXGaVkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:40:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Tue, 31 Jul 2007 23:39:52 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
References: <20070730023128.99E927B409F@zog.reactivated.net> <200707302223.04696.flamingice@sourmilk.net> <20070731230613.6d0a0856@logostar.upir.cz>
In-Reply-To: <20070731230613.6d0a0856@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707312339.53025.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007 23:06:13 Jiri Benc wrote:
> On Mon, 30 Jul 2007 22:22:58 -0700, Michael Wu wrote:
> > On Monday 30 July 2007 16:05, Michael Buesch wrote:
> > > I suggest you look at bcm43xx-mac80211.
> > > You will need to introduce refcounting for your monitor interfaces
> > > and I _really_ suggest to get rid of the zd_op_open() and zd_op_close()
> > > functions. Just include that in add/remove interface. You need
> > > to refcount your interfaces anyway.
> > >
> > Requiring refcounting for monitor interfaces is fairly dumb since mac80211 
> > does the exact same refcounting. I haven't bothered to do it in any driver 
> > ports yet for this reason. This part of the mac80211 driver api needs to be 
> > fixed.
> 
> Ouch, I thought we don't bother drivers with more than one monitor
> interface at a time. Apparently I forgot to fix that.
> 
> > Also, I'm not entirely convinced that eliminating the open/close callbacks is 
> > a good idea,
> 
> Why?

Yeah, I don't see the need for open/close, either.
We can live perfectly well without them. It even reduces code complexity
and makes drivers more readable.
In add/remove you better know anyway, if the interface is up or down.
So if it's down in add_interface, just init it. It's a matter of an if statement.
Really nothing more.

-- 
Greetings Michael.
