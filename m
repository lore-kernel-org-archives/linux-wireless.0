Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54590 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0K3AaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 19:30:02 -0500
Message-ID: <4CF44543.9070605@candelatech.com>
Date: Mon, 29 Nov 2010 16:28:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Script to crash ath9k with DMA errors.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is a script that reliably crashes my ath9k box.
A second box with completely different hardware (except
for ath9k) experiences similar problems.

I am using today's wireless-testing kernel with a few
patches of my own.

You will also need the very latest hostap tree as it has the
optimizations for allowing STAs to share scans.  Without
this optimization, I did not see this problem.

A few notes about the script:

* I cannot remove any interfaces, seems a ref-count leak somewhere.
   I haven't debugged this issue.

* Without the background ping, it is very hard to reproduce this problem,
   but with it, it happens almost every time.

* You'll need to set up your paths at the top of the script.


#!/usr/bin/perl

use strict;

my $iw = "./local/sbin/iw";
my $ip = "./local/sbin/ip";
my $wpa_s = "./local/bin/wpa_supplicant";
my $ssid = "candela-n";
my $key = "wpadmz123";

my $phy = "wiphy0";
my $max = 32;
my $i;
my $bmac = "00:01:02:03:04:";
my $cmd;

# Cleanup previous stuff
runCmd("killall wpa_supplicant");
runCmd("killall ping");

for ($i = 0; $i<$max; $i++) {
   # Work around ref-counting bugs in kernel
   runCmd("$ip link set sta$i down");
   runCmd("$ip addr flush dev sta$i");
   runCmd("$ip route flush dev sta$i");
   runCmd("$ip -6 addr flush dev sta$i");
   runCmd("$ip -6 route flush dev sta$i");

   # Bugger, cannot get the ref-count problem to go away.
   # runCmd("$iw dev sta$i del");
}

#exit(0);

open(FD, ">pingbg") || die("Couldn't open pingbg.");
print FD "#!/bin/bash\n\n";
print FD "ping \$* > /dev/null 2>&1 &\n";
print FD "echo continuing....\n";
close(FD);
runCmd("chmod a+x pingbg");

# Create stations
for ($i = 0; $i<$max; $i++) {
   runCmd("$iw phy $phy interface add sta$i type station");
   my $mc5 = $i + 1;
   if (length($mc5) == 1) {
     $mc5 = "0$mc5"; # pad mac octet
   }
   my $mac = "$bmac$mc5";
   runCmd("$ip link set sta$i address $mac");

   runCmd("$iw dev sta$i set power_save off");
   runCmd("$ip addr add 9.99.1.$mc5/24 dev sta$i");
   runCmd("./pingbg -I sta$i 9.99.1.1");
}

# Bring them up with WPA
for ($i = 0; $i<$max; $i++) {
   open(FD, ">sta$i" . "_wpa.conf") || die("Couldn't open file: $!\n");
   print FD "
ctrl_interface=/var/run/wpa_supplicant
fast_reauth=1
#can_scan_one=1
network={
     ssid=\"$ssid\"
     proto=WPA
     key_mgmt=WPA-PSK
     psk=\"$key\"
     pairwise=TKIP CCMP
     group=TKIP CCMP
}
";
   #runCmd("$wpa_s -B -i sta$i -c sta$i" . "_wpa.conf -P sta$i" . "_wpa.pid -t -f sta$i" . "_wpa.log");
}

# Build command to start one wpa_supplicant for all interfaces.
my $cmd = "$wpa_s -B -g /var/run/wpa_supplicant_if -P /tmp/wpa_supplicant-all.pid -t -f /tmp/wpa_supplicant_log_all.txt -i sta0 -c sta0_wpa.conf";
for ($i = 1; $i<$max; $i++) {
   $cmd = "$cmd -N -i sta$i -c sta$i" . "_wpa.conf";
}
runCmd($cmd);

sub runCmd {
   my $cmd = shift;
   print "$cmd\n";
   `$cmd`;
}


Example kernel crash output:

ADDRCONF(NETDEV_CHANGE): sta6: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta5: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta4: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta3: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta1: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta0: link becomes ready
padlock: VIA PadLock not detected.

