Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34892 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbcBXIku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 03:40:50 -0500
Received: by mail-wm0-f52.google.com with SMTP id c200so257840254wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 00:40:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56CC62BC.308@candelatech.com>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
 <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com> <56CC62BC.308@candelatech.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 24 Feb 2016 10:40:34 +0200
Message-ID: <CA+XVXffxWtZgfZS=EZGYng6vWMxqnhTdhgxagYXRbKq1iYj0Sg@mail.gmail.com> (sfid-20160224_094054_557322_04E9250C)
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2016 at 3:46 PM, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 02/23/2016 02:47 AM, Arik Nemtsov wrote:
>>
>> On Tue, Feb 23, 2016 at 12:42 AM, <greearb@candelatech.com> wrote:
>>>
>>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> ath10k supports VHT on 2.4Ghz band.
>>> If supplicant and hostapd and radio think
>>> VHT should be allowed, then kernel should let them
>>> try.
>>
>>
>> Removing the 80Mhz check entirely is not the right way to go IMO. The
>> check is there because there are countries where VHT rates are not
>> allowed, even on 20MHz channels. We use the fact these countries have
>> no 80MHz-allowed ranges as a crude regulatory hint to disable VHT
>> entirely. I'm not sure about the regulatory landscape in these
>> countries regarding VHT in 2.4GHz, but please don't break compliance
>> for the 5Ghz use-case.
>
>
> Maybe someone can fix the regulatory logic then?
>
> Add a no-vht flag or whatever?

This is more tricky that it looks at first - basically current
regulatory "hooks" concern channel width and location, transmit power
etc. Here regulatory compliance means never emitting the VHT IE in
probe requests etc. So a "no vht" flag would be useless to the reg.c
code - it currently never looks at IEs. Some cards even generate them
at the FW level.
All in all I think the current small bit of ugliness is justified for
regulatory compliance.

Also it's pretty easy to just leave the code there and condition the
check on the 5GHz band. There's no need to remove it.

>
> Any idea which countries this applies to?

I know Russia is one such country. Not sure about others.

Arik
