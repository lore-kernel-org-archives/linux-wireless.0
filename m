Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.172]:21850 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbXH2ObX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 10:31:23 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
	<87lkccf30m.fsf@tikku.osso.net>
	<1187270479.5141.44.camel@johannes.berg> <87643f4kkh.fsf@nokia.com>
	<1187275344.23489.6.camel@johannes.berg> <871wdphsus.fsf@nokia.com>
	<1188290911.7837.65.camel@johannes.berg> <87absbsz5f.fsf@nokia.com>
	<1188299159.7837.96.camel@johannes.berg> <87sl63prsg.fsf@nokia.com>
	<1188349109.7837.147.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Wed, 29 Aug 2007 17:32:38 +0300
In-Reply-To: <1188349109.7837.147.camel@johannes.berg> (ext Johannes Berg's message of "Wed\, 29 Aug 2007 02\:58\:29 +0200")
Message-ID: <877inev2bd.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Good news.

Really good news!

>> But that's not all, also multicast frames (including ARP broadcast)
>> are not buffered correctly. They are sent randomly instead of directly
>> after a DTIM beacon. Also Multicast bit is not set and DTIM is always
>> zero even though DTIM period is two.
>
> Actually, they were sent right away because we enqueued them to queue
> zero, not queue four.

Yeah, I meant randomly relative to a DTIM beacon.

> Please try the attached patches. I haven't implemented the set_tim()
> callback yet, but the device should now wake up for multicast traffic,
> not for unicast yet. The patches work for me on a heavily patched kernel
> ('everything' plus http://johannes.sipsolutions.net/patches/kernel/all/)

Applied 055-b43-timb-position.patch and 057-b43-mcast.patch to commit
0347a7c86f. Multicast is buffered correctly and N800 sees them. Also
DTIM count and multicast bit are now correct in beacons.

-- 
Kalle Valo
