Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42590 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbbJPGhf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 02:37:35 -0400
Message-ID: <1444977453.2370.2.camel@sipsolutions.net> (sfid-20151016_083738_436199_82FC7604)
Subject: Re: [PATCH 5/6] cfg80211: reg: make CRDA support optional
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 16 Oct 2015 08:37:33 +0200
In-Reply-To: <CAGRGNgUZXfrmCA+KpgTW2_yFEqVao7DmQofNrFpiiRAWhUaYXw@mail.gmail.com> (sfid-20151016_010415_028531_DF68F6E6)
References: <1444902418-25668-1-git-send-email-johannes@sipsolutions.net>
	 <1444902418-25668-5-git-send-email-johannes@sipsolutions.net>
	 <CAGRGNgUZXfrmCA+KpgTW2_yFEqVao7DmQofNrFpiiRAWhUaYXw@mail.gmail.com>
	 (sfid-20151016_010415_028531_DF68F6E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > config CFG80211_INTERNAL_REGDB
> > 
> > +config CFG80211_CRDA_SUPPORT
> 
> Is there a way to force the kernel builder to select at least one of
> these if they're building cfg80211?
> 

I'd actually thought about that, but I think there are two reasons not
to.

1) it may actually be a valid configuration, if you really only need
the built-in world regulatory domain, or have a device that provides
its own

2) the [RFC] patch I sent will add a *third* mechanism (and the second
one will remove the INTERNAL_REGDB support) so there would only be a
transition period

That said, perhaps since (2) will probably be significantly later than
this patch there could still be a point in it. (1) isn't very strong
and I don't even preserve that after (2).

johannes
