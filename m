Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab2K2AAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 19:00:04 -0500
Message-ID: <1354147227.9345.47.camel@jlt4.sipsolutions.net> (sfid-20121129_010009_593646_5C27B488)
Subject: Re: [PATCH] cfg80211: fix cmp_hidden_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Date: Thu, 29 Nov 2012 01:00:27 +0100
In-Reply-To: <CAB3XZEeuZOv_gHD2q0-K3JUXhjgTFx3AgZ1vS0Rc-toOVf-kTA@mail.gmail.com> (sfid-20121129_005346_428375_D8E90F07)
References: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEeuZOv_gHD2q0-K3JUXhjgTFx3AgZ1vS0Rc-toOVf-kTA@mail.gmail.com>
	 (sfid-20121129_005346_428375_D8E90F07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 01:53 +0200, Eliad Peller wrote:
> On Wed, Nov 28, 2012 at 11:44 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > The cmp_bss() comparator function uses memcmp() to
> > compare the SSID. This means that cmp_hidden_bss()
> > needs to similarly return a number bigger than zero
> > (use 1) instead of -1 when ie1 is bigger than ie2,
> > which is the case if an ie2 byte is non-zero.

> > +++ b/net/wireless/scan.c
> > @@ -472,7 +472,7 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
> >         /* zeroed SSID ie is another indication of a hidden bss */
> >         for (i = 0; i < ie2[1]; i++)
> >                 if (ie2[i + 2])
> > -                       return -1;
> > +                       return 1;
> >
> >         return 0;
> >  }
> 
> maybe i'm misreading it, but there is still no comparison here at all,
> so it seems wrong as well :)
> (practically, i guess it doesn't really matter, because if there is
> some non-null char, this is not a hidden ssid anyway)

Hmm yeah you're right, it should be
	return ie2[i + 1] - ie1[i + 1];

(or the other way around? need to sleep on that first...)

johannes

