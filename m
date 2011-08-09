Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.alice.nl ([217.149.195.8]:55253 "EHLO smtp.alice.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab1HIUbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 16:31:50 -0400
Message-ID: <4E418A39.5060705@cobradevil.org> (sfid-20110809_223155_704074_8E5394E2)
Date: Tue, 09 Aug 2011 21:27:53 +0200
From: william <kc@cobradevil.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu sometimes it can authenticate to ap
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org> <34676454425401d650be733a43191a53@cobradevil.org> <532595cb4d5ef910de54a4736ba76185@cobradevil.org> <4E41624E.3010904@lwfinger.net>
In-Reply-To: <4E41624E.3010904@lwfinger.net>
Content-Type: multipart/mixed;
 boundary="------------070602050103070004090301"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070602050103070004090301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Ok attached log files and below my test at home

Test scenario:

@home
I have a netgear wireless router which does wpa2 aes
i cannot get it to work anymore as at work so forgive me for these mixed 
results.

What i do is compile todays compat wireless on ubuntu maverick and on natty

http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
I installed kernel headers and build-essentials end run:
./scripts/driver-select rtlwifi
make && make install

###################################################################

ubuntu maverick

###################################################################



ubuntu maverick 2.6.35-30.54:
dmesg -c  after cold boot:

plugging in adapter:
dmesg:
[  387.400102] usb 2-5: new high speed USB device using ehci_hcd and 
address 3
[  387.682348] rtl8192cu: MAC address: 00:a1:b0:89:82:1c
[  387.682361] rtl8192cu: Board Type 0
[  387.713558] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  387.713565] cfg80211: Updating information on frequency 2412 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713568] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713571] cfg80211: Updating information on frequency 2417 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713573] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713576] cfg80211: Updating information on frequency 2422 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713578] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713580] cfg80211: Updating information on frequency 2427 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713583] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713585] cfg80211: Updating information on frequency 2432 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713588] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713590] cfg80211: Updating information on frequency 2437 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713593] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713595] cfg80211: Updating information on frequency 2442 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713598] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713600] cfg80211: Updating information on frequency 2447 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713603] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713605] cfg80211: Updating information on frequency 2452 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713607] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713610] cfg80211: Updating information on frequency 2457 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713612] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713615] cfg80211: Updating information on frequency 2462 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713617] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713620] cfg80211: Disabling freq 2467 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713622] cfg80211: Disabling freq 2472 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713624] cfg80211: Disabling freq 2484 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713886] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  387.718805] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  387.719469] usbcore: registered new interface driver rtl8192cu
[  387.740881] udev[987]: renamed network interface wlan0 to wlan1

wpa_supplicant -Dnl80211 -dd -c /etc/wpa_supplicant_thuis.conf -f 
wpa_supplicant.log -iwlan1
wpa_supplicant-ubuntu-maverick_cold_boot.log

dmesg:
[  387.400102] usb 2-5: new high speed USB device using ehci_hcd and 
address 3
[  387.682348] rtl8192cu: MAC address: 00:a1:b0:89:82:1c
[  387.682361] rtl8192cu: Board Type 0
[  387.713558] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  387.713565] cfg80211: Updating information on frequency 2412 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713568] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713571] cfg80211: Updating information on frequency 2417 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713573] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713576] cfg80211: Updating information on frequency 2422 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713578] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713580] cfg80211: Updating information on frequency 2427 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713583] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713585] cfg80211: Updating information on frequency 2432 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713588] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713590] cfg80211: Updating information on frequency 2437 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713593] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713595] cfg80211: Updating information on frequency 2442 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713598] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713600] cfg80211: Updating information on frequency 2447 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713603] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713605] cfg80211: Updating information on frequency 2452 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713607] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713610] cfg80211: Updating information on frequency 2457 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713612] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713615] cfg80211: Updating information on frequency 2462 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713617] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713620] cfg80211: Disabling freq 2467 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713622] cfg80211: Disabling freq 2472 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713624] cfg80211: Disabling freq 2484 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713886] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  387.718805] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  387.719469] usbcore: registered new interface driver rtl8192cu
[  387.740881] udev[987]: renamed network interface wlan0 to wlan1
[  462.336237] rtl8192cu: MAC auto ON okay!
[  462.370400] rtl8192cu: Tx queue select: 0x05
[  462.371173] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  462.774420] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  463.673151] wlan1: direct probe to e0:91:f5:7a:ae:d6 (try 1/3)
[  463.677499] wlan1: direct probe responded
[  463.690120] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  463.708429] wlan1: authenticated
[  463.708461] wlan1: associate with e0:91:f5:7a:ae:d6 (try 1)
[  463.715801] wlan1: RX AssocResp from e0:91:f5:7a:ae:d6 (capab=0x411 
status=0 aid=3)
[  463.715808] wlan1: associated
[  463.729553] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  473.761143] wlan1: deauthenticating from e0:91:f5:7a:ae:d6 by local 
choice (reason=3)
[  473.811154] cfg80211: All devices are disconnected, going to restore 
regulatory settings
[  473.811167] cfg80211: Restoring regulatory settings
[  473.811176] cfg80211: Calling CRDA to update world regulatory domain
[  473.824224] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  473.824232] cfg80211: World regulatory domain updated:
[  473.824237] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  473.824246] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  473.824254] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  473.824261] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  473.824268] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  473.824275] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  474.240071] wlan1: no IPv6 routers present
[  474.613195] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  474.810080] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 2)
[  475.010123] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 3)
[  475.014905] wlan1: authenticated
[  475.014939] wlan1: associate with e0:91:f5:7a:ae:d6 (try 1)
[  475.018642] wlan1: RX AssocResp from e0:91:f5:7a:ae:d6 (capab=0x411 
status=0 aid=3)
[  475.018650] wlan1: associated
[  485.048496] wlan1: deauthenticating from e0:91:f5:7a:ae:d6 by local 
choice (reason=3)
[  485.083634] cfg80211: All devices are disconnected, going to restore 
regulatory settings
[  485.083644] cfg80211: Restoring regulatory settings
[  485.083653] cfg80211: Calling CRDA to update world regulatory domain
[  485.096588] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  485.096597] cfg80211: World regulatory domain updated:
[  485.096601] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  485.096610] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  485.096617] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  485.096625] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  485.096632] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  485.096640] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  485.893367] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  486.092557] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 2)
[  486.290075] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 3)
[  486.490071] wlan1: authentication with e0:91:f5:7a:ae:d6 timed out


