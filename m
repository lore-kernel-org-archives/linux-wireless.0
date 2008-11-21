Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:5394 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYKUIhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 03:37:10 -0500
Received: by ug-out-1314.google.com with SMTP id 39so41108ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 00:37:08 -0800 (PST)
Message-ID: <f76a32050811210037x5958de39g53b174b2d0dfd41b@mail.gmail.com> (sfid-20081121_093716_167211_95409482)
Date: Fri, 21 Nov 2008 09:37:07 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200811210838.25977.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <200811201537.19047.hs4233@mail.mn-solutions.de>
	 <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
	 <200811210838.25977.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Johannes and Holger,

indeed I overlooked the AID bit in the relevant traffic sequences.
Knowing now what to look for, I can follow what is going on and find
it ok - except for the huge delay in between http request and reply.
Typically, the http request is sent, the iPod goes to sleep, and
several seconds pass (with numerous beacons without any AID bit set),
before we see one or two "traffic for you" beacons, then the iPod
wakes up and gets the reply. Most of the time my app already
timeouted.

I have checked that my app indeed completes its TCP reply in almost no
time. Mysteriously, the data takes several seconds from boost::asio
write completion until it appears on the air. That's the problem.

I will go back to square one and the fact that I see different
behaviour in the iPod and my other clients. I will work out the
differences. Will be back in case I come up with more wireless
questions.

Thank you for your help! Great work!
  Stefan.


2008/11/21 Holger Schurig <hs4233@mail.mn-solutions.de>:
> On Thursday 20 November 2008 20:21:44 Stefan Steuerwald wrote:
>> The iPod alternates Null Functions with the PWR MGT bit on and
>> off - whatever that means. Is it ignoring the AP and snoring
>> away?
>
> This is because the Ipod WLAN card all the time takes a nap of
> sleep. Whenever it goes to sleep, it sets the PWR_MGT bit. When
> it wakes up, it sends again a null packet with the bit off. So
> the AP should always know if the station sleeps or not.
>
> If the Ipod has data for the Ipod while it sleeps, it simply
> wakes up and sends the data, with the PWR_MGT bit off. Maybe it
> also sends a NULL packet iwth the PWR_MGT bit off in advance.
>
> If the AP has data for the Ipod while the Ipod sleeps, it sets
> the bit that corresponds to the AID of the Ipod in its TIM map.
> This is sent in the beacons of the AP. Even when a WLAN station
> sleeps, it knows when a beacon get's broadcasted and wakes up
> just in order to receive this beacon and check for it's AID bit.
> If it is set, it wakes up fully, notifies the AP about this and
> the AP sends the data packet to the now fully awoke WLAN
> station.
>
