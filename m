Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:4652 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYIFSHa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:07:30 -0400
Received: from [172.17.0.188] ([61.8.118.66])
 by Opus1.COM (PMDF V6.2-X27 #9830) with ESMTPSA id
 <01MZ8MAJRY808X4NGL@Opus1.COM> for linux-wireless@vger.kernel.org; Sat,
 06 Sep 2008 11:07:28 -0700 (MST)
Date: Sat, 06 Sep 2008 11:07:15 -0700
From: gavron@wetwork.net
Subject: Re: Speed enhancement for BCM4306/2
In-reply-to: <48C2A1F5.6020607@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Message-id: <48C2C6D3.3030601@wetwork.net> (sfid-20080906_200757_261272_063C090C)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net>
 <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net>
 <48C2A1F5.6020607@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger wrote:
> gavron@wetwork.net wrote:
>>
>>
>>
>> Ok, here's try #2.
>> E
>> /home/2.6.27/rc4-wl/drivers/net/wireless/b43legacy# diff -uN 
>> /tmp/phy.c phy.c
>> --- /tmp/phy.c    2008-09-05 21:56:20.000000000 -0700
>> +++ phy.c    2008-09-05 22:03:28.000000000 -0700
>
> For kernel patches, you need to be working in the base directory of 
> the kernel sources. For your tree, that would be in 
> /home/2.6.27/rc4-wl. That way the patches will apply with the 
> effective command of 'patch -p1 < patch_file'. For kernel patches, I 
> use quilt so that patches are easy to apply and remove.
>
>> @@ -1010,7 +1010,7 @@
>>         b43legacy_phy_initb5(dev);
>>     else
>>         b43legacy_phy_initb6(dev);
>> -    if (phy->rev >= 2 || phy->gmode)
>> +    if (phy->rev >= 2 && phy->gmode)
>>         b43legacy_phy_inita(dev);
>>
>>     if (phy->rev >= 2) {
>
> The above hunk is correct.
>
>> @@ -1027,15 +1027,17 @@
>>     }
>>     if (phy->rev >= 2 || phy->gmode) {
>
> This does not match step 7 of the specs. It was not changed recently, 
> but the code did not match what was on the web site. No, I don't know 
> why.
>
>>         tmp = b43legacy_phy_read(dev, 0x0400) & 0xFF;
>> -        if (tmp == 3 || tmp == 5) {
>> +        if (tmp == 4 || tmp == 5) {
>>             b43legacy_phy_write(dev, 0x04C2, 0x1816);
>> -            b43legacy_phy_write(dev, 0x04C3, 0x8006);
>> +            b43legacy_phy_write(dev, 0x04C3, 0x8606);
>>             if (tmp == 5)
>>                 b43legacy_phy_write(dev, 0x04CC,
>>                             (b43legacy_phy_read(dev,
>>                              0x04CC) & 0x00FF) |
>>                              0x1F00);
>>         }
>> +    }
>> +    if (phy->rev >= 2)
>>         b43legacy_phy_write(dev, 0x047E, 0x0078);
>>     }
>>     if (phy->radio_rev == 8) {
>
> This hunk does not match the specs. In addition, I think there are too 
> many right-hand curly braces for it to compile.
>
> Larry
>
I've been sitting on a git clone that refuses to proceed faster than 6 
KiB/s (it's a problem here in Melbourne).  Should it complete I will 
correct these issues.   I did see several other ways in which the code 
does not match the specs.  Should that be documented in the code or 
should the code be conformed to the specs even if that ends up breaking 
the driver?

Without getting into specifics it's cases where the specs will say "When 
something=value" but the code says "when variable >=(value -1)".

Ehud
