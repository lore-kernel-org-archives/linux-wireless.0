Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:59653 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYC2Ohu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 10:37:50 -0400
Subject: rt2500pci, infinite calls to rt2x00mc_configure_filter
From: Bas Hulsken <bhulsken@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-VXfUPHnBaX1VJgw5Ut/e"
Date: Sat, 29 Mar 2008 15:34:06 +0100
Message-Id: <1206801246.24689.19.camel@Bas> (sfid-20080329_143801_899785_26C2C358)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VXfUPHnBaX1VJgw5Ut/e
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Ivo,

with the latest changes, I guess in particular the commit "rt2x00: Fix
in _atomic() usage" changing the flags for rt2500pci results in infinite
calls to the new "rt2x00mc_configure_filter" in rt2x00mac.c. I noticed
this after applying the attached patch that I've been using to debug
some hostapd problems. All it does is add some printk's, I don't think
it can cause the problem, right? 

I use compat-wireless, to test stuff on a fedora system, this is the
uname -a:
Linux steady.steadydecline.net 2.6.24.3-50.fc8 #1 SMP Thu Mar 20
13:39:08 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

this checkout gives the problem (most recent wireless-testing):
mac80211-v2.6.25_rc7_3570_g78f8e64_080329-1.x86_64.rpm
while this one does not:
mac80211-v2.6.25_rc5_2672_g57b58cd_080326-1.x86_64.rpm

with the patch (see attachment) applied, I get this in the logs, upon
running hostapd:
-------------------------------------------------------------
Mar 29 14:25:49 steady kernel: rt2500pci filter_flags: 2
Mar 29 14:25:49 steady kernel:last message repeated 423 times
Mar 29 14:25:49 steady kernel: rt2500pci filte0pci filter_flags: 2
Mar 29 14:25:49 steady kernel: rt2500pci filter_flags: 2
Mar 29 14:25:49 steady kernel:last message repeated 139 times
------------------------------------------------------------
this continues forever, spamming the logs, and eventually making the
system unresponsive, requiring a reboot.

without the patch adding the printk to rt2x00mac_configure_filter, I get
this soft lockup:
------------------------------------------------------------
rt2500pci MAC changed: 00:0c:f6:14:05:19
ADDRCONF(NETDEV_UP): wlan1: link is not ready
BUG: soft lockup - CPU#0 stuck for 11s! [rt2500pci:1541]
CPU 0:
Modules linked in: cpufreq_stats nfsd lockd nfs_acl auth_rpcgss exportfs
autofs4 fuse rfcomm l2cap sunrpc ipt_REJECT xt_multiport iptable_filter
ipt_MASQUERADE ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 ipt_TOS
iptable_mangle ip_tables nf_conntrack_ipv6 xt_state nf_conntrack
xt_tcpudp ip6t_ipv6header ip6t_REJECT ip6table_filter ip6_tables
x_tables ipv6 cpufreq_ondemand acpi_cpufreq ext2 dm_mirror dm_multipath
dm_mod wm8775 cx25840 msp3400 saa7115 tuner tea5767 tda8290 tuner_simple
snd_hda_intel mt20xx snd_seq_dummy tea5761 snd_seq_oss
snd_seq_midi_event snd_seq arc4 snd_seq_device ecb snd_pcm_oss
snd_mixer_oss blkcipher snd_pcm ivtv i2c_algo_bit cx2341x snd_timer
tveeprom snd_page_alloc rt2500pci(U) rt2x00pci(U) rt2x00lib(U) videodev
rfkill snd_hwdep input_polldev firewire_ohci v4l2_common firewire_core
crc_itu_t v4l1_compat rtl8187(U) mac80211(U) snd ati_remote2 r8169
pcspkr eeprom_93cx6(U) lirc_atiusb cfg80211(U) lirc_dev soundcore
hci_usb button iTCO_wdt i2c_i801 i2c_core bluetooth iTCO_vendor_support
sky2 sr_mod sg floppy cdrom ahci pata_jmicron ata_generic ata_piix
pata_acpi libata sd_mod scsi_mod raid456 async_xor async_memcpy async_tx
xor ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 1541, comm: rt2500pci Not tainted 2.6.24.3-50.fc8 #1
RIP: 0010:[<ffffffff8126986b>]  [<ffffffff8126986b>]
_spin_unlock_irqrestore+0x8/0x9
RSP: 0018:ffff8101285d7e98  EFLAGS: 00000202
RAX: ffff81012d975fa0 RBX: ffffffff8824002e RCX: 0000000000000000
RDX: 0000000300000000 RSI: 0000000000000202 RDI: ffff81012d975f80
RBP: ffff81012d975f98 R08: ffff81012d975f88 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000300000000
R13: ffffffffffffff10 R14: ffffffff8824002e R15: ffffffffffffffff
FS:  0000000000000000(0000) GS:ffffffff813cb000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000003ce5e9afa0 CR3: 0000000122418000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff81045ba6>] queue_work+0x37/0x40
 [<ffffffff88240065>] :rt2x00lib:rt2x00lib_packetfilter_scheduled