ctrl+c wpa_supplicant and starting again:
dmesg:
[  387.400102] usb 2-5: new high speed USB device using ehci_hcd and 
address 3
[  387.682348] rtl8192cu: MAC address: 00:a1:b0:89:82:1c
[  387.682361] rtl8192cu: Board Type 0
[  387.713558] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  387.713565] cfg80211: Updating information on frequency 2412 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713568] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713571] cfg80211: Updating information on frequency 2417 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713573] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713576] cfg80211: Updating information on frequency 2422 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713578] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713580] cfg80211: Updating information on frequency 2427 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713583] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713585] cfg80211: Updating information on frequency 2432 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713588] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713590] cfg80211: Updating information on frequency 2437 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713593] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713595] cfg80211: Updating information on frequency 2442 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713598] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713600] cfg80211: Updating information on frequency 2447 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713603] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713605] cfg80211: Updating information on frequency 2452 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713607] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713610] cfg80211: Updating information on frequency 2457 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713612] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713615] cfg80211: Updating information on frequency 2462 MHz for 
a 20 MHz width channel with regulatory rule:
[  387.713617] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  387.713620] cfg80211: Disabling freq 2467 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713622] cfg80211: Disabling freq 2472 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713624] cfg80211: Disabling freq 2484 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  387.713886] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  387.718805] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  387.719469] usbcore: registered new interface driver rtl8192cu
[  387.740881] udev[987]: renamed network interface wlan0 to wlan1
[  462.336237] rtl8192cu: MAC auto ON okay!
[  462.370400] rtl8192cu: Tx queue select: 0x05
[  462.371173] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  462.774420] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  463.673151] wlan1: direct probe to e0:91:f5:7a:ae:d6 (try 1/3)
[  463.677499] wlan1: direct probe responded
[  463.690120] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  463.708429] wlan1: authenticated
[  463.708461] wlan1: associate with e0:91:f5:7a:ae:d6 (try 1)
[  463.715801] wlan1: RX AssocResp from e0:91:f5:7a:ae:d6 (capab=0x411 
status=0 aid=3)
[  463.715808] wlan1: associated
[  463.729553] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  473.761143] wlan1: deauthenticating from e0:91:f5:7a:ae:d6 by local 
choice (reason=3)
[  473.811154] cfg80211: All devices are disconnected, going to restore 
regulatory settings
[  473.811167] cfg80211: Restoring regulatory settings
[  473.811176] cfg80211: Calling CRDA to update world regulatory domain
[  473.824224] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  473.824232] cfg80211: World regulatory domain updated:
[  473.824237] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  473.824246] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  473.824254] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  473.824261] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  473.824268] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  473.824275] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  474.240071] wlan1: no IPv6 routers present
[  474.613195] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  474.810080] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 2)
[  475.010123] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 3)
[  475.014905] wlan1: authenticated
[  475.014939] wlan1: associate with e0:91:f5:7a:ae:d6 (try 1)
[  475.018642] wlan1: RX AssocResp from e0:91:f5:7a:ae:d6 (capab=0x411 
status=0 aid=3)
[  475.018650] wlan1: associated
[  485.048496] wlan1: deauthenticating from e0:91:f5:7a:ae:d6 by local 
choice (reason=3)
[  485.083634] cfg80211: All devices are disconnected, going to restore 
regulatory settings
[  485.083644] cfg80211: Restoring regulatory settings
[  485.083653] cfg80211: Calling CRDA to update world regulatory domain
[  485.096588] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  485.096597] cfg80211: World regulatory domain updated:
[  485.096601] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  485.096610] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  485.096617] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  485.096625] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[  485.096632] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  485.096640] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[  485.893367] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  486.092557] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 2)
[  486.290075] wlan1: authenticate with e0:91:f5:7a:ae:d6 (try 3)
[  486.490071] wlan1: authentication with e0:91:f5:7a:ae:d6 timed out
[  612.790282] rtl8192cu: MAC auto ON okay!
[  612.828665] rtl8192cu: Tx queue select: 0x05
[  612.829415] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  613.232099] ADDRCONF(NETDEV_UP): wlan1: link is not ready

attached wpa_supplicant-ubuntu-maverick_ctrlc.log







###################################################################

ubuntu natty

###################################################################


ubuntu natty 2.6.38-10.46:
dmesg -c  after cold boot:

