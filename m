Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout9.freenet.de ([195.4.92.99]:50003 "EHLO mout9.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab1G3UCH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 16:02:07 -0400
Message-ID: <4E346396.9030707@01019freenet.de> (sfid-20110730_220214_714752_8351D120)
Date: Sat, 30 Jul 2011 22:03:34 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com> <20110730182810.GA2743@jm.kir.nu>
In-Reply-To: <20110730182810.GA2743@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen schrieb:
> On Fri, Jul 29, 2011 at 07:22:17PM +0200, Helmut Schaa wrote:
>> Since EAPOL frames are normal data frames they are treated by the
>> rate control algorithm as such. Thus it can happen that the rate
>> control algorithm chooses an inappropriate rate (minstrel_ht uses
>> MCS rates for example) for the 4-way handshake and under low signal
>> conditions the handshake may time out.
>> 
>> To fix this issue always treat EAPOL frames the same as management 
>> frames and send them with the lowest available rate.
> 
> I don't think that this should be applied for the reasons given (and 
> alternative mechanisms proposed) in the discussion.

I tested it with AP (rt2860) (with STA rt3572sta) under load and
couldn't see any improvement. The first PTK-rekeying didn't work as
usual. Or should it be applied to STA?


Andreas
