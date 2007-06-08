Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:45008 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbXFHSM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 14:12:58 -0400
Received: by py-out-1112.google.com with SMTP id a29so1376357pyi
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2007 11:12:57 -0700 (PDT)
Message-ID: <43e72e890706081112k76e17827t4c66dbccdcee0e03@mail.gmail.com>
Date: Fri, 8 Jun 2007 14:12:57 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Cc: "Jiri Benc" <jbenc@suse.cz>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070608145821.GD14078@devicescape.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <200706072205.27902.flamingice@sourmilk.net>
	 <20070608112146.2df3608c@griffin.suse.cz>
	 <20070608145821.GD14078@devicescape.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/8/07, Jouni Malinen <jkm@devicescape.com> wrote:
> On Fri, Jun 08, 2007 at 11:21:46AM +0200, Jiri Benc wrote:
> > On Thu, 7 Jun 2007 22:05:21 -0700, Michael Wu wrote:
> > > On Thursday 07 June 2007 20:49, Larry Finger wrote:
> > > > Does mode->rates[0].flags automatically have IEEE80211_RATE_SUPPORTED set?
> > > > That wasn't clear to me.
> > > >
> > > Yes. (see ieee80211_prepare_rates)
> >
> > No :-) In theory, you can use PRISM2_HOSTAPD_SET_RATE_SETS ioctl to
> > disable the lowest available rate. Yes, that's deprecated and bad thing
> > to do; but unfortunately, it can be done with the current code.
>
> There are some odd cases, where disabling the lowest supported rate may
> even be required due to regulatory rules..

Just curious -- are you aware of a regulatory domain where this is the
case? Who defines those rules? For example, AFAICT FCC only talk about
power, and spectrum ranges. Where would I even look for these type of
restrictions?

  Luis
