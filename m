Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:40949 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZAIQRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 11:17:46 -0500
Received: by bwz14 with SMTP id 14so29192318bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 08:17:44 -0800 (PST)
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
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 18:17:41 +0200
In-Reply-To: <20090109153716.M19288@bobcopeland.com> (Bob Copeland's message of "Fri\, 9 Jan 2009 10\:44\:22 -0500")
Message-ID: <87hc48tpwa.fsf@litku.valot.fi> (sfid-20090109_171750_586450_7B76D03F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <me@bobcopeland.com> writes:

> On Fri, 09 Jan 2009 10:13:56 +0200, Kalle Valo wrote
>> > @@ -1170,6 +1170,7 @@ enum ieee80211_ampdu_mlme_action {
>> >   *	configuration in the TX control data. This handler should,
>> >   *	preferably, never fail and stop queues appropriately, more
>> >   *	importantly, however, it must never fail for A-MPDU-queues.
>> > + *	Returns NETDEV_TX_OK, or NETDEV_TX_BUSY if it fails.
>> >   *	Must be implemented and atomic.
>> 
>> Based on discussion from netdev I have understood that NETDEV_TX_BUSY
>> is not recommended, it's better to stop the queue already earlier,
>> drop the frame or store the skb somewhere else temporarily. Johannes,
>> have I understood this correctly?
>> 
>> It would be nice to have this documented here.
>
> Read the sentence before the added line :-)

I read it. Adding "or NETDEV_TX_BUSY if it fails" is just confusing,
better to state that it just should not fail.

-- 
Kalle Valo
