Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38373 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbcAEQVj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:21:39 -0500
Message-ID: <1452010897.12357.48.camel@sipsolutions.net> (sfid-20160105_172143_468275_C031479B)
Subject: Re: Reading the current monitor flags of an interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Roger James <roger@beardandsandals.co.uk>,
	linux-wireless@vger.kernel.org
Date: Tue, 05 Jan 2016 17:21:37 +0100
In-Reply-To: <568BED11.50302@beardandsandals.co.uk>
References: <5687FA72.9000301@beardandsandals.co.uk>
	 <1452009755.12357.44.camel@sipsolutions.net>
	 <568BED11.50302@beardandsandals.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 16:19 +0000, Roger James wrote:
> 
> Thanks Johannes, that was my conclusion, but I was not sure if that was 
> true in all cases. I tried another chipset and got the same results. 

It is true in all cases, since it's the generic cfg80211 code not doing
this. It's not even storing the flags, so it's not a trivial patch.

> I 
> am trying to debug a problem with an adapter only seeing broadcast and 
> multicast packets in monitor mode, and the significance of the setting 
> of the  otherbss flag in this case. It would be really helpful if iw
> could return the complete state of an interface, but it looks like that 
> would require a kernel patch. This seems like a can of worms to me.

It's not trivial, agree, since you'd have to query the underlying
driver (mac80211) for the flags.

johannes
