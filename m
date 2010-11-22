Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:33002 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab0KVDax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 22:30:53 -0500
Date: Sun, 21 Nov 2010 22:42:08 -0400
From: Giacomo Comes <comes@naic.edu>
To: linux-wireless@vger.kernel.org
Subject: orinoco_cs module and WPA not working
Message-ID: <20101122024208.GA13377@monopoli.naic.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm having trouble with a wireless card using the orinoco driver.

The card is (pccardctl ident output):

Socket 2:
  product info: "Dell", "TrueMobile 1150 Series PC Card", "Version 01.01", ""
  manfid: 0x0156, 0x0002
  function: 6 (network)

I'm running suse 11.3 with kernel 2.6.34.7

dmesg output shows that the card is supported by the orinoco_cs kernel module:

[   14.239886] pcmcia_socket pcmcia_socket1: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xf0000-0xfffff
[   14.241156] pcmcia_socket pcmcia_socket1: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   14.241409] pcmcia_socket pcmcia_socket1: cs: memory probe 0x60000000-0x60ffffff: clean.
[   14.269111] pcmcia_socket pcmcia_socket2: pccard: PCMCIA card inserted into slot 2
[   14.269128] pcmcia_socket pcmcia_socket2: cs: memory probe 0x0d0000-0x0effff:
[   14.295349] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[5b4fc0003fffffff]
[   14.320737]  excluding 0xe0000-0xeffff
[   14.320758] pcmcia_socket pcmcia_socket2: cs: memory probe 0x60000000-0x60ffffff: clean.
[   14.332530] pcmcia_socket pcmcia_socket2: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   14.344344] pcmcia_socket pcmcia_socket2: cs: memory probe 0xf9800000-0xfbffffff: excluding 0xf9f80000-0xfa1fffff 0xfae80000-0xfb0fffff
[   14.355136] pcmcia 2.0: pcmcia: registering new device pcmcia2.0
[   14.431345] cfg80211: Calling CRDA to update world regulatory domain
[   14.476321] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   14.494755] cfg80211: World regulatory domain updated:
[   14.494766]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.494775]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.494783]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.494791]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.494798]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.494806]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.498825] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   14.587767] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
[   14.587897] orinoco_cs 2.0: Station identity  001f:0001:0008:000a
[   14.587906] orinoco_cs 2.0: Firmware determined as Lucent/Agere 8.10
[   14.587915] orinoco_cs 2.0: firmware: requesting agere_sta_fw.bin
[   14.698324] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
[   14.698457] orinoco_cs 2.0: Station identity  001f:0002:0009:0030
[   14.698466] orinoco_cs 2.0: Firmware determined as Lucent/Agere 9.48
[   14.698472] orinoco_cs 2.0: Ad-hoc demo mode supported
[   14.698478] orinoco_cs 2.0: IEEE standard IBSS ad-hoc mode supported
[   14.698483] orinoco_cs 2.0: WEP supported, 104-bit key
[   14.698489] orinoco_cs 2.0: WPA-PSK supported
[...]
[   32.967560] ADDRCONF(NETDEV_UP): eth1: link is not ready


NetworkManager is not able to connect to an AP and /var/log/messages contains:

