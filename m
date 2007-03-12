Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61157 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbXCLSat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 14:30:49 -0400
Message-ID: <45F59C53.4090500@lwfinger.net>
Date: Mon, 12 Mar 2007 13:30:43 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: David Woodhouse <dwmw2@infradead.org>,
	Joseph Jezak <josejx@gentoo.org>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net> <1173685989.3584.2.camel@shinybook.infradead.org> <45F55452.3000704@gentoo.org> <20070312145309.GB8878@tuxdriver.com> <1173712594.3584.6.camel@shinybook.infradead.org> <45F590FA.4020409@lwfinger.net> <20070312174825.GD8878@tuxdriver.com>
In-Reply-To: <20070312174825.GD8878@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Mon, Mar 12, 2007 at 12:42:18PM -0500, Larry Finger wrote:
>> David Woodhouse wrote:
>>> On Mon, 2007-03-12 at 10:53 -0400, John W. Linville wrote:
>>>> FWIW, by inspection it looks like the mac80211-based driver is
>>>> (trying?) to implement this change.
>>>>
>>>> David, have you tried the mac80211 version?  Does it still have the
>>>> same crash?
>>> Should the one in 2.6.20-1.2982.fc7 be OK? I can try that relatively
>>> easily; anything else might need to wait till I get home.
>>>
>> I don't think it will improve anything. I don't currently have a copy of wireless-dev, but the code
>> in the mb tree is identical with that of wireless-2.6. I'm currently trying to figure out the spec
>> at http://bcm-v4.sipsolutions.net/802.11/PHY/calinit and what we need to change.
> 
> Huh?  Are you looking in drivers/net/wireless/mac80211/bcm43xx?
> It certainly seems to differ quite a bit from what is in
> drivers/net/wireless/bcm43xx (i.e. no the softmac-based version).

I was, but the conclusion is the same. The generate_xxatt_list is not relevant and only the last if
clause is important. The second argument to the second call to wireless_core_reset is just a
different way to say "non-zero".

I've been looking at the code for a while now, and I still don't see where the code doesn't match
the spec. Either it is a subtle point, or I'm not even close to sharp today.

Larry