plugging in adapter:
dmesg:
[  541.820017] usb 1-4: new high speed USB device using ehci_hcd and 
address 3
[  541.981323] cfg80211: Calling CRDA to update world regulatory domain
[  542.094477] rtl8192cu: MAC address: 00:a1:b0:89:82:1c
[  542.094484] rtl8192cu: Board Type 0
[  542.102603] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  542.102610] cfg80211: Updating information on frequency 2412 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102615] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102618] cfg80211: Updating information on frequency 2417 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102622] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102625] cfg80211: Updating information on frequency 2422 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102629] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102632] cfg80211: Updating information on frequency 2427 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102636] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102639] cfg80211: Updating information on frequency 2432 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102642] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102646] cfg80211: Updating information on frequency 2437 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102649] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102652] cfg80211: Updating information on frequency 2442 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102656] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102659] cfg80211: Updating information on frequency 2447 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102663] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102666] cfg80211: Updating information on frequency 2452 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102670] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102673] cfg80211: Updating information on frequency 2457 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102677] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102680] cfg80211: Updating information on frequency 2462 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102683] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102687] cfg80211: Disabling freq 2467 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102690] cfg80211: Disabling freq 2472 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102693] cfg80211: Disabling freq 2484 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102703] cfg80211: Pending regulatory request, waiting for it to 
be processed...
[  542.102760] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  542.105689] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  542.106369] usbcore: registered new interface driver rtl8192cu


wpa_supplicant -Dnl80211 -dd -c /etc/wpa_supplicant_thuis.conf -f 
wpa_supplicant.log -iwlan0
wpa_supplicant-ubuntu-natty_cold_boot.log

dmesg:
[  541.981323] cfg80211: Calling CRDA to update world regulatory domain
[  542.094477] rtl8192cu: MAC address: 00:a1:b0:89:82:1c
[  542.094484] rtl8192cu: Board Type 0
[  542.102603] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  542.102610] cfg80211: Updating information on frequency 2412 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102615] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102618] cfg80211: Updating information on frequency 2417 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102622] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102625] cfg80211: Updating information on frequency 2422 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102629] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102632] cfg80211: Updating information on frequency 2427 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102636] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102639] cfg80211: Updating information on frequency 2432 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102642] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102646] cfg80211: Updating information on frequency 2437 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102649] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102652] cfg80211: Updating information on frequency 2442 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102656] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102659] cfg80211: Updating information on frequency 2447 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102663] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102666] cfg80211: Updating information on frequency 2452 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102670] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102673] cfg80211: Updating information on frequency 2457 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102677] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102680] cfg80211: Updating information on frequency 2462 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102683] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102687] cfg80211: Disabling freq 2467 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102690] cfg80211: Disabling freq 2472 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102693] cfg80211: Disabling freq 2484 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102703] cfg80211: Pending regulatory request, waiting for it to 
be processed...
[  542.102760] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  542.105689] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  542.106369] usbcore: registered new interface driver rtl8192cu
[  676.832020] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga 
encoder (output 0)
[  837.368145] rtl8192cu: MAC auto ON okay!
[  837.400782] rtl8192cu: Tx queue select: 0x05
[  837.401540] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  837.794521] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  838.635952] wlan0: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  838.640035] wlan0: authenticated
[  838.640211] wlan0: associate with e0:91:f5:7a:ae:d6 (try 1)
[  838.644032] wlan0: RX AssocResp from e0:91:f5:7a:ae:d6 (capab=0x411 
status=0 aid=4)
[  838.644036] wlan0: associated
[  838.656495] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  838.681561] Intel AES-NI instructions are not detected.
[  838.701438] padlock_aes: VIA PadLock not detected.
[  848.816007] wlan0: no IPv6 routers present

ctrl+c wpa_supplicant and starting again:
dmesg:
[  541.820017] usb 1-4: new high speed USB device using ehci_hcd and 
address 3
[  541.981323] cfg80211: Calling CRDA to update world regulatory domain
[  542.094477] rtl8192cu: MAC address: 00:a1:b0:89:82:1c
[  542.094484] rtl8192cu: Board Type 0
[  542.102603] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  542.102610] cfg80211: Updating information on frequency 2412 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102615] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102618] cfg80211: Updating information on frequency 2417 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102622] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102625] cfg80211: Updating information on frequency 2422 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102629] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102632] cfg80211: Updating information on frequency 2427 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102636] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102639] cfg80211: Updating information on frequency 2432 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102642] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102646] cfg80211: Updating information on frequency 2437 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102649] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102652] cfg80211: Updating information on frequency 2442 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102656] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102659] cfg80211: Updating information on frequency 2447 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102663] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102666] cfg80211: Updating information on frequency 2452 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102670] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102673] cfg80211: Updating information on frequency 2457 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102677] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102680] cfg80211: Updating information on frequency 2462 MHz for 
a 20 MHz width channel with regulatory rule:
[  542.102683] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 
2000 mBm)
[  542.102687] cfg80211: Disabling freq 2467 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102690] cfg80211: Disabling freq 2472 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102693] cfg80211: Disabling freq 2484 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  542.102703] cfg80211: Pending regulatory request, waiting for it to 
be processed...
[  542.102760] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  542.105689] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  542.106369] usbcore: registered new interface driver rtl8192cu
[  676.832020] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga 
encoder (output 0)
[  837.368145] rtl8192cu: MAC auto ON okay!
[  837.400782] rtl8192cu: Tx queue select: 0x05
[  837.401540] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  837.794521] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  838.635952] wlan0: authenticate with e0:91:f5:7a:ae:d6 (try 1)
[  838.640035] wlan0: authenticated
[  838.640211] wlan0: associate with e0:91:f5:7a:ae:d6 (try 1)
[  838.644032] wlan0: RX AssocResp from e0:91:f5:7a:ae:d6 (capab=0x411 
status=0 aid=4)
[  838.644036] wlan0: associated
[  838.656495] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  838.681561] Intel AES-NI instructions are not detected.
[  838.701438] padlock_aes: VIA PadLock not detected.
[  848.816007] wlan0: no IPv6 routers present
[  952.783925] wlan0: deauthenticating from e0:91:f5:7a:ae:d6 by local 
choice (reason=3)
[  952.808221] cfg80211: All devices are disconnected, going to restore 
regulatory settings
[  952.808225] cfg80211: Restoring regulatory settings
[  952.808231] cfg80211: Calling CRDA for country: US
[  975.889157] rtl8192cu: MAC auto ON okay!
[  975.921798] rtl8192cu: Tx queue select: 0x05
[  975.922442] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  976.313109] ADDRCONF(NETDEV_UP): wlan0: link is not ready


