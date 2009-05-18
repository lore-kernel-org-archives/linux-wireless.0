Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27048 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbZERUEE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 16:04:04 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 13:04:06 -0700
Date: Mon, 18 May 2009 13:04:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] cfg80211: fix race between core hint and driver's
	custom apply
Message-ID: <20090518200409.GM20637@tesla>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com> <1242248682-22051-5-git-send-email-lrodriguez@atheros.com> <20090518184718.GJ2814@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090518184718.GJ2814@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 11:47:18AM -0700, John W. Linville wrote:
> On Wed, May 13, 2009 at 05:04:42PM -0400, Luis R. Rodriguez wrote:
> > Its possible for cfg80211 to have scheduled the work and for
> > the global workqueue to not have kicked in prior to a cfg80211
> > driver's regulatory hint or wiphy_apply_custom_regulatory().
> >
> > Although this is very unlikely its possible and should fix
> > this race. When this race would happen you are expected to have
> > hit a null pointer dereference panic.
> >
> > Cc: stable@kernel.org
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> (Same questions as for 3/4...)
> 
> What is the effect of this race?  What justifies this for 2.6.30
> and/or stable?  It is getting late in the cycle for 2.6.30...

It fixes an oops when your global workqueue is hammered during load
of ath9k, ath5k, or ar9170. I finally got confirmation from our team
it does fix the oops. Alan Jenkins also reported it fixed his oops.
He was getting an oops by adding the new RFKILL patches by johannes which
does add stuff ontop of the global workqueue.

  Luis
> 
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
