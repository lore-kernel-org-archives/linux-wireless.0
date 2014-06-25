Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52235 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbaFYP5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 11:57:43 -0400
Message-ID: <1403711846.4140.16.camel@jlt4.sipsolutions.net> (sfid-20140625_175747_034098_419DDEC0)
Subject: Re: [RFC 2/3] cfg80211: expose cfg80211_disable_40mhz_24ghz module
 parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 25 Jun 2014 17:57:26 +0200
In-Reply-To: <53A9B391.4050602@broadcom.com>
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>
		 <1402996581-10764-3-git-send-email-arend@broadcom.com>
	 <1403516075.4418.9.camel@jlt4.sipsolutions.net>
	 <53A9B391.4050602@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-24 at 19:21 +0200, Arend van Spriel wrote:

> >> + * @wiphy: The wiphy to check.
> >> + *
> >> + * Return: true is 40MHz is disabled in 2.4G band.
> >> + */
> >> +bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy);
> >
> > Why should that have a wiphy argument?
> 
> It is up to cfg80211 to determine the logic behind the function. It is 
> just context supplied by the caller. The fact that it is determined by a 
> module parameter is internal cfg80211 stuff.

I just don't really see any way it would ever be per wiphy?

> > Might also be simpler to just export the variable?
> 
> Either way is pretty simple I guess.

Yeah, dunno. I guess exporting the function at least makes sure nobody
will try to set the variable, so that's somewhat useful...

I'd prefer to remove the wiphy argument though (and fix the kernel-doc)

johannes

