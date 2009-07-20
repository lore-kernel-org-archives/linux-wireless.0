Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:16563 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZGTQ1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 12:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <20090718235609.GC25343@khazad-dum.debian.net>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
	<20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
	<43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com>
	<20090718103756.GA11381@elf.ucw.cz> <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com>
	<20090718235609.GC25343@khazad-dum.debian.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 20 Jul 2009 09:27:16 -0700
Message-ID: <43e72e890907200927j40ee0f35j6c9c2ede09f5dca6@mail.gmail.com>
Subject: Re: Generic events for wake up from S1-S4
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 18, 2009 at 4:56 PM, Henrique de Moraes
Holschuh<hmh@hmh.eng.br> wrote:
> On Sat, 18 Jul 2009, Luis R. Rodriguez wrote:
>> Hm yeah, but I doubt someone will do that, generally we'd get one wake
>> up event. Can't we just report the first one and ignore the rest?
>
> Well, I'd say keeping it simple is best, here.  What if you ignore the more
> interesting wakeup events by chance (and it is really up to userspace to
> know what it considers interesting...)?  IMHO, just issue as many
> notifications as needed, let userspace filter it if it wants.
>
> But if you guys are talking about something really generic, shouldn't it
> also provide the important "why" along with the "who"?
>
> Even for the most common cases, the "why" is useful: userspace may well want
> to run special routines when it wakes up because of WoL and WoW (instead of
> a key press, lid open or mouse movement...).
>
> When you factor in wakeups caused by platform alarms, well, the "why"
> becomes even more interesting.

We'd need a generic interface for keeping track of all possible
wake-up-triggers. Should be easy with udev events.

>> > What about simply reporting "wake event happened on this device" and
>> > doing that for all the devices?
>>
>> That's fine too. Just think it would be nice to be more specific if possible.
>
> A generic way for a device (of any sort, not just network devices!) to
> report that they just issued a system wakeup message, as well as the reason
> it did that seems like a good way to do it to me.

This should be easy to do via udev events.

How about an generic platform registered, and udev events issues for
wake-up-triggers, and also for wake-up-events, and leave all the
sorting out to userspace? All we'd need in-kernel would be the trigger
registration and event trigger notifications.

  Luis
