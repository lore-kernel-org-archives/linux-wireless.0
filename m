Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11375 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3GLEX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 00:23:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	<linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Help adding trace events to xHCI
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	<1373562533.8201.33.camel@jlt4.sipsolutions.net>
Date: Fri, 12 Jul 2013 07:23:16 +0300
In-Reply-To: <1373562533.8201.33.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Thu, 11 Jul 2013 19:08:53 +0200")
Message-ID: <8738rk5ruz.fsf@kamboji.qca.qualcomm.com> (sfid-20130712_062344_672719_B25E9205)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> (Mentors and wireless folks, we're struggling a bit with adding trace
>> events to the xHCI USB host controller driver.  I'm trying to look at
>> the ath6kl driver trace events as an example.  We could use some help
>> and/or advice.)
>
> Those were in turn modelled on mac80211, cfg80211 and/or iwlwifi, I
> think; might be worth also looking there. In general though, it's all
> pretty similar.

Correct, I used your code as example.

> The message tracing was really more of an after-thought in iwlwifi (and
> ath6kl as well I guess) because we already had a lot of debug messages
> and capturing it all together can be useful.
>
> However, tracing all the debug messages is actually fairly expensive, I
> think in part because of the string formatting and in part because of
> the always-max allocations in the ringbuffer.

The reason why added message tracing to ath6kl was that I wanted to
combine wpasupplicant, cfg80211 and ath6kl debug messages all into file
with synchronised timestamps. In this case I wasn't actually concerned
about performance at all.

-- 
Kalle Valo
