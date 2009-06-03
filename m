Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22975 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbZFCSfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:35:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2009 11:35:56 -0700
Date: Wed, 3 Jun 2009 11:36:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: check for existance sta before adding it
Message-ID: <20090603183602.GD13156@tesla>
References: <1243974603-15058-1-git-send-email-lrodriguez@atheros.com> <1243974947.7176.9.camel@johannes.local> <43e72e890906021401r2200bad9n1ffbe2c56c3a2c22@mail.gmail.com> <1244012450.7176.15.camel@johannes.local> <20090603180830.GA13156@tesla> <1244053423.22576.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1244053423.22576.2.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 03, 2009 at 11:23:43AM -0700, Johannes Berg wrote:
> On Wed, 2009-06-03 at 11:08 -0700, Luis R. Rodriguez wrote:
> > On Wed, Jun 03, 2009 at 12:00:50AM -0700, Johannes Berg wrote:
> > > On Tue, 2009-06-02 at 14:01 -0700, Luis R. Rodriguez wrote:
> > > 
> > > > Thanks, yeah I see where I was making an incorrect assumption here.
> > > > 
> > > > There still is a case here where userpsace can try to add a sta twice
> > > > and the second parameters passed would be ignored.
> > > 
> > > Don't we show that -EEXIST to userspace then? I thought we did.
> > 
> > We do, but why don't we *first* try to check for its existence?
> 
> Because that's racy -- after the check completes and before we go try to
> insert a station might have come to life. Well, it might actually be ok
> due to external factors (AP mode _only_ gets stations from userspace)
> but it seems better to not rely on that.

I see.

> What problem were you trying to solve btw?

Nothing in particular, I was just reviewing sta code path.

  Luis
