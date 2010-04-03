Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40605 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab0DCQAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 12:00:17 -0400
Received: by gwb19 with SMTP id 19so588226gwb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Apr 2010 09:00:16 -0700 (PDT)
Message-ID: <4BB7660A.3030900@lwfinger.net>
Date: Sat, 03 Apr 2010 11:00:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8187b - naughty behaviour
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
In-Reply-To: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2010 08:56 AM, Rogerio Luz Coelho wrote:
> Hello, sorry for posting this in a DEV list, but I tried elsewhere and
> people are generally kind, but unhelpfull. I am NOT a kernel
> programer, so I will impose on the list´s good will somewhat ;)
> 
> I have a Laptop witch uses the Realtek rtl8187b chip in a USB internal
> conection.
> 
> The chip WORKS in kernel Debian 2.6.32-3 , but is has an odd behavior:
> 
> It works, connects and gives me ADSL speed as long as I am no more
> than 3 meters from the router. Beyond that I get a "wrong password"
> message in NetworkManager or Wicd (tried them both with similar
> results)

Your device may behaves very differently from mine. At 15 m from my AP,
my rtl8187B device gets the following performance:

finger@larrylap:~> tcpperf -c desktop
Duration: 10 573usec
Bytes sent: 4574208 (4467 kB 4 MB 0 GB)
Bandwidth: 3659157 b/s (3659.16 kb/s 3.66 Mb/s)
Close duration: 0s 62usec

finger@larrylap:~> iwconfig wlan3
wlan3     IEEE 802.11bg  ESSID:"lwfdjf_rad"
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:85:49:FA
          Bit Rate=11 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=69/70  Signal level=-41 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

My device is a Level One WNC-0301USB and shows the following in dmesg:

finger@larrylap:~> dmesg | grep rtl
[129918.822942] rtl8187: inconsistency between id with OEM info!
[129918.827838] phy1: hwaddr 00:11:6b:3e:c4:0a, RTL8187BvB(early) V0 +
rtl8225z2, rfkill mask 2
[129918.860071] rtl8187: Customer ID is 0x00
[129918.860230] Registered led device: rtl8187-phy1::radio
[129918.860333] Registered led device: rtl8187-phy1::tx
[129918.860448] Registered led device: rtl8187-phy1::rx
[129918.862425] rtl8187: wireless switch is on
[129918.863143] usbcore: registered new interface driver rtl8187

At my usual distance of 2 m from the AP, the transmit rate is about 13
Mb/s and the reported signal level is -23 dBm, about what you report.
Our chips are different, but that has not previously been a problem.

Have you used this device with kernels older than 2.6.32? Fortunately,
it does not need external firmware, thus it works with any Live CD. I
have routinely tested all fairly recent kernels and have never seen this
problem.

Larry
