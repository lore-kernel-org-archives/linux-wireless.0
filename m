Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33312 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbcGCGN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 02:13:56 -0400
Received: by mail-oi0-f47.google.com with SMTP id u201so160071429oie.0
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jul 2016 23:13:55 -0700 (PDT)
Date: Sun, 3 Jul 2016 01:13:52 -0500
From: David Gilman <dgilman@gilslotd.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: Troubleshooting mwl8k driver issue
Message-ID: <20160703061352.GA63115@dar.local> (sfid-20160703_081522_533469_75D888EC)
References: <20160604035452.GA5925@dar.local>
 <20160606065146.GK8402@wantstofly.org>
 <20160610040247.GA16190@dar.local>
 <20160617194303.GA33130@dar.local>
 <20160618084828.GN20238@wantstofly.org>
 <20160621003630.GA39401@dar.local>
 <20160621080123.GV20238@wantstofly.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
In-Reply-To: <20160621080123.GV20238@wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> The only thing the log tells me is that this disconnect happens
> voluntarily, so I see nothing wrong from just those log messages.
> Can you run a sniffer to see what happens on the air when this
> disconnect occurs, or increase hostapd verbosity/debugging somehow?

I've given hostapd logging a shot.  The first 3 logs attached
(hostapd_debug-hostap_debug3) are syslogs with logging all the way up.
The last one is hostapd being run with the -dd flag.

All three of the events have slightly different logs but they're all
related to that WPA rekeying event.  This is a shot in the dark here,
but given that they look to be related to late or missing responses to
the rekeying maybe it's the wireless device being slow, or just slow
enough to not be able to keep up with the AP?  I could build a hostapd
with the timeout increased but I don't know if that's a good idea or the
right approach here.

-- 
David Gilman  :DG<
http://gilslotd.com

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hostapd_debug

Mon Jun 27 02:14:05 2016 daemon.debug hostapd: wlan1: WPA rekeying GTK
Mon Jun 27 02:14:05 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
Mon Jun 27 02:14:06 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: EAPOL-Key timeout
Mon Jun 27 02:14:06 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
Mon Jun 27 02:14:07 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: EAPOL-Key timeout
Mon Jun 27 02:14:07 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
Mon Jun 27 02:14:08 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: EAPOL-Key timeout
Mon Jun 27 02:14:08 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
Mon Jun 27 02:14:09 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: EAPOL-Key timeout
Mon Jun 27 02:14:09 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: WPA_PTK: sm->Disconnect
Mon Jun 27 02:14:09 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: event 3 notification
Mon Jun 27 02:14:09 2016 daemon.debug hostapd: wlan1: STA (bad phone) IEEE 802.1X: unauthorizing port
Mon Jun 27 02:14:11 2016 daemon.debug hostapd: wlan1: STA (bad phone) MLME: MLME-DEAUTHENTICATE.indication((bad phone), 2)
Mon Jun 27 02:14:11 2016 daemon.debug hostapd: wlan1: STA (bad phone) MLME: MLME-DELETEKEYS.request((bad phone))
Mon Jun 27 02:14:11 2016 kern.debug kernel: [ 1952.642536] ieee80211 phy1: Deleted BA stream index 0
Mon Jun 27 02:14:11 2016 kern.debug kernel: [ 1952.642565] ieee80211 phy1: Remove stream for (bad phone) 0
Mon Jun 27 02:14:14 2016 daemon.info hostapd: wlan1: STA (bad phone) IEEE 802.11: deauthenticated due to local deauth request
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) IEEE 802.11: authentication OK (open system)
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) MLME: MLME-AUTHENTICATE.indication((bad phone), OPEN_SYSTEM)
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) MLME: MLME-DELETEKEYS.request((bad phone))
Mon Jun 27 02:14:29 2016 daemon.info hostapd: wlan1: STA (bad phone) IEEE 802.11: authenticated
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) IEEE 802.11: association OK (aid 1)
Mon Jun 27 02:14:29 2016 daemon.info hostapd: wlan1: STA (bad phone) IEEE 802.11: associated (aid 1)
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) MLME: MLME-ASSOCIATE.indication((bad phone))
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) MLME: MLME-DELETEKEYS.request((bad phone))
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) IEEE 802.11: binding station to interface 'wlan1'
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: event 1 notification
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: start authentication
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) IEEE 802.1X: unauthorizing port
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 1/4 msg of 4-Way Handshake
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: received EAPOL-Key frame (2/4 Pairwise)
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 3/4 msg of 4-Way Handshake
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: received EAPOL-Key frame (4/4 Pairwise)
Mon Jun 27 02:14:29 2016 daemon.debug hostapd: wlan1: STA (bad phone) IEEE 802.1X: authorizing port
Mon Jun 27 02:14:29 2016 daemon.info hostapd: wlan1: STA (bad phone) WPA: pairwise key handshake completed (RSN)
Mon Jun 27 02:14:30 2016 daemon.info dnsmasq-dhcp[2989]: DHCPREQUEST(br-lan) 192.168.1.138 (bad phone)
Mon Jun 27 02:14:30 2016 daemon.info dnsmasq-dhcp[2989]: DHCPACK(br-lan) 192.168.1.138 (bad phone) android-63ebbc936f7b53af

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hostapd_debug2

