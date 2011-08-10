Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1HJUOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:14:37 -0400
Subject: Re: [PATCH 1/8] mac80211: improve mpath debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <CAG6hwVN27E=bt_-Ocv2JagUPmtZAWux17Lm3cV24be9TfM1BDQ@mail.gmail.com> (sfid-20110810_221156_535217_B568F4C2)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-2-git-send-email-thomas@cozybit.com>
	 <1312983507.4325.1.camel@jlt3.sipsolutions.net>
	 <CAG6hwVN27E=bt_-Ocv2JagUPmtZAWux17Lm3cV24be9TfM1BDQ@mail.gmail.com>
	 (sfid-20110810_221156_535217_B568F4C2)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 22:14:34 +0200
Message-ID: <1313007274.4016.2.camel@jlt3.sipsolutions.net> (sfid-20110810_221441_444240_B035E3E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 13:11 -0700, Thomas Pedersen wrote:
> On Wed, Aug 10, 2011 at 6:38 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:
> >
> >> +#ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
> >> +#define mpath_dbg(fmt, args...)      printk(KERN_DEBUG fmt, ##args)
> >> +#else
> >> +#define mpath_dbg(fmt, args...)      do { (void)(0); } while (0)
> >> +#endif
> >
> > Maybe this should be a static inline for checking the fmt args even when
> > it's compiled out?
> >
> I don't really see the point, since all this would give us is the
> compiler checking whether a const char * was passed as an argument to
> fmt, right?

No, if you annotate it correctly gcc will also check that the arguments
match, and warn if you do

mpath_dbg("foo: %s", 7)

for example :-)

johannes

