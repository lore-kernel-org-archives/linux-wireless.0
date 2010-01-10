Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37410 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab0AJWag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:30:36 -0500
Message-ID: <4B4A5502.8080305@hauke-m.de>
Date: Sun, 10 Jan 2010 23:30:26 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: kernel panic with b43 and hostap on mips
References: <4B490DF9.10802@hauke-m.de> <4B492AC1.2080908@lwfinger.net>
In-Reply-To: <4B492AC1.2080908@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4C45EB34C0E714EA11CC399A"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4C45EB34C0E714EA11CC399A
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Larry Finger wrote:
> On 01/09/2010 05:15 PM, Hauke Mehrtens wrote:
>> Hi,
>>
>> I am using compat-wireless of 2010-01-07 and mac80211: fix netdev
>> queues, mac80211: fix a few work bugs and mac80211: fix endian error b=
y
>> Johannes.
>>
>> The system is running OpenWrt with kernel 2.6.30.10 on Asus WL-500GP
>> (brcm47xx system mips) and hostap git of 2010-01-08.
>>
>> The Systems and hostapd starts normal, but if a client tries to connec=
t
>> to the access point the AP crashes. Without encryption it works withou=
t
>> any problems but with PSK and WPA1 the system crashes with the attache=
d
>> panic. I have not tried other encryption modes. With compat-wireless o=
f
>> 2009-12-05 and hostap git of 2009-11-29 the system worked link expecte=
d.
>=20
> Can you run compat-wireless of 01-07 with hostap of 11-29 to isolate th=
e problem
> in compat-wireless? If that shows the problem in compat-wireless, can y=
ou
> perform what amounts to a bisection?

Hi,

hostapd of 2010-01-08 and compat-wireless of 2009-12-05 are working
together. With compat-wireless of 2010-01-01 hostapd says "Failed to
remove interface (ifidx=3D0)" and no connection to the ap is possible.
With compat-wireless of 2010-01-05 hostap says nothing while a client
tries to connect.
For the tests today I used kernel 2.6.32.3.

It is hard to biselect the issue, because the AP mode did not worked for
some time on my device.
On an AMD64 System with Ubuntu 9.10 (kernel 2.6.31) and compat-wireless
of 2010-01-07 with the same hostapd version I have no problems.

Here is an other log of the error combined with hostapd debug log with
hostapd 20100108 and compat-wireless 2010-01-07.

Hauke