Mon Jun 27 02:24:05 2016 daemon.debug hostapd: wlan1: WPA rekeying GTK
Mon Jun 27 02:24:05 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
Mon Jun 27 02:24:06 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: EAPOL-Key timeout
Mon Jun 27 02:24:06 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
Mon Jun 27 02:24:06 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: received EAPOL-Key frame (2/2 Group)
Mon Jun 27 02:24:06 2016 daemon.info hostapd: wlan1: STA (bad phone) WPA: group key handshake completed (RSN)
Mon Jun 27 02:24:06 2016 daemon.debug hostapd: wlan1: STA (bad phone) WPA: received EAPOL-Key 2/2 Group with unexpected replay counter

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hostapd_debug3

Mon Jun 27 02:37:44 2016 kern.notice kernel: [ 3365.611014] ieee80211 phy1: tx rings drained
Mon Jun 27 02:37:44 2016 kern.debug kernel: [ 3365.615496] ieee80211 phy1: Deleted BA stream index 0
Mon Jun 27 02:37:44 2016 kern.debug kernel: [ 3365.615518] ieee80211 phy1: Remove stream for (bad phone) 0
Mon Jun 27 02:37:44 2016 kern.debug kernel: [ 3365.979922] ieee80211 phy1: Added a new stream for (bad phone) 0
Mon Jun 27 02:37:44 2016 kern.debug kernel: [ 3365.979965] ieee80211 phy1: Started stream for (bad phone) 0
Mon Jun 27 02:37:44 2016 kern.notice kernel: [ 3365.980066] ieee80211 phy1: tx rings drained
Mon Jun 27 02:37:44 2016 kern.err kernel: [ 3365.985827] ieee80211 phy1: Command BASTREAM error 0x1
Mon Jun 27 02:37:45 2016 kern.err kernel: [ 3366.992421] ieee80211 phy1: Command BASTREAM error 0x1
Mon Jun 27 02:37:46 2016 kern.err kernel: [ 3368.002391] ieee80211 phy1: Command BASTREAM error 0x1
Mon Jun 27 02:37:48 2016 kern.debug kernel: [ 3370.012306] ieee80211 phy1: Remove stream for (bad phone) 0
Mon Jun 27 02:37:53 2016 kern.debug kernel: [ 3374.452437] ieee80211 phy1: Added a new stream for (bad phone) 0
Mon Jun 27 02:37:53 2016 kern.debug kernel: [ 3374.452482] ieee80211 phy1: Started stream for (bad phone) 0
Mon Jun 27 02:37:53 2016 kern.notice kernel: [ 3374.452898] ieee80211 phy1: tx rings drained
Mon Jun 27 02:37:53 2016 kern.debug kernel: [ 3374.461251] ieee80211 phy1: Created a BA stream for (bad phone) : tid 0

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hostapd_debug4

wlan1: WPA rekeying GTK
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GTK - hexdump(len=16): [REMOVED]
WPA: (good laptop) WPA_PTK_GROUP entering state REKEYNEGOTIATING
wlan1: STA (good laptop) WPA: sending 1/2 msg of Group Key Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=24 keyidx=2 encr=1)
WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 03
Plaintext EAPOL-Key Key Data - hexdump(len=32): [REMOVED]
WPA: Use EAPOL-Key timeout of 500 ms (retry counter 1)
WPA: (bad phone) WPA_PTK_GROUP entering state REKEYNEGOTIATING
wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=24 keyidx=2 encr=1)
WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 03
Plaintext EAPOL-Key Key Data - hexdump(len=32): [REMOVED]
WPA: Use EAPOL-Key timeout of 500 ms (retry counter 1)
wpa_group_setkeys: GKeyDoneStations=2
wlan1: Event EAPOL_TX_STATUS (38) received
IEEE 802.1X: (good laptop) TX status - version=2 type=3 length=127 - ack=1
WPA: EAPOL-Key TX status for STA (good laptop) ack=1
wlan1: Event EAPOL_RX (24) received
IEEE 802.1X: 99 bytes from (good laptop)
   IEEE 802.1X: version=1 type=3 length=95
