Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37950 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdAXQlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 11:41:05 -0500
Received: by mail-wm0-f51.google.com with SMTP id r144so218206148wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 08:41:04 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: openwrt-devel@lists.openwrt.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
        ath10k@lists.infradead.org,
        "Pedersen, Thomas" <twp@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [OpenWrt-Devel] ath10k mesh + ap + encryption?
Date: Tue, 24 Jan 2017 17:41:01 +0100
Message-ID: <2853028.UifzgH78X3@bentobox> (sfid-20170124_174118_676860_633F3D9F)
In-Reply-To: <2962659.7QzjSqzP6C@bentobox>
References: <2661831.slnB0LOeVt@prime> <5898628.mmcCycDigQ@prime> <2962659.7QzjSqzP6C@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2205884.Fjh6GFGQaA"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2205884.Fjh6GFGQaA
Content-Type: multipart/mixed; boundary="nextPart2106001.IEj1CzrAWl"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart2106001.IEj1CzrAWl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 19. September 2016 11:34:00 CET Sven Eckelmann wrote:
> On Montag, 19. September 2016 08:43:56 CEST Simon Wunderlich wrote:
> [...]
> > > We're testing encrypted AP + Mesh quite successfully right now with
> > > this firmware: https://github.com/kvalo/ath10k-firmware/commit/307cb46b
> > > 06661ebd3186723b5002de769c7add83, of course that is for a QCA4019 chip.
> > > Which chip are you using? I can poke the firmware guys for possibility
> > > of getting a 10.4.3.2 firmware build for it.
[...]
>                | 802.11s encrypted | 802.11s unencrypted
> ---------------+-------------------+--------------------
> AP encrypted   | AP doesn't beacon | works
> AP unencrypted | AP doesn't beacon | works
> 
> I've also checked 10.2.4.70.12-2 (doesn't seem to support encrypted mesh at 
> all) and with rawmode=1 (makes no difference).

