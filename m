Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2EGJa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:30:27 -0400
Message-ID: <1336383024.4325.6.camel@jlt3.sipsolutions.net> (sfid-20120507_113030_238264_C85BF802)
Subject: Re: [PATCH] cfg80211: Remove compile warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Date: Mon, 07 May 2012 11:30:24 +0200
In-Reply-To: <CAMXE1-qniMzGi97U2oDPxyvSsms7nZpy6QfZVZPpnrC0WcNMqQ@mail.gmail.com> (sfid-20120504_104453_127145_540640EF)
References: <1335357955-28089-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1336071617.5167.9.camel@jlt3.sipsolutions.net>
	 <CAMXE1-qniMzGi97U2oDPxyvSsms7nZpy6QfZVZPpnrC0WcNMqQ@mail.gmail.com>
	 (sfid-20120504_104453_127145_540640EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-04 at 11:44 +0300, Andrei Emeltchenko wrote:

> >> -             case NL80211_IFTYPE_UNSPECIFIED:
> >> -             case NUM_NL80211_IFTYPES:
> >> +             default:
> >
> > When did this warning start occurring? I was pretty sure it didn't use
> > to? I think we should explicitly list the cases here though because we
> > want the compiler to warn here when we add something to the interface
> > type list so we catch this place that may have to be modified.
> 
> I think warning occurs when I added new interface type since it is
> also not handled.

Well, but in that case the warning is supposed to happen to tell you
that you need to think about that code for your new interface type.

John, please revert this patch.

johannes

