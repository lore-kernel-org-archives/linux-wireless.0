Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:44664 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbeAIC2H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 21:28:07 -0500
Received: by mail-qk0-f178.google.com with SMTP id v188so16765231qkh.11
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jan 2018 18:28:06 -0800 (PST)
Received: from debian-laptop (cblmdm134-228-27-14.buckeyecom.net. [134.228.27.14])
        by smtp.gmail.com with ESMTPSA id w61sm8329642qte.55.2018.01.08.18.28.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Jan 2018 18:28:05 -0800 (PST)
Message-ID: <1515464884.3518.4.camel@localhost> (sfid-20180109_032811_538190_BFA344EC)
Subject: Question on stopping ath dmesg output spam
From: waltfeasel@gmail.com
To: linux-wireless@vger.kernel.org
Date: Mon, 08 Jan 2018 21:28:04 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First off thank you to all of you for your work in letting me run linux
on my system! It really is greatly appreciated! It has come a long ways
from the early 90's due to everyone sharing their skills and
contributing. Sadly the below is driving me nuts for some reason and I
am at a loss on how to remedy it myself so I seek your wisdom.

I really would like to find a way to stop the repeated messages from my
wireless device in dmesg. 
It works fine and I have never had an issue with it before. I have
updated to kernel ver 4.15-rc7 and could not find anything in
configuring to stop this behavior. 
It also does this with the latest 4.14.0-0.bpo.2-amd64 kernel from
Debian so I don't believe it is something I have or havn't done but I
have been wrong more than once when confident I was right.

Most of things I have found refer to getting the Qualcomm Atheros
AR9485 Wireless Network Adapter working on a system and do not fix the
repeated spamming of this message.

Is there something I need to fix or if this is normal behavior is there
a way I can send this to the black hole (/dev/null) it belongs in?

Thank you for any insight,

Walt



uname -a
Linux debian-laptop 4.15.0-rc7-feas-00005-g4d01e46404b8-dirty #3 SMP
PREEMPT Sun Jan 7 19:31:26 EST 2018 x86_64 GNU/Linux


wlan0: authenticate with 14:ab:f0:68:ae:e0
wlan0: send auth to 14:ab:f0:68:ae:e0 (try 1/3)
wlan0: authenticated
wlan0: associate with 14:ab:f0:68:ae:e0 (try 1/3)
wlan0: RX AssocResp from 14:ab:f0:68:ae:e0 (capab=0x411 status=0 aid=1)
wlan0: associated
ath: EEPROM regdomain: 0x8348
ath: EEPROM indicates we should expect a country code
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ath: regdomain 0x8348 dynamically updated by country IE


sudo iw reg get
global
country US: DFS-FCC
	(2402 - 2472 @ 40), (N/A, 30), (N/A)
	(5170 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
	(5250 - 5330 @ 80), (N/A, 23), (0 ms), DFS, AUTO-BW
	(5490 - 5730 @ 160), (N/A, 23), (0 ms), DFS
	(5735 - 5835 @ 80), (N/A, 30), (N/A)
	(57240 - 63720 @ 2160), (N/A, 40), (N/A)


lspci
02:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network
Adapter (rev 01)


lsmod | grep ath
ath9k                 114688  0
ath9k_common           20480  1 ath9k
ath9k_hw              479232  2 ath9k,ath9k_common
ath                    32768  3 ath9k_hw,ath9k,ath9k_common
mac80211              806912  1 ath9k
cfg80211              737280  4 mac80211,ath9k,ath,ath9k_common


sudo rfkill list all
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: acer-wireless: Wireless LAN
	Soft blocked: no
	Hard blocked: no


lsmod | grep acer
acer_wmi               24576  0
sparse_keymap          16384  1 acer_wmi
rfkill                 28672  5 acer_wmi,cfg80211
video                  45056  2 acer_wmi,i915
wmi                    28672  3 wmi_bmof,acer_wmi,mxm_wmi


sudo dmesg | grep ath | egrep "regdomain|Country"
[   28.375725] ath: EEPROM regdomain: 0x65
[   28.375727] ath: Country alpha2 being used: 00
[   95.802335] ath: EEPROM regdomain: 0x8348
[   95.802340] ath: Country alpha2 being used: US
[   95.802342] ath: regdomain 0x8348 dynamically updated by country IE
[ 2487.519115] ath: EEPROM regdomain: 0x8348
[ 2487.519121] ath: Country alpha2 being used: US
[ 2487.519123] ath: regdomain 0x8348 dynamically updated by country IE
[ 3962.490884] ath: EEPROM regdomain: 0x8348
[ 3962.490892] ath: Country alpha2 being used: US
[ 3962.490895] ath: regdomain 0x8348 dynamically updated by country IE
[ 6089.394036] ath: EEPROM regdomain: 0x8348
[ 6089.394043] ath: Country alpha2 being used: US
[ 6089.394045] ath: regdomain 0x8348 dynamically updated by country IE
