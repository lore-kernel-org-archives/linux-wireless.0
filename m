Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:64887 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420AbYGaNyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 09:54:53 -0400
Message-ID: <4891C42E.6000001@lwfinger.net> (sfid-20080731_155456_491689_98B8805A)
Date: Thu, 31 Jul 2008 08:54:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: rschneiderman@yahoo.com
CC: linux-wireless@vger.kernel.org
Subject: Re: cannot connect to wireless router
References: <892482.44637.qm@web52406.mail.re2.yahoo.com>
In-Reply-To: <892482.44637.qm@web52406.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Schneiderman wrote:
> All,
> I can now see my wireless connection using iwlist but when I use iwconfig,  the acceess point keeps saying not associated. It has never worked
> 
> I have the 2.6.26 kernel loaded on suse with the lastest b43 firmware.
> This is a broadcom 4306 rev. 3.
>   
> This is from iwconfig
> wlan0     IEEE 802.11  ESSID:"wireless_g"
>           Mode:Managed  Frequency:2.437 GHz  Access Point: Not-Associated
>           Tx-Power=27 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>           Encryption key:off
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> dmesg | grep b43
> 
> b43-phy0: Broadcom 4306 WLAN found
> input: b43-phy0 as /devices/virtual/input/input5
> firmware: requesting b43/ucode5.fw
> firmware: requesting b43/pcm5.fw
> firmware: requesting b43/b0g0initvals5.fw
> firmware: requesting b43/b0g0bsinitvals5.fw
> b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
> Registered led device: b43-phy0::tx
> Registered led device: b43-phy0::rx
> Registered led device: b43-phy0::radio
> 
> This statement says I might should be using b43legacy for my card.
> 4306 and 4309 cards with a MAC core revision of 4 or less should also use b43legacy. b43 should be used on all other cards.

Just where in this output do you see the MAC core revision listed??? You don't 
because it is ssb that reads that parameter and selects b43. Your device has a 
MAC core revision of 5 or greater. See the fives in the firmware files above? 
That is a clue.

If your BCM4306 had been a Rev. 2, then it would have used b43legacy. I just 
updated the linux-wireless wiki to redescribe which driver is used for which 
card variant.

What are the other details of your system? Which version of SuSE is your distro? 
What encryption? If WEP, are you entering the key as a passphrase or a hex 
string? In the dmesg output, what is the result of 'dmesg | grep wlan0'?

Do you have the option of using NetworkManager? Some distros use dhclient, which 
does a down/up sequence that seems to disturb b43. In general, openSUSE distros 
do not have this problem. I use the "traditional ifup method" (as configured by 
YaST) with a 10.3 system, and NetworkManager with 11.0. Both work with b43.

Larry





