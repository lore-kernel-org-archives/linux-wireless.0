Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26911 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZERUCS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 16:02:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 13:02:20 -0700
Date: Mon, 18 May 2009 13:02:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 3/4] cfg80211: fix in nl80211_set_reg()
Message-ID: <20090518200223.GL20637@tesla>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com> <1242248682-22051-4-git-send-email-lrodriguez@atheros.com> <20090518184641.GI2814@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090518184641.GI2814@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 11:46:41AM -0700, John W. Linville wrote:
> On Wed, May 13, 2009 at 05:04:41PM -0400, Luis R. Rodriguez wrote:
> > There is a race on access to last_request and its alpha2
> > through reg_is_valid_request() and us possibly processing
> > first another regulatory request on another CPU. We avoid
> > this improbably race by locking with the cfg80211_mutex as
> > we should have done in the first place. While at it add
> > the assert on locking on reg_is_valid_request().
> >
> > Cc: stable@kernel.org
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> What is the effect of this race?

The race is theoretical and I cannot confirm if it happens but
if it does I suspect we can allow / deny regutatory requests
when the race occurs when in fact we shouldn't.

> What justifies this for 2.6.30
> and/or stable?  It is getting late in the cycle for 2.6.30...

We could potentially be allowing two duplicate regulatory
requests to be processed when two requests are being processed
on different CPUs, I believe this is hard to trigger, you would
need the global workqueue to be hit pretty hard, but if the race
is hit I would expect two regulatory requests for the same
alpha2 to be tried to be processed. In order to trigger though
you'd need crda to send two regulutory responses instead of one
or someone in userspace hammering crda for the same alpha2.
Just checked and if the race happens we'd drop it anyway with
a WARN_ON() later in __set_regdom():

        if (WARN_ON(!reg_is_valid_request(rd->alpha2)))
                return -EINVAL;

I suppose its safe to say that's all the consequences I can think of,
unless I'm overlooking something.

  Luis
