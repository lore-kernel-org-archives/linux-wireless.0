Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42106 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1G2SF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 14:05:56 -0400
Message-ID: <4E32F681.6020900@openwrt.org> (sfid-20110729_200559_955917_D0F09412)
Date: Fri, 29 Jul 2011 20:05:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com> <4E32F338.8040901@openwrt.org> <CAGXE3d9hNajZ0C=aVrA9Qf=aRAfZGR6ChVR36yrTqWrLEyP2+A@mail.gmail.com> <CAGXE3d-k37U5g7Leq135SzwxgXjdqsJ7-h9kLyoUc1QtbT0w-w@mail.gmail.com>
In-Reply-To: <CAGXE3d-k37U5g7Leq135SzwxgXjdqsJ7-h9kLyoUc1QtbT0w-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-07-29 8:00 PM, Helmut Schaa wrote:
> On Fri, Jul 29, 2011 at 7:56 PM, Helmut Schaa
> <helmut.schaa@googlemail.com>  wrote:
>>  On Fri, Jul 29, 2011 at 7:51 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>  On 2011-07-29 7:22 PM, Helmut Schaa wrote:
>>>>
>>>>  Since EAPOL frames are normal data frames they are treated by the rate
>>>>  control algorithm as such. Thus it can happen that the rate control
>>>>  algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates for
>>>>  example) for the 4-way handshake and under low signal conditions the
>>>>  handshake may time out.
>>>>
>>>>  To fix this issue always treat EAPOL frames the same as management
>>>>  frames and send them with the lowest available rate.
>>>
>>>  Have you tried preventing minstrel_ht from using EAPOL frames for probing
>>>  different rates instead of forcing it to use the lowest rate?
>>
>>  Nope. I'll give it a try soon.
>
> Felix, what rate is used by minstrel_ht if there are no statistics yet? MCS0?
Yes, rates default to lowest until better ones are available.

- Felix