WPA: Received EAPOL-Key from (good laptop) key_info=0x302 type=2 key_data_length=0
WPA: Received Key Nonce - hexdump(len=32): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: Received Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 03
wlan1: STA (good laptop) WPA: received EAPOL-Key frame (2/2 Group)
WPA: (good laptop) WPA_PTK_GROUP entering state REKEYESTABLISHED
wlan1: STA (good laptop) WPA: group key handshake completed (RSN)
WPA: (good laptop) WPA_PTK_GROUP entering state IDLE
wlan1: STA (bad phone) WPA: EAPOL-Key timeout
WPA: (bad phone) WPA_PTK_GROUP entering state REKEYNEGOTIATING
wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=24 keyidx=2 encr=1)
WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 04
Plaintext EAPOL-Key Key Data - hexdump(len=32): [REMOVED]
WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 2)
wlan1: STA (bad phone) WPA: EAPOL-Key timeout
WPA: (bad phone) WPA_PTK_GROUP entering state REKEYNEGOTIATING
wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=24 keyidx=2 encr=1)
WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 05
Plaintext EAPOL-Key Key Data - hexdump(len=32): [REMOVED]
WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 3)
wlan1: STA (bad phone) WPA: EAPOL-Key timeout
WPA: (bad phone) WPA_PTK_GROUP entering state REKEYNEGOTIATING
wlan1: STA (bad phone) WPA: sending 1/2 msg of Group Key Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=0 pairwise=0 kde_len=24 keyidx=2 encr=1)
WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 06
Plaintext EAPOL-Key Key Data - hexdump(len=32): [REMOVED]
WPA: Use EAPOL-Key timeout of 1000 ms (retry counter 4)
wlan1: STA (bad phone) WPA: EAPOL-Key timeout
WPA: (bad phone) WPA_PTK_GROUP entering state REKEYNEGOTIATING
WPA: (bad phone) WPA_PTK_GROUP entering state KEYERROR
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=3 addr=0x88628 key_idx=2 set_tx=1 seq_len=0 key_len=16
nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
   broadcast key
