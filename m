Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:45243 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbbBFOp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 09:45:27 -0500
Received: by mail-we0-f169.google.com with SMTP id x3so10455589wes.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 06:45:25 -0800 (PST)
Message-ID: <54D4D37C.2060007@phoenix-aerial.com> (sfid-20150206_154534_388611_062B090F)
Date: Fri, 06 Feb 2015 14:45:16 +0000
From: Ben Adler <ben@phoenix-aerial.com>
MIME-Version: 1.0
To: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Arend van Spriel <arend@broadcom.com>
Subject: Re: BCM4330 linux support
References: <54D3FF89.502@phoenix-aerial.com> <54D4851F.8020402@broadcom.com>
In-Reply-To: <54D4851F.8020402@broadcom.com>
Content-Type: multipart/mixed;
 boundary="------------040207080401090706030200"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040207080401090706030200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Arend, thanks for your prompt reply!

On 06.02.2015 09:10, Arend van Spriel wrote:
>> Arend, is it possible to make this chip work? Just STA, or also AP? If
>> so, which firmware and NVRAM files will I need?
>
> Well, I have this chip running on regular x86 laptop using special
> adapter boards and it also runs on i.MX6 board. The windows firmware and
> nvram should work.

Did you compare the md5 hash to your firmware? Are there different 
versions with different feature sets?

Does AP also work for you?

 > Can you send a kernel log preferably with
 > driver module loaded with 'debug=0xd416'.

Ok, added the module options and powercycled:

# cat /sys/module/brcmfmac/parameters/debug
54294

Please find attached:

1) output of iw_list

2) dmesg.txt: simple bootup, nothing done to wlan0.

3) dmesg_sta.txt: I added wlan0 client configuration in ubuntu's 
/etc/network/interfaces, so it has launched wpa_supplicant, which 
probably is repsonsible for the errors at the end.

4) dmesg_hostapd.txt: dmesg output, hostapd config and output

When I start neither wpa_supplicant nor hostapd, iwconfig says:

wlan0     IEEE 802.11abgn  ESSID:off/any
           Mode:Managed  Access Point: Not-Associated
           Retry short limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:on

When I configure wlan0 as STA, I get

wlan0     IEEE 802.11abgn  ESSID:off/any
           Mode:Managed  Access Point: Not-Associated   Tx-Power=1496 dBm
           Retry short limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:on

(Note the txpower :)

It seems like the debug options haven't really added much detail to 
dmesg. Do you need to see anything else? It's just a test install right 
now; I don't mind sharing SSH access.

Thanks!
Ben

--------------040207080401090706030200
Content-Type: text/plain; charset=UTF-8;
 name="dmesg_hostapd.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_hostapd.txt"

# cat /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
ssid=test
hw_mode=g
channel=1
auth_algs=3
ieee80211n=0
wpa=2
wpa_passphrase=somepassword
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP


# rfkill list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no


# hostapd -dd /etc/hostapd/hostapd.conf
random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
nl80211: Using driver-based roaming
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:6
nl80211: Using driver-based off-channel TX
nl80211: Supported vendor command: vendor_id=0x1018 subcmd=1
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Enable multi-channel concurrent (driver advertised support)
nl80211: interface wlan0 in phy phy0
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Setup AP(wlan0) - device_ap_sme=0 use_monitor=1
nl80211: Create interface iftype 6 (MONITOR)
Failed to create interface mon.wlan0: -95 (Operation not supported)
nl80211: Driver does not support monitor interface type - try to run without it
nl80211: Enable Probe Request reporting nl_preq=0x1ecf790
nl80211: Register frame type=0x40 nl_handle=0x1ecf790 match=
nl80211: Register frame command failed (type=64): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Failed to enable Probe Request frame reporting in AP mode
nl80211: Add own interface ifindex 3
nl80211: Do not indicate P2P_DEVICE support (p2p_device=1 driver param not specified)
phy: phy0
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz 20 mBm
nl80211: 2457-2482 @ 40 MHz 20 mBm
nl80211: 2474-2494 @ 20 MHz 20 mBm
nl80211: 5170-5250 @ 40 MHz 20 mBm
nl80211: 5735-5835 @ 40 MHz 20 mBm
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=13 freq=2472 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=14 freq=2484 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=34 freq=5170 MHz max_tx_power=4 dBm
Allowed channel: mode=2 chan=36 freq=5180 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=38 freq=5190 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=40 freq=5200 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=42 freq=5210 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=44 freq=5220 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=46 freq=5230 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=48 freq=5240 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=52 freq=5260 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=56 freq=5280 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=60 freq=5300 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=64 freq=5320 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=100 freq=5500 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=104 freq=5520 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=108 freq=5540 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=112 freq=5560 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=116 freq=5580 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=120 freq=5600 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=124 freq=5620 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=128 freq=5640 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=132 freq=5660 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=136 freq=5680 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=140 freq=5700 MHz max_tx_power=0 dBm
Allowed channel: mode=2 chan=149 freq=5745 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=153 freq=5765 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=157 freq=5785 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=161 freq=5805 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=165 freq=5825 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=13 freq=2472 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=14 freq=2484 MHz max_tx_power=20 dBm
Completing interface initialization
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
DFS 0 channels required radar detection
nl80211: Set freq 2412 (ht_enabled=0, vht_enabled=0, bandwidth=20 MHz, cf1=2412 MHz, cf2=0 MHz)
RATE[0] rate=10 flags=0x1
RATE[1] rate=20 flags=0x1
RATE[2] rate=55 flags=0x1
RATE[3] rate=110 flags=0x1
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
hostapd_setup_bss(hapd=0x1ed27b0 (wlan0), first=1)
wlan0: Flushing old station entries
nl80211: flush -> DEL_STATION wlan0 (all)
nl80211: Station flush failed: ret=-14 (Bad address)
wlan0: Could not connect to kernel driver
wlan0: Deauthenticate all stations
nl80211: sta_remove -> DEL_STATION wlan0 ff:ff:ff:ff:ff:ff --> 0 (Success)
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
Using interface wlan0 with hwaddr 04:e6:76:16:eb:80 and ssid "test"
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test
PSK (ASCII passphrase) - hexdump_ascii(len=12): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
random: Got 15/20 bytes from /dev/random
random: Only 15/20 bytes of strong random data available from /dev/random
random: Not enough entropy pool available for secure operations
WPA: Not enough entropy in random pool for secure operations - update keys later when the first station connects
Get randomness: len=32 entropy=0
GMK - hexdump(len=32): [REMOVED]
Get randomness: len=32 entropy=0
Key Counter - hexdump(len=32): [REMOVED]
WPA: Delay group state machine start until Beacon frames have been configured
VLAN: vlan_set_name_type(name_type=2)
nl80211: Set beacon (beacon_set=0)
nl80211: Beacon head - hexdump(len=55): 80 00 00 00 ff ff ff ff ff ff 04 e6 76 16 eb 80 04 e6 76 16 eb 80 00 00 00 00 00 00 00 00 00 00 64 00 11 04 00 04 74 65 73 74 01 08 82 84 8b 96 0c 12 18 24 03 01 01
nl80211: Beacon tail - hexdump(len=31): 2a 01 04 32 04 30 48 60 6c 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: ifindex=3
nl80211: beacon_int=100
nl80211: dtim_period=2
nl80211: ssid - hexdump_ascii(len=4):
     74 65 73 74                                       test
nl80211: hidden SSID not in use
nl80211: privacy=1
nl80211: auth_algs=0x3
nl80211: wpa_version=0x2
nl80211: key_mgmt_suites=0x2
nl80211: pairwise_ciphers=0x10
nl80211: group_cipher=0x10
nl80211: Beacon set failed: -52 (Invalid exchange)
Failed to set beacon parameters
wlan0: Unable to setup interface.
hostapd_interface_deinit_free(0x1eced90)
hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
hostapd_interface_deinit(0x1eced90)
hostapd_bss_deinit: deinit bss wlan0
wlan0: Flushing old station entries
nl80211: flush -> DEL_STATION wlan0 (all)
nl80211: Station flush failed: ret=-14 (Bad address)
wlan0: Could not connect to kernel driver
wlan0: Deauthenticate all stations
nl80211: sta_remove -> DEL_STATION wlan0 ff:ff:ff:ff:ff:ff --> 0 (Success)
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
hostapd_cleanup(hapd=0x1ed27b0 (wlan0))
hostapd_free_hapd_data(wlan0)
hostapd_interface_deinit_free: driver=0x4bc8e0 drv_priv=0x1ed36a0 -> hapd_deinit
nl80211: Remove monitor interface: refcount=0
nl80211: Remove beacon (ifindex=3)
netlink: Operstate: ifindex=3 linkmode=0 (kernel-control), operstate=6 (IF_OPER_UP)
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Teardown AP(wlan0) - device_ap_sme=1 use_monitor=1
hostapd_interface_free(0x1eced90)
hostapd_interface_free: free hapd 0x1ed27b0
hostapd_cleanup_iface(0x1eced90)
hostapd_cleanup_iface_partial(0x1eced90)
hostapd_cleanup_iface: free iface=0x1eced90




# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-031900rc6-generic (kernel@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201501261152 SMP Mon Jan 26 16:53:27 UTC 2015
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-031900rc6-generic root=UUID=0eb830d0-4493-422e-9d21-b2dea11e96c9 ro vt.handoff=1 nosplash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x00000000763cafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000763cb000-0x00000000763fafff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000763fb000-0x0000000076425fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076426000-0x00000000764cdfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000764ce000-0x00000000765e1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000765e2000-0x000000007662afff] type 20
[    0.000000] BIOS-e820: [mem 0x000000007662b000-0x0000000076cfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0x76425000  ACPI 2.0=0x76425014  SMBIOS=0x765e1390
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x000000000008f000) (0MB)
[    0.000000] efi: mem01: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000090000-0x000000000009e000) (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x00000000014d5000) (19MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000014d5000-0x0000000002000000) (11MB)
[    0.000000] efi: mem06: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000002000000-0x00000000033d5000) (19MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000033d5000-0x0000000020000000) (460MB)
[    0.000000] efi: mem08: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000020200000-0x0000000035ca6000) (346MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000035ca6000-0x0000000036e4b000) (17MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000036e4b000-0x00000000560cc000) (498MB)
[    0.000000] efi: mem12: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000560cc000-0x0000000072d00000) (460MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072d00000-0x0000000072d20000) (0MB)
[    0.000000] efi: mem14: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072d20000-0x0000000072f5f000) (2MB)
[    0.000000] efi: mem15: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072f5f000-0x0000000072f74000) (0MB)
[    0.000000] efi: mem16: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072f74000-0x0000000075dcb000) (46MB)
[    0.000000] efi: mem17: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000075dcb000-0x0000000076259000) (4MB)
[    0.000000] efi: mem18: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076259000-0x0000000076263000) (0MB)
[    0.000000] efi: mem19: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076263000-0x00000000763cb000) (1MB)
[    0.000000] efi: mem20: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000763cb000-0x00000000763fb000) (0MB)
[    0.000000] efi: mem21: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000763fb000-0x0000000076426000) (0MB)
[    0.000000] efi: mem22: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076426000-0x00000000764ce000) (0MB)
[    0.000000] efi: mem23: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000764ce000-0x00000000765e2000) (1MB)
[    0.000000] efi: mem24: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000765e2000-0x000000007662b000) (0MB)
[    0.000000] efi: mem25: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007662b000-0x0000000076cf6000) (6MB)
[    0.000000] efi: mem26: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076cf6000-0x0000000076cf7000) (0MB)
[    0.000000] efi: mem27: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076cf7000-0x0000000076d00000) (0MB)
[    0.000000] efi: mem28: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] efi: mem29: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed01000-0x00000000fed02000) (0MB)
[    0.000000] efi: mem30: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed08000-0x00000000fed09000) (0MB)
[    0.000000] efi: mem31: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000ffb00000-0x0000000100000000) (5MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: ZOTAC ZBOX-PI320 Series/ZBOX-PI320, BIOS B253P013 10/29/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x76d00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 060000000 mask FF0000000 write-back
[    0.000000]   3 base 070000000 mask FF8000000 write-back
[    0.000000]   4 base 070000000 mask FF8000000 write-back
[    0.000000]   5 base 077000000 mask FFF000000 uncachable
[    0.000000]   6 base 076E00000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1GB, range: 512MB, type WB
[    0.000000] reg 2, base: 1536MB, range: 256MB, type WB
[    0.000000] reg 3, base: 1792MB, range: 128MB, type WB
[    0.000000] reg 4, base: 1792MB, range: 128MB, type WB
[    0.000000] reg 5, base: 1904MB, range: 16MB, type UC
[    0.000000] reg 6, base: 1902MB, range: 2MB, type UC
[    0.000000] total RAM covered: 1902M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 4      lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 1902MB, range: 2MB, type UC
[    0.000000] reg 2, base: 1904MB, range: 16MB, type UC
[    0.000000] reg 3, base: 1920MB, range: 128MB, type UC
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fd0000, 0x02fd0fff] PGTABLE
[    0.000000] BRK [0x02fd1000, 0x02fd1fff] PGTABLE
[    0.000000] BRK [0x02fd2000, 0x02fd2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x76000000-0x761fffff]
[    0.000000]  [mem 0x76000000-0x761fffff] page 2M
[    0.000000] BRK [0x02fd3000, 0x02fd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x60000000-0x75ffffff]
[    0.000000]  [mem 0x60000000-0x75ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40000000-0x5fffffff]
[    0.000000]  [mem 0x40000000-0x5fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x76200000-0x763cafff]
[    0.000000]  [mem 0x76200000-0x763cafff] page 4k
[    0.000000] BRK [0x02fd4000, 0x02fd4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7662b000-0x76cfffff]
[    0.000000]  [mem 0x7662b000-0x767fffff] page 4k
[    0.000000]  [mem 0x76800000-0x76bfffff] page 2M
[    0.000000]  [mem 0x76c00000-0x76cfffff] page 4k
[    0.000000] BRK [0x02fd5000, 0x02fd5fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35ca6000-0x36e4afff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x0000000076425014 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x0000000076424100 000084 (v01 ALASKA A M I    00000003 MSFT 0100000D)
[    0.000000] ACPI: FACP 0x0000000076422000 00010C (v05 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: DSDT 0x000000007640E000 00FA77 (v02 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: MSDM 0x0000000076423000 000055 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: UEFI 0x0000000076492000 000042 (v01 ALASKA A M I    00000000      00000000)
[    0.000000] ACPI: HPET 0x0000000076421000 000038 (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: LPIT 0x0000000076420000 000104 (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: APIC 0x000000007641F000 00006C (v03 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: MCFG 0x000000007641E000 00003C (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: FPDT 0x0000000076407000 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x0000000076406000 000763 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076405000 000290 (v01 PmRef  Cpu0Tst  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076404000 00017A (v01 PmRef  ApTst    00003000 INTL 20061109)
[    0.000000] ACPI: CSRT 0x000000007640D000 00014C (v00 ALASKA A M I    00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000076cfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x7625d000-0x76261fff]
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff880070a00000-ffff8800727fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0x76cfffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x763cafff]
[    0.000000]   node   0: [mem 0x7662b000-0x76cfffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x76cfffff]
[    0.000000] On node 0 totalpages: 485436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7540 pages used for memmap
[    0.000000]   DMA32 zone: 481440 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics stolen memory at 0x77000000-0x7effffff
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x763cb000-0x763fafff]
[    0.000000] PM: Registered nosave memory: [mem 0x763fb000-0x76425fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76426000-0x764cdfff]
[    0.000000] PM: Registered nosave memory: [mem 0x764ce000-0x765e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x765e2000-0x7662afff]
[    0.000000] e820: [mem 0x7f000000-0xe00f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880076000000 s86976 r8192 d31808 u524288
[    0.000000] pcpu-alloc: s86976 r8192 d31808 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 477810
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-031900rc6-generic root=UUID=0eb830d0-4493-422e-9d21-b2dea11e96c9 ro vt.handoff=1 nosplash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1819864K/1941744K available (8026K kernel code, 1163K rwdata, 3852K rodata, 1408K init, 1292K bss, 121880K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:16640 nr_irqs:1024 16
[    0.000000]  Offload RCU callbacks from all CPUs
[    0.000000]  Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Maximum core-clock to bus-clock ratio: 0x10
[    0.000000] Resolved frequency ID: 0, frequency: 83200 KHz
[    0.000000] TSC runs at 1331200 KHz
[    0.000000] lapic_timer_frequency = 332800
[    0.000000] tsc: Detected 1331.200 MHz processor
[    0.000059] Calibrating delay loop (skipped), value calculated using timer frequency.. 2662.40 BogoMIPS (lpj=5324800)
[    0.000077] pid_max: default: 32768 minimum: 301
[    0.000096] ACPI: Core revision 20141107
[    0.037619] ACPI: All ACPI Tables successfully acquired
[    0.039347] Security Framework initialized
[    0.039377] AppArmor: AppArmor initialized
[    0.039386] Yama: becoming mindful.
[    0.039869] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.041318] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.041978] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.042005] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.042513] Initializing cgroup subsys memory
[    0.042539] Initializing cgroup subsys devices
[    0.042553] Initializing cgroup subsys freezer
[    0.042565] Initializing cgroup subsys net_cls
[    0.042577] Initializing cgroup subsys blkio
[    0.042588] Initializing cgroup subsys perf_event
[    0.042601] Initializing cgroup subsys net_prio
[    0.042613] Initializing cgroup subsys hugetlb
[    0.042664] CPU: Physical Processor ID: 0
[    0.042674] CPU: Processor Core ID: 0
[    0.042686] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.042686] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.047635] mce: CPU supports 6 MCE banks
[    0.047655] CPU0: Thermal monitoring enabled (TM1)
[    0.047672] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.047672] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.047854] Freeing SMP alternatives memory: 28K (ffffffff81e84000 - ffffffff81e8b000)
[    0.054841] ftrace: allocating 32886 entries in 129 pages
[    0.084703] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.124403] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.124412] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.124420] ..... (found apic 0 pin 0) ...
[    0.164104] ....... works.
[    0.164111] smpboot: CPU0: Intel(R) Atom(TM) CPU  Z3735F @ 1.33GHz (fam: 06, model: 37, stepping: 08)
[    0.164151] TSC deadline timer enabled
[    0.164202] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.164234] ... version:                3
[    0.164241] ... bit width:              40
[    0.164248] ... generic registers:      2
[    0.164255] ... value mask:             000000ffffffffff
[    0.164262] ... max period:             000000ffffffffff
[    0.164269] ... fixed-purpose events:   3
[    0.164275] ... event mask:             0000000700000003
[    0.166495] x86: Booting SMP configuration:
[    0.166509] .... node  #0, CPUs:      #1
[    0.184598] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.184979]  #2 #3
[    0.221186] x86: Booted up 1 node, 4 CPUs
[    0.221200] smpboot: Total of 4 processors activated (10649.60 BogoMIPS)
[    0.222626] devtmpfs: initialized
[    0.233885] evm: security.selinux
[    0.233895] evm: security.SMACK64
[    0.233901] evm: security.SMACK64EXEC
[    0.233907] evm: security.SMACK64TRANSMUTE
[    0.233914] evm: security.SMACK64MMAP
[    0.233920] evm: security.ima
[    0.233926] evm: security.capability
[    0.234087] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.234100] PM: Registering ACPI NVS region [mem 0x76426000-0x764cdfff] (688128 bytes)
[    0.234548] pinctrl core: initialized pinctrl subsystem
[    0.234822] RTC time: 14:31:30, date: 02/06/15
[    0.235179] NET: Registered protocol family 16
[    0.240523] cpuidle: using governor ladder
[    0.244533] cpuidle: using governor menu
[    0.244705] ACPI: bus type PCI registered
[    0.244716] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.244944] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.244960] PCI: not using MMCONFIG
[    0.244967] PCI: Using configuration type 1 for base access
[    0.250471] ACPI: Added _OSI(Module Device)
[    0.250484] ACPI: Added _OSI(Processor Device)
[    0.250492] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.250500] ACPI: Added _OSI(Processor Aggregator Device)
[    0.277213] ACPI: Dynamic OEM Table Load:
[    0.277252] ACPI: SSDT 0xFFFF880070333000 000501 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.279178] ACPI: Dynamic OEM Table Load:
[    0.279201] ACPI: SSDT 0xFFFF880070333800 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.281768] ACPI: Dynamic OEM Table Load:
[    0.281789] ACPI: SSDT 0xFFFF880070365A00 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.283649] ACPI: Dynamic OEM Table Load:
[    0.283669] ACPI: SSDT 0xFFFF880070359840 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.287705] ACPI: Interpreter enabled
[    0.287727] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20141107/hwxface-580)
[    0.287750] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.287771] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20141107/hwxface-580)
[    0.287812] ACPI: (supports S0 S4 S5)
[    0.287821] ACPI: Using IOAPIC for interrupt routing
[    0.287890] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.299318] [Firmware Info]: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] not reserved in ACPI motherboard resources
[    0.299334] PCI: not using MMCONFIG
[    0.299382] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.305450] ACPI: Power Resource [USBC] (on)
[    0.306295] ACPI: Power Resource [WWPR] (off)
[    0.312393] ACPI: Power Resource [PLPE] (on)
[    0.323923] ACPI: Power Resource [CLK0] (on)
[    0.324063] ACPI: Power Resource [CLK1] (on)
[    0.324845] ACPI: Power Resource [P28X] (off)
[    0.324982] ACPI: Power Resource [P18X] (off)
[    0.326183] ACPI: Power Resource [P28P] (off)
[    0.326319] ACPI: Power Resource [P18P] (off)
[    0.336637] ACPI: Power Resource [P28T] (off)
[    0.336779] ACPI: Power Resource [P18T] (off)
[    0.336914] ACPI: Power Resource [P1XT] (off)
[    0.339379] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.339402] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.339535] \_SB_.PCI0:_OSC invalid UUID
[    0.339541] _OSC request data:1 1e 0
[    0.339553] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.340315] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.340853] PCI host bridge to bus 0000:00
[    0.340868] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.340880] pci_bus 0000:00: root bus resource [io  0x0000-0x006f]
[    0.340891] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7]
[    0.340902] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.340913] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.340923] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.340934] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff]
[    0.340946] pci_bus 0000:00: root bus resource [mem 0x90800000-0x90bfffff]
[    0.340956] pci_bus 0000:00: root bus resource [mem 0x77000001-0x7f000000]
[    0.340967] pci_bus 0000:00: root bus resource [mem 0x80000000-0x906ffffe]
[    0.340978] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed40fff]
[    0.341002] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.341258] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.341281] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.341299] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.341316] pci 0000:00:02.0: reg 0x20: [io  0x1000-0x1007]
[    0.341620] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.341656] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.341675] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.341808] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.342053] pci 0000:00:1d.0: [8086:0f34] type 00 class 0x0c0320
[    0.342089] pci 0000:00:1d.0: reg 0x10: [mem 0x9060d000-0x9060d3ff]
[    0.342236] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.342472] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.343664] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.343878] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344098] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344303] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344508] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344712] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344917] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.345121] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.345615] platform 80860F28:00: failed to claim resource 0
[    0.345630] acpi 80860F28:00: platform device creation failed: -16
[    0.355068] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.355083] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.355096] vgaarb: loaded
[    0.355103] vgaarb: bridge control possible 0000:00:02.0
[    0.355843] SCSI subsystem initialized
[    0.355988] libata version 3.00 loaded.
[    0.356074] ACPI: bus type USB registered
[    0.356150] usbcore: registered new interface driver usbfs
[    0.356188] usbcore: registered new interface driver hub
[    0.356255] usbcore: registered new device driver usb
[    0.356804] PCI: Using ACPI for IRQ routing
[    0.356816] PCI: pci_cache_line_size set to 64 bytes
[    0.356845] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.356857] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.356862] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.356867] e820: reserve RAM buffer [mem 0x763cb000-0x77ffffff]
[    0.356872] e820: reserve RAM buffer [mem 0x76d00000-0x77ffffff]
[    0.357198] NetLabel: Initializing
[    0.357208] NetLabel:  domain hash size = 128
[    0.357214] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.357250] NetLabel:  unlabeled traffic allowed by default
[    0.357536] Switched to clocksource refined-jiffies
[    0.374840] AppArmor: AppArmor Filesystem Enabled
[    0.375039] pnp: PnP ACPI init
[    0.375192] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.375521] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.375536] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.375548] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.375560] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.375572] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.375586] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.375854] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.378986] pnp: PnP ACPI: found 3 devices
[    0.385428] pci_bus 0000:00: resource 4 [io  0x0000-0x006f]
[    0.385437] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7]
[    0.385443] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    0.385450] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.385456] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.385462] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff]
[    0.385482] pci_bus 0000:00: resource 10 [mem 0x90800000-0x90bfffff]
[    0.385488] pci_bus 0000:00: resource 11 [mem 0x77000001-0x7f000000]
[    0.385495] pci_bus 0000:00: resource 12 [mem 0x80000000-0x906ffffe]
[    0.385501] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed40fff]
[    0.385574] NET: Registered protocol family 2
[    0.386014] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.386141] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.386266] TCP: Hash tables configured (established 16384 bind 16384)
[    0.386326] TCP: reno registered
[    0.386349] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.386387] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.386520] NET: Registered protocol family 1
[    0.386564] pci 0000:00:02.0: Video device with shadowed ROM
[    0.386934] PCI: CLS 0 bytes, default 64
[    0.387102] Trying to unpack rootfs image as initramfs...
[    1.154082] Freeing initrd memory: 18068K (ffff880035ca6000 - ffff880036e4b000)
[    1.154765] microcode: CPU0 sig=0x30678, pf=0x2, revision=0x82b
[    1.154789] microcode: CPU1 sig=0x30678, pf=0x2, revision=0x82b
[    1.154816] microcode: CPU2 sig=0x30678, pf=0x2, revision=0x82b
[    1.154842] microcode: CPU3 sig=0x30678, pf=0x2, revision=0x82b
[    1.154998] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.155131] Scanning for low memory corruption every 60 seconds
[    1.156144] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    1.156188] Initialise system trusted keyring
[    1.156251] audit: initializing netlink subsys (disabled)
[    1.156299] audit: type=2000 audit(1423233091.120:1): initialized
[    1.157039] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.162231] zpool: loaded
[    1.162243] zbud: loaded
[    1.162664] VFS: Disk quotas dquot_6.5.2
[    1.162791] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.164391] fuse init (API version 7.23)
[    1.164835] Key type big_key registered
[    1.165682] Key type asymmetric registered
[    1.165696] Asymmetric key parser 'x509' registered
[    1.165822] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.165929] io scheduler noop registered
[    1.165945] io scheduler deadline registered (default)
[    1.166071] io scheduler cfq registered
[    1.166278] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.166334] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.166463] efifb: probing for efifb
[    1.166530] efifb: framebuffer at 0x80000000, mapped to 0xffffc90000480000, using 8128k, total 8128k
[    1.166543] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    1.166550] efifb: scrolling: redraw
[    1.166559] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.185527] Console: switching to colour frame buffer device 240x67
[    1.204361] fb0: EFI VGA frame buffer device
[    1.204452] intel_idle: MWAIT substates: 0x33000020
[    1.204457] intel_idle: v0.4 model 0x37
[    1.204461] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.205142] ACPI Exception: AE_ERROR, Returned by Handler for [GeneralPurposeIo] (20141107/evregion-297)
[    1.205306] ACPI Error: Method parse/execution failed [\_SB_.ADP1._PSR] (Node ffff8800728bc9b0), AE_ERROR (20141107/psparse-536)
[    1.205513] ACPI Exception: AE_ERROR, Error reading AC Adapter state (20141107/ac-131)
[    1.210453] [Firmware Bug]: No valid trip found
[    1.210645] GHES: HEST is not enabled!
[    1.210983] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.231227] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.235940] hpet: number irqs doesn't agree with number of timers
[    1.236119] Linux agpgart interface v0.103
[    1.240417] brd: module loaded
[    1.242662] loop: module loaded
[    1.243392] libphy: Fixed MDIO Bus: probed
[    1.243467] tun: Universal TUN/TAP device driver, 1.6
[    1.243545] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.243762] PPP generic driver version 2.4.2
[    1.244038] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.244152] ehci-pci: EHCI PCI platform driver
[    1.244491] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.244589] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.244722] ehci-pci 0000:00:1d.0: debug port 2
[    1.248725] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.248765] ehci-pci 0000:00:1d.0: irq 23, io mem 0x9060d000
[    1.257081] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.257295] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.257404] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.257514] usb usb1: Product: EHCI Host Controller
[    1.257591] usb usb1: Manufacturer: Linux 3.19.0-031900rc6-generic ehci_hcd
[    1.257696] usb usb1: SerialNumber: 0000:00:1d.0
[    1.258112] hub 1-0:1.0: USB hub found
[    1.258200] hub 1-0:1.0: 8 ports detected
[    1.258950] ehci-platform: EHCI generic platform driver
[    1.259077] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.259185] ohci-pci: OHCI PCI platform driver
[    1.259288] ohci-platform: OHCI generic platform driver
[    1.259399] uhci_hcd: USB Universal Host Controller Interface driver
[    1.259634] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.982779] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.111786] usb 1-1: New USB device found, idVendor=8087, idProduct=07e6
[    2.111894] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.112494] hub 1-1:1.0: USB hub found
[    2.112658] hub 1-1:1.0: 4 ports detected
[    2.294084] i8042: No controller found
[    2.298425] Switched to clocksource tsc
[    2.298815] mousedev: PS/2 mouse device common for all mice
[    2.299091] ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20141107/evxface-643)
[    2.299096] rtc_cmos 00:00: RTC can wake from S4
[    2.299184] rtc (null): invalid alarm value: 2015-2-6 14:65:63
[    2.299368] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.299456] rtc_cmos 00:00: alarms up to one day, 242 bytes nvram
[    2.299756] device-mapper: uevent: version 1.0.3
[    2.300189] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
[    2.300219] Intel P-state driver initializing.
[    2.300650] ledtrig-cpu: registered to indicate activity on CPUs
[    2.300657] EFI Variables Facility v0.08 2004-May-17
[    2.306456] PCCT header not found.
[    2.306457] ACPI PCC probe failed.
[    2.306680] TCP: cubic registered
[    2.306936] NET: Registered protocol family 10
[    2.307739] NET: Registered protocol family 17
[    2.307775] Key type dns_resolver registered
[    2.309601] Loading compiled-in X.509 certificates
[    2.311659] Loaded X.509 cert 'Magrathea: Glacier signing key: 43dbbfb67f6a8fa4dcf7857f524e05f411517371'
[    2.311698] registered taskstats version 1
[    2.319257] Key type trusted registered
[    2.334194] Key type encrypted registered
[    2.334215] AppArmor: AppArmor sha1 policy hashing enabled
[    2.334221] ima: No TPM chip found, activating TPM-bypass!
[    2.334268] evm: HMAC attrs: 0x1
[    2.335331]   Magic number: 3:387:535
[    2.335358] bdi 1:13: hash matches
[    2.335373] tty ttyS15: hash matches
[    2.336984] rtc_cmos 00:00: setting system clock to 2015-02-06 14:31:32 UTC (1423233092)
[    2.337521] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.337522] EDD information not available.
[    2.337815] PM: Hibernation image not present or could not be loaded.
[    2.404961] Freeing unused kernel memory: 1408K (ffffffff81d24000 - ffffffff81e84000)
[    2.409180] Write protecting the kernel read-only data: 12288k
[    2.415401] Freeing unused kernel memory: 152K (ffff8800027da000 - ffff880002800000)
[    2.420958] Freeing unused kernel memory: 244K (ffff880002bc3000 - ffff880002c00000)
[    2.478418] systemd-udevd[121]: starting version 204
[    2.508035] sdhci: Secure Digital Host Controller Interface driver
[    2.511743] sdhci: Copyright(c) Pierre Ossman
[    2.520441] sdhci-acpi 80860F14:00: No vmmc regulator found
[    2.522331] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    2.528190] sdhci-acpi 80860F14:00: No vqmmc regulator found
[    2.532186] mmc0: SDHCI controller on ACPI [80860F14:00] using ADMA
[    2.533368] sdhci-acpi INT33BB:00: No vmmc regulator found
[    2.533370] sdhci-acpi INT33BB:00: No vqmmc regulator found
[    2.536725] mmc1: SDHCI controller on ACPI [INT33BB:00] using ADMA
[    2.538067] sdhci-acpi 80860F14:01: No vmmc regulator found
[    2.538070] sdhci-acpi 80860F14:01: No vqmmc regulator found
[    2.541826] mmc2: SDHCI controller on ACPI [80860F14:01] using ADMA
[    2.628446] usb 1-1.1: New USB device found, idVendor=1a40, idProduct=0101
[    2.632919] usb 1-1.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.637417] usb 1-1.1: Product: USB 2.0 Hub
[    2.643242] hub 1-1.1:1.0: USB hub found
[    2.648028] hub 1-1.1:1.0: 4 ports detected
[    2.722530] mmc0: BKOPS_EN bit is not set
[    2.738786] mmc0: new HS200 MMC card at address 0001
[    2.746765] Driver 'mmcblk' needs updating - please use bus_type methods
[    2.752056] mmcblk0: mmc0:0001 BWBC3R 29.1 GiB
[    2.757297] mmcblk0boot0: mmc0:0001 BWBC3R partition 1 4.00 MiB
[    2.762533] mmcblk0boot1: mmc0:0001 BWBC3R partition 2 4.00 MiB
[    2.767578] mmcblk0rpmb: mmc0:0001 BWBC3R partition 3 4.00 MiB
[    2.782086]  mmcblk0: p1 p2 p3
[    2.827597] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    2.834321] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    2.841072] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    2.849552] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    2.911123] EXT4-fs (mmcblk0p3): INFO: recovery required on readonly filesystem
[    2.914321] EXT4-fs (mmcblk0p3): write access will be enabled during recovery
[    2.919521] mmc1: new high speed SDIO card at address 0001
[    2.946905] usb 1-1.1.1: new full-speed USB device number 4 using ehci-pci
[    2.980875] EXT4-fs (mmcblk0p3): recovery complete
[    2.986500] EXT4-fs (mmcblk0p3): mounted filesystem with ordered data mode. Opts: (null)
[    3.067157] usb 1-1.1.1: New USB device found, idVendor=045e, idProduct=0745
[    3.070889] usb 1-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.074208] usb 1-1.1.1: Product: Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0
[    3.077563] usb 1-1.1.1: Manufacturer: Microsoft
[    3.154672] usb 1-1.1.4: new high-speed USB device number 5 using ehci-pci
[    3.267541] usb 1-1.1.4: New USB device found, idVendor=0bda, idProduct=8152
[    3.270962] usb 1-1.1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.274284] usb 1-1.1.4: Product: USB 10/100 LAN
[    3.277606] usb 1-1.1.4: Manufacturer: Realtek
[    3.280945] usb 1-1.1.4: SerialNumber: 00012E58F054
[    3.288358] random: init urandom read with 37 bits of entropy available
[    3.363966] init: plymouth-upstart-bridge main process (181) terminated with status 1
[    3.367978] init: plymouth-upstart-bridge main process ended, respawning
[    3.388629] init: plymouth-upstart-bridge main process (191) terminated with status 1
[    3.392167] init: plymouth-upstart-bridge main process ended, respawning
[    3.407642] init: plymouth-upstart-bridge main process (194) terminated with status 1
[    3.412323] init: plymouth-upstart-bridge main process ended, respawning
[    3.436496] init: ureadahead main process (184) terminated with status 5
[    3.626082] Adding 1112060k swap on /dev/mmcblk0p2.  Priority:-1 extents:1 across:1112060k SSFS
[    3.806512] EXT4-fs (mmcblk0p3): re-mounted. Opts: errors=remount-ro
[    3.908968] systemd-udevd[335]: starting version 204
[    4.010734] lp: driver loaded but no devices found
[    4.032463] ppdev: user-space parallel port driver
[    4.190839] [drm] Initialized drm 1.1.0 20060810
[    4.232335] mei_txe 0000:00:1a.0: can't derive routing for PCI INT A
[    4.232343] mei_txe 0000:00:1a.0: PCI INT A: no GSI
[    4.240769] 80860F0A:00: ttyS4 at MMIO 0x90736000 (irq = 39, base_baud = 2764800) is a 16550A
[    4.292321] [Firmware Bug]: No valid trip found
[    4.323050] byt_gpio INT33FC:02: pin 16 cannot be used as GPIO.
[    4.352442] hidraw: raw HID events driver (C) Jiri Kosina
[    4.356513] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8 channels
[    4.357930] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8 channels
[    4.388195] [drm] Memory usable by graphics device = 2048M
[    4.388207] checking generic (80000000 7f0000) vs hw (80000000 10000000)
[    4.388211] fb: switching to inteldrmfb from EFI VGA
[    4.388277] Console: switching to colour dummy device 80x25
[    4.388634] [drm] Replacing VGA console driver
[    4.392561] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.392568] [drm] Driver supports precise vblank timestamp query.
[    4.429187] Bluetooth: Core ver 2.20
[    4.429239] NET: Registered protocol family 31
[    4.429244] Bluetooth: HCI device and connection manager initialized
[    4.429253] Bluetooth: HCI socket layer initialized
[    4.429260] Bluetooth: L2CAP socket layer initialized
[    4.429275] Bluetooth: SCO socket layer initialized
[    4.446974] Bluetooth: RFCOMM TTY layer initialized
[    4.446990] Bluetooth: RFCOMM socket layer initialized
[    4.447007] Bluetooth: RFCOMM ver 1.11
[    4.463309] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.463317] Bluetooth: BNEP filters: protocol multicast
[    4.463327] Bluetooth: BNEP socket layer initialized
[    4.623601] usbcore: registered new interface driver r8152
[    4.637831] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.660018] usbcore: registered new interface driver usbhid
[    4.660025] usbhid: USB HID core driver
[    4.660238] cfg80211: Calling CRDA to update world regulatory domain
[    4.671556] usbcore: registered new interface driver cdc_ether
[    4.697938] usb 1-1.1.4: reset high-speed USB device number 5 using ehci-pci
[    4.737019] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    4.739368] acpi device:09: registered as cooling_device4
[    4.739754] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input0
[    4.741925] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    4.774226] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    4.776304] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    4.776981] SSE version of gcm_enc/dec engaged.
[    4.778748] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    4.782349] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    4.847688] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to bit banging on pin 4
[    4.854533] fbcon: inteldrmfb (fb0) is primary device
[    4.859424] usbcore: registered new interface driver brcmfmac
[    4.893037] r8152 1-1.1.4:1.0 eth0: v1.07.0 (2014/10/09)
[    4.918410] intel_soc_dts_thermal: request_threaded_irq ret -22
[    4.930189] intel_rapl: Found RAPL domain package
[    4.930192] intel_rapl: Found RAPL domain core
[    4.945466] input: gpio-keys as /devices/platform/gpio-keys.0.auto/input/input1
[    4.961296] input: gpio-keys as /devices/platform/gpio-keys.1.auto/input/input2
[    5.002853] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/0003:045E:0745.0001/input/input3
[    5.005127] random: nonblocking pool is initialized
[    5.026974] cfg80211: World regulatory domain updated:
[    5.026984] cfg80211:  DFS Master region: unset
[    5.026985] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.026990] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.026993] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.026995] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.026998] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.027000] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.058554] hid-generic 0003:045E:0745.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input0
[    5.059325] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.1/0003:045E:0745.0002/input/input4
[    5.114655] hid-generic 0003:045E:0745.0002: input,hidraw1: USB HID v1.11 Mouse [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input1
[    5.125415] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.2/0003:045E:0745.0003/input/input5
[    5.182608] hid-generic 0003:045E:0745.0003: input,hiddev0,hidraw2: USB HID v1.11 Device [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input2
[    5.193679] Console: switching to colour frame buffer device 240x67
[    5.200252] brcmf_c_preinit_dcmds: Firmware version = wl0: Jan 29 2014 01:40:06 version 5.97.39.4 FWID 01-c7b9d775
[    5.209970] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.209973] i915 0000:00:02.0: registered panic notifier
[    5.593713] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.880383] init: failsafe main process (617) killed by TERM signal
[    5.972645] init: network-manager main process (819) terminated with status 127
[    5.972681] init: network-manager main process ended, respawning
[    6.346054] init: Failed to spawn whoopsie main process: unable to execute: No such file or directory
[    6.614976] init: lightdm main process (1019) terminated with status 127
[    6.626637] init: plymouth-ready (startup) main process (180) terminated with status 1
[    7.794914] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<starting hostapd...>
[  333.063664] brcmf_sdio_bus_rxctl: resumed on timeout
[  333.077320] brcmf_add_if: ERROR: netdev:wlan0 already exists
[  333.077437] brcmf_add_if: ignore IF event
[  333.163168] 8021q: 802.1Q VLAN Support v1.8
[  333.241893] brcmf_cfg80211_start_ap: setting AP mode failed -52
--------------040207080401090706030200
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-031900rc6-generic (kernel@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201501261152 SMP Mon Jan 26 16:53:27 UTC 2015
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-031900rc6-generic root=UUID=0eb830d0-4493-422e-9d21-b2dea11e96c9 ro vt.handoff=1 nosplash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x00000000763cafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000763cb000-0x00000000763fafff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000763fb000-0x0000000076425fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076426000-0x00000000764cdfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000764ce000-0x00000000765e1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000765e2000-0x000000007662afff] type 20
[    0.000000] BIOS-e820: [mem 0x000000007662b000-0x0000000076cfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0x76425000  ACPI 2.0=0x76425014  SMBIOS=0x765e1390
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x000000000008f000) (0MB)
[    0.000000] efi: mem01: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000090000-0x000000000009e000) (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x00000000014d5000) (19MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000014d5000-0x0000000002000000) (11MB)
[    0.000000] efi: mem06: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000002000000-0x00000000033d5000) (19MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000033d5000-0x0000000020000000) (460MB)
[    0.000000] efi: mem08: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000020200000-0x0000000035ca6000) (346MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000035ca6000-0x0000000036e4b000) (17MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000036e4b000-0x00000000560cc000) (498MB)
[    0.000000] efi: mem12: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000560cc000-0x0000000072d00000) (460MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072d00000-0x0000000072d20000) (0MB)
[    0.000000] efi: mem14: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072d20000-0x0000000072f5f000) (2MB)
[    0.000000] efi: mem15: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072f5f000-0x0000000072f74000) (0MB)
[    0.000000] efi: mem16: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072f74000-0x0000000075dcb000) (46MB)
[    0.000000] efi: mem17: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000075dcb000-0x0000000076259000) (4MB)
[    0.000000] efi: mem18: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076259000-0x0000000076263000) (0MB)
[    0.000000] efi: mem19: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076263000-0x00000000763cb000) (1MB)
[    0.000000] efi: mem20: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000763cb000-0x00000000763fb000) (0MB)
[    0.000000] efi: mem21: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000763fb000-0x0000000076426000) (0MB)
[    0.000000] efi: mem22: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076426000-0x00000000764ce000) (0MB)
[    0.000000] efi: mem23: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000764ce000-0x00000000765e2000) (1MB)
[    0.000000] efi: mem24: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000765e2000-0x000000007662b000) (0MB)
[    0.000000] efi: mem25: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007662b000-0x0000000076cf6000) (6MB)
[    0.000000] efi: mem26: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076cf6000-0x0000000076cf7000) (0MB)
[    0.000000] efi: mem27: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076cf7000-0x0000000076d00000) (0MB)
[    0.000000] efi: mem28: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] efi: mem29: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed01000-0x00000000fed02000) (0MB)
[    0.000000] efi: mem30: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed08000-0x00000000fed09000) (0MB)
[    0.000000] efi: mem31: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000ffb00000-0x0000000100000000) (5MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: ZOTAC ZBOX-PI320 Series/ZBOX-PI320, BIOS B253P013 10/29/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x76d00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 060000000 mask FF0000000 write-back
[    0.000000]   3 base 070000000 mask FF8000000 write-back
[    0.000000]   4 base 070000000 mask FF8000000 write-back
[    0.000000]   5 base 077000000 mask FFF000000 uncachable
[    0.000000]   6 base 076E00000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1GB, range: 512MB, type WB
[    0.000000] reg 2, base: 1536MB, range: 256MB, type WB
[    0.000000] reg 3, base: 1792MB, range: 128MB, type WB
[    0.000000] reg 4, base: 1792MB, range: 128MB, type WB
[    0.000000] reg 5, base: 1904MB, range: 16MB, type UC
[    0.000000] reg 6, base: 1902MB, range: 2MB, type UC
[    0.000000] total RAM covered: 1902M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 4      lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 1902MB, range: 2MB, type UC
[    0.000000] reg 2, base: 1904MB, range: 16MB, type UC
[    0.000000] reg 3, base: 1920MB, range: 128MB, type UC
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fd0000, 0x02fd0fff] PGTABLE
[    0.000000] BRK [0x02fd1000, 0x02fd1fff] PGTABLE
[    0.000000] BRK [0x02fd2000, 0x02fd2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x76000000-0x761fffff]
[    0.000000]  [mem 0x76000000-0x761fffff] page 2M
[    0.000000] BRK [0x02fd3000, 0x02fd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x60000000-0x75ffffff]
[    0.000000]  [mem 0x60000000-0x75ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40000000-0x5fffffff]
[    0.000000]  [mem 0x40000000-0x5fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x76200000-0x763cafff]
[    0.000000]  [mem 0x76200000-0x763cafff] page 4k
[    0.000000] BRK [0x02fd4000, 0x02fd4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7662b000-0x76cfffff]
[    0.000000]  [mem 0x7662b000-0x767fffff] page 4k
[    0.000000]  [mem 0x76800000-0x76bfffff] page 2M
[    0.000000]  [mem 0x76c00000-0x76cfffff] page 4k
[    0.000000] BRK [0x02fd5000, 0x02fd5fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35ca6000-0x36e4afff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x0000000076425014 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x0000000076424100 000084 (v01 ALASKA A M I    00000003 MSFT 0100000D)
[    0.000000] ACPI: FACP 0x0000000076422000 00010C (v05 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: DSDT 0x000000007640E000 00FA77 (v02 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: MSDM 0x0000000076423000 000055 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: UEFI 0x0000000076492000 000042 (v01 ALASKA A M I    00000000      00000000)
[    0.000000] ACPI: HPET 0x0000000076421000 000038 (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: LPIT 0x0000000076420000 000104 (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: APIC 0x000000007641F000 00006C (v03 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: MCFG 0x000000007641E000 00003C (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: FPDT 0x0000000076407000 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x0000000076406000 000763 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076405000 000290 (v01 PmRef  Cpu0Tst  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076404000 00017A (v01 PmRef  ApTst    00003000 INTL 20061109)
[    0.000000] ACPI: CSRT 0x000000007640D000 00014C (v00 ALASKA A M I    00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000076cfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x7625d000-0x76261fff]
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff880070a00000-ffff8800727fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0x76cfffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x763cafff]
[    0.000000]   node   0: [mem 0x7662b000-0x76cfffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x76cfffff]
[    0.000000] On node 0 totalpages: 485436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7540 pages used for memmap
[    0.000000]   DMA32 zone: 481440 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics stolen memory at 0x77000000-0x7effffff
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x763cb000-0x763fafff]
[    0.000000] PM: Registered nosave memory: [mem 0x763fb000-0x76425fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76426000-0x764cdfff]
[    0.000000] PM: Registered nosave memory: [mem 0x764ce000-0x765e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x765e2000-0x7662afff]
[    0.000000] e820: [mem 0x7f000000-0xe00f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880076000000 s86976 r8192 d31808 u524288
[    0.000000] pcpu-alloc: s86976 r8192 d31808 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 477810
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-031900rc6-generic root=UUID=0eb830d0-4493-422e-9d21-b2dea11e96c9 ro vt.handoff=1 nosplash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1819864K/1941744K available (8026K kernel code, 1163K rwdata, 3852K rodata, 1408K init, 1292K bss, 121880K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:16640 nr_irqs:1024 16
[    0.000000]  Offload RCU callbacks from all CPUs
[    0.000000]  Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Maximum core-clock to bus-clock ratio: 0x10
[    0.000000] Resolved frequency ID: 0, frequency: 83200 KHz
[    0.000000] TSC runs at 1331200 KHz
[    0.000000] lapic_timer_frequency = 332800
[    0.000000] tsc: Detected 1331.200 MHz processor
[    0.000059] Calibrating delay loop (skipped), value calculated using timer frequency.. 2662.40 BogoMIPS (lpj=5324800)
[    0.000077] pid_max: default: 32768 minimum: 301
[    0.000096] ACPI: Core revision 20141107
[    0.037619] ACPI: All ACPI Tables successfully acquired
[    0.039347] Security Framework initialized
[    0.039377] AppArmor: AppArmor initialized
[    0.039386] Yama: becoming mindful.
[    0.039869] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.041318] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.041978] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.042005] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.042513] Initializing cgroup subsys memory
[    0.042539] Initializing cgroup subsys devices
[    0.042553] Initializing cgroup subsys freezer
[    0.042565] Initializing cgroup subsys net_cls
[    0.042577] Initializing cgroup subsys blkio
[    0.042588] Initializing cgroup subsys perf_event
[    0.042601] Initializing cgroup subsys net_prio
[    0.042613] Initializing cgroup subsys hugetlb
[    0.042664] CPU: Physical Processor ID: 0
[    0.042674] CPU: Processor Core ID: 0
[    0.042686] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.042686] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.047635] mce: CPU supports 6 MCE banks
[    0.047655] CPU0: Thermal monitoring enabled (TM1)
[    0.047672] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.047672] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.047854] Freeing SMP alternatives memory: 28K (ffffffff81e84000 - ffffffff81e8b000)
[    0.054841] ftrace: allocating 32886 entries in 129 pages
[    0.084703] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.124403] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.124412] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.124420] ..... (found apic 0 pin 0) ...
[    0.164104] ....... works.
[    0.164111] smpboot: CPU0: Intel(R) Atom(TM) CPU  Z3735F @ 1.33GHz (fam: 06, model: 37, stepping: 08)
[    0.164151] TSC deadline timer enabled
[    0.164202] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.164234] ... version:                3
[    0.164241] ... bit width:              40
[    0.164248] ... generic registers:      2
[    0.164255] ... value mask:             000000ffffffffff
[    0.164262] ... max period:             000000ffffffffff
[    0.164269] ... fixed-purpose events:   3
[    0.164275] ... event mask:             0000000700000003
[    0.166495] x86: Booting SMP configuration:
[    0.166509] .... node  #0, CPUs:      #1
[    0.184598] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.184979]  #2 #3
[    0.221186] x86: Booted up 1 node, 4 CPUs
[    0.221200] smpboot: Total of 4 processors activated (10649.60 BogoMIPS)
[    0.222626] devtmpfs: initialized
[    0.233885] evm: security.selinux
[    0.233895] evm: security.SMACK64
[    0.233901] evm: security.SMACK64EXEC
[    0.233907] evm: security.SMACK64TRANSMUTE
[    0.233914] evm: security.SMACK64MMAP
[    0.233920] evm: security.ima
[    0.233926] evm: security.capability
[    0.234087] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.234100] PM: Registering ACPI NVS region [mem 0x76426000-0x764cdfff] (688128 bytes)
[    0.234548] pinctrl core: initialized pinctrl subsystem
[    0.234822] RTC time: 14:31:30, date: 02/06/15
[    0.235179] NET: Registered protocol family 16
[    0.240523] cpuidle: using governor ladder
[    0.244533] cpuidle: using governor menu
[    0.244705] ACPI: bus type PCI registered
[    0.244716] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.244944] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.244960] PCI: not using MMCONFIG
[    0.244967] PCI: Using configuration type 1 for base access
[    0.250471] ACPI: Added _OSI(Module Device)
[    0.250484] ACPI: Added _OSI(Processor Device)
[    0.250492] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.250500] ACPI: Added _OSI(Processor Aggregator Device)
[    0.277213] ACPI: Dynamic OEM Table Load:
[    0.277252] ACPI: SSDT 0xFFFF880070333000 000501 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.279178] ACPI: Dynamic OEM Table Load:
[    0.279201] ACPI: SSDT 0xFFFF880070333800 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.281768] ACPI: Dynamic OEM Table Load:
[    0.281789] ACPI: SSDT 0xFFFF880070365A00 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.283649] ACPI: Dynamic OEM Table Load:
[    0.283669] ACPI: SSDT 0xFFFF880070359840 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.287705] ACPI: Interpreter enabled
[    0.287727] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20141107/hwxface-580)
[    0.287750] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.287771] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20141107/hwxface-580)
[    0.287812] ACPI: (supports S0 S4 S5)
[    0.287821] ACPI: Using IOAPIC for interrupt routing
[    0.287890] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.299318] [Firmware Info]: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] not reserved in ACPI motherboard resources
[    0.299334] PCI: not using MMCONFIG
[    0.299382] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.305450] ACPI: Power Resource [USBC] (on)
[    0.306295] ACPI: Power Resource [WWPR] (off)
[    0.312393] ACPI: Power Resource [PLPE] (on)
[    0.323923] ACPI: Power Resource [CLK0] (on)
[    0.324063] ACPI: Power Resource [CLK1] (on)
[    0.324845] ACPI: Power Resource [P28X] (off)
[    0.324982] ACPI: Power Resource [P18X] (off)
[    0.326183] ACPI: Power Resource [P28P] (off)
[    0.326319] ACPI: Power Resource [P18P] (off)
[    0.336637] ACPI: Power Resource [P28T] (off)
[    0.336779] ACPI: Power Resource [P18T] (off)
[    0.336914] ACPI: Power Resource [P1XT] (off)
[    0.339379] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.339402] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.339535] \_SB_.PCI0:_OSC invalid UUID
[    0.339541] _OSC request data:1 1e 0
[    0.339553] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.340315] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.340853] PCI host bridge to bus 0000:00
[    0.340868] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.340880] pci_bus 0000:00: root bus resource [io  0x0000-0x006f]
[    0.340891] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7]
[    0.340902] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.340913] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.340923] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.340934] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff]
[    0.340946] pci_bus 0000:00: root bus resource [mem 0x90800000-0x90bfffff]
[    0.340956] pci_bus 0000:00: root bus resource [mem 0x77000001-0x7f000000]
[    0.340967] pci_bus 0000:00: root bus resource [mem 0x80000000-0x906ffffe]
[    0.340978] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed40fff]
[    0.341002] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.341258] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.341281] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.341299] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.341316] pci 0000:00:02.0: reg 0x20: [io  0x1000-0x1007]
[    0.341620] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.341656] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.341675] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.341808] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.342053] pci 0000:00:1d.0: [8086:0f34] type 00 class 0x0c0320
[    0.342089] pci 0000:00:1d.0: reg 0x10: [mem 0x9060d000-0x9060d3ff]
[    0.342236] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.342472] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.343664] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.343878] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344098] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344303] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344508] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344712] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.344917] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.345121] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.345615] platform 80860F28:00: failed to claim resource 0
[    0.345630] acpi 80860F28:00: platform device creation failed: -16
[    0.355068] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.355083] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.355096] vgaarb: loaded
[    0.355103] vgaarb: bridge control possible 0000:00:02.0
[    0.355843] SCSI subsystem initialized
[    0.355988] libata version 3.00 loaded.
[    0.356074] ACPI: bus type USB registered
[    0.356150] usbcore: registered new interface driver usbfs
[    0.356188] usbcore: registered new interface driver hub
[    0.356255] usbcore: registered new device driver usb
[    0.356804] PCI: Using ACPI for IRQ routing
[    0.356816] PCI: pci_cache_line_size set to 64 bytes
[    0.356845] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.356857] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.356862] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.356867] e820: reserve RAM buffer [mem 0x763cb000-0x77ffffff]
[    0.356872] e820: reserve RAM buffer [mem 0x76d00000-0x77ffffff]
[    0.357198] NetLabel: Initializing
[    0.357208] NetLabel:  domain hash size = 128
[    0.357214] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.357250] NetLabel:  unlabeled traffic allowed by default
[    0.357536] Switched to clocksource refined-jiffies
[    0.374840] AppArmor: AppArmor Filesystem Enabled
[    0.375039] pnp: PnP ACPI init
[    0.375192] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.375521] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.375536] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.375548] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.375560] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.375572] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.375586] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.375854] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.378986] pnp: PnP ACPI: found 3 devices
[    0.385428] pci_bus 0000:00: resource 4 [io  0x0000-0x006f]
[    0.385437] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7]
[    0.385443] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    0.385450] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.385456] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.385462] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff]
[    0.385482] pci_bus 0000:00: resource 10 [mem 0x90800000-0x90bfffff]
[    0.385488] pci_bus 0000:00: resource 11 [mem 0x77000001-0x7f000000]
[    0.385495] pci_bus 0000:00: resource 12 [mem 0x80000000-0x906ffffe]
[    0.385501] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed40fff]
[    0.385574] NET: Registered protocol family 2
[    0.386014] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.386141] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.386266] TCP: Hash tables configured (established 16384 bind 16384)
[    0.386326] TCP: reno registered
[    0.386349] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.386387] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.386520] NET: Registered protocol family 1
[    0.386564] pci 0000:00:02.0: Video device with shadowed ROM
[    0.386934] PCI: CLS 0 bytes, default 64
[    0.387102] Trying to unpack rootfs image as initramfs...
[    1.154082] Freeing initrd memory: 18068K (ffff880035ca6000 - ffff880036e4b000)
[    1.154765] microcode: CPU0 sig=0x30678, pf=0x2, revision=0x82b
[    1.154789] microcode: CPU1 sig=0x30678, pf=0x2, revision=0x82b
[    1.154816] microcode: CPU2 sig=0x30678, pf=0x2, revision=0x82b
[    1.154842] microcode: CPU3 sig=0x30678, pf=0x2, revision=0x82b
[    1.154998] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.155131] Scanning for low memory corruption every 60 seconds
[    1.156144] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    1.156188] Initialise system trusted keyring
[    1.156251] audit: initializing netlink subsys (disabled)
[    1.156299] audit: type=2000 audit(1423233091.120:1): initialized
[    1.157039] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.162231] zpool: loaded
[    1.162243] zbud: loaded
[    1.162664] VFS: Disk quotas dquot_6.5.2
[    1.162791] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.164391] fuse init (API version 7.23)
[    1.164835] Key type big_key registered
[    1.165682] Key type asymmetric registered
[    1.165696] Asymmetric key parser 'x509' registered
[    1.165822] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.165929] io scheduler noop registered
[    1.165945] io scheduler deadline registered (default)
[    1.166071] io scheduler cfq registered
[    1.166278] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.166334] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.166463] efifb: probing for efifb
[    1.166530] efifb: framebuffer at 0x80000000, mapped to 0xffffc90000480000, using 8128k, total 8128k
[    1.166543] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    1.166550] efifb: scrolling: redraw
[    1.166559] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.185527] Console: switching to colour frame buffer device 240x67
[    1.204361] fb0: EFI VGA frame buffer device
[    1.204452] intel_idle: MWAIT substates: 0x33000020
[    1.204457] intel_idle: v0.4 model 0x37
[    1.204461] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.205142] ACPI Exception: AE_ERROR, Returned by Handler for [GeneralPurposeIo] (20141107/evregion-297)
[    1.205306] ACPI Error: Method parse/execution failed [\_SB_.ADP1._PSR] (Node ffff8800728bc9b0), AE_ERROR (20141107/psparse-536)
[    1.205513] ACPI Exception: AE_ERROR, Error reading AC Adapter state (20141107/ac-131)
[    1.210453] [Firmware Bug]: No valid trip found
[    1.210645] GHES: HEST is not enabled!
[    1.210983] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.231227] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.235940] hpet: number irqs doesn't agree with number of timers
[    1.236119] Linux agpgart interface v0.103
[    1.240417] brd: module loaded
[    1.242662] loop: module loaded
[    1.243392] libphy: Fixed MDIO Bus: probed
[    1.243467] tun: Universal TUN/TAP device driver, 1.6
[    1.243545] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.243762] PPP generic driver version 2.4.2
[    1.244038] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.244152] ehci-pci: EHCI PCI platform driver
[    1.244491] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.244589] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.244722] ehci-pci 0000:00:1d.0: debug port 2
[    1.248725] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.248765] ehci-pci 0000:00:1d.0: irq 23, io mem 0x9060d000
[    1.257081] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.257295] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.257404] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.257514] usb usb1: Product: EHCI Host Controller
[    1.257591] usb usb1: Manufacturer: Linux 3.19.0-031900rc6-generic ehci_hcd
[    1.257696] usb usb1: SerialNumber: 0000:00:1d.0
[    1.258112] hub 1-0:1.0: USB hub found
[    1.258200] hub 1-0:1.0: 8 ports detected
[    1.258950] ehci-platform: EHCI generic platform driver
[    1.259077] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.259185] ohci-pci: OHCI PCI platform driver
[    1.259288] ohci-platform: OHCI generic platform driver
[    1.259399] uhci_hcd: USB Universal Host Controller Interface driver
[    1.259634] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.982779] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.111786] usb 1-1: New USB device found, idVendor=8087, idProduct=07e6
[    2.111894] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.112494] hub 1-1:1.0: USB hub found
[    2.112658] hub 1-1:1.0: 4 ports detected
[    2.294084] i8042: No controller found
[    2.298425] Switched to clocksource tsc
[    2.298815] mousedev: PS/2 mouse device common for all mice
[    2.299091] ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20141107/evxface-643)
[    2.299096] rtc_cmos 00:00: RTC can wake from S4
[    2.299184] rtc (null): invalid alarm value: 2015-2-6 14:65:63
[    2.299368] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.299456] rtc_cmos 00:00: alarms up to one day, 242 bytes nvram
[    2.299756] device-mapper: uevent: version 1.0.3
[    2.300189] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
[    2.300219] Intel P-state driver initializing.
[    2.300650] ledtrig-cpu: registered to indicate activity on CPUs
[    2.300657] EFI Variables Facility v0.08 2004-May-17
[    2.306456] PCCT header not found.
[    2.306457] ACPI PCC probe failed.
[    2.306680] TCP: cubic registered
[    2.306936] NET: Registered protocol family 10
[    2.307739] NET: Registered protocol family 17
[    2.307775] Key type dns_resolver registered
[    2.309601] Loading compiled-in X.509 certificates
[    2.311659] Loaded X.509 cert 'Magrathea: Glacier signing key: 43dbbfb67f6a8fa4dcf7857f524e05f411517371'
[    2.311698] registered taskstats version 1
[    2.319257] Key type trusted registered
[    2.334194] Key type encrypted registered
[    2.334215] AppArmor: AppArmor sha1 policy hashing enabled
[    2.334221] ima: No TPM chip found, activating TPM-bypass!
[    2.334268] evm: HMAC attrs: 0x1
[    2.335331]   Magic number: 3:387:535
[    2.335358] bdi 1:13: hash matches
[    2.335373] tty ttyS15: hash matches
[    2.336984] rtc_cmos 00:00: setting system clock to 2015-02-06 14:31:32 UTC (1423233092)
[    2.337521] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.337522] EDD information not available.
[    2.337815] PM: Hibernation image not present or could not be loaded.
[    2.404961] Freeing unused kernel memory: 1408K (ffffffff81d24000 - ffffffff81e84000)
[    2.409180] Write protecting the kernel read-only data: 12288k
[    2.415401] Freeing unused kernel memory: 152K (ffff8800027da000 - ffff880002800000)
[    2.420958] Freeing unused kernel memory: 244K (ffff880002bc3000 - ffff880002c00000)
[    2.478418] systemd-udevd[121]: starting version 204
[    2.508035] sdhci: Secure Digital Host Controller Interface driver
[    2.511743] sdhci: Copyright(c) Pierre Ossman
[    2.520441] sdhci-acpi 80860F14:00: No vmmc regulator found
[    2.522331] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    2.528190] sdhci-acpi 80860F14:00: No vqmmc regulator found
[    2.532186] mmc0: SDHCI controller on ACPI [80860F14:00] using ADMA
[    2.533368] sdhci-acpi INT33BB:00: No vmmc regulator found
[    2.533370] sdhci-acpi INT33BB:00: No vqmmc regulator found
[    2.536725] mmc1: SDHCI controller on ACPI [INT33BB:00] using ADMA
[    2.538067] sdhci-acpi 80860F14:01: No vmmc regulator found
[    2.538070] sdhci-acpi 80860F14:01: No vqmmc regulator found
[    2.541826] mmc2: SDHCI controller on ACPI [80860F14:01] using ADMA
[    2.628446] usb 1-1.1: New USB device found, idVendor=1a40, idProduct=0101
[    2.632919] usb 1-1.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.637417] usb 1-1.1: Product: USB 2.0 Hub
[    2.643242] hub 1-1.1:1.0: USB hub found
[    2.648028] hub 1-1.1:1.0: 4 ports detected
[    2.722530] mmc0: BKOPS_EN bit is not set
[    2.738786] mmc0: new HS200 MMC card at address 0001
[    2.746765] Driver 'mmcblk' needs updating - please use bus_type methods
[    2.752056] mmcblk0: mmc0:0001 BWBC3R 29.1 GiB
[    2.757297] mmcblk0boot0: mmc0:0001 BWBC3R partition 1 4.00 MiB
[    2.762533] mmcblk0boot1: mmc0:0001 BWBC3R partition 2 4.00 MiB
[    2.767578] mmcblk0rpmb: mmc0:0001 BWBC3R partition 3 4.00 MiB
[    2.782086]  mmcblk0: p1 p2 p3
[    2.827597] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    2.834321] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    2.841072] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    2.849552] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    2.911123] EXT4-fs (mmcblk0p3): INFO: recovery required on readonly filesystem
[    2.914321] EXT4-fs (mmcblk0p3): write access will be enabled during recovery
[    2.919521] mmc1: new high speed SDIO card at address 0001
[    2.946905] usb 1-1.1.1: new full-speed USB device number 4 using ehci-pci
[    2.980875] EXT4-fs (mmcblk0p3): recovery complete
[    2.986500] EXT4-fs (mmcblk0p3): mounted filesystem with ordered data mode. Opts: (null)
[    3.067157] usb 1-1.1.1: New USB device found, idVendor=045e, idProduct=0745
[    3.070889] usb 1-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.074208] usb 1-1.1.1: Product: Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0
[    3.077563] usb 1-1.1.1: Manufacturer: Microsoft
[    3.154672] usb 1-1.1.4: new high-speed USB device number 5 using ehci-pci
[    3.267541] usb 1-1.1.4: New USB device found, idVendor=0bda, idProduct=8152
[    3.270962] usb 1-1.1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.274284] usb 1-1.1.4: Product: USB 10/100 LAN
[    3.277606] usb 1-1.1.4: Manufacturer: Realtek
[    3.280945] usb 1-1.1.4: SerialNumber: 00012E58F054
[    3.288358] random: init urandom read with 37 bits of entropy available
[    3.363966] init: plymouth-upstart-bridge main process (181) terminated with status 1
[    3.367978] init: plymouth-upstart-bridge main process ended, respawning
[    3.388629] init: plymouth-upstart-bridge main process (191) terminated with status 1
[    3.392167] init: plymouth-upstart-bridge main process ended, respawning
[    3.407642] init: plymouth-upstart-bridge main process (194) terminated with status 1
[    3.412323] init: plymouth-upstart-bridge main process ended, respawning
[    3.436496] init: ureadahead main process (184) terminated with status 5
[    3.626082] Adding 1112060k swap on /dev/mmcblk0p2.  Priority:-1 extents:1 across:1112060k SSFS
[    3.806512] EXT4-fs (mmcblk0p3): re-mounted. Opts: errors=remount-ro
[    3.908968] systemd-udevd[335]: starting version 204
[    4.010734] lp: driver loaded but no devices found
[    4.032463] ppdev: user-space parallel port driver
[    4.190839] [drm] Initialized drm 1.1.0 20060810
[    4.232335] mei_txe 0000:00:1a.0: can't derive routing for PCI INT A
[    4.232343] mei_txe 0000:00:1a.0: PCI INT A: no GSI
[    4.240769] 80860F0A:00: ttyS4 at MMIO 0x90736000 (irq = 39, base_baud = 2764800) is a 16550A
[    4.292321] [Firmware Bug]: No valid trip found
[    4.323050] byt_gpio INT33FC:02: pin 16 cannot be used as GPIO.
[    4.352442] hidraw: raw HID events driver (C) Jiri Kosina
[    4.356513] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8 channels
[    4.357930] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8 channels
[    4.388195] [drm] Memory usable by graphics device = 2048M
[    4.388207] checking generic (80000000 7f0000) vs hw (80000000 10000000)
[    4.388211] fb: switching to inteldrmfb from EFI VGA
[    4.388277] Console: switching to colour dummy device 80x25
[    4.388634] [drm] Replacing VGA console driver
[    4.392561] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.392568] [drm] Driver supports precise vblank timestamp query.
[    4.429187] Bluetooth: Core ver 2.20
[    4.429239] NET: Registered protocol family 31
[    4.429244] Bluetooth: HCI device and connection manager initialized
[    4.429253] Bluetooth: HCI socket layer initialized
[    4.429260] Bluetooth: L2CAP socket layer initialized
[    4.429275] Bluetooth: SCO socket layer initialized
[    4.446974] Bluetooth: RFCOMM TTY layer initialized
[    4.446990] Bluetooth: RFCOMM socket layer initialized
[    4.447007] Bluetooth: RFCOMM ver 1.11
[    4.463309] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.463317] Bluetooth: BNEP filters: protocol multicast
[    4.463327] Bluetooth: BNEP socket layer initialized
[    4.623601] usbcore: registered new interface driver r8152
[    4.637831] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.660018] usbcore: registered new interface driver usbhid
[    4.660025] usbhid: USB HID core driver
[    4.660238] cfg80211: Calling CRDA to update world regulatory domain
[    4.671556] usbcore: registered new interface driver cdc_ether
[    4.697938] usb 1-1.1.4: reset high-speed USB device number 5 using ehci-pci
[    4.737019] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    4.739368] acpi device:09: registered as cooling_device4
[    4.739754] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input0
[    4.741925] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    4.774226] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    4.776304] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    4.776981] SSE version of gcm_enc/dec engaged.
[    4.778748] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    4.782349] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    4.847688] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to bit banging on pin 4
[    4.854533] fbcon: inteldrmfb (fb0) is primary device
[    4.859424] usbcore: registered new interface driver brcmfmac
[    4.893037] r8152 1-1.1.4:1.0 eth0: v1.07.0 (2014/10/09)
[    4.918410] intel_soc_dts_thermal: request_threaded_irq ret -22
[    4.930189] intel_rapl: Found RAPL domain package
[    4.930192] intel_rapl: Found RAPL domain core
[    4.945466] input: gpio-keys as /devices/platform/gpio-keys.0.auto/input/input1
[    4.961296] input: gpio-keys as /devices/platform/gpio-keys.1.auto/input/input2
[    5.002853] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/0003:045E:0745.0001/input/input3
[    5.005127] random: nonblocking pool is initialized
[    5.026974] cfg80211: World regulatory domain updated:
[    5.026984] cfg80211:  DFS Master region: unset
[    5.026985] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.026990] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.026993] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.026995] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.026998] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.027000] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.058554] hid-generic 0003:045E:0745.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input0
[    5.059325] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.1/0003:045E:0745.0002/input/input4
[    5.114655] hid-generic 0003:045E:0745.0002: input,hidraw1: USB HID v1.11 Mouse [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input1
[    5.125415] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.2/0003:045E:0745.0003/input/input5
[    5.182608] hid-generic 0003:045E:0745.0003: input,hiddev0,hidraw2: USB HID v1.11 Device [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input2
[    5.193679] Console: switching to colour frame buffer device 240x67
[    5.200252] brcmf_c_preinit_dcmds: Firmware version = wl0: Jan 29 2014 01:40:06 version 5.97.39.4 FWID 01-c7b9d775
[    5.209970] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.209973] i915 0000:00:02.0: registered panic notifier
[    5.593713] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.880383] init: failsafe main process (617) killed by TERM signal
[    5.972645] init: network-manager main process (819) terminated with status 127
[    5.972681] init: network-manager main process ended, respawning
[    6.346054] init: Failed to spawn whoopsie main process: unable to execute: No such file or directory
[    6.614976] init: lightdm main process (1019) terminated with status 127
[    6.626637] init: plymouth-ready (startup) main process (180) terminated with status 1
[    7.794914] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
--------------040207080401090706030200
Content-Type: text/plain; charset=UTF-8;
 name="dmesg_sta.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_sta.txt"

# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-031900rc6-generic (kernel@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201501261152 SMP Mon Jan 26 16:53:27 UTC 2015
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-031900rc6-generic root=UUID=0eb830d0-4493-422e-9d21-b2dea11e96c9 ro vt.handoff=1 nosplash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x00000000763cafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000763cb000-0x00000000763fafff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000763fb000-0x0000000076425fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076426000-0x00000000764cdfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000764ce000-0x00000000765e1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000765e2000-0x000000007662afff] type 20
[    0.000000] BIOS-e820: [mem 0x000000007662b000-0x0000000076cfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0x76425000  ACPI 2.0=0x76425014  SMBIOS=0x765e1390
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x000000000008f000) (0MB)
[    0.000000] efi: mem01: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000090000-0x000000000009e000) (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x00000000014d5000) (19MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000014d5000-0x0000000002000000) (11MB)
[    0.000000] efi: mem06: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000002000000-0x00000000033d5000) (19MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000033d5000-0x0000000020000000) (460MB)
[    0.000000] efi: mem08: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000020200000-0x0000000035ca6000) (346MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000035ca6000-0x0000000036e4b000) (17MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000036e4b000-0x00000000560cc000) (498MB)
[    0.000000] efi: mem12: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000560cc000-0x0000000072d00000) (460MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072d00000-0x0000000072d20000) (0MB)
[    0.000000] efi: mem14: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072d20000-0x0000000072f5f000) (2MB)
[    0.000000] efi: mem15: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072f5f000-0x0000000072f74000) (0MB)
[    0.000000] efi: mem16: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072f74000-0x0000000075dcb000) (46MB)
[    0.000000] efi: mem17: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000075dcb000-0x0000000076259000) (4MB)
[    0.000000] efi: mem18: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076259000-0x0000000076263000) (0MB)
[    0.000000] efi: mem19: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076263000-0x00000000763cb000) (1MB)
[    0.000000] efi: mem20: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000763cb000-0x00000000763fb000) (0MB)
[    0.000000] efi: mem21: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000763fb000-0x0000000076426000) (0MB)
[    0.000000] efi: mem22: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076426000-0x00000000764ce000) (0MB)
[    0.000000] efi: mem23: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000764ce000-0x00000000765e2000) (1MB)
[    0.000000] efi: mem24: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000765e2000-0x000000007662b000) (0MB)
[    0.000000] efi: mem25: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007662b000-0x0000000076cf6000) (6MB)
[    0.000000] efi: mem26: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076cf6000-0x0000000076cf7000) (0MB)
[    0.000000] efi: mem27: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076cf7000-0x0000000076d00000) (0MB)
[    0.000000] efi: mem28: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] efi: mem29: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed01000-0x00000000fed02000) (0MB)
[    0.000000] efi: mem30: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed08000-0x00000000fed09000) (0MB)
[    0.000000] efi: mem31: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000ffb00000-0x0000000100000000) (5MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: ZOTAC ZBOX-PI320 Series/ZBOX-PI320, BIOS B253P013 10/29/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x76d00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 060000000 mask FF0000000 write-back
[    0.000000]   3 base 070000000 mask FF8000000 write-back
[    0.000000]   4 base 070000000 mask FF8000000 write-back
[    0.000000]   5 base 077000000 mask FFF000000 uncachable
[    0.000000]   6 base 076E00000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1GB, range: 512MB, type WB
[    0.000000] reg 2, base: 1536MB, range: 256MB, type WB
[    0.000000] reg 3, base: 1792MB, range: 128MB, type WB
[    0.000000] reg 4, base: 1792MB, range: 128MB, type WB
[    0.000000] reg 5, base: 1904MB, range: 16MB, type UC
[    0.000000] reg 6, base: 1902MB, range: 2MB, type UC
[    0.000000] total RAM covered: 1902M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 4      lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 1902MB, range: 2MB, type UC
[    0.000000] reg 2, base: 1904MB, range: 16MB, type UC
[    0.000000] reg 3, base: 1920MB, range: 128MB, type UC
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fd0000, 0x02fd0fff] PGTABLE
[    0.000000] BRK [0x02fd1000, 0x02fd1fff] PGTABLE
[    0.000000] BRK [0x02fd2000, 0x02fd2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x76000000-0x761fffff]
[    0.000000]  [mem 0x76000000-0x761fffff] page 2M
[    0.000000] BRK [0x02fd3000, 0x02fd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x60000000-0x75ffffff]
[    0.000000]  [mem 0x60000000-0x75ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40000000-0x5fffffff]
[    0.000000]  [mem 0x40000000-0x5fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x76200000-0x763cafff]
[    0.000000]  [mem 0x76200000-0x763cafff] page 4k
[    0.000000] BRK [0x02fd4000, 0x02fd4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7662b000-0x76cfffff]
[    0.000000]  [mem 0x7662b000-0x767fffff] page 4k
[    0.000000]  [mem 0x76800000-0x76bfffff] page 2M
[    0.000000]  [mem 0x76c00000-0x76cfffff] page 4k
[    0.000000] BRK [0x02fd5000, 0x02fd5fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35ca6000-0x36e4afff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x0000000076425014 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x0000000076424100 000084 (v01 ALASKA A M I    00000003 MSFT 0100000D)
[    0.000000] ACPI: FACP 0x0000000076422000 00010C (v05 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: DSDT 0x000000007640E000 00FA77 (v02 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: MSDM 0x0000000076423000 000055 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: UEFI 0x0000000076492000 000042 (v01 ALASKA A M I    00000000      00000000)
[    0.000000] ACPI: HPET 0x0000000076421000 000038 (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: LPIT 0x0000000076420000 000104 (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: APIC 0x000000007641F000 00006C (v03 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: MCFG 0x000000007641E000 00003C (v01 ALASKA A M I    00000003 AMI  0100000D)
[    0.000000] ACPI: FPDT 0x0000000076407000 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x0000000076406000 000763 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076405000 000290 (v01 PmRef  Cpu0Tst  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076404000 00017A (v01 PmRef  ApTst    00003000 INTL 20061109)
[    0.000000] ACPI: CSRT 0x000000007640D000 00014C (v00 ALASKA A M I    00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000076cfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x7625d000-0x76261fff]
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff880070a00000-ffff8800727fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0x76cfffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x763cafff]
[    0.000000]   node   0: [mem 0x7662b000-0x76cfffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x76cfffff]
[    0.000000] On node 0 totalpages: 485436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7540 pages used for memmap
[    0.000000]   DMA32 zone: 481440 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics stolen memory at 0x77000000-0x7effffff
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x763cb000-0x763fafff]
[    0.000000] PM: Registered nosave memory: [mem 0x763fb000-0x76425fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76426000-0x764cdfff]
[    0.000000] PM: Registered nosave memory: [mem 0x764ce000-0x765e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x765e2000-0x7662afff]
[    0.000000] e820: [mem 0x7f000000-0xe00f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880076000000 s86976 r8192 d31808 u524288
[    0.000000] pcpu-alloc: s86976 r8192 d31808 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 477810
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-031900rc6-generic root=UUID=0eb830d0-4493-422e-9d21-b2dea11e96c9 ro vt.handoff=1 nosplash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1819864K/1941744K available (8026K kernel code, 1163K rwdata, 3852K rodata, 1408K init, 1292K bss, 121880K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:16640 nr_irqs:1024 16
[    0.000000]  Offload RCU callbacks from all CPUs
[    0.000000]  Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Maximum core-clock to bus-clock ratio: 0x10
[    0.000000] Resolved frequency ID: 0, frequency: 83200 KHz
[    0.000000] TSC runs at 1331200 KHz
[    0.000000] lapic_timer_frequency = 332800
[    0.000000] tsc: Detected 1331.200 MHz processor
[    0.000058] Calibrating delay loop (skipped), value calculated using timer frequency.. 2662.40 BogoMIPS (lpj=5324800)
[    0.000077] pid_max: default: 32768 minimum: 301
[    0.000096] ACPI: Core revision 20141107
[    0.037624] ACPI: All ACPI Tables successfully acquired
[    0.039350] Security Framework initialized
[    0.039380] AppArmor: AppArmor initialized
[    0.039390] Yama: becoming mindful.
[    0.039873] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.041324] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.041987] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.042013] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.042521] Initializing cgroup subsys memory
[    0.042546] Initializing cgroup subsys devices
[    0.042560] Initializing cgroup subsys freezer
[    0.042573] Initializing cgroup subsys net_cls
[    0.042584] Initializing cgroup subsys blkio
[    0.042596] Initializing cgroup subsys perf_event
[    0.042609] Initializing cgroup subsys net_prio
[    0.042621] Initializing cgroup subsys hugetlb
[    0.042671] CPU: Physical Processor ID: 0
[    0.042681] CPU: Processor Core ID: 0
[    0.042694] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.042694] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.047642] mce: CPU supports 6 MCE banks
[    0.047662] CPU0: Thermal monitoring enabled (TM1)
[    0.047680] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.047680] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.047861] Freeing SMP alternatives memory: 28K (ffffffff81e84000 - ffffffff81e8b000)
[    0.054848] ftrace: allocating 32886 entries in 129 pages
[    0.084691] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.124380] smpboot: CPU0: Intel(R) Atom(TM) CPU  Z3735F @ 1.33GHz (fam: 06, model: 37, stepping: 08)
[    0.124420] TSC deadline timer enabled
[    0.124475] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.124507] ... version:                3
[    0.124514] ... bit width:              40
[    0.124520] ... generic registers:      2
[    0.124527] ... value mask:             000000ffffffffff
[    0.124534] ... max period:             000000ffffffffff
[    0.124541] ... fixed-purpose events:   3
[    0.124548] ... event mask:             0000000700000003
[    0.126767] x86: Booting SMP configuration:
[    0.126781] .... node  #0, CPUs:      #1
[    0.144869] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.145251]  #2 #3
[    0.181456] x86: Booted up 1 node, 4 CPUs
[    0.181470] smpboot: Total of 4 processors activated (10649.60 BogoMIPS)
[    0.182890] devtmpfs: initialized
[    0.194338] evm: security.selinux
[    0.194347] evm: security.SMACK64
[    0.194354] evm: security.SMACK64EXEC
[    0.194360] evm: security.SMACK64TRANSMUTE
[    0.194366] evm: security.SMACK64MMAP
[    0.194373] evm: security.ima
[    0.194379] evm: security.capability
[    0.194538] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.194552] PM: Registering ACPI NVS region [mem 0x76426000-0x764cdfff] (688128 bytes)
[    0.194999] pinctrl core: initialized pinctrl subsystem
[    0.195274] RTC time: 14:26:36, date: 02/06/15
[    0.195631] NET: Registered protocol family 16
[    0.200792] cpuidle: using governor ladder
[    0.204803] cpuidle: using governor menu
[    0.204976] ACPI: bus type PCI registered
[    0.204987] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.205214] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.205229] PCI: not using MMCONFIG
[    0.205237] PCI: Using configuration type 1 for base access
[    0.210743] ACPI: Added _OSI(Module Device)
[    0.210756] ACPI: Added _OSI(Processor Device)
[    0.210765] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.210773] ACPI: Added _OSI(Processor Aggregator Device)
[    0.237480] ACPI: Dynamic OEM Table Load:
[    0.237520] ACPI: SSDT 0xFFFF880070333000 000501 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.239445] ACPI: Dynamic OEM Table Load:
[    0.239468] ACPI: SSDT 0xFFFF880070333800 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.242037] ACPI: Dynamic OEM Table Load:
[    0.242058] ACPI: SSDT 0xFFFF880070365A00 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.243918] ACPI: Dynamic OEM Table Load:
[    0.243938] ACPI: SSDT 0xFFFF880070359840 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.247972] ACPI: Interpreter enabled
[    0.247994] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20141107/hwxface-580)
[    0.248017] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.248037] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20141107/hwxface-580)
[    0.248078] ACPI: (supports S0 S4 S5)
[    0.248087] ACPI: Using IOAPIC for interrupt routing
[    0.248155] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.259584] [Firmware Info]: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] not reserved in ACPI motherboard resources
[    0.259600] PCI: not using MMCONFIG
[    0.259648] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.265712] ACPI: Power Resource [USBC] (on)
[    0.266554] ACPI: Power Resource [WWPR] (off)
[    0.272649] ACPI: Power Resource [PLPE] (on)
[    0.284180] ACPI: Power Resource [CLK0] (on)
[    0.284321] ACPI: Power Resource [CLK1] (on)
[    0.285099] ACPI: Power Resource [P28X] (off)
[    0.285236] ACPI: Power Resource [P18X] (off)
[    0.286440] ACPI: Power Resource [P28P] (off)
[    0.286577] ACPI: Power Resource [P18P] (off)
[    0.296888] ACPI: Power Resource [P28T] (off)
[    0.297031] ACPI: Power Resource [P18T] (off)
[    0.297165] ACPI: Power Resource [P1XT] (off)
[    0.299632] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.299654] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.299789] \_SB_.PCI0:_OSC invalid UUID
[    0.299794] _OSC request data:1 1e 0
[    0.299806] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.300567] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.301105] PCI host bridge to bus 0000:00
[    0.301119] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.301131] pci_bus 0000:00: root bus resource [io  0x0000-0x006f]
[    0.301141] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7]
[    0.301152] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.301163] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.301174] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.301185] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff]
[    0.301196] pci_bus 0000:00: root bus resource [mem 0x90800000-0x90bfffff]
[    0.301207] pci_bus 0000:00: root bus resource [mem 0x77000001-0x7f000000]
[    0.301218] pci_bus 0000:00: root bus resource [mem 0x80000000-0x906ffffe]
[    0.301229] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed40fff]
[    0.301252] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.301510] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.301533] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.301551] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.301568] pci 0000:00:02.0: reg 0x20: [io  0x1000-0x1007]
[    0.301869] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.301905] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.301925] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.302057] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.302303] pci 0000:00:1d.0: [8086:0f34] type 00 class 0x0c0320
[    0.302340] pci 0000:00:1d.0: reg 0x10: [mem 0x9060d000-0x9060d3ff]
[    0.302486] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.302722] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.303912] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.304126] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.304347] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.304553] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.304757] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.304961] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.305165] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.305370] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.305862] platform 80860F28:00: failed to claim resource 0
[    0.305877] acpi 80860F28:00: platform device creation failed: -16
[    0.315314] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.315329] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.315342] vgaarb: loaded
[    0.315349] vgaarb: bridge control possible 0000:00:02.0
[    0.316091] SCSI subsystem initialized
[    0.316235] libata version 3.00 loaded.
[    0.316322] ACPI: bus type USB registered
[    0.316398] usbcore: registered new interface driver usbfs
[    0.316437] usbcore: registered new interface driver hub
[    0.316503] usbcore: registered new device driver usb
[    0.317056] PCI: Using ACPI for IRQ routing
[    0.317068] PCI: pci_cache_line_size set to 64 bytes
[    0.317097] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.317109] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.317114] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.317119] e820: reserve RAM buffer [mem 0x763cb000-0x77ffffff]
[    0.317124] e820: reserve RAM buffer [mem 0x76d00000-0x77ffffff]
[    0.317449] NetLabel: Initializing
[    0.317458] NetLabel:  domain hash size = 128
[    0.317464] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.317499] NetLabel:  unlabeled traffic allowed by default
[    0.317787] Switched to clocksource refined-jiffies
[    0.335123] AppArmor: AppArmor Filesystem Enabled
[    0.335323] pnp: PnP ACPI init
[    0.335476] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.335807] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.335822] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.335834] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.335846] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.335858] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.335872] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.336139] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.339273] pnp: PnP ACPI: found 3 devices
[    0.345702] pci_bus 0000:00: resource 4 [io  0x0000-0x006f]
[    0.345711] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7]
[    0.345718] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    0.345724] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.345730] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.345736] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff]
[    0.345755] pci_bus 0000:00: resource 10 [mem 0x90800000-0x90bfffff]
[    0.345762] pci_bus 0000:00: resource 11 [mem 0x77000001-0x7f000000]
[    0.345768] pci_bus 0000:00: resource 12 [mem 0x80000000-0x906ffffe]
[    0.345774] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed40fff]
[    0.345848] NET: Registered protocol family 2
[    0.346287] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.346414] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.346538] TCP: Hash tables configured (established 16384 bind 16384)
[    0.346598] TCP: reno registered
[    0.346620] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.346658] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.346792] NET: Registered protocol family 1
[    0.346837] pci 0000:00:02.0: Video device with shadowed ROM
[    0.347209] PCI: CLS 0 bytes, default 64
[    0.347379] Trying to unpack rootfs image as initramfs...
[    1.114368] Freeing initrd memory: 18068K (ffff880035ca6000 - ffff880036e4b000)
[    1.115051] microcode: CPU0 sig=0x30678, pf=0x2, revision=0x82b
[    1.115074] microcode: CPU1 sig=0x30678, pf=0x2, revision=0x82b
[    1.115102] microcode: CPU2 sig=0x30678, pf=0x2, revision=0x82b
[    1.115129] microcode: CPU3 sig=0x30678, pf=0x2, revision=0x82b
[    1.115286] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.115420] Scanning for low memory corruption every 60 seconds
[    1.116431] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    1.116476] Initialise system trusted keyring
[    1.116538] audit: initializing netlink subsys (disabled)
[    1.116587] audit: type=2000 audit(1423232797.088:1): initialized
[    1.117325] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.122514] zpool: loaded
[    1.122526] zbud: loaded
[    1.122946] VFS: Disk quotas dquot_6.5.2
[    1.123072] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.124684] fuse init (API version 7.23)
[    1.125130] Key type big_key registered
[    1.125986] Key type asymmetric registered
[    1.126000] Asymmetric key parser 'x509' registered
[    1.126125] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.126228] io scheduler noop registered
[    1.126242] io scheduler deadline registered (default)
[    1.126354] io scheduler cfq registered
[    1.126579] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.126641] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.126769] efifb: probing for efifb
[    1.126836] efifb: framebuffer at 0x80000000, mapped to 0xffffc90000480000, using 8128k, total 8128k
[    1.126849] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    1.126856] efifb: scrolling: redraw
[    1.126865] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.145803] Console: switching to colour frame buffer device 240x67
[    1.164637] fb0: EFI VGA frame buffer device
[    1.164728] intel_idle: MWAIT substates: 0x33000020
[    1.164733] intel_idle: v0.4 model 0x37
[    1.164737] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.165427] ACPI Exception: AE_ERROR, Returned by Handler for [GeneralPurposeIo] (20141107/evregion-297)
[    1.165592] ACPI Error: Method parse/execution failed [\_SB_.ADP1._PSR] (Node ffff8800728bc9b0), AE_ERROR (20141107/psparse-536)
[    1.165798] ACPI Exception: AE_ERROR, Error reading AC Adapter state (20141107/ac-131)
[    1.170718] [Firmware Bug]: No valid trip found
[    1.170909] GHES: HEST is not enabled!
[    1.171266] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.191509] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.196209] hpet: number irqs doesn't agree with number of timers
[    1.196388] Linux agpgart interface v0.103
[    1.200679] brd: module loaded
[    1.202912] loop: module loaded
[    1.203616] libphy: Fixed MDIO Bus: probed
[    1.203691] tun: Universal TUN/TAP device driver, 1.6
[    1.203770] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.203995] PPP generic driver version 2.4.2
[    1.204272] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.204387] ehci-pci: EHCI PCI platform driver
[    1.204715] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.204812] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.204945] ehci-pci 0000:00:1d.0: debug port 2
[    1.208960] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.209000] ehci-pci 0000:00:1d.0: irq 23, io mem 0x9060d000
[    1.217355] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.217565] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.217673] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.217784] usb usb1: Product: EHCI Host Controller
[    1.217861] usb usb1: Manufacturer: Linux 3.19.0-031900rc6-generic ehci_hcd
[    1.217967] usb usb1: SerialNumber: 0000:00:1d.0
[    1.218377] hub 1-0:1.0: USB hub found
[    1.218461] hub 1-0:1.0: 8 ports detected
[    1.219184] ehci-platform: EHCI generic platform driver
[    1.219304] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.219412] ohci-pci: OHCI PCI platform driver
[    1.219520] ohci-platform: OHCI generic platform driver
[    1.219632] uhci_hcd: USB Universal Host Controller Interface driver
[    1.219867] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.946038] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.075376] usb 1-1: New USB device found, idVendor=8087, idProduct=07e6
[    2.075486] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.076115] hub 1-1:1.0: USB hub found
[    2.076269] hub 1-1:1.0: 4 ports detected
[    2.254320] i8042: No controller found
[    2.258669] Switched to clocksource tsc
[    2.258896] mousedev: PS/2 mouse device common for all mice
[    2.259215] ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20141107/evxface-643)
[    2.259220] rtc_cmos 00:00: RTC can wake from S4
[    2.259306] rtc (null): invalid alarm value: 2015-2-6 14:65:63
[    2.259518] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.259556] rtc_cmos 00:00: alarms up to one day, 242 bytes nvram
[    2.259796] device-mapper: uevent: version 1.0.3
[    2.260217] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
[    2.260248] Intel P-state driver initializing.
[    2.260622] ledtrig-cpu: registered to indicate activity on CPUs
[    2.260629] EFI Variables Facility v0.08 2004-May-17
[    2.265263] PCCT header not found.
[    2.265264] ACPI PCC probe failed.
[    2.265487] TCP: cubic registered
[    2.265840] NET: Registered protocol family 10
[    2.267016] NET: Registered protocol family 17
[    2.267040] Key type dns_resolver registered
[    2.268466] Loading compiled-in X.509 certificates
[    2.271243] Loaded X.509 cert 'Magrathea: Glacier signing key: 43dbbfb67f6a8fa4dcf7857f524e05f411517371'
[    2.271279] registered taskstats version 1
[    2.277728] Key type trusted registered
[    2.288126] Key type encrypted registered
[    2.288141] AppArmor: AppArmor sha1 policy hashing enabled
[    2.288147] ima: No TPM chip found, activating TPM-bypass!
[    2.288209] evm: HMAC attrs: 0x1
[    2.288604]   Magic number: 3:284:434
[    2.291664] rtc_cmos 00:00: setting system clock to 2015-02-06 14:26:38 UTC (1423232798)
[    2.291977] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.291978] EDD information not available.
[    2.292278] PM: Hibernation image not present or could not be loaded.
[    2.360508] Freeing unused kernel memory: 1408K (ffffffff81d24000 - ffffffff81e84000)
[    2.364786] Write protecting the kernel read-only data: 12288k
[    2.371302] Freeing unused kernel memory: 152K (ffff8800027da000 - ffff880002800000)
[    2.376631] Freeing unused kernel memory: 244K (ffff880002bc3000 - ffff880002c00000)
[    2.431780] systemd-udevd[121]: starting version 204
[    2.469019] sdhci: Secure Digital Host Controller Interface driver
[    2.469020] sdhci: Copyright(c) Pierre Ossman
[    2.478697] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    2.482091] sdhci-acpi 80860F14:00: No vmmc regulator found
[    2.482094] sdhci-acpi 80860F14:00: No vqmmc regulator found
[    2.486812] mmc0: SDHCI controller on ACPI [80860F14:00] using ADMA
[    2.488042] sdhci-acpi INT33BB:00: No vmmc regulator found
[    2.488045] sdhci-acpi INT33BB:00: No vqmmc regulator found
[    2.492433] mmc1: SDHCI controller on ACPI [INT33BB:00] using ADMA
[    2.493859] sdhci-acpi 80860F14:01: No vmmc regulator found
[    2.493862] sdhci-acpi 80860F14:01: No vqmmc regulator found
[    2.497696] mmc2: SDHCI controller on ACPI [80860F14:01] using ADMA
[    2.613036] usb 1-1.1: New USB device found, idVendor=1a40, idProduct=0101
[    2.617074] usb 1-1.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.620305] usb 1-1.1: Product: USB 2.0 Hub
[    2.624712] hub 1-1.1:1.0: USB hub found
[    2.628868] hub 1-1.1:1.0: 4 ports detected
[    2.691231] mmc0: BKOPS_EN bit is not set
[    2.709419] mmc0: new HS200 MMC card at address 0001
[    2.720701] Driver 'mmcblk' needs updating - please use bus_type methods
[    2.725769] mmcblk0: mmc0:0001 BWBC3R 29.1 GiB
[    2.731083] mmcblk0boot0: mmc0:0001 BWBC3R partition 1 4.00 MiB
[    2.736127] mmcblk0boot1: mmc0:0001 BWBC3R partition 2 4.00 MiB
[    2.740272] mmcblk0rpmb: mmc0:0001 BWBC3R partition 3 4.00 MiB
[    2.752934]  mmcblk0: p1 p2 p3
[    2.790361] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    2.796948] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    2.803643] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    2.811071] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    2.865132] mmc1: new high speed SDIO card at address 0001
[    2.905438] EXT4-fs (mmcblk0p3): INFO: recovery required on readonly filesystem
[    2.908527] EXT4-fs (mmcblk0p3): write access will be enabled during recovery
[    2.927478] usb 1-1.1.1: new full-speed USB device number 4 using ehci-pci
[    3.032006] EXT4-fs (mmcblk0p3): recovery complete
[    3.037213] EXT4-fs (mmcblk0p3): mounted filesystem with ordered data mode. Opts: (null)
[    3.053342] usb 1-1.1.1: New USB device found, idVendor=045e, idProduct=0745
[    3.057511] usb 1-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.061010] usb 1-1.1.1: Product: Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0
[    3.064883] usb 1-1.1.1: Manufacturer: Microsoft
[    3.073579] hidraw: raw HID events driver (C) Jiri Kosina
[    3.099687] usbcore: registered new interface driver usbhid
[    3.104113] usbhid: USB HID core driver
[    3.155315] usb 1-1.1.4: new high-speed USB device number 5 using ehci-pci
[    3.270420] usb 1-1.1.4: New USB device found, idVendor=0bda, idProduct=8152
[    3.274698] usb 1-1.1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.274701] usb 1-1.1.4: Product: USB 10/100 LAN
[    3.274703] usb 1-1.1.4: Manufacturer: Realtek
[    3.274706] usb 1-1.1.4: SerialNumber: 00012E58F054
[    3.347937] random: init urandom read with 44 bits of entropy available
[    3.428523] init: plymouth-upstart-bridge main process (182) terminated with status 1
[    3.432249] init: plymouth-upstart-bridge main process ended, respawning
[    3.452140] init: plymouth-upstart-bridge main process (192) terminated with status 1
[    3.455845] init: plymouth-upstart-bridge main process ended, respawning
[    3.473258] init: plymouth-upstart-bridge main process (195) terminated with status 1
[    3.477638] init: plymouth-upstart-bridge main process ended, respawning
[    3.490739] init: ureadahead main process (185) terminated with status 5
[    3.686825] Adding 1112060k swap on /dev/mmcblk0p2.  Priority:-1 extents:1 across:1112060k SSFS
[    3.862936] EXT4-fs (mmcblk0p3): re-mounted. Opts: errors=remount-ro
[    3.943606] systemd-udevd[333]: starting version 204
[    4.065057] lp: driver loaded but no devices found
[    4.093552] ppdev: user-space parallel port driver
[    4.253186] 80860F0A:00: ttyS4 at MMIO 0x90736000 (irq = 39, base_baud = 2764800) is a 16550A
[    4.302982] [Firmware Bug]: No valid trip found
[    4.317051] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8 channels
[    4.318525] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8 channels
[    4.330372] byt_gpio INT33FC:02: pin 16 cannot be used as GPIO.
[    4.452957] Bluetooth: Core ver 2.20
[    4.452997] NET: Registered protocol family 31
[    4.453002] Bluetooth: HCI device and connection manager initialized
[    4.453012] Bluetooth: HCI socket layer initialized
[    4.453020] Bluetooth: L2CAP socket layer initialized
[    4.453038] Bluetooth: SCO socket layer initialized
[    4.472412] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.472414] Bluetooth: BNEP filters: protocol multicast
[    4.472423] Bluetooth: BNEP socket layer initialized
[    4.492771] Bluetooth: RFCOMM TTY layer initialized
[    4.492789] Bluetooth: RFCOMM socket layer initialized
[    4.492802] Bluetooth: RFCOMM ver 1.11
[    4.512104] mei_txe 0000:00:1a.0: can't derive routing for PCI INT A
[    4.512113] mei_txe 0000:00:1a.0: PCI INT A: no GSI
[    4.539665] [drm] Initialized drm 1.1.0 20060810
[    4.613106] cfg80211: Calling CRDA to update world regulatory domain
[    4.615355] init: cups main process (509) killed by HUP signal
[    4.615404] init: cups main process ended, respawning
[    4.695820] [drm] Memory usable by graphics device = 2048M
[    4.695831] checking generic (80000000 7f0000) vs hw (80000000 10000000)
[    4.695836] fb: switching to inteldrmfb from EFI VGA
[    4.695944] Console: switching to colour dummy device 80x25
[    4.698905] [drm] Replacing VGA console driver
[    4.709488] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.709501] [drm] Driver supports precise vblank timestamp query.
[    4.712444] usbcore: registered new interface driver r8152
[    4.714769] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/0003:045E:0745.0001/input/input0
[    4.730710] usbcore: registered new interface driver cdc_ether
[    4.752735] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    4.754265] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    4.755997] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    4.758861] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    4.770269] hid-generic 0003:045E:0745.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input0
[    4.771393] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.1/0003:045E:0745.0002/input/input1
[    4.785972] usb 1-1.1.4: reset high-speed USB device number 5 using ehci-pci
[    4.789250] SSE version of gcm_enc/dec engaged.
[    4.821372] usbcore: registered new interface driver brcmfmac
[    4.826854] hid-generic 0003:045E:0745.0002: input,hidraw1: USB HID v1.11 Mouse [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input1
[    4.838841] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0 as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.2/0003:045E:0745.0003/input/input2
[    4.891696] intel_soc_dts_thermal: request_threaded_irq ret -22
[    4.894442] hid-generic 0003:045E:0745.0003: input,hiddev0,hidraw2: USB HID v1.11 Device [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v7.0] on usb-0000:00:1d.0-1.1.1/input2
[    4.912766] intel_rapl: Found RAPL domain package
[    4.912774] intel_rapl: Found RAPL domain core
[    4.915472] r8152 1-1.1.4:1.0 eth0: v1.07.0 (2014/10/09)
[    4.925962] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.967756] intel_soc_dts_thermal: request_threaded_irq ret -22
[    4.982466] random: nonblocking pool is initialized
[    5.027713] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    5.036233] acpi device:09: registered as cooling_device5
[    5.037254] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    5.037737] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    5.059381] input: gpio-keys as /devices/platform/gpio-keys.0.auto/input/input4
[    5.060119] input: gpio-keys as /devices/platform/gpio-keys.1.auto/input/input5
[    5.125901] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to bit banging on pin 4
[    5.133046] fbcon: inteldrmfb (fb0) is primary device
[    5.162241] brcmf_c_preinit_dcmds: Firmware version = wl0: Jan 29 2014 01:40:06 version 5.97.39.4 FWID 01-c7b9d775
[    5.162312] cfg80211: World regulatory domain updated:
[    5.162316] cfg80211:  DFS Master region: unset
[    5.162316] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.162321] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.162324] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.162326] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.162329] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.162331] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.490595] Console: switching to colour frame buffer device 240x67
[    5.504841] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.504845] i915 0000:00:02.0: registered panic notifier
[    7.437638] brcmf_sdio_bus_rxctl: resumed on timeout
[    7.456192] brcmf_add_if: ERROR: netdev:wlan0 already exists
[    7.456294] brcmf_add_if: ignore IF event
[    7.518066] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.661760] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.116680] init: failsafe main process (598) killed by TERM signal
[   10.448891] init: Failed to spawn whoopsie main process: unable to execute: No such file or directory
[   10.684775] init: lightdm main process (1021) terminated with status 127
[   10.697362] init: plymouth-ready (startup) main process (181) terminated with status 1
[   16.923917] cfg80211: Calling CRDA for country: DE
[   16.931523] cfg80211: Regulatory domain changed to country: DE
[   16.931532] cfg80211:  DFS Master region: unset
[   16.931536] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   16.931543] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   16.931548] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   16.931554] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm), (0 s)
[   16.931559] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm), (0 s)
[   16.931565] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
[   18.956035] brcmf_cfg80211_del_key: invalid key index (4)
[   18.956147] brcmf_cfg80211_del_key: invalid key index (5)
[   18.956289] cfg80211: Calling CRDA to update world regulatory domain
[   18.962909] cfg80211: World regulatory domain updated:
[   18.962918] cfg80211:  DFS Master region: unset
[   18.962922] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   18.962930] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   18.962936] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   18.962941] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[   18.962946] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   18.962951] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   21.105515] brcmf_sdio_bus_rxctl: resumed on timeout
[   21.105755] brcmf_run_escan: error (-52)
[   21.105867] brcmf_cfg80211_scan: scan error (-52)
[   31.668228] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.668338] brcmf_fweh_event_worker: event handler failed (69)
[   31.668554] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.668773] brcmf_fweh_event_worker: event handler failed (69)
[   31.668863] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.668957] brcmf_fweh_event_worker: event handler failed (69)
[   31.669047] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.669141] brcmf_fweh_event_worker: event handler failed (69)
[   31.669231] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.669325] brcmf_fweh_event_worker: event handler failed (69)
[   31.669469] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.669582] brcmf_fweh_event_worker: event handler failed (69)
[   31.670108] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.670208] brcmf_fweh_event_worker: event handler failed (69)
[   31.670459] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.670571] brcmf_fweh_event_worker: event handler failed (69)
[   31.670677] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.670814] brcmf_fweh_event_worker: event handler failed (69)
[   31.670922] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.671032] brcmf_fweh_event_worker: event handler failed (69)
[   31.671137] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.671247] brcmf_fweh_event_worker: event handler failed (69)
[   31.671352] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.671460] brcmf_fweh_event_worker: event handler failed (69)
[   31.671565] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.671674] brcmf_fweh_event_worker: event handler failed (69)
[   31.671779] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.671888] brcmf_fweh_event_worker: event handler failed (69)
[   31.671992] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.672099] brcmf_fweh_event_worker: event handler failed (69)
[   31.672176] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.672258] brcmf_fweh_event_worker: event handler failed (69)
[   31.672443] brcmf_cfg80211_escan_handler: scan not ready, bssidx=0
[   31.672515] brcmf_fweh_event_worker: event handler failed (69)
--------------040207080401090706030200
Content-Type: text/plain; charset=UTF-8;
 name="iw_list.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iw_list.txt"