Nov 12 18:55:22 rescue kernel: [  388.982388] ------------[ cut here ]------------
Nov 12 18:55:22 rescue kernel: [  388.982427] WARNING: at /usr/src/packages/BUILD/kernel-desktop-2.6.34.7/linux-2.6.34/net/wireless/core.c:633 wdev_cleanup_work+0xb7/0xe0 [cfg80211]()
Nov 12 18:55:22 rescue kernel: [  388.982432] Hardware name: Latitude C840                   
Nov 12 18:55:22 rescue kernel: [  388.982435] Modules linked in: fuse ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd cpufreq_conservative cpufreq_userspace cpufreq_powersave speedstep_ich speedstep_lib mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables loop dm_mod michael_mic orinoco_cs orinoco cfg80211 rfkill firewire_ohci firewire_core snd_intel8x0m pcmcia crc_itu_t snd_intel8x0 snd_ac97_codec ppdev ac97_bus iTCO_wdt sr_mod snd_pcm parport_pc ohci1394 yenta_socket rsrc_nonstatic dcdbas pcmcia_core ieee1394 3c59x video parport floppy snd_timer sg cdrom iTCO_vendor_support snd battery ac pcspkr joydev soundcore snd_page_alloc shpchp pci_hotplug ext4 jbd2 crc16 nouveau ttm drm_kms_helper drm i2c_algo_bit button intel_agp fan processor ata_generic thermal thermal_sys 
Nov 12 18:55:22 rescue kernel: [  388.982543] Pid: 707, comm: cfg80211 Not tainted 2.6.34.7-0.5-desktop #1
Nov 12 18:55:22 rescue kernel: [  388.982546] Call Trace:
Nov 12 18:55:22 rescue kernel: [  388.982570]  [<c02065c3>] try_stack_unwind+0x173/0x190
Nov 12 18:55:22 rescue kernel: [  388.982580]  [<c02051cf>] dump_trace+0x3f/0xe0
Nov 12 18:55:22 rescue kernel: [  388.982589]  [<c020662b>] show_trace_log_lvl+0x4b/0x60
Nov 12 18:55:22 rescue kernel: [  388.982595]  [<c0206658>] show_trace+0x18/0x20
Nov 12 18:55:22 rescue kernel: [  388.982607]  [<c064e0b3>] dump_stack+0x6d/0x72
Nov 12 18:55:22 rescue kernel: [  388.982616]  [<c02443ae>] warn_slowpath_common+0x6e/0xb0
Nov 12 18:55:22 rescue kernel: [  388.982623]  [<c0244403>] warn_slowpath_null+0x13/0x20
Nov 12 18:55:22 rescue kernel: [  388.982635]  [<e2db5497>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
Nov 12 18:55:22 rescue kernel: [  388.982657]  [<c025cfa9>] run_workqueue+0x79/0x170
Nov 12 18:55:22 rescue kernel: [  388.982665]  [<c025d123>] worker_thread+0x83/0xe0
Nov 12 18:55:22 rescue kernel: [  388.982673]  [<c025fef4>] kthread+0x74/0x80
Nov 12 18:55:22 rescue kernel: [  388.982681]  [<c0203826>] kernel_thread_helper+0x6/0x10
Nov 12 18:55:22 rescue kernel: [  388.982688] ---[ end trace 3f0348b3b0c6f4ff ]---
Nov 12 18:55:25 rescue dhcpcd[6700]: eth1: dhcpcd not running


Instead of using NetworkManager, I tryed the wireless connection using
the traditional method with ifup. This time /var/log/messages contains:


Nov 14 21:30:22 rescue ifdown:     eth1      device: Dell
Nov 14 21:30:22 rescue ifdown: TrueMobile 1150 Series PC Card
Nov 14 21:30:22 rescue ifdown: Version 01.01
Nov 14 21:30:22 rescue dhcpcd[10496]: eth1: sending signal 15 to pid 4944
Nov 14 21:30:22 rescue dhcpcd[4944]: eth1: received SIGTERM, stopping
Nov 14 21:30:22 rescue dhcpcd[4944]: eth1: removing IP address 192.168.16.100/24
Nov 14 21:30:22 rescue dhcpcd[10496]: eth1: exiting
Nov 14 21:30:23 rescue dhcpcd[4944]: eth1: exiting
Nov 14 21:30:24 rescue kernel: [  841.364442] ------------[ cut here ]------------
Nov 14 21:30:24 rescue kernel: [  841.364481] WARNING: at /usr/src/packages/BUILD/kernel-desktop-2.6.34.7/linux-2.6.34/net/wireless/core.c:633 wdev_cleanup_work+0xb7/0xe0 [cfg80211]()
Nov 14 21:30:24 rescue kernel: [  841.364489] Hardware name: Latitude C840                   
Nov 14 21:30:24 rescue kernel: [  841.364494] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave speedstep_ich speedstep_lib mperf loop dm_mod michael_mic orinoco_cs orinoco cfg80211 rfkill firewire_ohci snd_intel8x0 firewire_core snd_intel8x0m snd_ac97_codec crc_itu_t pcmcia ppdev iTCO_wdt ac97_bus snd_pcm parport_pc sr_mod ohci1394 yenta_socket 3c59x rsrc_nonstatic pcmcia_core ieee1394 dcdbas sg cdrom video parport floppy snd_timer snd shpchp iTCO_vendor_support battery ac pcspkr joydev soundcore snd_page_alloc pci_hotplug ext4 jbd2 crc16 nouveau ttm drm_kms_helper drm i2c_algo_bit button intel_agp fan processor ata_generic thermal thermal_sys [last unloaded: preloadtrace]
Nov 14 21:30:24 rescue kernel: [  841.364635] Pid: 732, comm: cfg80211 Not tainted 2.6.34.7-0.5-desktop #1
Nov 14 21:30:24 rescue kernel: [  841.364641] Call Trace:
Nov 14 21:30:24 rescue kernel: [  841.364673]  [<c02065c3>] try_stack_unwind+0x173/0x190
Nov 14 21:30:24 rescue kernel: [  841.364689]  [<c02051cf>] dump_trace+0x3f/0xe0
Nov 14 21:30:24 rescue kernel: [  841.364703]  [<c020662b>] show_trace_log_lvl+0x4b/0x60
Nov 14 21:30:24 rescue kernel: [  841.364715]  [<c0206658>] show_trace+0x18/0x20
Nov 14 21:30:24 rescue kernel: [  841.364732]  [<c064e0b3>] dump_stack+0x6d/0x72
Nov 14 21:30:24 rescue kernel: [  841.364746]  [<c02443ae>] warn_slowpath_common+0x6e/0xb0
Nov 14 21:30:24 rescue kernel: [  841.364759]  [<c0244403>] warn_slowpath_null+0x13/0x20
Nov 14 21:30:24 rescue kernel: [  841.364778]  [<e2d9b497>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
Nov 14 21:30:24 rescue kernel: [  841.364807]  [<c025cfa9>] run_workqueue+0x79/0x170
Nov 14 21:30:24 rescue kernel: [  841.364822]  [<c025d123>] worker_thread+0x83/0xe0
Nov 14 21:30:24 rescue kernel: [  841.364835]  [<c025fef4>] kthread+0x74/0x80
Nov 14 21:30:24 rescue kernel: [  841.364848]  [<c0203826>] kernel_thread_helper+0x6/0x10
Nov 14 21:30:24 rescue kernel: [  841.364859] ---[ end trace 86f247bee785359d ]---
Nov 14 21:31:09 rescue kernel: [   26.546538] powernow: This module only works with AMD K7 CPUs

Nov 14 21:31:21 rescue ifup:     eth1      device: Dell
Nov 14 21:31:21 rescue ifup: TrueMobile 1150 Series PC Card
Nov 14 21:31:21 rescue ifup: Version 01.01
Nov 14 21:31:21 rescue ifup:     eth1      is controlled by ifplugd
Nov 14 21:31:21 rescue ifup:     eth1      device: Dell
Nov 14 21:31:21 rescue ifup: TrueMobile 1150 Series PC Card
Nov 14 21:31:21 rescue ifup: Version 01.01
Nov 14 21:31:21 rescue ifup-wireless:     eth1      warning: WPA configured, but is untested
Nov 14 21:31:21 rescue ifup-wireless:     eth1      warning: with this device
Nov 14 21:31:21 rescue ifup-wireless:     eth1      starting wpa_supplicant
Nov 14 21:31:21 rescue kernel: [   39.199513] ADDRCONF(NETDEV_UP): eth1: link is not ready
Nov 14 21:31:22 rescue ifup-dhcp: Starting DHCP4 client on eth1
Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: dhcpcd 3.2.3 starting
Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: hardware address = 00:02:2d:70:31:3b
Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: broadcasting for a lease
Nov 14 21:31:22 rescue ifup-dhcp: . 
Nov 14 21:31:25 rescue ifup-dhcp: . 
Nov 14 21:31:28 rescue ifup-dhcp: . 
Nov 14 21:31:31 rescue ifup-dhcp: . 
Nov 14 21:31:33 rescue ifup-dhcp: . 
Nov 14 21:31:36 rescue ifup-dhcp: . 
Nov 14 21:31:39 rescue ifup-dhcp: . 
Nov 14 21:31:42 rescue ifup-dhcp: . 
Nov 14 21:31:42 rescue dhcpcd[3584]: eth1: timed out
Nov 14 21:31:42 rescue dhcpcd[3584]: eth1: trying to use old lease in `/var/lib/dhcpcd/dhcpcd-eth1.info'
Nov 14 21:31:42 rescue dhcpcd[3584]: eth1: adding IP address 192.168.16.100/24
Nov 14 21:31:42 rescue dhcpcd[3584]: eth1: adding default route via 192.168.16.1 metric 0

Nov 14 21:31:43 rescue ifup-dhcp:  
Nov 14 21:31:43 rescue ifup-dhcp:     eth1      DHCP4 continues in background
Nov 14 21:31:43 rescue ifdown:     eth1      device: Dell
Nov 14 21:31:43 rescue ifdown: TrueMobile 1150 Series PC Card
Nov 14 21:31:43 rescue ifdown: Version 01.01
Nov 14 21:31:44 rescue ifup:     eth1      device: Dell
Nov 14 21:31:44 rescue ifup: TrueMobile 1150 Series PC Card
Nov 14 21:31:44 rescue ifup: Version 01.01
Nov 14 21:31:44 rescue dhcpcd[3584]: eth1: exiting

It first tryes to connect to an AP using WPA, but it fails.
Thereafter it connects to a second AP using WEP.

If I use the traditional method with ifup, I can use the card with WEP
but not WPA. With NetworkManager I cannot even connect using WEP.

I have also used the latest compat-wireless tarball configured with
the options:
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_VERBOSE_DEBUG=y

but it didn't make any difference.

My question is: 
Does orinoco_cs really support WPA or not?
Is the problem really with the orinoco_cs module or with something else
(may be wpa_supplicant)?

Another issue I have with the the orinoco_cs module is the following:
During suspend and resume there is a two minutes timeout period.

More precisely, after I start to suspend the laptop the screen
goes black, the message 
             s2disk: snapshotting the system 
appears and then there is a two minutes period where the screen stays black
and nothing happens. After the two minutes, the messages snapshot ready
appears, the snapshot image is saved to the disk and the laptop turns off.
On resume, the kernel founds the snapshot image, loads it and then
stays two minutes doing nothing. After the two minutes, the text
                 s2disk: returned to userspace
appears on screen, there is some disk activity and then the sistem is back.

If I blacklist the orinoco_cs module, then suspend and resume work properly.

I have no idea if the two problems are related or not. If any of the issues 
has been already discussed, please point me where I can find such discussion.

If you need more informations or you want me to test some code let me know.

Please CC the answer to me as I'm not subscribed.

Thanks.
Giacomo
