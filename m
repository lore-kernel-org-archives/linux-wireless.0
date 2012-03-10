Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34634 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2CJRCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 12:02:45 -0500
Received: by dajr28 with SMTP id r28so2895372daj.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2012 09:02:45 -0800 (PST)
Message-ID: <4F5B8932.4010101@gmail.com> (sfid-20120310_180316_913684_64AF6DF9)
Date: Sat, 10 Mar 2012 09:02:42 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: Oskar Stenman <oskar@cetex.se>, linux-wireless@vger.kernel.org
Subject: Re: ath9k timeouts with the current Mainline
References: <4F12F5DD.3030904@gmail.com> <4F5B27DB.8090508@cetex.se> <4F5B61A7.6010904@01019freenet.de>
In-Reply-To: <4F5B61A7.6010904@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/2012 06:13 AM, Andreas Hartmann wrote:
> Oskar Stenman wrote:
>> I'm having a similar or the same problem, it's been nagging me for at
>> least 1.5years.
>>
>> If I'm able to connect I get frequent dropouts from any wireless network
>> I'm connected to. It gets sluggish and after a little while disconnects,
>> and once it has disconnected it just keeps reconnecting and failing.
>> sometimes a reboot helps, but most of the time it wont help anymore than
>> a couple of seconds to a minute. It's also impossible to connect to my
>> wireless hotspot on my Xperia Mini Pro and it seems ad-hoc networks are
>> also impossible.
>>
>> I'm running ubuntu 11.10 with latest patches applied as of today. Since
>> i've not seen anything being solved during this time i doubt anyone has
>> been trying to, or has been able to solve the problem recently.
>
> I'm running exactly the same chip (according lspci) without any problem.
> But I'm using slightly different environment:
>
> 1. 64 bit
> 2. kernel 3.1 (some time ago, I run 3.0, too, but cannot remember
>     having any problems related ar9285).
> 3. no network manager - just plain wpa_supplicant.
> 4. wpa_supplicant 0.7.3
>
>
> If you like to, you could just check, if the problem is network manager
> related. Try to stop it and run wpa_supplicant manually as root like
> this (ensure, that no other wpa_supplicant process is running at the
> same time):
>
> wpa_supplicant -t -c /etc/wpa_supplicant/wpa_supplicant.conf -Dnl80211
> -i wlan0
>
> -c is the config file. -i is the device name.
>
> sample config file for WPA2 PSK would be:
>
> network={
>          ssid="your network name"
>          # scan_ssid=1
>          key_mgmt=WPA-PSK
>          psk="your psk"
>          proto=WPA2
> }
>
> If you see a line like this:
> WPA: Key negotiation completed with xx:xx:xx:xx:xx:xx [PTK=CCMP GTK=CCMP]
> you can go to another terminal and start dhclient or dhcpcd like this:
>
> dhcpcd wlan0 (or whatever your device name is)
>
>
> If this is all running fine, you most probably face a network manager
> problem.
>
>
> Hope that helps,
> regards,
> Andreas
>


The timeouts I have not see just yet; only the RX DMA thing which I am 
monitoring and trying to recreate, so I can _possibly_ bisect. as for 
the timeout(s) I have not see this with the current, there is a bug 
report on this(2.6.37 or so) but I think the bug was closed due to no 
participation or something.

also make sure you have power save off(iwconfig wlan* power off) because 
from what I remember powersave on is what triggers the timeout(s)


Justin P. Mattock