attached wpa_supplicant-ubuntu-maverick_ctrlc.log



@@@@@@@@@@@@@@@@@@@@


on 2.6.35 i cannot do a dhcp request but i can on 2.6.38
after ctrl+c both systems are rendered useless


On 08/09/2011 06:37 PM, Larry Finger wrote:
> On 08/09/2011 10:12 AM, kc@cobradevil.org wrote:
>> Hello all,
>>
>> not sure what is happening but so far i have the following results:
>> i downloaded the latest bleeding edge wireless from
>> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2 
>>
>> I installed kernel headers and build-essentials end run:
>> ./scripts/driver-select rtlwifi
>> make && make install
>>
>> i downloaded the firmware from
>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
>>
>> Running on Ubuntu maverick kernel 2.6.35-30 update 56 i get sometimes an
>> authenticated message when running wpa_supplicant -Dnl80211 -c
>> /etc/wpa_supplicant.conf -i wlan0 but most times it will timeout
>> Running on Ubuntu natty kernel 2.6.38-10 update 46 i always get the
>> authenticated message when running wpa_supplicant -Dnl80211 -c
>> /etc/wpa_supplicant.conf -i wlan0
>>
>> only when using dhcp request on two accespoint i get different 
>> results on the
>> natty driver but that has todo with:
>> https://bugzilla.kernel.org/show_bug.cgi?id=38012 when applied i can 
>> connect two
>> both accespoints.
>>
>> Any ideas why it does not work on the maverick kernel?
>
> How does it work at all with a 2.6.38 kernel? Driver rtl8192cu was not 
> added to the kernel until 2.6 39.
>
sorry for not being clear about this but i also compiled the compat tree 
on this kernel
>> Also when stopping the wpa_supplicant with ctrl+c and restart i first 
>> have to
>> replug the device before it tries todo anything with the card.
>
> What info is in the dmesg output in this case?
>
> To debug the authentication case, run wpa_supplicant with the "-ddd" 
> and "-f wpa_supplicant.log" switches. That way you will get a log of 
> what is going wrong.
>
> Larry


--------------070602050103070004090301
Content-Type: text/x-log;
 name="wpa_supplicant-ubuntu-maverick_cold_boot.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wpa_supplicant-ubuntu-maverick_cold_boot.log"

