Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alt-proxy13.mail.unifiedlayer.com ([67.222.34.81]:38288 "HELO
	alt-proxy13.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750713AbaAPFc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 00:32:27 -0500
Message-ID: <52D76D56.6060906@trillion01.com> (sfid-20140116_063231_321379_6B6C77DA)
Date: Thu, 16 Jan 2014 00:25:42 -0500
From: Olivier Langlois <olivier@trillion01.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
CC: daniel@zonque.org
Subject: Re: [ISSUE] rtl8192ce appears to interfere with ALSA playback
References: <1389767820.2436.45.camel@Wailaba2> <52D6BEEF.5050705@lwfinger.net>
In-Reply-To: <52D6BEEF.5050705@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2014 12:01 PM, Larry Finger wrote:
> On 01/15/2014 12:37 AM, Olivier Langlois wrote:
>> How to reproduce:
>>
>> 1. Enable Wifi while not connecting to any AP.
>> 2. lano1106@hpmini ~/Music $ aplay -c1 sine.wav
>> underrun!!! (at least 1856093977.967 ms long)
>
> Olivier,
>
> I am certain that rtl8192ce does not disable interrupts for 2 sec, but 
> I need some more info from you.

Larry. That is a fact. I agree with you that rtl8192ce does certainly 
not do that.

>
> What is your CPU situation? I suspect x86_64, but please confirm.How 
> many CPUs? What is the maximum CPU speed?
>

I'm running 32-bits on that machine.

lano1106@hpmini ~ $ cat /proc/cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 28
model name : Intel(R) Atom(TM) CPU N455 @ 1.66GHz
stepping : 10
microcode : 0x107
cpu MHz : 1666.000
cache size : 512 KB
...

this processor has 2 cores.

It is not very powerful by today standard but on the other side, with 
running top, I can tell that the system is pretty much idle when I 
experience the issue. cpu usage is certainly not higher than 10%.

> What distro?

ArchLinux

>
> How do you control the wifi? Is it NetworkManager? This is important 
> because the device driver does not initiate any scans on its own - 
> scans are initiated and controlled by upstream.

I am using a collection of shell scripts called 'netcfg'. I suppose that 
what you really want to know is this:

lano1106@hpmini ~ $ systemctl status net-auto-wireless
net-auto-wireless.service - Provides automatic netcfg wireless connection
Loaded: loaded (/usr/lib/systemd/system/net-auto-wireless.service; enabled)
Active: active (running) since Wed 2014-01-15 21:47:16 EST; 2h 20min ago
Process: 237 ExecStart=/usr/bin/netcfg-wpa_actiond $WIRELESS_INTERFACE 
(code=exited, status=0/SUCCESS)
CGroup: /system.slice/net-auto-wireless.service
├─357 wpa_supplicant -B -P /run/wpa_supplicant_wlan0.pid -i wlan0 -D 
nl80211,wext -c/run/network/wpa.wlan0/wpa.conf -W
├─359 /usr/sbin/wpa_actiond -p /run/wpa_supplicant -i wlan0 -P 
/run/wpa_actiond_wlan0.pid -a /usr/bin/netcfg-wpa_actiond-action
└─423 dhcpcd -qL -t 30 -K wlan0

and this:

lano1106@hpmini ~ $ pacman -Qs wpa
local/wpa_actiond 1.4-2
Daemon that connects to wpa_supplicant and handles connect and 
disconnect events
local/wpa_supplicant 2.0-4
A utility providing key negotiation for WPA wireless networks


>
> Please provide a URL for the test file sine.wav. If it is part of your 
> distro, then put it in a public repository, or E-mail it to me privately.
>
>
I have made it available here:

http://www.trillion01.com/sine.wav

but really, there is nothing special to it. It could be any wav file or 
mp3 file. What is nice with reproducing the problem with aplay, it is 
that it is so simple and talk direcly to ALSA, it eliminates a lot 
potential causes.

thank you very much for assisting me!
Olivier