wlan1: STA (bad phone) WPA: WPA_PTK: sm->Disconnect
WPA: (bad phone) WPA_PTK entering state DISCONNECT
wpa_sta_disconnect STA (bad phone)
hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect: STA (bad phone) reason 2
wlan1: ap_sta_disconnect addr (bad phone) reason=2
nl80211: send_mlme - da= (bad phone) noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xc0 (WLAN_FC_STYPE_DEAUTH) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=0 offchanok=0
CMD_FRAME - hexdump(len=26): c0 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 02 00
nl80211: Frame TX command accepted; cookie 0x129c
nl80211: Drop oldest pending send action cookie 0x0
wlan1: AP-STA-DISCONNECTED (bad phone)
wlan1: STA (bad phone) WPA: event 3 notification
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=0 addr=0xb6e853d8 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=(bad phone)
wlan1: ap_sta_disconnect: reschedule ap_handle_timer timeout for (bad phone) (5 seconds - AP_MAX_INACTIVITY_AFTER_DEAUTH)
WPA: (bad phone) WPA_PTK_GROUP entering state IDLE
WPA: (bad phone) WPA_PTK entering state DISCONNECTED
WPA: (bad phone) WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=0 addr=0xb6e853d8 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=(bad phone)
nl80211: Set STA flags - ifname=wlan1 addr=(bad phone) total_flags=0x2 flags_or=0x0 flags_and=0xfffffffe authorized=0
wlan1: STA (bad phone) IEEE 802.1X: unauthorizing port
wlan1: Deauthentication callback for STA (bad phone)
wlan1: Removing STA (bad phone) from kernel driver
nl80211: sta_remove -> DEL_STATION wlan1 (bad phone) --> 0 (No error information)
wlan1: STA (bad phone) MLME: MLME-DEAUTHENTICATE.indication((bad phone), 2)
wlan1: STA (bad phone) MLME: MLME-DELETEKEYS.request((bad phone))
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=0 addr=0xb6e853d8 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=(bad phone)
nl80211: Event message available
nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlan1
nl80211: Delete station (bad phone)
nl80211: Event message available
nl80211: BSS Event 83 (NL80211_CMD_UNEXPECTED_FRAME) received for wlan1
wlan1: Event RX_FROM_UNKNOWN (18) received
Data/PS-poll frame from not associated STA (bad phone)
Association Response to the STA has already been sent, but no TX status yet known - ignore Class 3 frame issue with (bad phone)
wlan1: ap_handle_timer: (bad phone) flags=0x40008a00 timeout_next=3
wlan1: STA (bad phone) IEEE 802.11: deauthenticated due to local deauth request
nl80211: sta_remove -> DEL_STATION wlan1 (bad phone) --> -2 (No such file or directory)
hostapd_ht_operation_update current operation mode=0x4
hostapd_ht_operation_update new operation mode=0x4 changes=0
ap_free_sta: cancel ap_handle_timer for (bad phone)
nl80211: Event message available
nl80211: BSS Event 83 (NL80211_CMD_UNEXPECTED_FRAME) received for wlan1
wlan1: Event RX_FROM_UNKNOWN (18) received
Data/PS-poll frame from not associated STA (bad phone)
nl80211: send_mlme - da= (bad phone) noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xc0 (WLAN_FC_STYPE_DEAUTH) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=0 offchanok=0
CMD_FRAME - hexdump(len=26): c0 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 07 00
nl80211: Frame TX command accepted; cookie 0x129d
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for wlan1
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on wlan1((AP)) A1=(bad phone) A2=(AP)
nl80211: MLME event frame - hexdump(len=26): c0 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 07 00
nl80211: Frame TX status event
wlan1: Event TX_STATUS (17) received
mgmt::deauth cb
handle_deauth_cb: STA (bad phone) not found
nl80211: Event message available
nl80211: BSS Event 83 (NL80211_CMD_UNEXPECTED_FRAME) received for wlan1
wlan1: Event RX_FROM_UNKNOWN (18) received
Data/PS-poll frame from not associated STA (bad phone)
nl80211: send_mlme - da= (bad phone) noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xc0 (WLAN_FC_STYPE_DEAUTH) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=0 offchanok=0
CMD_FRAME - hexdump(len=26): c0 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 07 00
nl80211: Frame TX command accepted; cookie 0x129e
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for wlan1
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on wlan1((AP)) A1=(bad phone) A2=(AP)
nl80211: MLME event frame - hexdump(len=26): c0 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 07 00
nl80211: Frame TX status event
wlan1: Event TX_STATUS (17) received
mgmt::deauth cb
handle_deauth_cb: STA (bad phone) not found
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=(bad phone)
nl80211: MLME event frame - hexdump(len=128): 40 00 00 00 ff ff ff ff ff ff fc c2 de ac b1 72 ff ff ff ff ff ff 40 d7 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 0c 12 18 24 30 48 60 6c 2d 1a 6f 00 17 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 06 00 00 08 80 01 40 bf 0c 32 58 81 0f fa ff 00 00 fa ff 00 00 dd 05 00 90 4c 04 07 dd 08 00 50 f2 08 00 11 00 00 dd 09 00 10 18 02 00 00 10 00 00
nl80211: Frame event
nl80211: RX frame sa=(bad phone) freq=5240 ssi_signal=-61 fc=0x40 seq_ctrl=0xd740 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=128
nl80211: send_mlme - da= (bad phone) noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=0 offchanok=0
CMD_FRAME - hexdump(len=183): 50 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX command accepted; cookie 0x129f
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for wlan1
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on wlan1((AP)) A1=(bad phone) A2=(AP)
nl80211: MLME event frame - hexdump(len=183): 50 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX status event
wlan1: Event TX_STATUS (17) received
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=(AP) A2=(bad phone)
nl80211: MLME event frame - hexdump(len=26): c0 00 3c 00 94 10 3e 8f d2 db fc c2 de ac b1 72 94 10 3e 8f d2 db 50 d7 06 00
nl80211: Frame event
nl80211: RX frame sa=(bad phone) freq=5240 ssi_signal=-62 fc=0xc0 seq_ctrl=0xd750 stype=12 (WLAN_FC_STYPE_DEAUTH) len=26
wlan1: Event RX_MGMT (19) received
wlan1: mgmt::deauth
wlan1: deauthentication: STA=(bad phone) reason_code=6
wlan1: Station (bad phone) trying to deauthenticate, but it is not authenticated
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=(bad phone)
nl80211: MLME event frame - hexdump(len=128): 40 00 00 00 ff ff ff ff ff ff fc c2 de ac b1 72 ff ff ff ff ff ff 60 d7 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 0c 12 18 24 30 48 60 6c 2d 1a 6f 00 17 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 06 00 00 08 80 01 40 bf 0c 32 58 81 0f fa ff 00 00 fa ff 00 00 dd 05 00 90 4c 04 07 dd 08 00 50 f2 08 00 11 00 00 dd 09 00 10 18 02 00 00 10 00 00
nl80211: Frame event
nl80211: RX frame sa=(bad phone) freq=5240 ssi_signal=-61 fc=0x40 seq_ctrl=0xd760 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=128
nl80211: send_mlme - da= (bad phone) noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=0 offchanok=0
CMD_FRAME - hexdump(len=183): 50 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX command accepted; cookie 0x12a0
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for wlan1
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on wlan1((AP)) A1=(bad phone) A2=(AP)
nl80211: MLME event frame - hexdump(len=183): 50 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX status event
wlan1: Event TX_STATUS (17) received
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=(AP) A2=(bad phone)
nl80211: MLME event frame - hexdump(len=41): b0 00 3c 00 94 10 3e 8f d2 db fc c2 de ac b1 72 94 10 3e 8f d2 db 70 d7 00 00 01 00 00 00 dd 09 00 10 18 02 00 00 10 00 00
nl80211: Frame event
nl80211: RX frame sa=(bad phone) freq=5240 ssi_signal=-61 fc=0xb0 seq_ctrl=0xd770 stype=11 (WLAN_FC_STYPE_AUTH) len=41
wlan1: Event RX_MGMT (19) received
mgmt::auth
authentication: STA=(bad phone) auth_alg=0 auth_transaction=1 status_code=0 wep=0 seq_ctrl=0xd770
  New STA
