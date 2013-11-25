Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab3KYRQW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 12:16:22 -0500
Message-ID: <1385399816.8710.16.camel@dcbw.foobar.com> (sfid-20131125_181636_904932_46F5FE11)
Subject: Re: Roaming with libertas and wpa_supplicant not working
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Troels Nilsson <nilsson.troels@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 11:16:56 -0600
In-Reply-To: <1385396191.4443.44.camel@jlt4.sipsolutions.net>
References: <loom.20131118T143002-687@post.gmane.org>
	 (sfid-20131118_145509_206573_37D8C413) <1385396191.4443.44.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-25 at 17:16 +0100, Johannes Berg wrote:
> On Mon, 2013-11-18 at 13:50 +0000, Troels Nilsson wrote:
> > Hi,
> > 
> > We are having a problem with a custom device which uses the libertas wifi
> > driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3). More
> > specifically, whenever wpa_supplicant attempts to roam to a different access
> > point it gets a EALREADY error.
> > 
> > I have tracked down the problem to this check in sme.c:
> > 
> >         if (wdev->sme_state != CFG80211_SME_IDLE)
> >                 return -EALREADY;
> 
> This no longer exists - please try a newer kernel.

Yeah, though the code there hasn't changed much in cfg80211 in the
"connect" case from what he's using.  It seems that
supplicant-controlled roaming simply won't work with "connect" devices
unless a disconnect is done first?  Libertas is kinda different here
since it does allow userspace roaming control.

Dan


