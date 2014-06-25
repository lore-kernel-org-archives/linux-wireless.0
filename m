Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34913 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbaFYQvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 12:51:19 -0400
Message-ID: <53AAFDF3.9030707@broadcom.com> (sfid-20140625_185138_509373_0336400C)
Date: Wed, 25 Jun 2014 18:50:59 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/3] cfg80211: expose cfg80211_disable_40mhz_24ghz module
 parameter
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>		 <1402996581-10764-3-git-send-email-arend@broadcom.com>	 <1403516075.4418.9.camel@jlt4.sipsolutions.net>	 <53A9B391.4050602@broadcom.com> <1403711846.4140.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1403711846.4140.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-06-14 17:57, Johannes Berg wrote:
> On Tue, 2014-06-24 at 19:21 +0200, Arend van Spriel wrote:
>
>>>> + * @wiphy: The wiphy to check.
>>>> + *
>>>> + * Return: true is 40MHz is disabled in 2.4G band.
>>>> + */
>>>> +bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy);
>>>
>>> Why should that have a wiphy argument?
>>
>> It is up to cfg80211 to determine the logic behind the function. It is
>> just context supplied by the caller. The fact that it is determined by a
>> module parameter is internal cfg80211 stuff.
>
> I just don't really see any way it would ever be per wiphy?

Maybe you are right. By the way, is OBSS support a requirement to do 
40MHz in 2.4G?

>>> Might also be simpler to just export the variable?
>>
>> Either way is pretty simple I guess.
>
> Yeah, dunno. I guess exporting the function at least makes sure nobody
> will try to set the variable, so that's somewhat useful...
>
> I'd prefer to remove the wiphy argument though (and fix the kernel-doc)

No problem. Will do.

Gr. AvS