ap_sta_add: register ap_handle_timer timeout for (bad phone) (300 seconds - ap_max_inactivity)
wlan1: STA (bad phone) IEEE 802.11: authentication OK (open system)
wlan1: STA (bad phone) MLME: MLME-AUTHENTICATE.indication((bad phone), OPEN_SYSTEM)
wlan1: STA (bad phone) MLME: MLME-DELETEKEYS.request((bad phone))
authentication reply: STA=(bad phone) auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
nl80211: send_mlme - da= (bad phone) noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xb0 (WLAN_FC_STYPE_AUTH) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=0 offchanok=0
CMD_FRAME - hexdump(len=30): b0 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 02 00 00 00
nl80211: Frame TX command accepted; cookie 0x12a1
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for wlan1
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on wlan1((AP)) A1=(bad phone) A2=(AP)
nl80211: MLME event frame - hexdump(len=30): b0 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 02 00 00 00
nl80211: Frame TX status event
wlan1: Event TX_STATUS (17) received
mgmt::auth cb
wlan1: STA (bad phone) IEEE 802.11: authenticated
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=(AP) A2=(bad phone)
nl80211: MLME event frame - hexdump(len=148): 00 00 3c 00 94 10 3e 8f d2 db fc c2 de ac b1 72 94 10 3e 8f d2 db 80 d7 11 00 0a 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 21 02 09 12 24 0a 24 04 34 04 64 0c 95 04 a5 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 2d 1a 6f 00 17 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 06 00 00 08 80 01 40 dd 09 00 10 18 02 00 00 10 00 00 dd 07 00 50 f2 02 00 01 00
nl80211: Frame event
nl80211: RX frame sa=(bad phone) freq=5240 ssi_signal=-62 fc=0x0 seq_ctrl=0xd780 stype=0 (WLAN_FC_STYPE_ASSOC_REQ) len=148
wlan1: Event RX_MGMT (19) received
mgmt::assoc_req
association request: STA=(bad phone) capab_info=0x11 listen_interval=10 seq_ctrl=0xd780
WMM IE - hexdump(len=7): 00 50 f2 02 00 01 00
Validating WMM IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0  version 1  QoS info 0x0
  new AID 1
HT: STA (bad phone) HT Capabilities Info: 0x006f
update_sta_ht STA (bad phone) - no greenfield, num of non-gf stations 2
hostapd_ht_operation_update current operation mode=0x4
hostapd_ht_operation_update new operation mode=0x4 changes=0
wlan1: STA (bad phone) IEEE 802.11: association OK (aid 1)
nl80211: send_mlme - da= (bad phone) noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x10 (WLAN_FC_STYPE_ASSOC_RESP) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=0 offchanok=0
CMD_FRAME - hexdump(len=128): 10 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 11 00 00 00 01 c0 01 08 8c 12 98 24 b0 48 60 6c 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX command accepted; cookie 0x12a2
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for wlan1
nl80211: MLME event 60 (NL80211_CMD_FRAME_TX_STATUS) on wlan1((AP)) A1=(bad phone) A2=(AP)
nl80211: MLME event frame - hexdump(len=128): 10 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 11 00 00 00 01 c0 01 08 8c 12 98 24 b0 48 60 6c 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX status event
wlan1: Event TX_STATUS (17) received
mgmt::assoc_resp cb
wlan1: STA (bad phone) IEEE 802.11: associated (aid 1)
wlan1: STA (bad phone) MLME: MLME-ASSOCIATE.indication((bad phone))
wlan1: STA (bad phone) MLME: MLME-DELETEKEYS.request((bad phone))
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=0 addr=0xb6eb4578 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=(bad phone)
nl80211: sta_remove -> DEL_STATION wlan1 (bad phone) --> -2 (No such file or directory)
nl80211: Add STA (bad phone)
  * supported rates - hexdump(len=8): 8c 12 98 24 b0 48 60 6c
  * capability=0x11
  * ht_capabilities - hexdump(len=26): 6c 00 17 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  * aid=1
  * listen_interval=10
  * flags set=0x8 mask=0x8
  * qosinfo=0x0
