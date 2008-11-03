Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:5314 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbYKCDOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 22:14:40 -0500
Received: by rv-out-0506.google.com with SMTP id g9so930689rvb.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 19:14:39 -0800 (PST)
Message-ID: <43075fc60811021914v39a98f8dxc52fdbfd20f2a81d@mail.gmail.com> (sfid-20081103_041449_149368_F4184EAC)
Date: Sun, 2 Nov 2008 22:14:39 -0500
From: "Iordan Iordanov" <iiordanov@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath9k driver runs out of TX descriptors
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890811021227m30231c2ega9ab1c3f0eac71d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43075fc60811012033t6fdcd1c4h2c4868659afa9ec5@mail.gmail.com>
	 <43e72e890811021227m30231c2ega9ab1c3f0eac71d6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> This is not critical and common, we were supposed to change this to a
> debug message only so you wouldn't see it. When it occurs we just tell
> the upper layers to hold its horses.

This makes sense.

> You are increasing the size the driver uses with this too, which we
> want to avoid.

Yes, I realized that, but I wanted to see if there would be a
performance increase!

> I take it you don't see any throughput performance enhancements though right?

You take it right! I didn't notice any measurable performance
increase. In fact, this leads me to something that I wanted to ask
you. When beginning to copy, I see speeds near 3.5 MB/s, which then
within a few seconds drops to about 1.7 MB/s. I wonder whether this
could be attributed to the adapter?

Also, there are several other problems, and it may be better that
re-report them in a separate report (please tell me if this is so):

1) The card has a very "difficult" time connecting to an actual draft
N device, whereas it is perfectly happy connecting to any of my G
devices. The syslog looks like this:

Nov  2 21:36:23 pancake NetworkManager: <info>  (wlan3): supplicant
interface state change: 1 -> 2.
Nov  2 21:36:23 pancake kernel: [70288.504085] wlan3: direct probe to
AP xx:xx:xx:xx:xx:xx timed out
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation (wlan3)
starting connection 'Auto wirelessnetwork'
Nov  2 21:36:49 pancake NetworkManager: <info>  (wlan3): device state
change: 3 -> 4
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) scheduled...
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) started...
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) scheduled...
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) complete.
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) starting...
Nov  2 21:36:49 pancake NetworkManager: <info>  (wlan3): device state
change: 4 -> 5
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation
(wlan3/wireless): connection 'Auto wirelessnetwork' has security, and
secrets exist.  No new secrets needed.
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: added 'ssid'
value 'wirelessnetwork'
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: added
'scan_ssid' value '1'
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: added
'key_mgmt' value 'WPA-PSK'
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: added 'psk'
value '<omitted>'
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: added 'proto'
value 'WPA RSN'
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: added
'pairwise' value 'TKIP CCMP'
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: added 'group'
value 'WEP40 WEP104 TKIP CCMP'
Nov  2 21:36:49 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) complete.
Nov  2 21:36:49 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 0
Nov  2 21:36:49 pancake NetworkManager: <info>  Config: set interface
ap_scan to 1
Nov  2 21:36:50 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 21:36:51 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 3
Nov  2 21:36:51 pancake kernel: [70316.295510] wlan3: direct probe to
AP xx:xx:xx:xx:xx:xx try 1
Nov  2 21:37:01 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 3 -> 0
Nov  2 21:37:01 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 21:37:03 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 3
Nov  2 21:37:03 pancake kernel: [70327.840433] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 21:37:03 pancake kernel: [70327.842772] wlan3: authenticated
Nov  2 21:37:03 pancake kernel: [70327.842794] wlan3: associate with
AP xx:xx:xx:xx:xx:xx
Nov  2 21:37:03 pancake kernel: [70327.847301] wlan3: RX AssocResp
from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
Nov  2 21:37:03 pancake kernel: [70327.847320] wlan3: associated
Nov  2 21:37:03 pancake kernel: [70327.863524]
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
Nov  2 21:37:03 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 3 -> 4
Nov  2 21:37:03 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 4 -> 5
Nov  2 21:37:04 pancake NetworkManager: <info>  wlan3: link timed out.
Nov  2 21:37:04 pancake avahi-daemon[4829]: Registering new address
record for fe80::21b:63ff:fe05:eb3f on wlan3.*.
Nov  2 21:37:12 pancake kernel: [70337.326206] wlan3: deauthenticated
Nov  2 21:37:12 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 5 -> 0
Nov  2 21:37:12 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 21:37:13 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 0
Nov  2 21:37:13 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2