# iw list
Wiphy phy0
        Band 1:
                Capabilities: 0x1020
                        HT20
                        Static SM Power Save
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 3839 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 16 usec (0x07)
                HT TX/RX MCS rate indexes supported: 0-7
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm)
                        * 2472 MHz [13] (20.0 dBm)
                        * 2484 MHz [14] (20.0 dBm)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Band 2:
                Capabilities: 0x1020
                        HT20
                        Static SM Power Save
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 3839 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 16 usec (0x07)
                HT TX/RX MCS rate indexes supported: 0-7
                Frequencies:
                        * 5170 MHz [34] (20.0 dBm)
                        * 5180 MHz [36] (20.0 dBm)
                        * 5190 MHz [38] (20.0 dBm)
                        * 5200 MHz [40] (20.0 dBm)
                        * 5210 MHz [42] (20.0 dBm)
                        * 5220 MHz [44] (20.0 dBm)
                        * 5230 MHz [46] (20.0 dBm)
                        * 5240 MHz [48] (20.0 dBm)
                        * 5260 MHz [52] (20.0 dBm)
                        * 5280 MHz [56] (20.0 dBm)
                        * 5300 MHz [60] (20.0 dBm)
                        * 5320 MHz [64] (20.0 dBm)
                        * 5500 MHz [100] (20.0 dBm)
                        * 5520 MHz [104] (20.0 dBm)
                        * 5540 MHz [108] (20.0 dBm)
                        * 5560 MHz [112] (20.0 dBm)
                        * 5580 MHz [116] (20.0 dBm)
                        * 5600 MHz [120] (20.0 dBm)
                        * 5620 MHz [124] (20.0 dBm)
                        * 5640 MHz [128] (20.0 dBm)
                        * 5660 MHz [132] (20.0 dBm)
                        * 5680 MHz [136] (20.0 dBm)
                        * 5700 MHz [140] (20.0 dBm)
                        * 5745 MHz [149] (20.0 dBm)
                        * 5765 MHz [153] (20.0 dBm)
                        * 5785 MHz [157] (20.0 dBm)
                        * 5805 MHz [161] (20.0 dBm)
                        * 5825 MHz [165] (20.0 dBm)
                        * 4920 MHz [-16] (disabled)
                        * 4940 MHz [-12] (disabled)
                        * 4960 MHz [-8] (disabled)
                        * 4980 MHz [-4] (disabled)
                        * 6000 MHz [200] (disabled)
                        * 6020 MHz [204] (disabled)
                        * 6040 MHz [208] (disabled)
                        * 6060 MHz [212] (disabled)
                        * 6080 MHz [216] (disabled)
                Bitrates (non-HT):
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 10
        max scan IEs length: 2048 bytes
        Coverage class: 0 (up to 0m)
        Supported Ciphers:
                * WEP40 (00-0f-ac:1)
                * WEP104 (00-0f-ac:5)
                * TKIP (00-0f-ac:2)
                * CCMP (00-0f-ac:4)
                * CMAC (00-0f-ac:6)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * P2P-client
                 * P2P-GO
                 * Unknown mode (10)
        software interface modes (can always be added):
        valid interface combinations:
                 * #{ IBSS, managed } <= 1, #{ AP } <= 4, #{ P2P-client, P2P-GO } <= 1, #{ Unknown mode (10) } <= 1,
                   total <= 3, #channels <= 2
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * new_beacon
                 * join_ibss
                 * set_pmksa
                 * del_pmksa
                 * flush_pmksa
                 * remain_on_channel
                 * action
                 * set_channel
                 * Unknown command (75)
                 * Unknown command (89)
                 * connect
                 * disconnect
        Supported TX frame types:
                 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * Unknown mode (10): 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
        Supported RX frame types:
                 * managed: 0x40 0xd0
                 * P2P-client: 0x40 0xd0
                 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * Unknown mode (10): 0x40 0xd0
        Device supports roaming.
--------------040207080401090706030200--
