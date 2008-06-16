Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206AbYFPUji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 16:39:38 -0400
Subject: Re: [PATCH] mac80211: remove shared key todo
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213647709.3803.50.camel@johannes.berg>
References: <1213642529.3803.47.camel@johannes.berg>
	 <1213647566.18384.6.camel@localhost.localdomain>
	 <1213647709.3803.50.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 16:38:49 -0400
Message-Id: <1213648729.18384.11.camel@localhost.localdomain> (sfid-20080616_223955_597870_67264533)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-16 at 22:21 +0200, Johannes Berg wrote:
> On Mon, 2008-06-16 at 16:19 -0400, Dan Williams wrote:
> > On Mon, 2008-06-16 at 20:55 +0200, Johannes Berg wrote:
> > > Adding shared key authentication is not going to happen anyway.
> > 
> > +1; I've _never_ heard or seen anyone using Shared Key auth with adhoc.
> > How would that work anyway, given that there's no AP to send you the
> > challenge text?  Just auth against some random peer?
> 
> I have no idea. Usually, you don't even do open auth for IBSS, there's
> just no point. Unless you get into IBSS with encryption, but we don't
> really support that yet, and we probably never will actually support
> that without the userspace MLME in wpa supplicant.

IBSS + WEP works at least for ipw2200 and other non-mac80211 cards; I
can check it out with mac80211 if you like.

One thing though, if mac80211 isn't going to support IBSS + WEP for a
while, we should find some way to push capability bits to userspace that
say that.  Otherwise there's no way for NM to tell that the driver
doesn't support it, and thus to not even show the options in the UI.

Any particular reason IBSS would require a userspace MLME?  There
shouldn't be any rekeying of any kind with adhoc, since there's no
central station to coordinate the rekying.  AFAIK with IBSS you just use
the given PSK at creation time, and never change it.  That shouldn't be
too hard to handle, right?

Dan


