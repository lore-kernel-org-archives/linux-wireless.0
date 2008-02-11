Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:5192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYBKLIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 06:08:49 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3768525fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2008 03:08:47 -0800 (PST)
Message-ID: <47B02CBB.1060406@gmail.com> (sfid-20080211_110855_578284_80D46122)
Date: Mon, 11 Feb 2008 13:08:43 +0200
From: =?UTF-8?B?RWRkeSBQZXRyaciZb3I=?= <eddy.petrisor@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: weird issues with b43 - and an oops
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello developers,

Sorry if this is not the proper place for this mail. Please redirect me 
to the proper place, if I am in the wrong place.


First some history.
I have a Dell Inspiron 6400 (aka E1505) which has this wireless card:

0b:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan 
mini-PCI (rev 01)

0b:00.0 0280: 14e4:4311 (rev 01)


I didn't use this wireless card with encription until thursday when I 
upgraded to 2.6.24[1] (from Debian Unstable) and set up the card to work 
with wpa2-psk with aes[1]. To my wonder and pleasure, it worked without 
a firmware upgrade, the only firmware I had was the one extracted with 
bcm43xx-fwcutter, I didn't use b43-fwcutter as when I saw it was working 
without, I wasn't preoccupied with it.


It worked without problems (although after suspend to ram I had to 
ifdown/ifup the card) until yesterday evening when, after a longer 
suspend-to-ram it didn't start and found error messages in syslog.


Here it is how it worked when it did:

Feb 10 12:34:13 bounty kernel: wlan0: RX deauthentication from 
00:1b:fc:45:33:70 (reason=7)
Feb 10 12:34:13 bounty kernel: wlan0: deauthenticated
Feb 10 12:34:14 bounty kernel: wlan0: authenticate with AP 00:1b:fc:45:33:70
Feb 10 12:34:14 bounty kernel: wlan0: RX authentication from 
00:1b:fc:45:33:70 (alg=0 transaction=2 status=0)
Feb 10 12:34:14 bounty kernel: wlan0: authenticated
Feb 10 12:34:14 bounty kernel: wlan0: associate with AP 00:1b:fc:45:33:70
Feb 10 12:34:14 bounty kernel: wlan0: RX ReassocResp from 
00:1b:fc:45:33:70 (capab=0x411 status=0 aid=1)
Feb 10 12:34:14 bounty kernel: wlan0: associated
Feb 10 12:34:14 bounty kernel: wlan0: switched to short barker preamble 
(BSSID=00:1b:fc:45:33:70)
Feb 10 12:34:20 bounty dhclient: DHCPDISCOVER on wlan0 to 
255.255.255.255 port 67 interval 15
Feb 10 12:34:22 bounty dhclient: DHCPOFFER from 192.168.77.254
Feb 10 12:34:22 bounty dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 
port 67
Feb 10 12:34:22 bounty dhclient: DHCPACK from 192.168.77.254
[....]
Feb 10 12:46:31 bounty kernel: wlan0: No ProbeResp from current AP 
00:1b:fc:45:33:70 - assume out of range
Feb 10 12:46:43 bounty kernel: wlan0: Initial auth_alg=0
Feb 10 12:46:43 bounty kernel: wlan0: authenticate with AP 00:1b:fc:45:33:70
Feb 10 12:46:43 bounty kernel: wlan0: Initial auth_alg=0
Feb 10 12:46:43 bounty kernel: wlan0: authenticate with AP 00:1b:fc:45:33:70
Feb 10 12:46:43 bounty kernel: wlan0: RX authentication from 
00:1b:fc:45:33:70 (alg=0 transaction=2 status=0)
Feb 10 12:46:43 bounty kernel: wlan0: authenticated
Feb 10 12:46:43 bounty kernel: wlan0: associate with AP 00:1b:fc:45:33:70
Feb 10 12:46:43 bounty kernel: wlan0: authentication frame received from 
00:1b:fc:45:33:70, but not in authenticate state - ignored
Feb 10 12:46:43 bounty kernel: wlan0: RX ReassocResp from 
00:1b:fc:45:33:70 (capab=0x411 status=0 aid=1)
Feb 10 12:46:43 bounty kernel: wlan0: associated
Feb 10 12:46:43 bounty kernel: wlan0: switched to short barker preamble 
(BSSID=00:1b:fc:45:33:70)
Feb 10 12:50:01 bounty /USR/SBIN/CRON[13464]: (root) CMD (test -x 
/usr/sbin/mcelog -a ! -e /etc/mcelog-disabled && /usr/sbin/mcelog 
--ignorenodev --filter >> /var/log/mcelog)
Feb 10 12:50:51 bounty dhclient: DHCPREQUEST on wlan0 to 192.168.77.254 
port 67
Feb 10 12:50:56 bounty dhclient: DHCPREQUEST on wlan0 to 192.168.77.254 
port 67
Feb 10 12:50:56 bounty dhclient: DHCPACK from 192.168.77.254
Feb 10 12:50:56 bounty dhclient: bound to 192.168.77.103 -- renewal in 
366 seconds.


