Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server11.hostfactory.ch ([62.146.13.133]:44088 "EHLO
	server11.hostfactory.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbbGHPfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 11:35:12 -0400
Received: from [192.168.1.104] (ip5b41fe70.dynamic.kabel-deutschland.de [91.65.254.112])
	by server11.hostfactory.ch (Postfix) with ESMTPSA id C29C860206BDF
	for <linux-wireless@vger.kernel.org>; Wed,  8 Jul 2015 17:28:53 +0200 (CEST)
Message-ID: <559D41B3.4050604@weiss.ch> (sfid-20150708_173519_693963_814C5674)
Date: Wed, 08 Jul 2015 17:28:51 +0200
From: Rolf Anderegg <rolf.anderegg@weiss.ch>
Reply-To: rolf.anderegg@weiss.ch
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am having trouble with the following setup using ath9k_htc (AR9271): I
would like to setup two virtual interfaces on a TP-Link Wireless USB
adapter (TL-WN722N).

ath0: AP (access point/master mode) with hostapd [1], on bridge br0
ath1: STA (station/managed mode) with wpa_supplicant

AP works fine when STA is omitted (or wpa_supplicant is stopped). But
when I try to operate both simultaneously (on the same channel), while
the STA is up and stable, the AP can no longer hold a connection for
longer than a few seconds. The hostapd syslogs either say that
connection is dropped due to inactivity or failure to authenticate.
Also, sometimes a slowpath kernel warning is dumped [2].
Kernel version is 3.12.10-rt15 (more environment info: [3]).

When I try the same setup with a D-Link PCI card (DWL-G520) running with
ath5k, AP and STA work smoothly side by side. So I'm wondering whether
there are any known limitations or pitfalls when using virtual
interfaces with ath9k_htc?

Any hints or ideas would be greatly appreciated.
Cheers,

Rolf Anderegg




[1] hostapd.conf:
interface=ath0
bridge=br0
driver=nl80211
ssid=MAN301-0099_LAN
hw_mode=g
channel=8
auth_algs=3
wmm_enabled=1
wpa=3
wpa_psk_file=/etc/hostapd.wpa_psk
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP


[2] kernel warning:
[ 4142.857848] ------------[ cut here ]------------
[ 4142.857917] WARNING: CPU: 0 PID: 19211 at net/mac80211/agg-tx.c:699 ieee80211_start_tx_ba_cb+0xa5/0xf8 [mac80211]()
[ 4142.857970] Modules linked in: bridge stp llc ipv6 snd_seq_dummy ppdev snd_dice snd_firewire_lib snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_oss snd_seq_midi ath9k_htc snd_rawmidi ath9k_common ath9k_hw snd_seq_midi_event ath joydev snd_seq mac80211 microcode snd_seq_device snd_timer cfg80211 rfkill snd serio_raw soundcore lpc_ich mfd_core parport_pc fuse w83627hf hwmon_vid shpchp coretemp lp parport firewire_ohci ata_generic firewire_core pata_acpi r8169 mii
[ 4142.857977] CPU: 0 PID: 19211 Comm: kworker/u8:0 Tainted: G        W    3.12.10-rt15 #2
[ 4142.857980] Hardware name:                  /D510MO, BIOS MOPNV10N.86A.0516.2011.0331.1730 03/31/2011
[ 4142.858051] Workqueue: phy0 ieee80211_iface_work [mac80211]
[ 4142.858063]  00000000 00000000 f625beb8 c15dba8f 00000000 f625bed0 c102d255 f95cfb0c
[ 4142.858073]  00000000 f2e62534 f27f3ad0 f625bee0 c102d2e1 00000009 00000000 f625bf00
[ 4142.858082]  f95cfb0c f3f48c18 f2e62360 f27f3800 f26bfc80 f3f48c00 f3fb28c0 f625bf28
[ 4142.858084] Call Trace:
[ 4142.858096]  [<c15dba8f>] dump_stack+0x49/0x80
[ 4142.858104]  [<c102d255>] warn_slowpath_common+0x66/0x7d
[ 4142.858146]  [<f95cfb0c>] ? ieee80211_start_tx_ba_cb+0xa5/0xf8 [mac80211]
[ 4142.858152]  [<c102d2e1>] warn_slowpath_null+0x14/0x18
[ 4142.858192]  [<f95cfb0c>] ieee80211_start_tx_ba_cb+0xa5/0xf8 [mac80211]
[ 4142.858234]  [<f95d3183>] ieee80211_iface_work+0x99/0x253 [mac80211]
[ 4142.858243]  [<c1040112>] process_one_work+0x146/0x253
[ 4142.858249]  [<c10405ab>] worker_thread+0x137/0x1d9
[ 4142.858255]  [<c1040474>] ? rescuer_thread+0x22f/0x22f
[ 4142.858260]  [<c1044a1e>] kthread+0x74/0x79
[ 4142.858268]  [<c15e4e77>] ret_from_kernel_thread+0x1b/0x28
[ 4142.858274]  [<c10449aa>] ? __kthread_parkme+0x59/0x59
[ 4142.858289] ---[ end trace 0000000000000003 ]---


[3] environment summary:
:~$ uname -srvmpio
Linux 3.12.10-rt15 #2 SMP PREEMPT RT Tue Jun 9 16:17:55 CEST 2015 i686 i686 i686 GNU/Linux

:~$ lsusb -s 1:3
Bus 001 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271 802.11n

:~$ wpa_supplicant -v
wpa_supplicant v2.4

:~$ sudo wpa_cli status
Selected interface 'ath1'
bssid=b8:a3:86:14:d3:ee
freq=2447
ssid=Kakofon
id=0
id_str=ath1
mode=station
pairwise_cipher=CCMP
group_cipher=TKIP
key_mgmt=WPA2-PSK
wpa_state=COMPLETED
ip_address=192.168.1.102
address=c6:4a:00:1b:c2:98

:~$ hostapd -v
hostapd v2.4

:~$ sudo hostapd_cli status
Selected interface 'ath0'
state=ENABLED
phy=phy0
freq=2447
num_sta_non_erp=0
num_sta_no_short_slot_time=0
num_sta_no_short_preamble=0
olbc=0
num_sta_ht_no_gf=0
num_sta_no_ht=0
num_sta_ht_20_mhz=0
num_sta_ht40_intolerant=0
olbc_ht=0
ht_op_mode=0x0
cac_time_seconds=0
cac_time_left_seconds=N/A
channel=8
secondary_channel=0
ieee80211n=0
ieee80211ac=0
vht_oper_chwidth=0
vht_oper_centr_freq_seg0_idx=0
vht_oper_centr_freq_seg1_idx=0
bss[0]=ath0
bssid[0]=c0:4a:00:1b:c2:98
ssid[0]=MAN301-0099_LAN
num_sta[0]=0

:~$ cat /sys/module/ath9k_htc/parameters/nohwcrypt
1

:~$ lsmod | grep ath9k
ath9k_htc              46002  0
ath9k_common            2153  1 ath9k_htc
ath9k_hw              370729  2 ath9k_common,ath9k_htc
ath                    12554  3 ath9k_common,ath9k_htc,ath9k_hw
mac80211              366454  1 ath9k_htc
cfg80211              330733  3 ath,mac80211,ath9k_htc


[4]: pre/post-up commands:
Creating ath0 (preup):
iw dev wlan0 interface add ath0 type __ap

Starting hostapd (postup):
hostapd -B -P /var/run/hostapd.br_ap.pid /etc/hostapd.conf

Creating ath1 (preup):
iw dev wlan0 interface add ath1 type station
ip link set ath1 address ${ALT_HW_ADDR}

Starting wpa_supplicant (postup):
wpa_supplicant -Dnl80211 -P/var/run/wpa_supplicant.pid -c /etc/wpa_supplicant.conf -B -d -iath1


