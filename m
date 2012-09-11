Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:39142 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2IKXni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 19:43:38 -0400
Received: by yhnn12 with SMTP id n12so278941yhn.10
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 16:43:38 -0700 (PDT)
Message-ID: <504FCD39.80705@gmail.com> (sfid-20120912_014342_174587_A6EC6576)
Date: Tue, 11 Sep 2012 19:46:01 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, scchen@qca.qualcomm.com,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	marco@tampabay.rr.com, janusz.dziedzic@gmail.com
Subject: Re: [PATCH] carl9170: fix spurious transmissions in sniffer mode
References: <201209112318.35334.chunkeey@googlemail.com> <504FB53C.6050106@gmail.com> <201209120126.31312.chunkeey@googlemail.com>
In-Reply-To: <201209120126.31312.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2012 07:26 PM, Christian Lamparter wrote:
> On Wednesday 12 September 2012 00:03:40 Richard Farina wrote:
>> On 09/11/2012 05:18 PM, Christian Lamparter wrote:
>>> Several people have complained about an unusual
>>> and undocumented feature of the AR9170 hardware:
>>>
>>> In siffer mode, the hardware generates spurious
>>> ACK frames for every received frame... even
>>> broadcasts.
>>>
>>> The reason for this malfunction is unknown:
>>> <http://marc.info/?l=linux-wireless&m=134517238506033>
>>> But there's a workaround: Instead of the special
>>> sniffer mode, the hardware will be put into
>>> station mode and all rx filters are disabled.
>> I am by no means an expert here but wouldn't it be better to disable
>> ACK? Or is this not really an option?
> Oh AFAIK there's some nifty software which emulates
> some sort of accesspoint by (ab-)using monitor mode
> and injection. And in this case having a device which
> ACKs any frame destined for the semi-fake ap might be
> a "good thing".
Are you referencing airbase-ng here?  Airbase-ng assumes the hardware
does not ack in monitor mode and therefore does it itself.  Mind you,
I'm not saying it wouldn't be nice to have the hardware ack (VASTLY
improved response time for one) but a monitor mode vif is assumed to not
transmit anything at all, unless we specifically inject it.

An ack on/off (default off) would be awesome, but baring that the only
sane choice is off.

Thanks,
Zero
> 
>> Did you test to see if this actually does receive the same number of
>> packets as "special sniffer mode"? If so, that really should be in the
>> commit message imho.
> One problem is that you can't really take two devices,
> attach them to separate machines (one machine is patched,
> the other isn't) and do a "head-to-head" comparison.
> The device on the machine without the "fix" will happily
> generate spurious messages which will be picked up by
> everyone else (including the other machine). However,
> the device on the patched machine does not generate
> bogus ACKs, so the device without the patch does not
> notice anything unusual... (Yep, this is very confusing.)
> 
> Note: The AR9170 MAC hardware does not feed generated
> control frames like ACK,RTS/CTS,BACKs, etc... back to
> the driver. Only those from other peers are picked up!
> 
>> (I know you tested it, but since you didn't say it
>> the commit message reads like you didn't).
> You are right, but what I need are "Tested-by" tags.
> It's sort of pointless if I just add a "works-for-me",
> as I do very little with monitor mode.
> 
> Regards,
> 	Chr
> 

