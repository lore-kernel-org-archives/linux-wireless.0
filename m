Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:36968 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2KELNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 06:13:53 -0500
Message-ID: <50979D38.6010002@ehuk.net> (sfid-20121105_121423_464154_72561532)
Date: Mon, 05 Nov 2012 11:04:24 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: Eddie Chapman <eddie@ehuk.net>
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: johannes.berg@intel.com, florian@reitmeir.org,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net> <20121105081757.GA3730@kroah.com>
In-Reply-To: <20121105081757.GA3730@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/12 08:17, Greg KH wrote:
> On Sat, Nov 03, 2012 at 07:52:20PM +0000, Eddie Chapman wrote:
>> On 3.6.5 my rt2800usb adapter's speeds (measured downloading a file
>> on the my LAN with wget) dropped down to around 900 Kbyte/s from the
>> usual approx. 4 Mbyte/s.  Also some packet loss and latency spikes.
>> Nothing unusual reported in dmesg.
>>
>> Rebooting back into 3.6.4 with identical .config and the problem goes away.
>>
>> So I reversed the following 4 patches introduced in 3.6.5:
>>
>> Felix Fietkau:
>>          mac80211: use ieee80211_free_txskb in a few more places
>>
>> Johannes Berg:
>>          mac80211: connect with HT20 if HT40 is not permitted
>>
>> Stanislaw Gruszka:
>>          mac80211: check if key has TKIP type before updating IV
>>          cfg80211/mac80211: avoid state mishmash on deauth
>>
>> rebuilt 3.6.5, rebooted into it, and speeds back to normal.
>>
>> Sorry can't be more specific, didn't have enough time to revert each
>> one individually to find out which one caused the regression.
>> Though if anyone would really like me to find out let me know.
>
> I would, if you could narrow this down to one patch, that would be
> great.
>
> Also, copying the wireless developers on the email about this, would be
> best, there's nothing that the stable tree developers can do about this
> on their own.
>
> And, can you also test 3.7-rc4, to ensure that the problem isn't there
> as well?
>
> thanks,
>
> greg k-h

Thanks Greg.

I've narrowed it down to this patch which introduces the problem:

Johannes Berg:
mac80211: connect with HT20 if HT40 is not permitted
commit: 3a40414f826a8f1096d9b94c4a53ef91b25ba28d

The other 3 patches above give me no problems at all, so I am now 
running my 3.6.5 with those 3 back in, and just the HT20/HT40 patch 
removed, and throughput is perfect. As soon as I introduce the patch 
HT20/HT40 throughput drops right down to a fifth of what it was.

So I've copied into this message the original people from the HT20/HT40 
patch as well as linux-wireless.

This is my original message in full sent to stable list for the benefit 
of the new recipients:
http://www.mail-archive.com/stable@vger.kernel.org/msg22645.html

If I can do anything else to help figure out why this patch causes 
problems for my device, please let me know.

thanks,
Eddie
