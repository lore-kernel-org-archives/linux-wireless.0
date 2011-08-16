Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4737 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1HPLgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 07:36:54 -0400
Message-ID: <4E4A5641.4020604@broadcom.com> (sfid-20110816_133701_434473_18B64EF6)
Date: Tue, 16 Aug 2011 13:36:33 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	networkmanager-list@gnome.org
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110814121646.GA5188@stt008.linux.site>
In-Reply-To: <20110814121646.GA5188@stt008.linux.site>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Camaleón,

So the first problem that you encounter is that scan does not work. Lets 
dive into that first.

I see in the log that you sent:

'Aug 14 13:39:02 stt300 NetworkManager[1181]: 
supplicant_interface_acquire: assertion `mgr_state == 
NM_SUPPLICANT_MANAGER_STATE_IDLE' failed'

I also see many 'wpa_supplicant[1204]: Failed to initiate AP scan' messages.

There are no 'Failed to initiate AP scan' messages before the 'assertion 
failed' message. I do not know if the 2nd message is a byproduct of the 
1st result. Regardless, a failed assertion is serious. I cc'ed the 
network manager mailing list.

I don't know how willing/able you are to do some kernel hacking, but 
could you provide us more information with the following instructions:

http://linuxwireless.org/en/developers/Documentation/mac80211/tracing

Thanks, Roland.


  wrote:
> Hello,
>
> Some background:
>
> ***
> Computer: Compaq Mini CQ10
> Running Debian Wheezy, kernel 3.0.0.1-686-pae
> Debian Bug report #637240
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637240
> ***
>
> Since upgrading to kernel 3.x, I'm facing a weird problem with my
> wireless adapter (BCM4313) and "brcmsmac" driver. The problems are as
> follows:
>
> 1/ When the computer starts there is no automatic association between
> the AP and the netbook. NetworkManager stays disconnected and shows not
> wifi networks available.
>
> 2/ Once I force a connection to a hidden AP, I can only get associated
> when sitting next (very near) to the AP.
>
> I am attaching the logs for both situations:
>
> a) When sitting next to the AP and computer starts (next_to_ap.txt)
> b) When sitting on the next room (next_room.txt)
>
> Kernel 2.6.39-2-686-pae was working fine.
>
> CC'ing to "devel@driverdev.osuosl.org" mailing list and Broadcom
> maintainers.
>
> P.S. You can add me as CC for any response.
>
> Greetings,
>

Aug 14 13:38:15 stt300 NetworkManager[1109]: <info> (wlan0): device 
state change: 8 -> 3 (reason 38)
Aug 14 13:38:15 stt300 NetworkManager[1109]: <info> (wlan0): 
deactivating device (reason: 38).
Aug 14 13:38:15 stt300 NetworkManager[1109]: <info> (wlan0): canceled 
DHCP transaction, DHCP client pid 2217
Aug 14 13:38:15 stt300 avahi-daemon[1155]: Withdrawing address record 
for 192.168.0.155 on wlan0.
Aug 14 13:38:15 stt300 avahi-daemon[1155]: Leaving mDNS multicast group 
on interface wlan0.IPv4 with address 192.168.0.155.
Aug 14 13:38:15 stt300 avahi-daemon[1155]: Interface wlan0.IPv4 no 
longer relevant for mDNS.
Aug 14 13:38:15 stt300 kernel: [ 4281.489369] ieee80211 phy0: 
wl_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
Aug 14 13:38:15 stt300 kernel: [ 4281.501937] ieee80211 phy0: 
wl_ops_bss_info_changed: qos enabled: false (implement)
Aug 14 13:38:15 stt300 kernel: [ 4281.502139] ieee80211 phy0: brcmsmac: 
wl_ops_bss_info_changed: disassociated
Aug 14 13:38:15 stt300 kernel: [ 4281.502327] ieee80211 phy0: 
wl_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
Aug 14 13:38:15 stt300 kernel: [ 4281.502560] wlan0: deauthenticating 
from 00:23:f8:9d:ad:11 by local choice (reason=3)
Aug 14 13:38:15 stt300 dbus[1093]: [system] Activating service 
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Aug 14 13:38:15 stt300 acpid: client 1153[0:0] has disconnected
Aug 14 13:38:15 stt300 acpid: client connected from 2430[0:0]
Aug 14 13:38:15 stt300 acpid: 1 client rule loaded
Aug 14 13:38:15 stt300 dbus[1093]: [system] Successfully activated 
service 'org.freedesktop.nm_dispatcher'
Aug 14 13:38:15 stt300 kernel: [ 4281.560117] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: true (implement)
Aug 14 13:38:15 stt300 kernel: [ 4281.563769] cfg80211: Calling CRDA to 
update world regulatory domain
Aug 14 13:38:15 stt300 wpa_supplicant[1132]: CTRL-EVENT-DISCONNECTED 
bssid=00:00:00:00:00:00 reason=0
Aug 14 13:38:15 stt300 kernel: [ 4281.582186] cfg80211: World regulatory 
domain updated:
Aug 14 13:38:15 stt300 kernel: [ 4281.582194] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:38:15 stt300 kernel: [ 4281.582202] cfg80211:     (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.582208] cfg80211:     (2457000 KHz 
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.582214] cfg80211:     (2474000 KHz 
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.582221] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.582227] cfg80211:     (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.582257] cfg80211: Calling CRDA for 
country: EU
Aug 14 13:38:15 stt300 kernel: [ 4281.594818] cfg80211: Regulatory 
domain changed to country: EU
Aug 14 13:38:15 stt300 kernel: [ 4281.594826] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:38:15 stt300 kernel: [ 4281.594833] cfg80211:     (2402000 KHz 
- 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.594839] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.594845] cfg80211:     (5250000 KHz 
- 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:38:15 stt300 kernel: [ 4281.594851] cfg80211:     (5490000 KHz 
- 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Aug 14 13:38:15 stt300 init: Switching to runlevel: 0
Aug 14 13:38:16 stt300 bluetoothd[1167]: Stopping SDP server
Aug 14 13:38:16 stt300 bluetoothd[1167]: Exit
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> caught signal 15, 
shutting down normally.
Aug 14 13:38:17 stt300 NetworkManager[1109]: <warn> quit request 
received, terminating...
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (eth0): now unmanaged
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (eth0): device state 
change: 2 -> 1 (reason 36)
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (eth0): cleaning up...
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (eth0): taking down 
device.
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (wlan0): now unmanaged
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (wlan0): device 
state change: 3 -> 1 (reason 36)
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (wlan0): cleaning up...
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> (wlan0): taking down 
device.
Aug 14 13:38:17 stt300 avahi-daemon[1155]: Got SIGTERM, quitting.
Aug 14 13:38:17 stt300 avahi-daemon[1155]: Leaving mDNS multicast group 
on interface wlan0.IPv6 with address fe80::ae81:12ff:fe34:6963.
Aug 14 13:38:17 stt300 NetworkManager[1109]: <info> exiting (success)
Aug 14 13:38:17 stt300 avahi-daemon[1155]: avahi-daemon 0.6.30 exiting.
Aug 14 13:38:18 stt300 nm-dispatcher.action: Caught signal 15, shutting 
down...
Aug 14 13:38:18 stt300 acpid: exiting
Aug 14 13:38:18 stt300 modem-manager[1118]: <info>  Caught signal 15, 
shutting down...
Aug 14 13:38:19 stt300 kernel: Kernel logging (proc) stopped.
Aug 14 13:38:19 stt300 rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.3" x-pid="1023" x-info="http://www.rsyslog.com"] exiting 
on signal 15.
Aug 14 13:39:00 stt300 kernel: imklog 5.8.3, log source = /proc/kmsg 
started.
Aug 14 13:39:00 stt300 rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.3" x-pid="1136" x-info="http://www.rsyslog.com"] start
Aug 14 13:39:00 stt300 kernel: [    0.000000] Initializing cgroup subsys 
cpuset
Aug 14 13:39:00 stt300 kernel: [    0.000000] Initializing cgroup subsys cpu
Aug 14 13:39:00 stt300 kernel: [    0.000000] Linux version 
3.0.0-1-686-pae (Debian 3.0.0-1) (ben@decadent.org.uk) (gcc version 
4.5.3 (Debian 4.5.3-3) ) #1 SMP Sun Jul 24 14:27:32 UTC 2011
Aug 14 13:39:00 stt300 kernel: [    0.000000] Disabled fast string 
operations
Aug 14 13:39:00 stt300 kernel: [    0.000000] BIOS-provided physical RAM 
map:
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
0000000000000000 - 000000000009fc00 (usable)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
000000000009fc00 - 00000000000a0000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
00000000000e0000 - 0000000000100000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
0000000000100000 - 000000007f43f000 (usable)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
000000007f43f000 - 000000007f4bf000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
000000007f4bf000 - 000000007f5bf000 (ACPI NVS)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
000000007f5bf000 - 000000007f5f7000 (ACPI data)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
000000007f5f7000 - 000000007f600000 (usable)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
000000007f600000 - 0000000080000000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
00000000e0000000 - 00000000f0000000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
00000000fec00000 - 00000000fec01000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
00000000fed14000 - 00000000fed1a000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
00000000fed1c000 - 00000000fed20000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
00000000fee00000 - 00000000fee01000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000]  BIOS-e820: 
00000000ffe00000 - 0000000100000000 (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000] NX (Execute Disable) 
protection: active
Aug 14 13:39:00 stt300 kernel: [    0.000000] DMI 2.6 present.
Aug 14 13:39:00 stt300 kernel: [    0.000000] DMI: Hewlett-Packard 
Compaq Mini CQ10-500            /148A, BIOS F.14 11/12/2010
Aug 14 13:39:00 stt300 kernel: [    0.000000] e820 update range: 
0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Aug 14 13:39:00 stt300 kernel: [    0.000000] e820 remove range: 
00000000000a0000 - 0000000000100000 (usable)
Aug 14 13:39:00 stt300 kernel: [    0.000000] last_pfn = 0x7f600 
max_arch_pfn = 0x1000000
Aug 14 13:39:00 stt300 kernel: [    0.000000] MTRR default type: uncachable
Aug 14 13:39:00 stt300 kernel: [    0.000000] MTRR fixed ranges enabled:
Aug 14 13:39:00 stt300 kernel: [    0.000000]   00000-9FFFF write-back
Aug 14 13:39:00 stt300 kernel: [    0.000000]   A0000-BFFFF uncachable
Aug 14 13:39:00 stt300 kernel: [    0.000000]   C0000-FFFFF write-protect
Aug 14 13:39:00 stt300 kernel: [    0.000000] MTRR variable ranges enabled:
Aug 14 13:39:00 stt300 kernel: [    0.000000]   0 base 0FFE00000 mask 
0FFE00000 write-protect
Aug 14 13:39:00 stt300 kernel: [    0.000000]   1 base 000000000 mask 
0C0000000 write-back
Aug 14 13:39:00 stt300 kernel: [    0.000000]   2 base 040000000 mask 
0C0000000 write-back
Aug 14 13:39:00 stt300 kernel: [    0.000000]   3 base 07F800000 mask 
0FF800000 uncachable
Aug 14 13:39:00 stt300 kernel: [    0.000000]   4 disabled
Aug 14 13:39:00 stt300 kernel: [    0.000000]   5 disabled
Aug 14 13:39:00 stt300 kernel: [    0.000000]   6 disabled
Aug 14 13:39:00 stt300 kernel: [    0.000000] x86 PAT enabled: cpu 0, 
old 0x7040600070406, new 0x7010600070106
Aug 14 13:39:00 stt300 kernel: [    0.000000] initial memory mapped : 0 
- 01a00000
Aug 14 13:39:00 stt300 kernel: [    0.000000] Base memory trampoline at 
[c009b000] 9b000 size 16384
Aug 14 13:39:00 stt300 kernel: [    0.000000] init_memory_mapping: 
0000000000000000-00000000379fe000
Aug 14 13:39:00 stt300 kernel: [    0.000000]  0000000000 - 0000200000 
page 4k
Aug 14 13:39:00 stt300 kernel: [    0.000000]  0000200000 - 0037800000 
page 2M
Aug 14 13:39:00 stt300 kernel: [    0.000000]  0037800000 - 00379fe000 
page 4k
Aug 14 13:39:00 stt300 kernel: [    0.000000] kernel direct mapping 
tables up to 379fe000 @ 19fa000-1a00000
Aug 14 13:39:00 stt300 kernel: [    0.000000] RAMDISK: 37b6a000 - 37dad000
Aug 14 13:39:00 stt300 kernel: [    0.000000] Allocated new RAMDISK: 
377bb000 - 379fd217
Aug 14 13:39:00 stt300 kernel: [    0.000000] Move RAMDISK from 
0000000037b6a000 - 0000000037dac216 to 377bb000 - 379fd216
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: RSDP 000fe020 00024 
(v02 HP    )
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: XSDT 7f5f6120 00074 
(v01 HPQOEM SLIC-MPC 00000001      01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: FACP 7f5f5000 000F4 
(v04 HP     SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: DSDT 7f5e6000 0BA96 
(v01 HP     SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: FACS 7f589000 00040
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: HPET 7f5f4000 00038 
(v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: APIC 7f5f3000 00078 
(v02 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: MCFG 7f5f2000 0003C 
(v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: SLIC 7f5e5000 00176 
(v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: BOOT 7f5e4000 00028 
(v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: SSDT 7f5e3000 004C4 
(v02  PmRef    CpuPm 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: SSDT 7f5e2000 001F7 
(v02  PmRef  Cpu0Tst 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: SSDT 7f5e1000 00064 
(v02  PmRef  Cpu1Tst 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: WDAT 7f5e0000 00194 
(v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Aug 14 13:39:00 stt300 kernel: [    0.000000] 1148MB HIGHMEM available.
Aug 14 13:39:00 stt300 kernel: [    0.000000] 889MB LOWMEM available.
Aug 14 13:39:00 stt300 kernel: [    0.000000]   mapped low ram: 0 - 379fe000
Aug 14 13:39:00 stt300 kernel: [    0.000000]   low ram: 0 - 379fe000
Aug 14 13:39:00 stt300 kernel: [    0.000000] Zone PFN ranges:
Aug 14 13:39:00 stt300 kernel: [    0.000000]   DMA      0x00000010 -> 
0x00001000
Aug 14 13:39:00 stt300 kernel: [    0.000000]   Normal   0x00001000 -> 
0x000379fe
Aug 14 13:39:00 stt300 kernel: [    0.000000]   HighMem  0x000379fe -> 
0x0007f600
Aug 14 13:39:00 stt300 kernel: [    0.000000] Movable zone start PFN for 
each node
Aug 14 13:39:00 stt300 kernel: [    0.000000] early_node_map[3] active 
PFN ranges
Aug 14 13:39:00 stt300 kernel: [    0.000000]     0: 0x00000010 -> 
0x0000009f
Aug 14 13:39:00 stt300 kernel: [    0.000000]     0: 0x00000100 -> 
0x0007f43f
Aug 14 13:39:00 stt300 kernel: [    0.000000]     0: 0x0007f5f7 -> 
0x0007f600
Aug 14 13:39:00 stt300 kernel: [    0.000000] On node 0 totalpages: 521175
Aug 14 13:39:00 stt300 kernel: [    0.000000] free_area_init_node: node 
0, pgdat c141c980, node_mem_map f67ca200
Aug 14 13:39:00 stt300 kernel: [    0.000000]   DMA zone: 32 pages used 
for memmap
Aug 14 13:39:00 stt300 kernel: [    0.000000]   DMA zone: 0 pages reserved
Aug 14 13:39:00 stt300 kernel: [    0.000000]   DMA zone: 3951 pages, 
LIFO batch:0
Aug 14 13:39:00 stt300 kernel: [    0.000000]   Normal zone: 1748 pages 
used for memmap
Aug 14 13:39:00 stt300 kernel: [    0.000000]   Normal zone: 221994 
pages, LIFO batch:31
Aug 14 13:39:00 stt300 kernel: [    0.000000]   HighMem zone: 2297 pages 
used for memmap
Aug 14 13:39:00 stt300 kernel: [    0.000000]   HighMem zone: 291153 
pages, LIFO batch:31
Aug 14 13:39:00 stt300 kernel: [    0.000000] Using APIC driver default
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] 
lapic_id[0x00] enabled)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] 
lapic_id[0x01] enabled)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] 
lapic_id[0x00] disabled)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] 
lapic_id[0x00] disabled)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x01] dfl dfl lint[0x1])
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x02] dfl dfl lint[0x1])
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: IOAPIC (id[0x04] 
address[0xfec00000] gsi_base[0])
Aug 14 13:39:00 stt300 kernel: [    0.000000] IOAPIC[0]: apic_id 4, 
version 32, address 0xfec00000, GSI 0-23
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 0 global_irq 2 dfl dfl)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 9 global_irq 9 high level)
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: IRQ0 used by override.
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: IRQ2 used by override.
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: IRQ9 used by override.
Aug 14 13:39:00 stt300 kernel: [    0.000000] Using ACPI (MADT) for SMP 
configuration information
Aug 14 13:39:00 stt300 kernel: [    0.000000] ACPI: HPET id: 0x8086a201 
base: 0xfed00000
Aug 14 13:39:00 stt300 kernel: [    0.000000] SMP: Allowing 4 CPUs, 2 
hotplug CPUs
Aug 14 13:39:00 stt300 kernel: [    0.000000] nr_irqs_gsi: 40
Aug 14 13:39:00 stt300 kernel: [    0.000000] PM: Registered nosave 
memory: 000000000009f000 - 00000000000a0000
Aug 14 13:39:00 stt300 kernel: [    0.000000] PM: Registered nosave 
memory: 00000000000a0000 - 00000000000e0000
Aug 14 13:39:00 stt300 kernel: [    0.000000] PM: Registered nosave 
memory: 00000000000e0000 - 0000000000100000
Aug 14 13:39:00 stt300 kernel: [    0.000000] Allocating PCI resources 
starting at 80000000 (gap: 80000000:60000000)
Aug 14 13:39:00 stt300 kernel: [    0.000000] Booting paravirtualized 
kernel on bare hardware
Aug 14 13:39:00 stt300 kernel: [    0.000000] setup_percpu: NR_CPUS:32 
nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
Aug 14 13:39:00 stt300 kernel: [    0.000000] PERCPU: Embedded 13 
pages/cpu @f6400000 s28864 r0 d24384 u524288
Aug 14 13:39:00 stt300 kernel: [    0.000000] pcpu-alloc: s28864 r0 
d24384 u524288 alloc=1*2097152
Aug 14 13:39:00 stt300 kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3
Aug 14 13:39:00 stt300 kernel: [    0.000000] Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 517098
Aug 14 13:39:00 stt300 kernel: [    0.000000] Kernel command line: 
BOOT_IMAGE=/boot/vmlinuz-3.0.0-1-686-pae 
root=UUID=ef88aa1c-5071-41ac-8884-6c991eca9b22 ro quiet
Aug 14 13:39:00 stt300 kernel: [    0.000000] PID hash table entries: 
4096 (order: 2, 16384 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.000000] Dentry cache hash table 
entries: 131072 (order: 7, 524288 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.000000] Inode-cache hash table 
entries: 65536 (order: 6, 262144 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.000000] Initializing CPU#0
Aug 14 13:39:00 stt300 kernel: [    0.000000] Initializing HighMem for 
node 0 (000379fe:0007f600)
Aug 14 13:39:00 stt300 kernel: [    0.000000] Memory: 2059732k/2086912k 
available (2764k kernel code, 24968k reserved, 1474k data, 404k init, 
1173800k highmem)
Aug 14 13:39:00 stt300 kernel: [    0.000000] virtual kernel memory layout:
Aug 14 13:39:00 stt300 kernel: [    0.000000]     fixmap  : 0xffd36000 - 
0xfffff000   (2852 kB)
Aug 14 13:39:00 stt300 kernel: [    0.000000]     pkmap   : 0xffa00000 - 
0xffc00000   (2048 kB)
Aug 14 13:39:00 stt300 kernel: [    0.000000]     vmalloc : 0xf81fe000 - 
0xff9fe000   ( 120 MB)
Aug 14 13:39:00 stt300 kernel: [    0.000000]     lowmem  : 0xc0000000 - 
0xf79fe000   ( 889 MB)
Aug 14 13:39:00 stt300 kernel: [    0.000000]       .init : 0xc1424000 - 
0xc1489000   ( 404 kB)
Aug 14 13:39:00 stt300 kernel: [    0.000000]       .data : 0xc12b326c - 
0xc1423b80   (1474 kB)
Aug 14 13:39:00 stt300 kernel: [    0.000000]       .text : 0xc1000000 - 
0xc12b326c   (2764 kB)
Aug 14 13:39:00 stt300 kernel: [    0.000000] Checking if this processor 
honours the WP bit even in supervisor mode...Ok.
Aug 14 13:39:00 stt300 kernel: [    0.000000] Hierarchical RCU 
implementation.
Aug 14 13:39:00 stt300 kernel: [    0.000000]   RCU dyntick-idle 
grace-period acceleration is enabled.
Aug 14 13:39:00 stt300 kernel: [    0.000000] NR_IRQS:1280
Aug 14 13:39:00 stt300 kernel: [    0.000000] CPU 0 irqstacks, 
hard=f600c000 soft=f600e000
Aug 14 13:39:00 stt300 kernel: [    0.000000] Console: colour VGA+ 80x25
Aug 14 13:39:00 stt300 kernel: [    0.000000] console [tty0] enabled
Aug 14 13:39:00 stt300 kernel: [    0.000000] hpet clockevent registered
Aug 14 13:39:00 stt300 kernel: [    0.000000] Fast TSC calibration using PIT
Aug 14 13:39:00 stt300 kernel: [    0.000000] Detected 1662.521 MHz 
processor.
Aug 14 13:39:00 stt300 kernel: [    0.004005] Calibrating delay loop 
(skipped), value calculated using timer frequency.. 3325.04 BogoMIPS 
(lpj=6650084)
Aug 14 13:39:00 stt300 kernel: [    0.004015] pid_max: default: 32768 
minimum: 301
Aug 14 13:39:00 stt300 kernel: [    0.004124] Security Framework initialized
Aug 14 13:39:00 stt300 kernel: [    0.004132] SELinux:  Disabled at boot.
Aug 14 13:39:00 stt300 kernel: [    0.004183] Mount-cache hash table 
entries: 512
Aug 14 13:39:00 stt300 kernel: [    0.004712] Initializing cgroup subsys 
cpuacct
Aug 14 13:39:00 stt300 kernel: [    0.004761] Initializing cgroup subsys 
memory
Aug 14 13:39:00 stt300 kernel: [    0.004792] Initializing cgroup subsys 
devices
Aug 14 13:39:00 stt300 kernel: [    0.004798] Initializing cgroup subsys 
freezer
Aug 14 13:39:00 stt300 kernel: [    0.004803] Initializing cgroup subsys 
net_cls
Aug 14 13:39:00 stt300 kernel: [    0.004808] Initializing cgroup subsys 
blkio
Aug 14 13:39:00 stt300 kernel: [    0.004869] Disabled fast string 
operations
Aug 14 13:39:00 stt300 kernel: [    0.004878] CPU: Physical Processor ID: 0
Aug 14 13:39:00 stt300 kernel: [    0.004882] CPU: Processor Core ID: 0
Aug 14 13:39:00 stt300 kernel: [    0.004887] mce: CPU supports 5 MCE banks
Aug 14 13:39:00 stt300 kernel: [    0.004898] CPU0: Thermal monitoring 
handled by SMI
Aug 14 13:39:00 stt300 kernel: [    0.004906] using mwait in idle threads.
Aug 14 13:39:00 stt300 kernel: [    0.005422] ACPI: Core revision 20110413
Aug 14 13:39:00 stt300 kernel: [    0.020112] Enabling APIC mode:  Flat. 
  Using 1 I/O APICs
Aug 14 13:39:00 stt300 kernel: [    0.020524] ..TIMER: vector=0x30 
apic1=0 pin1=2 apic2=-1 pin2=-1
Aug 14 13:39:00 stt300 kernel: [    0.060356] CPU0: Intel(R) Atom(TM) 
CPU N455   @ 1.66GHz stepping 0a
Aug 14 13:39:00 stt300 kernel: [    0.064003] Performance Events: PEBS 
fmt0+, Atom events, Intel PMU driver.
Aug 14 13:39:00 stt300 kernel: [    0.064003] ... version:                3
Aug 14 13:39:00 stt300 kernel: [    0.064003] ... bit width:              40
Aug 14 13:39:00 stt300 kernel: [    0.064003] ... generic registers:      2
Aug 14 13:39:00 stt300 kernel: [    0.064003] ... value mask: 
   000000ffffffffff
Aug 14 13:39:00 stt300 kernel: [    0.064003] ... max period: 
   000000007fffffff
Aug 14 13:39:00 stt300 kernel: [    0.064003] ... fixed-purpose events:   3
Aug 14 13:39:00 stt300 kernel: [    0.064003] ... event mask: 
   0000000700000003
Aug 14 13:39:00 stt300 kernel: [    0.064003] NMI watchdog enabled, 
takes one hw-pmu counter.
Aug 14 13:39:00 stt300 kernel: [    0.064003] CPU 1 irqstacks, 
hard=f60f4000 soft=f60f6000
Aug 14 13:39:00 stt300 kernel: [    0.064003] Booting Node   0, 
Processors  #1
Aug 14 13:39:00 stt300 kernel: [    0.064003] smpboot cpu 1: start_ip = 
9b000
Aug 14 13:39:00 stt300 kernel: [    0.008000] Initializing CPU#1
Aug 14 13:39:00 stt300 kernel: [    0.008000] Disabled fast string 
operations
Aug 14 13:39:00 stt300 kernel: [    0.008000] CPU1: Thermal monitoring 
handled by SMI
Aug 14 13:39:00 stt300 kernel: [    0.156062] NMI watchdog enabled, 
takes one hw-pmu counter.
Aug 14 13:39:00 stt300 kernel: [    0.156137] Brought up 2 CPUs
Aug 14 13:39:00 stt300 kernel: [    0.156145] Total of 2 processors 
activated (6650.35 BogoMIPS).
Aug 14 13:39:00 stt300 kernel: [    0.156871] devtmpfs: initialized
Aug 14 13:39:00 stt300 kernel: [    0.156871] PM: Registering ACPI NVS 
region at 7f4bf000 (1048576 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.156871] print_constraints: dummy:
Aug 14 13:39:00 stt300 kernel: [    0.156871] NET: Registered protocol 
family 16
Aug 14 13:39:00 stt300 kernel: [    0.156922] ACPI: bus type pci registered
Aug 14 13:39:00 stt300 kernel: [    0.157192] PCI: MMCONFIG for domain 
0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Aug 14 13:39:00 stt300 kernel: [    0.157200] PCI: MMCONFIG at [mem 
0xe0000000-0xefffffff] reserved in E820
Aug 14 13:39:00 stt300 kernel: [    0.157205] PCI: Using MMCONFIG for 
extended config space
Aug 14 13:39:00 stt300 kernel: [    0.157209] PCI: Using configuration 
type 1 for base access
Aug 14 13:39:00 stt300 kernel: [    0.160124] bio: create slab <bio-0> at 0
Aug 14 13:39:00 stt300 kernel: [    0.163201] ACPI: EC: Look up EC in DSDT
Aug 14 13:39:00 stt300 kernel: [    0.166766] ACPI: Executed 1 blocks of 
module-level executable AML code
Aug 14 13:39:00 stt300 kernel: [    0.171137] [Firmware Bug]: ACPI: BIOS 
_OSI(Linux) query ignored
Aug 14 13:39:00 stt300 kernel: [    0.172142] ACPI: SSDT 7f494c98 001F7 
(v02  PmRef  Cpu0Ist 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.172944] ACPI: Dynamic OEM Table Load:
Aug 14 13:39:00 stt300 kernel: [    0.172952] ACPI: SSDT   (null) 001F7 
(v02  PmRef  Cpu0Ist 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.173258] ACPI: SSDT 7f493e18 001C7 
(v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.174011] ACPI: Dynamic OEM Table Load:
Aug 14 13:39:00 stt300 kernel: [    0.174018] ACPI: SSDT   (null) 001C7 
(v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.196656] ACPI: SSDT 7f494f18 000D0 
(v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.197434] ACPI: Dynamic OEM Table Load:
Aug 14 13:39:00 stt300 kernel: [    0.197442] ACPI: SSDT   (null) 000D0 
(v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.197718] ACPI: SSDT 7f492f18 00083 
(v02  PmRef  Cpu1Cst 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.198473] ACPI: Dynamic OEM Table Load:
Aug 14 13:39:00 stt300 kernel: [    0.198479] ACPI: SSDT   (null) 00083 
(v02  PmRef  Cpu1Cst 00003000 INTL 20051117)
Aug 14 13:39:00 stt300 kernel: [    0.524473] ACPI: Interpreter enabled
Aug 14 13:39:00 stt300 kernel: [    0.524485] ACPI: (supports S0 S3 S4 S5)
Aug 14 13:39:00 stt300 kernel: [    0.524549] ACPI: Using IOAPIC for 
interrupt routing
Aug 14 13:39:00 stt300 kernel: [    0.538349] ACPI: Power Resource 
[FN00] (on)
Aug 14 13:39:00 stt300 kernel: [    0.539118] ACPI: EC: GPE = 0x11, I/O: 
command/status = 0x66, data = 0x62
Aug 14 13:39:00 stt300 kernel: [    0.539485] ACPI: No dock devices found.
Aug 14 13:39:00 stt300 kernel: [    0.539491] HEST: Table not found.
Aug 14 13:39:00 stt300 kernel: [    0.539499] PCI: Using host bridge 
windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Aug 14 13:39:00 stt300 kernel: [    0.540516] ACPI Warning: For 
\_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI 
requires 4 (20110413/nspredef-352)
Aug 14 13:39:00 stt300 kernel: [    0.540535] \_SB_.PCI0:_OSC evaluation 
returned wrong type
Aug 14 13:39:00 stt300 kernel: [    0.540539] _OSC request data:1 8 1f
Aug 14 13:39:00 stt300 kernel: [    0.540550] ACPI: PCI Root Bridge 
[PCI0] (domain 0000 [bus 00-ff])
Aug 14 13:39:00 stt300 kernel: [    0.542233] pci_root PNP0A08:00: host 
bridge window [io  0x0000-0x0cf7]
Aug 14 13:39:00 stt300 kernel: [    0.542241] pci_root PNP0A08:00: host 
bridge window [io  0x0d00-0xffff]
Aug 14 13:39:00 stt300 kernel: [    0.542248] pci_root PNP0A08:00: host 
bridge window [mem 0x000a0000-0x000bffff]
Aug 14 13:39:00 stt300 kernel: [    0.542256] pci_root PNP0A08:00: host 
bridge window [mem 0x80000000-0xfebfffff]
Aug 14 13:39:00 stt300 kernel: [    0.542284] pci 0000:00:00.0: 
[8086:a010] type 0 class 0x000600
Aug 14 13:39:00 stt300 kernel: [    0.542346] pci 0000:00:02.0: 
[8086:a011] type 0 class 0x000300
Aug 14 13:39:00 stt300 kernel: [    0.542362] pci 0000:00:02.0: reg 10: 
[mem 0x94180000-0x941fffff]
Aug 14 13:39:00 stt300 kernel: [    0.542372] pci 0000:00:02.0: reg 14: 
[io  0x30c0-0x30c7]
Aug 14 13:39:00 stt300 kernel: [    0.542383] pci 0000:00:02.0: reg 18: 
[mem 0x80000000-0x8fffffff pref]
Aug 14 13:39:00 stt300 kernel: [    0.542393] pci 0000:00:02.0: reg 1c: 
[mem 0x94000000-0x940fffff]
Aug 14 13:39:00 stt300 kernel: [    0.542439] pci 0000:00:02.1: 
[8086:a012] type 0 class 0x000380
Aug 14 13:39:00 stt300 kernel: [    0.542453] pci 0000:00:02.1: reg 10: 
[mem 0x94100000-0x9417ffff]
Aug 14 13:39:00 stt300 kernel: [    0.542566] pci 0000:00:1b.0: 
[8086:27d8] type 0 class 0x000403
Aug 14 13:39:00 stt300 kernel: [    0.542595] pci 0000:00:1b.0: reg 10: 
[mem 0x94200000-0x94203fff 64bit]
Aug 14 13:39:00 stt300 kernel: [    0.542682] pci 0000:00:1b.0: PME# 
supported from D0 D3hot D3cold
Aug 14 13:39:00 stt300 kernel: [    0.542691] pci 0000:00:1b.0: PME# 
disabled
Aug 14 13:39:00 stt300 kernel: [    0.542729] pci 0000:00:1c.0: 
[8086:27d0] type 1 class 0x000604
Aug 14 13:39:00 stt300 kernel: [    0.542823] pci 0000:00:1c.0: PME# 
supported from D0 D3hot D3cold
Aug 14 13:39:00 stt300 kernel: [    0.542831] pci 0000:00:1c.0: PME# 
disabled
Aug 14 13:39:00 stt300 kernel: [    0.542874] pci 0000:00:1c.1: 
[8086:27d2] type 1 class 0x000604
Aug 14 13:39:00 stt300 kernel: [    0.542966] pci 0000:00:1c.1: PME# 
supported from D0 D3hot D3cold
Aug 14 13:39:00 stt300 kernel: [    0.542974] pci 0000:00:1c.1: PME# 
disabled
Aug 14 13:39:00 stt300 kernel: [    0.543018] pci 0000:00:1d.0: 
[8086:27c8] type 0 class 0x000c03
Aug 14 13:39:00 stt300 kernel: [    0.543080] pci 0000:00:1d.0: reg 20: 
[io  0x3080-0x309f]
Aug 14 13:39:00 stt300 kernel: [    0.543134] pci 0000:00:1d.1: 
[8086:27c9] type 0 class 0x000c03
Aug 14 13:39:00 stt300 kernel: [    0.543196] pci 0000:00:1d.1: reg 20: 
[io  0x3060-0x307f]
Aug 14 13:39:00 stt300 kernel: [    0.543247] pci 0000:00:1d.2: 
[8086:27ca] type 0 class 0x000c03
Aug 14 13:39:00 stt300 kernel: [    0.543309] pci 0000:00:1d.2: reg 20: 
[io  0x3040-0x305f]
Aug 14 13:39:00 stt300 kernel: [    0.543362] pci 0000:00:1d.3: 
[8086:27cb] type 0 class 0x000c03
Aug 14 13:39:00 stt300 kernel: [    0.543425] pci 0000:00:1d.3: reg 20: 
[io  0x3020-0x303f]
Aug 14 13:39:00 stt300 kernel: [    0.543490] pci 0000:00:1d.7: 
[8086:27cc] type 0 class 0x000c03
Aug 14 13:39:00 stt300 kernel: [    0.543490] pci 0000:00:1d.7: reg 10: 
[mem 0x94204400-0x942047ff]
Aug 14 13:39:00 stt300 kernel: [    0.548076] pci 0000:00:1d.7: PME# 
supported from D0 D3hot D3cold
Aug 14 13:39:00 stt300 kernel: [    0.548086] pci 0000:00:1d.7: PME# 
disabled
Aug 14 13:39:00 stt300 kernel: [    0.548127] pci 0000:00:1e.0: 
[8086:2448] type 1 class 0x000604
Aug 14 13:39:00 stt300 kernel: [    0.548220] pci 0000:00:1f.0: 
[8086:27bc] type 0 class 0x000601
Aug 14 13:39:00 stt300 kernel: [    0.548388] pci 0000:00:1f.2: 
[8086:27c1] type 0 class 0x000106
Aug 14 13:39:00 stt300 kernel: [    0.548417] pci 0000:00:1f.2: reg 10: 
[io  0x30b8-0x30bf]
Aug 14 13:39:00 stt300 kernel: [    0.548434] pci 0000:00:1f.2: reg 14: 
[io  0x30cc-0x30cf]
Aug 14 13:39:00 stt300 kernel: [    0.548450] pci 0000:00:1f.2: reg 18: 
[io  0x30b0-0x30b7]
Aug 14 13:39:00 stt300 kernel: [    0.548466] pci 0000:00:1f.2: reg 1c: 
[io  0x30c8-0x30cb]
Aug 14 13:39:00 stt300 kernel: [    0.548481] pci 0000:00:1f.2: reg 20: 
[io  0x30a0-0x30af]
Aug 14 13:39:00 stt300 kernel: [    0.548497] pci 0000:00:1f.2: reg 24: 
[mem 0x94204000-0x942043ff]
Aug 14 13:39:00 stt300 kernel: [    0.548539] pci 0000:00:1f.2: PME# 
supported from D3hot
Aug 14 13:39:00 stt300 kernel: [    0.548547] pci 0000:00:1f.2: PME# 
disabled
Aug 14 13:39:00 stt300 kernel: [    0.548575] pci 0000:00:1f.3: 
[8086:27da] type 0 class 0x000c05
Aug 14 13:39:00 stt300 kernel: [    0.548651] pci 0000:00:1f.3: reg 20: 
[io  0x3000-0x301f]
Aug 14 13:39:00 stt300 kernel: [    0.548840] pci 0000:01:00.0: 
[10ec:8136] type 0 class 0x000200
Aug 14 13:39:00 stt300 kernel: [    0.548910] pci 0000:01:00.0: reg 10: 
[io  0x2000-0x20ff]
Aug 14 13:39:00 stt300 kernel: [    0.549028] pci 0000:01:00.0: reg 18: 
[mem 0x90004000-0x90004fff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.549103] pci 0000:01:00.0: reg 20: 
[mem 0x90000000-0x90003fff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.549299] pci 0000:01:00.0: supports 
D1 D2
Aug 14 13:39:00 stt300 kernel: [    0.549304] pci 0000:01:00.0: PME# 
supported from D0 D1 D2 D3hot D3cold
Aug 14 13:39:00 stt300 kernel: [    0.549322] pci 0000:01:00.0: PME# 
disabled
Aug 14 13:39:00 stt300 kernel: [    0.549489] pci 0000:01:00.1: 
[10ec:5288] type 0 class 0x00ff00
Aug 14 13:39:00 stt300 kernel: [    0.549557] pci 0000:01:00.1: reg 10: 
[mem 0x93000000-0x9300ffff]
Aug 14 13:39:00 stt300 kernel: [    0.549973] pci 0000:01:00.1: supports 
D1 D2
Aug 14 13:39:00 stt300 kernel: [    0.549978] pci 0000:01:00.1: PME# 
supported from D1 D2 D3hot D3cold
Aug 14 13:39:00 stt300 kernel: [    0.549996] pci 0000:01:00.1: PME# 
disabled
Aug 14 13:39:00 stt300 kernel: [    0.550216] pci 0000:00:1c.0: PCI 
bridge to [bus 01-01]
Aug 14 13:39:00 stt300 kernel: [    0.550224] pci 0000:00:1c.0:   bridge 
window [io  0x2000-0x2fff]
Aug 14 13:39:00 stt300 kernel: [    0.550233] pci 0000:00:1c.0:   bridge 
window [mem 0x93000000-0x93ffffff]
Aug 14 13:39:00 stt300 kernel: [    0.550246] pci 0000:00:1c.0:   bridge 
window [mem 0x90000000-0x90ffffff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.550356] pci 0000:02:00.0: 
[14e4:4727] type 0 class 0x000280
Aug 14 13:39:00 stt300 kernel: [    0.550405] pci 0000:02:00.0: reg 10: 
[mem 0x92000000-0x92003fff 64bit]
Aug 14 13:39:00 stt300 kernel: [    0.550588] pci 0000:02:00.0: supports 
D1 D2
Aug 14 13:39:00 stt300 kernel: [    0.556069] pci 0000:00:1c.1: PCI 
bridge to [bus 02-02]
Aug 14 13:39:00 stt300 kernel: [    0.556079] pci 0000:00:1c.1:   bridge 
window [io  0x1000-0x1fff]
Aug 14 13:39:00 stt300 kernel: [    0.556088] pci 0000:00:1c.1:   bridge 
window [mem 0x92000000-0x92ffffff]
Aug 14 13:39:00 stt300 kernel: [    0.556100] pci 0000:00:1c.1:   bridge 
window [mem 0x91000000-0x91ffffff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.556199] pci 0000:00:1e.0: PCI 
bridge to [bus 03-03] (subtractive decode)
Aug 14 13:39:00 stt300 kernel: [    0.556208] pci 0000:00:1e.0:   bridge 
window [io  0xf000-0x0000] (disabled)
Aug 14 13:39:00 stt300 kernel: [    0.556217] pci 0000:00:1e.0:   bridge 
window [mem 0xfff00000-0x000fffff] (disabled)
Aug 14 13:39:00 stt300 kernel: [    0.556228] pci 0000:00:1e.0:   bridge 
window [mem 0xfff00000-0x000fffff pref] (disabled)
Aug 14 13:39:00 stt300 kernel: [    0.556235] pci 0000:00:1e.0:   bridge 
window [io  0x0000-0x0cf7] (subtractive decode)
Aug 14 13:39:00 stt300 kernel: [    0.556242] pci 0000:00:1e.0:   bridge 
window [io  0x0d00-0xffff] (subtractive decode)
Aug 14 13:39:00 stt300 kernel: [    0.556249] pci 0000:00:1e.0:   bridge 
window [mem 0x000a0000-0x000bffff] (subtractive decode)
Aug 14 13:39:00 stt300 kernel: [    0.556256] pci 0000:00:1e.0:   bridge 
window [mem 0x80000000-0xfebfffff] (subtractive decode)
Aug 14 13:39:00 stt300 kernel: [    0.556282] pci_bus 0000:00: on NUMA 
node 0
Aug 14 13:39:00 stt300 kernel: [    0.556291] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0._PRT]
Aug 14 13:39:00 stt300 kernel: [    0.556615] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0.P32_._PRT]
Aug 14 13:39:00 stt300 kernel: [    0.556823] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0.EXP1._PRT]
Aug 14 13:39:00 stt300 kernel: [    0.556973] ACPI: PCI Interrupt 
Routing Table [\_SB_.PCI0.EXP2._PRT]
Aug 14 13:39:00 stt300 kernel: [    0.557313] ACPI Warning: For 
\_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI 
requires 4 (20110413/nspredef-352)
Aug 14 13:39:00 stt300 kernel: [    0.557331] \_SB_.PCI0:_OSC evaluation 
returned wrong type
Aug 14 13:39:00 stt300 kernel: [    0.557335] _OSC request data:1 1f 1f
Aug 14 13:39:00 stt300 kernel: [    0.557346]  pci0000:00: Requesting 
ACPI _OSC control (0x1d)
Aug 14 13:39:00 stt300 kernel: [    0.557493] ACPI Warning: For 
\_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI 
requires 4 (20110413/nspredef-352)
Aug 14 13:39:00 stt300 kernel: [    0.557510] \_SB_.PCI0:_OSC evaluation 
returned wrong type
Aug 14 13:39:00 stt300 kernel: [    0.557514] _OSC request data:1 0 1d
Aug 14 13:39:00 stt300 kernel: [    0.557524]  pci0000:00: ACPI _OSC 
request failed (AE_TYPE), returned control mask: 0x1d
Aug 14 13:39:00 stt300 kernel: [    0.557529] ACPI _OSC control for PCIe 
not granted, disabling ASPM
Aug 14 13:39:00 stt300 kernel: [    0.564414] ACPI: PCI Interrupt Link 
[LNKA] (IRQs 3 4 5 7 9 10 *11 12)
Aug 14 13:39:00 stt300 kernel: [    0.564569] ACPI: PCI Interrupt Link 
[LNKB] (IRQs 3 4 5 7 9 *10 11 12)
Aug 14 13:39:00 stt300 kernel: [    0.564721] ACPI: PCI Interrupt Link 
[LNKC] (IRQs 3 4 5 7 9 10 *11 12)
Aug 14 13:39:00 stt300 kernel: [    0.564871] ACPI: PCI Interrupt Link 
[LNKD] (IRQs 3 4 5 7 9 10 *11 12)
Aug 14 13:39:00 stt300 kernel: [    0.565022] ACPI: PCI Interrupt Link 
[LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Aug 14 13:39:00 stt300 kernel: [    0.565176] ACPI: PCI Interrupt Link 
[LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Aug 14 13:39:00 stt300 kernel: [    0.565329] ACPI: PCI Interrupt Link 
[LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Aug 14 13:39:00 stt300 kernel: [    0.565483] ACPI: PCI Interrupt Link 
[LNKH] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Aug 14 13:39:00 stt300 kernel: [    0.565752] vgaarb: device added: 
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Aug 14 13:39:00 stt300 kernel: [    0.565774] vgaarb: loaded
Aug 14 13:39:00 stt300 kernel: [    0.565777] vgaarb: bridge control 
possible 0000:00:02.0
Aug 14 13:39:00 stt300 kernel: [    0.565880] PCI: Using ACPI for IRQ 
routing
Aug 14 13:39:00 stt300 kernel: [    0.574797] PCI: pci_cache_line_size 
set to 64 bytes
Aug 14 13:39:00 stt300 kernel: [    0.574939] reserve RAM buffer: 
000000000009fc00 - 000000000009ffff
Aug 14 13:39:00 stt300 kernel: [    0.574946] reserve RAM buffer: 
000000007f43f000 - 000000007fffffff
Aug 14 13:39:00 stt300 kernel: [    0.574954] reserve RAM buffer: 
000000007f600000 - 000000007fffffff
Aug 14 13:39:00 stt300 kernel: [    0.575232] HPET: 3 timers in total, 0 
timers will be used for per-cpu timer
Aug 14 13:39:00 stt300 kernel: [    0.575244] hpet0: at MMIO 0xfed00000, 
IRQs 2, 8, 0
Aug 14 13:39:00 stt300 kernel: [    0.575255] hpet0: 3 comparators, 
64-bit 14.318180 MHz counter
Aug 14 13:39:00 stt300 kernel: [    0.580081] Switching to clocksource hpet
Aug 14 13:39:00 stt300 kernel: [    0.583036] pnp: PnP ACPI init
Aug 14 13:39:00 stt300 kernel: [    0.583079] ACPI: bus type pnp registered
Aug 14 13:39:00 stt300 kernel: [    0.583816] Switched to NOHz mode on 
CPU #0
Aug 14 13:39:00 stt300 kernel: [    0.583965] Switched to NOHz mode on 
CPU #1
Aug 14 13:39:00 stt300 kernel: [    0.584953] pnp 00:00: [bus 00-ff]
Aug 14 13:39:00 stt300 kernel: [    0.584960] pnp 00:00: [io 
0x0000-0x0cf7 window]
Aug 14 13:39:00 stt300 kernel: [    0.584966] pnp 00:00: [io  0x0cf8-0x0cff]
Aug 14 13:39:00 stt300 kernel: [    0.584972] pnp 00:00: [io 
0x0d00-0xffff window]
Aug 14 13:39:00 stt300 kernel: [    0.584979] pnp 00:00: [mem 
0x000a0000-0x000bffff window]
Aug 14 13:39:00 stt300 kernel: [    0.584985] pnp 00:00: [mem 
0x000c0000-0x000c3fff window]
Aug 14 13:39:00 stt300 kernel: [    0.584991] pnp 00:00: [mem 
0x000c4000-0x000c7fff window]
Aug 14 13:39:00 stt300 kernel: [    0.584997] pnp 00:00: [mem 
0x000c8000-0x000cbfff window]
Aug 14 13:39:00 stt300 kernel: [    0.585003] pnp 00:00: [mem 
0x000cc000-0x000cffff window]
Aug 14 13:39:00 stt300 kernel: [    0.585009] pnp 00:00: [mem 
0x000d0000-0x000d3fff window]
Aug 14 13:39:00 stt300 kernel: [    0.585015] pnp 00:00: [mem 
0x000d4000-0x000d7fff window]
Aug 14 13:39:00 stt300 kernel: [    0.585021] pnp 00:00: [mem 
0x000d8000-0x000dbfff window]
Aug 14 13:39:00 stt300 kernel: [    0.585027] pnp 00:00: [mem 
0x000dc000-0x000dffff window]
Aug 14 13:39:00 stt300 kernel: [    0.585034] pnp 00:00: [mem 
0x000e0000-0x000e3fff window]
Aug 14 13:39:00 stt300 kernel: [    0.585040] pnp 00:00: [mem 
0x000e4000-0x000e7fff window]
Aug 14 13:39:00 stt300 kernel: [    0.585046] pnp 00:00: [mem 
0x000e8000-0x000ebfff window]
Aug 14 13:39:00 stt300 kernel: [    0.585052] pnp 00:00: [mem 
0x000ec000-0x000effff window]
Aug 14 13:39:00 stt300 kernel: [    0.585058] pnp 00:00: [mem 
0x000f0000-0x000fffff window]
Aug 14 13:39:00 stt300 kernel: [    0.585064] pnp 00:00: [mem 
0x80000000-0xfebfffff window]
Aug 14 13:39:00 stt300 kernel: [    0.585193] pnp 00:00: Plug and Play 
ACPI device, IDs PNP0a08 PNP0a03 (active)
Aug 14 13:39:00 stt300 kernel: [    0.585515] pnp 00:01: [io  0x002e-0x002f]
Aug 14 13:39:00 stt300 kernel: [    0.585522] pnp 00:01: [io  0x004e-0x004f]
Aug 14 13:39:00 stt300 kernel: [    0.585527] pnp 00:01: [io  0x0061]
Aug 14 13:39:00 stt300 kernel: [    0.585532] pnp 00:01: [io  0x0070]
Aug 14 13:39:00 stt300 kernel: [    0.585537] pnp 00:01: [io  0x0080]
Aug 14 13:39:00 stt300 kernel: [    0.585546] pnp 00:01: [io  0x0092]
Aug 14 13:39:00 stt300 kernel: [    0.585551] pnp 00:01: [io  0x00b2-0x00b3]
Aug 14 13:39:00 stt300 kernel: [    0.585556] pnp 00:01: [io  0x0063]
Aug 14 13:39:00 stt300 kernel: [    0.585561] pnp 00:01: [io  0x0065]
Aug 14 13:39:00 stt300 kernel: [    0.585566] pnp 00:01: [io  0x0067]
Aug 14 13:39:00 stt300 kernel: [    0.585572] pnp 00:01: [io  0x0600-0x060f]
Aug 14 13:39:00 stt300 kernel: [    0.585577] pnp 00:01: [io  0x0610]
Aug 14 13:39:00 stt300 kernel: [    0.585582] pnp 00:01: [io  0x0800-0x080f]
Aug 14 13:39:00 stt300 kernel: [    0.585587] pnp 00:01: [io  0x0810-0x0817]
Aug 14 13:39:00 stt300 kernel: [    0.585593] pnp 00:01: [io  0x0400-0x047f]
Aug 14 13:39:00 stt300 kernel: [    0.585598] pnp 00:01: [io  0x0500-0x053f]
Aug 14 13:39:00 stt300 kernel: [    0.585604] pnp 00:01: [mem 
0xe0000000-0xefffffff]
Aug 14 13:39:00 stt300 kernel: [    0.585610] pnp 00:01: [mem 
0xfed1c000-0xfed1ffff]
Aug 14 13:39:00 stt300 kernel: [    0.585616] pnp 00:01: [mem 
0xfed14000-0xfed17fff]
Aug 14 13:39:00 stt300 kernel: [    0.585621] pnp 00:01: [mem 
0xfed18000-0xfed18fff]
Aug 14 13:39:00 stt300 kernel: [    0.585627] pnp 00:01: [mem 
0xfed19000-0xfed19fff]
Aug 14 13:39:00 stt300 kernel: [    0.585633] pnp 00:01: [mem 
0xfec00000-0xfec00fff]
Aug 14 13:39:00 stt300 kernel: [    0.585639] pnp 00:01: [mem 
0xfee00000-0xfee00fff]
Aug 14 13:39:00 stt300 kernel: [    0.585782] system 00:01: [io 
0x0600-0x060f] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585790] system 00:01: [io  0x0610] 
has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585797] system 00:01: [io 
0x0800-0x080f] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585804] system 00:01: [io 
0x0810-0x0817] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585812] system 00:01: [io 
0x0400-0x047f] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585820] system 00:01: [io 
0x0500-0x053f] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585829] system 00:01: [mem 
0xe0000000-0xefffffff] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585836] system 00:01: [mem 
0xfed1c000-0xfed1ffff] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585844] system 00:01: [mem 
0xfed14000-0xfed17fff] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585851] system 00:01: [mem 
0xfed18000-0xfed18fff] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585859] system 00:01: [mem 
0xfed19000-0xfed19fff] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585867] system 00:01: [mem 
0xfec00000-0xfec00fff] could not be reserved
Aug 14 13:39:00 stt300 kernel: [    0.585875] system 00:01: [mem 
0xfee00000-0xfee00fff] has been reserved
Aug 14 13:39:00 stt300 kernel: [    0.585883] system 00:01: Plug and 
Play ACPI device, IDs PNP0c02 (active)
Aug 14 13:39:00 stt300 kernel: [    0.585911] pnp 00:02: [io  0x0000-0x001f]
Aug 14 13:39:00 stt300 kernel: [    0.585917] pnp 00:02: [io  0x0081-0x0091]
Aug 14 13:39:00 stt300 kernel: [    0.585922] pnp 00:02: [io  0x0093-0x009f]
Aug 14 13:39:00 stt300 kernel: [    0.585927] pnp 00:02: [io  0x00c0-0x00df]
Aug 14 13:39:00 stt300 kernel: [    0.585933] pnp 00:02: [dma 4]
Aug 14 13:39:00 stt300 kernel: [    0.586005] pnp 00:02: Plug and Play 
ACPI device, IDs PNP0200 (active)
Aug 14 13:39:00 stt300 kernel: [    0.586071] pnp 00:03: [io  0x0070-0x0077]
Aug 14 13:39:00 stt300 kernel: [    0.586140] pnp 00:03: Plug and Play 
ACPI device, IDs PNP0b00 (active)
Aug 14 13:39:00 stt300 kernel: [    0.586305] pnp 00:04: [irq 0 disabled]
Aug 14 13:39:00 stt300 kernel: [    0.586323] pnp 00:04: [irq 8]
Aug 14 13:39:00 stt300 kernel: [    0.586329] pnp 00:04: [mem 
0xfed00000-0xfed003ff]
Aug 14 13:39:00 stt300 kernel: [    0.586400] pnp 00:04: Plug and Play 
ACPI device, IDs PNP0103 (active)
Aug 14 13:39:00 stt300 kernel: [    0.586432] pnp 00:05: [io  0x00f0]
Aug 14 13:39:00 stt300 kernel: [    0.586443] pnp 00:05: [irq 13]
Aug 14 13:39:00 stt300 kernel: [    0.586515] pnp 00:05: Plug and Play 
ACPI device, IDs PNP0c04 (active)
Aug 14 13:39:00 stt300 kernel: [    0.586545] pnp 00:06: [mem 
0xff800000-0xffffffff]
Aug 14 13:39:00 stt300 kernel: [    0.586620] pnp 00:06: Plug and Play 
ACPI device, IDs INT0800 (active)
Aug 14 13:39:00 stt300 kernel: [    0.586679] pnp 00:07: [io  0x0060]
Aug 14 13:39:00 stt300 kernel: [    0.586685] pnp 00:07: [io  0x0064]
Aug 14 13:39:00 stt300 kernel: [    0.586696] pnp 00:07: [irq 1]
Aug 14 13:39:00 stt300 kernel: [    0.586769] pnp 00:07: Plug and Play 
ACPI device, IDs PNP0303 (active)
Aug 14 13:39:00 stt300 kernel: [    0.586819] pnp 00:08: [irq 12]
Aug 14 13:39:00 stt300 kernel: [    0.586899] pnp 00:08: Plug and Play 
ACPI device, IDs SYN1e33 SYN1e00 SYN0002 PNP0f13 (active)
Aug 14 13:39:00 stt300 kernel: [    0.587082] pnp: PnP ACPI: found 9 devices
Aug 14 13:39:00 stt300 kernel: [    0.587086] ACPI: ACPI bus type pnp 
unregistered
Aug 14 13:39:00 stt300 kernel: [    0.587094] PnPBIOS: Disabled by ACPI PNP
Aug 14 13:39:00 stt300 kernel: [    0.626289] PCI: max bus depth: 1 
pci_try_num: 2
Aug 14 13:39:00 stt300 kernel: [    0.626339] pci 0000:00:1c.0: PCI 
bridge to [bus 01-01]
Aug 14 13:39:00 stt300 kernel: [    0.626347] pci 0000:00:1c.0:   bridge 
window [io  0x2000-0x2fff]
Aug 14 13:39:00 stt300 kernel: [    0.626358] pci 0000:00:1c.0:   bridge 
window [mem 0x93000000-0x93ffffff]
Aug 14 13:39:00 stt300 kernel: [    0.626368] pci 0000:00:1c.0:   bridge 
window [mem 0x90000000-0x90ffffff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.626380] pci 0000:00:1c.1: PCI 
bridge to [bus 02-02]
Aug 14 13:39:00 stt300 kernel: [    0.626388] pci 0000:00:1c.1:   bridge 
window [io  0x1000-0x1fff]
Aug 14 13:39:00 stt300 kernel: [    0.626398] pci 0000:00:1c.1:   bridge 
window [mem 0x92000000-0x92ffffff]
Aug 14 13:39:00 stt300 kernel: [    0.626407] pci 0000:00:1c.1:   bridge 
window [mem 0x91000000-0x91ffffff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.626419] pci 0000:00:1e.0: PCI 
bridge to [bus 03-03]
Aug 14 13:39:00 stt300 kernel: [    0.626424] pci 0000:00:1e.0:   bridge 
window [io  disabled]
Aug 14 13:39:00 stt300 kernel: [    0.626432] pci 0000:00:1e.0:   bridge 
window [mem disabled]
Aug 14 13:39:00 stt300 kernel: [    0.626440] pci 0000:00:1e.0:   bridge 
window [mem pref disabled]
Aug 14 13:39:00 stt300 kernel: [    0.626473] pci 0000:00:1c.0: PCI INT 
A -> GSI 16 (level, low) -> IRQ 16
Aug 14 13:39:00 stt300 kernel: [    0.626484] pci 0000:00:1c.0: setting 
latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    0.626502] pci 0000:00:1c.1: PCI INT 
B -> GSI 17 (level, low) -> IRQ 17
Aug 14 13:39:00 stt300 kernel: [    0.626511] pci 0000:00:1c.1: setting 
latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    0.626524] pci 0000:00:1e.0: setting 
latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    0.626532] pci_bus 0000:00: resource 
4 [io  0x0000-0x0cf7]
Aug 14 13:39:00 stt300 kernel: [    0.626538] pci_bus 0000:00: resource 
5 [io  0x0d00-0xffff]
Aug 14 13:39:00 stt300 kernel: [    0.626544] pci_bus 0000:00: resource 
6 [mem 0x000a0000-0x000bffff]
Aug 14 13:39:00 stt300 kernel: [    0.626551] pci_bus 0000:00: resource 
7 [mem 0x80000000-0xfebfffff]
Aug 14 13:39:00 stt300 kernel: [    0.626557] pci_bus 0000:01: resource 
0 [io  0x2000-0x2fff]
Aug 14 13:39:00 stt300 kernel: [    0.626563] pci_bus 0000:01: resource 
1 [mem 0x93000000-0x93ffffff]
Aug 14 13:39:00 stt300 kernel: [    0.626570] pci_bus 0000:01: resource 
2 [mem 0x90000000-0x90ffffff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.626576] pci_bus 0000:02: resource 
0 [io  0x1000-0x1fff]
Aug 14 13:39:00 stt300 kernel: [    0.626582] pci_bus 0000:02: resource 
1 [mem 0x92000000-0x92ffffff]
Aug 14 13:39:00 stt300 kernel: [    0.626589] pci_bus 0000:02: resource 
2 [mem 0x91000000-0x91ffffff 64bit pref]
Aug 14 13:39:00 stt300 kernel: [    0.626596] pci_bus 0000:03: resource 
4 [io  0x0000-0x0cf7]
Aug 14 13:39:00 stt300 kernel: [    0.626602] pci_bus 0000:03: resource 
5 [io  0x0d00-0xffff]
Aug 14 13:39:00 stt300 kernel: [    0.626608] pci_bus 0000:03: resource 
6 [mem 0x000a0000-0x000bffff]
Aug 14 13:39:00 stt300 kernel: [    0.626614] pci_bus 0000:03: resource 
7 [mem 0x80000000-0xfebfffff]
Aug 14 13:39:00 stt300 kernel: [    0.626762] NET: Registered protocol 
family 2
Aug 14 13:39:00 stt300 kernel: [    0.626977] IP route cache hash table 
entries: 32768 (order: 5, 131072 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.627667] TCP established hash table 
entries: 131072 (order: 8, 1048576 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.628644] TCP bind hash table 
entries: 65536 (order: 7, 524288 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.629074] TCP: Hash tables 
configured (established 131072 bind 65536)
Aug 14 13:39:00 stt300 kernel: [    0.629080] TCP reno registered
Aug 14 13:39:00 stt300 kernel: [    0.629088] UDP hash table entries: 
512 (order: 2, 16384 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.629107] UDP-Lite hash table 
entries: 512 (order: 2, 16384 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.629583] NET: Registered protocol 
family 1
Aug 14 13:39:00 stt300 kernel: [    0.629621] pci 0000:00:02.0: Boot 
video device
Aug 14 13:39:00 stt300 kernel: [    0.644096] PCI: CLS 64 bytes, default 64
Aug 14 13:39:00 stt300 kernel: [    0.644208] Unpacking initramfs...
Aug 14 13:39:00 stt300 kernel: [    0.761164] Freeing initrd memory: 
2316k freed
Aug 14 13:39:00 stt300 kernel: [    0.762851] Simple Boot Flag at 0x44 
set to 0x1
Aug 14 13:39:00 stt300 kernel: [    0.763769] audit: initializing 
netlink socket (disabled)
Aug 14 13:39:00 stt300 kernel: [    0.763803] type=2000 
audit(1313321927.756:1): initialized
Aug 14 13:39:00 stt300 kernel: [    0.795592] highmem bounce pool size: 
64 pages
Aug 14 13:39:00 stt300 kernel: [    0.795605] HugeTLB registered 2 MB 
page size, pre-allocated 0 pages
Aug 14 13:39:00 stt300 kernel: [    0.804884] VFS: Disk quotas dquot_6.5.2
Aug 14 13:39:00 stt300 kernel: [    0.805057] Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Aug 14 13:39:00 stt300 kernel: [    0.805281] msgmni has been set to 1734
Aug 14 13:39:00 stt300 kernel: [    0.805715] alg: No test for stdrng (krng)
Aug 14 13:39:00 stt300 kernel: [    0.805796] Block layer SCSI generic 
(bsg) driver version 0.4 loaded (major 253)
Aug 14 13:39:00 stt300 kernel: [    0.805804] io scheduler noop registered
Aug 14 13:39:00 stt300 kernel: [    0.805808] io scheduler deadline 
registered
Aug 14 13:39:00 stt300 kernel: [    0.805846] io scheduler cfq 
registered (default)
Aug 14 13:39:00 stt300 kernel: [    0.806039] pcieport 0000:00:1c.0: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    0.806112] pcieport 0000:00:1c.0: irq 
40 for MSI/MSI-X
Aug 14 13:39:00 stt300 kernel: [    0.806240] pcieport 0000:00:1c.1: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    0.806307] pcieport 0000:00:1c.1: irq 
41 for MSI/MSI-X
Aug 14 13:39:00 stt300 kernel: [    0.806683] ERST: Table is not found!
Aug 14 13:39:00 stt300 kernel: [    0.806713] isapnp: Scanning for PnP 
cards...
Aug 14 13:39:00 stt300 kernel: [    1.160568] isapnp: No Plug & Play 
device found
Aug 14 13:39:00 stt300 kernel: [    1.160723] Serial: 8250/16550 driver, 
4 ports, IRQ sharing enabled
Aug 14 13:39:00 stt300 kernel: [    1.161975] Linux agpgart interface v0.103
Aug 14 13:39:00 stt300 kernel: [    1.162207] agpgart-intel 
0000:00:00.0: Intel GMA3150 Chipset
Aug 14 13:39:00 stt300 kernel: [    1.162427] agpgart-intel 
0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
Aug 14 13:39:00 stt300 kernel: [    1.162687] agpgart-intel 
0000:00:00.0: detected 8192K stolen memory
Aug 14 13:39:00 stt300 kernel: [    1.162915] agpgart-intel 
0000:00:00.0: AGP aperture is 256M @ 0x80000000
Aug 14 13:39:00 stt300 kernel: [    1.163249] i8042: PNP: PS/2 
Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
Aug 14 13:39:00 stt300 kernel: [    1.168513] serio: i8042 KBD port at 
0x60,0x64 irq 1
Aug 14 13:39:00 stt300 kernel: [    1.168532] serio: i8042 AUX port at 
0x60,0x64 irq 12
Aug 14 13:39:00 stt300 kernel: [    1.168834] mousedev: PS/2 mouse 
device common for all mice
Aug 14 13:39:00 stt300 kernel: [    1.168944] rtc_cmos 00:03: RTC can 
wake from S4
Aug 14 13:39:00 stt300 kernel: [    1.169115] rtc_cmos 00:03: rtc core: 
registered rtc_cmos as rtc0
Aug 14 13:39:00 stt300 kernel: [    1.169153] rtc0: alarms up to one 
month, 242 bytes nvram, hpet irqs
Aug 14 13:39:00 stt300 kernel: [    1.169181] cpuidle: using governor ladder
Aug 14 13:39:00 stt300 kernel: [    1.169185] cpuidle: using governor menu
Aug 14 13:39:00 stt300 kernel: [    1.169830] TCP cubic registered
Aug 14 13:39:00 stt300 kernel: [    1.169937] NET: Registered protocol 
family 10
Aug 14 13:39:00 stt300 kernel: [    1.171486] Mobile IPv6
Aug 14 13:39:00 stt300 kernel: [    1.171493] NET: Registered protocol 
family 17
Aug 14 13:39:00 stt300 kernel: [    1.171503] Registering the 
dns_resolver key type
Aug 14 13:39:00 stt300 kernel: [    1.171562] Using IPI No-Shortcut mode
Aug 14 13:39:00 stt300 kernel: [    1.171788] PM: Hibernation image not 
present or could not be loaded.
Aug 14 13:39:00 stt300 kernel: [    1.171816] registered taskstats version 1
Aug 14 13:39:00 stt300 kernel: [    1.176970] rtc_cmos 00:03: setting 
system clock to 2011-08-14 11:38:48 UTC (1313321928)
Aug 14 13:39:00 stt300 kernel: [    1.177078] Initializing network drop 
monitor service
Aug 14 13:39:00 stt300 kernel: [    1.177323] Freeing unused kernel 
memory: 404k freed
Aug 14 13:39:00 stt300 kernel: [    1.177685] Write protecting the 
kernel text: 2768k
Aug 14 13:39:00 stt300 kernel: [    1.177760] Write protecting the 
kernel read-only data: 1068k
Aug 14 13:39:00 stt300 kernel: [    1.177765] NX-protecting the kernel 
data: 3376k
Aug 14 13:39:00 stt300 kernel: [    1.294585] input: AT Translated Set 2 
keyboard as /devices/platform/i8042/serio0/input/input0
Aug 14 13:39:00 stt300 kernel: [    1.352206] ACPI Warning: For 
\_TZ_.THRM._AL0: Return Package has no elements (empty) 
(20110413/nspredef-456)
Aug 14 13:39:00 stt300 kernel: [    1.352229] ACPI: [Package] has zero 
elements (f5953e00)
Aug 14 13:39:00 stt300 kernel: [    1.352316] ACPI: Invalid active0 
threshold
Aug 14 13:39:00 stt300 kernel: [    1.361502] thermal LNXTHERM:00: 
registered as thermal_zone0
Aug 14 13:39:00 stt300 kernel: [    1.361513] ACPI: Thermal Zone [THRM] 
(44 C)
Aug 14 13:39:00 stt300 kernel: [    1.369279] SCSI subsystem initialized
Aug 14 13:39:00 stt300 kernel: [    1.388653] libata version 3.00 loaded.
Aug 14 13:39:00 stt300 kernel: [    1.391239] ahci 0000:00:1f.2: version 3.0
Aug 14 13:39:00 stt300 kernel: [    1.391272] ahci 0000:00:1f.2: PCI INT 
B -> GSI 17 (level, low) -> IRQ 17
Aug 14 13:39:00 stt300 kernel: [    1.391369] ahci 0000:00:1f.2: irq 42 
for MSI/MSI-X
Aug 14 13:39:00 stt300 kernel: [    1.391557] ahci: SSS flag set, 
parallel bus scan disabled
Aug 14 13:39:00 stt300 kernel: [    1.391615] ahci 0000:00:1f.2: AHCI 
0001.0100 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
Aug 14 13:39:00 stt300 kernel: [    1.391627] ahci 0000:00:1f.2: flags: 
64bit ncq ilck stag pm led clo pmp pio slum part
Aug 14 13:39:00 stt300 kernel: [    1.391641] ahci 0000:00:1f.2: setting 
latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    1.393755] scsi0 : ahci
Aug 14 13:39:00 stt300 kernel: [    1.394119] scsi1 : ahci
Aug 14 13:39:00 stt300 kernel: [    1.394380] scsi2 : ahci
Aug 14 13:39:00 stt300 kernel: [    1.394638] scsi3 : ahci
Aug 14 13:39:00 stt300 kernel: [    1.395427] ata1: SATA max UDMA/133 
abar m1024@0x94204000 port 0x94204100 irq 42
Aug 14 13:39:00 stt300 kernel: [    1.395439] ata2: SATA max UDMA/133 
abar m1024@0x94204000 port 0x94204180 irq 42
Aug 14 13:39:00 stt300 kernel: [    1.395447] ata3: DUMMY
Aug 14 13:39:00 stt300 kernel: [    1.395453] ata4: DUMMY
Aug 14 13:39:00 stt300 kernel: [    1.760036] Refined TSC clocksource 
calibration: 1662.681 MHz.
Aug 14 13:39:00 stt300 kernel: [    1.760047] Switching to clocksource tsc
Aug 14 13:39:00 stt300 kernel: [    1.884089] ata1: SATA link up 3.0 
Gbps (SStatus 123 SControl 300)
Aug 14 13:39:00 stt300 kernel: [    1.884902] ata1.00: unexpected _GTF 
length (4)
Aug 14 13:39:00 stt300 kernel: [    1.933771] ata1.00: ATA-8: 
ST9250315AS, 0001SDM1, max UDMA/133
Aug 14 13:39:00 stt300 kernel: [    1.933778] ata1.00: 488397168 
sectors, multi 16: LBA48 NCQ (depth 31/32)
Aug 14 13:39:00 stt300 kernel: [    1.935602] ata1.00: unexpected _GTF 
length (4)
Aug 14 13:39:00 stt300 kernel: [    1.935940] ata1.00: configured for 
UDMA/133
Aug 14 13:39:00 stt300 kernel: [    1.936304] scsi 0:0:0:0: 
Direct-Access     ATA      ST9250315AS      0001 PQ: 0 ANSI: 5
Aug 14 13:39:00 stt300 kernel: [    2.256037] ata2: SATA link down 
(SStatus 0 SControl 300)
Aug 14 13:39:00 stt300 kernel: [    2.268646] sd 0:0:0:0: [sda] 
488397168 512-byte logical blocks: (250 GB/232 GiB)
Aug 14 13:39:00 stt300 kernel: [    2.268864] sd 0:0:0:0: [sda] Write 
Protect is off
Aug 14 13:39:00 stt300 kernel: [    2.268874] sd 0:0:0:0: [sda] Mode 
Sense: 00 3a 00 00
Aug 14 13:39:00 stt300 kernel: [    2.268980] sd 0:0:0:0: [sda] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 14 13:39:00 stt300 kernel: [    2.391332]  sda: sda1 sda2
Aug 14 13:39:00 stt300 kernel: [    2.392198] sd 0:0:0:0: [sda] Attached 
SCSI disk
Aug 14 13:39:00 stt300 kernel: [    2.964556] PM: Starting manual resume 
from disk
Aug 14 13:39:00 stt300 kernel: [    2.964564] PM: Hibernation image 
partition 8:1 present
Aug 14 13:39:00 stt300 kernel: [    2.964568] PM: Looking for 
hibernation image.
Aug 14 13:39:00 stt300 kernel: [    2.965033] PM: Image not found (code -22)
Aug 14 13:39:00 stt300 kernel: [    2.965037] PM: Hibernation image not 
present or could not be loaded.
Aug 14 13:39:00 stt300 kernel: [    2.975052] REISERFS (device sda2): 
found reiserfs format "3.6" with standard journal
Aug 14 13:39:00 stt300 kernel: [    2.975081] REISERFS (device sda2): 
using ordered data mode
Aug 14 13:39:00 stt300 kernel: [    2.981906] REISERFS (device sda2): 
journal params: device sda2, size 8192, journal first block 18, max 
trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 14 13:39:00 stt300 kernel: [    2.982780] REISERFS (device sda2): 
checking transaction log (sda2)
Aug 14 13:39:00 stt300 kernel: [    3.065005] REISERFS (device sda2): 
Using r5 hash to sort names
Aug 14 13:39:00 stt300 kernel: [    5.768446] ACPI: acpi_idle registered 
with cpuidle
Aug 14 13:39:00 stt300 kernel: [    5.775322] Marking TSC unstable due 
to TSC halts in idle
Aug 14 13:39:00 stt300 kernel: [    5.783618] Switching to clocksource hpet
Aug 14 13:39:00 stt300 kernel: [    5.797532] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
Aug 14 13:39:00 stt300 kernel: [    5.797550] ACPI: Power Button [PWRB]
Aug 14 13:39:00 stt300 kernel: [    5.797763] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
Aug 14 13:39:00 stt300 kernel: [    5.799241] ACPI: Lid Switch [LID0]
Aug 14 13:39:00 stt300 kernel: [    5.799519] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Aug 14 13:39:00 stt300 kernel: [    5.799536] ACPI: Power Button [PWRF]
Aug 14 13:39:00 stt300 kernel: [    5.812438] wmi: Mapper loaded
Aug 14 13:39:00 stt300 kernel: [    5.945040] ACPI: Battery Slot [BAT0] 
(battery present)
Aug 14 13:39:00 stt300 kernel: [    6.001603] r8169 Gigabit Ethernet 
driver 2.3LK-NAPI loaded
Aug 14 13:39:00 stt300 kernel: [    6.001684] r8169 0000:01:00.0: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
Aug 14 13:39:00 stt300 kernel: [    6.001825] r8169 0000:01:00.0: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    6.001849] r8169 0000:01:00.0: 
(unregistered net_device): unknown MAC, using family default
Aug 14 13:39:00 stt300 kernel: [    6.002059] r8169 0000:01:00.0: irq 43 
for MSI/MSI-X
Aug 14 13:39:00 stt300 kernel: [    6.003446] r8169 0000:01:00.0: eth0: 
RTL8101e at 0xf8306000, 68:b5:99:d3:c1:d8, XID 04000000 IRQ 43
Aug 14 13:39:00 stt300 kernel: [    6.015224] usbcore: registered new 
interface driver usbfs
Aug 14 13:39:00 stt300 kernel: [    6.015298] usbcore: registered new 
interface driver hub
Aug 14 13:39:00 stt300 kernel: [    6.015429] usbcore: registered new 
device driver usb
Aug 14 13:39:00 stt300 kernel: [    6.113107] i801_smbus 0000:00:1f.3: 
PCI INT B -> GSI 17 (level, low) -> IRQ 17
Aug 14 13:39:00 stt300 kernel: [    6.123609] ehci_hcd: USB 2.0 
'Enhanced' Host Controller (EHCI) Driver
Aug 14 13:39:00 stt300 kernel: [    6.123681] ehci_hcd 0000:00:1d.7: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
Aug 14 13:39:00 stt300 kernel: [    6.123726] ehci_hcd 0000:00:1d.7: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    6.123736] ehci_hcd 0000:00:1d.7: 
EHCI Host Controller
Aug 14 13:39:00 stt300 kernel: [    6.123839] ehci_hcd 0000:00:1d.7: new 
USB bus registered, assigned bus number 1
Aug 14 13:39:00 stt300 kernel: [    6.123903] ehci_hcd 0000:00:1d.7: 
using broken periodic workaround
Aug 14 13:39:00 stt300 kernel: [    6.123926] ehci_hcd 0000:00:1d.7: 
debug port 1
Aug 14 13:39:00 stt300 kernel: [    6.127832] ehci_hcd 0000:00:1d.7: 
cache line size of 64 is not supported
Aug 14 13:39:00 stt300 kernel: [    6.127874] ehci_hcd 0000:00:1d.7: irq 
16, io mem 0x94204400
Aug 14 13:39:00 stt300 kernel: [    6.140083] ehci_hcd 0000:00:1d.7: USB 
2.0 started, EHCI 1.00
Aug 14 13:39:00 stt300 kernel: [    6.140162] usb usb1: New USB device 
found, idVendor=1d6b, idProduct=0002
Aug 14 13:39:00 stt300 kernel: [    6.140169] usb usb1: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Aug 14 13:39:00 stt300 kernel: [    6.140174] usb usb1: Product: EHCI 
Host Controller
Aug 14 13:39:00 stt300 kernel: [    6.140179] usb usb1: Manufacturer: 
Linux 3.0.0-1-686-pae ehci_hcd
Aug 14 13:39:00 stt300 kernel: [    6.140185] usb usb1: SerialNumber: 
0000:00:1d.7
Aug 14 13:39:00 stt300 kernel: [    6.140522] hub 1-0:1.0: USB hub found
Aug 14 13:39:00 stt300 kernel: [    6.140540] hub 1-0:1.0: 8 ports detected
Aug 14 13:39:00 stt300 kernel: [    6.332220] cfg80211: Calling CRDA to 
update world regulatory domain
Aug 14 13:39:00 stt300 kernel: [    6.350867] ACPI: AC Adapter [AC] 
(off-line)
Aug 14 13:39:00 stt300 kernel: [    6.452092] usb 1-8: new high speed 
USB device number 2 using ehci_hcd
Aug 14 13:39:00 stt300 kernel: [    6.489361] input: PC Speaker as 
/devices/platform/pcspkr/input/input4
Aug 14 13:39:00 stt300 kernel: [    6.654715] usb 1-8: New USB device 
found, idVendor=174f, idProduct=1122
Aug 14 13:39:00 stt300 kernel: [    6.654729] usb 1-8: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Aug 14 13:39:00 stt300 kernel: [    6.654740] usb 1-8: Product: HP Webcam
Aug 14 13:39:00 stt300 kernel: [    6.654747] usb 1-8: Manufacturer: D-MAX
Aug 14 13:39:00 stt300 kernel: [    6.654755] usb 1-8: SerialNumber: 00
Aug 14 13:39:00 stt300 kernel: [    6.754662] HDA Intel 0000:00:1b.0: 
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug 14 13:39:00 stt300 kernel: [    6.754777] HDA Intel 0000:00:1b.0: 
irq 44 for MSI/MSI-X
Aug 14 13:39:00 stt300 kernel: [    6.754842] HDA Intel 0000:00:1b.0: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    6.796496] uhci_hcd: USB Universal 
Host Controller Interface driver
Aug 14 13:39:00 stt300 kernel: [    6.815218] brcmutil: module is from 
the staging directory, the quality is unknown, you have been warned.
Aug 14 13:39:00 stt300 kernel: [    6.820988] input: HP WMI hotkeys as 
/devices/virtual/input/input5
Aug 14 13:39:00 stt300 kernel: [    6.857159] [drm] Initialized drm 
1.1.0 20060810
Aug 14 13:39:00 stt300 kernel: [    7.006096] input: HDA Digital PCBeep 
as /devices/pci0000:00/0000:00:1b.0/input/input6
Aug 14 13:39:00 stt300 kernel: [    7.024481] input: HDA Intel Mic at 
Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
Aug 14 13:39:00 stt300 kernel: [    7.024782] input: HDA Intel HP Out at 
Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
Aug 14 13:39:00 stt300 kernel: [    7.025452] uhci_hcd 0000:00:1d.0: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
Aug 14 13:39:00 stt300 kernel: [    7.025477] uhci_hcd 0000:00:1d.0: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    7.025485] uhci_hcd 0000:00:1d.0: 
UHCI Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.025510] uhci_hcd 0000:00:1d.0: new 
USB bus registered, assigned bus number 2
Aug 14 13:39:00 stt300 kernel: [    7.025555] uhci_hcd 0000:00:1d.0: irq 
16, io base 0x00003080
Aug 14 13:39:00 stt300 kernel: [    7.025647] usb usb2: New USB device 
found, idVendor=1d6b, idProduct=0001
Aug 14 13:39:00 stt300 kernel: [    7.025654] usb usb2: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Aug 14 13:39:00 stt300 kernel: [    7.025660] usb usb2: Product: UHCI 
Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.025665] usb usb2: Manufacturer: 
Linux 3.0.0-1-686-pae uhci_hcd
Aug 14 13:39:00 stt300 kernel: [    7.025670] usb usb2: SerialNumber: 
0000:00:1d.0
Aug 14 13:39:00 stt300 kernel: [    7.025971] hub 2-0:1.0: USB hub found
Aug 14 13:39:00 stt300 kernel: [    7.025989] hub 2-0:1.0: 2 ports detected
Aug 14 13:39:00 stt300 kernel: [    7.026216] uhci_hcd 0000:00:1d.1: PCI 
INT C -> GSI 18 (level, low) -> IRQ 18
Aug 14 13:39:00 stt300 kernel: [    7.026238] uhci_hcd 0000:00:1d.1: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    7.026249] uhci_hcd 0000:00:1d.1: 
UHCI Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.026286] uhci_hcd 0000:00:1d.1: new 
USB bus registered, assigned bus number 3
Aug 14 13:39:00 stt300 kernel: [    7.026373] uhci_hcd 0000:00:1d.1: irq 
18, io base 0x00003060
Aug 14 13:39:00 stt300 kernel: [    7.026494] usb usb3: New USB device 
found, idVendor=1d6b, idProduct=0001
Aug 14 13:39:00 stt300 kernel: [    7.026504] usb usb3: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Aug 14 13:39:00 stt300 kernel: [    7.026511] usb usb3: Product: UHCI 
Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.026518] usb usb3: Manufacturer: 
Linux 3.0.0-1-686-pae uhci_hcd
Aug 14 13:39:00 stt300 kernel: [    7.026525] usb usb3: SerialNumber: 
0000:00:1d.1
Aug 14 13:39:00 stt300 kernel: [    7.026931] hub 3-0:1.0: USB hub found
Aug 14 13:39:00 stt300 kernel: [    7.026953] hub 3-0:1.0: 2 ports detected
Aug 14 13:39:00 stt300 kernel: [    7.027180] uhci_hcd 0000:00:1d.2: PCI 
INT B -> GSI 17 (level, low) -> IRQ 17
Aug 14 13:39:00 stt300 kernel: [    7.027202] uhci_hcd 0000:00:1d.2: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    7.027213] uhci_hcd 0000:00:1d.2: 
UHCI Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.027240] uhci_hcd 0000:00:1d.2: new 
USB bus registered, assigned bus number 4
Aug 14 13:39:00 stt300 kernel: [    7.027325] uhci_hcd 0000:00:1d.2: irq 
17, io base 0x00003040
Aug 14 13:39:00 stt300 kernel: [    7.027449] usb usb4: New USB device 
found, idVendor=1d6b, idProduct=0001
Aug 14 13:39:00 stt300 kernel: [    7.027459] usb usb4: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Aug 14 13:39:00 stt300 kernel: [    7.027466] usb usb4: Product: UHCI 
Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.027473] usb usb4: Manufacturer: 
Linux 3.0.0-1-686-pae uhci_hcd
Aug 14 13:39:00 stt300 kernel: [    7.027480] usb usb4: SerialNumber: 
0000:00:1d.2
Aug 14 13:39:00 stt300 kernel: [    7.027871] hub 4-0:1.0: USB hub found
Aug 14 13:39:00 stt300 kernel: [    7.027891] hub 4-0:1.0: 2 ports detected
Aug 14 13:39:00 stt300 kernel: [    7.028179] uhci_hcd 0000:00:1d.3: PCI 
INT D -> GSI 19 (level, low) -> IRQ 19
Aug 14 13:39:00 stt300 kernel: [    7.028204] uhci_hcd 0000:00:1d.3: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    7.028214] uhci_hcd 0000:00:1d.3: 
UHCI Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.028244] uhci_hcd 0000:00:1d.3: new 
USB bus registered, assigned bus number 5
Aug 14 13:39:00 stt300 kernel: [    7.028333] uhci_hcd 0000:00:1d.3: irq 
19, io base 0x00003020
Aug 14 13:39:00 stt300 kernel: [    7.028452] usb usb5: New USB device 
found, idVendor=1d6b, idProduct=0001
Aug 14 13:39:00 stt300 kernel: [    7.028462] usb usb5: New USB device 
strings: Mfr=3, Product=2, SerialNumber=1
Aug 14 13:39:00 stt300 kernel: [    7.028470] usb usb5: Product: UHCI 
Host Controller
Aug 14 13:39:00 stt300 kernel: [    7.028477] usb usb5: Manufacturer: 
Linux 3.0.0-1-686-pae uhci_hcd
Aug 14 13:39:00 stt300 kernel: [    7.028484] usb usb5: SerialNumber: 
0000:00:1d.3
Aug 14 13:39:00 stt300 kernel: [    7.028912] hub 5-0:1.0: USB hub found
Aug 14 13:39:00 stt300 kernel: [    7.028930] hub 5-0:1.0: 2 ports detected
Aug 14 13:39:00 stt300 kernel: [    7.138559] i915 0000:00:02.0: power 
state changed by ACPI to D0
Aug 14 13:39:00 stt300 kernel: [    7.138571] i915 0000:00:02.0: power 
state changed by ACPI to D0
Aug 14 13:39:00 stt300 kernel: [    7.138584] i915 0000:00:02.0: PCI INT 
A -> GSI 16 (level, low) -> IRQ 16
Aug 14 13:39:00 stt300 kernel: [    7.138593] i915 0000:00:02.0: setting 
latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    7.194697] i915 0000:00:02.0: irq 45 
for MSI/MSI-X
Aug 14 13:39:00 stt300 kernel: [    7.194711] [drm] Supports vblank 
timestamp caching Rev 1 (10.10.2010).
Aug 14 13:39:00 stt300 kernel: [    7.194716] [drm] Driver supports 
precise vblank timestamp query.
Aug 14 13:39:00 stt300 kernel: [    7.194806] vgaarb: device changed 
decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Aug 14 13:39:00 stt300 kernel: [    7.255232] brcmsmac: module is from 
the staging directory, the quality is unknown, you have been warned.
Aug 14 13:39:00 stt300 kernel: [    7.266179] brcmsmac 0000:02:00.0: bus 
2 slot 0 func 0 irq 10
Aug 14 13:39:00 stt300 kernel: [    7.266215] brcmsmac 0000:02:00.0: PCI 
INT A -> GSI 17 (level, low) -> IRQ 17
Aug 14 13:39:00 stt300 kernel: [    7.266234] brcmsmac 0000:02:00.0: 
setting latency timer to 64
Aug 14 13:39:00 stt300 kernel: [    7.313284] Linux media interface: v0.10
Aug 14 13:39:00 stt300 kernel: [    7.324455] Linux video capture 
interface: v2.00
Aug 14 13:39:00 stt300 kernel: [    7.338115] uvcvideo: Found UVC 1.00 
device HP Webcam (174f:1122)
Aug 14 13:39:00 stt300 kernel: [    7.351556] input: HP Webcam as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input9
Aug 14 13:39:00 stt300 kernel: [    7.351796] usbcore: registered new 
interface driver uvcvideo
Aug 14 13:39:00 stt300 kernel: [    7.351804] USB Video Class driver 
(v1.1.0)
Aug 14 13:39:00 stt300 kernel: [    7.518589] [drm] initialized overlay 
support
Aug 14 13:39:00 stt300 kernel: [    7.539074] fbcon: inteldrmfb (fb0) is 
primary device
Aug 14 13:39:00 stt300 kernel: [    7.588281] Console: switching to 
colour frame buffer device 128x37
Aug 14 13:39:00 stt300 kernel: [    7.597366] fb0: inteldrmfb frame 
buffer device
Aug 14 13:39:00 stt300 kernel: [    7.597371] drm: registered panic notifier
Aug 14 13:39:00 stt300 kernel: [    7.615502] acpi device:21: registered 
as cooling_device2
Aug 14 13:39:00 stt300 kernel: [    7.616165] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
Aug 14 13:39:00 stt300 kernel: [    7.616336] ACPI: Video Device [OVGA] 
(multi-head: yes  rom: no  post: no)
Aug 14 13:39:00 stt300 kernel: [    7.616480] [drm] Initialized i915 
1.6.0 20080730 for 0000:00:02.0 on minor 0
Aug 14 13:39:00 stt300 kernel: [    7.815387] Synaptics Touchpad, model: 
1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xa40000/0xa0400
Aug 14 13:39:00 stt300 kernel: [    7.861970] input: SynPS/2 Synaptics 
TouchPad as /devices/platform/i8042/serio1/input/input11
Aug 14 13:39:00 stt300 kernel: [    7.905114] ieee80211 phy0: Selected 
rate control algorithm 'minstrel_ht'
Aug 14 13:39:00 stt300 kernel: [    8.562929] cfg80211: World regulatory 
domain updated:
Aug 14 13:39:00 stt300 kernel: [    8.562937] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:39:00 stt300 kernel: [    8.562944] cfg80211:     (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.562951] cfg80211:     (2457000 KHz 
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.562957] cfg80211:     (2474000 KHz 
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.562963] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.562970] cfg80211:     (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.562998] cfg80211: Calling CRDA for 
country: US
Aug 14 13:39:00 stt300 kernel: [    8.575099] cfg80211: Regulatory 
domain changed to country: US
Aug 14 13:39:00 stt300 kernel: [    8.575107] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:39:00 stt300 kernel: [    8.575114] cfg80211:     (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.575121] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.575127] cfg80211:     (5250000 KHz 
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.575133] cfg80211:     (5490000 KHz 
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.575140] cfg80211:     (5650000 KHz 
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.575146] cfg80211:     (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.617805] cfg80211: Calling CRDA for 
country: EU
Aug 14 13:39:00 stt300 kernel: [    8.629409] cfg80211: Regulatory 
domain changed to country: EU
Aug 14 13:39:00 stt300 kernel: [    8.629417] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:39:00 stt300 kernel: [    8.629424] cfg80211:     (2402000 KHz 
- 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.629430] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.629436] cfg80211:     (5250000 KHz 
- 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:39:00 stt300 kernel: [    8.629442] cfg80211:     (5490000 KHz 
- 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Aug 14 13:39:00 stt300 kernel: [   10.064927] Adding 3905532k swap on 
/dev/sda1.  Priority:-1 extents:1 across:3905532k
Aug 14 13:39:00 stt300 kernel: [   10.494607] loop: module loaded
Aug 14 13:39:00 stt300 kernel: [   12.173978] fuse init (API version 7.16)
Aug 14 13:39:01 stt300 kernel: [   13.994612] input: ACPI Virtual 
Keyboard Device as /devices/virtual/input/input12
Aug 14 13:39:01 stt300 NetworkManager[1181]: <info> NetworkManager 
(version 0.8.4.0) is starting...
Aug 14 13:39:01 stt300 NetworkManager[1181]: <info> Read config file 
/etc/NetworkManager/NetworkManager.conf
Aug 14 13:39:01 stt300 NetworkManager[1181]: <info> trying to start the 
modem manager...
Aug 14 13:39:01 stt300 dbus[1166]: [system] Activating service 
name='org.freedesktop.ModemManager' (using servicehelper)
Aug 14 13:39:01 stt300 modem-manager[1190]: <info>  ModemManager 
(version 0.4.997) starting...
Aug 14 13:39:01 stt300 dbus[1166]: [system] Successfully activated 
service 'org.freedesktop.ModemManager'
Aug 14 13:39:02 stt300 dbus[1166]: [system] Activating service 
name='org.freedesktop.PolicyKit1' (using servicehelper)
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Longcheer
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Novatel
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin SimTech
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Nokia
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Gobi
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Option
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Sierra
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin AnyData
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Generic
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin MotoC
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Option 
High-Speed
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin 
Ericsson MBM
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Samsung
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Huawei
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin ZTE
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin X22X
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Linktop
Aug 14 13:39:02 stt300 modem-manager[1190]: <info>  Loaded plugin Wavecom
Aug 14 13:39:02 stt300 polkitd[1195]: started daemon version 0.102 using 
authority implementation `local' version `0.102'
Aug 14 13:39:02 stt300 dbus[1166]: [system] Successfully activated 
service 'org.freedesktop.PolicyKit1'
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> monitoring kernel 
firmware directory '/lib/firmware'.
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: init!
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
update_system_hostname
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPluginIfupdown: 
management mode: unmanaged
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
devices added (path: 
/sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net/eth0, iface: eth0)
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
device added (path: 
/sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net/eth0, iface: 
eth0): no ifupdown configuration found.
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
devices added (path: 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: wlan0)
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
device added (path: 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: 
wlan0): no ifupdown configuration found.
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
devices added (path: /sys/devices/virtual/net/lo, iface: lo)
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
device added (path: /sys/devices/virtual/net/lo, iface: lo): no ifupdown 
configuration found.
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: end 
_init.
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> Loaded plugin 
ifupdown: (C) 2008 Canonical Ltd.  To report bugs please use the 
NetworkManager mailing list.
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> Loaded plugin 
keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the 
NetworkManager mailing list.
Aug 14 13:39:02 stt300 NetworkManager[1181]:    Ifupdown: get unmanaged 
devices count: 0
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
(148923920) ... get_connections.
Aug 14 13:39:02 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
(148923920) ... get_connections (managed=false): return empty list.
Aug 14 13:39:02 stt300 NetworkManager[1181]:    Ifupdown: get unmanaged 
devices count: 0
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> found WiFi radio 
killswitch rfkill1 (at 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/ieee80211/phy0/rfkill1) (driver 
<unknown>)
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> found WiFi radio 
killswitch rfkill0 (at /sys/devices/platform/hp-wmi/rfkill/rfkill0) 
(driver hp-wmi)
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> WiFi enabled by 
radio killswitch; enabled by state file
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> WWAN enabled by 
radio killswitch; enabled by state file
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> WiMAX enabled by 
radio killswitch; enabled by state file
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> Networking is 
enabled by state file
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): carrier is OFF
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): new Ethernet 
device (driver: 'r8169' ifindex: 2)
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): exported as 
/org/freedesktop/NetworkManager/Devices/0
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): now managed
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): device state 
change: 1 -> 2 (reason 2)
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): bringing up 
device.
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): preparing 
device.
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (eth0): deactivating 
device (reason: 2).
Aug 14 13:39:02 stt300 kernel: [   15.481126] r8169 0000:01:00.0: eth0: 
link down
Aug 14 13:39:02 stt300 kernel: [   15.481524] ADDRCONF(NETDEV_UP): eth0: 
link is not ready
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> Added default wired 
connection 'Auto eth0' for 
/sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net/eth0
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): driver 
supports SSID scans (scan_capa 0x01).
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): new 802.11 
WiFi device (driver: 'brcmsmac' ifindex: 3)
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): exported as 
/org/freedesktop/NetworkManager/Devices/1
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): now managed
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 1 -> 2 (reason 2)
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): bringing up 
device.
Aug 14 13:39:02 stt300 kernel: [   15.571728] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: true (implement)
Aug 14 13:39:02 stt300 kernel: [   15.575016] ieee80211 phy0: 
wl_ops_config: change monitor mode: false (implement)
Aug 14 13:39:02 stt300 kernel: [   15.578639] ieee80211 phy0: 
wl_ops_config: change power-save mode: false (implement)
Aug 14 13:39:02 stt300 kernel: [   15.583276] ieee80211 phy0: 
wl_ops_bss_info_changed: qos enabled: false (implement)
Aug 14 13:39:02 stt300 kernel: [   15.587298] ADDRCONF(NETDEV_UP): 
wlan0: link is not ready
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): preparing 
device.
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> (wlan0): 
deactivating device (reason: 2).
Aug 14 13:39:02 stt300 NetworkManager[1181]: 
supplicant_interface_acquire: assertion `mgr_state == 
NM_SUPPLICANT_MANAGER_STATE_IDLE' failed
Aug 14 13:39:02 stt300 NetworkManager[1181]: <warn> 
/sys/devices/virtual/net/lo: couldn't determine device driver; ignoring...
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> modem-manager is now 
available
Aug 14 13:39:02 stt300 NetworkManager[1181]: <warn> bluez error getting 
default adapter: The name org.bluez was not provided by any .service files
Aug 14 13:39:02 stt300 NetworkManager[1181]: <info> Trying to start the 
supplicant...
Aug 14 13:39:02 stt300 dbus[1166]: [system] Activating service 
name='fi.epitest.hostap.WPASupplicant' (using servicehelper)
Aug 14 13:39:03 stt300 dbus[1166]: [system] Successfully activated 
service 'fi.epitest.hostap.WPASupplicant'
Aug 14 13:39:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
manager state:  down -> idle
Aug 14 13:39:03 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 2 -> 3 (reason 0)
Aug 14 13:39:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
interface state:  starting -> ready
Aug 14 13:39:03 stt300 kernel: [   15.814384] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: false (implement)
Aug 14 13:39:03 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:39:04 stt300 acpid: starting up with netlink and the input layer
Aug 14 13:39:04 stt300 acpid: 42 rules loaded
Aug 14 13:39:04 stt300 acpid: waiting for events: event logging is off
Aug 14 13:39:04 stt300 kernel: [   17.404728] apm: BIOS not found.
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Found user 'avahi' (UID 105) 
and group 'avahi' (GID 110).
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Successfully dropped root 
privileges.
Aug 14 13:39:05 stt300 avahi-daemon[1269]: avahi-daemon 0.6.30 starting up.
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Successfully called chroot().
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Successfully dropped 
remaining capabilities.
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Loading service file 
/services/udisks.service.
Aug 14 13:39:05 stt300 acpid: client connected from 1237[0:0]
Aug 14 13:39:05 stt300 acpid: 1 client rule loaded
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Network interface enumeration 
completed.
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Registering HINFO record with 
values 'I686'/'LINUX'.
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Server startup complete. Host 
name is stt300.local. Local service cookie is 3365141641.
Aug 14 13:39:05 stt300 avahi-daemon[1269]: Service "stt300" 
(/services/udisks.service) successfully established.
Aug 14 13:39:05 stt300 bluetoothd[1280]: Bluetooth daemon 4.94
Aug 14 13:39:05 stt300 bluetoothd[1280]: Starting SDP server
Aug 14 13:39:05 stt300 kernel: [   18.522557] Bluetooth: Core ver 2.16
Aug 14 13:39:05 stt300 kernel: [   18.522637] NET: Registered protocol 
family 31
Aug 14 13:39:05 stt300 kernel: [   18.522644] Bluetooth: HCI device and 
connection manager initialized
Aug 14 13:39:05 stt300 kernel: [   18.522651] Bluetooth: HCI socket 
layer initialized
Aug 14 13:39:05 stt300 kernel: [   18.522656] Bluetooth: L2CAP socket 
layer initialized
Aug 14 13:39:05 stt300 kernel: [   18.522762] Bluetooth: SCO socket 
layer initialized
Aug 14 13:39:05 stt300 kernel: [   18.552815] Bluetooth: BNEP (Ethernet 
Emulation) ver 1.3
Aug 14 13:39:05 stt300 kernel: [   18.552823] Bluetooth: BNEP filters: 
protocol multicast
Aug 14 13:39:05 stt300 kernel: [   18.590539] Bluetooth: RFCOMM TTY 
layer initialized
Aug 14 13:39:05 stt300 kernel: [   18.590553] Bluetooth: RFCOMM socket 
layer initialized
Aug 14 13:39:05 stt300 kernel: [   18.590559] Bluetooth: RFCOMM ver 1.11
Aug 14 13:39:05 stt300 NetworkManager[1181]: <warn> bluez error getting 
default adapter: No such adapter
Aug 14 13:39:06 stt300 /usr/sbin/cron[1342]: (CRON) INFO (pidfile fd = 3)
Aug 14 13:39:06 stt300 /usr/sbin/cron[1343]: (CRON) STARTUP (fork ok)
Aug 14 13:39:06 stt300 /usr/sbin/cron[1343]: (CRON) INFO (Running 
@reboot jobs)
Aug 14 13:39:07 stt300 kernel: [   20.145048] lp: driver loaded but no 
devices found
Aug 14 13:39:07 stt300 udev-configure-printer: add /module/lp
Aug 14 13:39:07 stt300 udev-configure-printer: Failed to get parent
Aug 14 13:39:07 stt300 kernel: [   20.567047] ppdev: user-space parallel 
port driver
Aug 14 13:39:09 stt300 dbus[1166]: [system] Activating service 
name='org.freedesktop.ConsoleKit' (using servicehelper)
Aug 14 13:39:10 stt300 dbus[1166]: [system] Successfully activated 
service 'org.freedesktop.ConsoleKit'
Aug 14 13:39:11 stt300 kernel: [   24.039332] cpufreq-nforce2: No 
nForce2 chipset.
Aug 14 13:39:11 stt300 kernel: [   24.200436] p4-clockmod: Warning: 
EST-capable CPU detected. The acpi-cpufreq module offers voltage scaling 
in addition to frequency scaling. You should use that instead of 
p4-clockmod, if possible.
Aug 14 13:39:11 stt300 kernel: [   24.200502] ondemand governor failed, 
too long transition latency of HW, fallback to performance governor
Aug 14 13:39:11 stt300 kernel: [   24.200543] p4-clockmod: P4/Xeon(TM) 
CPU On-Demand Clock Modulation available
Aug 14 13:39:12 stt300 kernel: [   24.676635] powernow: This module only 
works with AMD K7 CPUs
Aug 14 13:39:13 stt300 kernel: [   25.683356] ondemand governor failed, 
too long transition latency of HW, fallback to performance governor
Aug 14 13:39:13 stt300 kernel: [   25.687148] ondemand governor failed, 
too long transition latency of HW, fallback to performance governor
Aug 14 13:39:16 stt300 dbus[1166]: [system] Activating service 
name='org.freedesktop.UPower' (using servicehelper)
Aug 14 13:39:16 stt300 dbus[1166]: [system] Successfully activated 
service 'org.freedesktop.UPower'
Aug 14 13:39:19 stt300 dbus[1166]: [system] Activating service 
name='org.freedesktop.UDisks' (using servicehelper)
Aug 14 13:39:19 stt300 dbus[1166]: [system] Successfully activated 
service 'org.freedesktop.UDisks'
Aug 14 13:39:23 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:39:25 stt300 dbus[1166]: [system] Activating service 
name='org.gnome.ClockApplet.Mechanism' (using servicehelper)
Aug 14 13:39:26 stt300 dbus[1166]: [system] Successfully activated 
service 'org.gnome.ClockApplet.Mechanism'
Aug 14 13:39:31 stt300 dbus[1166]: [system] Activating service 
name='org.debian.apt' (using servicehelper)
Aug 14 13:39:33 stt300 AptDaemon: INFO: Initializing daemon
Aug 14 13:39:33 stt300 dbus[1166]: [system] Successfully activated 
service 'org.debian.apt'
Aug 14 13:39:53 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
starting connection 'Auto WLAN_B5'
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 3 -> 4 (reason 0)
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): access point 'Auto WLAN_B5' has security, but secrets 
are required.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:00 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:00 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:01 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:01 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:01 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:02 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:02 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:02 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:03 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:04 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:04 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:04 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:05 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:05 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:05 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:06 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:06 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:06 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:07 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:07 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:07 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:08 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:08 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:08 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:09 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:09 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:09 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:10 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:10 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:10 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:11 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:12 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:13 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:14 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:15 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:16 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:17 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:18 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:19 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:20 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:21 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:22 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:23 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:24 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:25 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:26 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): association took too long.
Aug 14 13:40:26 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:40:26 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): asking for new secrets
Aug 14 13:40:26 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:27 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:28 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:40:29 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:30 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:31 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:32 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:33 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:34 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:35 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:36 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:37 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:38 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:38 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:38 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:39 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:39 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:39 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:40 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:40 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:40 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:41 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:41 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:41 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:42 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:42 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:42 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:43 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:43 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:43 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:44 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:44 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:44 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:45 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:45 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:45 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:46 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:46 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:46 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:47 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:47 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:47 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:48 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:48 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:48 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:49 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:49 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:49 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:50 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:50 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:50 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:51 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:51 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:51 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:52 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:52 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:52 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:53 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:53 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:53 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:54 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): association took too long.
Aug 14 13:40:54 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:40:54 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): asking for new secrets
Aug 14 13:40:54 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:54 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:54 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:55 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:55 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:55 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:56 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:56 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:56 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:40:57 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:57 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:58 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:58 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:58 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:40:59 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:40:59 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:40:59 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:00 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:00 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:00 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:01 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:01 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:01 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:02 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:02 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:02 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:03 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:04 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:04 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:04 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:05 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:05 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:05 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:06 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:06 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:06 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:07 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:07 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:07 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:08 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:08 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:08 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:09 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:09 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:09 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:10 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:10 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:10 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:11 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:12 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:13 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:14 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:15 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:16 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:17 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:18 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:19 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:20 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:21 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:22 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): association took too long.
Aug 14 13:41:22 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:41:22 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): asking for new secrets
Aug 14 13:41:22 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:23 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:24 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:41:25 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:26 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:27 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:28 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:29 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:30 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:31 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:32 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:33 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:34 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:35 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:41:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:41:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:41:36 stt300 wpa_supplicant[1204]: Trying to associate with 
00:23:f8:9d:ad:11 (SSID='WLAN_B5' freq=2437 MHz)
Aug 14 13:41:36 stt300 kernel: [  169.077763] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: true (implement)
Aug 14 13:41:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> associating
Aug 14 13:41:36 stt300 kernel: [  169.082536] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: false (implement)
Aug 14 13:41:36 stt300 kernel: [  169.082553] wlan0: authenticate with 
00:23:f8:9d:ad:11 (try 1)
Aug 14 13:41:36 stt300 kernel: [  169.085718] wlan0: authenticated
Aug 14 13:41:36 stt300 kernel: [  169.085783] wlan0: associate with 
00:23:f8:9d:ad:11 (try 1)
Aug 14 13:41:36 stt300 wpa_supplicant[1204]: Associated with 
00:23:f8:9d:ad:11
Aug 14 13:41:36 stt300 kernel: [  169.092294] wlan0: RX AssocResp from 
00:23:f8:9d:ad:11 (capab=0x471 status=0 aid=1)
Aug 14 13:41:36 stt300 kernel: [  169.092304] wlan0: associated
Aug 14 13:41:36 stt300 kernel: [  169.094072] ieee80211 phy0: 
wl_ops_bss_info_changed: qos enabled: false (implement)
Aug 14 13:41:36 stt300 kernel: [  169.094089] ieee80211 phy0: brcmsmac: 
wl_ops_bss_info_changed: associated
Aug 14 13:41:36 stt300 kernel: [  169.094120] ieee80211 phy0: 
wl_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
Aug 14 13:41:36 stt300 kernel: [  169.094637] ADDRCONF(NETDEV_CHANGE): 
wlan0: link becomes ready
Aug 14 13:41:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  associating -> associated
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  associated -> 4-way handshake
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  4-way handshake -> group handshake
Aug 14 13:41:37 stt300 wpa_supplicant[1204]: WPA: Key negotiation 
completed with 00:23:f8:9d:ad:11 [PTK=TKIP GTK=TKIP]
Aug 14 13:41:37 stt300 wpa_supplicant[1204]: CTRL-EVENT-CONNECTED - 
Connection to 00:23:f8:9d:ad:11 completed (auth) [id=3 id_str=]
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  group handshake -> completed
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected 
to wireless network 'WLAN_B5'.
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 3 of 5 (IP Configure Start) scheduled.
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 3 of 5 (IP Configure Start) started...
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 7 (reason 0)
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Beginning DHCPv4 transaction (timeout in 45 seconds)
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> dhclient started 
with pid 2175
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 3 of 5 (IP Configure Start) complete.
Aug 14 13:41:37 stt300 dhclient: Internet Systems Consortium DHCP Client 
4.1.1-P1
Aug 14 13:41:37 stt300 dhclient: Copyright 2004-2010 Internet Systems 
Consortium.
Aug 14 13:41:37 stt300 dhclient: All rights reserved.
Aug 14 13:41:37 stt300 dhclient: For info, please visit 
https://www.isc.org/software/dhcp/
Aug 14 13:41:37 stt300 dhclient:
Aug 14 13:41:37 stt300 avahi-daemon[1269]: Joining mDNS multicast group 
on interface wlan0.IPv6 with address fe80::ae81:12ff:fe34:6963.
Aug 14 13:41:37 stt300 avahi-daemon[1269]: New relevant interface 
wlan0.IPv6 for mDNS.
Aug 14 13:41:37 stt300 avahi-daemon[1269]: Registering new address 
record for fe80::ae81:12ff:fe34:6963 on wlan0.*.
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> (wlan0): DHCPv4 
state changed nbi -> preinit
Aug 14 13:41:37 stt300 dhclient: Listening on LPF/wlan0/ac:81:12:34:69:63
Aug 14 13:41:37 stt300 dhclient: Sending on   LPF/wlan0/ac:81:12:34:69:63
Aug 14 13:41:37 stt300 dhclient: Sending on   Socket/fallback
Aug 14 13:41:37 stt300 dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 
port 67
Aug 14 13:41:37 stt300 dhclient: DHCPACK from 192.168.0.79
Aug 14 13:41:37 stt300 dhclient: bound to 192.168.0.155 -- renewal in 
39507 seconds.
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> (wlan0): DHCPv4 
state changed preinit -> reboot
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 4 of 5 (IP4 Configure Get) scheduled...
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 4 of 5 (IP4 Configure Get) started...
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info>   address 192.168.0.155
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info>   prefix 24 
(255.255.255.0)
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info>   gateway 192.168.0.79
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info>   nameserver 
'80.58.0.33'
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info>   nameserver 
'80.58.32.94'
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info>   domain name 'lan'
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Scheduling stage 5
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 5 of 5 (IP Configure Commit) scheduled...
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Done scheduling stage 5
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 4 of 5 (IP4 Configure Get) complete.
Aug 14 13:41:37 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 5 of 5 (IP Configure Commit) started...
Aug 14 13:41:37 stt300 avahi-daemon[1269]: Joining mDNS multicast group 
on interface wlan0.IPv4 with address 192.168.0.155.
Aug 14 13:41:38 stt300 kernel: [  170.679777] ieee80211 phy0: 
wl_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
Aug 14 13:41:37 stt300 avahi-daemon[1269]: New relevant interface 
wlan0.IPv4 for mDNS.
Aug 14 13:41:37 stt300 avahi-daemon[1269]: Registering new address 
record for 192.168.0.155 on wlan0.IPv4.
Aug 14 13:41:39 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 7 -> 8 (reason 0)
Aug 14 13:41:39 stt300 NetworkManager[1181]: <info> (wlan0): roamed from 
BSSID 00:23:F8:9D:AD:11 (WLAN_B5) to 00:23:F8:9D:AD:11 (WLAN_B5)
Aug 14 13:41:39 stt300 NetworkManager[1181]: <info> Policy set 'Auto 
WLAN_B5' (wlan0) as default for IPv4 routing and DNS.
Aug 14 13:41:39 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
successful, device activated.
Aug 14 13:41:39 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 5 of 5 (IP Configure Commit) complete.
Aug 14 13:41:39 stt300 dbus[1166]: [system] Activating service 
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Aug 14 13:41:39 stt300 dbus[1166]: [system] Successfully activated 
service 'org.freedesktop.nm_dispatcher'
Aug 14 13:41:46 stt300 kernel: [  179.600114] wlan0: no IPv6 routers present
Aug 14 13:43:57 stt300 anacron[2444]: Anacron 2.3 started on 2011-08-14
Aug 14 13:43:57 stt300 anacron[2444]: Normal exit (0 jobs run)
Aug 14 13:44:34 stt300 AptDaemon: INFO: Quiting due to inactivity
Aug 14 13:44:34 stt300 AptDaemon: INFO: Shutdown was requested

Aug 14 13:50:19 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 8 -> 3 (reason 39)
Aug 14 13:50:19 stt300 NetworkManager[1181]: <info> (wlan0): 
deactivating device (reason: 39).
Aug 14 13:50:19 stt300 NetworkManager[1181]: <info> (wlan0): canceled 
DHCP transaction, DHCP client pid 2175
Aug 14 13:50:19 stt300 kernel: [  692.402985] ieee80211 phy0: 
wl_ops_bss_info_changed: qos enabled: false (implement)
Aug 14 13:50:19 stt300 kernel: [  692.403004] ieee80211 phy0: brcmsmac: 
wl_ops_bss_info_changed: disassociated
Aug 14 13:50:19 stt300 kernel: [  692.403020] ieee80211 phy0: 
wl_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
Aug 14 13:50:19 stt300 kernel: [  692.403031] wlan0: deauthenticating 
from 00:23:f8:9d:ad:11 by local choice (reason=3)
Aug 14 13:50:19 stt300 kernel: [  692.452098] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: true (implement)
Aug 14 13:50:21 stt300 kernel: [  693.764138] cfg80211: Calling CRDA to 
update world regulatory domain
Aug 14 13:50:21 stt300 avahi-daemon[1269]: Withdrawing address record 
for 192.168.0.155 on wlan0.
Aug 14 13:50:21 stt300 wpa_supplicant[1204]: CTRL-EVENT-DISCONNECTED 
bssid=00:00:00:00:00:00 reason=0
Aug 14 13:50:21 stt300 avahi-daemon[1269]: Leaving mDNS multicast group 
on interface wlan0.IPv4 with address 192.168.0.155.
Aug 14 13:50:21 stt300 avahi-daemon[1269]: Interface wlan0.IPv4 no 
longer relevant for mDNS.
Aug 14 13:50:21 stt300 dbus[1166]: [system] Activating service 
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Aug 14 13:50:21 stt300 kernel: [  693.796897] cfg80211: World regulatory 
domain updated:
Aug 14 13:50:21 stt300 kernel: [  693.796908] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:50:21 stt300 kernel: [  693.796918] cfg80211:     (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.796928] cfg80211:     (2457000 KHz 
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.796937] cfg80211:     (2474000 KHz 
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.796946] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.796955] cfg80211:     (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.796996] cfg80211: Calling CRDA for 
country: EU
Aug 14 13:50:21 stt300 dbus[1166]: [system] Successfully activated 
service 'org.freedesktop.nm_dispatcher'
Aug 14 13:50:21 stt300 kernel: [  693.831233] cfg80211: Regulatory 
domain changed to country: EU
Aug 14 13:50:21 stt300 kernel: [  693.831243] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:50:21 stt300 kernel: [  693.831253] cfg80211:     (2402000 KHz 
- 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.831262] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.831271] cfg80211:     (5250000 KHz 
- 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:50:21 stt300 kernel: [  693.831280] cfg80211:     (5490000 KHz 
- 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Aug 14 13:50:39 stt300 avahi-daemon[1269]: Interface wlan0.IPv6 no 
longer relevant for mDNS.
Aug 14 13:50:39 stt300 avahi-daemon[1269]: Leaving mDNS multicast group 
on interface wlan0.IPv6 with address fe80::ae81:12ff:fe34:6963.
Aug 14 13:50:39 stt300 avahi-daemon[1269]: Withdrawing address record 
for fe80::ae81:12ff:fe34:6963 on wlan0.
Aug 14 13:50:39 stt300 avahi-daemon[1269]: Withdrawing workstation 
service for wlan0.
Aug 14 13:50:39 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
devices removed (path: 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: wlan0)
Aug 14 13:50:39 stt300 NetworkManager[1181]: <info> (wlan0): now unmanaged
Aug 14 13:50:39 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 3 -> 1 (reason 36)
Aug 14 13:50:39 stt300 NetworkManager[1181]: <info> (wlan0): cleaning up...
Aug 14 13:50:39 stt300 NetworkManager[1181]: <info> radio killswitch 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/ieee80211/phy0/rfkill1 
disappeared
Aug 14 13:50:39 stt300 kernel: [  712.176213] brcmsmac 0000:02:00.0: PCI 
INT A disabled
Aug 14 13:50:39 stt300 wpa_supplicant[1204]: Could not read interface 
wlan0 flags: No such device
Aug 14 13:50:50 stt300 kernel: [  723.594513] cfg80211: Calling CRDA to 
update world regulatory domain
Aug 14 13:50:50 stt300 kernel: [  723.610205] brcmutil: module is from 
the staging directory, the quality is unknown, you have been warned.
Aug 14 13:50:50 stt300 kernel: [  723.613763] brcmsmac: module is from 
the staging directory, the quality is unknown, you have been warned.
Aug 14 13:50:50 stt300 kernel: [  723.619364] cfg80211: World regulatory 
domain updated:
Aug 14 13:50:50 stt300 kernel: [  723.619374] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:50:50 stt300 kernel: [  723.619385] cfg80211:     (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:50 stt300 kernel: [  723.619394] cfg80211:     (2457000 KHz 
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:50 stt300 kernel: [  723.619403] cfg80211:     (2474000 KHz 
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:50 stt300 kernel: [  723.619412] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:50 stt300 kernel: [  723.619421] cfg80211:     (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:50 stt300 kernel: [  723.626928] brcmsmac 0000:02:00.0: bus 
2 slot 0 func 0 irq 17
Aug 14 13:50:50 stt300 kernel: [  723.626964] brcmsmac 0000:02:00.0: PCI 
INT A -> GSI 17 (level, low) -> IRQ 17
Aug 14 13:50:50 stt300 kernel: [  723.626985] brcmsmac 0000:02:00.0: 
setting latency timer to 64
Aug 14 13:50:50 stt300 kernel: [  723.655812] ieee80211 phy0: Selected 
rate control algorithm 'minstrel_ht'
Aug 14 13:50:50 stt300 kernel: [  723.658781] cfg80211: Calling CRDA for 
country: US
Aug 14 13:50:50 stt300 NetworkManager[1181]: <info> found WiFi radio 
killswitch rfkill2 (at 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/ieee80211/phy0/rfkill2) (driver 
<unknown>)
Aug 14 13:50:51 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
devices added (path: 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: wlan0)
Aug 14 13:50:51 stt300 NetworkManager[1181]:    SCPlugin-Ifupdown: 
device added (path: 
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: 
wlan0): no ifupdown configuration found.
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): driver 
supports SSID scans (scan_capa 0x01).
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): new 802.11 
WiFi device (driver: 'brcmsmac' ifindex: 4)
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): exported as 
/org/freedesktop/NetworkManager/Devices/2
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): now managed
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 1 -> 2 (reason 2)
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): bringing up 
device.
Aug 14 13:50:51 stt300 kernel: [  723.708363] cfg80211: Regulatory 
domain changed to country: US
Aug 14 13:50:51 stt300 kernel: [  723.708372] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:50:51 stt300 kernel: [  723.708381] cfg80211:     (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.708390] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.708399] cfg80211:     (5250000 KHz 
- 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.708407] cfg80211:     (5490000 KHz 
- 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.708416] cfg80211:     (5650000 KHz 
- 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.708424] cfg80211:     (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.708453] cfg80211: Calling CRDA for 
country: EU
Aug 14 13:50:51 stt300 kernel: [  723.724639] cfg80211: Regulatory 
domain changed to country: EU
Aug 14 13:50:51 stt300 kernel: [  723.724648] cfg80211:     (start_freq 
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 14 13:50:51 stt300 kernel: [  723.724657] cfg80211:     (2402000 KHz 
- 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.724665] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.724673] cfg80211:     (5250000 KHz 
- 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.724681] cfg80211:     (5490000 KHz 
- 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Aug 14 13:50:51 stt300 kernel: [  723.747941] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: true (implement)
Aug 14 13:50:51 stt300 kernel: [  723.747967] ieee80211 phy0: 
wl_ops_config: change monitor mode: false (implement)
Aug 14 13:50:51 stt300 kernel: [  723.747976] ieee80211 phy0: 
wl_ops_config: change power-save mode: false (implement)
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): preparing 
device.
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): 
deactivating device (reason: 2).
Aug 14 13:50:51 stt300 kernel: [  723.748827] ieee80211 phy0: 
wl_ops_bss_info_changed: qos enabled: false (implement)
Aug 14 13:50:51 stt300 kernel: [  723.749535] ADDRCONF(NETDEV_UP): 
wlan0: link is not ready
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
interface state:  starting -> ready
Aug 14 13:50:51 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 2 -> 3 (reason 42)
Aug 14 13:50:51 stt300 kernel: [  723.797297] ieee80211 phy0: 
wl_ops_bss_info_changed: BSS idle: false (implement)
Aug 14 13:50:51 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
starting connection 'Auto WLAN_B5'
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 3 -> 4 (reason 0)
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): access point 'Auto WLAN_B5' has security, but secrets 
are required.
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:51:10 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:51:11 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:12 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:13 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:14 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:15 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:16 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:17 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:18 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:19 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:20 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:21 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:22 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:23 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:24 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:25 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:26 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:27 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:28 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:29 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:30 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:31 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:32 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:33 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:34 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:35 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:36 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:36 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): association took too long.
Aug 14 13:51:36 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:51:36 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): asking for new secrets
Aug 14 13:51:37 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:38 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:51:38 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:51:39 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:39 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:39 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:40 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:40 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:40 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:41 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:41 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:41 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:42 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:42 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:42 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:43 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:43 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:43 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:44 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:44 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:44 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:45 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:45 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:45 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:46 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:46 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:46 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:47 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:47 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:47 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:48 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:48 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:48 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:49 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:49 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:49 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:50 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:50 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:50 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:51 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:51 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:51 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:52 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:52 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:52 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:53 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:53 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:53 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:54 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:54 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:54 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:55 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:55 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:55 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:56 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:56 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:56 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:57 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:57 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:57 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:58 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:58 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:58 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:51:59 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:51:59 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:51:59 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:00 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:00 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:00 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:01 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:01 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:01 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:02 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:02 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:02 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:03 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:03 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:04 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): association took too long.
Aug 14 13:52:04 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:52:04 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): asking for new secrets
Aug 14 13:52:04 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:04 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:04 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:05 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:05 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:05 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:06 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:52:06 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:52:07 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:07 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:07 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:08 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:08 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:08 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:09 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:09 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:09 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:10 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:10 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:10 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:11 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:11 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:12 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:12 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:13 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:13 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:14 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:14 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:15 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:15 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:16 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:16 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:17 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:17 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:18 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:18 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:19 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:19 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:20 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:20 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:21 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:21 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:22 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:22 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:23 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:23 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:24 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:24 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:25 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:25 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:26 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:26 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:27 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:27 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:28 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:28 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:29 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:29 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:30 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:30 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:31 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:31 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:32 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): association took too long.
Aug 14 13:52:32 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 6 (reason 0)
Aug 14 13:52:32 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): asking for new secrets
Aug 14 13:52:32 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:32 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:33 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:33 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) scheduled...
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) started...
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 6 -> 4 (reason 0)
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) scheduled...
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 1 of 5 (Device Prepare) complete.
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) starting...
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 4 -> 5 (reason 0)
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Activation 
(wlan0/wireless): connection 'Auto WLAN_B5' has security, and secrets 
exist.  No new secrets needed.
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Config: added 'ssid' 
value 'WLAN_B5'
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Config: added 
'scan_ssid' value '1'
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Config: added 
'key_mgmt' value 'WPA-PSK'
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Config: added 'psk' 
value '<omitted>'
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Activation (wlan0) 
Stage 2 of 5 (Device Configure) complete.
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> Config: set 
interface ap_scan to 1
Aug 14 13:52:34 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:34 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:35 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:35 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:36 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:36 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:37 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:37 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:38 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:38 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:38 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:39 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:39 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:39 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:40 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:40 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:40 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:41 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:41 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:41 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:42 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:42 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:42 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:43 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:43 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:43 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:44 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:44 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:44 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:45 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:45 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:45 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:46 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:46 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:46 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:47 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:47 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:47 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:48 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:48 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:48 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:49 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:49 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:49 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:50 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:50 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:50 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:51 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:51 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:51 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:52 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:52 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:52 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:53 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:53 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:53 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:54 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:54 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:54 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:55 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:55 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:55 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:56 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:56 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:56 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:57 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:57 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:57 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:58 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:52:58 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  inactive -> scanning
Aug 14 13:52:58 stt300 NetworkManager[1181]: <info> (wlan0): supplicant 
connection state:  scanning -> inactive
Aug 14 13:52:59 stt300 NetworkManager[1181]: <warn> Activation 
(wlan0/wireless): association took too long.
Aug 14 13:52:59 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 5 -> 9 (reason 7)
Aug 14 13:52:59 stt300 NetworkManager[1181]: <warn> Activation (wlan0) 
failed for access point (WLAN_B5)
Aug 14 13:52:59 stt300 NetworkManager[1181]: <info> Marking connection 
'Auto WLAN_B5' invalid.
Aug 14 13:52:59 stt300 NetworkManager[1181]: <warn> Activation (wlan0) 
failed.
Aug 14 13:52:59 stt300 NetworkManager[1181]: <info> (wlan0): device 
state change: 9 -> 3 (reason 0)
Aug 14 13:52:59 stt300 NetworkManager[1181]: <info> (wlan0): 
deactivating device (reason: 0).
Aug 14 13:52:59 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:00 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:01 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:02 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:03 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:04 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:05 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:06 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:07 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:08 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:09 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:10 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:11 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:12 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:13 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:14 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:15 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:16 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:17 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:18 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:19 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:20 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:21 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:22 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:23 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:24 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:25 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:26 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:27 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:28 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:29 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:30 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:31 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:32 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:33 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:34 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:35 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.
Aug 14 13:53:36 stt300 wpa_supplicant[1204]: Failed to initiate AP scan.