this output encompasses a couple of attempts at connecting. Sometimes,
it gets further and asks for a DHCP address:

Nov  2 21:53:19 pancake dhclient: DHCPDISCOVER on wlan3 to
255.255.255.255 port 67 interval 7
Nov  2 21:53:26 pancake dhclient: DHCPDISCOVER on wlan3 to
255.255.255.255 port 67 interval 14
Nov  2 21:53:30 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 0
Nov  2 21:53:30 pancake kernel: [71315.364392] wlan3: No ProbeResp
from current AP xx:xx:xx:xx:xx:xx - assume out of range
Nov  2 21:53:30 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 21:53:32 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 3
Nov  2 21:53:32 pancake kernel: [71317.225312] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 21:53:32 pancake kernel: [71317.233135] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 21:53:32 pancake kernel: [71317.235406] wlan3: authenticated
Nov  2 21:53:32 pancake kernel: [71317.235425] wlan3: associate with
AP xx:xx:xx:xx:xx:xx

but it complains about "No ProbeResp". I did think about not properly
installed antennas, but here is the output of iwconfig:

wlan3     IEEE 802.11abgn  ESSID:"wirelessnetwork"
          Mode:Managed  Frequency:2.462 GHz  Access Point: xx:xx:xx:xx:xx:xx
          Bit Rate=1 Mb/s   Tx-Power=23 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Power Management:off
          Link Quality=95/100  Signal level:-63 dBm  Noise level=-106 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

and it seems like the signal is great.

Sometimes, if I am very persistent, it manages to connect. Last time
it connected, I was watching syslog and I saw some modules crashing,
so I am attaching the syslog output here:

 Nov  2 21:58:40 pancake NetworkManager: <info>  (wlan3): device state
