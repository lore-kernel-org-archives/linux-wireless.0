Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50779 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1G2SKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 14:10:04 -0400
Received: by gwaa12 with SMTP id a12so665095gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 11:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E32F681.6020900@openwrt.org>
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com>
	<1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com>
	<4E32F338.8040901@openwrt.org>
	<CAGXE3d9hNajZ0C=aVrA9Qf=aRAfZGR6ChVR36yrTqWrLEyP2+A@mail.gmail.com>
	<CAGXE3d-k37U5g7Leq135SzwxgXjdqsJ7-h9kLyoUc1QtbT0w-w@mail.gmail.com>
	<4E32F681.6020900@openwrt.org>
Date: Fri, 29 Jul 2011 20:10:03 +0200
Message-ID: <CAGXE3d9Lb54PPMMqi6GJhLyjiVN+GP6jOoEA1SWLECL64HbTvQ@mail.gmail.com> (sfid-20110729_201045_381121_76CFEEDF)
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 8:05 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-07-29 8:00 PM, Helmut Schaa wrote:
>>
>> On Fri, Jul 29, 2011 at 7:56 PM, Helmut Schaa
>> <helmut.schaa@googlemail.com>  wrote:
>>>
>>>  On Fri, Jul 29, 2011 at 7:51 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>>
>>>>  On 2011-07-29 7:22 PM, Helmut Schaa wrote:
>>>>>
>>>>>  Since EAPOL frames are normal data frames they are treated by the rate
>>>>>  control algorithm as such. Thus it can happen that the rate control
>>>>>  algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates
>>>>> for
>>>>>  example) for the 4-way handshake and under low signal conditions the
>>>>>  handshake may time out.
>>>>>
>>>>>  To fix this issue always treat EAPOL frames the same as management
>>>>>  frames and send them with the lowest available rate.
>>>>
>>>>  Have you tried preventing minstrel_ht from using EAPOL frames for
>>>> probing
>>>>  different rates instead of forcing it to use the lowest rate?
>>>
>>>  Nope. I'll give it a try soon.
>>
>> Felix, what rate is used by minstrel_ht if there are no statistics yet?
>> MCS0?
>
> Yes, rates default to lowest until better ones are available.

Ok, I'll try if forbidding rate probing for EAPOL frames in
minstrel_ht solves this problem.
