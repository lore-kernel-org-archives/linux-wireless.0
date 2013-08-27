Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46547 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3H0VTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 17:19:08 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so5735115obc.34
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 14:19:05 -0700 (PDT)
Message-ID: <521D17C7.2070105@lwfinger.net> (sfid-20130827_231912_608156_0AAC714B)
Date: Tue, 27 Aug 2013 16:19:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problems associating to AP with rtl8192cu driver
References: <5217B01D.4000609@ilande.co.uk> <521B9A74.60603@ilande.co.uk> <521CD266.5010801@lwfinger.net> <521D0EA2.2070105@ilande.co.uk>
In-Reply-To: <521D0EA2.2070105@ilande.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2013 03:40 PM, Mark Cave-Ayland wrote:
> On 27/08/13 17:23, Larry Finger wrote:
>
> Hi Larry,
>
>> I just retested and this message was posted from what lsusb says is a
>> "Bus 001 Device 007: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un
>> 802.11n Wireless Adapter [Realtek RTL8188CUS]" connected to an AP using
>> WPA(1).
>
> I'm actually testing a dongle from a Raspberry Pi that I've been experiencing
> issues with under load with the Realtek-written 8192cu driver. My understanding
> is that it is an OEM RTL8188CUS adapter from here:
> http://thepihut.com/products/usb-wifi-adapter-for-the-raspberry-pi.
>
>> My kernel is 3.11.0-rc6-wl+ from the wireless-testing tree. I have built
>> 3.11-rc7-wl+, but not yet rebooted. Before I boot into that kernel, I
>> will build and test the mainline kernel, but it should not make a
>> difference as the only code differences between wireless-testing and the
>> mainline trees deal with cleaning up some sparse endian issues.
>>
>> What is the make/model of the AP that fails? Is its firmware the latest
>> available? Just to confirm, you are running WPA1 encryption.
>
> It seems to be all of the ones I'm testing :/  Currently that's an old Netgear
> DG834G, a desktop PC running Debian Wheezy/hostapd using a zd1211rw-based WiFi
> dongle, and an O2 Wireless box (rebadged Thomson). The problem seems to be that
> association is difficult, and even when it does associate then the AP appears to
> drop out every minute or so.
>
> The rtl8192cu firmware is that supplied with Debian Wheezy, while the AP
> firmware should also be reasonably up-to-date. Access to all APs is fine using
> an Android phone, the zd1211rw desktop PC and a laptop with an iwlwifi driver.
> The APs are set to advertise both WPA and WPA2 encryption.

The accepted firmware has an md5sum of 943e9b714a926e630b8152d7aad91d2e for 
/lib/firmware/rtlwifi/rtl8192cufw.bin.

>> Do you still have the wireshark file from the failed attempt? If so,
>> could you filter out the traffic from APs and stations other than the
>> units trying to make the connection, and send me (privately) the trimmed
>> file?
>
> Yes - I'm not sure if it's exactly that attempt, but I do have a representative
> wireshark trace of this which I will send to you privately.
>
>> For completeness, I have tested WPA2 with Netgear WNDR3300 and WNDR3400
>> running standard firmware, WPA1 with a Linksys WRT54GL running openWRT
>> Kamikaze fw, and WEP with a Linksys WRT54G V5 running standard fw.
>
> Okay. So perhaps there is something slightly different about this particular
> WiFi dongle...

Neither rtl8192cu nor 8192cu (the vendor driver) work with the 2x2 configuration 
such as found in a TP-Link TL-WN8200ND V1.0. That was reported to Realtek, but I 
have had no response from them.

Larry