change: 7 -> 3
Nov  2 21:58:40 pancake NetworkManager: <info>  (wlan3): deactivating
device (reason: 0).
Nov  2 21:58:40 pancake NetworkManager: <info>  wlan3: canceled DHCP
transaction, dhcp client pid 7942
Nov  2 21:58:40 pancake kernel: [71625.504154] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 21:58:40 pancake kernel: [71625.506252] wlan3: disassociating
by local choice (reason=3)
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation (wlan3)
starting connection 'Auto wirelessnetwork'
Nov  2 21:58:40 pancake NetworkManager: <info>  (wlan3): device state
change: 3 -> 4
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) scheduled...
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) started...
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) scheduled...
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation (wlan3)
Stage 1 of 5 (Device Prepare) complete.
Nov  2 21:58:40 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 7 -> 0
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) starting...
Nov  2 21:58:40 pancake NetworkManager: <info>  (wlan3): device state
change: 4 -> 5
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation
(wlan3/wireless): connection 'Auto wirelessnetwork' has security, and
secrets exist.  No new secrets needed.
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: added 'ssid'
value 'wirelessnetwork'
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: added
'scan_ssid' value '1'
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: added
'key_mgmt' value 'WPA-PSK'
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: added 'psk'
value '<omitted>'
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: added 'proto'
value 'WPA RSN'
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: added
'pairwise' value 'TKIP CCMP'
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: added 'group'
value 'WEP40 WEP104 TKIP CCMP'
Nov  2 21:58:40 pancake NetworkManager: <info>  Activation (wlan3)
Stage 2 of 5 (Device Configure) complete.
Nov  2 21:58:40 pancake NetworkManager: <info>  Config: set interface
ap_scan to 1
Nov  2 21:58:40 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 0 -> 2
Nov  2 21:58:41 pancake kernel: [71625.704170] wlan3: authenticate
with AP xx:xx:xx:xx:xx:xx
Nov  2 21:58:41 pancake kernel: [71625.706531] wlan3: authenticated
Nov  2 21:58:41 pancake kernel: [71625.706548] wlan3: associate with
AP xx:xx:xx:xx:xx:xx
Nov  2 21:58:41 pancake kernel: [71625.710811] wlan3: RX AssocResp
from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=1)
Nov  2 21:58:41 pancake kernel: [71625.710830] wlan3: associated
Nov  2 21:58:41 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 2 -> 4
Nov  2 21:58:42 pancake kernel: [71627.196779] ------------[ cut here
]------------
Nov  2 21:58:42 pancake kernel: [71627.196797] WARNING: at
/usr/src/compat-wireless-2008-10-31/include/net/mac80211.h:1959
ath_get_rate+0xff/0x9a0 [ath9k]()
Nov  2 21:58:42 pancake kernel: [71627.196804] Modules linked in:
ath9k gspca_sunplus gspca_main videodev v4l1_compat mac80211 cfg80211
nfs lockd nfs_acl sunrpc aes_i586 aes_generic i915 drm af_packet
rfkill_input binfmt_misc rfcomm sco bridge stp bnep l2cap ppdev
acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_userspace
cpufreq_conservative cpufreq_stats freq_table pci_slot container sbs
sbshc iptable_filter ip_tables x_tables ipv6 sbp2 parport_pc lp
parport loop joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy arc4 ecb snd_seq_oss crypto_blkcipher rfkill iTCO_wdt
psmouse iTCO_vendor_support dcdbas led_class evdev serio_raw btusb
snd_seq_midi snd_rawmidi pcspkr bluetooth snd_seq_midi_event snd_seq
snd_timer snd_seq_device sdhci_pci sdhci video output mmc_core wmi
yenta_socket rsrc_nonstatic pcmcia_core ac button battery snd
intel_agp shpchp agpgart pci_hotplug soundcore snd_page_alloc ext3 jbd
mbcache sd_mod crc_t10dif sg ata_generic pata_acpi ohci1394 uhci_hcd
ieee1394 ata_piix ehci
Nov  2 21:58:42 pancake kernel: hcd libata scsi_mod usbcore tg3 libphy
dock thermal processor fan fbcon tileblit font bitblit softcursor fuse
[last unloaded: ath9k]
Nov  2 21:58:42 pancake kernel: [71627.197093] Pid: 5476, comm:
wpa_supplicant Tainted: G        W 2.6.27-7-generic #1
Nov  2 21:58:42 pancake kernel: [71627.197105]  [<c037c406>] ? printk+0x1d/0x1f
Nov  2 21:58:42 pancake kernel: [71627.197123]  [<c0131de9>]
warn_on_slowpath+0x59/0x90
Nov  2 21:58:42 pancake kernel: [71627.197141]  [<c0122fda>] ?
__dequeue_entity+0x2a/0xb0
Nov  2 21:58:42 pancake kernel: [71627.197151]  [<c0123215>] ?
dequeue_entity+0x15/0x180
Nov  2 21:58:42 pancake kernel: [71627.197164]  [<c0123186>] ?
set_next_entity+0x126/0x160
Nov  2 21:58:42 pancake kernel: [71627.197177]  [<c0102df6>] ?
__switch_to+0xa6/0x160
Nov  2 21:58:42 pancake kernel: [71627.197189]  [<c01284cb>] ?
finish_task_switch+0x2b/0xe0
Nov  2 21:58:42 pancake kernel: [71627.197201]  [<c037c999>] ?
schedule+0x429/0x790
Nov  2 21:58:42 pancake kernel: [71627.197215]  [<c012a21e>] ?
resched_task+0x1e/0x70
Nov  2 21:58:42 pancake kernel: [71627.197226]  [<c012ad55>] ?
check_preempt_wakeup+0x175/0x1b0
Nov  2 21:58:42 pancake kernel: [71627.197239]  [<f8bfbd4f>]
ath_get_rate+0xff/0x9a0 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.197263]  [<c013c749>] ?
del_timer_sync+0x19/0x20
Nov  2 21:58:42 pancake kernel: [71627.197277]  [<c011282b>] ?
native_send_call_func_single_ipi+0x2b/0x30
Nov  2 21:58:42 pancake kernel: [71627.197290]  [<c0157869>] ?
generic_exec_single+0x89/0x90
Nov  2 21:58:42 pancake kernel: [71627.197306]  [<f8c81a4d>]
rate_control_get_rate+0xbd/0xd0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197340]  [<f8c889c0>]
invoke_tx_handlers+0x4d0/0xdf0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197373]  [<c012a260>] ?
resched_task+0x60/0x70
Nov  2 21:58:42 pancake kernel: [71627.197384]  [<c02eb2f8>] ?
skb_release_data+0x68/0xa0
Nov  2 21:58:42 pancake kernel: [71627.197398]  [<f8c8a928>] ?
ieee80211_hdrlen+0x8/0x80 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197430]  [<f8c87212>] ?
__ieee80211_tx_prepare+0x172/0x2f0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197462]  [<f8c899db>]
ieee80211_master_start_xmit+0x1eb/0x4a0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197495]  [<c0191616>] ?
__mod_zone_page_state+0x16/0x90
Nov  2 21:58:42 pancake kernel: [71627.197513]  [<c02f347b>]
dev_hard_start_xmit+0x16b/0x1c0
Nov  2 21:58:42 pancake kernel: [71627.197526]  [<c01ac6ee>] ?
__slab_alloc+0xe/0x260
Nov  2 21:58:42 pancake kernel: [71627.197538]  [<c03058b5>]
__qdisc_run+0x1b5/0x200
Nov  2 21:58:42 pancake kernel: [71627.197550]  [<c02f53b7>]
dev_queue_xmit+0x2e7/0x3f0
Nov  2 21:58:42 pancake kernel: [71627.197560]  [<c02eb872>] ?
__alloc_skb+0x52/0x110
Nov  2 21:58:42 pancake kernel: [71627.197572]  [<f8c8b204>]
ieee80211_tx_skb+0x54/0x60 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197604]  [<f8c7b00f>]
ieee80211_send_delba+0xff/0x140 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197632]  [<f8bf2fb0>] ?
ath9k_ampdu_action+0x0/0x1a0 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.197656]  [<f8c7bb85>]
ieee80211_sta_stop_rx_ba_session+0x165/0x190 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197686]  [<f8c7bcd8>]
ieee80211_sta_tear_down_BA_sessions+0x48/0x60 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197715]  [<f8c7cfa8>]
ieee80211_set_disassoc+0xa8/0x1a0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197743]  [<f8c7d22b>]
ieee80211_sta_req_auth+0x8b/0x90 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197770]  [<f8c76595>]
ieee80211_ioctl_siwgenie+0x85/0x90 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197801]  [<c0369c4f>]
ioctl_standard_iw_point+0xef/0x290
Nov  2 21:58:42 pancake kernel: [71627.197813]  [<c036941f>] ?
wireless_send_event+0x15f/0x230
Nov  2 21:58:42 pancake kernel: [71627.197825]  [<f8c8190a>] ?
ieee80211_if_change_type+0x1a/0xa0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197859]  [<c0369ece>]
ioctl_standard_call+0xde/0x110
Nov  2 21:58:42 pancake kernel: [71627.197873]  [<f8c76510>] ?
ieee80211_ioctl_siwgenie+0x0/0x90 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197900]  [<c02f23d5>] ?
__dev_get_by_name+0x85/0xb0
Nov  2 21:58:42 pancake kernel: [71627.197913]  [<c036971e>]
wireless_process_ioctl+0xbe/0x150
Nov  2 21:58:42 pancake kernel: [71627.197924]  [<f8c76510>] ?
ieee80211_ioctl_siwgenie+0x0/0x90 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.197951]  [<c037d430>] ?
mutex_lock+0x10/0x20
Nov  2 21:58:42 pancake kernel: [71627.197962]  [<c0369820>]
wext_handle_ioctl+0x70/0xe0
Nov  2 21:58:42 pancake kernel: [71627.197973]  [<c0369df0>] ?
ioctl_standard_call+0x0/0x110
Nov  2 21:58:42 pancake kernel: [71627.197983]  [<c03699e0>] ?
ioctl_private_call+0x0/0x180
Nov  2 21:58:42 pancake kernel: [71627.197996]  [<c02f452f>]
dev_ioctl+0x45f/0x520
Nov  2 21:58:42 pancake kernel: [71627.198007]  [<c0213664>] ?
security_file_permission+0x14/0x20
Nov  2 21:58:42 pancake kernel: [71627.198019]  [<c02e4b50>] ?
sock_ioctl+0x0/0x250
Nov  2 21:58:42 pancake kernel: [71627.198031]  [<c02e4c45>]
sock_ioctl+0xf5/0x250
Nov  2 21:58:42 pancake kernel: [71627.198041]  [<c02e4b50>] ?
sock_ioctl+0x0/0x250
Nov  2 21:58:42 pancake kernel: [71627.198051]  [<c01bee9d>] vfs_ioctl+0x2d/0x90
Nov  2 21:58:42 pancake kernel: [71627.198064]  [<c01bf086>]
do_vfs_ioctl+0x66/0x1f0
Nov  2 21:58:42 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 4 -> 3
Nov  2 21:58:42 pancake kernel: [71627.198073]  [<c02147d8>] ?
cap_file_ioctl+0x8/0x10
Nov  2 21:58:42 pancake kernel: [71627.198086]  [<c01bf27b>] sys_ioctl+0x6b/0x70
Nov  2 21:58:42 pancake kernel: [71627.198094]  [<c0103f7b>]
sysenter_do_call+0x12/0x2f
Nov  2 21:58:42 pancake kernel: [71627.198104]  =======================
Nov  2 21:58:42 pancake kernel: [71627.198109] ---[ end trace
a64ed0740ee7a1a4 ]---
Nov  2 21:58:42 pancake kernel: [71627.198220] ------------[ cut here
]------------
Nov  2 21:58:42 pancake kernel: [71627.198230] WARNING: at
/usr/src/compat-wireless-2008-10-31/include/net/mac80211.h:1959
ath_get_rate+0xff/0x9a0 [ath9k]()
Nov  2 21:58:42 pancake kernel: [71627.198242] Modules linked in:
ath9k gspca_sunplus gspca_main videodev v4l1_compat mac80211 cfg80211
nfs lockd nfs_acl sunrpc aes_i586 aes_generic i915 drm af_packet
rfkill_input binfmt_misc rfcomm sco bridge stp bnep l2cap ppdev
acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_userspace
cpufreq_conservative cpufreq_stats freq_table pci_slot container sbs
sbshc iptable_filter ip_tables x_tables ipv6 sbp2 parport_pc lp
parport loop joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy arc4 ecb snd_seq_oss crypto_blkcipher rfkill iTCO_wdt
psmouse iTCO_vendor_support dcdbas led_class evdev serio_raw btusb
snd_seq_midi snd_rawmidi pcspkr bluetooth snd_seq_midi_event snd_seq
snd_timer snd_seq_device sdhci_pci sdhci video output mmc_core wmi
yenta_socket rsrc_nonstatic pcmcia_core ac button battery snd
intel_agp shpchp agpgart pci_hotplug soundcore snd_page_alloc ext3 jbd
mbcache sd_mod crc_t10dif sg ata_generic pata_acpi ohci1394 uhci_hcd
ieee1394 ata_piix ehci
Nov  2 21:58:42 pancake kernel: hcd libata scsi_mod usbcore tg3 libphy
dock thermal processor fan fbcon tileblit font bitblit softcursor fuse
[last unloaded: ath9k]
Nov  2 21:58:42 pancake kernel: [71627.198527] Pid: 5476, comm:
wpa_supplicant Tainted: G        W 2.6.27-7-generic #1
Nov  2 21:58:42 pancake kernel: [71627.198537]  [<c037c406>] ? printk+0x1d/0x1f
Nov  2 21:58:42 pancake kernel: [71627.198548]  [<c0131de9>]
warn_on_slowpath+0x59/0x90
Nov  2 21:58:42 pancake kernel: [71627.198566]  [<f8bf7495>] ?
ath_buf_set_rate+0x4f5/0x6a0 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.198594]  [<f8bdf9d5>] ?
ath9k_hw_txstart+0x35/0x60 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.198616]  [<f8bf76bd>] ?
ath_tx_txqaddbuf+0x7d/0x140 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.198642]  [<f8bfbd4f>]
ath_get_rate+0xff/0x9a0 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.198666]  [<f8bfc684>] ?
ath_node_get+0x14/0xa0 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.198691]  [<f8bf7fd4>] ?
ath_tx_start+0x64/0x70 [ath9k]
Nov  2 21:58:42 pancake kernel: [71627.198719]  [<f8c81a4d>]
rate_control_get_rate+0xbd/0xd0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.198754]  [<f8c889c0>]
invoke_tx_handlers+0x4d0/0xdf0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.198784]  [<c02eb2f8>] ?
skb_release_data+0x68/0xa0
Nov  2 21:58:42 pancake kernel: [71627.198797]  [<f8c8a928>] ?
ieee80211_hdrlen+0x8/0x80 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.198829]  [<f8c87212>] ?
__ieee80211_tx_prepare+0x172/0x2f0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.198863]  [<f8c899db>]
ieee80211_master_start_xmit+0x1eb/0x4a0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.198895]  [<c01ac6ee>] ?
__slab_alloc+0xe/0x260
Nov  2 21:58:42 pancake kernel: [71627.198908]  [<c02f347b>]
dev_hard_start_xmit+0x16b/0x1c0
Nov  2 21:58:42 pancake kernel: [71627.198919]  [<c03058b5>]
__qdisc_run+0x1b5/0x200
Nov  2 21:58:42 pancake kernel: [71627.198931]  [<c02f53b7>]
dev_queue_xmit+0x2e7/0x3f0
Nov  2 21:58:42 pancake kernel: [71627.198941]  [<c02eb872>] ?
__alloc_skb+0x52/0x110
Nov  2 21:58:42 pancake kernel: [71627.198953]  [<f8c8b204>]
ieee80211_tx_skb+0x54/0x60 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.198986]  [<f8c7ced6>]
ieee80211_send_deauth_disassoc+0xc6/0xf0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.199014]  [<f8c7bcd8>] ?
ieee80211_sta_tear_down_BA_sessions+0x48/0x60 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.199045]  [<f8c7cfc8>]
ieee80211_set_disassoc+0xc8/0x1a0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.199073]  [<f8c7d22b>]
ieee80211_sta_req_auth+0x8b/0x90 [mac80211]
Nov  2 21:58:42 pancake NetworkManager: <info>  (wlan3): supplicant
connection state change: 3 -> 0
Nov  2 21:58:42 pancake kernel: [71627.199100]  [<f8c76595>]
ieee80211_ioctl_siwgenie+0x85/0x90 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.199129]  [<c0369c4f>]
ioctl_standard_iw_point+0xef/0x290
Nov  2 21:58:42 pancake kernel: [71627.199143]  [<c036941f>] ?
wireless_send_event+0x15f/0x230
Nov  2 21:58:42 pancake kernel: [71627.199154]  [<f8c8190a>] ?
ieee80211_if_change_type+0x1a/0xa0 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.199187]  [<c0369ece>]
ioctl_standard_call+0xde/0x110
Nov  2 21:58:42 pancake kernel: [71627.199199]  [<f8c76510>] ?
ieee80211_ioctl_siwgenie+0x0/0x90 [mac80211]
Nov  2 21:58:42 pancake kernel: [71627.199226]  [<c02f23d5>] ?
__dev_get_by_name+0x85/0xb0
Nov  2 21:58:42 pancake kernel: [71627.199238]  [<c036971e>]
wireless_process_ioctl+0xbe/0x150
s network 'wirelessnetwork'.
Nov  2 21:58:43 pancake NetworkManager: <info>  Activation (wlan3)
Stage 3 of 5 (IP Configure Start) scheduled.
Nov  2 21:58:43 pancake NetworkManager: <info>  Activation (wlan3)
Stage 3 of 5 (IP Configure Start) started...
Nov  2 21:58:43 pancake NetworkManager: <info>  (wlan3): device state
change: 5 -> 7
Nov  2 21:58:43 pancake NetworkManager: <info>  Activation (wlan3)
Beginning DHCP transaction.
Nov  2 21:58:43 pancake dhclient: Internet Systems Consortium DHCP Client V3.1.1
Nov  2 21:58:43 pancake dhclient: Copyright 2004-2008 Internet Systems
Consortium.
Nov  2 21:58:43 pancake dhclient: All rights reserved.
Nov  2 21:58:43 pancake dhclient: For info, please visit
http://www.isc.org/sw/dhcp/
Nov  2 21:58:43 pancake dhclient:
Nov  2 21:58:43 pancake dhclient: wmaster0: unknown hardware address type 801
Nov  2 21:58:43 pancake NetworkManager: <info>  dhclient started with pid 7970
Nov  2 21:58:43 pancake NetworkManager: <info>  Activation (wlan3)
Stage 3 of 5 (IP Configure Start) complete.
Nov  2 21:58:43 pancake NetworkManager: <info>  DHCP: device wlan3
state changed normal exit -> preinit
Nov  2 21:58:43 pancake dhclient: wmaster0: unknown hardware address type 801
Nov  2 21:58:43 pancake dhclient: Listening on LPF/wlan3/xx:xx:xx:xx:xx:xx
Nov  2 21:58:43 pancake dhclient: Sending on   LPF/wlan3/xx:xx:xx:xx:xx:xx
Nov  2 21:58:43 pancake dhclient: Sending on   Socket/fallback
Nov  2 21:58:46 pancake dhclient: DHCPDISCOVER on wlan3 to
255.255.255.255 port 67 interval 3
Nov  2 21:58:49 pancake dhclient: DHCPDISCOVER on wlan3 to
255.255.255.255 port 67 interval 6
Nov  2 21:58:55 pancake dhclient: DHCPDISCOVER on wlan3 to
255.255.255.255 port 67 interval 15
Nov  2 21:58:55 pancake dhclient: DHCPOFFER of 192.168.2.198 from 192.168.2.1
Nov  2 21:58:55 pancake dhclient: DHCPREQUEST of 192.168.2.198 on
wlan3 to 255.255.255.255 port 67
Nov  2 21:58:55 pancake dhclient: DHCPACK of 192.168.2.198 from 192.168.2.1
Nov  2 21:58:55 pancake NetworkManager: <info>  DHCP: device wlan3
state changed preinit -> bound
Nov  2 21:58:55 pancake NetworkManager: <info>  Activation (wlan3)
Stage 4 of 5 (IP Configure Get) scheduled...
Nov  2 21:58:55 pancake NetworkManager: <info>  Activation (wlan3)
Stage 4 of 5 (IP Configure Get) started...
Nov  2 21:58:55 pancake dhclient: bound to 192.168.2.198 -- renewal in
42289 seconds.
Nov  2 21:58:55 pancake NetworkManager: <info>    address 192.168.2.198
Nov  2 21:58:55 pancake NetworkManager: <info>    prefix 24 (255.255.255.0)
Nov  2 21:58:55 pancake NetworkManager: <info>    gateway 192.168.2.1
Nov  2 21:58:55 pancake NetworkManager: <info>    hostname 'pancake'
Nov  2 21:58:55 pancake NetworkManager: <info>    nameserver '192.168.2.1'
Nov  2 21:58:55 pancake NetworkManager: <info>    domain name
'dancho.no-ip.com'
Nov  2 21:58:55 pancake NetworkManager: <info>  Activation (wlan3)
Stage 5 of 5 (IP Configure Commit) scheduled...
Nov  2 21:58:55 pancake NetworkManager: <info>  Activation (wlan3)
Stage 4 of 5 (IP Configure Get) complete.
Nov  2 21:58:55 pancake NetworkManager: <info>  Activation (wlan3)
Stage 5 of 5 (IP Configure Commit) started...
Nov  2 21:58:55 pancake avahi-daemon[4829]: Joining mDNS multicast
group on interface wlan3.IPv4 with address 192.168.2.198.
Nov  2 21:58:55 pancake avahi-daemon[4829]: New relevant interface
wlan3.IPv4 for mDNS.
Nov  2 21:58:55 pancake avahi-daemon[4829]: Registering new address
record for 192.168.2.198 on wlan3.IPv4.
Nov  2 21:58:56 pancake NetworkManager: <info>  (wlan3): device state
change: 7 -> 8
Nov  2 21:58:56 pancake NetworkManager: <debug> [1225681136.040808]
periodic_update(): Roamed from BSSID xx:xx:xx:xx:xx:xx
(wirelessnetwork) to xx:xx:xx:xx:xx:xx (wirelessnetwork)
Nov  2 21:58:56 pancake NetworkManager: <info>  Policy set 'Auto
wirelessnetwork' (wlan3) as default for routing and DNS.
Nov  2 21:58:56 pancake NetworkManager: <info>  Activation (wlan3)
successful, device activated.
Nov  2 21:58:56 pancake NetworkManager: <info>  Activation (wlan3)
Stage 5 of 5 (IP Configure Commit) complete.
Nov  2 21:59:00 pancake ntpdate[8034]: adjust time server 91.189.94.4
offset 0.022458 sec

2) When the card does succeed to connect to an actual draft N device
(wrt350n running dd-wrt), it does make between 5 and 6 MB/s, but then
stalls for extended periods of time, during which there is no special
output in dmesg, syslog (for NetworkManager).

Nothing is pingable, there is absolutely no traffic between the
adapter and the access point.

Usually, all the logs are awfully quiet for a while, and sometimes it
unstalls, and continues to copy, or it reports "No ProbeResp" and
disconnects and tries to reconnect. I haven't been able to transfer
more than 130MB without a stall, although once I establish a working
connection and I don't load it heavily, I am able to browse the
Internet and do small tasks without instigating a stall.

> 11n Atheros devices begin on AR9xxx, AR5416 and AR5008 (although I
> think this is just mislabeled and should be AR5416) are the first
> generation 11n devices and escaped the new nomenclature.

Thanks for the info, and very many thanks for any help with this!
Please let me know how I can be of help with any further debugging!

Cheers,
Iordan Iordanov


-- 
The conscious mind has only one thread of execution.
