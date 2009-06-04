Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([204.127.217.103]:34161 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbZFDOwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 10:52:08 -0400
Message-ID: <4A27DF95.50603@lwfinger.net>
Date: Thu, 04 Jun 2009 09:52:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: always init poll delayed work
References: <1244015729.7176.28.camel@johannes.local>	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>
In-Reply-To: <1244040913.4862.8.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-06-03 at 09:50 -0500, Larry Finger wrote:
>> 2. Much more serious - When the radio kill switch is turned off, the
>> radio is killed just as expected, but it is not restored when the
>> switch is turned on. The only way to restore the radio is to
>> rmmod/insmod b43. Similarly, if the module is loaded with the switch
>> off, it is not possible to turn the radio on. An unload/load resquence
>> is then needed.
> 
> I suspected that much. And you can't recover that since you can't set
> the interface UP. This is because polling doesn't work while the
> interface is set down. As I said previously, I think that's previously
> been buggy too, if you did
>  1) hard kill
>  2) set interface down
>  3) hard unkill
> 
> then step 3) would not trigger an event to userspace until you set the
> interface up again, afaict.
> 
> We probably need to bring up the core to poll it, if possible?

I have not made much progress in sorting this out. When I turn the
switch off, I see RFKILL_STATE in /sys/class/rfkill/rfkill0/uevent go
from unblocked to hw_blocked. It does not change when the switch is
turned on.

I have verified that b43_rfkill_poll(), the polling callback routine
is being executed, but that the hardware bit in the interface is never
being set again. Whichever part of the old rfkill_input code that made
that change seems not to be functioning.

What diagnostics would be helpful?

Larry

