Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47203 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077Ab1I3Siw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 14:38:52 -0400
Received: from [10.0.0.100] (cpc2-livi5-2-0-cust271.sgyl.cable.virginmedia.com [62.31.13.16])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 119EA94050D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 14:38:50 -0400 (EDT)
Message-ID: <4E860CDB.9040207@emobix.co.uk> (sfid-20110930_203855_600890_A202A0CF)
Date: Fri, 30 Sep 2011 19:39:23 +0100
From: Ian Jeffray <ian@emobix.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <4E81F8C8.4010909@lwfinger.net>
In-Reply-To: <4E81F8C8.4010909@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/09/2011 17:24, Larry Finger wrote:
> On 09/27/2011 10:36 AM, Ian Jeffray wrote:
>> Dear all,
>>
>> I'm attempting to get some sense from a Realtek 8191S device on
>> ARM linux.
<SNIP>
>> My host is a TI DaVinci DM8168 (OMAP3+toys). The USB host is not
>> fantastic, but has been thrashed heavily with other devices and seems
>> to be reliable in those cases.
<SNIP>
>
> I have not tried this chip on an ARM host as I have no hardware. My
> testing has been with X86 and PPC - thus I know the endianess is OK, but
> that is the extent of my platform testing.
>
> The first thing I would try is wireshark on another host to verify that
> packets are actually getting on the air.

Ok, so I've spent more more days working on this.  The driver appears
to be fine on an ARM9 S3X board.   I've contacted the TI support
team about the USB host and applied some patches from them which have
slightly improved the situation, but it's still horrible - I'm actually
getting "reliable" scans but only a pathetic 1Mbit or less of data
throughput.

I've also tried this driver (and the realtek upstream version) with
a Blackfin BF527 device, which has roughly the same 'musb' Inventra
USB host controller... and I see exactly the same problem there!
The firmware appears to load fine, but scans produce no results.

I'm not really sure about your comment about wireshark because,
as far as I understand, a 'iwlist wlan0 scan' command doesn't cause
any traffic which would be wireshark capturable on another host...
am I misunderstanding something?

So it appears as though there may be some general problem with this
driver and an 'musb' host controller.  Very strange.

My next course of attack is to try comparing outputs of 'usbmon'
dumps between hosts which work and hosts which don't... but I can't
make a great deal of sense looking at them really.

I'd greatly appreciate any more advice you may be able to give.

Many thanks,

Ian.

-- 
Ian Jeffray    ian@emobix.co.uk    Tel: +44 (0) 141 221 8449
emobix Limited, Suite 5/5, 29 St Vincent Place, Glasgow, G1 2DT
Registered in Scotland; Company No. 371276 - VAT No. 983 4833 78