+0x37/0x3c
 [<ffffffff81045635>] run_workqueue+0x7f/0x10b
 [<ffffffff81045f3d>] worker_thread+0x0/0xe4
 [<ffffffff81046017>] worker_thread+0xda/0xe4
 [<ffffffff81049221>] autoremove_wake_function+0x0/0x2e
 [<ffffffff810490f2>] kthread+0x47/0x75
 [<ffffffff8100cca8>] child_rip+0xa/0x12
 [<ffffffff81034326>] check_preempt_wakeup+0x0/0xa5
 [<ffffffff810490ab>] kthread+0x0/0x75
 [<ffffffff8100cc9e>] child_rip+0x0/0x12
------------------------------------------------------------
I guess this softlock might be prevented from winding up in the logs
with the printk I've added, because that spams the log.

any ideas?

best regards,
Bas Hulsken

--=-VXfUPHnBaX1VJgw5Ut/e
Content-Disposition: attachment; filename=debug_for_johannes.diff
Content-Type: text/x-patch; name=debug_for_johannes.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2500pci.c	2008-03-29 13:57:42.000000000 +0100
+++ ./rt2500pci.c	2008-03-29 14:13:08.000000000 +0100
@@ -49,6 +49,21 @@
  * the access attempt is considered to have failed,
  * and we will print an error.
  */
+
+#define MAC2STR_BUFFERS 4
+
+static inline char *mac2str(u8 *mac)
+{
+	static atomic_t a = ATOMIC_INIT(0);
+	static char bufs[MAC2STR_BUFFERS][6 * 3];
+	char *str;
+
+	str = bufs[atomic_inc_return(&a) & (MAC2STR_BUFFERS - 1)];
+	sprintf(str, "%02x:%02x:%02x:%02x:%02x:%02x",
+		mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+	return str;
+}
+
 static u32 rt2500pci_bbp_check(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -329,10 +344,11 @@ static void rt2500pci_config_intf(struct
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	}
 
-	if (flags & CONFIG_UPDATE_MAC)
+	if (flags & CONFIG_UPDATE_MAC) {
 		rt2x00pci_register_multiwrite(rt2x00dev, CSR3,
 					      conf->mac, sizeof(conf->mac));
-
+		printk(KERN_INFO "rt2500pci MAC changed: %s\n", mac2str((u8 *)conf->mac));
+	}
 	if (flags & CONFIG_UPDATE_BSSID)
 		rt2x00pci_register_multiwrite(rt2x00dev, CSR5,
 					      conf->bssid, sizeof(conf->bssid));
--- compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-03-26 21:49:36.000000000 +0100
+++ ./rt2x00mac.c	2008-03-29 14:14:54.000000000 +0100
@@ -416,7 +416,7 @@ void rt2x00mac_configure_filter(struct i
 	if (rt2x00dev->packet_filter == *total_flags)
 		return;
 	rt2x00dev->packet_filter = *total_flags;
-
+	printk(KERN_INFO "rt2500pci filter_flags: %d\n", rt2x00dev->packet_filter);
 	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
 		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
 	else

--=-VXfUPHnBaX1VJgw5Ut/e--

