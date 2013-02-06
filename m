Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:56875 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3BFLzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 06:55:40 -0500
Received: by mail-la0-f53.google.com with SMTP id fr10so1229522lab.26
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 03:55:39 -0800 (PST)
Message-ID: <511244B4.2020007@gmail.com> (sfid-20130206_125544_319046_774A30FB)
Date: Wed, 06 Feb 2013 12:55:32 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: configuration for WoWLAN over TCP
References: <1360062367-15970-1-git-send-email-johannes@sipsolutions.net>  <51110D86.8030500@gmail.com>  (sfid-20130205_144759_494055_8E3FC786) <1360072210.8376.9.camel@jlt4.sipsolutions.net>  (sfid-20130205_144950_996774_14518D3F) <1360073836.8376.10.camel@jlt4.sipsolutions.net>  (sfid-20130205_151706_344715_2E47E8AD) <1360075125.8376.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360075125.8376.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-05 15:38, Johannes Berg wrote:

>>>> What's protecting this feature from stomping on an existing connection
>>>> when specifying the source port?
>>>
>>> Nothing. Presumably if you specify it you know what you're doing, and
>>> don't also create a connection to the same IP from the same port?
>>>
>>> Hmm. Maybe we could allocate the socket anyway and make it allocate the
>>> chosen port, failing if it isn't available? I guess I need to check the
>>> APIs.
>>
>> I guess this might work: http://p.sipsolutions.net/e5bc789d26b5e34a.txt
>
> Yep, seems to work, I'll fold that in. (Tested by having a TCP
> connection open and requesting the same port to be used)

Great! Patch looks good otherwise IMHO.

Cheers,

Pontus
