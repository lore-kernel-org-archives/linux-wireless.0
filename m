Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60942 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbcCZTVB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2016 15:21:01 -0400
Message-ID: <1459020054.8901.8.camel@sipsolutions.net> (sfid-20160326_202107_096792_EFED5FBD)
Subject: Re: hashing error in hacked 4.4.6+ kernel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 26 Mar 2016 20:20:54 +0100
In-Reply-To: <56F5DE21.9050601@candelatech.com> (sfid-20160326_015610_163402_1721825C)
References: <56F5DE21.9050601@candelatech.com>
	 (sfid-20160326_015610_163402_1721825C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-25 at 17:56 -0700, Ben Greear wrote:
> 
> Mar 25 17:02:05 ath10k.candelatech.com kernel: sta28:
> deauthenticating from 04:f0:21:f6:85:1c by local choice (Reason:
> 3=DEAUTH_LEAVING)
> Mar 25 17:02:05 ath10k.candelatech.com kernel: ------------[ cut here
> ]------------
> Mar 25 17:02:05 ath10k.candelatech.com kernel: WARNING: CPU: 2 PID:
> 6227 at /home/greearb/git/linux-
> 4.4.dev.y/net/mac80211/sta_info.c:921 
> __sta_info_destroy_part1+0x91/0x422 [mac80211]()

In upstream, this warning goes straight to rhashtable not finding the
entry.

In your code though (looking at the commit introducing it, hoping you
didn't change it later), there's considerably more code in
sta_info_hash_del() that can return an error. It might be interesting
to find out *which* error is happening.

I'd agree though, from my brief look at the code it doesn't seem likely
that there's a problem with the code you add.

johannes

PS: you should probably write "return 0" instead of "return rv"
whenever it's clear that "rv" must be 0 :)

PPS: why are you not using rhashtable for the vhash?
