Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38165 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbbBXKOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:14:16 -0500
Message-ID: <1424772854.2192.19.camel@sipsolutions.net> (sfid-20150224_111419_785623_FFD1C544)
Subject: Re: [PATCH] mac80211-hwsim:  Don't enqueue pkts that do not want
 txstatus.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 11:14:14 +0100
In-Reply-To: <54EB6589.6040803@candelatech.com>
References: <1423592732-17256-1-git-send-email-greearb@candelatech.com>
	 <1424707739.3075.19.camel@sipsolutions.net>
	 <54EB6589.6040803@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-23 at 09:38 -0800, Ben Greear wrote:

> > This doesn't really seem right - essentially it means that whatever you
> > just gave to userspace is now completely useless?
> > 
> > It seems skb_orphan() could/should be put here.
> 
> I don't understand your complaint, why is what I gave to user-space useless?

userspace is supposed to give back the SKB pointer as a cookie when it
reports whether or not it was transmitted correctly, and then we will
free the SKB afterwards.

Note that I also just merged a patch from Bob in this area.

> If we just orphan them, does that clean up the skb memory properly?

No, of course not, but it removes it from socket accounting. This may be
what you want, although I'm not really sure it's the right thing to do
since it would make this behave differently than other drivers which
also don't orphan the SKB (and shouldn't - you can consider the SKB on
this queue as being on the HW DMA queue where it should still be
accounted for correctly)

I think perhaps you just want Bob's patch to fix the case of too slow
userspace.

> If not, what eventually frees the skb?

The tx status path does.

johannes