Initializing interface 'wlan1' conf '/etc/wpa_supplicant_thuis.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant_thuis.conf' -> '/etc/wpa_supplicant_thuis.conf'
Reading configuration file '/etc/wpa_supplicant_thuis.conf'
Line: 1 - start of a new network block
ssid - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='GIGABIT_1000MBPS2'
Initializing interface (2) 'wlan1'
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:a1:b0:89:82:1c
wpa_driver_nl80211_set_wpa
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_countermeasures
wpa_driver_nl80211_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): cc d9 84 e5 b6 62 52 37 80 44 2a 54 bb b0 e0 37
WPS: Build Beacon and Probe Response IEs
WPS:  * Version
WPS:  * Wi-Fi Protected Setup State (0)
WPS:  * Version
WPS:  * Wi-Fi Protected Setup State (0)
WPS:  * Response Type (2)
WPS:  * UUID-E
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Serial Number
WPS:  * Primary Device Type
WPS:  * Device Name
WPS:  * Config Methods (0)
WPS:  * RF Bands (3)
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan1
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan to speed up initial association
Received scan results (0 BSSes)
Cached scan results are empty - not posting
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (2 BSSes)
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2'
Trying to associate with e0:91:f5:7a:ae:d6 (SSID='GIGABIT_1000MBPS2' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_nl80211_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_nl80211_associate
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RSN: Ignored PMKID candidate without preauth flag
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b1a len=33
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8c08 len=181
AssocResp IE wireless event - hexdump(len=165): 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: e0:91:f5:7a:ae:d6
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=e0:91:f5:7a:ae:d6
No keys have been configured - skip key clearing
Associated with e0:91:f5:7a:ae:d6
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 0c 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 0c
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d4
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 0c 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: PMKID from Authenticator - hexdump(len=16): 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: no matching PMKID found
WPA: Renewed SNonce - hexdump(len=32): 87 2a 20 06 cb 49 f2 19 7b fe cf 79 5c 30 7b b4 2f 7c 87 5d 52 b7 c5 ce 28 34 0e 22 bf d0 28 bd
WPA: PTK derivation - A1=00:a1:b0:89:82:1c A2=e0:91:f5:7a:ae:d6
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 0c 87 2a 20 06 cb 49 f2 19 7b fe cf 79 5c 30 7b b4 2f 7c 87 5d 52 b7 c5 ce 28 34 0e 22 bf d0 28 bd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 85 7a 29 c4 c3 66 44 3d db d1 07 df d2 61 30 10 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 0d 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 0d
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d4
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 0d 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: PMKID from Authenticator - hexdump(len=16): 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: no matching PMKID found
WPA: PTK derivation - A1=00:a1:b0:89:82:1c A2=e0:91:f5:7a:ae:d6
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 0d 87 2a 20 06 cb 49 f2 19 7b fe cf 79 5c 30 7b b4 2f 7c 87 5d 52 b7 c5 ce 28 34 0e 22 bf d0 28 bd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e8 e9 89 d2 c0 5a d2 f0 3a 8b 0a 86 c5 e8 81 ea 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
Authentication with e0:91:f5:7a:ae:d6 timed out.
Added BSSID e0:91:f5:7a:ae:d6 into blacklist
wpa_driver_nl80211_disassociate
No keys have been configured - skip key clearing
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
Added BSSID 00:00:00:00:00:00 into blacklist
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0xa7ae28 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=00:00:00:00:00:00
nl80211: set_key failed; err=-2
State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (2 BSSes)
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2'
Trying to associate with e0:91:f5:7a:ae:d6 (SSID='GIGABIT_1000MBPS2' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_nl80211_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_nl80211_associate
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b1a len=33
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8c08 len=181
AssocResp IE wireless event - hexdump(len=165): 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: e0:91:f5:7a:ae:d6
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=e0:91:f5:7a:ae:d6
No keys have been configured - skip key clearing
Associated with e0:91:f5:7a:ae:d6
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 00 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d5
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 00 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: PMKID from Authenticator - hexdump(len=16): 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: no matching PMKID found
WPA: Renewed SNonce - hexdump(len=32): 9d f6 33 cf 7a 53 60 f9 4a b6 f9 5e c5 0d 86 bc ab 26 1c bd 66 b6 9b 03 34 05 3b e8 d1 e1 05 c1
WPA: PTK derivation - A1=00:a1:b0:89:82:1c A2=e0:91:f5:7a:ae:d6
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 00 9d f6 33 cf 7a 53 60 f9 4a b6 f9 5e c5 0d 86 bc ab 26 1c bd 66 b6 9b 03 34 05 3b e8 d1 e1 05 c1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ac 1b ac f5 71 ea cb 56 31 6e 85 5e fb 65 02 8f 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d5
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: PMKID from Authenticator - hexdump(len=16): 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: no matching PMKID found
WPA: PTK derivation - A1=00:a1:b0:89:82:1c A2=e0:91:f5:7a:ae:d6
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 9d f6 33 cf 7a 53 60 f9 4a b6 f9 5e c5 0d 86 bc ab 26 1c bd 66 b6 9b 03 34 05 3b e8 d1 e1 05 c1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 5f 5e bc 6d a4 ad 99 48 b4 3d b5 31 b9 75 63 53 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
Authentication with e0:91:f5:7a:ae:d6 timed out.
BSSID e0:91:f5:7a:ae:d6 blacklist count incremented to 2
wpa_driver_nl80211_disassociate
No keys have been configured - skip key clearing
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:00:00:00:00:00
BSSID 00:00:00:00:00:00 blacklist count incremented to 2
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0xa7ae28 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=00:00:00:00:00:00
nl80211: set_key failed; err=-2
State: SCANNING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
nl80211: Event message available
nl80211: New scan results available
Received scan results (1 BSSes)
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   skip - blacklisted
Try to find non-WPA AP
0: e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   skip - blacklisted
No APs found - clear blacklist and try again
Removed BSSID 00:00:00:00:00:00 from blacklist (clear)
Removed BSSID e0:91:f5:7a:ae:d6 from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2'
Trying to associate with e0:91:f5:7a:ae:d6 (SSID='GIGABIT_1000MBPS2' freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
wpa_driver_nl80211_set_drop_unencrypted
State: DISCONNECTED -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_nl80211_associate
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: External notification - EAP fail=0
EAPOL: External notification - portControl=Auto
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b1a len=33
Authentication with e0:91:f5:7a:ae:d6 timed out.
Added BSSID e0:91:f5:7a:ae:d6 into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No APs found - clear blacklist and try again
Removed BSSID e0:91:f5:7a:ae:d6 from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan1
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
EAPOL: External notification - EAP success=0
wpa_driver_nl80211_set_wpa
wpa_driver_nl80211_set_drop_unencrypted
wpa_driver_nl80211_set_countermeasures
No keys have been configured - skip key clearing
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6

--------------070602050103070004090301
Content-Type: text/x-log;
 name="wpa_supplicant-ubuntu-maverick_ctrlc.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wpa_supplicant-ubuntu-maverick_ctrlc.log"

Initializing interface 'wlan1' conf '/etc/wpa_supplicant_thuis.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant_thuis.conf' -> '/etc/wpa_supplicant_thuis.conf'
Reading configuration file '/etc/wpa_supplicant_thuis.conf'
Line: 1 - start of a new network block
ssid - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='GIGABIT_1000MBPS2'
Initializing interface (2) 'wlan1'
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:a1:b0:89:82:1c
wpa_driver_nl80211_set_wpa
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=0 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=1 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=2 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_key: alg=0 addr=0x470c3c key_idx=3 set_tx=0 seq_len=0 key_len=0
nl80211: set_key failed; err=-67
wpa_driver_nl80211_set_countermeasures
wpa_driver_nl80211_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): cc d9 84 e5 b6 62 52 37 80 44 2a 54 bb b0 e0 37
WPS: Build Beacon and Probe Response IEs
WPS:  * Version
WPS:  * Wi-Fi Protected Setup State (0)
WPS:  * Version
WPS:  * Wi-Fi Protected Setup State (0)
WPS:  * Response Type (2)
WPS:  * UUID-E
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Serial Number
WPS:  * Primary Device Type
WPS:  * Device Name
WPS:  * Config Methods (0)
WPS:  * RF Bands (3)
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan1
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
EAPOL: disable timer tick
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan to speed up initial association
Received scan results (0 BSSes)
Cached scan results are empty - not posting
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
Wireless event: cmd=0x8b19 len=16
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan1
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
wpa_driver_nl80211_set_wpa
wpa_driver_nl80211_set_drop_unencrypted
wpa_driver_nl80211_set_countermeasures
No keys have been configured - skip key clearing
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6

--------------070602050103070004090301
Content-Type: text/x-log;
 name="wpa_supplicant-ubuntu-natty_cold_boot.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wpa_supplicant-ubuntu-natty_cold_boot.log"

Initializing interface 'wlan0' conf '/etc/wpa_supplicant_thuis.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant_thuis.conf' -> '/etc/wpa_supplicant_thuis.conf'
Reading configuration file '/etc/wpa_supplicant_thuis.conf'
Line: 2 - start of a new network block
ssid - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='GIGABIT_1000MBPS2'
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:a1:b0:89:82:1c
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=3 set_tx=0 seq_len=0 key_len=0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): cc d9 84 e5 b6 62 52 37 80 44 2a 54 bb b0 e0 37
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (3 BSSes)
BSS: Start scan result update 1
BSS: Add new id 0 BSSID e0:91:f5:7a:ae:d6 SSID 'GIGABIT_1000MBPS2'
BSS: Add new id 1 BSSID 88:25:2c:bc:be:9b SSID ''
BSS: Add new id 2 BSSID 00:22:3f:10:79:38 SSID 'volley'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2'
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
Trying to authenticate with e0:91:f5:7a:ae:d6 (SSID='GIGABIT_1000MBPS2' freq=2412 MHz)
No keys have been configured - skip key clearing
State: SCANNING -> AUTHENTICATING
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
nl80211: Authenticate (ifindex=3)
  * bssid=e0:91:f5:7a:ae:d6
  * freq=2412
  * SSID - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
  * IEs - hexdump(len=0): [NULL]
  * Auth Type 0
nl80211: Authentication request send successfully
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: MLME event 37
nl80211: MLME event frame - hexdump(len=41): b0 00 3a 01 00 a1 b0 89 82 1c e0 91 f5 7a ae d6 e0 91 f5 7a ae d6 20 0b 00 00 02 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00
SME: Authentication response: peer=e0:91:f5:7a:ae:d6 auth_type=0 status_code=0
SME: Authentication response IEs - hexdump(len=11): dd 09 00 10 18 02 02 f0 04 00 00
Trying to associate with e0:91:f5:7a:ae:d6 (SSID='GIGABIT_1000MBPS2' freq=2412 MHz)
State: AUTHENTICATING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Associate (ifindex=3)
  * bssid=e0:91:f5:7a:ae:d6
  * freq=2412
  * SSID - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
  * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Association request send successfully
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: MLME event 38
nl80211: MLME event frame - hexdump(len=195): 10 00 3a 01 00 a1 b0 89 82 1c e0 91 f5 7a ae d6 e0 91 f5 7a ae d6 30 0b 11 04 00 00 04 c0 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
freq=2412 MHz
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=e0:91:f5:7a:ae:d6
No keys have been configured - skip key clearing
Associated with e0:91:f5:7a:ae:d6
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
nl80211: Event message available
nl80211: Ignore connect event (cmd=46) when using userspace SME
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 00 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d8
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 00 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: PMKID from Authenticator - hexdump(len=16): 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: no matching PMKID found
WPA: Renewed SNonce - hexdump(len=32): 37 6d db 0e b3 52 09 45 bc 9f 4c 55 eb 55 b3 e1 1a 84 5d 49 a8 62 c6 9f cd c8 ef 4b 31 53 42 2a
WPA: PTK derivation - A1=00:a1:b0:89:82:1c A2=e0:91:f5:7a:ae:d6
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 00 37 6d db 0e b3 52 09 45 bc 9f 4c 55 eb 55 b3 e1 1a 84 5d 49 a8 62 c6 9f cd c8 ef 4b 31 53 42 2a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80 8b 16 3f ec 5d 74 14 48 41 38 88 2e f3 14 ad 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 01 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d8 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9 df 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d4 db 32 c3 c2 99 b3 75 1f e5 72 83 ef d1 b6 e2 00 38 bf 0a a4 da 23 5f bc 27 50 80 9f 44 8d 4c 87 4a 84 82 af 57 0e 8f 81 20 a7 6a e3 39 96 e7 1b 26 08 33 c2 34 4e e6 7c 06 ea 96 f3 28 8f bf 0c 37 ea 56 0a 8d 09 31 24 42
IEEE 802.1X RX: version=2 type=3 length=151
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=56
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d8
  key_iv - hexdump(len=16): 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9
  key_rsc - hexdump(len=8): df 05 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): d4 db 32 c3 c2 99 b3 75 1f e5 72 83 ef d1 b6 e2
