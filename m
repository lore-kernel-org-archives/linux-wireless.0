Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59398 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbcBWLIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 06:08:55 -0500
Message-ID: <1456225732.2041.27.camel@sipsolutions.net> (sfid-20160223_120908_287094_A3F41009)
Subject: Re: [RFC 0/2] mac80211: add support for ht_caps mcs rxmask override
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?C=E9dric?= Debarge - ACKSYS
	<cedric.debarge@acksys.fr>
Cc: linux-wireless@vger.kernel.org,
	'Ben Greear' <greearb@candelatech.com>
Date: Tue, 23 Feb 2016 12:08:52 +0100
In-Reply-To: <01a201d16b34$11dcf5e0$3596e1a0$@acksys.fr>
References: <cover.1454685673.git.cedric.debarge@acksys.fr>
	 <1455827262.2084.31.camel@sipsolutions.net>
	 <01a201d16b34$11dcf5e0$3596e1a0$@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-19 at 17:39 +0100, Cédric Debarge - ACKSYS wrote:
> > What are you working on that you need this?
> 
> We are working on critical industrial networks where a specific
> (generally high) bandwidth is required.
> Supressing low MCSs (that are not able to handle the desired
> bandwidth) allows us to be sure that the wireless link can sustain
> the requested bandwidth.
> If the radio conditions do not allow high enough MCSs, we prefer
> increase the AP density rather than not being able to communicate at
> the requested speed.

Interesting. So are you saying that you're trying to disable the
low(er) rates by not having the client systems advertise them, possibly
because you can't manipulate the transmitter to not use them?

But that seems a bit strange, since basic/mandatory rates always need
to be supported?

> > I think my comments to him apply to this too - see the thread at
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/143789
> 
> Thanks for the link, I didn't noticed Ben Grear's request.
> According to the given patches, it seems the targeted goal is quite
> similar. So your comments also apply on my demand.

It seems that your implementation is closer to what I was suggesting
though :)

johannes
