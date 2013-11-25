Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KYSgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 13:36:17 -0500
Message-ID: <1385404573.4443.58.camel@jlt4.sipsolutions.net> (sfid-20131125_193620_931203_39C06AD5)
Subject: Re: Roaming with libertas and wpa_supplicant not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Troels Nilsson <nilsson.troels@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 19:36:13 +0100
In-Reply-To: <1385399816.8710.16.camel@dcbw.foobar.com>
References: <loom.20131118T143002-687@post.gmane.org>
	 (sfid-20131118_145509_206573_37D8C413) <1385396191.4443.44.camel@jlt4.sipsolutions.net>
	 <1385399816.8710.16.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-25 at 11:16 -0600, Dan Williams wrote:
> On Mon, 2013-11-25 at 17:16 +0100, Johannes Berg wrote:
> > On Mon, 2013-11-18 at 13:50 +0000, Troels Nilsson wrote:
> > > Hi,
> > > 
> > > We are having a problem with a custom device which uses the libertas wifi
> > > driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3). More
> > > specifically, whenever wpa_supplicant attempts to roam to a different access
> > > point it gets a EALREADY error.
> > > 
> > > I have tracked down the problem to this check in sme.c:
> > > 
> > >         if (wdev->sme_state != CFG80211_SME_IDLE)
> > >                 return -EALREADY;
> > 
> > This no longer exists - please try a newer kernel.
> 
> Yeah, though the code there hasn't changed much in cfg80211 in the
> "connect" case from what he's using.  It seems that
> supplicant-controlled roaming simply won't work with "connect" devices
> unless a disconnect is done first?  Libertas is kinda different here
> since it does allow userspace roaming control.

I believe the code *does* in fact allow connect() while connected right
now, though arguably that's a bug and shouldn't be done. It would make
some more sense to allow NL80211_CMD_ROAM to be used for something like
that, but ...

johannes