WPA: RX EAPOL-Key - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 01 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d8 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9 df 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d4 db 32 c3 c2 99 b3 75 1f e5 72 83 ef d1 b6 e2 00 38 bf 0a a4 da 23 5f bc 27 50 80 9f 44 8d 4c 87 4a 84 82 af 57 0e 8f 81 20 a7 6a e3 39 96 e7 1b 26 08 33 c2 34 4e e6 7c 06 ea 96 f3 28 8f bf 0c 37 ea 56 0a 8d 09 31 24 42
RSN: encrypted key data - hexdump(len=56): bf 0a a4 da 23 5f bc 27 50 80 9f 44 8d 4c 87 4a 84 82 af 57 0e 8f 81 20 a7 6a e3 39 96 e7 1b 26 08 33 c2 34 4e e6 7c 06 ea 96 f3 28 8f bf 0c 37 ea 56 0a 8d 09 31 24 42
WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 dd 16 00 0f ac 01 01 00 29 6f 09 48 2c 45 02 3f c9 0f a2 8d 42 22 52 3d dd 00
WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: GTK in EAPOL-Key - hexdump(len=24): [REMOVED]
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 66 c3 21 19 a3 e0 db fe 3d 27 97 e9 1a 39 9d 89 00 00
WPA: Installing PTK to the driver.
wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x9efd1a0 key_idx=0 set_tx=1 seq_len=6 key_len=16
   addr=e0:91:f5:7a:ae:d6
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=18): [REMOVED]
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=16).
WPA: RSC - hexdump(len=6): df 05 00 00 00 00
wpa_driver_nl80211_set_key: ifindex=3 alg=3 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=6 key_len=16
WPA: Key negotiation completed with e0:91:f5:7a:ae:d6 [PTK=CCMP GTK=CCMP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to e0:91:f5:7a:ae:d6 completed (auth) [id=0 id_str=]
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: Supplicant port status: Authorized
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan0
wpa_driver_nl80211_deauthenticate
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x9efa844 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=e0:91:f5:7a:ae:d6
State: COMPLETED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
No keys have been configured - skip key clearing
BSS: Remove id 0 BSSID e0:91:f5:7a:ae:d6 SSID 'GIGABIT_1000MBPS2'
BSS: Remove id 1 BSSID 88:25:2c:bc:be:9b SSID ''
BSS: Remove id 2 BSSID 00:22:3f:10:79:38 SSID 'volley'
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6

--------------070602050103070004090301
Content-Type: text/x-log;
 name="wpa_supplicant-ubuntu-natty_ctrlc.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wpa_supplicant-ubuntu-natty_ctrlc.log"

Initializing interface 'wlan0' conf '/etc/wpa_supplicant_thuis.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant_thuis.conf' -> '/etc/wpa_supplicant_thuis.conf'
Reading configuration file '/etc/wpa_supplicant_thuis.conf'
Line: 2 - start of a new network block
ssid - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='GIGABIT_1000MBPS2'
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:a1:b0:89:82:1c
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 alg=0 addr=0x80e15fc key_idx=3 set_tx=0 seq_len=0 key_len=0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): cc d9 84 e5 b6 62 52 37 80 44 2a 54 bb b0 e0 37
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 1
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 2
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 3
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 4
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 5
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan0
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
No keys have been configured - skip key clearing
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6
Initializing interface 'wlan0' conf '/etc/wpa_supplicant_thuis.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant_thuis.conf' -> '/etc/wpa_supplicant_thuis.conf'
Reading configuration file '/etc/wpa_supplicant_thuis.conf'
Line: 2 - start of a new network block
ssid - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='GIGABIT_1000MBPS2'
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:a1:b0:89:82:1c
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=3 set_tx=0 seq_len=0 key_len=0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): cc d9 84 e5 b6 62 52 37 80 44 2a 54 bb b0 e0 37
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (2 BSSes)
BSS: Start scan result update 1
BSS: Add new id 0 BSSID 00:22:3f:10:79:38 SSID 'volley'
BSS: Add new id 1 BSSID e0:91:f5:7a:ae:d6 SSID 'GIGABIT_1000MBPS2'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:22:3f:10:79:38 ssid='volley' wpa_ie_len=24 rsn_ie_len=0 caps=0x411
   skip - SSID mismatch
