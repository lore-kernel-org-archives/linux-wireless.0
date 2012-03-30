Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55807 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab2C3Ct0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 22:49:26 -0400
Received: by pbcun15 with SMTP id un15so1032717pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 19:49:26 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Mar 2012 22:49:25 -0400
Message-ID: <CALGY4fuhWYBgSmw6LAwTFNq0b9J7pyFb2271LH0GcT71nmuNow@mail.gmail.com> (sfid-20120330_044931_504853_4B8D25D9)
Subject: iwlwifi slow speed, unstable connection
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I'm experiencing very slow speed when I download large files over
the air. This doesn't really slow stuff down for web surfing, but when
I download large file speed is about 1MB/sec. This started to happen
after I installed new version of compat wireless somewhere in the
middle of March. Before this I had speed up to 5MB/sec in same
environment an dI was running compat-wireless from January. I do not
often download large files over the air from another locally connected
machine (by wire) so problem was unnoticed for some time and now I
cannot really provide exact version when problem started, I'll try to
figure this out, though.
  So problem appears on dell laptop with intel 5300 card running 3.2.9
kernel with some compat wireless from early march. I've tried to
install 'vanilla' 3.3 kernel from ubuntu repository and run into exact
same problem. I have an ath9k based AP with recent openwrt.

  Also, after some time downloading at that low speed connection drops
