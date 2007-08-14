Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:42538 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbXHNIMa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 04:12:30 -0400
Message-ID: <46C1638C.7070704@hhs.nl>
Date: Tue, 14 Aug 2007 10:10:52 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <46C0474B.2000206@hhs.nl> <200708131314.59141.flamingice@sourmilk.net> <200708140025.56708.chunkeey@web.de>
In-Reply-To: <200708140025.56708.chunkeey@web.de>
Content-Type: multipart/mixed;
 boundary="------------050203080601020504020903"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050203080601020504020903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Chr wrote:
> On Monday, 13. August 2007, Michael Wu wrote:
>> On Monday 13 August 2007 04:58, Hans de Goede wrote:
>>> Okay, I still had copies of various git revisions of prism54common.c and .h
>>> (aka the culprits) on my laptop. I've run some tests again to make sure I
>>> had the right revisions in mind for the breakage (which I had). I've
>>> attached 2 patches:
>>> diff: with this reversed my speed increases 10x and more importantly when
>>> fully loading the link (using scp from a local non wireless ethernet
>>> machine) it no longer looses the connection in a couple of seconds
>>>
>> Hm, I guess either these changes were wrong or exposed some bugs. Can you 
>> check what sort of tx rates are being reported in iwconfig before and after 
>> that change?
>>
>>> diff2, when I do not reverse this one, it still associates, but it no
>>> longer receives / or transmits packages. (no dhcp, no ping when manually
>>> assigning IP's, etc).
>>>
>> Not sure.. this patch generally helped things on my hardware. Christian 
>> Lamparter might have an idea.
>>
> 
> Well not really, It is "fast" as usual here: 
>  
> scp user@p54pci-pc:/usr/src/dummyzero ./
> dummyzero                                                                                                               100%  236MB   1.8MB/s   02:09
> 
> iperf:
> [  5] local 192.168.1.247 port 5001 connected with 192.168.1.1 port 56253
> [  5]  0.0-240.7 sec    597 MBytes  20.8 Mbits/sec
> 
> 
> => need more data...
>  
> 1. Which p54 firmware do you use? (It "must" be 2.7.0.0 for pci/cardbus)
2.4.12.0, extracted from the window driver for my card, any later version will 
cause the driver to fail to load with: "Error cannot read eeprom!"

> 2. What's your "average" txrate and Link Signal Level / Link Quality with and without the patches.
>    (see iwconfig)
See attached logs

> 3. what brand/type of AP do you have? 
A davolink DV-201AMR its an embedded Linux device using the BCM6348 chipset,

> -> what does the beacon frame look like? (or: if you don't have a
> wlan sniffer / monitor, just run: iwlist wlanX scan )
See logs

> 4. Can you recompile the mac80211 layer with debug options and look for
> something like ethX: STA XX:YY:ZZ:AA:BB:CC Average rate: VVV ... in your syslogs?

See logs

> 5. are they any suspicious dmesg outputs when the "network" stops/dies?
> 

Nope.


I've attached a tarbal with logs the FC7test logs are the logs from the Fedora 
7 test kernel which I normally use, as that works well.

The rest is based on a F-8 test kernel which contains a wireless-dev snapshot 
from 26 jul 2007. The dates are dates of git checkouts from prism54common.{c,h}
the -common one has the speed changes to prism54common.h reversed, because 
otherwise connectivity is lost as explained.

I hope this helps.

Regards,

Hans

--------------050203080601020504020903
Content-Type: application/x-gzip;
 name="logs.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="logs.tar.gz"

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
EAgEAoFAIBAIxP+IfwDEGeDrAHgAAA==
--------------050203080601020504020903--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
