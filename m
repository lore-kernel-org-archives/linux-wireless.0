Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:41791 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab3BNK4H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 05:56:07 -0500
Message-ID: <511CC175.9080702@neratec.com> (sfid-20130214_115613_603906_A0E0C146)
Date: Thu, 14 Feb 2013 11:50:29 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2] mac80211: fix auth/assoc timeout handling
References: <1360834178-11599-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1360834178-11599-1-git-send-email-johannes@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------080809040305050807050805"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080809040305050807050805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I am getting some disconnections becasue of failed
nullfunc in my ath9k ap+sta test setup. The auth/assoc
don't timeout but nullfunc does.

I have checked in wireshark and all nullfunc were
properly acknowledged.
Attached syslog + iw event.

Do you have any idea where it comes from or should
I start looking at it?

Wojtek
> From: Johannes Berg <johannes.berg@intel.com>
>
> In my commit 1672c0e31917f49d31d30d79067103432bc20cc7
> ("mac80211: start auth/assoc timeout on frame status")
> I broke auth/assoc timeout handling: in case we wait
> for the TX status, it now leaves the timeout field set
> to 0, which is a valid time and can compare as being
> before now ("jiffies"). Thus, if the work struct runs
> for some other reason, the auth/assoc is treated as
> having timed out.
>
> Fix this by introducing a separate "timeout_started"
> variable that tracks whether the timeout has started
> and is checked before timing out.
>
> Additionally, for proper TX status handling the change
> requires that the skb->dev pointer is set up for all
> the frames, so set it up for all frames in mac80211.
>

--------------080809040305050807050805
Content-Type: text/plain; charset=UTF-8;
 name="test.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test.txt"

