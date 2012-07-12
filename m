Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44045 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2GLB6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 21:58:30 -0400
Received: by yenl2 with SMTP id l2so1928953yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 18:58:30 -0700 (PDT)
Message-ID: <4FFE2F38.7030604@lwfinger.net> (sfid-20120712_035841_436115_80064897)
Date: Wed, 11 Jul 2012 20:58:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Anyone using rtl8192de with 2.4GHz 802.11g?
References: <20120712002149.GA14850@alittletooquiet.net> <4FFE211C.3020506@lwfinger.net> <20120712013216.GB14850@alittletooquiet.net>
In-Reply-To: <20120712013216.GB14850@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2012 08:32 PM, Forest Bond wrote:
> Hi Larry,
>
> Thanks for the quick reply.
>
> On Wed, Jul 11, 2012 at 07:58:04PM -0500, Larry Finger wrote:
>> On 07/11/2012 07:21 PM, Forest Bond wrote:
>>> Hi,
>>>
>>> The rtl8192de driver is working fine for me at 5GHz, but I am having trouble
>>> getting scan results for 2.4GHz 802.11g networks.  I have been doing a lot of
>>> debugging but am not making much progress.  I suspect the 802.11 b/g/n phy is
>>> not being initialized correctly, but I'm pretty far outside my domain on this
>>> one.
>>>
>>> Is anyone successfully using this driver with a 2.4GHz 802.11g network?
>>
>> I have several different models - some work better than others. What
>> is the PCI ID for yours?
>
> This is the one I have:
>
> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8193]
> 02:00.1 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8193] (rev 01)

It turns out that both kinds have the same ID. I think one of them is a 
prototype, while the other is probably a production unit. Obviously, bitrot has 
set in while I wasn't testing. With the kernel driver, neither unit can even 
scan in the 2.4 GHz band. Using the latest version of the vendor driver, the 
production version connects with APs running WEP, WPA, or WPA2. The prototype 
can only handle WEP.

Obviously, I have some work to do. In the meantime, I will send you a tarball 
containing the vendor driver - privately so as not to spam the list.

Larry



