Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35965 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbcDQMmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2016 08:42:38 -0400
Message-ID: <1460896953.15362.2.camel@sipsolutions.net> (sfid-20160417_144308_878297_106CBB57)
Subject: Re: [PATCH v3] prism54: isl_38xx: Replace 'struct timeval'
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>,
	y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Sun, 17 Apr 2016 14:42:33 +0200
In-Reply-To: <5521267.mr5HLCdTY6@wuerfel>
References: <20160413060916.GA21184@localhost>
	 <1460536706.3057.3.camel@sipsolutions.net> <5521267.mr5HLCdTY6@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-04-17 at 01:34 +0200, Arnd Bergmann wrote:
> On Wednesday 13 April 2016 10:38:26 Johannes Berg wrote:
> > 
> > > 
> > > The patch was build-tested / debugged by removing the
> > > "if VERBOSE > SHOW_ERROR_MESSAGES" guards.
> > Stands to reason that we should just remove the (more or less) dead
> > code, since I don't think anyone really ever touches this driver
> > any
> > more or will ever again ...
> Do you mean removing all DEBUG() statements from the driver, or
> removing the entire driver?
> 

We tried removing the driver once, since p54 supposedly drives the same
hardware, but some people had certain use cases that didn't work there,
apparently.

I was thinking more restrictively of just the stuff that can't even be
built without modifying the sources - like the "#if VERBOSE" thing.

johannes
