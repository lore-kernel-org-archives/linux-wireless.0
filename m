Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51559 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaANIPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 03:15:07 -0500
Received: by mail-ie0-f180.google.com with SMTP id ar20so43998iec.25
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 00:15:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87k3e3nk7f.fsf@purkki.adurom.net>
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
	<1389007385.5891.9.camel@jlt4.sipsolutions.net>
	<CA+V6dmjoLx90vEwGZa8vRNHp0yWqKQnae+GcvEZHsCxR-oHnhg@mail.gmail.com>
	<87k3e3nk7f.fsf@purkki.adurom.net>
Date: Tue, 14 Jan 2014 09:15:06 +0100
Message-ID: <CANq1E4SrMVmEyLA1J9kQA565AZHBvB=5C7r0GSuhoK6UO5OVkQ@mail.gmail.com> (sfid-20140114_091510_856243_745693E8)
Subject: Re: Exporting the TSF to userland
From: David Herrmann <dh.herrmann@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Pierre Bourdon <delroth@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Jan 14, 2014 at 7:36 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Pierre Bourdon <delroth@gmail.com> writes:
>
>> On Mon, Jan 6, 2014 at 12:23 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Tue, 2013-12-31 at 05:24 +0100, Pierre Bourdon wrote:
>>>> Hello linux-wireless,
>>>>
>>>> I'm a developer of libdrc, a project that allows Linux computers to
>>>> control a Wii U GamePad. Because of how the device operates, our
>>>> library needs to be able to read the TSF value of the access point
>>>> device from userland.
>>>>
>>>> We currently have a hacky patch that works for our use cases, but it
>>>> would be a lot more convenient if that feature could be upstreamed.
>>>> What would be the best way to proceed?
>>>
>>> That patch ... let's say I think "hacky" is almost lauding it. :)
>>>
>>> sysfs is a really bad place for this too, no other wireless APIs use
>>> sysfs.
>>
>> What do you recommend as the best place to export this kind of information?
>
> Either nl80211 or debugfs. Maybe debugfs is better because this is more
> or less a hack?

It's supposed to be a real interface used to calculate timestamps for
mpeg streams, iirc. So debugfs is no option here.

Thanks
David