*syslog*
Feb 14 11:30:19 wlanTS kernel: [ 1427.514016] device wlan1 entered promiscuous mode
Feb 14 11:30:19 wlanTS kernel: [ 1427.519694] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
Feb 14 11:30:19 wlanTS kernel: [ 1427.537230] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
Feb 14 11:30:19 wlanTS kernel: [ 1427.537249] wlan_br: port 1(wlan1) entered forwarding state
Feb 14 11:30:19 wlanTS kernel: [ 1427.537252] wlan_br: port 1(wlan1) entered forwarding state
Feb 14 11:30:24 wlanTS kernel: [ 1432.517595] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Feb 14 11:30:27 wlanTS kernel: [ 1435.027343] wlan0: authenticate with 04:f0:21:02:46:46
Feb 14 11:30:27 wlanTS kernel: [ 1435.027350] wlan0: Allocated STA 04:f0:21:02:46:46
Feb 14 11:30:27 wlanTS kernel: [ 1435.029871] ath: phy0: unsupported hw bitrate detected 0x1b using 1 Mbit
Feb 14 11:30:27 wlanTS kernel: [ 1435.053186] wlan0: Inserted STA 04:f0:21:02:46:46
Feb 14 11:30:27 wlanTS kernel: [ 1435.053261] wlan0: direct probe to 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:30:27 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: authenticated
Feb 14 11:30:27 wlanTS kernel: [ 1435.175960] wlan0: send auth to 04:f0:21:02:46:46 (try 2/3)
Feb 14 11:30:27 wlanTS kernel: [ 1435.177161] wlan0: authenticated
Feb 14 11:30:27 wlanTS kernel: [ 1435.177166] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:30:27 wlanTS kernel: [ 1435.177558] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
Feb 14 11:30:27 wlanTS kernel: [ 1435.177562] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
Feb 14 11:30:27 wlanTS kernel: [ 1435.179950] wlan0: associate with 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:30:27 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: associated (aid 1)
Feb 14 11:30:27 wlanTS kernel: [ 1435.180741] wlan1: Allocated STA 04:f0:21:02:46:45
Feb 14 11:30:27 wlanTS kernel: [ 1435.180745] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:30:27 wlanTS kernel: [ 1435.180746] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:30:27 wlanTS kernel: [ 1435.180808] wlan1: Inserted STA 04:f0:21:02:46:45
Feb 14 11:30:27 wlanTS kernel: [ 1435.182769] wlan0: RX AssocResp from 04:f0:21:02:46:46 (capab=0x11 status=0 aid=1)
Feb 14 11:30:27 wlanTS kernel: [ 1435.182790] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:30:27 wlanTS kernel: [ 1435.182820] wlan0: associated
Feb 14 11:30:27 wlanTS kernel: [ 1435.183240] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Feb 14 11:30:27 wlanTS kernel: [ 1435.188416] wlan0: dropped frame to 04:f0:21:02:46:46 (unauthorized port)
Feb 14 11:30:27 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 RADIUS: starting accounting session 511CBCBB-00000000
Feb 14 11:30:27 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 WPA: pairwise key handshake completed (RSN)
Feb 14 11:30:27 wlanTS kernel: [ 1435.192105] wlan0: moving STA 04:f0:21:02:46:46 to state 4
Feb 14 11:30:27 wlanTS kernel: [ 1435.192604] wlan1: moving STA 04:f0:21:02:46:45 to state 4
Feb 14 11:30:34 wlanTS kernel: [ 1442.494154] wlan_br: port 1(wlan1) entered forwarding state
Feb 14 11:31:08 wlanTS kernel: [ 1476.219242] wlan0: Failed to send nullfunc to AP 04:f0:21:02:46:46 after 500ms, disconnecting
Feb 14 11:31:08 wlanTS kernel: [ 1476.219282] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:31:08 wlanTS kernel: [ 1476.219285] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:31:08 wlanTS kernel: [ 1476.219288] wlan0: moving STA 04:f0:21:02:46:46 to state 1
Feb 14 11:31:08 wlanTS kernel: [ 1476.219290] wlan0: Removed STA 04:f0:21:02:46:46
Feb 14 11:31:08 wlanTS kernel: [ 1476.450611] cfg80211: Calling CRDA to update world regulatory domain
Feb 14 11:31:08 wlanTS kernel: [ 1476.453987] wlan0: Destroyed STA 04:f0:21:02:46:46
Feb 14 11:31:08 wlanTS kernel: [ 1476.458539] cfg80211: World regulatory domain updated:
Feb 14 11:31:08 wlanTS kernel: [ 1476.458543] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 14 11:31:08 wlanTS kernel: [ 1476.458545] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:31:08 wlanTS kernel: [ 1476.458547] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:31:08 wlanTS kernel: [ 1476.458549] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:31:08 wlanTS kernel: [ 1476.458551] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:31:08 wlanTS kernel: [ 1476.458552] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:31:11 wlanTS kernel: [ 1478.964309] wlan0: authenticate with 04:f0:21:02:46:46
Feb 14 11:31:11 wlanTS kernel: [ 1478.964315] wlan0: Allocated STA 04:f0:21:02:46:46
Feb 14 11:31:11 wlanTS kernel: [ 1478.964697] wlan0: Inserted STA 04:f0:21:02:46:46
Feb 14 11:31:11 wlanTS kernel: [ 1478.964701] wlan0: send auth to 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:31:11 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: authenticated
Feb 14 11:31:11 wlanTS kernel: [ 1479.001453] wlan0: authenticated
Feb 14 11:31:11 wlanTS kernel: [ 1479.001458] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:31:11 wlanTS kernel: [ 1479.001811] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
Feb 14 11:31:11 wlanTS kernel: [ 1479.001815] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
Feb 14 11:31:11 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: associated (aid 1)
Feb 14 11:31:11 wlanTS kernel: [ 1479.005571] wlan0: associate with 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:31:11 wlanTS kernel: [ 1479.008102] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:31:11 wlanTS kernel: [ 1479.008106] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:31:11 wlanTS kernel: [ 1479.008121] wlan1: moving STA 04:f0:21:02:46:45 to state 1
Feb 14 11:31:11 wlanTS kernel: [ 1479.008123] wlan1: Removed STA 04:f0:21:02:46:45
Feb 14 11:31:11 wlanTS kernel: [ 1479.008335] wlan1: Allocated STA 04:f0:21:02:46:45
Feb 14 11:31:11 wlanTS kernel: [ 1479.008338] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:31:11 wlanTS kernel: [ 1479.008340] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:31:11 wlanTS kernel: [ 1479.008341] wlan1: moving STA 04:f0:21:02:46:45 to state 4
Feb 14 11:31:11 wlanTS kernel: [ 1479.008462] wlan0: RX AssocResp from 04:f0:21:02:46:46 (capab=0x11 status=0 aid=1)
Feb 14 11:31:11 wlanTS kernel: [ 1479.008483] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:31:11 wlanTS kernel: [ 1479.008518] wlan0: associated
Feb 14 11:31:11 wlanTS kernel: [ 1479.008527] wlan1: Inserted STA 04:f0:21:02:46:45
Feb 14 11:31:11 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 RADIUS: starting accounting session 511CBCBB-00000000
Feb 14 11:31:11 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 WPA: pairwise key handshake completed (RSN)
Feb 14 11:31:11 wlanTS kernel: [ 1479.014747] wlan1: Destroyed STA 04:f0:21:02:46:45
Feb 14 11:31:11 wlanTS kernel: [ 1479.016048] wlan0: moving STA 04:f0:21:02:46:46 to state 4
Feb 14 11:32:13 wlanTS kernel: [ 1540.887190] wlan0: Failed to send nullfunc to AP 04:f0:21:02:46:46 after 500ms, disconnecting
Feb 14 11:32:13 wlanTS kernel: [ 1540.887227] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:32:13 wlanTS kernel: [ 1540.887230] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:32:13 wlanTS kernel: [ 1540.887233] wlan0: moving STA 04:f0:21:02:46:46 to state 1
Feb 14 11:32:13 wlanTS kernel: [ 1540.887235] wlan0: Removed STA 04:f0:21:02:46:46
Feb 14 11:32:13 wlanTS kernel: [ 1541.117865] cfg80211: Calling CRDA to update world regulatory domain
Feb 14 11:32:13 wlanTS kernel: [ 1541.125896] cfg80211: World regulatory domain updated:
Feb 14 11:32:13 wlanTS kernel: [ 1541.125900] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 14 11:32:13 wlanTS kernel: [ 1541.125902] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:32:13 wlanTS kernel: [ 1541.125904] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:32:13 wlanTS kernel: [ 1541.125906] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:32:13 wlanTS kernel: [ 1541.125907] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:32:13 wlanTS kernel: [ 1541.125909] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:32:13 wlanTS kernel: [ 1541.127328] wlan0: Destroyed STA 04:f0:21:02:46:46
Feb 14 11:32:16 wlanTS kernel: [ 1543.628244] wlan0: authenticate with 04:f0:21:02:46:46
Feb 14 11:32:16 wlanTS kernel: [ 1543.628250] wlan0: Allocated STA 04:f0:21:02:46:46
Feb 14 11:32:16 wlanTS kernel: [ 1543.628629] wlan0: Inserted STA 04:f0:21:02:46:46
Feb 14 11:32:16 wlanTS kernel: [ 1543.628634] wlan0: send auth to 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:32:16 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: authenticated
Feb 14 11:32:16 wlanTS kernel: [ 1543.665830] wlan0: authenticated
Feb 14 11:32:16 wlanTS kernel: [ 1543.665836] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:32:16 wlanTS kernel: [ 1543.666182] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
Feb 14 11:32:16 wlanTS kernel: [ 1543.666186] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
Feb 14 11:32:16 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: associated (aid 1)
Feb 14 11:32:16 wlanTS kernel: [ 1543.669541] wlan0: associate with 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:32:16 wlanTS kernel: [ 1543.672013] wlan0: RX AssocResp from 04:f0:21:02:46:46 (capab=0x11 status=0 aid=1)
Feb 14 11:32:16 wlanTS kernel: [ 1543.672070] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:32:16 wlanTS kernel: [ 1543.672111] wlan0: associated
Feb 14 11:32:16 wlanTS kernel: [ 1543.673774] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:32:16 wlanTS kernel: [ 1543.673777] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:32:16 wlanTS kernel: [ 1543.673783] wlan1: moving STA 04:f0:21:02:46:45 to state 1
Feb 14 11:32:16 wlanTS kernel: [ 1543.673784] wlan1: Removed STA 04:f0:21:02:46:45
Feb 14 11:32:16 wlanTS kernel: [ 1543.673991] wlan1: Allocated STA 04:f0:21:02:46:45
Feb 14 11:32:16 wlanTS kernel: [ 1543.673994] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:32:16 wlanTS kernel: [ 1543.673995] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:32:16 wlanTS kernel: [ 1543.673997] wlan1: moving STA 04:f0:21:02:46:45 to state 4
Feb 14 11:32:16 wlanTS kernel: [ 1543.674118] wlan1: Inserted STA 04:f0:21:02:46:45
Feb 14 11:32:16 wlanTS kernel: [ 1543.678414] wlan1: Destroyed STA 04:f0:21:02:46:45
Feb 14 11:32:16 wlanTS kernel: [ 1543.681149] wlan0: moving STA 04:f0:21:02:46:46 to state 4
Feb 14 11:32:16 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 RADIUS: starting accounting session 511CBCBB-00000000
Feb 14 11:32:16 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 WPA: pairwise key handshake completed (RSN)
Feb 14 11:33:18 wlanTS kernel: [ 1605.682681] wlan0: Failed to send nullfunc to AP 04:f0:21:02:46:46 after 500ms, disconnecting
Feb 14 11:33:18 wlanTS kernel: [ 1605.682720] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:33:18 wlanTS kernel: [ 1605.682722] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:33:18 wlanTS kernel: [ 1605.682726] wlan0: moving STA 04:f0:21:02:46:46 to state 1
Feb 14 11:33:18 wlanTS kernel: [ 1605.682728] wlan0: Removed STA 04:f0:21:02:46:46
Feb 14 11:33:18 wlanTS kernel: [ 1605.918105] cfg80211: Calling CRDA to update world regulatory domain
Feb 14 11:33:18 wlanTS kernel: [ 1605.925249] cfg80211: World regulatory domain updated:
Feb 14 11:33:18 wlanTS kernel: [ 1605.925252] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 14 11:33:18 wlanTS kernel: [ 1605.925255] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:33:18 wlanTS kernel: [ 1605.925257] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:33:18 wlanTS kernel: [ 1605.925259] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:33:18 wlanTS kernel: [ 1605.925260] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:33:18 wlanTS kernel: [ 1605.925262] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:33:18 wlanTS kernel: [ 1605.925407] wlan0: Destroyed STA 04:f0:21:02:46:46
Feb 14 11:33:21 wlanTS kernel: [ 1608.431737] wlan0: authenticate with 04:f0:21:02:46:46
Feb 14 11:33:21 wlanTS kernel: [ 1608.431744] wlan0: Allocated STA 04:f0:21:02:46:46
Feb 14 11:33:21 wlanTS kernel: [ 1608.432125] wlan0: Inserted STA 04:f0:21:02:46:46
Feb 14 11:33:21 wlanTS kernel: [ 1608.432129] wlan0: send auth to 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:33:21 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: authenticated
Feb 14 11:33:21 wlanTS kernel: [ 1608.468692] wlan0: authenticated
Feb 14 11:33:21 wlanTS kernel: [ 1608.468697] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:33:21 wlanTS kernel: [ 1608.469211] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
Feb 14 11:33:21 wlanTS kernel: [ 1608.469226] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
Feb 14 11:33:21 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: associated (aid 1)
Feb 14 11:33:21 wlanTS kernel: [ 1608.472968] wlan0: associate with 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:33:21 wlanTS kernel: [ 1608.475249] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:33:21 wlanTS kernel: [ 1608.475257] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:33:21 wlanTS kernel: [ 1608.475262] wlan1: moving STA 04:f0:21:02:46:45 to state 1
Feb 14 11:33:21 wlanTS kernel: [ 1608.475264] wlan1: Removed STA 04:f0:21:02:46:45
Feb 14 11:33:21 wlanTS kernel: [ 1608.475476] wlan1: Allocated STA 04:f0:21:02:46:45
Feb 14 11:33:21 wlanTS kernel: [ 1608.475479] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:33:21 wlanTS kernel: [ 1608.475481] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:33:21 wlanTS kernel: [ 1608.475483] wlan1: moving STA 04:f0:21:02:46:45 to state 4
Feb 14 11:33:21 wlanTS kernel: [ 1608.475611] wlan1: Inserted STA 04:f0:21:02:46:45
Feb 14 11:33:21 wlanTS kernel: [ 1608.476320] wlan0: RX AssocResp from 04:f0:21:02:46:46 (capab=0x11 status=0 aid=1)
Feb 14 11:33:21 wlanTS kernel: [ 1608.476354] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:33:21 wlanTS kernel: [ 1608.476385] wlan0: associated
Feb 14 11:33:21 wlanTS kernel: [ 1608.482778] wlan1: Destroyed STA 04:f0:21:02:46:45
Feb 14 11:33:21 wlanTS kernel: [ 1608.483876] wlan0: moving STA 04:f0:21:02:46:46 to state 4
Feb 14 11:33:21 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 RADIUS: starting accounting session 511CBCBB-00000000
Feb 14 11:33:21 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 WPA: pairwise key handshake completed (RSN)
Feb 14 11:34:23 wlanTS kernel: [ 1670.478367] wlan0: Failed to send nullfunc to AP 04:f0:21:02:46:46 after 500ms, disconnecting
Feb 14 11:34:23 wlanTS kernel: [ 1670.478404] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:34:23 wlanTS kernel: [ 1670.478406] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:34:23 wlanTS kernel: [ 1670.478410] wlan0: moving STA 04:f0:21:02:46:46 to state 1
Feb 14 11:34:23 wlanTS kernel: [ 1670.478412] wlan0: Removed STA 04:f0:21:02:46:46
Feb 14 11:34:23 wlanTS kernel: [ 1670.708096] cfg80211: Calling CRDA to update world regulatory domain
Feb 14 11:34:23 wlanTS kernel: [ 1670.711647] wlan0: Destroyed STA 04:f0:21:02:46:46
Feb 14 11:34:23 wlanTS kernel: [ 1670.715430] cfg80211: World regulatory domain updated:
Feb 14 11:34:23 wlanTS kernel: [ 1670.715433] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Feb 14 11:34:23 wlanTS kernel: [ 1670.715435] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:34:23 wlanTS kernel: [ 1670.715437] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:34:23 wlanTS kernel: [ 1670.715439] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:34:23 wlanTS kernel: [ 1670.715440] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:34:23 wlanTS kernel: [ 1670.715442] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Feb 14 11:34:26 wlanTS kernel: [ 1673.219262] wlan0: authenticate with 04:f0:21:02:46:46
Feb 14 11:34:26 wlanTS kernel: [ 1673.219268] wlan0: Allocated STA 04:f0:21:02:46:46
Feb 14 11:34:26 wlanTS kernel: [ 1673.219648] wlan0: Inserted STA 04:f0:21:02:46:46
Feb 14 11:34:26 wlanTS kernel: [ 1673.219653] wlan0: send auth to 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:34:26 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: authenticated
Feb 14 11:34:26 wlanTS kernel: [ 1673.255916] wlan0: authenticated
Feb 14 11:34:26 wlanTS kernel: [ 1673.255921] wlan0: moving STA 04:f0:21:02:46:46 to state 2
Feb 14 11:34:26 wlanTS kernel: [ 1673.256256] ath9k 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
Feb 14 11:34:26 wlanTS kernel: [ 1673.256260] ath9k 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
Feb 14 11:34:26 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 802.11: associated (aid 1)
Feb 14 11:34:26 wlanTS kernel: [ 1673.256644] wlan0: associate with 04:f0:21:02:46:46 (try 1/3)
Feb 14 11:34:26 wlanTS kernel: [ 1673.258627] wlan0: RX AssocResp from 04:f0:21:02:46:46 (capab=0x11 status=0 aid=1)
Feb 14 11:34:26 wlanTS kernel: [ 1673.258687] wlan0: moving STA 04:f0:21:02:46:46 to state 3
Feb 14 11:34:26 wlanTS kernel: [ 1673.258718] wlan0: associated
Feb 14 11:34:26 wlanTS kernel: [ 1673.260222] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:34:26 wlanTS kernel: [ 1673.260225] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:34:26 wlanTS kernel: [ 1673.260230] wlan1: moving STA 04:f0:21:02:46:45 to state 1
Feb 14 11:34:26 wlanTS kernel: [ 1673.260232] wlan1: Removed STA 04:f0:21:02:46:45
Feb 14 11:34:26 wlanTS kernel: [ 1673.260727] wlan1: Allocated STA 04:f0:21:02:46:45
Feb 14 11:34:26 wlanTS kernel: [ 1673.260730] wlan1: moving STA 04:f0:21:02:46:45 to state 2
Feb 14 11:34:26 wlanTS kernel: [ 1673.260732] wlan1: moving STA 04:f0:21:02:46:45 to state 3
Feb 14 11:34:26 wlanTS kernel: [ 1673.260733] wlan1: moving STA 04:f0:21:02:46:45 to state 4
Feb 14 11:34:26 wlanTS kernel: [ 1673.260859] wlan1: Inserted STA 04:f0:21:02:46:45
Feb 14 11:34:26 wlanTS kernel: [ 1673.266900] wlan1: Destroyed STA 04:f0:21:02:46:45
Feb 14 11:34:26 wlanTS kernel: [ 1673.268209] wlan0: moving STA 04:f0:21:02:46:46 to state 4
Feb 14 11:34:26 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 RADIUS: starting accounting session 511CBCBB-00000000
Feb 14 11:34:26 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 WPA: pairwise key handshake completed (RSN)


