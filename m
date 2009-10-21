Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f184.google.com ([209.85.212.184]:60562 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZJULsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 07:48:06 -0400
Received: by vws14 with SMTP id 14so2188199vws.33
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2009 04:48:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com>
Date: Wed, 21 Oct 2009 13:48:09 +0200
Message-ID: <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com>
Subject: Re: mac80211/ath9k/hostapd: Some clients unable to associate with AP
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

I've now checked the latest compat-wireless snapshot (2009-10-21) and
it has the same problem: Windows based clients with 11g or 11b cards
cannot connect to a mac80211/ath9k/hostapd based AP. It used to work
with compat-wireless-2009-06-02.

I've tried an Intel PRO Wireless 3945ABG card and an older 3Com
3CRWE62092B card. The Intel card seems to accept the auth response but
chokes on the assoc response while the 3Com card ignores the auth
response and just sends auth request indefinitely. This time I used
hostapd 0.6.9 in all tests.

All the non-windows 11g clients I've tried all work (an iPhone and a
Google Dev G1). I only have access to one 11n capable windows based
client (Ralink noname card) but that one works just fine and connects
to the AP on the first attempt.

Any ideas on how to track this down? I can enable some logs and hack
together some patches to track this down, I'm just not sure where to
start. Bisecting is difficult for me as I can only build
compat-wireless and only on OpenWrt... Thanx for any help in advance.

/Björn

