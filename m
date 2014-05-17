Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dewberryfields.co.uk ([217.41.92.67]:49448 "EHLO
	mail.dewberryfields.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbaEQOjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 10:39:51 -0400
Message-ID: <537774B4.2000905@dewberryfields.co.uk> (sfid-20140517_163955_660142_06FD36F5)
Date: Sat, 17 May 2014 15:39:48 +0100
From: Michael Howard <mike@dewberryfields.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Mwifiex driver on Globalscale Mirabox
References: <5346DED8.2030704@free.fr>
	<CAJwzM1k=OOBa7C3u0+TzmRUBwMYfJSMgB+smbORfKmPE6KnF2g@mail.gmail.com>
	<53480138.2080805@free.fr>	<53733AB4.7010500@free.fr>
	<20140514215126.GA15419@us.netrek.org>
	<CAJwzM1k+75qRJaONyehMNPaOqOHyBhryMGBtZ4NpD6jGHk-cHQ@mail.gmail.com>
	<5374F638.6000505@dewberryfields.co.uk>
	<CAJwzM1mvK1i3ENrQyVZNoiwYFiopWGRaOVe5iGTr61TQVXdaMQ@mail.gmail.com>
 <CAJwzM1mg5KVZFev4Gs9Qw43H5OwiLF3fmhwv8-3y9mEvWM6b6g@mail.gmail.com>
In-Reply-To: <CAJwzM1mg5KVZFev4Gs9Qw43H5OwiLF3fmhwv8-3y9mEvWM6b6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 16/05/2014 13:27, Avinash Patil wrote:
>
> Hi Michael,
>
> We are not able to reproduce this issue in our setup with sd8787 p96. 
> Could you please share hostapd config file, console logs and driver 
> debug logs?
>
> Thanks,
> -Avinash
>
>
Hi Avinash,

Not sure how to enable driver debug logs, other than debugfs and that 
contains only empty files, and adding -ddd to hostapd.

hostapd.conf is simple, just for testing, as follows;

interface=uap0
bridge=br0
driver=nl80211
ssid=TEST
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=*******************
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

root@mirabox:/etc/init.d# ./hostapd start
[....] Starting advanced IEEE 802.11 management: hostapddevice uap0 
entered promiscuous mode
br0: port 2(uap0) entered listening state
br0: port 2(uap0) entered listening state
mwifiex_sdio mmc0:0001:1: CMD_RESP: cmd 0x112 error, result=0x2
. ok

==> kern.log <==
May 17 13:23:52 mirabox kernel: mwifiex_sdio mmc0:0001:1: CMD_RESP: cmd 
0x112 error, result=0x2

The odd thing is, I have just added an atheros AR9287 mini pcie card to 
the Mirabox, rebuilt the kernel (only adding atheros support) and now 
the SD8787 card and mwifiex work.
I have no idea why this is other than possibly a flakey Mirabox. I will 
let you know if I get a better idea (maybe I'll now take out the Atheros 
card) of what's happening.

Regards,
Mike

-- 

