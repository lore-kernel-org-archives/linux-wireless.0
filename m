Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47980 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaKNHIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 02:08:42 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH] cfg80211: remove net-pf-16-proto-16-family-nl80211 module alias
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1415933817.2629.14.camel@dcbw.local>
Date: Fri, 14 Nov 2014 16:08:41 +0900
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <2CD74A8A-6F36-4F1C-A784-D6FC1695CC1A@holtmann.org> (sfid-20141114_080844_993451_D148B6CC)
References: <20141113123313.GA1926@redhat.com> <1415882683.2021.3.camel@sipsolutions.net> <20141113132252.GB1926@redhat.com> <252AB6B9-9D33-4932-B75F-D3B2B057D3C0@holtmann.org> <20141113133928.GC1926@redhat.com> <4E8F3B23-EC77-4B53-8180-7DB12042E0B5@holtmann.org> <1415933817.2629.14.camel@dcbw.local>
To: Dan Williams <dcbw@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

>>>>> With the alias cfg80211 module is loaded on systems without the wireless
>>>>> hardware when user-space use nl80211 to discover if there are wireless
>>>>> devices, what is considered as resources wastage. On systems with
>>>>> wireless hardware cfg80211 module will be loaded anyway.
>>>>> 
>>>>> Cc: Marcel Holtmann <marcel@holtmann.org>
>>>>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>>>>> ---
>>>>> net/wireless/core.c | 1 -
>>>>> 1 file changed, 1 deletion(-)
>>>>> 
>>>>> diff --git a/net/wireless/core.c b/net/wireless/core.c
>>>>> index a4d2792..badcabe 100644
>>>>> --- a/net/wireless/core.c
>>>>> +++ b/net/wireless/core.c
>>>>> @@ -34,7 +34,6 @@
>>>>> MODULE_AUTHOR("Johannes Berg");
>>>>> MODULE_LICENSE("GPL");
>>>>> MODULE_DESCRIPTION("wireless configuration support");
>>>>> -MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);
>>>> 
>>>> NAK.
>>>> 
>>>> We want to auto-load cfg80211 when userspace asked for nl80211 netlink family.
>>> 
>>> Could you elaborate more why?
>> 
>> you want to talk to the nl80211 family. The kernel has a module that allows you to talk to this family. So let it load the netlink family.
>> 
>> If you do not want cfg80211 loaded, then fix NetworkManager and not hack the kernel. NetworkManager asks to talk to nl80211 in the first place. That one is causing the loading of cfg80211 module.
> 
> Unfortunately there seems to be no reliable way of detecting that an
> ethernet-type interface is WiFi (and talks nl80211) or is not WiFi, than
> by asking it, using nl80211.  Unless you have suggestions for this?

my suggestion is to fix missing DEVTYPE=wlan entries.

If you want to do detection via nl80211, that is fine by me. However then NetworkManager users have to accept that this will then trigger loading of cfg80211 module. But we are not removing a correct module alias because of this.

This is the same thing when you start bluetoothd without any Bluetooth controllers attached to the system. The bluetooth core module will be loaded. We are not removing the correct socket address family module auto-loading because someone does not want to have the module loaded, but poke with the socket for some reason.

Regards

Marcel

