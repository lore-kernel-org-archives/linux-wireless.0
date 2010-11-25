Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:38804 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0KYBpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:45:15 -0500
Date: Wed, 24 Nov 2010 21:45:11 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@gmail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101125014511.GA1683@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu> <AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
In-Reply-To: <AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 24, 2010 at 07:06:12PM +0000, Dave Kilroy wrote:
> On Mon, Nov 22, 2010 at 2:42 AM, Giacomo Comes <comes@naic.edu> wrote:
> > I'm having trouble with a wireless card using the orinoco driver.
> >
> > The card is (pccardctl ident output):
> >
> > Socket 2:
> > =A0product info: "Dell", "TrueMobile 1150 Series PC Card", "Version 01.=
01", ""
> > =A0manfid: 0x0156, 0x0002
> > =A0function: 6 (network)
>=20
> This is the same card I used to develop the WPA functionality in orinoco.
>=20
> > I'm running suse 11.3 with kernel 2.6.34.7
>=20
> > [ =A0 14.498825] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.=
id.au>, Pavel Roskin <proski@gnu.org>, et al)
> > [ =A0 14.587767] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
> > [ =A0 14.587897] orinoco_cs 2.0: Station identity =A0001f:0001:0008:000a
> > [ =A0 14.587906] orinoco_cs 2.0: Firmware determined as Lucent/Agere 8.=
10
> > [ =A0 14.587915] orinoco_cs 2.0: firmware: requesting agere_sta_fw.bin
> > [ =A0 14.698324] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
> > [ =A0 14.698457] orinoco_cs 2.0: Station identity =A0001f:0002:0009:0030
> > [ =A0 14.698466] orinoco_cs 2.0: Firmware determined as Lucent/Agere 9.=
48
> > [ =A0 14.698472] orinoco_cs 2.0: Ad-hoc demo mode supported
> > [ =A0 14.698478] orinoco_cs 2.0: IEEE standard IBSS ad-hoc mode support=
ed
> > [ =A0 14.698483] orinoco_cs 2.0: WEP supported, 104-bit key
> > [ =A0 14.698489] orinoco_cs 2.0: WPA-PSK supported
>=20
> This means the driver should have been setup appropriately.
>=20
> > [...]
> > [ =A0 32.967560] ADDRCONF(NETDEV_UP): eth1: link is not ready
> >
> >
> > NetworkManager is not able to connect to an AP and /var/log/messages co=
ntains:
> >
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982388] ------------[ cut here =
]------------
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982427] WARNING: at /usr/src/pa=
ckages/BUILD/kernel-desktop-2.6.34.7/linux-2.6.34/net/wireless/core.c:633 w=
dev_cleanup_work+0xb7/0xe0 [cfg80211]()
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982432] Hardware name: Latitude=
 C840
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982435] Modules linked in: fuse=
 ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit af_packet snd_pcm_oss snd_m=
ixer_oss snd_seq snd_seq_device edd cpufreq_conservative cpufreq_userspace =
cpufreq_powersave speedstep_ich speedstep_lib mperf ip6t_REJECT nf_conntrac=
k_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filt=
er ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack n=
f_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables loop dm_mod mic=
hael_mic orinoco_cs orinoco cfg80211 rfkill firewire_ohci firewire_core snd=
_intel8x0m pcmcia crc_itu_t snd_intel8x0 snd_ac97_codec ppdev ac97_bus iTCO=
_wdt sr_mod snd_pcm parport_pc ohci1394 yenta_socket rsrc_nonstatic dcdbas =
pcmcia_core ieee1394 3c59x video parport floppy snd_timer sg cdrom iTCO_ven=
dor_support snd battery ac pcspkr joydev soundcore snd_page_alloc shpchp pc=
i_hotplug ext4 jbd2 crc16 nouveau ttm drm_kms_helper drm i2c_algo_bit butto=
n intel_agp fan processor ata_generic thermal thermal_sys
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982543] Pid: 707, comm: cfg8021=
1 Not tainted 2.6.34.7-0.5-desktop #1
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982546] Call Trace:
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982570] =A0[<c02065c3>] try_sta=
ck_unwind+0x173/0x190
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982580] =A0[<c02051cf>] dump_tr=
ace+0x3f/0xe0
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982589] =A0[<c020662b>] show_tr=
ace_log_lvl+0x4b/0x60
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982595] =A0[<c0206658>] show_tr=
ace+0x18/0x20
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982607] =A0[<c064e0b3>] dump_st=
ack+0x6d/0x72
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982616] =A0[<c02443ae>] warn_sl=
owpath_common+0x6e/0xb0
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982623] =A0[<c0244403>] warn_sl=
owpath_null+0x13/0x20
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982635] =A0[<e2db5497>] wdev_cl=
eanup_work+0xb7/0xe0 [cfg80211]
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982657] =A0[<c025cfa9>] run_wor=
kqueue+0x79/0x170
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982665] =A0[<c025d123>] worker_=
thread+0x83/0xe0
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982673] =A0[<c025fef4>] kthread=
+0x74/0x80
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982681] =A0[<c0203826>] kernel_=
thread_helper+0x6/0x10
> > Nov 12 18:55:22 rescue kernel: [ =A0388.982688] ---[ end trace 3f0348b3=
b0c6f4ff ]---
> > Nov 12 18:55:25 rescue dhcpcd[6700]: eth1: dhcpcd not running
>=20
> I've never seen this before. It looks like a scan is in progress when
> cfg80211 tries to do some cleanup - while bringing the interface down.

