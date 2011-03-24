Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47167 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338Ab1CXJc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 05:32:57 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	devel@linuxdriverproject.org, Naveen Singh <nsingh@atheros.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Vipin Mehta <vmehta@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Update on Android PM enhancements - CONFIG_HAS_EARLYSUSPEND and friends
References: <AANLkTik69v+gdPzwdMSyVnvHMKbWquvfCFvHLmLu-bBB@mail.gmail.com>
	<AANLkTikurVF_-u8gTqM3ireKia28zMrkXRyrvdNTob7e@mail.gmail.com>
	<1300957495.3807.7.camel@jlt3.sipsolutions.net>
	<1300957590.3807.8.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 24 Mar 2011 11:32:40 +0200
In-Reply-To: <1300957590.3807.8.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Thu\, 24 Mar 2011 10\:06\:30 +0100")
Message-ID: <87k4fouamf.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2011-03-24 at 10:04 +0100, Johannes Berg wrote:
>> On Wed, 2011-03-23 at 17:47 -0700, Arve Hjønnevåg wrote:
>> 
>> > There is no planned replacement for early suspend, and it will
>> > probably be dropped form the android kernel at some point. The wifi
>> > driver use it to enter a lower operating state when the screen is off.
>> > If you driver does have any other way to put the driver in this state
>> > you need to add an interface that lets user-space select that state
>> > directly.
>> 
>> The interface is called "ip link set wlan0 down".
>
> Or, in fact, just powersaving mode.

Exactly.

> But I don't think for a wifi driver there's any need for special
> driver specific states.

In maemo, to save power, we decreased the dynamic power save timeout
whenever display was turned off. This was all done from user space and
wifi driver in the kernel was completely unaware of the display state.
But I think this is still a hack and we should save as much as
possible power in all cases, despite the display state. Instead power
save parameters should automatically change based on the transfer
characteristics.

Few examples what I mean:

o if idle or very little traffic -> more aggressive power save
o if latency critical packets (dns requests, higher qos classes etc)
  -> decrease latency
o if active data transfer -> increase throughput

And before someone suggests adding dynamic timeout variable to
nl80211: I think it's very much implementation specific parameter. Not
all drivers support it and it might be that even in future mac80211
uses something else. So having the timeout variable in nl80211 is not
a long term solution.

-- 
Kalle Valo
