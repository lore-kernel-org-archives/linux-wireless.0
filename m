Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2829 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965Ab3DXINy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 04:13:54 -0400
Message-ID: <51779434.4010709@broadcom.com> (sfid-20130424_101400_945415_BF7D2179)
Date: Wed, 24 Apr 2013 10:13:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Marcel Holtmann" <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: Android P2P-Device workaround
References: <1366721149-5440-1-git-send-email-johannes@sipsolutions.net>
 <EC4E16A7-2F9E-4E59-A561-88C85A459BCA@holtmann.org>
 <1366735340.8385.20.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366735340.8385.20.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2013 06:42 PM, Johannes Berg wrote:
> On Tue, 2013-04-23 at 07:50 -0700, Marcel Holtmann wrote:
>
>>> +config CFG80211_ANDROID_P2P_HACK
>>> +	bool "Android P2P netdevice hack"
>>> +	depends on CFG80211
>>> +	depends on !CFG80211_WEXT
>>> +	help
>>> +	  Enable this option for Android P2P w/ P2P Device.
>>> +
>>
>> do you really think this is a good idea? Wouldn't it be better if
>> Android just gets its userspace fixed. This way, they never will and
>> you carry this workaround forever.
>
> Well, I'm about 50/50 on whether to merge this. On the one hand, it's a
> very simple patch to carry out of tree, on the other hand more than one
> person will need it.
>

Here is one who needs it. I consider this patch as a temporary solution, 
but it would be good to have it upstream. We would be using 
compat-drivers to backport the upstream brcmfmac to the android kernel, 
which also takes care of cfg80211.

>> Has anybody actually looked into what it would take to just fix
>> Android userspace to use nl80211 to bring up P2P. I just see tons of
>> #ifdef added to the kernel.
>
> Yes, I did :-)
>
> However, for any system running Jelly Bean that's not really an option,
> and I have no idea if/how K-whatever is coming, so it might not be
> possible there either. Additionally, fairly large changes are needed in
> wpa_supplicant to actually support the P2P-Device with only nl82011
> APIs.

If android is moving to 3.8 kernel with KLP (key lime pie), you could 
say that it requires middleware/wifi-framework to deal with the new 
kernel API. However, it mostly involves wpa_supplicant regardless of 
using it on android or not. So this is more a wpa_supplicant P2P hack.

> This gives us a transition path while making changes to the other parts
> of the stack.

For 'selfish' reasons I am not opposed to this path ;-)

>>> +			if (!dev
>>> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
>>> +			    || (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
>>> +				info->genlhdr->cmd != NL80211_CMD_SET_INTERFACE)
>>> +#endif
>>> +			) {
>>> 				mutex_unlock(&cfg80211_mutex);
>>> 				if (rtnl)
>>> 					rtnl_unlock();
>>
>> And doing an #ifdef in the middle of if-clause doesn't ring any alarm
>> bells that this might be a really bad idea ;)
>
> Well, I could put an #ifdef into each and every command instead which I
> didn't want to, which incidentally is the reason for not allowing this
> with WEXT, WEXT ioctls on the P2P-Device netdev just cause crashes :)

I dislike these kind of constructs as well so I would like this to be 
made somewhat cleaner (conditional helper function?).

> Basically this way also reduces the surface of this patch to make it
> easier to use out of tree.
>
>> When I am looking at the USB gadget handling, I see a lot of progress
>> in establishing a standard kernel interface and changing Android
>> userspace to work with that instead.
>
> "progress" doesn't really help, at least in this case it's pretty much
> an either-or situation and changing the userspace will take a long time.

As long as changing the user-space is done eventually, right.

Gr. AvS