1: e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP e0:91:f5:7a:ae:d6 ssid='GIGABIT_1000MBPS2'
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
Trying to authenticate with e0:91:f5:7a:ae:d6 (SSID='GIGABIT_1000MBPS2' freq=2412 MHz)
No keys have been configured - skip key clearing
State: SCANNING -> AUTHENTICATING
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
nl80211: Authenticate (ifindex=4)
  * bssid=e0:91:f5:7a:ae:d6
  * freq=2412
  * SSID - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
  * IEs - hexdump(len=0): [NULL]
  * Auth Type 0
nl80211: Authentication request send successfully
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: MLME event 37
nl80211: MLME event frame - hexdump(len=41): b0 00 3a 01 00 a1 b0 89 82 1c e0 91 f5 7a ae d6 e0 91 f5 7a ae d6 90 05 00 00 02 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00
SME: Authentication response: peer=e0:91:f5:7a:ae:d6 auth_type=0 status_code=0
SME: Authentication response IEs - hexdump(len=11): dd 09 00 10 18 02 02 f0 04 00 00
Trying to associate with e0:91:f5:7a:ae:d6 (SSID='GIGABIT_1000MBPS2' freq=2412 MHz)
State: AUTHENTICATING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Associate (ifindex=4)
  * bssid=e0:91:f5:7a:ae:d6
  * freq=2412
  * SSID - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
  * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Association request send successfully
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: MLME event 38
nl80211: MLME event frame - hexdump(len=195): 10 00 3a 01 00 a1 b0 89 82 1c e0 91 f5 7a ae d6 e0 91 f5 7a ae d6 a0 05 11 04 00 00 04 c0 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Association info event
resp_ies - hexdump(len=165): 01 08 82 84 0b 16 24 30 48 6c 32 04 0c 12 18 60 2d 1a 7e 18 1b ff 00 00 00 01 00 00 00 00 00 96 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 1e 00 90 4c 33 7e 18 1b ff 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 0d 16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
freq=2412 MHz
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=e0:91:f5:7a:ae:d6
No keys have been configured - skip key clearing
Associated with e0:91:f5:7a:ae:d6
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
nl80211: Event message available
nl80211: Ignore connect event (cmd=46) when using userspace SME
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 02 03 00 75 02 00 8a 00 10 00 00 00 00 00 00 00 01 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: PMKID from Authenticator - hexdump(len=16): 82 90 f9 f8 bf b8 00 da 47 ce 80 66 3d 01 4d 6b
RSN: no matching PMKID found
WPA: Renewed SNonce - hexdump(len=32): 22 fb 6b 50 8a f1 88 da 51 f2 eb 61 72 a4 b1 a1 ea 21 a6 6d 6d 1a 88 8c 25 64 05 31 5b f3 1d bf
WPA: PTK derivation - A1=00:a1:b0:89:82:1c A2=e0:91:f5:7a:ae:d6
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 22 fb 6b 50 8a f1 88 da 51 f2 eb 61 72 a4 b1 a1 ea 21 a6 6d 6d 1a 88 8c 25 64 05 31 5b f3 1d bf 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c6 b4 77 1f 95 a5 d0 eb f9 fc 57 66 69 1b 51 d8 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from e0:91:f5:7a:ae:d6
RX EAPOL - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 02 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 da e5 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ef 49 73 34 23 25 10 e8 bb 38 f4 d5 13 8a 74 e4 00 38 f6 87 7e d1 67 ed 93 8b 58 c2 67 4e f8 78 13 fa a1 33 94 f5 95 55 a4 f2 53 9e 6a e2 4c 29 a8 76 da 05 20 d3 02 3b 80 1a c1 0c f7 e6 aa 27 45 1c 9c 6b 6c a8 29 30 af 37
IEEE 802.1X RX: version=2 type=3 length=151
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
  key_length=16 key_data_length=56
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9
  key_iv - hexdump(len=16): 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 da
  key_rsc - hexdump(len=8): e5 05 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): ef 49 73 34 23 25 10 e8 bb 38 f4 d5 13 8a 74 e4
