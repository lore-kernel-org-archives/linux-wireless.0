Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49180 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZEPJEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 05:04:13 -0400
Received: by ewy24 with SMTP id 24so2991234ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 02:04:13 -0700 (PDT)
Message-ID: <4A0671F7.4010908@gmail.com>
Date: Sun, 10 May 2009 07:19:35 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Howard Chu <hyc@highlandsun.com>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs and WPA-EAP?
References: <4A065AFD.8000604@highlandsun.com>	 <4A0D3A83.4040809@highlandsun.com> <4A0DB0A5.9010301@gmail.com>	 <4A0DC4A9.8050505@highlandsun.com>  <4A0DD39D.6070001@gmail.com> <1242429170.10933.30.camel@localhost.localdomain> <4A0E0579.70507@highlandsun.com>
In-Reply-To: <4A0E0579.70507@highlandsun.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Howard Chu wrote:
> Dan Williams wrote:
>> On Fri, 2009-05-15 at 21:42 +0100, Dave wrote:
>>> Before enabling wpa_supplicant, can you try scan for your AP (as root):
>>>
>>> iwlist ethX scan essid YYYYY
> 
> That works fine. In fact, just "iwlist scan" returns the same result - only 
> the info for my AP is returned. (There are at least 6 APs visible from an 
> another laptop sitting nearby.)

The fact we can parse the scan result from your AP is good. It indicates
the AP doesn't transmit a large list of IEs which trip the card up. The
fact we can't see the other APs... I'll assume that's your dodgy antenna :)

>>> I'm interested in what it returns, and whether dmesg reports 'Ext scan
>>> results too large' or something similar.
> 
> No, it just continues with the stream of "frame lost" messages:
> 
> eth2: Information frame lost. (10 times, followed by 1
> __ratelimit: 2 callbacks suppressed  (then 10 more frame lost messages, and so on)

I had thought you didn't get the frame lost messages until you tried to
authenticate. If you always receive them, then it might just be due to
an AP you're not interested in (and you might be able to ignore these
warnings).

A few questions:

1. How far is wpa_supplicant getting in authentication? Use -dd
2. If it authenticates, did you check whether you could dhcp on eth2?

It would also be nice to identify the source of your frame lost
messages. Any chance you could have a look at the wireless traffic with
another card in monitor mode?


Regards,

Dave.
