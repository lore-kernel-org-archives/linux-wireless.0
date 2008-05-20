Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37726 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758983AbYETNrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:47:04 -0400
Message-ID: <4832D661.60902@lwfinger.net> (sfid-20080520_154711_759299_7409BB75)
Date: Tue, 20 May 2008 08:47:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tomas Winkler <tomasw@gmail.com>, Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in	ieee80211_compatible_rates
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>	 <1211288251.6252.86.camel@johannes.berg>	 <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com>	 <1211289769.6252.90.camel@johannes.berg>	 <1ba2fa240805200633y6730a1e3ufbc0adfedd3f8243@mail.gmail.com>	 (sfid-20080520_153405_359637_5B9C0929) <1211290714.6252.93.camel@johannes.berg>
In-Reply-To: <1211290714.6252.93.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>>> Thing is, I'm not totally convinced it is wrong to the code while it may
>>> or may not be wrong...
>> Doesn't should be bss pinned int he bss list if you are associating to
>> it. If it's not there you don't have access to it's info It looks very
>> wrong to me.
> 
> Well, yes, it is a bit odd.
> 
>>> I think this patch should go in first as it
>>> actually fixes the oops, and then we can discuss the merits of adding a
>>> warning there separately. Maybe after we look a bit at the code and try
>>> to figure out whether it can still happen after that patch from
>>> Abhijeet.
>> I'm not sure if this patch is complete without this warning. What is
>> in the else statement is a hack and it should be obvious.
> 
> Considering that the message won't help us at all, why bother? We know
> it's triggering, we know this might be a problem, and we know we can
> only solve it by auditing the code. So why add a message that will get
> us countless emails/complaints from people we cannot do anything about
> anyway without doing the audit?

This argument could go on endlessly; however, it is clear that we need to 
settle on a patch and get it upstream ASAP! Now that mainline is broken, the 
urgency is _MUCH_ greater.

Larry
