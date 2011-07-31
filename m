Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:38253 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1GaHL4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2011 03:11:56 -0400
Message-ID: <4E350095.5050002@01019freenet.de> (sfid-20110731_091159_153251_9C209371)
Date: Sun, 31 Jul 2011 09:13:25 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> <20110730182810.GA2743@jm.kir.nu> <4E346396.9030707@01019freenet.de> <201107302232.28582.chunkeey@googlemail.com>
In-Reply-To: <201107302232.28582.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter schrieb:
> On Saturday 30 July 2011 22:03:34 Andreas Hartmann wrote:
>> Jouni Malinen schrieb:
>>> On Fri, Jul 29, 2011 at 07:22:17PM +0200, Helmut Schaa wrote:
>>>> Since EAPOL frames are normal data frames they are treated by the
>>>> rate control algorithm as such. Thus it can happen that the rate
>>>> control algorithm chooses an inappropriate rate (minstrel_ht uses
>>>> MCS rates for example) for the 4-way handshake and under low signal
>>>> conditions the handshake may time out.
>>>>
>>>> To fix this issue always treat EAPOL frames the same as management 
>>>> frames and send them with the lowest available rate.
>>>
>>> I don't think that this should be applied for the reasons given (and 
>>> alternative mechanisms proposed) in the discussion.
>>
>> I tested it with AP (rt2860) (with STA rt3572sta) under load and
>> couldn't see any improvement. The first PTK-rekeying didn't work as
>> usual. Or should it be applied to STA?
> 
> might be a shot into the dark. But who's assigning a proper frame sequence
> to each eapol? Hostapd certainly can't because it doesn't know what's the
> current sequence at the moment... and mac80211 won't assign one because
> the frame is injected by a monitor interface. So when the receiver gets the
> EAPOL it might drops it because the empty sequence might be not in the
> BA window anymore. Does this sound reasonable, or did I miss something?

Meanwhile I tested with the patch on both sides, AP (rt2800pci / rt2860)
and STA (ath9k / ar9582) and compat-wireless-2011-07-28. The result is
unchanged the same: the first ptk rekeying (4 way handshake) just didn't
work.

Another thing: I don't think, that the wireless modules are the reason
of the problem. If I'm using the following test setup, I get no problem
at all:

AP: (rt2800pci / rt2860 - without patch)
STA: (rt3572 / rt3572sta - used without wpa_supplicant, but just
rt3572sta stack - rt3572sta ships with an own WPA2-PSK-stack)

-> Why is it working without any problems, if wpa_supplicant isn't used
at all?


Andreas