I just tested it with a IPQ4019 with the (10.4-)3.2.1-00050 image. And I see a 
similar problem with it. But the AP was not actually active (device was in AP 
mode but no channel was set and it didn't beacon). So we end up again with an 
incomplete initialized AP but hostapd was running.

I've simply disabled the LEDE wifi stuff and ran the attached autostart.sh 
manually. This seemed to work fine. This is rather odd because the same 
configuration for wpa_supplicant and hostapd was used. It also works fine with 
the normal LEDE setup scripts when encryption on the mesh device is disabled 
and it also works fine with ath9k.

With the LEDE scripts/netifd, hostapd thought that the AP went up:

    root@lede:/# hostapd_cli status
    Selected interface 'wlan0-1'
    state=ENABLED
    phy=phy0
    freq=2462
    num_sta_non_erp=0
    num_sta_no_short_slot_time=0
    num_sta_no_short_preamble=0
    olbc=0
    num_sta_ht_no_gf=0
    num_sta_no_ht=0
    num_sta_ht_20_mhz=0
    num_sta_ht40_intolerant=0
    olbc_ht=1
    ht_op_mode=0x11
    cac_time_seconds=0
    cac_time_left_seconds=N/A
    channel=11
    secondary_channel=0
    ieee80211n=1
    ieee80211ac=0
    bss[0]=wlan0-1
    bssid[0]=ac:86:74:00:0e:35
    ssid[0]=LEDE3-1
    num_sta[0]=0

iw dev didn't think so:

    Interface wlan0-1
            ifindex 13
            wdev 0x5
            addr ac:86:74:00:0e:35
            type AP
            txpower 30.00 dBm

Interestingly, it sometimes (randomly) started to work when the AP interface 
was switched to psk2 for encryption instead of using an unencrypted AP.

Right now, it looks like an odd timing problem. Has someone else a good idea 
what to test?


Btw. we never received any (10.4-)3.2 based firmware for QCA988X from QCA. But 
I am also not sure if I find time to retest it again with QCA988x.

Kind regards,
	Sven
--nextPart2106001.IEj1CzrAWl
Content-Disposition: attachment; filename="wpa_supplicant.conf"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="wpa_supplicant.conf"

network={
        ssid="openmesh"
        key_mgmt=SAE
        mode=5
        frequency=2462
        psk="9f0a965af38f2d0a13b66d8b46ab962c"
        mcast_rate=18
}

--nextPart2106001.IEj1CzrAWl
Content-Disposition: attachment; filename="hostapd.conf"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="hostapd.conf"

driver=nl80211
logger_syslog=127
logger_syslog_level=2
logger_stdout=127
logger_stdout_level=2
hw_mode=g
channel=11
ieee80211n=1
ht_coex=0
ht_capab=[LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935][DSSS_CCK-40]
interface=wlan0-1
ctrl_interface=/var/run/hostapd
ap_isolate=1
disassoc_low_ack=1
preamble=1
wmm_enabled=1
ignore_broadcast_ssid=0
uapsd_advertisement_enabled=1
auth_algs=1
wpa=0
ssid=LEDE3-1
bridge=br-lan
bssid=00:11:22:33:17:02

--nextPart2106001.IEj1CzrAWl
Content-Disposition: attachment; filename="wifi.lede.config"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="wifi.lede.config"

config wifi-device 'radio0'
        option type 'mac80211'
        option channel '11'
        option hwmode '11g'
        option path 'platform/soc/a000000.wifi'
        option htmode 'HT20'
        option disabled '0'

config wifi-iface 'extra_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'LEDE3-1'
        option encryption 'none'
        option disabled 0
        option macaddr 'ac:86:74:00:0e:35'

config wifi-iface 'default_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'LEDE2-1'
        option encryption 'psk2'
        option key 'testtest'
        option macaddr 'ac:86:74:00:0e:36'
        option disabled 1

config wifi-iface 'wmesh0'
        option device 'radio0'
        option ifname 'mesh0'
        option network 'lan'
        option mode 'mesh'
        option mesh_id 'openmesh'
        option disabled '0'
        option mcast_rate '18000'
        option macaddr 'ac:86:74:00:0e:37'
        option mesh_ttl 1
        option mesh_fwding 0
#        option encryption 'none'
        option ieee80211w 1
        option encryption 'psk2+aes'
        option key '9f0a965af38f2d0a13b66d8b46ab962c'

--nextPart2106001.IEj1CzrAWl
Content-Disposition: attachment; filename="autostart.sh"
Content-Transfer-Encoding: 7Bit
Content-Type: application/x-shellscript; name="autostart.sh"

cat > /tmp/hostapd.conf << EOF
driver=nl80211
logger_syslog=127
logger_syslog_level=2
logger_stdout=127
logger_stdout_level=2
hw_mode=g
channel=11
ieee80211n=1
ht_coex=0
ht_capab=[LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935][DSSS_CCK-40]
interface=wlan0-1
ctrl_interface=/var/run/hostapd
ap_isolate=1
disassoc_low_ack=1
preamble=1
wmm_enabled=1
ignore_broadcast_ssid=0
uapsd_advertisement_enabled=1
auth_algs=1
wpa=0
ssid=LEDE3-1
bridge=br-lan
bssid=00:11:22:33:17:02
EOF
cat > /tmp/wpa_supplicant.conf << EOF
network={
        ssid="openmesh"
        key_mgmt=SAE
        mode=5
        frequency=2462
        psk="9f0a965af38f2d0a13b66d8b46ab962c"
        mcast_rate=18
}
EOF

iw dev wlan0 del
iw phy phy0 interface add wlan0-1 type managed
iw phy phy0 interface add mesh0 type mp
ip link set dev wlan0-1 address 00:11:22:33:17:02
ip link set up dev mesh0
brctl addif br-lan mesh0
hostapd -d /tmp/hostapd.conf  &
ip link set up dev wlan0-1
wpa_supplicant -Dnl80211 -b br-lan -i mesh0 -c /tmp/wpa_supplicant.conf  &

--nextPart2106001.IEj1CzrAWl--

--nextPart2205884.Fjh6GFGQaA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAliHg50ACgkQXYcKB8Em
e0ZG0RAA1v3nEq7V/vwFiuwFDSOi9wz4uSkDHq2KaoXsEh/2FKo5sTOKS6F/2jnv
xXPQwZ45QmX/PE3d6eki/IJNDt16poImlidfwxSGxJOUHz99aLJ740gP8e7/81Df
Bu/aEv9cXv6mp5w7Nja20Qjevvcx/l1Ch6Q4DJ7n6nX0QyIxKeqi9c7DZt4puv22
MBBBLnHJPud1MvFvoCylGLG4GqJR0Dc5d13SNebEjFIpxbwkgGvoktQ/3IPGrA9d
A4mlQ1IUcOYNjXJcOuXToXqELS5InvYtb90/zVaMuFqSuQA99LdQ78I5g0V+q87Q
emvQ4UNadL39UICfMb6KZQBSNd9OcssUpy3PMXkqoO/pq5SnRQ1p7crtGBXRwtEx
oqhGdp98YSCruq+mrAc7I5j2quD4tKpr6G4SZEIS8kuMhCuNNgPX/XhQNtYRn7Jn
HD87tJ1NM0ox1yfLjTSZd/s2Y2W0WsojD3EVpycKV8mD2ARm99M+DKlqHha/OGMK
zmnc7G/MVwWaz2s8uN2EjoRz8MJ2GQO4b/r05+jJ8gDJrpYuEvJcNv7qfnrDTBlx
kIT7PvMAnvrygJdY3p5XjhPQB6Q7M0VnoEtPSB24hfxKFDd+cLPqu+EDZYSVt52O
9TahFqAJJJixN5f/IRy6gaqF0iM7SxnW9OEH1TMEauHCYsyw7Ls=
=8l0B
-----END PGP SIGNATURE-----

--nextPart2205884.Fjh6GFGQaA--
