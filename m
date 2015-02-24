Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39799 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbbBXOkk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 09:40:40 -0500
Message-ID: <1424788834.2192.34.camel@sipsolutions.net> (sfid-20150224_154044_417315_3C886BEB)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 15:40:34 +0100
In-Reply-To: <54EC8C5D.5090400@candelatech.com>
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>
		  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>
		 <54EB66CC.1030800@candelatech.com>
	 <1424772714.2192.16.camel@sipsolutions.net>
	 <54EC8C5D.5090400@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-24 at 06:36 -0800, Ben Greear wrote:

> We could push more and more of this to user-space and let it decide whether and
> how to forward or accept frames for particular radios.

Sure, no objection to that. However, just arbitrarily adding a "change
channel" call, without thinking about the realities of the code already
supporting multi-channel concurrency, remain-on-channel and hw-scan
operations won't get us very far and just lead to issues with the API.

> But, to do that, we need the low-level settings sent to user-space
> (such as current channel).  Encryption keys could be a future enhancement
> here, so that we can do 'hardware' encryption in hwsim (and handle encrypt/decrypt
> logic however we want in user-space).

Sure. I'd just like to ask that the API is actually useful in more than
the default single-channel support BSS-only case :)

johannes

