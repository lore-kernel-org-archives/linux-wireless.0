Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:35854 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753140AbdEJOak (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 10:30:40 -0400
Received: by mail-wr0-f182.google.com with SMTP id l50so46340099wrc.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 May 2017 07:30:39 -0700 (PDT)
From: Marek =?utf-8?B?RmxvcmlhxYRjenlr?= <marek.florianczyk@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.infradead.org
Subject: Re: Cubieboard2 + hostapd + 100 wireless devices
Date: Wed, 10 May 2017 16:30:35 +0200
Message-ID: <1703928.J8ZF87vcpf@franki> (sfid-20170510_163103_211254_A1B7BB97)
In-Reply-To: <20170510093113.GA9584@redhat.com>
References: <1946348.9jam7OIK4C@franki> <20170510093113.GA9584@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1564641.IXqKO62ad3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1564641.IXqKO62ad3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Dnia =C5=9Broda, 10 maja 2017 11:31:17 CEST Stanislaw Gruszka pisze:
> On Sun, May 07, 2017 at 02:19:25PM +0200, Marek Floria=C5=84czyk wrote:
>
>=20
> If RT5370 works for you I would stick with it. RTxxx chips with rt2800
> driver are capable to support up to 190 stations with HW encryption and
> 11n aggregation (something that you are not interested). Theoretically
> more stations can be added and those should fallback to software
> encryption and frame aggregation will not be done, but I'm not sure if
> anyone test that.
>=20
> I'm also not sure if many people test 11b, perhaps 11g would be better
> choice. BTW, what kernel version are you using (I'm curious if 11b
> still works on latest kernels) ?
>=20
> Stanislaw

Hi,

Thanks for answer.
I'm using Linux cubieboard2 4.9.12-sunxi=20
This is Armbian based on Debian Jessie

I'm using "b" mode on hostapd because our modules:
http://www.electrodragon.com/product/esp-12f-esp8266-wifi-board/
have +20dBm when in "b" mode - that's what docs say.

I still have problems when 80 devices are connected, after a few minutes so=
me=20
of them (10-20) deauthenticate with AP.=20
When reporting from hostapd_cli, sta changes from:

flags=3D[AUTH][ASSOC][AUTHORIZED][SHORT_PREAMBLE][WMM]
aid=3D69
capability=3D0x31
listen_interval=3D100
supported_rates=3D8b 96 82 84 0c 18 30 60 6c 12 24 48
timeout_next=3DNULLFUNC POLL
dot11RSNAStatsSTAAddress=3D5c:cf:7f:ff:eb:ee
dot11RSNAStatsVersion=3D1
dot11RSNAStatsSelectedPairwiseCipher=3D00-50-f2-2
dot11RSNAStatsTKIPLocalMICFailures=3D0
dot11RSNAStatsTKIPRemoteMICFailures=3D0
hostapdWPAPTKState=3D11
hostapdWPAPTKGroupState=3D0
rx_packets=3D18
tx_packets=3D17
rx_bytes=3D3295
tx_bytes=3D3490
inactive_msec=3D134370
connected_time=3D832

To:

flags=3D[AUTH]
aid=3D0
capability=3D0x0
listen_interval=3D0
supported_rates=3D
timeout_next=3DNULLFUNC POLL
rx_packets=3D2
tx_packets=3D2
rx_bytes=3D48
tx_bytes=3D143
inactive_msec=3D1980

When I have only 20some devices it works always, but with more devices=20
something goes wrong....

I'm running hostapd in debug mode now, and I have found station:
2c:3a:e8:00:33:e0
That deauthenticate with AP, but I don't know why,=20
reason_code=3D3 "station is leaving (or has left) IBSS or ESS"

Any help would be appreciated ;)

Best Regards
Marek

--nextPart1564641.IXqKO62ad3
Content-Disposition: attachment; filename="hostapd.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="hostapd.log"

