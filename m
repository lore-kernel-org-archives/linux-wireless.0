Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm5-vm0.bullet.mail.ird.yahoo.com ([77.238.189.207]:40745 "HELO
	nm5-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753263Ab3HMQXy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 12:23:54 -0400
Message-ID: <1376411031.31841.YahooMailBasic@web171406.mail.ir2.yahoo.com> (sfid-20130813_182357_706749_C1C3B185)
Date: Tue, 13 Aug 2013 17:23:51 +0100 (BST)
From: Phillip Moss <phillipmoss12@yahoo.es>
Subject: Signal loss rtl8723ae wifi driver
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I have a rtl8723ae wifi card on my laptop. When connecting to any wifi Access Point 
the wifi signal fluctuates from full strength to very low.  In order to connect and 
stay connected I must be no farther than two meters from my router otherwise I get
disconnected. I have tried the kernel driver on multiple distros as well as the
vendor drivers for older kernel versions. All seem to have the same problem. The card
works ok on Windows 7 with vendor drivers. I have also tried compiling
backports-3.10-rc1-2 with no luck. During a signal loss period I get no logs but if I
take the laptop too far from the AP dmesg reports:

[  764.163774] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  764.192783] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  764.200572] wlp3s0: authenticated
[  764.203290] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  764.225178] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
aid=2) [  764.225452] wlp3s0: associated
[  764.225459] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[  772.036168] wlp3s0: deauthenticated from xx:xx:xx:xx:xx:xx (Reason: 15)
[  772.077800] cfg80211: Calling CRDA to update world regulatory domain
[  775.286474] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  775.315559] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  775.321158] wlp3s0: authenticated
[  775.322689] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  775.426155] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 2/3)
[  775.529550] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 3/3)
[  775.633015] wlp3s0: association with xx:xx:xx:xx:xx:xx timed out
[  786.622957] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  786.651896] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  786.662445] wlp3s0: authenticated
[  786.665720] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  786.673076] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
aid=2) [  786.673305] wlp3s0: associated
[  814.496149] wlp3s0: Connection to AP xx:xx:xx:xx:xx:xx lost
[  814.589627] cfg80211: Calling CRDA to update world regulatory domain
[  815.974548] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  816.003540] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  816.012928] wlp3s0: authenticated
[  816.014009] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  816.117439] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 2/3)
[  816.220847] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 3/3)
[  816.324220] wlp3s0: association with xx:xx:xx:xx:xx:xx timed out
[  817.806001] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  817.835045] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  817.935652] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
[  818.039082] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
[  818.142458] wlp3s0: authentication with xx:xx:xx:xx:xx:xx timed out
[  820.148096] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  820.177057] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  820.183705] wlp3s0: authenticated
[  820.184179] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  820.287650] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 2/3)
[  820.391074] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 3/3)
[  820.494461] wlp3s0: association with xx:xx:xx:xx:xx:xx timed out
[  826.476820] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  826.505764] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  826.606337] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
[  826.709744] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
[  826.813199] wlp3s0: authentication with xx:xx:xx:xx:xx:xx timed out
[  837.813007] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  837.842080] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  837.857000] wlp3s0: authenticated
[  837.859229] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  837.866815] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
aid=2) [  837.867038] wlp3s0: associated
[  845.599874] wlp3s0: deauthenticated from xx:xx:xx:xx:xx:xx (Reason: 15)
[  845.627330] cfg80211: Calling CRDA to update world regulatory domain
[  857.376412] wlp3s0: authenticate with xx:xx:xx:xx:xx:xx
[  857.405387] wlp3s0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  857.410017] wlp3s0: authenticated
[  857.412546] wlp3s0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  857.415665] wlp3s0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0
aid=2) [  857.415902] wlp3s0: associated

The issue is exactly the same as discribed here:
http://askubuntu.com/questions/289414/rtl8723ae-driver-problem-ubuntu-13-04
Does anyone know what might be wrong?
Cheers for the help.
