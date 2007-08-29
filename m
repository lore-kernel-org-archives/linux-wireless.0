Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.173]:58601 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbXH2ETE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 00:19:04 -0400
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
	<1188317935.7837.106.camel@johannes.berg> <878x7v8rcm.fsf@nokia.com>
	<1188326593.7837.118.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
In-Reply-To: <1188326593.7837.118.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 28 Aug 2007 20\:43\:13 +0200")
Date: Wed, 29 Aug 2007 07:18:13 +0300
Message-ID: <87fy2355yy.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Sorry for sending twice, I accidentally sent the previous mail too
early.)

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2007-08-28 at 21:08 +0300, Kalle Valo wrote:
>
>> I hope you have time to investigate this, because I really would like
>> to have Nokia N800 and 770 working with b43 AP. So if you need more
>> testing, just ask.
>
> Can you disable QoS and see if the same weird frames show up again? b43
> doesn't really support QoS yet but I don't think that should be causing
> such frame corruption.

>From b43 or N800? 

> Interestingly, your N800 seems to pick up the frames correctly since it
> did reply to the ping packets... 

Yes, N800 managed to receive some ping packets from the laptop, but
the packet loss was high (at least 50%). It happened because the ARP
requests were not buffered and N800 could receive them occasionally
just by luck. When N800 replied to the request, it woke up from PSM
and b43 immediately sent all the buffered frames to N800. 

N800 stays awake 200 ms (100 ms if display is off) after a transmitted
frame, so there's some time to receive packets at that time.

If added a static ARP entry (ip neigh change ... permanent), packet
loss was 100%.

> Did you have a capture size limit?

I think I didn't, but I have to recheck.

-- 
Kalle Valo
