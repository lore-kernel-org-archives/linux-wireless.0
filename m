Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18613 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1AGCtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:49:13 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:48:56 -0800
Date: Thu, 6 Jan 2011 18:49:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for
 debugfs.
Message-ID: <20110107024909.GD20431@tux>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
 <1294361165-15308-3-git-send-email-greearb@candelatech.com>
 <AANLkTikjjKe96Ok09Yz1R_nqsoO+n-9X-abeF8VUoOwQ@mail.gmail.com>
 <4D267E4D.7000608@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D267E4D.7000608@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 06, 2011 at 06:45:33PM -0800, Ben Greear wrote:
> On 01/06/2011 06:30 PM, Luis R. Rodriguez wrote:
> > On Thu, Jan 6, 2011 at 4:46 PM,<greearb@candelatech.com>  wrote:
> >> +#define ATH9K_MAX_STATIONS 1024
> >
> > How about making this a Kconfig with a default to a value of the known
> > (by you) max workable number of STAs that one can use on ath9k, which
> > is modifiable to other values by power of two up to 1024. Advise in
> > the kconfig that if more STAs are used then some issue may arise but
> > should be reported (so the issue can be fixed). This way by default
> > normal users (you're not normal) won't enable>  max known workable
> > stable number of STAs on ath9k.
> 
> This is just for debugging at this point.  It wastes a bit of memory
> when debugfs is enabled, but otherwise doesn't affect anything.  It's
> not even really a problem if there are more stations than fit in
> the array.

I meant to use the value as a limit on the # of STAs you can create
with one ath9k device. The debugfs can still be used as you did,
only that the limit would come from the kconfig value.

> I can reproduce all my problems with < 128, so if you'd prefer
> the number be smaller, that's fine with me.  I don't think it's
> worth a configurable value, however.

I thikn we should limit the # STAs to whatever it is that you can
use in a realiable way, this should be a driver limitation, but
I figured you'd want to configure this to a higher value yourself
for whatever tests you are doing. We should fix it though but at
least other clueless users would not go over stable limit you have
found.

  Luis
