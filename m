Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:38056 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3HNDXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:23:49 -0400
Received: by mail-ob0-f182.google.com with SMTP id wo10so11418452obc.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 20:23:48 -0700 (PDT)
Message-ID: <520AF842.8030403@lwfinger.net> (sfid-20130814_052411_058927_B66F34A1)
Date: Tue, 13 Aug 2013 22:23:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Phillip Moss <phillipmoss12@yahoo.es>
CC: linux-wireless@vger.kernel.org
Subject: Re: Signal loss rtl8723ae wifi driver
References: <1376411031.31841.YahooMailBasic@web171406.mail.ir2.yahoo.com>
In-Reply-To: <1376411031.31841.YahooMailBasic@web171406.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2013 11:23 AM, Phillip Moss wrote:
> Hi all,
> I have a rtl8723ae wifi card on my laptop. When connecting to any wifi Access Point
> the wifi signal fluctuates from full strength to very low.  In order to connect and
> stay connected I must be no farther than two meters from my router otherwise I get
> disconnected. I have tried the kernel driver on multiple distros as well as the
> vendor drivers for older kernel versions. All seem to have the same problem. The card
> works ok on Windows 7 with vendor drivers. I have also tried compiling
> backports-3.10-rc1-2 with no luck. During a signal loss period I get no logs but if I
> take the laptop too far from the AP dmesg reports:
>
> [  764.163774] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  764.192783] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  764.200572] wlp3s0: authenticated
> [  764.203290] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  764.225178] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
> aid=2) [  764.225452] wlp3s0: associated
> [  764.225459] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> [  772.036168] wlp3s0: deauthenticated from xx:xx:xx:xx:xx:xx (Reason: 15)
> [  772.077800] cfg80211: Calling CRDA to update world regulatory domain
> [  775.286474] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  775.315559] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  775.321158] wlp3s0: authenticated
> [  775.322689] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  775.426155] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 2/3)
> [  775.529550] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 3/3)
> [  775.633015] wlp3s0: association with xx:xx:xx:xx:xx:xx timed out
> [  786.622957] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  786.651896] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  786.662445] wlp3s0: authenticated
> [  786.665720] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  786.673076] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
> aid=2) [  786.673305] wlp3s0: associated
> [  814.496149] wlp3s0: Connection to AP xx:xx:xx:xx:xx:xx lost
> [  814.589627] cfg80211: Calling CRDA to update world regulatory domain
> [  815.974548] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  816.003540] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  816.012928] wlp3s0: authenticated
> [  816.014009] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  816.117439] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 2/3)
> [  816.220847] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 3/3)
> [  816.324220] wlp3s0: association with xx:xx:xx:xx:xx:xx timed out
> [  817.806001] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  817.835045] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  817.935652] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
> [  818.039082] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
> [  818.142458] wlp3s0: authentication with xx:xx:xx:xx:xx:xx timed out
> [  820.148096] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  820.177057] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  820.183705] wlp3s0: authenticated
> [  820.184179] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  820.287650] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 2/3)
> [  820.391074] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 3/3)
> [  820.494461] wlp3s0: association with xx:xx:xx:xx:xx:xx timed out
> [  826.476820] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  826.505764] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  826.606337] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
> [  826.709744] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
> [  826.813199] wlp3s0: authentication with xx:xx:xx:xx:xx:xx timed out
> [  837.813007] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  837.842080] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  837.857000] wlp3s0: authenticated
> [  837.859229] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  837.866815] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
> aid=2) [  837.867038] wlp3s0: associated
> [  845.599874] wlp3s0: deauthenticated from xx:xx:xx:xx:xx:xx (Reason: 15)
> [  845.627330] cfg80211: Calling CRDA to update world regulatory domain
> [  857.376412] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
> [  857.405387] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
> [  857.410017] wlp3s0: authenticated
> [  857.412546] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  857.415665] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
> aid=2) [  857.415902] wlp3s0: associated
>
> The issue is exactly the same as discribed here:
> http://askubuntu.com/questions/289414/rtl8723ae-driver-problem-ubuntu-13-04
> Does anyone know what might be wrong?
> Cheers for the help.

No.

There is only one driver for the RTL8723AE, thus it is not a surprise that the 
one on the Realtek site behaves the same as the one in the kernel. Similarly, 
the distros usually do not change the kernel, at least not for the device 
drivers. Thus all of them should behave the same. In fact, if I learned that 
some distro was applying a patch that was not in the mainline kernel, I would 
refuse to support any user of that distro.

How are you measuring the signal strength? This device does not report an actual 
strength - the driver manipulates the reported number into what "could" be a 
signal strength in dBm.

Why is your device name "wlp3s0", rather than the usual "wlanX"? What is 
controlling your connection. If it is wicd, note that I do not support that 
piece of software. I use NetworkManager.

In my standard setup, iwconfig shows about -60 dBm for my device, and the 
netperf results for 3 second intervals are as follows:

Pass 1
TCP_MAERTS Test:   8.76  9.21  8.37  7.84  8.75 10.61 14.11  9.24  9.95 10.00
RX Results: max 14.11, min  7.84. Mean  9.68(1.67)

TCP_STREAM Test:   8.61  9.84  3.94  3.39  4.90  4.79  4.01  5.89  6.13  9.38
TX Results: max  9.84, min  3.39. Mean  6.09(2.25)

Pass 2
TCP_MAERTS Test:  11.65 12.30 11.35  6.18  7.48 11.89  8.57  8.17  8.53  9.98
RX Results: max 12.30, min  6.18. Mean  9.61(2.01)

TCP_STREAM Test:   5.92  9.42  5.39  5.47  5.00  7.19  8.81  6.70  9.81  2.97
TX Results: max  9.81, min  2.97. Mean  6.67(2.06)

This is not the best performance that I have seen - this is an 802.11n AP 
capable of 150 Mbps for these 1x1 devices.

Larry