122.439116: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
122.439224: Unknown event 5
122.439342: RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11043
([UP][RUNNING][LOWER_UP])
122.439491: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
122.439661: Unknown event 5
151.228297: mgmt::proberesp cb
151.284292: mgmt::proberesp cb
151.344281: mgmt::proberesp cb
175.820380: mgmt::proberesp cb
175.880294: mgmt::proberesp cb
175.944281: mgmt::proberesp cb
177.024713: mgmt::auth
177.024924: authentication: STA=3D00:25:d3:24:81:99 auth_alg=3D0
auth_transaction=3D1 status_code=3D0 wep=3D0
177.025127:   New STA
177.025390: wlan0: STA 00:25:d3:24:81:99 IEEE 802.11: authentication OK
(open system)
177.025749: wlan0: STA 00:25:d3:24:81:99 MLME:
MLME-AUTHENTICATE.indication(00:25:d3:24:81:99, OPEN_SYSTEM)
177.0260CPU 0 Unable to handle kernel paging request at virtual address
00000000, epc =3D=3D 801a8efc, ra =3D=3D 801a8ee4
03: wlan0: STA 0Oops[#1]:
Cpu 0
$ 0   : 00000000 00478aa3 00002000 00027a80
$ 4   : 000011a0 8151c780 00000003 00000005
$ 8   : 00000002 00000001 00100000 00000000
$12   : 00000000 00000000 00000083 00470000
$16   : 00000000 81462e00 8151c780 81ff0000
$20   : 00000000 8186c940 00000091 00000000
$24   : 00000001 814f58e1
$28   : 8152e000 8152fc58 81debe00 801a8ee4
Hi    : 00000000
Lo    : 00000080
epc   : 801a8efc dev_queue_xmit+0x1d8/0x5dc
    Not tainted
ra    : 801a8ee4 dev_queue_xmit+0x1c0/0x5dc
Status: 1000d803    KERNEL EXL IE
Cause : 00800008
BadVA : 00000000
PrId  : 00029006 (Broadcom BCM3302)
Modules linked in: nf_nat_tftp nf_conntrack_tftp nf_nat_irc
nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat
nf_nat xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4
nf_conntrack pppoe pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_multiport
xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp
x_tables ppp_async ppp_generic slhc b43legacy b43 mac80211 cfg80211
crc_ccitt arc4 aes_generic deflate ecb cbc switch_robo switch_core diag
Process hostapd (pid: 1058, threadinfo=3D8152e000, task=3D81c439b8,
tls=3D00000000)
Stack : 00000000 8186c940 00000091 00000000 81debe00 80197b38 81e08000
8151c780
        81ff0000 00000091 00000300 00000000 8186c940 8022008c 81e08000
8152fe28
        00000000 8152fd38 818041a0 8001dcc0 00000000 801a1164 00000000
8152fd38
        00000000 00000024 8152fce8 801c6b84 0319bfe0 802f0200 00000422
00000000
        00000000 00000000 8152fd58 00000000 00000091 8152fe24 8152fe44
8152fe44
        ...
Call Trace:
[<801a8efc>] dev_queue_xmit+0x1d8/0x5dc
[<8022008c>] packet_sendmsg+0x9c4/0xb9c
[<80194470>] sock_sendmsg+0xa8/0xd8
[<80194648>] sys_sendmsg+0x1a8/0x224
[<80003230>] stack_done+0x20/0x3c


Code: 3042cfff  34422000  a642007a <8e030000> 106000a8  00000000
8e02004c  30420004  10400005
Disabling lock debugging due to kernel taint
0:25:d3:24:81:99Kernel panic - not syncing: Fatal exception in interrupt
 MLME: MLME-DELERebooting in 3 seconds..TEKEYS.request(00:25:d3:24:81:99)=

177.026164: authentication reply: STA=3D00:25:d3:24:81:99 auth_alg=3D0
auth_transaction=3D2 resp=3D0 (IE len=3D0)
177.028302: mgmt::auth cb
177.028563: wlan0: STA 00:25:d3:24:81:99 IEEE 802.11: authenticated
177.029915: mgmt::reassoc_req
177.030043: reassociation request: STA=3D00:25:d3:24:81:99
capab_info=3D0x431 listen_interval=3D10 current_ap=3D00:1a:92:ea:73:12
177.030320: Validating WMM IE: OUI 00:50:f2  OUI type 2  OUI sub-type 0
 version 1  QoS info 0x0
177.030540:   new AID 1
177.030760: wlan0: STA 00:25:d3:24:81:99 IEEE 802.11: association OK (aid=
 1)
177.033298: mgmt::reassoc_resp cb
177.033576: wlan0: STA 00:25:d3:24:81:99 IEEE 802.11: associated (aid 1)
177.034240: wlan0: STA 00:25:d3:24:81:99 MLME:
MLME-REASSOCIATE.indication(00:25:d3:24:81:99)
177.034567: wlan0: STA 00:25:d3:24:81:99 MLME:
MLME-DELETEKEYS.request(00:25:d3:24:81:99)
177.036355: wpa_driver_nl80211_set_key: ifindex=3D8 alg=3D0 addr=3D0x4788=
48
key_idx=3D0 set_tx=3D1 seq_len=3D0 key_len=3D0
177.036611:    addr=3D00:25:d3:24:81:99
177.047463: wlan0: STA 00:25:d3:24:81:99 WPA: event 1 notification
177.048974: wpa_driver_nl80211_set_key: ifindex=3D8 alg=3D0 addr=3D0x4788=
48
key_idx=3D0 set_tx=3D1 seq_len=3D0 key_len=3D0
177.049226:    addr=3D00:25:d3:24:81:99
177.049898: wlan0: STA 00:25:d3:24:81:99 WPA: start authentication
177.050027: WPA: 00:25:d3:24:81:99 WPA_PTK entering state INITIALIZE
177.051323: wpa_driver_nl80211_set_key: ifindex=3D8 alg=3D0 addr=3D0x4788=
48
key_idx=3D0 set_tx=3D1 seq_len=3D0 key_len=3D0
177.051575:    addr=3D00:25:d3:24:81:99
177.053702: wlan0: STA 00:25:d3:24:81:99 IEEE 802.1X: unauthorizing port
177.053829: WPA: 00:25:d3:24:81:99 WPA_PTK_GROUP entering state IDLE
177.053975: WPA: 00:25:d3:24:81:99 WPA_PTK entering state AUTHENTICATION
177.054197: WPA: 00:25:d3:24:81:99 WPA_PTK entering state AUTHENTICATION2=

177.054344: WPA: 00:25:d3:24:81:99 WPA_PTK entering state INITPSK
177.054535: WPA: 00:25:d3:24:81:99 WPA_PTK entering state PTKSTART
177.054814: wlan0: STA 00:25:d3:24:81:99 WPA: sending 1/4 msg of 4-Way
Handshake
177.054914: WPA: Send EAPOL(version=3D1 secure=3D0 mic=3D0 ack=3D1 instal=
l=3D0
pairwise=3D8 kde_len=3D0 keyidx=3D0 encr=3D0)



--------------enig4C45EB34C0E714EA11CC399A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLSlUDAAoJEIZ0px9YPRMy8c8P/0xD1lHbhGGX/RD//A9lIJyC
jYHR7pGz4ddMjbdbbJLXg6xkTzJVJ9TlO0Zqyb/k02eI9OVIIW6DCwKG+MveJ+u9
pgWfg0mk6s2KC3zhRQxPpDEKllg/k9/W2LsRlfdL3CMwF+t6OYktiwFnfmSIDBaZ
+bsN7HhfGZnPiedEidVIbXiktGNGPRSsxwFgzEiwhznNgdkF57MmVU9Z6CdKvJYY
rIv/QsNgUU3QUXxOyduA/B6ctimiPoNVwj9D/57tNcVxB8GUJu8YV9VromLB3w6s
NpEsLaCePuEeKLwNWDncht2vscPgGPA1UYNzQCar8lWEA/qgIsxVcR4ciVX7WN6i
IeUSiN+jKG0dRFsyIfhR6B/e3o2fTjtV+QRYyOPfJrnw/D1pZFOKBBi5d/WKB9KP
RkeAoszLGV5CCjPv3A0gdZkQzfG57QETEqX/hoNTO3mjlguiMFkO5MDMW7T0vmfp
ZEcLgF8NsIIj4eRRD9ZC/cpdxrK8AgaTHazPZtTZPvylriLNBFcYmMB18CeD9jvb
XjC4Wdl2XgHJnbYWaqynp4nJlyuFYVrnpsFFYKVycEDQ2EecjNhnx8E+uwzkHGMH
UdFRvTI4+WZLThoMDhTDuRZegUeOdb3f6op0UW7Latm1jPQIXCizVL/NZQbKPcQs
6cppFFr9zsohb2ZXqeWa
=siqh
-----END PGP SIGNATURE-----

--------------enig4C45EB34C0E714EA11CC399A--
