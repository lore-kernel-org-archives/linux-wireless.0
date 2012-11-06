Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.freestuffjunction.co.uk ([109.169.51.71]:42871 "EHLO
	mail.freestuffjunction.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab2KFQX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 11:23:59 -0500
Message-ID: <50993991.5090906@ehuk.net> (sfid-20121106_172406_928192_D554CCF1)
Date: Tue, 06 Nov 2012 16:23:45 +0000
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: Eddie Chapman <eddie@ehuk.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: Linux 3.6.5
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>    <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>    (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>   <509838F4.4010301@ehuk.net>  <1352188621.9440.4.camel@jlt4.sipsolutions.net> <50992E0E.3040606@ehuk.net> <1352217244.9440.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352217244.9440.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/12 15:54, Johannes Berg wrote:
> Hi Eddie,
>
>> The AP is a Netgear WNR2000v3 running DD-WRT v24-sp2 (03/19/12) std.
>>
>> After sshing into it and playing around with the iw command, the phy is
>> phy0 and the device is ath0.
>>
>> "iw ath0 scan dump" returns nothing unfortunately.
>
> Yeah, sorry, I guess I confused you. I did want this info from the
> client, as you provided:
>
>> In case it helps, on the laptop (the client) I do get output from "iw
>> wlan0 scan dump":
>>
>> BSS 82:e1:fa:1a:65:00 (on wlan0) -- associated
> [...]
>> 	HT operation:
>> 		 * primary channel: 9
>> 		 * secondary channel offset: above
>
> As you can see, it's using HT40+ on channel 9 (2452 MHz). Your HT40
> allow (correctly) map showed:
>
> 2452 HT40 -
>
> This is because HT40+ isn't actually allowed on channel 9 by the
> standard (cf. 802.11-2012 Table E-1 (US), E-2 (Europe), E-3 (Japan).

I've just realised what's going on. Not being too knowledgeable about 
wireless I had no idea what HT20 and HT40 and the patch was about. Now 
when I look at the AP web interface, I see a drop down box for "Channel 
Width", with the options being:

Quarter (5MHz)
Half (10MHz)
Full (20MHz)
Turbo (40MHz)
Dynamic (20/40MHz)

and "Turbo" is selected. It doesn't say "HT" anywhere, but I'm guessing 
this setting is actually the HT setting and I have it set to 40 where it 
should be 20?  It must be something I changed when setting the AP up, 
not understanding what it did. Perhaps I should set it to Dynamic.

> I wonder, what is the oldest kernel you tried? I think the fact that we
> can connect here was introduced by some older patch, and then reverted
> by my patch, so older kernels should have been slower as well?

I've had this AP like this with the "Turbo" setting for a good few 
months, and had excellent throughput (around 4 or 5 Mbyte/s) on a 
mixture of kernels on my laptop the whole time; Fedora 15 with a 3.0 
kernel (which they named 2.6.40), and then Gentoo using various 3.4 and 
3.6 kernels. Only on upgrading to 3.6.5 was the first time throughput 
dropped.  I've also had an Android phone and another Windows XP laptop 
connecting to this AP without any problems, though never measured 
throughput with them so can't say if they have ever suffered.

> The problem here is that some devices (notably iwlwifi) will not allow
> (by firmware) to connect to such an AP as HT40- if that is not allowed.
> So I prevented it generally, but we can make it device dependent. I
> don't like it much, but I suppose we can do it. Try this patch:
>
> http://p.sipsolutions.net/0129f39c7d882289.txt
>
> It will still prohibit this configuration when the driver said it's not
> allowed, but will allow it when there were other reasons to not allow
> it.

OK, so I'll try re applying the HT20/HT40 patch in 3.6.5, and then 
applying the above patch, and report back.

thanks,
Eddie
