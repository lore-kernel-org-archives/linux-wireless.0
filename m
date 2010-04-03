Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:31168 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0DCQtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 12:49:50 -0400
Received: by qw-out-2122.google.com with SMTP id 8so979426qwh.37
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 09:49:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB7660A.3030900@lwfinger.net>
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
	 <4BB7660A.3030900@lwfinger.net>
Date: Sat, 3 Apr 2010 13:49:49 -0300
Message-ID: <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>
Subject: Re: RTL 8187b - naughty behaviour
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/3 Larry Finger <Larry.Finger@lwfinger.net>:
> On 04/03/2010 08:56 AM, Rogerio Luz Coelho wrote:
>> Hello, sorry for posting this in a DEV list, but I tried elsewhere and
>> people are generally kind, but unhelpfull. I am NOT a kernel
>> programer, so I will impose on the list´s good will somewhat ;)
>>
>> I have a Laptop witch uses the Realtek rtl8187b chip in a USB internal
>> conection.
>>
>> The chip WORKS in kernel Debian 2.6.32-3 , but is has an odd behavior:
>>
>> It works, connects and gives me ADSL speed as long as I am no more
>> than 3 meters from the router. Beyond that I get a "wrong password"
>> message in NetworkManager or Wicd (tried them both with similar
>> results)
>
> Your device may behaves very differently from mine. At 15 m from my AP,
> my rtl8187B device gets the following performance:
>
> finger@larrylap:~> tcpperf -c desktop
> Duration: 10 573usec
> Bytes sent: 4574208 (4467 kB 4 MB 0 GB)
> Bandwidth: 3659157 b/s (3659.16 kb/s 3.66 Mb/s)
> Close duration: 0s 62usec
>
> finger@larrylap:~> iwconfig wlan3
> wlan3     IEEE 802.11bg  ESSID:"lwfdjf_rad"
>          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:85:49:FA
>          Bit Rate=11 Mb/s   Tx-Power=20 dBm
>          Retry  long limit:7   RTS thr:off   Fragment thr:off
>          Power Management:off
>          Link Quality=69/70  Signal level=-41 dBm
>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> My device is a Level One WNC-0301USB and shows the following in dmesg:
>
> finger@larrylap:~> dmesg | grep rtl
> [129918.822942] rtl8187: inconsistency between id with OEM info!
> [129918.827838] phy1: hwaddr 00:11:6b:3e:c4:0a, RTL8187BvB(early) V0 +
> rtl8225z2, rfkill mask 2
> [129918.860071] rtl8187: Customer ID is 0x00
> [129918.860230] Registered led device: rtl8187-phy1::radio
> [129918.860333] Registered led device: rtl8187-phy1::tx
> [129918.860448] Registered led device: rtl8187-phy1::rx
> [129918.862425] rtl8187: wireless switch is on
> [129918.863143] usbcore: registered new interface driver rtl8187
>
> At my usual distance of 2 m from the AP, the transmit rate is about 13
> Mb/s and the reported signal level is -23 dBm, about what you report.
> Our chips are different, but that has not previously been a problem.
>
> Have you used this device with kernels older than 2.6.32? Fortunately,
> it does not need external firmware, thus it works with any Live CD. I
> have routinely tested all fairly recent kernels and have never seen this
> problem.
>
> Larry
>

I have a MS-Win7 instalation on this Laptop and it works 100% even at
longer distances than you report,even with walls in between.

Will do the tcpperf test as soon as I get home. There are other with
the same problem with my exact chip here in Brasil , that is because
one of our leading Laptop vendors uses this config.

Does it matter that the USB port used in this setting is a connected
to a USB HUB and then to the mother board?

More details and tests will come your way in a day or two ... will
reinstall Mandriva 2010 and do some tests with older kernels.

Thaks for the quick reply :)

Rogerio
