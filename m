Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56654 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1GPLlk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 07:41:40 -0400
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [TODO] at76c50x: remove wext includes
References: <1310546836.3873.6.camel@jlt3.sipsolutions.net>
	<4E1D5CB7.7070607@adurom.com> <4E1DA3A0.1000606@gnu.org>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 16 Jul 2011 14:41:38 +0300
In-Reply-To: <4E1DA3A0.1000606@gnu.org> (Pavel Roskin's message of "Wed\, 13 Jul 2011 09\:54\:40 -0400")
Message-ID: <87vcv2v4el.fsf@purkki.adurom.net> (sfid-20110716_134143_347210_BEB2727C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> On 07/13/2011 04:52 AM, Kalle Valo wrote:
>> The driver has been broken due to the mac80211 changes for a long time
>> and it's obvious that I can't maintain it anymore as I haven't touched
>> it for a long time. I would like to just remove it altogether. Any
>> objections?
>>
>> If someone wants to step up and fix it, now is the time to do it.
>
> Please keep the driver for now!

Ok, I won't remove it now but I'll send a patch stating that it's
broken currently.

> I have a pile of compatible hardware, and I should be able to fix
> it. I'm placing it onto my TODO list.

Nice. Thank you for stepping in.

> There is some really obsolete hardware that we may need to stop
> supporting, e.g. Atheros AR5210, but the reason is because it's
> supported by an actively developed driver, ath5k, and the AR5210 code
> stands in the way all the time.
>
> However, at76c50x-usb is a separate driver and it doesn't stand in the
> way of anybody except when global changes are made.

You are right. The problem is that the driver is broken currently as
it requires bssid before authentication and mac80211 doesn't provide
it. Or at least I haven't found a way to do that.

I know that Johannes has been talking about adding support for
providing bssid to the driver before authentication. So there is a
chance that we might be able to fix this without major hacks.

-- 
Kalle Valo