1494425876.349802: nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan2
1494425876.349952: nl80211: RX frame da=7c:dd:90:84:79:cc sa=2c:3a:e8:00:33:e0 bssid=7c:dd:90:84:79:cc freq=2437 ssi_signal=-43 fc=0xc0 seq_ctrl=0x450 stype=12 (WLAN_FC_STYPE_DEAUTH) len=26
1494425876.350132: wlan2: Event RX_MGMT (19) received
1494425876.350254: wlan2: mgmt::deauth
1494425876.350382: wlan2: deauthentication: STA=2c:3a:e8:00:33:e0 reason_code=3
1494425876.350518: 1494425876.350526: wlan2: STA 2c:3a:e8:00:33:e0 IEEE 802.11: deauthenticated
1494425876.350683: 1494425876.350691: wlan2: STA 2c:3a:e8:00:33:e0 MLME: MLME-DEAUTHENTICATE.indication(2c:3a:e8:00:33:e0, 3)
1494425876.350845: 1494425876.350853: wlan2: STA 2c:3a:e8:00:33:e0 MLME: MLME-DELETEKEYS.request(2c:3a:e8:00:33:e0)
1494425876.351468: nl80211: sta_remove -> DEL_STATION wlan2 2c:3a:e8:00:33:e0 --> 0 (Success)
1494425876.351681: ap_free_sta: cancel ap_handle_timer for 2c:3a:e8:00:33:e0
1494425876.351978: nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlan2
1494425876.352135: nl80211: Delete station 2c:3a:e8:00:33:e0
1494425876.352441: nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan2
1494425876.352599: nl80211: RX frame da=7c:dd:90:84:79:cc sa=2c:3a:e8:00:33:e0 bssid=7c:dd:90:84:79:cc freq=2437 ssi_signal=-41 fc=0xb0 seq_ctrl=0x460 stype=11 (WLAN_FC_STYPE_AUTH) len=30
1494425876.352783: wlan2: Event RX_MGMT (19) received
1494425876.352900: mgmt::auth
1494425876.353251: authentication: STA=2c:3a:e8:00:33:e0 auth_alg=0 auth_transaction=1 status_code=0 wep=0 seq_ctrl=0x460
1494425876.353425:   New STA
1494425876.354104: ap_sta_add: register ap_handle_timer timeout for 2c:3a:e8:00:33:e0 (300 seconds - ap_max_inactivity)
1494425876.354721: nl80211: sta_remove -> DEL_STATION wlan2 2c:3a:e8:00:33:e0 --> -2 (No such file or directory)
1494425876.354943: nl80211: Add STA 2c:3a:e8:00:33:e0
1494425876.355185:   * supported rates - hexdump(len=0): [NULL]
1494425876.355346:   * capability=0x0
1494425876.355458:   * aid=1 (UNASSOC_STA workaround)
1494425876.355675:   * listen_interval=0
1494425876.355810:   * flags set=0x0 mask=0xa0
1494425876.356195: 1494425876.356205: wlan2: STA 2c:3a:e8:00:33:e0 IEEE 802.11: authentication OK (open system)
1494425876.356594: 1494425876.356604: wlan2: STA 2c:3a:e8:00:33:e0 MLME: MLME-AUTHENTICATE.indication(2c:3a:e8:00:33:e0, OPEN_SYSTEM)
1494425876.356958: 1494425876.356966: wlan2: STA 2c:3a:e8:00:33:e0 MLME: MLME-DELETEKEYS.request(2c:3a:e8:00:33:e0)
1494425876.357128: authentication reply: STA=2c:3a:e8:00:33:e0 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
1494425876.357266: nl80211: send_mlme - da= 2c:3a:e8:00:33:e0 noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xb0 (WLAN_FC_STYPE_AUTH) nlmode=3
1494425876.357400: nl80211: send_mlme -> send_frame
1494425876.357502: nl80211: send_frame - Use bss->freq=2437
1494425876.357600: nl80211: send_frame -> send_frame_cmd
1494425876.357956: nl80211: Drop oldest pending send action cookie 0x9b89
1494425876.358476: nl80211: Drv Event 19 (NL80211_CMD_NEW_STATION) received for wlan2
1494425876.358651: nl80211: New station 2c:3a:e8:00:33:e0
1494425876.358936: nl80211: BSS Event 59 (NL80211_CMD_FRAME) received for wlan2
1494425876.359086: nl80211: RX frame da=7c:dd:90:84:79:cc sa=2c:3a:e8:00:56:6e bssid=7c:dd:90:84:79:cc freq=2437 ssi_signal=-51 fc=0xc0 seq_ctrl=0x350 stype=12 (WLAN_FC_STYPE_DEAUTH) len=26

--nextPart1564641.IXqKO62ad3--
