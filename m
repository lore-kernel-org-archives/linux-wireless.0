Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:34260 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3IQIuJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 04:50:09 -0400
Message-ID: <20130917084327.6955.qmail@stuge.se> (sfid-20130917_105029_956546_8074F167)
Date: Tue, 17 Sep 2013 10:43:27 +0200
From: Peter Stuge <peter@stuge.se>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	hostap@lists.shmoo.com
Subject: RT3573 wpa_supplicant: "nl80211: Delete station $my_ap" after
	"SME: Send 20/40 BSS Coexistence to $my_ap"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez wrote:
> 0x0846, 0x9012 NETGEAR WNDA4100 N900 Wireless Dual Band USB Adapter

I'm testing the WNDA4100 with torvalds/linux.git and as of a day or
two ago and wpa_supplicant-2.0.

I haven't measured throughput. Latency is really bad for interactive
connections, but at least the packets are flowing on all bands. Yay!

Ping to the access point is around 3 ms with the odd 20+ ms when the
kernel goes off to do something else.


Here's my problem:

After wpa_supplicant -Dnl80211 -ddd sees scan results and says
"SME: Send 20/40 BSS Coexistence to $my_ap" and that frame is acked,
wpa_supplicant seems to receive a "link up" event which causes it to
delete the existing association for no good reason. It blacklists my
ap so I need to reconnect manually with iw dev wlan1 connect -w $ssid.

(Oh, and iw dev wlan1 connect -w consistently says "Unspecified failure"
even though the connection is established fine by wpa_supplicant. Other
problem though.)

My AP is hidden, so it isn't included in the scan results. But
wpa_supplicant is connected to it fine when the scan results arrive.

wpa_supplicant does *not* disconnect if I manually initiate a scan
when there is no other link activity, this only happens for
"Scan requested (ret=0) - scan timeout 30 seconds" scans.

--8<-- wpa_supplicant -ddd log snippet with MAC address replaced with $my_ap.
wlan1: New scan results available
SME: Send 20/40 BSS Coexistence to $my_ap
nl80211: Send Action frame (ifindex=6, freq=2417 MHz wait=0 ms no_cck=0)
nl80211: CMD_FRAME freq=2417 wait=0 no_cck=0 no_ack=0 offchanok=1
nl80211: Frame TX command accepted; cookie 0xffff880039f70700
wlan1: Checking for other virtual interfaces sharing same radio (phy1) in event_scan_results
nl80211: Event message available
nl80211: MLME event 60
nl80211: MLME event frame - hexdump(len=34): d0 00 da 00 $my_ap 84 1b 5e 7e e1 bc $my_ap d0 72 04 00 48 01 00 49 03 00 06 05
nl80211: Frame TX status event
nl80211: Action TX status: cookie=0ffff880039f70700 (match) (ack=1)
wlan1: Event TX_STATUS (18) received
wlan1: EVENT_TX_STATUS dst=$my_ap type=0 stype=13
RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
nl80211: Delete station $my_ap
nl80211: Event message available
nl80211: MLME event 39
nl80211: MLME event frame - hexdump(len=26): c0 00 00 00 $my_ap 84 1b 5e 7e e1 bc $my_ap 00 00 04 00
nl80211: Deauthenticate event
wlan1: Event DEAUTH (12) received
wlan1: Deauthentication notification
wlan1:  * reason 4 (locally generated)
wlan1:  * address $my_ap
Deauthentication frame IE(s) - hexdump(len=0): [NULL]
wlan1: CTRL-EVENT-DISCONNECTED bssid=$my_ap reason=4 locally_generated=1
wlan1: Auto connect enabled: try to reconnect (wps=0 wpa_state=9)
wlan1: Setting scan request: 0 sec 100000 usec
Added BSSID $my_ap into blacklist
wlan1: Blacklist count 1 --> request scan in 100 ms
wlan1: Setting scan request: 0 sec 100000 usec
wlan1: Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x112f828 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=$my_ap
wlan1: State: COMPLETED -> DISCONNECTED
-->8--


What's the problem? wpa_supplicant or rt2800usb or mac80211 or all of
the above?


Thanks

//Peter
