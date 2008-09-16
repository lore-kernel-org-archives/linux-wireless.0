Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46901 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYIPIZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 04:25:52 -0400
To: "Dan Williams" <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, Helmut Schaa <hschaa@suse.de>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
References: <200809151416.07552.hschaa@suse.de>
	<200809151435.28933.hschaa@suse.de>
	<1221487652.10177.23.camel@localhost.localdomain>
	<200809151710.43827.hs4233@mail.mn-solutions.de>
	<1221491952.10177.65.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Sep 2008 11:25:10 +0300
In-Reply-To: <1221491952.10177.65.camel@localhost.localdomain> (ext Dan Williams's message of "Mon\, 15 Sep 2008 11\:19\:12 -0400")
Message-ID: <87fxo0zee1.fsf@nokia.com> (sfid-20080916_102603_629755_1AEFEE3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Mon, 2008-09-15 at 17:10 +0200, Holger Schurig wrote:
>> > So why does this need a new event?  Can't wpa_supplicant
>> > monitor the signal quality (or level/noise if the driver
>> > doesn't provide "quality") and do what it needs to do without
>> > any changes to the kernel at all?
>> 
>> It could, but to do this, wpa_supplicant (or whatever) would have 
>> to periodically get awake, send the query command to mac80211 
>> and get the result.
>> 
>> With an event, it just sits sleeping until some interesting event 
>> arrives. Nicer programming idiom, AFAIK.

I agree, this is the kind of design we should strive for. 

> Except that everything that listens to WEXT events gets woken up every
> time an event comes in anyway.  So any card doing background scanning
> will wake up the supplicant too

No, in good condition there won't be scanning going on and hence
nothing will wake up supplicant. And with good hardware design (with
beacon filtering) not even the CPU is woken up. But you are proposing
means that the suplicant (and hence the CPU) would be waken all the
time, despite the signal condition. Not good.

> I honestly think that every few seconds is OK here.

No, it really isn't ok. There are CPUs, like TI's OMAP 3430, where CPU
wake up takes a relatively long time and is expensive from power
consumption point of view. Useless periodic timers are a bad idea.

> My main problem is that adding a beacon threshold to mac80211 isn't a
> great idea because it's not a standard value and it's not something
> really applicable to mac80211; it's policy which is different for
> different programs, and the way you've implemented it here it's global
> for the interface.

Still I don't see a problem here, all the mac80211 drivers should
already now report similar signal strenght to the mac80211 in
comparable level. And I doubt that there's that much need for the
applications to adjust the roaming thershold itself. I would assume it
would be more like enable and disable, if not even that. 

Of course it would be nice to be able to configure the threshold from
user space, but I find that as an extra feature. We should try get
good default values by testing.

-- 
Kalle Valo
