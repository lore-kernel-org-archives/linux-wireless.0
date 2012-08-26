Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2HZIK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 04:10:28 -0400
Message-ID: <1345968623.3622.3.camel@jlt4.sipsolutions.net> (sfid-20120826_101132_904740_A20BA933)
Subject: Re: [RFC 00/20] mac80211: multi-channel work
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 26 Aug 2012 10:10:23 +0200
In-Reply-To: <CAB3XZEcnVxiBkSz4ZMYSqWF55BYBcDgF7tZsRRXoD91unVrAww@mail.gmail.com> (sfid-20120826_095829_154644_66A916CF)
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 <1345800585.4503.8.camel@jlt3.sipsolutions.net>
	 <CAB3XZEcnVxiBkSz4ZMYSqWF55BYBcDgF7tZsRRXoD91unVrAww@mail.gmail.com>
	 (sfid-20120826_095829_154644_66A916CF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-08-26 at 10:58 +0300, Eliad Peller wrote:

> > Now if the supplicant wants to deauthenticate as well, we have no
> > channel context to use for it. We could use remain-on-channel? Or we
> > could create a new channel context? Or just ignore the deauth? I haven't
> > found a good solution yet... We also can't rely on the supplicant always
> > doing a deauth, so we don't want to keep the channel context around
> > until the deauth either.
> >
> > Obviously the same can also happen if the supplicant just asks us to
> > deauthenticate without ever having connected at all, but that's a rather
> > unlikely case.
> >
> > Anyone have any idea? :)
> >
> is it really different from the situation today, when we'll try tx on
> idle device/interface (afaict)?

Well, it is still a bit different, we have no channel at all :)

> this scenario (deauth after disassoc) also sounds pretty unlikely...

It seems that it happens when you ask the supplicant to "disconnect" via
the CLI.

johannes

