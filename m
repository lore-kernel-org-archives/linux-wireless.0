Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:44904 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab3D0NTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 09:19:37 -0400
Received: by mail-bk0-f47.google.com with SMTP id ji1so2034244bkc.20
        for <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 06:19:35 -0700 (PDT)
Message-ID: <517BD02A.5060904@unicz.it> (sfid-20130427_151940_748350_F10D6AF1)
Date: Sat, 27 Apr 2013 15:18:34 +0200
From: Paolo Zaffino <p.zaffino@unicz.it>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Intel Centrino Wireless-N 2230 (rev c4) bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Developers,
my name is Paolo Zaffino and I'm an Italian GNU/Linux user.
I have an asus NV56 with an Intel Corporation Centrino Wireless-N 2230 
(rev c4) wifi card.
I installed Arch Linux at 64 bit, my kernel version is the  3.8.7-1 and 
I use Gnome with Network Manager.
I am facing a strange bug in the wifi driver.
I am able to get a working connection to many wifi networks (open and 
wpa), but in other cases I can not connect to them or I connect but 
every 30 seconds (more o less) the connection drops.
In this last case dmesg return this:

[   25.459573] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[   25.460892] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   25.468385] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
[   25.846472] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   25.853963] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
[   26.065675] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   27.186073] wlp3s0: authenticate with 74:ea:3a:cd:28:42
[   27.202371] wlp3s0: send auth to 74:ea:3a:cd:28:42 (try 1/3)
[   27.229754] wlp3s0: authenticated
[   27.229912] iwlwifi 0000:03:00.0 wlp3s0: disabling HT/VHT due to 
WEP/TKIP use
[   27.229915] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
not supported by the AP
[   27.229916] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS is 
not supported by the AP
[   27.232552] wlp3s0: associate with 74:ea:3a:cd:28:42 (try 1/3)
[   27.235911] wlp3s0: RX AssocResp from 74:ea:3a:cd:28:42 (capab=0x431 
status=0 aid=8)
[   27.237835] wlp3s0: associated
[   27.237875] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[ 1756.822019] wlp3s0: deauthenticating from 74:ea:3a:cd:28:42 by local 
choice (reason=3)
[ 1756.828531] cfg80211: Calling CRDA to update world regulatory domain
[ 1757.303801] wlp3s0: authenticate with 74:ea:3a:cd:29:13
[ 1757.308566] wlp3s0: send auth to 74:ea:3a:cd:29:13 (try 1/3)
[ 1757.310340] wlp3s0: authenticated
[ 1757.310586] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
not supported by the AP
[ 1757.310592] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS is 
not supported by the AP
[ 1757.310598] wlp3s0: waiting for beacon from 74:ea:3a:cd:29:13
[ 1757.385290] wlp3s0: associate with 74:ea:3a:cd:29:13 (try 1/3)
[ 1757.387810] wlp3s0: RX AssocResp from 74:ea:3a:cd:29:13 (capab=0x431 
status=0 aid=13)
[ 1757.389812] wlp3s0: associated
[ 1757.793015] wlp3s0: deauthenticating from 74:ea:3a:cd:29:13 by local 
choice (reason=3)
[ 1757.806386] cfg80211: Calling CRDA to update world regulatory domain
[ 1758.222639] wlp3s0: authenticate with 74:ea:3a:cd:29:13
[ 1758.225663] wlp3s0: send auth to 74:ea:3a:cd:29:13 (try 1/3)
[ 1758.228142] wlp3s0: authenticated
[ 1758.228424] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
not supported by the AP
[ 1758.228436] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS is 
not supported by the AP
[ 1758.230701] wlp3s0: associate with 74:ea:3a:cd:29:13 (try 1/3)
[ 1758.233728] wlp3s0: RX AssocResp from 74:ea:3a:cd:29:13 (capab=0x431 
status=0 aid=13)
[ 1758.236525] wlp3s0: associated
[ 1758.761549] wlp3s0: deauthenticating from 74:ea:3a:cd:29:13 by local 
choice (reason=3)
[ 1758.771562] cfg80211: Calling CRDA to update world regulatory domain
[ 1759.206738] wlp3s0: authenticate with 74:ea:3a:cd:28:42
[ 1759.211055] wlp3s0: send auth to 74:ea:3a:cd:28:42 (try 1/3)
[ 1759.213441] wlp3s0: authenticated
[ 1759.213538] iwlwifi 0000:03:00.0 wlp3s0: disabling HT/VHT due to 
WEP/TKIP use
[ 1759.213540] iwlwifi 0000:03:00.0 wlp3s0: disabling HT as WMM/QoS is 
not supported by the AP
[ 1759.213541] iwlwifi 0000:03:00.0 wlp3s0: disabling VHT as WMM/QoS is 
not supported by the AP
[ 1759.215855] wlp3s0: associate with 74:ea:3a:cd:28:42 (try 1/3)
[ 1759.218253] wlp3s0: RX AssocResp from 74:ea:3a:cd:28:42 (capab=0x431 
status=0 aid=2)
[ 1759.220225] wlp3s0: associated


I'm here for further infomations about hardware or configurations.
Unfortunately this is a nasty problem for me and for a plenty of other 
users that are in the same situation.
Thank you very much for your great work!

Regards.
Paolo Zaffino

-- 
Paolo Zaffino
Ph.D. Student - Biomedical and Computer Engineering
Dept. of Experimental and Clinical Medicine
"Magna Graecia" University of Catanzaro
viale Europa, 88100 Catanzaro - Italy