2009/10/20 Björn Smedman <bjorn.smedman@venatech.se>:
> Hi all,
>
> I'm trying to update from compat-wireless-2009-06-02 to
> compat-wireless-2.6.32-rc1. After the update some clients can
> no-longer associate with the access point (mac80211/ath9k/hostapd).
> Specifically, it seems windows based clients do not accept the new
> association response frame and choke or send deauth.
>
> A tcpdump from a separate machine shows the story. After the update
> with compat-wireless-2.6.32-rc1 the dump locks like this (notice the
> deauth frame from the XP laptop at the end):
>
>        19:59:18.973699 1573025241us tsft 1.0 Mb/s 2412 MHz (0x0080) -53dB
> signal 0dB noise antenna 0 BSSID:ff:ff:ff:ff:ff:ff
> DA:ff:ff:ff:ff:ff:ff SA:00:13:02:36:ab:37 Probe Request
> (demo.venatech.net) [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit]
>        19:59:18.975919 1573026699us tsft 1.0 Mb/s 2412 MHz (0x0080) -57dB
> signal 0dB noise antenna 0 BSSID:00:23:cd:de:2f:c5
> DA:00:13:02:36:ab:37 SA:00:23:cd:de:2f:c5 Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        19:59:18.977723 1573028524us tsft 1.0 Mb/s 2412 MHz (0x0080) -43dB
> signal 0dB noise antenna 0 BSSID:00:23:cd:da:3c:05
> DA:00:13:02:36:ab:37 SA:00:23:cd:da:3c:05 Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        19:59:18.981060 1573031853us tsft 1.0 Mb/s 2412 MHz (0x0080) -67dB
> signal 0dB noise antenna 0 BSSID:00:23:cd:c7:c3:fd
> DA:00:13:02:36:ab:37 SA:00:23:cd:c7:c3:fd Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        19:59:19.019827 1573071924us tsft short preamble 54.0 Mb/s 2412 MHz
> (0x0080) -53dB signal 0dB noise antenna 0 BSSID:00:23:cd:da:3c:05
> DA:00:23:cd:da:3c:05 SA:00:13:02:36:ab:37 Authentication (Open
> System)-1: Succesful
>        19:59:19.022448 1573074291us tsft 1.0 Mb/s 2412 MHz (0x0080) -42dB
> signal 0dB noise antenna 0 BSSID:00:23:cd:da:3c:05
> DA:00:13:02:36:ab:37 SA:00:23:cd:da:3c:05 Authentication (Open
> System)-2:
>        19:59:19.022963 1573075062us tsft short preamble 54.0 Mb/s 2412 MHz
> (0x0080) -52dB signal 0dB noise antenna 0 BSSID:00:23:cd:da:3c:05
> DA:00:23:cd:da:3c:05 SA:00:13:02:36:ab:37 Assoc Request
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
>        19:59:19.096487 1573147524us tsft 1.0 Mb/s 2412 MHz (0x0080) -42dB
> signal 0dB noise antenna 0 BSSID:00:23:cd:da:3c:05
> DA:00:13:02:36:ab:37 SA:00:23:cd:da:3c:05 Assoc Response AID(2) ::
> Succesful
>        19:59:19.227409 1573279582us tsft short preamble 54.0 Mb/s 2412 MHz
> (0x0080) -52dB signal 0dB noise antenna 0 BSSID:00:23:cd:da:3c:05
> DA:00:23:cd:da:3c:05 SA:00:13:02:36:ab:37 DeAuthentication:
> Unspecified reason
>
> With compat-wireless-2009-06-02 the (successful) dump locks like this:
>
>        20:01:56.525502 433315165us tsft 1.0 Mb/s 2412 MHz (0x0080) -42dB
> signal 0dB noise antenna 0 BSSID:ff:ff:ff:ff:ff:ff
> DA:ff:ff:ff:ff:ff:ff SA:00:13:02:36:ab:37 Probe Request
> (demo.venatech.net) [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit]
>        20:01:56.527462 433316613us tsft 1.0 Mb/s 2412 MHz (0x0080) -44dB
> signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:13:02:36:ab:37 SA:00:25:86:d9:61:a7 Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        20:01:56.541231 433330271us tsft 1.0 Mb/s 2412 MHz (0x0080) -44dB
> signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:13:02:36:ab:37 SA:00:25:86:d9:61:a7 Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        20:01:56.542509 433331546us tsft 1.0 Mb/s 2412 MHz (0x0080) -43dB
> signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:13:02:36:ab:37 SA:00:25:86:d9:61:a7 Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        20:01:56.543874 433332939us tsft 1.0 Mb/s 2412 MHz (0x0080) -43dB
> signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:13:02:36:ab:37 SA:00:25:86:d9:61:a7 Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        20:01:56.545297 433334332us tsft 1.0 Mb/s 2412 MHz (0x0080) -43dB
> signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:13:02:36:ab:37 SA:00:25:86:d9:61:a7 Probe Response
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH:
> 1
>        20:01:56.556071 433346142us tsft short preamble 54.0 Mb/s 2412 MHz
> (0x0080) -41dB signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:25:86:d9:61:a7 SA:00:13:02:36:ab:37 Authentication (Open
> System)-1: Succesful
>        20:01:56.558199 433347993us tsft 1.0 Mb/s 2412 MHz (0x0080) -42dB
> signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:13:02:36:ab:37 SA:00:25:86:d9:61:a7 Authentication (Open
> System)-2:
>        20:01:56.558653 433348766us tsft short preamble 54.0 Mb/s 2412 MHz
> (0x0080) -41dB signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:25:86:d9:61:a7 SA:00:13:02:36:ab:37 Assoc Request
> (demo.venatech.net) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit]
>        20:01:56.634096 433423226us tsft 1.0 Mb/s 2412 MHz (0x0080) -42dB
> signal 0dB noise antenna 0 BSSID:00:25:86:d9:61:a7
> DA:00:13:02:36:ab:37 SA:00:25:86:d9:61:a7 Assoc Response AID(2) ::
> Succesful
>
> I've also tried some other windows based clients, e.g. a laptop with
> an old 11b 3Com PCMCIA card. Most seem to choke from the auth response
> or assoc response frame. The hostapd/syslog on the AP side looks
> something like this:
>
>        MGMT
>        mgmt::auth
>        authentication: STA=00:04:75:c4:1e:a5 auth_alg=0 auth_transaction=1
> status_code=0 wep=0
>        ap0: STA 00:04:75:c4:1e:a5 IEEE 802.11: authentication OK (open system)
>        ap0: STA 00:04:75:c4:1e:a5 MLME:
> MLME-AUTHENTICATE.indication(00:04:75:c4:1e:a5, OPEN_SYSTEM)
>        ap0: STA 00:04:75:c4:1e:a5 MLME: MLME-DELETEKEYS.request(00:04:75:c4:1e:a5)
>        authentication reply: STA=00:04:75:c4:1e:a5 auth_alg=0
> auth_transaction=2 resp=0 (IE len=0)
>        MGMT (TX callback) ACK
>        mgmt::auth cb
>        ap0: STA 00:04:75:c4:1e:a5 IEEE 802.11: authenticated
>        Jan  1 03:33:12 00:23:CD:DA:3C:04 daemon.info hostapd: ap0: STA
> 00:04:75:c4:1e:a5 IEEE 802.11: authenticated
>        STA 00:04:75:c4:1e:a5 sent probe request for broadcast SSID
>        STA 00:04:75:c4:1e:a5 sent probe request for our SSID
>        MGMT (TX callback) fail
>        mgmt::proberesp cb
>        MGMT (TX callback) fail
>        mgmt::proberesp cb
>        MGMT
>        mgmt::auth
>        authentication: STA=00:04:75:c4:1e:a5 auth_alg=0 auth_transaction=1
> status_code=0 wep=0
>        ap0: STA 00:04:75:c4:1e:a5 IEEE 802.11: authentication OK (open system)
>        ap0: STA 00:04:75:c4:1e:a5 MLME:
> MLME-AUTHENTICATE.indication(00:04:75:c4:1e:a5, OPEN_SYSTEM)
>        ap0: STA 00:04:75:c4:1e:a5 MLME: MLME-DELETEKEYS.request(00:04:75:c4:1e:a5)
>        authentication reply: STA=00:04:75:c4:1e:a5 auth_alg=0
> auth_transaction=2 resp=0 (IE len=0)
>        STA 00:22:fa:f8:17:c8 sent probe request for broadcast SSID
>        MGMT (TX callback) ACK
>        mgmt::auth cb
>        ap0: STA 00:04:75:c4:1e:a5 IEEE 802.11: authenticated
>
>        [And so on over and over...]
>
> I've also tried some different versions of hostapd: 0.6.9 and two
> different git snapshots from 0.7-branch (a35187e71a1dd23653fc03ed5
> and 6d6f4bb87f33278aed133875d0d561eb55d7ae59) but it doesn't seem to
> make any difference. My configuration file is really simple:
>
>        driver=nl80211
>        interface=ap0
>        ctrl_interface=/var/run/
>        hostapd-vtmd
>        hw_mode=g
>        channel=1
>        ssid=demo.venatech.net
>        ieee80211n=1
>        ht_capab=
>
> Does anybody recognize this? Any ideas on what to try next? Any help
> would be greatly appreciated.
>
> /Björn
>



-- 
Venatech AB
Ideon Innovation
Ole Römers väg 12
SE-22370 LUND
Sweden

+46 (0) 46 286 86 20
info@venatech.se
http://www.venatech.se
