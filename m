Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49145 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaANGgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 01:36:37 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Pierre Bourdon <delroth@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Exporting the TSF to userland
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
	<1389007385.5891.9.camel@jlt4.sipsolutions.net>
	<CA+V6dmjoLx90vEwGZa8vRNHp0yWqKQnae+GcvEZHsCxR-oHnhg@mail.gmail.com>
Date: Tue, 14 Jan 2014 08:36:36 +0200
In-Reply-To: <CA+V6dmjoLx90vEwGZa8vRNHp0yWqKQnae+GcvEZHsCxR-oHnhg@mail.gmail.com>
	(Pierre Bourdon's message of "Mon, 6 Jan 2014 12:37:34 +0100")
Message-ID: <87k3e3nk7f.fsf@purkki.adurom.net> (sfid-20140114_073641_183911_7BF58A2E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pierre Bourdon <delroth@gmail.com> writes:

> On Mon, Jan 6, 2014 at 12:23 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2013-12-31 at 05:24 +0100, Pierre Bourdon wrote:
>>> Hello linux-wireless,
>>>
>>> I'm a developer of libdrc, a project that allows Linux computers to
>>> control a Wii U GamePad. Because of how the device operates, our
>>> library needs to be able to read the TSF value of the access point
>>> device from userland.
>>>
>>> We currently have a hacky patch that works for our use cases, but it
>>> would be a lot more convenient if that feature could be upstreamed.
>>> What would be the best way to proceed?
>>
>> That patch ... let's say I think "hacky" is almost lauding it. :)
>>
>> sysfs is a really bad place for this too, no other wireless APIs use
>> sysfs.
>
> What do you recommend as the best place to export this kind of information?

Either nl80211 or debugfs. Maybe debugfs is better because this is more
or less a hack?

-- 
Kalle Valo
