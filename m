Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48324 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbZAISr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 13:47:58 -0500
Received: by bwz14 with SMTP id 14so29434958bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 10:47:56 -0800 (PST)
To: "Bob Copeland" <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Subject: Re: drivers returning wrong results from their _tx op
References: <1231193264.3697.41.camel@johannes>
	<b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com>
	<1231246859.3503.0.camel@johannes>
	<20090109022347.GA5077@hash.localnet> <87hc4828xn.fsf@litku.valot.fi>
	<20090109153716.M19288@bobcopeland.com>
	<87hc48tpwa.fsf@litku.valot.fi> <20090109182142.M2510@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 20:47:53 +0200
In-Reply-To: <20090109182142.M2510@bobcopeland.com> (Bob Copeland's message of "Fri\, 9 Jan 2009 13\:27\:27 -0500")
Message-ID: <87zli0s4di.fsf@litku.valot.fi> (sfid-20090109_194803_099068_AF60E603)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <me@bobcopeland.com> writes:

> On Fri, 09 Jan 2009 18:17:41 +0200, Kalle Valo wrote
>> I read it. Adding "or NETDEV_TX_BUSY if it fails" is just confusing,
>> better to state that it just should not fail.
>
> Fair enough, but the state of things today is some drivers do.
> Yes, we're guilty of that in ath5k and it should be fixed.  But like 
> ->config(), if the callback should never ever fail, then returning
> an error code at all is pretty suspect.

Yes, that's why it's already better to deny this kind of usage in
documentation already now.

> Would this be better?
>
> "This function should return NETDEV_TX_OK except in very limited cases."
>
> Then when someone asks which cases, you say "none"...

That's better.

Thanks for doing this. It's very important to document the return
values, especially for the people not familiar with mac80211.

-- 
Kalle Valo
