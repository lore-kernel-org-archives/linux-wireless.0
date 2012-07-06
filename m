Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2GFGjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 02:39:52 -0400
Message-ID: <1341556785.4462.0.camel@jlt3.sipsolutions.net> (sfid-20120706_083956_327394_6DEED8B3)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Date: Fri, 06 Jul 2012 08:39:45 +0200
In-Reply-To: <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com> (sfid-20120705_184840_857903_2B23A6DE)
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341394944.4482.9.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
	 <1341474303.4455.5.camel@jlt3.sipsolutions.net>
	 <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
	 (sfid-20120705_184840_857903_2B23A6DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-05 at 09:48 -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 5, 2012 at 12:45 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-07-04 at 09:26 -0700, Luis R. Rodriguez wrote:
> >> I've skipped the other comments as I can address those in a new series.
> >>
> >> On Wed, Jul 4, 2012 at 2:42 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> > So I'm not really convinced about this. It seems this Kconfig should
> >> > better be a Kconfig that enables other Kconfig only, not enabling other
> >> > features. How else would anyone be able to do due diligence and check
> >> > what exactly this enables that they need to test?
> >>
> >> Makes sense, so would we then have CONFIG_REG_HINT_CELL_BASE_STATION ?
> >
> > I don't know how fine-grained it should be? Maybe it should be more
> > generic and be a config for all (future) kinds of user hints?
> 
> Well so in this case the cell base station hint support gets used and
> trusted on the wireless core if CONFIG_REG_HINT_CELL_BASE_STATION is
> set. Whether or not a *driver* trusts and uses it as well will depend
> on whether or not they set the NL80211_FEATURE_CELL_BASE_REG_HINTS
> feature on their wiphy->features. The way I was thinking about drivers
> going about enabling / disabling was to let the driver have its own
> kconfig option for this. The reason is that firmware may require some
> implementation / changes / testing to ensure that a device won't poop
> out if this is used.

Oh, that explains the extra flag there, I pretty much thought it was
useless. I guess that could be useful for when you ship some device with
builtin wireless but allow plugging in other wireless?

johannes

