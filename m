Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34434 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbFUT7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 15:59:25 -0400
Received: by igboe5 with SMTP id oe5so49447661igb.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 12:59:24 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 21 Jun 2015 21:59:24 +0200
Message-ID: <CACna6rzr35hM-VLxgvxtGPnnxSMPx6TM18Qfc8E1Obm7iVPG4A@mail.gmail.com> (sfid-20150621_215937_946658_148C89EA)
Subject: brcmfmac: one faulty "iw interface add" command breaks in-firmware
 BSS state
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: multipart/mixed; boundary=089e0149465c0845e005190c985c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e0149465c0845e005190c985c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I've discovered some bug in brcmfmac & its BSS management. It was
exposed by OpenWrt user space change ("fix") I introduced in:
http://git.openwrt.org/?p=3Dopenwrt.git;a=3Dcommit;h=3D1cbb5e8de50457c1d972=
4ca75cc6815df5721289
and it's related to the "interface add" command.

I've router with BCM43602 and I'm using a very recent brcmfmac.

brcmfmac 0000:01:00.0: enabling device (0140 -> 0142)
brcmfmac: brcmf_c_preinit_dcmds: Firmware version =3D wl0: Mar  3 2015
04:46:51 version 7.35.177.33 (r538052) FWID 01-c8317c80
brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166 code

wlan0     Link encap:Ethernet  HWaddr 00:23:6A:A3:7D:95
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:8 errors:0 dropped:4 overruns:0 frame:0
          TX packets:19 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:505 (505.0 B)  TX bytes:1730 (1.6 KiB)

I'll just describe two scenarios that should make things clear. Both
after a cold boot.


1) Standard (working) scenario
# hostapd /etc/hostapd.conf
Configuration file: /etc/hostapd.conf
Failed to create interface mon.wlan0: -95 (Operation not supported)
[  105.483797] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
[  105.490308] brcmfmac: brcmf_add_if: ignore IF event
[  105.499067] device wlan0 entered promiscuous mode
[  105.503939] br-lan: port 2(wlan0) entered forwarding state
[  105.509437] br-lan: port 2(wlan0) entered forwarding state
wlan0: Could not connect to kernel driver
Using interface wlan0 with hwaddr 00:23:6a:a3:7d:95 and ssid "OpenWrtA"
[  105.640966] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
[  105.647478] brcmfmac: brcmf_add_if: ignore IF event
wlan0: interface state UNINITIALIZED->ENABLED
wlan0: AP-ENABLED
[  107.510613] br-lan: port 2(wlan0) entered forwarding state

This results in a working AP, my devices are able to connect


2) Scenario with iw command "mistake":
# iw phy phy0 interface add wlan0 type __ap
[   65.036358] brcmfmac: brcmf_net_attach: couldn't register the net device
[   65.043080] brcmfmac: brcmf_ap_add_vif: Registering netdevice failed
command failed: Invalid exchange (-52)
# hostapd /etc/hostapd.conf
Configuration file: /etc/hostapd.conf
Failed to create interface mon.wlan0: -95 (Operation not supported)
[   83.393594] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
[   83.400122] brcmfmac: brcmf_add_if: ignore IF event
[   83.409448] device wlan0 entered promiscuous mode
[   83.414259] br-lan: port 2(wlan0) entered forwarding state
[   83.419802] br-lan: port 2(wlan0) entered forwarding state
wlan0: Could not connect to kernel driver
Using interface wlan0 with hwaddr 00:23:6a:a3:7d:95 and ssid "OpenWrtA"
[   83.550307] brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
[   83.556814] brcmfmac: brcmf_add_if: ignore IF event
wlan0: interface state UNINITIALIZED->ENABLED
wlan0: AP-ENABLED
[   85.418417] br-lan: port 2(wlan0) entered forwarding state

In this case in-firmware BSS state seems to be broken and BSS seems to
be using *different* address. Following wpa_supplicant log should make
it clear.

wlp2s0b1: State: SCANNING -> AUTHENTICATING
EAPOL: External notification - EAP success=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=3D0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=3DAuto
EAPOL: Supplicant port status: Unauthorized
nl80211: Authenticate (ifindex=3D3)
  * bssid=3D00:23:6a:a3:7d:95
  * freq=3D2462
  * SSID - hexdump_ascii(len=3D8):
     4f 70 65 6e 57 72 74 41                           OpenWrtA
  * IEs - hexdump(len=3D0): [NULL]
  * Auth Type 0
nl80211: Authentication request send successfully
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: New station 00:23:6a:a3:7d:95
nl80211: Event message available
nl80211: MLME event 37
nl80211: Authenticate event
wlp2s0b1: Event AUTH (11) received
wlp2s0b1: SME: Ignore authentication with unexpected peer 02:23:6a:a3:7d:96
wlp2s0b1: SME: Authentication timeout
wpa_driver_nl80211_deauthenticate(addr=3D00:23:6a:a3:7d:95 reason_code=3D3)

--=20
Rafa=C5=82

--089e0149465c0845e005190c985c
Content-Type: application/octet-stream; name="hostapd.conf"
Content-Disposition: attachment; filename="hostapd.conf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ib6vwo0m0

ZHJpdmVyPW5sODAyMTEKbG9nZ2VyX3N5c2xvZz0xMjcKbG9nZ2VyX3N5c2xvZ19sZXZlbD0yCmxv
Z2dlcl9zdGRvdXQ9MTI3CmxvZ2dlcl9zdGRvdXRfbGV2ZWw9Mgpod19tb2RlPWcKY2hhbm5lbD0x
MQpub3NjYW49MQppZWVlODAyMTFuPTEKaHRfY29leD0wCmh0X2NhcGFiPVtTSE9SVC1HSS0yMF1b
RFNTU19DQ0stNDBdCgppbnRlcmZhY2U9d2xhbjAKY3RybF9pbnRlcmZhY2U9L3Zhci9ydW4vaG9z
dGFwZApkaXNhc3NvY19sb3dfYWNrPTEKcHJlYW1ibGU9MQp3bW1fZW5hYmxlZD0xCmlnbm9yZV9i
cm9hZGNhc3Rfc3NpZD0wCnVhcHNkX2FkdmVydGlzZW1lbnRfZW5hYmxlZD0xCndwYV9wYXNzcGhy
YXNlPW9wZW53cnQxMjMKYXV0aF9hbGdzPTEKd3BhPTIKd3BhX3BhaXJ3aXNlPUNDTVAKc3NpZD1P
cGVuV3J0QQpicmlkZ2U9YnItbGFuCndwYV9rZXlfbWdtdD1XUEEtUFNLCm9rYz0wCmRpc2FibGVf
cG1rc2FfY2FjaGluZz0xCmJzc2lkPTAwOjIzOjZhOmEzOjdkOjk1Cg==
--089e0149465c0845e005190c985c--
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