WPA: RX EAPOL-Key - hexdump(len=155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 00 00 02 18 dc b4 aa 7f dd 61 85 06 b5 21 4e 03 78 ee 93 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 d9 7a cd 10 95 03 ef 09 78 ee 6e ba eb 7f 82 04 da e5 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ef 49 73 34 23 25 10 e8 bb 38 f4 d5 13 8a 74 e4 00 38 f6 87 7e d1 67 ed 93 8b 58 c2 67 4e f8 78 13 fa a1 33 94 f5 95 55 a4 f2 53 9e 6a e2 4c 29 a8 76 da 05 20 d3 02 3b 80 1a c1 0c f7 e6 aa 27 45 1c 9c 6b 6c a8 29 30 af 37
RSN: encrypted key data - hexdump(len=56): f6 87 7e d1 67 ed 93 8b 58 c2 67 4e f8 78 13 fa a1 33 94 f5 95 55 a4 f2 53 9e 6a e2 4c 29 a8 76 da 05 20 d3 02 3b 80 1a c1 0c f7 e6 aa 27 45 1c 9c 6b 6c a8 29 30 af 37
WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from e0:91:f5:7a:ae:d6 (ver=2)
WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 dd 16 00 0f ac 01 01 00 29 6f 09 48 2c 45 02 3f c9 0f a2 8d 42 22 52 3d dd 00
WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: GTK in EAPOL-Key - hexdump(len=24): [REMOVED]
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f6 32 87 f4 77 44 79 37 c8 79 e6 3b 23 9f f9 74 00 00
WPA: Installing PTK to the driver.
wpa_driver_nl80211_set_key: ifindex=4 alg=3 addr=0x99151a0 key_idx=0 set_tx=1 seq_len=6 key_len=16
   addr=e0:91:f5:7a:ae:d6
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=18): [REMOVED]
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=1 tx=0 len=16).
WPA: RSC - hexdump(len=6): e5 05 00 00 00 00
wpa_driver_nl80211_set_key: ifindex=4 alg=3 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=6 key_len=16
WPA: Key negotiation completed with e0:91:f5:7a:ae:d6 [PTK=CCMP GTK=CCMP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to e0:91:f5:7a:ae:d6 completed (auth) [id=0 id_str=]
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: Supplicant port status: Authorized
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
BSS: Expire BSS 0 due to age
BSS: Remove id 0 BSSID 00:22:3f:10:79:38 SSID 'volley'
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan0
wpa_driver_nl80211_deauthenticate
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x9912844 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=e0:91:f5:7a:ae:d6
State: COMPLETED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
No keys have been configured - skip key clearing
BSS: Remove id 1 BSSID e0:91:f5:7a:ae:d6 SSID 'GIGABIT_1000MBPS2'
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6
Initializing interface 'wlan0' conf '/etc/wpa_supplicant_thuis.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant_thuis.conf' -> '/etc/wpa_supplicant_thuis.conf'
Reading configuration file '/etc/wpa_supplicant_thuis.conf'
Line: 2 - start of a new network block
ssid - hexdump_ascii(len=17):
     47 49 47 41 42 49 54 5f 31 30 30 30 4d 42 50 53   GIGABIT_1000MBPS
     32                                                2               
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='GIGABIT_1000MBPS2'
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:a1:b0:89:82:1c
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e15fc key_idx=3 set_tx=0 seq_len=0 key_len=0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): cc d9 84 e5 b6 62 52 37 80 44 2a 54 bb b0 e0 37
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 1
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 2
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 3
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 4
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 5
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (0 BSSes)
BSS: Start scan result update 6
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable network found
Setting scan request: 5 sec 0 usec
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added

--------------070602050103070004090301--
