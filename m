Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:39312 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYGBRIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 13:08:06 -0400
Received: from zoltar.telenet-ops.be (zoltar.telenet-ops.be [195.130.132.57])
	by yorgi.telenet-ops.be (Postfix) with ESMTP id ECAF2589062
	for <linux-wireless@vger.kernel.org>; Wed,  2 Jul 2008 19:08:03 +0200 (CEST)
Received: from hoboi3bl3.telenet-ops.be (hoboi3bl3.telenet-ops.be [195.130.137.86])
	by zoltar.telenet-ops.be (Postfix) with ESMTP id 9328540F2
	for <linux-wireless@vger.kernel.org>; Wed,  2 Jul 2008 19:07:32 +0200 (CEST)
Received: from edna.telenet-ops.be (edna.telenet-ops.be [195.130.132.58])
	by hoboi3bl3.telenet-ops.be (8.13.1/8.13.1) with ESMTP id m62H7Wgu025678
	for <linux-wireless@vger.kernel.org>; Wed, 2 Jul 2008 19:07:32 +0200
Received: from [192.168.2.139] (d54C6CD29.access.telenet.be [84.198.205.41])
	by edna.telenet-ops.be (Postfix) with ESMTP id 5EDA4E4010
	for <linux-wireless@vger.kernel.org>; Wed,  2 Jul 2008 19:07:32 +0200 (CEST)
Message-ID: <486BB5D4.4010701@yahoo.co.uk> (sfid-20080702_190811_023226_09113B6F)
Date: Wed, 02 Jul 2008 19:07:32 +0200
From: Ivo Couckuyt <iv0co@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb adapter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sent this a while ago, but might be filtered due to attachment (removed 
now):

i tried the following firmwares:
2.4.4.0.arm  2.4.6.0.arm
2.5.11.0.arm 2.5.6.0.arm 2.5.2.0.arm 2.7.0.0.arm
All give the same dmesg output, (HC died; cleaning up)
except 2.5.8.0.arm which gives something else, probably not worth much, 
but nevertheless see attachment

In the very beginning I used ndiswrapper without any problem (still 
works now), but at the moment i'm using the old islsm driver together
with kernel 2.6.9 and firmware 2.5.6.0 (only one that works), which 
doesn't seem to be on the site you mentioned
md5sum:
6ff238179cf9618aac2b5d7a34e41450  2.5.6.0.arm (is included for what it 
is worth)
So i've been stuck at kernel 2.6.9 for some time now as islsm doesn't 
compile with newer kernels :-) p54usb should be a relatively straight 
port from islsm yes ? except for the control rate algorithm and some 
cleaning up i guess.

ps: thanks for the effort.
ps2: firmware 2.5.7.0 isn't on site too:  
09f9da7ea757173c9de1a0322a1f9782  2.7.0.0.arm

kind regards,
Ivo Couckuyt

Chr wrote:
> On Sunday 08 June 2008 13:54:14 Johannes Berg wrote:
>  
>> On Fri, 2008-06-06 at 23:06 +0200, Ivo Couckuyt wrote:
>>    
>>> Sorry for the late reply, i just thought i install kernel 2.6.25 r4 and
>>> try again.
>>>
>>> It is somewhat better and worse, when modprobing p54usb i got a small
>>> hang/hickup accompanied with the following error in dmesg
>>> ehci_hcd 0000:00:02.2: HC died; cleaning up
>>> [...]
>>>       
>> Sorry, no idea. Christian?
>>     
> Not yet... but card is on the way, so maybe in the future. :)
>
> I googled for "HC died; cleaning up" and yes, there "are" other people 
> with the same issue... But noone had a solutions other than use 
> ndiswrapper.
>
> So, i took a look at the driver... it ships with a really old firmware 
> 2.4.6.0 So, I know that there are atleast some (mini)PCI Cards that 
> have big problems with anything newer than 2.4.x.y, maybe there are 
> broken USB-Parts too...
>
> Ivo, can you please try the older firmware? You can find a copy @
> (http://daemonizer.de/prism54/prism54-fw/ scroll down to USB).
>
> If this doesn't work? could you please about ndiswrapper?
>
> Regards,
>     Christian
>
>   

------------------------------------------------------------------------

usb 1-1: new high speed USB device using ehci_hcd and address 5
usb 1-1: configuration #1 chosen from 1 choice
p54: LM86 firmware
p54: FW rev 2.5.8.0 - Softmac protocol 3.0
prism54usb: probe of 1-1:1.0 failed with error -110
usbcore: registered new interface driver prism54usb

