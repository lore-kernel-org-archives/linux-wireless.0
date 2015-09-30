Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51636 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbbI3Sac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 14:30:32 -0400
Message-ID: <1443637830.1859.17.camel@sipsolutions.net> (sfid-20150930_203036_792474_D5ECDC68)
Subject: Re: Can we ignore frames with invalid BSSID in IBSS mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Date: Wed, 30 Sep 2015 20:30:30 +0200
In-Reply-To: <560C19F3.6070903@candelatech.com>
References: <5605D228.7050609@candelatech.com>
	 (sfid-20150926_010105_789618_F93D668E) <1443595615.1859.2.camel@sipsolutions.net>
	 <560BFABC.8090504@candelatech.com>
	 <1443626224.1859.9.camel@sipsolutions.net>
	 <560C036C.7000401@candelatech.com>
	 <1443633267.1859.11.camel@sipsolutions.net>
	 <560C19F3.6070903@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-30 at 10:20 -0700, Ben Greear wrote:
> 
> Yes, it is a transmitter side problem, and A-MSDU on IBSS
> is disabled by default in all ath10k firmware versions that I am aware of.

Right.

> I was hoping there might be a way to allow A-MSDU + IBSS + ath10k
> to work in future kernels without applying out-of-tree
> kernel hacks.  This would let people with appropriate firmware
> enable IBSS + A-MSDU for added performance in cases where they
> knew the peer could support the needed work-around.
> 
> I don't think it is worth a lot of effort, but if it were relatively
> simple to fix, then maybe it is worth it.
> 

Had it been a receiver-side issue, then it'd seem reasonable to work
around it. But it being a transmitter-side issue it doesn't really seem
so - *every* possible peer would have to be adjusted, and some might
not even be able to get adjusted (e.g. devices that have A-MSDU
deaggregation in hardware/firmware) ...

So to do that properly you'd have to advertise some sort of quirk
vendor IE, and all that, which seems excessive given the limited use.

johannes