wlan1: STA (bad phone) IEEE 802.11: binding station to interface 'wlan1'
nl80211: wlan1[17]: set_sta_vlan((bad phone), ifname=wlan1[17], vlan_id=0)
nl80211: Set STA flags - ifname=wlan1 addr=(bad phone) total_flags=0x2 flags_or=0x2 flags_and=0xfffffff3 authorized=0
wlan1: STA (bad phone) WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=0 addr=0xb6eb4578 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=(bad phone)
IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
wlan1: STA (bad phone) WPA: start authentication
WPA: (bad phone) WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=0 addr=0xb6eb4578 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=(bad phone)
nl80211: Set STA flags - ifname=wlan1 addr=(bad phone) total_flags=0x2 flags_or=0x0 flags_and=0xfffffffe authorized=0
wlan1: STA (bad phone) IEEE 802.1X: unauthorizing port
WPA: (bad phone) WPA_PTK_GROUP entering state IDLE
WPA: (bad phone) WPA_PTK entering state AUTHENTICATION
WPA: (bad phone) WPA_PTK entering state AUTHENTICATION2
WPA: Assign ANonce - hexdump(len=32): 53 5b 47 31 3f 5c 8d 8b 0a 50 96 ea f7 6f 5b 5a f7 14 c9 b9 1b fb 43 33 e2 e8 45 8f ba c1 12 62
WPA: (bad phone) WPA_PTK entering state INITPSK
Searching a PSK for (bad phone) prev_psk=0
Searching a PSK for (bad phone) prev_psk=0
WPA: (bad phone) WPA_PTK entering state PTKSTART
wlan1: STA (bad phone) WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=1 kde_len=0 keyidx=0 encr=0)
WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 01
WPA: Use EAPOL-Key timeout of 100 ms (retry counter 1)
wlan1: hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for (bad phone) (300 seconds - ap_max_inactivity)
nl80211: Event message available
nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan1
nl80211: New station (bad phone)
wlan1: Event EAPOL_TX_STATUS (38) received
IEEE 802.1X: (bad phone) TX status - version=2 type=3 length=95 - ack=1
WPA: EAPOL-Key TX status for STA (bad phone) ack=1
WPA: Increase initial EAPOL-Key 1/4 timeout by 1000 ms because of acknowledged frame
wlan1: Event EAPOL_RX (24) received
IEEE 802.1X: 121 bytes from (bad phone)
   IEEE 802.1X: version=1 type=3 length=117
WPA: Received EAPOL-Key from (bad phone) key_info=0x10a type=2 key_data_length=22
WPA: Received Key Nonce - hexdump(len=32): 6f 41 14 04 3c 80 eb 35 ae b7 69 e7 80 7d ed b8 4e 83 e3 7e 7c 8e e7 84 1d 45 10 84 fc 48 b8 7b
WPA: Received Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 01
wlan1: STA (bad phone) WPA: received EAPOL-Key frame (2/4 Pairwise)
WPA: (bad phone) WPA_PTK entering state PTKCALCNEGOTIATING
Searching a PSK for (bad phone) prev_psk=0
WPA: PTK derivation - A1=(AP) A2=(bad phone)
WPA: Nonce1 - hexdump(len=32): 53 5b 47 31 3f 5c 8d 8b 0a 50 96 ea f7 6f 5b 5a f7 14 c9 b9 1b fb 43 33 e2 e8 45 8f ba c1 12 62
WPA: Nonce2 - hexdump(len=32): 6f 41 14 04 3c 80 eb 35 ae b7 69 e7 80 7d ed b8 4e 83 e3 7e 7c 8e e7 84 1d 45 10 84 fc 48 b8 7b
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: KCK - hexdump(len=16): [REMOVED]
WPA: KEK - hexdump(len=16): [REMOVED]
WPA: TK - hexdump(len=16): [REMOVED]
WPA: (bad phone) WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: (bad phone) WPA_PTK entering state PTKINITNEGOTIATING
wlan1: STA (bad phone) WPA: sending 3/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=1 pairwise=1 kde_len=46 keyidx=2 encr=1)
WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 02
Plaintext EAPOL-Key Key Data - hexdump(len=56): [REMOVED]
WPA: Use EAPOL-Key timeout of 100 ms (retry counter 1)
wlan1: Event EAPOL_TX_STATUS (38) received
IEEE 802.1X: (bad phone) TX status - version=2 type=3 length=151 - ack=1
WPA: EAPOL-Key TX status for STA (bad phone) ack=1
wlan1: Event EAPOL_RX (24) received
IEEE 802.1X: 99 bytes from (bad phone)
   IEEE 802.1X: version=1 type=3 length=95
