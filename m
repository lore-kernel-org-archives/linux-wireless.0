Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50013 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2IBKeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 06:34:18 -0400
Received: by weyx8 with SMTP id x8so2446421wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 03:34:17 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 12:34:17 +0200
Message-ID: <CA+tDD0Kz4vR1AKWZPj+h9pF9jA25ZkXS=3g+zf8epdPLdizCMA@mail.gmail.com> (sfid-20120902_123423_333157_59D25F38)
Subject: ath9k connection issues
From: Sebastiano Degan <sebdeg87@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I'd like to report a bug probably regarding the ath9k driver, I've
tried several distributions (Ubuntu, Opensuse and Fedora) and the
issue is the same in all of them.
________________________________________________________________________________________________________
INFO ABOUT THE SYSTEM:
# uname -r
3.5.2-3.fc17.x86_64

# lsmod | grep ath
ath9k                 131258  0
ath9k_common           13602  1 ath9k
ath9k_hw              389880  2 ath9k_common,ath9k
ath                    23103  3 ath9k_common,ath9k,ath9k_hw
mac80211              521833  1 ath9k
cfg80211              192203  3 ath,ath9k,mac80211

# lspci -vv | grep AR5008 -A8
07:03.0 Network controller: Atheros Communications Inc. AR5008
Wireless Network Adapter (rev 01)
	Subsystem: Atheros Communications Inc. Device 3079
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fbef0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] #80 [0000]
	Kernel driver in use: ath9k
__________________________________________________________________________________________________________

__________________________________________________________________________________________________________
BUG DESCRIPTION:


Case 1 -  Network Manager Enabled + DHCP

The card seems to associate without any problem to the network, which
is protected with WPA2/PSK, but when it comes to getting an IP address
the problem arise.
The IP address is never obtained or obtained after a long time (20-30 seconds).

This is the output of dmesg while trying to connect using NetworkManager:

[   64.232992] cfg80211: Calling CRDA to update world regulatory domain
[   64.242596] cfg80211: World regulatory domain updated:
[   64.242600] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   64.242603] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   64.242606] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   64.242609] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   64.242612] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   64.242614] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   64.242631] cfg80211: Calling CRDA for country: IT
[   64.246335] cfg80211: Regulatory domain changed to country: IT
[   64.246338] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   64.246342] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[   64.246344] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[   64.246347] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[   64.246349] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(N/A, 2700 mBm)
[   67.792972] wlan0: authenticate with 00:21:91:e1:8f:03
[   67.796241] wlan0: send auth to 00:21:91:e1:8f:03 (try 1/3)
[   67.821502] wlan0: authenticated
[   67.824204] wlan0: associate with 00:21:91:e1:8f:03 (try 1/3)
[   67.848564] wlan0: RX AssocResp from 00:21:91:e1:8f:03 (capab=0x411
status=0 aid=2)
[   67.848652] wlan0: associated
[  113.098861] wlan0: deauthenticating from 00:21:91:e1:8f:03 by local
choice (reason=3)

And this just keeps repeating until NetworkManager gives up.


Case 2 -  Network Manager Disbled + DHCP

The card seems to associate without any problem to the network, which
is protected with WPA2/PSK, but when it comes to getting an IP address
the problem arise.
The IP address is obtained  with higher probability, but still after a
long time (20-30 seconds).


Case 3 -  Network Manager Disbled + No DHCP

This is the fastest way I currently have to get the connection up and running:

1) Connect using wpa_supplicant
2) Fix ip address
3) Start pinging the address of the router

After a few "Destination Host Unreachable", I get some replies and the
connection starts to work


In all three cases, once the connection is up it appears to be stable
and provides good performances, at least for what concerns web
browsing.
____________________________________________________________________________________________________________