And here is a snippet after the suspend-to-ram when it stopped working:

Feb 11 03:32:00 bounty dhclient: There is already a pid file 
/var/run/dhclient.wlan0.pid with pid 304
Feb 11 03:32:00 bounty dhclient: killed old client process, removed PID file
Feb 11 03:32:00 bounty dhclient: Internet Systems Consortium DHCP Client 
V3.0.6
Feb 11 03:32:00 bounty dhclient: Copyright 2004-2007 Internet Systems 
Consortium.
Feb 11 03:32:00 bounty dhclient: All rights reserved.
Feb 11 03:32:00 bounty dhclient: For info, please visit 
http://www.isc.org/sw/dhcp/
Feb 11 03:32:00 bounty dhclient:
Feb 11 03:32:00 bounty dhclient: wmaster0: unknown hardware address type 801
Feb 11 03:32:00 bounty dhclient: wmaster0: unknown hardware address type 801
Feb 11 03:32:00 bounty dhclient: Listening on LPF/wlan0/00:16:cf:cb:27:2b
Feb 11 03:32:00 bounty dhclient: Sending on   LPF/wlan0/00:16:cf:cb:27:2b
Feb 11 03:32:00 bounty dhclient: Sending on   Socket/fallback
Feb 11 03:32:01 bounty dhclient: DHCPRELEASE on wlan0 to 192.168.77.254 
port 67
Feb 11 03:32:01 bounty avahi-daemon[8853]: Withdrawing address record 
for 192.168.77.103 on wlan0.
Feb 11 03:32:01 bounty avahi-daemon[8853]: Leaving mDNS multicast group 
on interface wlan0.IPv4 with address 192.168.77.103.
Feb 11 03:32:01 bounty avahi-daemon[8853]: Interface wlan0.IPv4 no 
longer relevant for mDNS.
Feb 11 03:32:01 bounty kernel: b43-phy0 ERROR: DMA RX reset timed out
Feb 11 03:32:01 bounty kernel: b43-phy0 ERROR: DMA TX reset timed out
Feb 11 03:32:02 bounty last message repeated 5 times
Feb 11 03:32:02 bounty avahi-daemon[8853]: Interface wlan0.IPv6 no 
longer relevant for mDNS.
Feb 11 03:32:02 bounty avahi-daemon[8853]: Leaving mDNS multicast group 
on interface wlan0.IPv6 with address fe80::216:cfff:fecb:272b.
Feb 11 03:32:02 bounty avahi-daemon[8853]: Withdrawing address record 
for fe80::216:cfff:fecb:272b on wlan0.
Feb 11 03:32:12 bounty kernel: input: b43-phy0 as /class/input/input16
Feb 11 03:32:12 bounty kernel: WARNING: at drivers/ssb/main.c:883 
ssb_tmslow_reject_bitmask()
Feb 11 03:32:12 bounty kernel: Pid: 8061, comm: wpa_supplicant Not 
tainted 2.6.24-1-amd64 #1
Feb 11 03:32:12 bounty kernel:
Feb 11 03:32:12 bounty kernel: Call Trace:
Feb 11 03:32:12 bounty kernel:  [<ffffffff880557cd>] 
:ssb:ssb_tmslow_reject_bitmask+0x4a/0x53
Feb 11 03:32:12 bounty kernel:  [<ffffffff8805603d>] 
:ssb:ssb_device_is_enabled+0xf/0x3b
Feb 11 03:32:12 bounty kernel:  [<ffffffff882d418e>] 
:b43:b43_wireless_core_init+0x42/0x6e2
Feb 11 03:32:12 bounty kernel:  [<ffffffff882d4de1>] 
:b43:b43_start+0x36/0x75
Feb 11 03:32:12 bounty kernel:  [<ffffffff8823e930>] 
:mac80211:ieee80211_open+0x1ca/0x3d2
Feb 11 03:32:12 bounty kernel:  [<ffffffff803ad6dc>] dev_open+0x46/0x7e
Feb 11 03:32:12 bounty kernel:  [<ffffffff803ac139>] 
dev_change_flags+0xaa/0x160
Feb 11 03:32:12 bounty kernel:  [<ffffffff803ef401>] 
devinet_ioctl+0x243/0x5a8
Feb 11 03:32:12 bounty kernel:  [<ffffffff803a0816>] sock_ioctl+0x1dc/0x200
Feb 11 03:32:12 bounty kernel:  [<ffffffff802a3465>] do_ioctl+0x21/0x6b
Feb 11 03:32:12 bounty kernel:  [<ffffffff802a36f2>] vfs_ioctl+0x243/0x25c
Feb 11 03:32:12 bounty kernel:  [<ffffffff802a375c>] sys_ioctl+0x51/0x71
Feb 11 03:32:12 bounty kernel:  [<ffffffff8020bfac>] tracesys+0xdc/0xe1
Feb 11 03:32:12 bounty kernel:
Feb 11 03:32:12 bounty kernel: b43-phy0 ERROR: Microcode not responding
Feb 11 03:32:12 bounty kernel: b43-phy0 ERROR: You must go to 
http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and 
download the correct firmware (version 4).
Feb 11 03:32:12 bounty dhclient: Internet Systems Consortium DHCP Client 
V3.0.6
Feb 11 03:32:12 bounty dhclient: Copyright 2004-2007 Internet Systems 
Consortium.
Feb 11 03:32:12 bounty dhclient: All rights reserved.
Feb 11 03:32:12 bounty dhclient: For info, please visit 
http://www.isc.org/sw/dhcp/
Feb 11 03:32:12 bounty dhclient:
Feb 11 03:32:12 bounty dhclient: wmaster0: unknown hardware address type 801
Feb 11 03:32:12 bounty kernel: input: b43-phy0 as /class/input/input17
Feb 11 03:32:12 bounty kernel: WARNING: at drivers/ssb/main.c:883 
ssb_tmslow_reject_bitmask()
Feb 11 03:32:12 bounty kernel: Pid: 8080, comm: ifconfig Not tainted 
2.6.24-1-amd64 #1
Feb 11 03:32:12 bounty kernel:


