Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:41617 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaIXN2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 09:28:08 -0400
Message-ID: <5422C6E0.3080002@broadcom.com> (sfid-20140924_152812_560556_F2B784F4)
Date: Wed, 24 Sep 2014 15:28:00 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Seth Forshee <seth.forshee@canonical.com>,
	<brcm80211-dev-list@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <53FDACD1.8090805@msgid.tls.msk.ru> <53FDF8EB.4050905@broadcom.com> <54169D4F.2090607@broadcom.com> <541EEF17.7020806@msgid.tls.msk.ru> <542145B1.4030202@msgid.tls.msk.ru> <54216BF1.3060500@broadcom.com> <20140923134419.GA19016@ubuntu-hedt> <54217AA5.2060803@broadcom.com> <542182BE.2000606@msgid.tls.msk.ru> <542183A6.4070207@msgid.tls.msk.ru> <20140923143124.GC19016@ubuntu-hedt> <54219984.2080601@msgid.tls.msk.ru> <5421AF5C.6000106@broadcom.com> <5421B78E.4050908@msgid.tls.msk.ru>
In-Reply-To: <5421B78E.4050908@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/14 20:10, Michael Tokarev wrote:
> 23.09.2014 21:35, Arend van Spriel wrote:
>> On 09/23/14 18:02, Michael Tokarev wrote:
>
>>> Oh. Indeed.  While I enabled it, I recompiled only drivers/net/wireless,
>>> but not net/.  Rebuilt, another trace is here --
>>>
>>>    http://www.corpit.ru/mjt/tmp/brcmsmac-4313-trace-201409233.dat.gz
>>>
>>> Thanks,
>>
>> Just to confirm. With this trace you also get a stall during wget?
>
> Yes.  Initially it started d/loading but some time later the d/load speed
> reduced to 0.  It is possible to wait further, and after some more time
> it will receive some more bytes/kilobytes/packets and stall again.  Overall
> progress is nearing zero.

I looked at the log. I see download commence because the packets 
received of 1562 bytes length. So within one second I see little over 
200 packets so approx. 3Mbps which is not impressive but I don't know 
what can be expected. Indeed after that it stalls and we only seem to 
receive small packets of 179 bytes that seem to end up in 
cfg80211_mgmt_rx. It could be that the hardware is somehow bogged and 
can not receive at higher modulations as management frames are 
transmitted at lower rates. The hardware will drop packets that are 
having FCS (aka. checksum) errors. The brcmsmac is missing some code to 
read fcs error count from hardware, but I will get back to you with a 
patch that we can use to confirm this.

Regards,
Arend

> Thanks,
>
> /mjt

