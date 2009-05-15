Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:46069 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZEOUmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 16:42:09 -0400
Received: by mu-out-0910.google.com with SMTP id i2so841811mue.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 13:42:07 -0700 (PDT)
Message-ID: <4A0DD39D.6070001@gmail.com>
Date: Fri, 15 May 2009 21:42:05 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Howard Chu <hyc@highlandsun.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs and WPA-EAP?
References: <4A065AFD.8000604@highlandsun.com> <4A0D3A83.4040809@highlandsun.com> <4A0DB0A5.9010301@gmail.com> <4A0DC4A9.8050505@highlandsun.com>
In-Reply-To: <4A0DC4A9.8050505@highlandsun.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Howard Chu wrote:
> Dave wrote:
>> Howard Chu wrote:
>>> Sigh, nothing's ever easy. After abandoning the CTX714 I mentioned in an
>>> earlier email, I find that the Thinkpad T42 I got from eBay came with some
>>> kind of Orinoco 802.11B mini-PCI card installed. Ubuntu Jaunty's 2.6.28 kernel
>>> loads up the orinoco_cs driver for this card. It appears that this driver only
>>> supports WPA-PSK, and I use WPA-EAP on my home wlan. Has anyone done any work
>>> on supporting WPA-EAP for this card?
>>
>> Note that the card only supports TKIP, so it won't work if the AP
>> doesn't offer it.
> 
> Thanks, that may have been the issue I was facing at first. My AP was 
> configured for CCMP. I've now set it to TKIP and seem to be getting further. 
> But now when I start wpa_supplicant I see a stream of "Information frame lost" 
> messages in dmesg that pretty much never end (interspersed once in a while 
> with ratelimit messages). I wonder if this laptop's mini-PCI slot is hosed or 
> something.

That message is printed in response to a firmware interrupt. It
indicates "an unsolicited Frame Structure cannot be generated... because
there is not enough Frame Structure buffer space available".

I suspect that the beacons/probe responses/scan results are either too
large/too frequent for the card to handle, or the firmware can't
decipher them.

Before enabling wpa_supplicant, can you try scan for your AP (as root):

iwlist ethX scan essid YYYYY

I'm interested in what it returns, and whether dmesg reports 'Ext scan
results too large' or something similar.


Dave.