*iw event *
1360837824.782001: wlan0 (phy #0): scan started
1360837827.197135: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360837827.222965: wlan0: new station 04:f0:21:02:46:46
1360837827.245281: wlan1 (phy #1): mgmt TX status (cookie ffff8801a7c37800): acked
1360837827.347002: wlan1 (phy #1): mgmt TX status (cookie ffff8801a7c37800): acked
1360837827.347515: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 e0 1e 00 00 02 00 00 00]
1360837827.350804: wlan1 (phy #1): mgmt TX status (cookie ffff880210c8cc00): acked
1360837827.353163: wlan1: new station 04:f0:21:02:46:45
1360837827.353189: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 f0 1e 11 00 00 00 01 c0 01 02 b0 c8]
1360837827.353214: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360837868.034432: wlan0 (phy #0): CQM event: Beacon loss detected
1360837868.534439: wlan0: del station 04:f0:21:02:46:46
1360837868.762937: wlan0 (phy #0): deauth 04:f0:21:02:46:45 -> 04:f0:21:02:46:46 reason 4: Disassociated due to inactivity [frame: c0 00 00 00 04 f0 21 02 46 46 04 f0 21 02 46 45 04 f0 21 02 46 46 00 00 04 00]
1360837868.763084: wlan0 (phy #0): disconnected (local request)
1360837868.774498: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
1360837868.870692: wlan0 (phy #0): scan started
1360837871.289040: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360837871.289638: wlan0: new station 04:f0:21:02:46:46
1360837871.325435: wlan1 (phy #1): mgmt TX status (cookie ffff880212789d00): acked
1360837871.326573: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 d0 d0 00 00 02 00 00 00]
1360837871.331876: wlan1 (phy #1): mgmt TX status (cookie ffff880201d19b00): acked
1360837871.333073: wlan1: del station 04:f0:21:02:46:45
1360837871.333412: wlan1: new station 04:f0:21:02:46:45
1360837871.333987: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 e0 d0 11 00 00 00 01 c0 01 02 b0 c8]
1360837871.334149: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360837901.954414: wlan0 (phy #0): CQM event: Beacon loss detected
1360837932.930397: wlan0 (phy #0): CQM event: Beacon loss detected
1360837933.430426: wlan0: del station 04:f0:21:02:46:46
1360837933.658384: wlan0 (phy #0): deauth 04:f0:21:02:46:45 -> 04:f0:21:02:46:46 reason 4: Disassociated due to inactivity [frame: c0 00 00 00 04 f0 21 02 46 46 04 f0 21 02 46 45 04 f0 21 02 46 46 00 00 04 00]
1360837933.658525: wlan0 (phy #0): disconnected (local request)
1360837933.669905: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
1360837933.766132: wlan0 (phy #0): scan started
1360837936.181010: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360837936.181614: wlan0: new station 04:f0:21:02:46:46
1360837936.218111: wlan1 (phy #1): mgmt TX status (cookie ffff880202195c00): acked
1360837936.218979: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 30 d6 00 00 02 00 00 00]
1360837936.224440: wlan1 (phy #1): mgmt TX status (cookie ffff880211cbbd00): acked
1360837936.225408: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 50 d6 11 00 00 00 01 c0 01 02 b0 c8]
1360837936.225577: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360837936.226777: wlan1: del station 04:f0:21:02:46:45
1360837936.227041: wlan1: new station 04:f0:21:02:46:45
1360837966.978405: wlan0 (phy #0): CQM event: Beacon loss detected
1360837997.954416: wlan0 (phy #0): CQM event: Beacon loss detected
1360837998.454423: wlan0: del station 04:f0:21:02:46:46
1360837998.687007: wlan0 (phy #0): deauth 04:f0:21:02:46:45 -> 04:f0:21:02:46:46 reason 4: Disassociated due to inactivity [frame: c0 00 00 00 04 f0 21 02 46 46 04 f0 21 02 46 45 04 f0 21 02 46 46 00 00 04 00]
1360837998.687147: wlan0 (phy #0): disconnected (local request)
1360837998.697906: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
1360837998.794785: wlan0 (phy #0): scan started
1360838001.213030: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360838001.213614: wlan0: new station 04:f0:21:02:46:46
1360838001.249634: wlan1 (phy #1): mgmt TX status (cookie ffff880212789700): acked
1360838001.250522: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 00 dc 00 00 02 00 00 00]
1360838001.255590: wlan1 (phy #1): mgmt TX status (cookie ffff880212789a00): acked
1360838001.256773: wlan1: del station 04:f0:21:02:46:45
1360838001.257055: wlan1: new station 04:f0:21:02:46:45
1360838001.259393: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 10 dc 11 00 00 00 01 c0 01 02 b0 c8]
1360838001.259576: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360838032.002412: wlan0 (phy #0): CQM event: Beacon loss detected
1360838062.978416: wlan0 (phy #0): CQM event: Beacon loss detected
1360838063.478664: wlan0: del station 04:f0:21:02:46:46
1360838063.705487: wlan0 (phy #0): deauth 04:f0:21:02:46:45 -> 04:f0:21:02:46:46 reason 4: Disassociated due to inactivity [frame: c0 00 00 00 04 f0 21 02 46 46 04 f0 21 02 46 45 04 f0 21 02 46 46 00 00 04 00]
1360838063.705626: wlan0 (phy #0): disconnected (local request)
1360838063.716681: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
1360838063.813230: wlan0 (phy #0): scan started
1360838066.229024: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360838066.229619: wlan0: new station 04:f0:21:02:46:46
1360838066.265360: wlan1 (phy #1): mgmt TX status (cookie ffff8802021df100): acked
1360838066.266046: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 d0 e1 00 00 02 00 00 00]
1360838066.268056: wlan1 (phy #1): mgmt TX status (cookie ffff8801fee65800): acked
1360838066.269026: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 e0 e1 11 00 00 00 01 c0 01 02 b0 c8]
1360838066.269118: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360838066.270202: wlan1: del station 04:f0:21:02:46:45
1360838066.270765: wlan1: new station 04:f0:21:02:46:45
1360838097.026448: wlan0 (phy #0): CQM event: Beacon loss detected
1360838097.922411: wlan0 (phy #0): CQM event: Beacon loss detected
1360838129.026419: wlan0 (phy #0): CQM event: Beacon loss detected
1360838129.526429: wlan0: del station 04:f0:21:02:46:46
1360838129.757763: wlan0 (phy #0): deauth 04:f0:21:02:46:45 -> 04:f0:21:02:46:46 reason 4: Disassociated due to inactivity [frame: c0 00 00 00 04 f0 21 02 46 46 04 f0 21 02 46 45 04 f0 21 02 46 46 00 00 04 00]
1360838129.757904: wlan0 (phy #0): disconnected (local request)
1360838129.769560: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
1360838129.865576: wlan0 (phy #0): scan started
1360838132.280953: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360838132.281472: wlan0: new station 04:f0:21:02:46:46
1360838132.317300: wlan1 (phy #1): mgmt TX status (cookie ffff880201fef100): acked
1360838132.317942: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 e0 eb 00 00 02 00 00 00]
1360838132.319276: wlan1 (phy #1): mgmt TX status (cookie ffff880211c1ed00): acked
1360838132.319570: wlan1: del station 04:f0:21:02:46:45
1360838132.319849: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 f0 eb 11 00 00 00 01 c0 01 02 b0 c8]
1360838132.319883: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360838132.319980: wlan1: new station 04:f0:21:02:46:45
1360838162.946420: wlan0 (phy #0): CQM event: Beacon loss detected
1360838193.986409: wlan0 (phy #0): CQM event: Beacon loss detected
1360838194.486425: wlan0: del station 04:f0:21:02:46:46
1360838194.730311: wlan0 (phy #0): deauth 04:f0:21:02:46:45 -> 04:f0:21:02:46:46 reason 4: Disassociated due to inactivity [frame: c0 00 00 00 04 f0 21 02 46 46 04 f0 21 02 46 45 04 f0 21 02 46 46 00 00 04 00]
1360838194.730451: wlan0 (phy #0): disconnected (local request)
1360838194.742023: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
1360838194.838039: wlan0 (phy #0): scan started
1360838197.253050: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360838197.253650: wlan0: new station 04:f0:21:02:46:46
1360838197.289518: wlan1 (phy #1): mgmt TX status (cookie ffff880202f93900): acked
1360838197.290231: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 a0 f1 00 00 02 00 00 00]
1360838197.294844: wlan1 (phy #1): mgmt TX status (cookie ffff880202f93b00): acked
1360838197.296072: wlan1: del station 04:f0:21:02:46:45
1360838197.296356: wlan1: new station 04:f0:21:02:46:45
1360838197.297503: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 c0 f1 11 00 00 00 01 c0 01 02 b0 c8]
1360838197.297667: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360838227.970419: wlan0 (phy #0): CQM event: Beacon loss detected
1360838258.946424: wlan0 (phy #0): CQM event: Beacon loss detected
1360838259.446437: wlan0: del station 04:f0:21:02:46:46
1360838259.671932: wlan0 (phy #0): deauth 04:f0:21:02:46:45 -> 04:f0:21:02:46:46 reason 4: Disassociated due to inactivity [frame: c0 00 00 00 04 f0 21 02 46 46 04 f0 21 02 46 45 04 f0 21 02 46 46 00 00 04 00]
1360838259.672072: wlan0 (phy #0): disconnected (local request)
1360838259.683723: phy #0: regulatory domain change: set to world roaming by the wireless core upon initialization request
1360838259.779668: wlan0 (phy #0): scan started
1360838262.197023: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825, ""
1360838262.197634: wlan0: new station 04:f0:21:02:46:46
1360838262.233558: wlan1 (phy #1): mgmt TX status (cookie ffff8802017ac500): acked
1360838262.234260: wlan0 (phy #0): auth 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: b0 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 40 f7 00 00 02 00 00 00]
1360838262.240278: wlan1 (phy #1): mgmt TX status (cookie ffff880201b9cc00): acked
1360838262.240846: wlan1: del station 04:f0:21:02:46:45
1360838262.241139: wlan1: new station 04:f0:21:02:46:45
1360838262.244034: wlan0 (phy #0): assoc 04:f0:21:02:46:46 -> 04:f0:21:02:46:45 status: 0: Successful [frame: 10 00 2c 00 04 f0 21 02 46 45 04 f0 21 02 46 46 04 f0 21 02 46 46 60 f7 11 00 00 00 01 c0 01 02 b0 c8]
1360838262.244122: wlan0 (phy #0): connected to 04:f0:21:02:46:46
1360838292.994436: wlan0 (phy #0): CQM event: Beacon loss detected
1360838323.970422: wlan0 (phy #0): CQM event: Beacon loss detected


--------------080809040305050807050805--