[root@ath9k-dev1 ~]# ADDRCONF(NETDEV_CHANGE): sta30: link becomes ready
ADDRCONF(NETDEV_CHANGE): sta29: link becomes ready
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x90/0x9a [ath9k]()
Hardware name: PDSBM
Could not stop RX, we could be confusing the DMA engine when we start RX up
Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]
Pid: 3505, comm: wpa_supplicant Not tainted 2.6.37-rc3-wl+ #53
Call Trace:
  [<78436fe9>] warn_slowpath_common+0x77/0x8c
  [<f933019e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<f933019e>] ? ath_stoprecv+0x90/0x9a [ath9k]
  [<7843707a>] warn_slowpath_fmt+0x2e/0x30
  [<f933019e>] ath_stoprecv+0x90/0x9a [ath9k]
  [<f932f13c>] ath_set_channel+0x94/0x1e8 [ath9k]
  [<7845a425>] ? mark_held_locks+0x47/0x5f
  [<7878e5bb>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
  [<f932f5d4>] ath9k_config+0x344/0x423 [ath9k]
  [<f919aaaa>] ieee80211_hw_config+0x11b/0x125 [mac80211]
  [<f91aa25a>] ieee80211_set_channel+0x74/0x9e [mac80211]
  [<f8d37d36>] cfg80211_set_freq+0xf3/0x12d [cfg80211]
  [<f91aa1e6>] ? ieee80211_set_channel+0x0/0x9e [mac80211]
  [<f8d3a24c>] cfg80211_mgd_wext_siwfreq+0x108/0x148 [cfg80211]
  [<f8d395c9>] cfg80211_wext_siwfreq+0x42/0xbf [cfg80211]
  [<7876e14f>] ioctl_standard_call+0x52/0x28e
  [<786f2db3>] ? dev_name_hash+0x16/0x48
  [<786f67cc>] ? __dev_get_by_name+0x32/0x3d
  [<7876e418>] wext_handle_ioctl+0x8d/0x18d
  [<f8d39587>] ? cfg80211_wext_siwfreq+0x0/0xbf [cfg80211]
  [<786f78f9>] dev_ioctl+0x520/0x53f
  [<786e5f7f>] ? sock_ioctl+0x0/0x202
  [<786e6175>] sock_ioctl+0x1f6/0x202
  [<7878e576>] ? _raw_spin_unlock_irq+0x22/0x2b
  [<786e5f7f>] ? sock_ioctl+0x0/0x202
  [<784cc151>] do_vfs_ioctl+0x4b1/0x4f6
  [<7878e576>] ? _raw_spin_unlock_irq+0x22/0x2b
  [<784303cd>] ? finish_task_switch+0x72/0xd4
  [<784c14a9>] ? fcheck_files+0x9b/0xca
  [<784c1505>] ? fget_light+0x2d/0xb0
  [<784cc1d9>] sys_ioctl+0x43/0x62
  [<784030dc>] sysenter_do_call+0x12/0x38
---[ end trace 34d8f42d696b7763 ]---
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/net/wireless/mlme.c:285 __cfg80211_auth_remove+0x98/0x9e [cfg80211]()
Hardware name: PDSBM
Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]
Pid: 38, comm: kworker/u:1 Tainted: G        W   2.6.37-rc3-wl+ #53
Call Trace:
  [<78436fe9>] warn_slowpath_common+0x77/0x8c
  [<f8d34888>] ? __cfg80211_auth_remove+0x98/0x9e [cfg80211]
  [<f8d34888>] ? __cfg80211_auth_remove+0x98/0x9e [cfg80211]
  [<7843701b>] warn_slowpath_null+0x1d/0x1f
  [<f8d34888>] __cfg80211_auth_remove+0x98/0x9e [cfg80211]
  [<f8d34fc2>] cfg80211_send_auth_timeout+0x90/0xa0 [cfg80211]
  [<7845a681>] ? trace_hardirqs_on_caller+0x104/0x125
  [<7845a6ad>] ? trace_hardirqs_on+0xb/0xd
  [<f91a434b>] ieee80211_probe_auth_done+0x1e/0x7b [mac80211]
  [<f91a6861>] ieee80211_work_work+0xd51/0xd8f [mac80211]
  [<7845a681>] ? trace_hardirqs_on_caller+0x104/0x125
  [<7845a602>] ? trace_hardirqs_on_caller+0x85/0x125
  [<78447000>] process_one_work+0x1af/0x2bf
  [<78446f8f>] ? process_one_work+0x13e/0x2bf
  [<f91a5b10>] ? ieee80211_work_work+0x0/0xd8f [mac80211]
  [<7844874e>] worker_thread+0xf9/0x1bf
  [<78448655>] ? worker_thread+0x0/0x1bf
  [<7844b27e>] kthread+0x62/0x67
  [<7844b21c>] ? kthread+0x0/0x67
  [<784036c6>] kernel_thread_helper+0x6/0x1a
---[ end trace 34d8f42d696b7764 ]---
e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:
   TDH                  <f1>
   TDT                  <f4>
   next_to_use          <f4>
   next_to_clean        <f1>
buffer_info[next_to_clean]:
   time_stamp           <bcc5>
   next_to_watch        <f1>
   jiffies              <c73c>
   next_to_watch.status <0>
MAC Status             <80080f83>
PHY Status             <796d>
PHY 1000BASE-T Status  <7c00>
PHY Extended Status    <3000>
PCI Status             <4010>
e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:
   TDH                  <f1>
   TDT                  <f4>
   next_to_use          <f4>
   next_to_clean        <f1>
buffer_info[next_to_clean]:
   time_stamp           <bcc5>
   next_to_watch        <f1>
   jiffies              <cf0c>
   next_to_watch.status <0>
MAC Status             <80080f83>
PHY Status             <796d>
PHY 1000BASE-T Status  <7c00>
PHY Extended Status    <3000>
PCI Status             <4010>
BUG: unable to handle kernel NULL pointer dereference at 00000040
IP: [<f933470a>] ath_tx_start+0x461/0x5ef [ath9k]
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/irq
Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]

Pid: 38, comm: kworker/u:1 Tainted: G        W   2.6.37-rc3-wl+ #53 PDSBM/PDSBM
EIP: 0060:[<f933470a>] EFLAGS: 00010246 CPU: 1
EIP is at ath_tx_start+0x461/0x5ef [ath9k]

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