Later an oops appears (not sure if is related):

Feb 11 03:35:00 bounty /USR/SBIN/CRON[8381]: (root) CMD (test -x 
/usr/sbin/mcelog -a ! -e /etc/mcelog-disabled && /usr/sbin/mcelog 
--ignorenodev --filter >>
/var/log/mcelog)
Feb 11 03:36:04 bounty kernel: usb 4-2: USB disconnect, address 3
Feb 11 03:36:26 bounty ifplugd.agent[9113]: Stopping ifplugd for wlan0
Feb 11 03:36:26 bounty ifplugd.agent[9116]: Stopping ifplugd for wmaster0
Feb 11 03:36:26 bounty dhclient: Internet Systems Consortium DHCP Client 
V3.0.6
Feb 11 03:36:26 bounty dhclient: Copyright 2004-2007 Internet Systems 
Consortium.
Feb 11 03:36:26 bounty dhclient: All rights reserved.
Feb 11 03:36:26 bounty dhclient: For info, please visit 
http://www.isc.org/sw/dhcp/
Feb 11 03:36:26 bounty dhclient:
Feb 11 03:36:26 bounty kernel: Unable to handle kernel paging request at 
ffffffff882e2ba3 RIP:
Feb 11 03:36:26 bounty kernel:  [<ffffffff882e2ba3>]
Feb 11 03:36:26 bounty kernel: PGD 203067 PUD 207063 PMD 3d546067 PTE 0
Feb 11 03:36:26 bounty kernel: Oops: 0010 [1] SMP
Feb 11 03:36:26 bounty kernel: CPU 1
Feb 11 03:36:26 bounty kernel: Modules linked in: usbhid hid usb_storage 
sch_sfq asix usbnet xt_multiport binfmt_misc rfcomm l2cap xt_TCPMSS 
xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack 
iptable_filter ip_tables x_tables ppdev parport_pc lp parport 
acpi_cpufreq cpufreq_stats cpufreq_powersave cpufreq_conservative 
cpufreq_userspace ipv6 rfkill_input sha256_generic aes_x86_64 
aes_generic cbc dm_crypt dm_snapshot dm_mirror dm_mod kvm_intel kvm tun 
mmc_block fuse cpufreq_ondemand freq_table firewire_sbp2 loop joydev 
arc4 ecb blkcipher snd_hda_intel rfkill snd_pcm_oss snd_mixer_oss 
mac80211 psmouse snd_pcm cfg80211 battery sdhci i2c_i801 snd_timer 
led_class video hci_usb serio_raw ricoh_mmc button ac mmc_core i2c_core 
input_polldev snd intel_agp output bluetooth soundcore snd_page_alloc 
evdev iTCO_wdt ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic 
ata_piix libata scsi_mod b44 generic ide_core firewire_ohci 
firewire_core ssb crc_itu_t pcmcia pcmcia_core firmware_class mii 
ehci_hcd uhci_hcd thermal
Feb 11 03:36:26 bounty kernel: rocessor fan
Feb 11 03:36:26 bounty kernel: Pid: 8067, comm: ipolldevd Not tainted 
2.6.24-1-amd64 #1
Feb 11 03:36:26 bounty kernel: RIP: 0010:[<ffffffff882e2ba3>] 
[<ffffffff882e2ba3>]
Feb 11 03:36:26 bounty kernel: RSP: 0018:ffff810008f39eb8  EFLAGS: 00010247
Feb 11 03:36:26 bounty kernel: RAX: ffff8100330ff7c0 RBX: 
ffff810037451da8 RCX: ffff810037451db0
Feb 11 03:36:26 bounty kernel: RDX: ffff8100330ff7c8 RSI: 
ffff810008f39ef0 RDI: ffff810037451d80
Feb 11 03:36:26 bounty kernel: RBP: ffffffff881b50c2 R08: 
ffff810008f38000 R09: 0000000000000000
Feb 11 03:36:26 bounty kernel: R10: ffff81003edfea58 R11: 
ffffffff8039d62c R12: ffff81001b69dac8
Feb 11 03:36:26 bounty kernel: R13: ffffffffffffffff R14: 
ffffffff80576f00 R15: 0000000000000000
Feb 11 03:36:26 bounty kernel: FS:  0000000000000000(0000) 
GS:ffff81003edd47c0(0000) knlGS:0000000000000000
Feb 11 03:36:26 bounty kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
000000008005003b
Feb 11 03:36:26 bounty kernel: CR2: ffffffff882e2ba3 CR3: 
0000000034dc3000 CR4: 00000000000026a0
Feb 11 03:36:26 bounty kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Feb 11 03:36:26 bounty kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Feb 11 03:36:26 bounty kernel: Process ipolldevd (pid: 8067, threadinfo 
ffff810008f38000, task ffff81003644b800)
Feb 11 03:36:26 bounty kernel: Stack:  ffffffff881b50cd ffff8100330ff7c0 
ffffffff80244695 ffff8100330ff7c0
Feb 11 03:36:26 bounty kernel:  ffff8100330ff7c0 ffffffff80244fa7 
ffffffff80245081 0000000000000000
Feb 11 03:36:26 bounty kernel:  ffff81003644b800 ffffffff80247ff2 
ffff810008f39f08 ffff810008f39f08
Feb 11 03:36:26 bounty kernel: Call Trace:
Feb 11 03:36:26 bounty kernel:  [<ffffffff881b50cd>] 
:input_polldev:input_polled_device_work+0xb/0x26
Feb 11 03:36:26 bounty kernel:  [<ffffffff80244695>] 
run_workqueue+0x7f/0x10b
Feb 11 03:36:26 bounty kernel:  [<ffffffff80244fa7>] worker_thread+0x0/0xe4
Feb 11 03:36:26 bounty kernel:  [<ffffffff80245081>] worker_thread+0xda/0xe4
Feb 11 03:36:26 bounty kernel:  [<ffffffff80247ff2>] 
autoremove_wake_function+0x0/0x2e
Feb 11 03:36:26 bounty kernel:  [<ffffffff80247ed3>] kthread+0x47/0x74
Feb 11 03:36:26 bounty kernel:  [<ffffffff8020cc48>] child_rip+0xa/0x12
Feb 11 03:36:26 bounty kernel:  [<ffffffff80247e8c>] kthread+0x0/0x74
Feb 11 03:36:26 bounty kernel:  [<ffffffff8020cc3e>] child_rip+0x0/0x12
Feb 11 03:36:26 bounty kernel:
Feb 11 03:36:26 bounty kernel:
Feb 11 03:36:26 bounty kernel: Code:  Bad RIP value.
Feb 11 03:36:26 bounty kernel: RIP  [<ffffffff882e2ba3>]
Feb 11 03:36:26 bounty kernel:  RSP <ffff810008f39eb8>
Feb 11 03:36:26 bounty kernel: CR2: ffffffff882e2ba3
Feb 11 03:36:26 bounty kernel: ---[ end trace cf9ada55fb8670a2 ]---
Feb 11 03:36:26 bounty dhclient: Bind socket to interface: No such device
Feb 11 03:36:59 bounty kernel: usb 4-2: new full speed USB device using 
uhci_hcd and address 4
Feb 11 03:36:59 bounty kernel: usb 4-2: configuration #1 chosen from 1 
choice
Feb 11 03:37:07 bounty kernel: usb 4-2: USB disconnect, address 4


