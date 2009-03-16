Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58036 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578AbZCPM0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 08:26:22 -0400
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
References: <20090314171234.11126.21125.stgit@tikku>
	<20090314171452.11126.11618.stgit@tikku>
	<43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com>
	<87r60z1c8x.fsf@nokia.com> <20090316085036.GA29705@jm.kir.nu>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 16 Mar 2009 14:25:00 +0200
In-Reply-To: <20090316085036.GA29705@jm.kir.nu> (ext Jouni Malinen's message of "Mon\, 16 Mar 2009 09\:50\:36 +0100")
Message-ID: <8763i9ven7.fsf@nokia.com> (sfid-20090316_132639_434469_5864226D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

>> Other option is that the hardware which does not support checksumming
>> would just pass beacons periodically to the stack, for example every 5
>> seconds. Even though beacon filter is enabled in mac80211 it does not
>> prevent hardware from sending beacons. This is not the most optimal
>> solution, but there's not much choices if the hardware doesn't support
>> checksumming.
>
> While it would be possible to do that, it does not really solve many of
> the use cases where Beacon contents can change and the STA is required
> to take some action. For example, Channel Switch Announcement IEs would
> likely be missed if a Beacon frames is passed through that infrequently.
> I would assume the driver could enable this even if the hardware does
> not use checksumming to detect Beacon changes, but this may severely
> limit functionality in number of cases, so I'm not sure I would
> recommend this to be done in general.

Yes, definitely not recommended. I would classify it to "the ugly
hack" category.

-- 
Kalle Valo
