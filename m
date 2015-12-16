Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42889 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbbLPNmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:42:45 -0500
Message-ID: <1450273362.8247.15.camel@sipsolutions.net> (sfid-20151216_144248_553121_92A01B2B)
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Date: Wed, 16 Dec 2015 14:42:42 +0100
In-Reply-To: <567168AF.4060804@candelatech.com>
References: <5670DA9A.4010102@candelatech.com>
			 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>
		 <56716386.4070107@candelatech.com>
	 <1450272308.8247.11.camel@sipsolutions.net>
	 <567168AF.4060804@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-12-16 at 05:35 -0800, Ben Greear wrote:

> Well, the old code used it as a key, and the old documentation used
> it as a key, so it is a bit of a regression to change the behaviour
> now.

But it's still used as a key, no? Just the value changed. If you treat
it as a key then you'd just have it for a frame incoming and outgoing?

> > I think this is pretty much a done deal by now though since I don't
> > really want to break wmediumd.
> 
> It was not the only user-space to use the API :)

So you're saying you have code that broke? How did it break though, I
don't really see it yet. Can you explain?

> Well, that would be fine too.  The nice thing about the
> address,though, is that you can query it as part of
> /sys/class/ieee..... and other already-implemented
> interfaces.  Finding the radio-id would require new API in this case,
> which is a bit of work.

Well, it was always rather awkward since it was the *second* address :)

You can query the ID/index already through the netlink API, or even
from sysfs since the virtual device name is essentially
	sprintf(name, "hwsim%d", idx)

johannes