WPA: Received EAPOL-Key from (bad phone) key_info=0x30a type=2 key_data_length=0
WPA: Received Key Nonce - hexdump(len=32): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: Received Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 02
wlan1: STA (bad phone) WPA: received EAPOL-Key frame (4/4 Pairwise)
WPA: (bad phone) WPA_PTK entering state PTKINITDONE
wpa_driver_nl80211_set_key: ifindex=17 (wlan1) alg=3 addr=0xb6eb4578 key_idx=0 set_tx=1 seq_len=0 key_len=16
nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
   addr=(bad phone)
wlan1: AP-STA-CONNECTED (bad phone)
nl80211: Set STA flags - ifname=wlan1 addr=(bad phone) total_flags=0x3 flags_or=0x1 flags_and=0xffffffff authorized=1
wlan1: STA (bad phone) IEEE 802.1X: authorizing port
wlan1: STA (bad phone) WPA: pairwise key handshake completed (RSN)
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=(bad phone)
nl80211: MLME event frame - hexdump(len=114): 40 00 00 00 ff ff ff ff ff ff fc c2 de ac b1 72 ff ff ff ff ff ff 60 da 00 00 01 08 0c 12 18 24 30 48 60 6c 2d 1a 6f 00 17 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 06 00 00 08 80 01 40 bf 0c 32 58 81 0f fa ff 00 00 fa ff 00 00 dd 05 00 90 4c 04 07 dd 08 00 50 f2 08 00 11 00 fc dd 09 00 10 18 02 00 00 10 00 00
nl80211: Frame event
nl80211: RX frame sa=(bad phone) freq=5240 ssi_signal=-59 fc=0x40 seq_ctrl=0xda60 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=114
nl80211: send_mlme - da= (bad phone) noack=1 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=1 offchanok=0
CMD_FRAME - hexdump(len=183): 50 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=(bad phone)
nl80211: MLME event frame - hexdump(len=114): 40 00 00 00 ff ff ff ff ff ff fc c2 de ac b1 72 ff ff ff ff ff ff 70 da 00 00 01 08 0c 12 18 24 30 48 60 6c 2d 1a 6f 00 17 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 06 00 00 08 80 01 40 bf 0c 32 58 81 0f fa ff 00 00 fa ff 00 00 dd 05 00 90 4c 04 07 dd 08 00 50 f2 08 00 11 00 fc dd 09 00 10 18 02 00 00 10 00 00
nl80211: Frame event
nl80211: RX frame sa=(bad phone) freq=5240 ssi_signal=-60 fc=0x40 seq_ctrl=0xda70 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=114
nl80211: send_mlme - da= (bad phone) noack=1 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=1 offchanok=0
CMD_FRAME - hexdump(len=183): 50 00 00 00 fc c2 de ac b1 72 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=34:23:ba:7b:aa:15
nl80211: MLME event frame - hexdump(len=110): 40 00 00 00 ff ff ff ff ff ff 34 23 ba 7b aa 15 ff ff ff ff ff ff c0 01 00 00 01 08 0c 12 18 24 30 48 60 6c 2d 1a 62 00 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 30 dd 09 00 10 18 02 00 00 00 00 00 dd 1e 00 90 4c 33 62 00 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
nl80211: RX frame sa=34:23:ba:7b:aa:15 freq=5240 ssi_signal=-73 fc=0x40 seq_ctrl=0x1c0 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=110
nl80211: send_mlme - da= 34:23:ba:7b:aa:15 noack=1 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=1 offchanok=0
CMD_FRAME - hexdump(len=183): 50 00 00 00 34 23 ba 7b aa 15 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=34:23:ba:7b:aa:15
nl80211: MLME event frame - hexdump(len=110): 40 00 00 00 ff ff ff ff ff ff 34 23 ba 7b aa 15 ff ff ff ff ff ff d0 01 00 00 01 08 0c 12 18 24 30 48 60 6c 2d 1a 62 00 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 30 dd 09 00 10 18 02 00 00 00 00 00 dd 1e 00 90 4c 33 62 00 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
nl80211: RX frame sa=34:23:ba:7b:aa:15 freq=5240 ssi_signal=-67 fc=0x40 seq_ctrl=0x1d0 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=110
nl80211: send_mlme - da= 34:23:ba:7b:aa:15 noack=1 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=5240
nl80211: send_frame -> send_frame_cmd
nl80211: CMD_FRAME freq=5240 wait=0 no_cck=0 no_ack=1 offchanok=0
CMD_FRAME - hexdump(len=183): 50 00 00 00 34 23 ba 7b aa 15 94 10 3e 8f d2 db 94 10 3e 8f d2 db 00 00 00 00 00 00 00 00 00 00 64 00 11 00 00 0e 67 69 6c 6d 61 6e 20 6f 70 65 6e 77 72 74 01 08 8c 12 98 24 b0 48 60 6c 03 01 30 07 06 30 30 20 24 04 14 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00 2d 1a ec 0b 03 ff ff ff 00 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 3d 16 30 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 08 00 00 00 00 00 00 00 40 dd 18 00 50 f2 02 01 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Drop oldest pending send action cookie 0x0
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=a4:77:33:7b:21:e8
nl80211: MLME event frame - hexdump(len=106): 40 00 00 00 ff ff ff ff ff ff a4 77 33 7b 21 e8 ff ff ff ff ff ff 70 92 00 0c 4e 45 54 47 45 41 52 38 30 2d 35 47 01 08 02 04 0b 0c 12 16 18 24 2d 1a 62 00 03 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 08 e0 e1 09 00 32 04 30 48 60 6c 7f 08 00 00 00 00 00 00 00 40 bf 0c 30 70 c0 33 fc ff 24 01 fc ff 24 01
nl80211: Frame event
nl80211: RX frame sa=a4:77:33:7b:21:e8 freq=5240 ssi_signal=-57 fc=0x40 seq_ctrl=0x9270 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=106
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=a4:77:33:7b:21:e8
nl80211: MLME event frame - hexdump(len=106): 40 00 00 00 ff ff ff ff ff ff a4 77 33 7b 21 e8 ff ff ff ff ff ff 80 92 00 0c 4e 45 54 47 45 41 52 38 30 2d 35 47 01 08 02 04 0b 0c 12 16 18 24 2d 1a 62 00 03 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 08 e0 e1 09 00 32 04 30 48 60 6c 7f 08 00 00 00 00 00 00 00 40 bf 0c 30 70 c0 33 fc ff 24 01 fc ff 24 01
nl80211: Frame event
nl80211: RX frame sa=a4:77:33:7b:21:e8 freq=5240 ssi_signal=-57 fc=0x40 seq_ctrl=0x9280 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=106
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=a4:77:33:7b:21:e8
nl80211: MLME event frame - hexdump(len=106): 40 00 00 00 ff ff ff ff ff ff a4 77 33 7b 21 e8 ff ff ff ff ff ff 90 92 00 0c 4e 45 54 47 45 41 52 38 30 2d 35 47 01 08 02 04 0b 0c 12 16 18 24 2d 1a 62 00 03 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 08 e0 e1 09 00 32 04 30 48 60 6c 7f 08 00 00 00 00 00 00 00 40 bf 0c 30 70 c0 33 fc ff 24 01 fc ff 24 01
nl80211: Frame event
nl80211: RX frame sa=a4:77:33:7b:21:e8 freq=5240 ssi_signal=-57 fc=0x40 seq_ctrl=0x9290 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=106
nl80211: Event message available
nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan1
nl80211: MLME event 59 (NL80211_CMD_FRAME) on wlan1((AP)) A1=ff:ff:ff:ff:ff:ff A2=a4:77:33:7b:21:e8
nl80211: MLME event frame - hexdump(len=106): 40 00 00 00 ff ff ff ff ff ff a4 77 33 7b 21 e8 ff ff ff ff ff ff a0 92 00 0c 4e 45 54 47 45 41 52 38 30 2d 35 47 01 08 02 04 0b 0c 12 16 18 24 2d 1a 62 00 03 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 08 e0 e1 09 00 32 04 30 48 60 6c 7f 08 00 00 00 00 00 00 00 40 bf 0c 30 70 c0 33 fc ff 24 01 fc ff 24 01
nl80211: Frame event
nl80211: RX frame sa=a4:77:33:7b:21:e8 freq=5240 ssi_signal=-57 fc=0x40 seq_ctrl=0x92a0 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=106

--6TrnltStXW4iwmi0--