At some point I decided to restart, but I think there is an important 
bit there:

Feb 11 04:48:48 bounty kernel: b43-phy1: Broadcom 4311 WLAN found
Feb 11 04:48:48 bounty kernel: b43-phy1 ERROR: FOUND UNSUPPORTED PHY 
(Analog 15, Type 15, Revision 255)
Feb 11 04:48:48 bounty kernel: b43: probe of ssb0:0 failed with error -95
Feb 11 04:50:01 bounty /USR/SBIN/CRON[14909]: (root) CMD (test -x 
/usr/sbin/mcelog -a ! -e /etc/mcelog-disabled && /usr/sbin/mcelog 
--ignorenodev --filter >> /var/log/mcelog)
Feb 11 04:50:29 bounty shutdown[14935]: shutting down for system reboot



Then, this morning I found this mail[2], and tried the firmware 
indicated there, but no success:

b43-phy2: Broadcom 4311 WLAN found
phy2: Selected rate control algorithm 'simple'
input: b43-phy2 as /class/input/input13
Registered led device: b43-phy2:tx
Registered led device: b43-phy2:rx
Registered led device: b43-phy2:radio
ADDRCONF(NETDEV_UP): wlan0: link is not ready
printk: 10 messages suppressed.
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1b:fc:45:33:70
wlan0: authenticate with AP 00:1b:fc:45:33:70
wlan0: authenticate with AP 00:1b:fc:45:33:70
wlan0: authentication with AP 00:1b:fc:45:33:70 timed out
printk: 20 messages suppressed.
b43-phy2 ERROR: PHY transmission error
b43-phy2 ERROR: PHY transmission error
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1b:fc:45:33:70
wlan0: authenticate with AP 00:1b:fc:45:33:70
wlan0: authenticate with AP 00:1b:fc:45:33:70
wlan0: authentication with AP 00:1b:fc:45:33:70 timed out



Any help is appreciated.
I just hope I didn't fried the wlan card.


[1] 
http://ramblingfoo.blogspot.com/2008/02/wpa2-psk-with-aes-on-broadcom-wlan0.html
[2]
http://article.gmane.org/gmane.linux.kernel.wireless.general/11141
-- 
Regards,
EddyP
=============================================
"Imagination is more important than knowledge" A.Einstein
