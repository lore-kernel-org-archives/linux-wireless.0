Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35743 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1CKUTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:19:31 -0500
Received: by vxi39 with SMTP id 39so2920467vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 12:19:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimfy87qCY7m-5YzBpqLTQKakf1zLMxCGNvotjO3@mail.gmail.com>
References: <AANLkTi=Bz5aegRoTL7AJvimOm4HTY7xpkHoowWPxZW4+@mail.gmail.com>
	<AANLkTimfy87qCY7m-5YzBpqLTQKakf1zLMxCGNvotjO3@mail.gmail.com>
Date: Fri, 11 Mar 2011 21:19:29 +0100
Message-ID: <AANLkTimES4LLH9MT459RGc+2XUZ2csOLRnxWd4dws5mQ@mail.gmail.com>
Subject: Re: rt2800usb (rt2x00) in ad-hoc mode stalls when transferring large
 amount of data
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 11, 2011 at 9:08 PM, Luis Correia <luis.f.correia@gmail.com> wrote:
> Hi
>
> On Fri, Mar 11, 2011 at 20:04, Juan Carlos Garza
> <juancarlosgarza@gmail.com> wrote:
>> Hello
>>
>> I have a Ralink 3071 usb device (Bus 002 Device 003: ID 07b8:3071
>> D-Link Corp. 802.11n/b/g Mini Wireless LAN USB2.0 Adapter).
>> I am using the mac80211 driver by compiling the compat-wireless
>> tarball from yesterday (10 March). I cross compile it with the 2.6.24
>> kernel in a Montavista distribution (and also with 2.6.27 in Fedora)
>>
>> It works pretty good in AP mode using HostAPD and DCHP and I get
>> relative good transfer rates (up to 3.5 MBytes per second).
>>
>> My problems are with Ad-Hoc connections. I can configure the Ad-Hoc
>> connection, for example:
>>
>> iwconfig wlan0 mode ad-hoc
>> iwconfig wlan0 essid my_ad_hoc_nt
>> iwconfig wlan0 key 1122334455
>> ifconfig wlan0 192.168.111.44 up
>>
>> It works and I connect to it on the other end (a windows machine with
>> a compatible static ip address), however, it only works for doing
>> small data transfer rate things like browsing through the directories
>> of a shared folder or retrieving web pages from a web server. When I
>> try to do something like transferring a 500 MByte file, it starts
>> transferring, reaches a peak and then it drops to 0 again. After that,
>> the file is no longer transferred and I cannot do anything else (can't
>> ping).
>>
>> Is this a known issue? Any ideas?
>>
>> Juan Carlos
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> keep in mind that current (and by design) ad-hoc connections max out at 11Mb.

Thanks for the comment,
Mhh, I've been benchmarking some other chipsets in ad-hoc mode (like
the rtl8188cus) and they do not present these problems (only a slow
transfer rate).

>
> there may be some buffer bottleneck involved.
>

I tried changing the MTU and other parameters, and nothing...

> but I'm not a very good expert on this subject.
>
>
> Luis Correia
>



-- 
________________________________
M.Sc. Juan Carlos Garza Fernández
Chistophstr. 14
70178 Stuttgart, Deutschland
+49 711 4080769
+49 176 21947676
juancarlosgarza@gmail.com
________________________________
