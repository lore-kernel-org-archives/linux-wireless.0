Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54814 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208AbbBZUOA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 15:14:00 -0500
Message-ID: <1424981635.1885.35.camel@sipsolutions.net> (sfid-20150226_211405_056983_9D4656F0)
Subject: Re: Flaky AP has bad AIFSN, so no HT/VHT....
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 26 Feb 2015 21:13:55 +0100
In-Reply-To: <54EF60F5.1030506@candelatech.com> (sfid-20150226_190753_768816_FA71C63F)
References: <54EF60F5.1030506@candelatech.com>
	 (sfid-20150226_190753_768816_FA71C63F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-02-26 at 10:07 -0800, Ben Greear wrote:

> It looks like their beacon has bogus AIFSN info, and sniff of the beacon does
> show AIFSN set to 0.

Yeah this is invalid - the spec requires at least 2.

> Kernel dmesg logs:
> 
> wlan0: authenticated at: 1424969385.456415
> wlan0: AP has invalid WMM params (AIFSN=0 for ACI 0), disabling WMM

and then since we disable WMM we also can't do HT or VHT since they both
require WMM (technically QoS, but that's mostly just different IE
signalling)

> wlan0: associate with 00:18:25:06:4a:b4 (try 1/3), at: 1424969385.457148
> wlan0: RX AssocResp from 00:18:25:06:4a:b4 (capab=0x401 status=0 aid=2) at: 1424969385.476681
> wlan0: associated at: 1424969385.477265
> 
> 
> But a commercial phone connects just fine to this AP, and reports ~780Mbps link speed,
> so it at least thinks it is doing VHT.
> 
> My question is, should we just warn and ignore this bad AIFSN, or is this really
> a fatal issue as far as enabling WMM?

It's hard to say what the AP meant when it said 0 ... did it really want
the non-standard behaviour of 0, which will result in really bad medium
access behaviour? Or should we override to use the minimum of 2?

AFAIR at least the Intel device gets horribly confused and crashes when
we actually ask it to use 0 - the backoff calculation then is rather
strange anyway.

Note that disabling WMM of course also makes use of *some* medium access
rules, so there's perhaps the possibility of using the default value for
ACs that have it as 0? OTOH, if we disable WMM, we'll use 3 for all
frames, rather than 2/2/3/7 (for VO/VI/BE/BK) ...

It's not really trivial though.

johannes