completely and I get this in logs:
-------------------------------
Mar 29 22:12:19 xxx kernel: [220407.141631] ------------[ cut here ]------------
Mar 29 22:12:19 xxx kernel: [220407.141674] WARNING: at
/home/xxx/projects/wireless/compat-wireless/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:894
iwl_tx_cmd_complete+0x341/0x380 [iwlwifi]()
Mar 29 22:12:19 xxx kernel: [220407.141682] Hardware name: MM061
Mar 29 22:12:19 xxx kernel: [220407.141690] wrong command queue 7
(should be 4), sequence 0x2723 readp=7 writep=7
Mar 29 22:12:19 xxx kernel: [220407.141694] Modules linked in:
ftdi_sio usbserial binfmt_misc ip6table_filter ip6_tables
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp kvm_intel kvm parport_pc
ppdev arc4 iwlwifi(O) mac80211(O) joydev dell_laptop dcdbas
snd_hda_codec_idt pcmcia snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_seq_midi r852 sm_common nand nand_ids mtd nand_bch bch cfg80211(O)
snd_rawmidi snd_seq_midi_event psmouse r592 nand_ecc memstick
pcmcia_core snd_seq serio_raw compat(O) snd_timer snd_seq_device lp
dm_multipath parport snd dell_wmi sparse_keymap soundcore
snd_page_alloc mac_hid btrfs zlib_deflate libcrc32c radeon ttm
drm_kms_helper drm firewire_ohci firewire_core video sdhci_pci sdhci
wmi ssb crc_itu_t i2c_algo_bit
Mar 29 22:12:19 xxx kernel: [220407.141864] Pid: 0, comm: swapper/0
Tainted: G           O 3.2.9-030209-generic-pae #201202292059
Mar 29 22:12:19 xxx kernel: [220407.141869] Call Trace:
Mar 29 22:12:19 xxx kernel: [220407.141884]  [<c1058f42>]
warn_slowpath_common+0x72/0xa0
Mar 29 22:12:19 xxx kernel: [220407.141911]  [<f958e361>] ?
iwl_tx_cmd_complete+0x341/0x380 [iwlwifi]
Mar 29 22:12:19 xxx kernel: [220407.141937]  [<f958e361>] ?
iwl_tx_cmd_complete+0x341/0x380 [iwlwifi]
Mar 29 22:12:19 xxx kernel: [220407.141946]  [<c1059013>]
warn_slowpath_fmt+0x33/0x40
Mar 29 22:12:19 xxx kernel: [220407.141971]  [<f958e361>]
iwl_tx_cmd_complete+0x341/0x380 [iwlwifi]
Mar 29 22:12:19 xxx kernel: [220407.141997]  [<f957a9ee>] ?
iwl_rx_dispatch+0xce/0xf0 [iwlwifi]
Mar 29 22:12:19 xxx kernel: [220407.142023]  [<f958b577>]
iwl_irq_tasklet+0x447/0xd50 [iwlwifi]
Mar 29 22:12:19 xxx kernel: [220407.142035]  [<c105f929>]
tasklet_action+0xa9/0xe0
Mar 29 22:12:19 xxx kernel: [220407.142043]  [<c105f5ce>]
__do_softirq+0x9e/0x1b0
Mar 29 22:12:19 xxx kernel: [220407.142052]  [<c1598ee4>] ?
nmi_stack_correct+0x2f/0x34
Mar 29 22:12:19 xxx kernel: [220407.142061]  [<c105f530>] ? irq_enter+0x70/0x70
Mar 29 22:12:19 xxx kernel: [220407.142069]  [<c105f530>] ? irq_enter+0x70/0x70
Mar 29 22:12:19 xxx kernel: [220407.142073]  <IRQ>  [<c105f40d>] ?
irq_exit+0x9d/0xc0
Mar 29 22:12:19 xxx kernel: [220407.142087]  [<c159fbdb>] ? do_IRQ+0x4b/0xc0
Mar 29 22:12:19 xxx kernel: [220407.142095]  [<c107eb32>] ?
sched_clock_local+0xb2/0x190
Mar 29 22:12:19 xxx kernel: [220407.142104]  [<c159fa30>] ?
common_interrupt+0x30/0x38
Mar 29 22:12:19 xxx kernel: [220407.142112]  [<c107007b>] ?
sys_olduname+0xcb/0x1b0
Mar 29 22:12:19 xxx kernel: [220407.142122]  [<c132be99>] ?
acpi_idle_enter_simple+0xef/0x12a
Mar 29 22:12:19 xxx kernel: [220407.142134]  [<c148068b>] ?
cpuidle_idle_call+0xab/0x1d0
Mar 29 22:12:19 xxx kernel: [220407.142143]  [<c10105c4>] ? cpu_idle+0xa4/0xe0
Mar 29 22:12:19 xxx kernel: [220407.142152]  [<c157ae5d>] ? rest_init+0x5d/0x70
Mar 29 22:12:19 xxx kernel: [220407.142162]  [<c185a894>] ?
start_kernel+0x35e/0x364
Mar 29 22:12:19 xxx kernel: [220407.142170]  [<c185a360>] ?
kernel_init+0x14a/0x14a
Mar 29 22:12:19 xxx kernel: [220407.142178]  [<c185a0c4>] ?
i386_start_kernel+0xb3/0xbb
Mar 29 22:12:19 xxx kernel: [220407.142184] ---[ end trace faabf7cf620ccbbe ]---
Mar 29 22:12:19 xxx kernel: [220407.142192] iwl data: 00000000: 00 00
55 55 0e 52 23 27 c4 01 d9 08 28 da e4 d8  ..UU.R#'....(...
Mar 29 22:12:19 xxx kernel: [220407.142200] iwl data: 00000010: 86 51
f0 5e a0 ed 57 14 5c ad ba 1b 7c 51 bd c5  .Q.^..W.\...|Q..
Mar 29 22:12:19 xxx kernel: [220407.142218] iwlwifi 0000:0b:00.0:
iwl_tx_queue_reclaim: Read index for DMA queue txq id (11),
last_to_free 95 is out of range [0-256] 151 151.
Mar 29 22:12:23 xxx kernel: [220410.496084] iwlwifi 0000:0b:00.0:
Error sending REPLY_ADD_STA: time out after 2000ms.
Mar 29 22:12:23 xxx kernel: [220410.496095] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 8
Mar 29 22:12:23 xxx kernel: [220410.496103] HW problem - can not stop
rx aggregation for tid 0
Mar 29 22:12:25 xxx kernel: [220412.508116] iwlwifi 0000:0b:00.0:
Error sending REPLY_ADD_STA: time out after 2000ms.
Mar 29 22:12:25 xxx kernel: [220412.508127] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 9
Mar 29 22:12:25 xxx kernel: [220412.508139] ieee80211 phy0: failed to
remove key (0, 00:14:d1:53:50:2d) from hardware (-110)
Mar 29 22:12:27 xxx kernel: [220414.512090] iwlwifi 0000:0b:00.0:
Error sending REPLY_QOS_PARAM: time out after 2000ms.
Mar 29 22:12:27 xxx kernel: [220414.512101] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 10
Mar 29 22:12:27 xxx kernel: [220414.512109] iwlwifi 0000:0b:00.0:
Failed to update QoS
Mar 29 22:12:29 xxx kernel: [220416.512341] iwlwifi 0000:0b:00.0:
Error sending REPLY_RXON: time out after 2000ms.
Mar 29 22:12:29 xxx kernel: [220416.512352] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 11
Mar 29 22:12:29 xxx kernel: [220416.512360] iwlwifi 0000:0b:00.0:
Error clearing ASSOC_MSK on BSS (-110)
Mar 29 22:12:31 xxx kernel: [220418.512083] iwlwifi 0000:0b:00.0:
Error sending REPLY_RXON: time out after 2000ms.
Mar 29 22:12:31 xxx kernel: [220418.512094] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 12
Mar 29 22:12:31 xxx kernel: [220418.512102] iwlwifi 0000:0b:00.0:
Error clearing ASSOC_MSK on BSS (-110)
Mar 29 22:12:33 xxx kernel: [220420.528275] iwlwifi 0000:0b:00.0:
Error sending REPLY_ADD_STA: time out after 2000ms.
Mar 29 22:12:33 xxx kernel: [220420.528286] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 13
Mar 29 22:12:33 xxx kernel: [220420.528298] ieee80211 phy0: failed to
remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-110)
Mar 29 22:12:33 xxx kernel: [220420.528538] cfg80211: All devices are
disconnected, going to restore regulatory settings
Mar 29 22:12:33 xxx kernel: [220420.528553] cfg80211: Restoring
regulatory settings
Mar 29 22:12:33 xxx kernel: [220420.528562] cfg80211: Calling CRDA to
update world regulatory domain
Mar 29 22:12:33 xxx kernel: [220420.561616] cfg80211: Ignoring
regulatory request Set by core since the driver uses its own custom
regulatory domain
Mar 29 22:12:33 xxx kernel: [220420.561620] cfg80211: World regulatory
domain updated:
Mar 29 22:12:33 xxx kernel: [220420.561623] cfg80211:   (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 29 22:12:33 xxx kernel: [220420.561627] cfg80211:   (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:12:33 xxx kernel: [220420.561631] cfg80211:   (2457000 KHz -
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:12:33 xxx kernel: [220420.561635] cfg80211:   (2474000 KHz -
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:12:33 xxx kernel: [220420.561638] cfg80211:   (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:12:33 xxx kernel: [220420.561642] cfg80211:   (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:12:35 xxx kernel: [220422.528111] iwlwifi 0000:0b:00.0:
Error sending REPLY_RXON: time out after 2000ms.
Mar 29 22:12:35 xxx kernel: [220422.528121] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 14
Mar 29 22:12:35 xxx kernel: [220422.528129] iwlwifi 0000:0b:00.0:
Error clearing ASSOC_MSK on BSS (-110)
Mar 29 22:12:37 xxx kernel: [220424.532095] iwlwifi 0000:0b:00.0: fail
to flush all tx fifo queues
Mar 29 22:12:39 xxx kernel: [220426.532091] iwlwifi 0000:0b:00.0:
Error sending REPLY_RXON: time out after 2000ms.
Mar 29 22:12:39 xxx kernel: [220426.532102] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 15
Mar 29 22:12:39 xxx kernel: [220426.532110] iwlwifi 0000:0b:00.0:
Error clearing ASSOC_MSK on BSS (-110)
Mar 29 22:12:41 xxx kernel: [220428.532133] iwlwifi 0000:0b:00.0:
Error sending REPLY_RXON: time out after 2000ms.
Mar 29 22:12:41 xxx kernel: [220428.532144] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 16
Mar 29 22:12:41 xxx kernel: [220428.532152] iwlwifi 0000:0b:00.0:
Error clearing ASSOC_MSK on BSS (-110)
Mar 29 22:12:43 xxx kernel: [220430.532238] iwlwifi 0000:0b:00.0:
Error sending REPLY_RXON: time out after 2000ms.
Mar 29 22:12:43 xxx kernel: [220430.532249] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 17
Mar 29 22:12:43 xxx kernel: [220430.532258] iwlwifi 0000:0b:00.0:
Error clearing ASSOC_MSK on BSS (-110)
Mar 29 22:12:45 xxx kernel: [220432.532120] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:12:45 xxx kernel: [220432.532131] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 18
Mar 29 22:12:48 xxx kernel: [220435.532061] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:12:48 xxx kernel: [220435.532068] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 19
Mar 29 22:12:51 xxx kernel: [220438.533726] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:12:51 xxx kernel: [220438.533737] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 20
Mar 29 22:12:54 xxx kernel: [220441.532054] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:12:54 xxx kernel: [220441.532061] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 21
Mar 29 22:12:57 xxx kernel: [220444.532081] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:12:57 xxx kernel: [220444.532092] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 22
Mar 29 22:13:00 xxx kernel: [220447.532071] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:00 xxx kernel: [220447.532082] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 23
Mar 29 22:13:03 xxx kernel: [220450.532090] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:03 xxx kernel: [220450.532102] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 24
Mar 29 22:13:06 xxx kernel: [220453.532119] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:06 xxx kernel: [220453.532130] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 25
Mar 29 22:13:09 xxx kernel: [220456.532097] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:09 xxx kernel: [220456.532108] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 26
Mar 29 22:13:12 xxx kernel: [220459.532087] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:12 xxx kernel: [220459.532098] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 27
Mar 29 22:13:15 xxx kernel: [220462.532096] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:15 xxx kernel: [220462.532107] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 28
Mar 29 22:13:18 xxx kernel: [220465.532092] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:18 xxx kernel: [220465.532102] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 29
Mar 29 22:13:21 xxx kernel: [220468.532098] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:21 xxx kernel: [220468.532109] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 31
Mar 29 22:13:24 xxx kernel: [220471.532114] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:24 xxx kernel: [220471.532125] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 32
Mar 29 22:13:27 xxx kernel: [220474.532089] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:27 xxx kernel: [220474.532117] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 33
Mar 29 22:13:30 xxx kernel: [220477.532055] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:30 xxx kernel: [220477.532067] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 34
Mar 29 22:13:33 xxx kernel: [220480.532064] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:33 xxx kernel: [220480.532071] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 35
Mar 29 22:13:36 xxx kernel: [220483.536166] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:36 xxx kernel: [220483.536173] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 36
Mar 29 22:13:39 xxx kernel: [220486.544044] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:13:39 xxx kernel: [220486.544050] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 7 write_ptr 37
Mar 29 22:13:40 xxx kernel: [220487.544919] iwlwifi 0000:0b:00.0: No
space in command queue
Mar 29 22:13:40 xxx kernel: [220487.544926] iwlwifi 0000:0b:00.0:
Restarting adapter queue is full
Mar 29 22:13:40 xxx kernel: [220487.544935] iwlwifi 0000:0b:00.0:
Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
Mar 29 22:13:40 xxx kernel: [220487.548010] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 1 [0xa5a5a5a2]
Mar 29 22:13:40 xxx kernel: [220487.548010] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 3 [0xa5a5a5a2]
Mar 29 22:13:40 xxx kernel: [220487.548010] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 4 [0xa5a5a5a2]
Mar 29 22:13:40 xxx kernel: [220487.548010] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 6 [0xa5a5a5a2]
Mar 29 22:13:40 xxx kernel: [220487.571928] ieee80211 phy0: Hardware
restart was requested
Mar 29 22:13:40 xxx kernel: [220487.572110] iwlwifi 0000:0b:00.0: L1
Enabled; Disabling L0S
Mar 29 22:13:40 xxx kernel: [220487.575168] iwlwifi 0000:0b:00.0:
Radio type=0x0-0x2-0x0
Mar 29 22:13:44 xxx kernel: [220491.796631] wlan1: authenticate with
00:14:d1:53:50:2d
Mar 29 22:13:44 xxx kernel: [220491.798322] wlan1: send auth to
00:14:d1:53:50:2d (try 1/3)
Mar 29 22:13:44 xxx kernel: [220491.804052] wlan1: authenticated
Mar 29 22:13:44 xxx kernel: [220491.808138] wlan1: associate with
00:14:d1:53:50:2d (try 1/3)
Mar 29 22:13:44 xxx kernel: [220492.012053] wlan1: associate with
00:14:d1:53:50:2d (try 2/3)
Mar 29 22:13:44 xxx kernel: [220492.040092] wlan1: RX AssocResp from
00:14:d1:53:50:2d (capab=0x411 status=0 aid=1)
Mar 29 22:13:44 xxx kernel: [220492.040102] wlan1: associated
-------------------------------
This piece of logs appered on 3.2 + compat-wireless.

On 3.3 I get this:
-------------------------------
Mar 29 22:20:28 xxx kernel: [   46.276054] cfg80211: Regulatory domain
changed to country: CA
Mar 29 22:20:28 xxx kernel: [   46.276056] cfg80211:   (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 29 22:20:28 xxx kernel: [   46.276060] cfg80211:   (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Mar 29 22:20:28 xxx kernel: [   46.276063] cfg80211:   (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Mar 29 22:20:28 xxx kernel: [   46.276067] cfg80211:   (5250000 KHz -
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:20:28 xxx kernel: [   46.276071] cfg80211:   (5490000 KHz -
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:20:28 xxx kernel: [   46.276074] cfg80211:   (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Mar 29 22:20:34 xxx kernel: [   52.455511] EXT4-fs (sda2): re-mounted.
Opts: errors=remount-ro,commit=0
Mar 29 22:20:34 xxx kernel: [   52.521317] EXT4-fs (sda5): re-mounted.
Opts: commit=0
Mar 29 22:20:34 xxx kernel: [   52.550460] EXT4-fs (sda6): re-mounted.
Opts: commit=0
Mar 29 22:21:33 xxx kernel: [  111.504166] usb 5-2: USB disconnect,
device number 2
Mar 29 22:24:16 xxx kernel: [  274.625842] process `skype' is using
obsolete setsockopt SO_BSDCOMPAT
Mar 29 22:26:13 xxx kernel: [  391.333512] CE: hpet increased
min_delta_ns to 20113 nsec
Mar 29 22:26:32 xxx kernel: [  409.985814] ICMPv6 RA:
ndisc_router_discovery() failed to add default route.
Mar 29 22:27:59 xxx kernel: [  496.923356] CE: hpet increased
min_delta_ns to 30169 nsec
Mar 29 22:28:46 xxx kernel: [  544.508077] iwlwifi 0000:0b:00.0: Error
sending REPLY_ADD_STA: time out after 2000ms.
Mar 29 22:28:46 xxx kernel: [  544.508087] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 228
Mar 29 22:28:46 xxx kernel: [  544.508095] HW problem - can not stop
rx aggregation for tid 0
Mar 29 22:28:48 xxx kernel: [  546.508084] iwlwifi 0000:0b:00.0: Error
sending REPLY_QOS_PARAM: time out after 2000ms.
Mar 29 22:28:48 xxx kernel: [  546.508094] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 229
Mar 29 22:28:48 xxx kernel: [  546.508101] iwlwifi 0000:0b:00.0:
Failed to update QoS
Mar 29 22:28:50 xxx kernel: [  548.508057] iwlwifi 0000:0b:00.0: Error
sending REPLY_RXON: time out after 2000ms.
Mar 29 22:28:50 xxx kernel: [  548.508066] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 230
Mar 29 22:28:50 xxx kernel: [  548.508074] iwlwifi 0000:0b:00.0: Error
clearing ASSOC_MSK on BSS (-110)
Mar 29 22:28:52 xxx kernel: [  550.508052] iwlwifi 0000:0b:00.0: Error
sending REPLY_RXON: time out after 2000ms.
Mar 29 22:28:52 xxx kernel: [  550.508062] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 231
Mar 29 22:28:52 xxx kernel: [  550.508069] iwlwifi 0000:0b:00.0: Error
clearing ASSOC_MSK on BSS (-110)
Mar 29 22:28:54 xxx kernel: [  552.508081] iwlwifi 0000:0b:00.0: Error
sending REPLY_RXON: time out after 2000ms.
Mar 29 22:28:54 xxx kernel: [  552.508092] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 232
Mar 29 22:28:54 xxx kernel: [  552.508099] iwlwifi 0000:0b:00.0: Error
clearing ASSOC_MSK on BSS (-110)
Mar 29 22:28:56 xxx kernel: [  554.508067] iwlwifi 0000:0b:00.0: Error
sending REPLY_ADD_STA: time out after 2000ms.
Mar 29 22:28:56 xxx kernel: [  554.508073] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 233
Mar 29 22:28:56 xxx kernel: [  554.508080] ieee80211 phy0: failed to
remove key (0, 00:14:d1:53:50:2d) from hardware (-110)
Mar 29 22:28:56 xxx kernel: [  554.508129] wlan1: moving STA
00:14:d1:53:50:2d to state 2
Mar 29 22:28:56 xxx kernel: [  554.508132] wlan1: moving STA
00:14:d1:53:50:2d to state 1
Mar 29 22:28:56 xxx kernel: [  554.508135] wlan1: moving STA
00:14:d1:53:50:2d to state 0
Mar 29 22:28:58 xxx kernel: [  556.508091] iwlwifi 0000:0b:00.0: Error
sending REPLY_REMOVE_STA: time out after 2000ms.
Mar 29 22:28:58 xxx kernel: [  556.508096] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 234
Mar 29 22:28:58 xxx kernel: [  556.508101] iwlwifi 0000:0b:00.0: Error
removing station 00:14:d1:53:50:2d
Mar 29 22:29:00 xxx kernel: [  558.508074] iwlwifi 0000:0b:00.0: Error
sending REPLY_ADD_STA: time out after 2000ms.
Mar 29 22:29:00 xxx kernel: [  558.508080] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 235
Mar 29 22:29:00 xxx kernel: [  558.508086] ieee80211 phy0: failed to
remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-110)
Mar 29 22:29:02 xxx kernel: [  560.508080] iwlwifi 0000:0b:00.0: Error
sending REPLY_ADD_STA: time out after 2000ms.
Mar 29 22:29:02 xxx kernel: [  560.508090] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 236
Mar 29 22:29:02 xxx kernel: [  560.508100] ieee80211 phy0: failed to
remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-110)
Mar 29 22:29:02 xxx kernel: [  560.508239] cfg80211: All devices are
disconnected, going to restore regulatory settings
Mar 29 22:29:02 xxx kernel: [  560.508248] cfg80211: Restoring
regulatory settings
Mar 29 22:29:02 xxx kernel: [  560.508256] cfg80211: Calling CRDA to
update world regulatory domain
Mar 29 22:29:02 xxx kernel: [  560.518641] cfg80211: Ignoring
regulatory request Set by core since the driver uses its own custom
regulatory domain
Mar 29 22:29:02 xxx kernel: [  560.518649] cfg80211: World regulatory
domain updated:
Mar 29 22:29:02 xxx kernel: [  560.518653] cfg80211:   (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 29 22:29:02 xxx kernel: [  560.518661] cfg80211:   (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:29:02 xxx kernel: [  560.518668] cfg80211:   (2457000 KHz -
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:29:02 xxx kernel: [  560.518675] cfg80211:   (2474000 KHz -
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:29:02 xxx kernel: [  560.518682] cfg80211:   (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:29:02 xxx kernel: [  560.518689] cfg80211:   (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:29:04 xxx kernel: [  562.508084] iwlwifi 0000:0b:00.0: Error
sending REPLY_RXON: time out after 2000ms.
Mar 29 22:29:04 xxx kernel: [  562.508093] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 237
Mar 29 22:29:04 xxx kernel: [  562.508100] iwlwifi 0000:0b:00.0: Error
clearing ASSOC_MSK on BSS (-110)
Mar 29 22:29:06 xxx kernel: [  564.516101] iwlwifi 0000:0b:00.0: fail
to flush all tx fifo queues
Mar 29 22:29:08 xxx kernel: [  566.516075] iwlwifi 0000:0b:00.0: Error
sending REPLY_RXON: time out after 2000ms.
Mar 29 22:29:08 xxx kernel: [  566.516085] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 238
Mar 29 22:29:08 xxx kernel: [  566.516093] iwlwifi 0000:0b:00.0: Error
clearing ASSOC_MSK on BSS (-110)
Mar 29 22:29:10 xxx kernel: [  568.516083] iwlwifi 0000:0b:00.0: Error
sending REPLY_RXON: time out after 2000ms.
Mar 29 22:29:10 xxx kernel: [  568.516092] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 239
Mar 29 22:29:10 xxx kernel: [  568.516100] iwlwifi 0000:0b:00.0: Error
clearing ASSOC_MSK on BSS (-110)
Mar 29 22:29:12 xxx kernel: [  570.516111] iwlwifi 0000:0b:00.0: Error
sending REPLY_RXON: time out after 2000ms.
Mar 29 22:29:12 xxx kernel: [  570.516120] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 240
Mar 29 22:29:12 xxx kernel: [  570.516128] iwlwifi 0000:0b:00.0: Error
clearing ASSOC_MSK on BSS (-110)
Mar 29 22:29:14 xxx kernel: [  572.516078] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:14 xxx kernel: [  572.516088] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 241
Mar 29 22:29:17 xxx kernel: [  575.516110] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:17 xxx kernel: [  575.516120] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 242
Mar 29 22:29:20 xxx kernel: [  578.520078] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:20 xxx kernel: [  578.520089] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 243
Mar 29 22:29:23 xxx kernel: [  581.520119] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:23 xxx kernel: [  581.520129] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 244
Mar 29 22:29:26 xxx kernel: [  584.520078] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:26 xxx kernel: [  584.520088] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 245
Mar 29 22:29:29 xxx kernel: [  587.520082] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:29 xxx kernel: [  587.520092] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 246
Mar 29 22:29:32 xxx kernel: [  590.520106] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:32 xxx kernel: [  590.520117] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 247
Mar 29 22:29:35 xxx kernel: [  593.520047] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:35 xxx kernel: [  593.520053] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 248
Mar 29 22:29:38 xxx kernel: [  596.520066] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:38 xxx kernel: [  596.520076] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 249
Mar 29 22:29:41 xxx kernel: [  599.520087] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:41 xxx kernel: [  599.520097] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 250
Mar 29 22:29:44 xxx kernel: [  602.520104] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:44 xxx kernel: [  602.520114] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 252
Mar 29 22:29:47 xxx kernel: [  605.520090] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:47 xxx kernel: [  605.520100] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 253
Mar 29 22:29:50 xxx kernel: [  608.520049] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:50 xxx kernel: [  608.520060] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 254
Mar 29 22:29:53 xxx kernel: [  611.520070] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:53 xxx kernel: [  611.520080] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 255
Mar 29 22:29:56 xxx kernel: [  614.520067] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:56 xxx kernel: [  614.520077] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 0
Mar 29 22:29:59 xxx kernel: [  617.520079] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: time out after 2000ms.
Mar 29 22:29:59 xxx kernel: [  617.520089] iwlwifi 0000:0b:00.0:
Current CMD queue read_ptr 227 write_ptr 1
Mar 29 22:30:00 xxx kernel: [  618.521622] iwlwifi 0000:0b:00.0: No
space in command queue
Mar 29 22:30:00 xxx kernel: [  618.521629] iwlwifi 0000:0b:00.0:
Restarting adapter queue is full
Mar 29 22:30:00 xxx kernel: [  618.521639] iwlwifi 0000:0b:00.0: Error
sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
Mar 29 22:30:00 xxx kernel: [  618.525475] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 1 [0xa5a5a5a2]
Mar 29 22:30:00 xxx kernel: [  618.525475] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 3 [0xa5a5a5a2]
Mar 29 22:30:00 xxx kernel: [  618.525475] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 4 [0xa5a5a5a2]
Mar 29 22:30:00 xxx kernel: [  618.525475] iwlwifi 0000:0b:00.0:
Failing on timeout while stopping DMA channel 6 [0xa5a5a5a2]
Mar 29 22:30:00 xxx kernel: [  618.548273] ieee80211 phy0: Hardware
restart was requested
-------------------------------

And after reconnect (and this reconnect takes long time) connection is
very slow and I get this after some time:
-------------------------------
Mar 29 22:30:42 xxx kernel: [  660.654234] cfg80211: Regulatory domain
changed to country: CA
Mar 29 22:30:42 xxx kernel: [  660.654239] cfg80211:   (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 29 22:30:42 xxx kernel: [  660.654246] cfg80211:   (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Mar 29 22:30:42 xxx kernel: [  660.654252] cfg80211:   (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Mar 29 22:30:42 xxx kernel: [  660.654259] cfg80211:   (5250000 KHz -
5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:30:42 xxx kernel: [  660.654266] cfg80211:   (5490000 KHz -
5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 29 22:30:42 xxx kernel: [  660.654272] cfg80211:   (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Mar 29 22:34:07 xxx kernel: [  865.228935] iwlwifi 0000:0b:00.0:
Microcode SW error detected.  Restarting 0x82000000.
Mar 29 22:34:07 xxx kernel: [  865.228941] iwlwifi 0000:0b:00.0:
Loaded firmware version: 8.83.5.1 build 33692
Mar 29 22:34:07 xxx kernel: [  865.232453] iwlwifi 0000:0b:00.0: Start
IWL Error Log Dump:
Mar 29 22:34:07 xxx kernel: [  865.232457] iwlwifi 0000:0b:00.0:
Status: 0x000412E4, count: 5
Mar 29 22:34:07 xxx kernel: [  865.232461] iwlwifi 0000:0b:00.0:
0x0000000C | FH_ERROR
Mar 29 22:34:07 xxx kernel: [  865.232464] iwlwifi 0000:0b:00.0:
0x000006E4 | uPc
Mar 29 22:34:07 xxx kernel: [  865.232467] iwlwifi 0000:0b:00.0:
0x000005AA | branchlink1
Mar 29 22:34:07 xxx kernel: [  865.232470] iwlwifi 0000:0b:00.0:
0x00000820 | branchlink2
Mar 29 22:34:07 xxx kernel: [  865.232472] iwlwifi 0000:0b:00.0:
0x00000916 | interruptlink1
Mar 29 22:34:07 xxx kernel: [  865.232475] iwlwifi 0000:0b:00.0:
0x000027A2 | interruptlink2
Mar 29 22:34:07 xxx kernel: [  865.232478] iwlwifi 0000:0b:00.0:
0x00000020 | data1
Mar 29 22:34:07 xxx kernel: [  865.232481] iwlwifi 0000:0b:00.0:
0x03530000 | data2
Mar 29 22:34:07 xxx kernel: [  865.232484] iwlwifi 0000:0b:00.0:
0x000067C6 | line
Mar 29 22:34:07 xxx kernel: [  865.232487] iwlwifi 0000:0b:00.0:
0xF3817BB9 | beacon time
Mar 29 22:34:07 xxx kernel: [  865.232490] iwlwifi 0000:0b:00.0:
0xCFC34447 | tsf low
Mar 29 22:34:07 xxx kernel: [  865.232493] iwlwifi 0000:0b:00.0:
0x00000005 | tsf hi
Mar 29 22:34:07 xxx kernel: [  865.232495] iwlwifi 0000:0b:00.0:
0x00000000 | time gp1
Mar 29 22:34:07 xxx kernel: [  865.232498] iwlwifi 0000:0b:00.0:
0x0EB36008 | time gp2
Mar 29 22:34:07 xxx kernel: [  865.232501] iwlwifi 0000:0b:00.0:
0x00000000 | time gp3
Mar 29 22:34:07 xxx kernel: [  865.232504] iwlwifi 0000:0b:00.0:
0x00010853 | uCode version
Mar 29 22:34:07 xxx kernel: [  865.232507] iwlwifi 0000:0b:00.0:
0x00000024 | hw version
Mar 29 22:34:07 xxx kernel: [  865.232510] iwlwifi 0000:0b:00.0:
0x00480302 | board version
Mar 29 22:34:07 xxx kernel: [  865.232513] iwlwifi 0000:0b:00.0:
0x0BE6001C | hcmd
Mar 29 22:34:07 xxx kernel: [  865.232515] iwlwifi 0000:0b:00.0:
0x2FF73802 | isr0
Mar 29 22:34:07 xxx kernel: [  865.232518] iwlwifi 0000:0b:00.0:
0x01406000 | isr1
Mar 29 22:34:07 xxx kernel: [  865.232521] iwlwifi 0000:0b:00.0:
0x0000011A | isr2
Mar 29 22:34:07 xxx kernel: [  865.232523] iwlwifi 0000:0b:00.0:
0x004370C2 | isr3
Mar 29 22:34:07 xxx kernel: [  865.232526] iwlwifi 0000:0b:00.0:
0x10000112 | isr4
Mar 29 22:34:07 xxx kernel: [  865.232529] iwlwifi 0000:0b:00.0:
0x000067C6 | isr_pref
Mar 29 22:34:07 xxx kernel: [  865.232532] iwlwifi 0000:0b:00.0:
0x00004A88 | wait_event
Mar 29 22:34:07 xxx kernel: [  865.232534] iwlwifi 0000:0b:00.0:
0x0000002C | l2p_control
Mar 29 22:34:07 xxx kernel: [  865.232537] iwlwifi 0000:0b:00.0:
0x000003BF | l2p_duration
Mar 29 22:34:07 xxx kernel: [  865.232540] iwlwifi 0000:0b:00.0:
0x001054F7 | l2p_mhvalid
Mar 29 22:34:07 xxx kernel: [  865.232543] iwlwifi 0000:0b:00.0:
0x00000015 | l2p_addr_match
Mar 29 22:34:07 xxx kernel: [  865.232546] iwlwifi 0000:0b:00.0:
0x02121704 | lmpm_pmg_sel
Mar 29 22:34:07 xxx kernel: [  865.232548] iwlwifi 0000:0b:00.0:
0x06685060 | timestamp
Mar 29 22:34:07 xxx kernel: [  865.232551] iwlwifi 0000:0b:00.0:
0x00000100 | flow_handler
Mar 29 22:34:07 xxx kernel: [  865.232554] iwlwifi 0000:0b:00.0: CSR values:
Mar 29 22:34:07 xxx kernel: [  865.232556] iwlwifi 0000:0b:00.0: (2nd
byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Mar 29 22:34:07 xxx kernel: [  865.232585] iwlwifi 0000:0b:00.0:
 CSR_HW_IF_CONFIG_REG: 0X00480302
Mar 29 22:34:07 xxx kernel: [  865.232612] iwlwifi 0000:0b:00.0:
   CSR_INT_COALESCING: 0X0000ff40
Mar 29 22:34:07 xxx kernel: [  865.232623] iwlwifi 0000:0b:00.0:
              CSR_INT: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232635] iwlwifi 0000:0b:00.0:
         CSR_INT_MASK: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232646] iwlwifi 0000:0b:00.0:
    CSR_FH_INT_STATUS: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232657] iwlwifi 0000:0b:00.0:
          CSR_GPIO_IN: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232668] iwlwifi 0000:0b:00.0:
            CSR_RESET: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232680] iwlwifi 0000:0b:00.0:
         CSR_GP_CNTRL: 0X080403c5
Mar 29 22:34:07 xxx kernel: [  865.232708] iwlwifi 0000:0b:00.0:
           CSR_HW_REV: 0X00000024
Mar 29 22:34:07 xxx kernel: [  865.232735] iwlwifi 0000:0b:00.0:
       CSR_EEPROM_REG: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232746] iwlwifi 0000:0b:00.0:
        CSR_EEPROM_GP: 0X90000004
Mar 29 22:34:07 xxx kernel: [  865.232758] iwlwifi 0000:0b:00.0:
       CSR_OTP_GP_REG: 0X00060000
Mar 29 22:34:07 xxx kernel: [  865.232769] iwlwifi 0000:0b:00.0:
          CSR_GIO_REG: 0X00080042
Mar 29 22:34:07 xxx kernel: [  865.232780] iwlwifi 0000:0b:00.0:
     CSR_GP_UCODE_REG: 0X0000d990
Mar 29 22:34:07 xxx kernel: [  865.232792] iwlwifi 0000:0b:00.0:
    CSR_GP_DRIVER_REG: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232803] iwlwifi 0000:0b:00.0:
    CSR_UCODE_DRV_GP1: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232814] iwlwifi 0000:0b:00.0:
    CSR_UCODE_DRV_GP2: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.232826] iwlwifi 0000:0b:00.0:
          CSR_LED_REG: 0X00000078
Mar 29 22:34:07 xxx kernel: [  865.232837] iwlwifi 0000:0b:00.0:
 CSR_DRAM_INT_TBL_REG: 0X8803666f
Mar 29 22:34:07 xxx kernel: [  865.232848] iwlwifi 0000:0b:00.0:
 CSR_GIO_CHICKEN_BITS: 0X27800200
Mar 29 22:34:07 xxx kernel: [  865.232860] iwlwifi 0000:0b:00.0:
      CSR_ANA_PLL_CFG: 0X00880300
Mar 29 22:34:07 xxx kernel: [  865.232871] iwlwifi 0000:0b:00.0:
    CSR_HW_REV_WA_REG: 0X0001001a
Mar 29 22:34:07 xxx kernel: [  865.232882] iwlwifi 0000:0b:00.0:
 CSR_DBG_HPET_MEM_REG: 0Xffff0000
Mar 29 22:34:07 xxx kernel: [  865.232888] iwlwifi 0000:0b:00.0: FH
register values:
Mar 29 22:34:07 xxx kernel: [  865.232926] iwlwifi 0000:0b:00.0:
  FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X036d5000
Mar 29 22:34:07 xxx kernel: [  865.232949] iwlwifi 0000:0b:00.0:
 FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00366380
Mar 29 22:34:07 xxx kernel: [  865.232971] iwlwifi 0000:0b:00.0:
           FH_RSCSR_CHNL0_WPTR: 0X00000050
Mar 29 22:34:07 xxx kernel: [  865.232994] iwlwifi 0000:0b:00.0:
  FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00819104
Mar 29 22:34:07 xxx kernel: [  865.233016] iwlwifi 0000:0b:00.0:
   FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Mar 29 22:34:07 xxx kernel: [  865.233044] iwlwifi 0000:0b:00.0:
     FH_MEM_RSSR_RX_STATUS_REG: 0X03530000
Mar 29 22:34:07 xxx kernel: [  865.233087] iwlwifi 0000:0b:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.233128] iwlwifi 0000:0b:00.0:
         FH_TSSR_TX_STATUS_REG: 0X07ff0001
Mar 29 22:34:07 xxx kernel: [  865.233169] iwlwifi 0000:0b:00.0:
          FH_TSSR_TX_ERROR_REG: 0X00000000
Mar 29 22:34:07 xxx kernel: [  865.233331] iwlwifi 0000:0b:00.0: Start
IWL Event Log Dump: display last 20 entries
Mar 29 22:34:07 xxx kernel: [  865.233382] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635257:0x00000020:0322
Mar 29 22:34:07 xxx kernel: [  865.233413] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635257:0x00000030:0322
Mar 29 22:34:07 xxx kernel: [  865.233460] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635266:0x00000094:0322
Mar 29 22:34:07 xxx kernel: [  865.233507] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635364:0x00000113:0106
Mar 29 22:34:07 xxx kernel: [  865.233554] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635366:0x00000000:0302
Mar 29 22:34:07 xxx kernel: [  865.233586] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635392:0x00000440:0323
Mar 29 22:34:07 xxx kernel: [  865.233611] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635411:0x00000000:1350
Mar 29 22:34:07 xxx kernel: [  865.233645] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635412:0x00000000:1351
Mar 29 22:34:07 xxx kernel: [  865.233664] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635412:0x00000000:1352
Mar 29 22:34:07 xxx kernel: [  865.233682] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635413:0x00000002:1353
Mar 29 22:34:07 xxx kernel: [  865.233717] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246635806:0x0000001d:0355
Mar 29 22:34:07 xxx kernel: [  865.233735] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636377:0x00000113:0106
Mar 29 22:34:07 xxx kernel: [  865.233753] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636379:0x00000000:0302
Mar 29 22:34:07 xxx kernel: [  865.233771] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636405:0x00000440:0323
Mar 29 22:34:07 xxx kernel: [  865.233790] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636424:0x00000000:1350
Mar 29 22:34:07 xxx kernel: [  865.233824] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636425:0x00000000:1351
Mar 29 22:34:07 xxx kernel: [  865.233842] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636425:0x00000000:1352
Mar 29 22:34:07 xxx kernel: [  865.233874] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636425:0x00000002:1353
Mar 29 22:34:07 xxx kernel: [  865.233920] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636536:0x000000d7:0123
Mar 29 22:34:07 xxx kernel: [  865.233952] iwlwifi 0000:0b:00.0:
EVT_LOGT:0246636574:0x00000000:0125
Mar 29 22:34:07 xxx kernel: [  865.234420] ieee80211 phy0: Hardware
restart was requested
Mar 29 22:34:07 xxx kernel: [  865.234522] iwlwifi 0000:0b:00.0: L1
Enabled; Disabling L0S
Mar 29 22:34:07 xxx kernel: [  865.237585] iwlwifi 0000:0b:00.0: Radio
type=0x0-0x2-0x0
Mar 29 22:34:13 xxx kernel: [  870.661583] ICMPv6 RA:
ndisc_router_discovery() failed to add default route.
Mar 29 22:39:47 xxx kernel: [ 1205.589254] CE: hpet increased
min_delta_ns to 45253 nsec
Mar 29 22:40:40 xxx kernel: [ 1258.040689] ICMPv6 RA:
ndisc_router_discovery() failed to add default route.
Mar 29 22:40:54 xxx kernel: [ 1272.210830] wlan1: deauthenticating
from 00:14:d1:53:50:2d by local choice (reason=3)
Mar 29 22:40:54 xxx kernel: [ 1272.212312] wlan1: moving STA
00:14:d1:53:50:2d to state 2
Mar 29 22:40:54 xxx kernel: [ 1272.212318] wlan1: moving STA
00:14:d1:53:50:2d to state 1
Mar 29 22:40:54 xxx kernel: [ 1272.212323] wlan1: moving STA
00:14:d1:53:50:2d to state 0
Mar 29 22:40:54 xxx kernel: [ 1272.214647] cfg80211: All devices are
disconnected, going to restore regulatory settings
Mar 29 22:40:54 xxx kernel: [ 1272.214655] cfg80211: Restoring
regulatory settings
Mar 29 22:40:54 xxx kernel: [ 1272.214664] cfg80211: Calling CRDA to
update world regulatory domain
Mar 29 22:40:54 xxx kernel: [ 1272.234584] cfg80211: Ignoring
regulatory request Set by core since the driver uses its own custom
regulatory domain
-------------------------------

I do install new compat-wireless from time to time and I had almost
perfectly stable (and fast) wifi before march, so this looks like
quite recent regression.

I'd be happy to provide any additional information required or test any patches.

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