The patch you posted made this trace disappear.

>=20
> > Nov 14 21:31:21 rescue ifup: =A0 =A0 eth1 =A0 =A0 =A0device: Dell
> > Nov 14 21:31:21 rescue ifup: TrueMobile 1150 Series PC Card
> > Nov 14 21:31:21 rescue ifup: Version 01.01
> > Nov 14 21:31:21 rescue ifup: =A0 =A0 eth1 =A0 =A0 =A0is controlled by i=
fplugd
> > Nov 14 21:31:21 rescue ifup: =A0 =A0 eth1 =A0 =A0 =A0device: Dell
> > Nov 14 21:31:21 rescue ifup: TrueMobile 1150 Series PC Card
> > Nov 14 21:31:21 rescue ifup: Version 01.01
> > Nov 14 21:31:21 rescue ifup-wireless: =A0 =A0 eth1 =A0 =A0 =A0warning: =
WPA configured, but is untested
> > Nov 14 21:31:21 rescue ifup-wireless: =A0 =A0 eth1 =A0 =A0 =A0warning: =
with this device
> > Nov 14 21:31:21 rescue ifup-wireless: =A0 =A0 eth1 =A0 =A0 =A0starting =
wpa_supplicant
> > Nov 14 21:31:21 rescue kernel: [ =A0 39.199513] ADDRCONF(NETDEV_UP): et=
h1: link is not ready
> > Nov 14 21:31:22 rescue ifup-dhcp: Starting DHCP4 client on eth1
> > Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: dhcpcd 3.2.3 starting
> > Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: hardware address =3D 00:02:2=
d:70:31:3b
> > Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: broadcasting for a lease
> > Nov 14 21:31:22 rescue ifup-dhcp: .
>=20
> <snip dhcp log> This isn't interesting. If wpa_supplicant hasn't
> connected you to an AP, dhcpcd isn't going to find anything.
>=20
> > It first tryes to connect to an AP using WPA, but it fails.
> > Thereafter it connects to a second AP using WEP.
>=20
> Can you provide wpa_supplicant logs? With a reasonable amount of
> debug. -dd should do.
>=20

Attached you will find the wpa_supplicant.log created with the
following command line:
wpa_supplicant -ieth1 -c wpa_supplicant.conf -f wpa_supplicant.log -dd

>=20
> > Another issue I have with the the orinoco_cs module is the following:
> > During suspend and resume there is a two minutes timeout period.
>=20
> > More precisely, after I start to suspend the laptop the screen
> > goes black, the message
> > =A0 =A0 =A0 =A0 =A0 =A0 s2disk: snapshotting the system
> > appears and then there is a two minutes period where the screen stays b=
lack
> > and nothing happens. After the two minutes, the messages snapshot ready
> > appears, the snapshot image is saved to the disk and the laptop turns o=
ff.
> > On resume, the kernel founds the snapshot image, loads it and then
> > stays two minutes doing nothing. After the two minutes, the text
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s2disk: returned to userspace
> > appears on screen, there is some disk activity and then the sistem is b=
ack.
> >
> > If I blacklist the orinoco_cs module, then suspend and resume work prop=
erly.
> >
> > I have no idea if the two problems are related or not. If any of the is=
sues
> > has been already discussed, please point me where I can find such discu=
ssion.
>=20
> This is new. Depending on your kernel config, orinoco will either try
> to keep a copy of firmware which it re-flashes on resume, or try read
> the firmware on suspend, which is freed on resume. Both worked circa
> 2.6.32.
>=20
> > If you need more informations or you want me to test some code let me k=
now.
>=20
> A wpa_supplicant log please. Note that the laptop I used to develop
> for (and on) has moved on, so there's only a limited number of things
> I can do to debug the issue.

If things don't go on, I will figure a way to give you access to the
truemobile card.

Regards.
Giacomo

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant.log"

Initializing interface 'eth1' conf 'wpa_supplicant.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Configuration file 'wpa_supplicant.conf' -> '/root/wpa_supplicant.conf'
Reading configuration file '/root/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='wheel'
Line: 3 - start of a new network block
ssid - hexdump_ascii(len=5):
     43 6f 6d 65 73                                    Comes           
PSK (ASCII passphrase) - hexdump_ascii(len=18): [REMOVED]
key_mgmt: 0x2
priority=5 (0x5)
proto: 0x1
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Priority group 5
   id=0 ssid='Comes'
WEXT: cfg80211-based driver detected
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0x5
  capabilities: key_mgmt 0x5 enc 0x7 flags 0x0
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:02:2d:70:31:3b
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=4 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=5 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_countermeasures
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): 65 86 3e 36 18 13 57 3a b2 46 2f 88 c6 00 3e 7d
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
ctrl_interface_group=10 (from group name 'wheel')
Added interface eth1
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b06 len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
Wireless event: cmd=0x8b1a len=8
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 5 seconds
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
Scan timeout - try to get results
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.
Setting scan request: 1 sec 0 usec
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface eth1
No keys have been configured - skip key clearing
State: SCANNING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
wpa_driver_wext_set_countermeasures
No keys have been configured - skip key clearing
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6

--ikeVEW9yuYc//A+q--
