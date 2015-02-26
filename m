Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54778 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbbBZUHe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 15:07:34 -0500
Message-ID: <1424981243.1885.31.camel@sipsolutions.net> (sfid-20150226_210737_745382_2063C683)
Subject: Re: [PATCH] mac80211: Send EAPOL frames at lowest rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Thu, 26 Feb 2015 21:07:23 +0100
In-Reply-To: <CA+55aFyMoNhwYKcYwfs7Jjxh-wQbQK92Gqs8pv9AcLJUwk13RA@mail.gmail.com> (sfid-20150226_190127_554604_DDFD2747)
References: <1424958650-11165-1-git-send-email-jouni@qca.qualcomm.com>
	 <CA+55aFyMoNhwYKcYwfs7Jjxh-wQbQK92Gqs8pv9AcLJUwk13RA@mail.gmail.com>
	 (sfid-20150226_190127_554604_DDFD2747)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus, Jouni, all,

Thanks everyone. I've applied this patch to my mac80211 tree - I'll send
it out to davem tomorrow I think.

Jouni, given that hwsim uses minstrel as well, perhaps we could have a
test case in the wpa_supplicant tests in some way that checks this? I'm
thinking we could hook into the AP and remove it from the radio group
right after sending 3/4, so that 4/4 would get retransmitted? I don't
actually know though if hwsim really honours all the rate stuff,
something to look into perhaps.

> Also "Tested-by:", and I'd suggest marking it for stable too (although
> I understand that David generally doesn't use stable tags, and just
> sends them separately to the stable tree).

Done - and yeah, he does that, but I add stable tags anyway since I
don't want to track it down later. So far he hasn't complained :-)

> My main laptop is iwlwifi, and the only reason that worked is
> apparently that the iwlwifi driver already basically does something
> similar on its own.

Yes, and it also starts out at a lower rate.

> All the other devices I have apparently don't use the 802.11 code even
> if they are Linux-based (ie mostly android, and presumably they use
> some vendor driver rather than the minstrel rate-handling code).

Indeed, very few of them do. The only ones I'm aware of are (fairly old)
phones using the TI wifi chip - my Motorola razr i for example actually
runs mac80211. However, it also doesn't use minstrel, so I guess you
won't find a phone using this :-)

johannes

