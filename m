Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:28819 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751617AbZBEO7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 09:59:40 -0500
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n15ERWI26805
	for <linux-wireless@vger.kernel.org>; Thu, 5 Feb 2009 15:27:32 +0100
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id n15EPvOL016080
	for <linux-wireless@vger.kernel.org>; Thu, 5 Feb 2009 15:25:58 +0100
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 27CBC4335CF
	for <linux-wireless@vger.kernel.org>; Thu,  5 Feb 2009 15:25:57 +0100 (CET)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lT2oMoFXVFh2 for <linux-wireless@vger.kernel.org>;
	Thu,  5 Feb 2009 15:25:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 0E0494335D9
	for <linux-wireless@vger.kernel.org>; Thu,  5 Feb 2009 15:25:51 +0100 (CET)
Message-ID: <20090205152550.10936yvgbf2eipcs@neo.wg.de> (sfid-20090205_155943_225072_BC6C929C)
Date: Thu, 05 Feb 2009 15:25:50 +0100
From: Jan Schneider <jan@horde.org>
To: linux-wireless@vger.kernel.org
Subject: iwlagn crashing
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

since there doesn't seem to be a bug tracker, I'm gonna report it  
here. Exactly every 10 minutes, I get this dump in the logs:

Feb  5 14:38:27 tank kernel: [ 6267.996208] no space for a new  
keyModules linked
  in: aes_x86_64 aes_generic af_packet i915 drm rfcomm bnep sco l2cap  
ipt_MASQUER
ADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack  
ipt_REJECT xt_tcp
udp bridge stp kvm_intel kvm ppdev vmnet vmblock vmci vmmon ipv6  
acpi_cpufreq cp
ufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative  
cpufreq_ond
emand freq_table container sbs sbshc pci_slot iptable_filter ip_tables  
x_tables
uinput sbp2 lp btusb bluetooth pcmcia snd_hda_intel arc4 snd_pcm_oss  
ecb snd_mix
er_oss crypto_blkcipher snd_pcm iwlagn iwlcore snd_seq_dummy dcdbas  
snd_seq_oss
rfkill dm_multipath psmouse sdhci_pci scsi_dh sdhci led_class pcspkr  
ricoh_mmc s
erio_raw yenta_socket rsrc_nonstatic joydev mmc_core mac80211  
snd_seq_midi pcmci
a_core snd_rawmidi snd_seq_midi_event snd_seq cfg80211 snd_timer  
snd_seq_device
snd uvcvideo soundcore compat_ioctl32 shpchp pci_hotplug  
snd_page_alloc videodev
  v4l1_compat evdev video output parport_pc parport wmi button ac
Feb  5 14:38:27 tank kernel: battery intel_agp usbhid hid ext3 jbd  
mbcache sr_mo
d cdrom sd_mod crc_t10dif sg pata_acpi ohci1394 ahci ata_generic  
ieee1394 ehci_h
cd uhci_hcd libata scsi_mod dock usbcore e1000e dm_mirror dm_log  
dm_snapshot dm_
mod thermal processor fan fbcon tileblit font bitblit softcursor fuse
Feb  5 14:38:27 tank kernel: [ 6267.996419] Pid: 9, comm: events/0 Tainted: G
      W 2.6.27-11-generic #1
Feb  5 14:38:27 tank kernel: [ 6267.996424]
Feb  5 14:38:27 tank kernel: [ 6267.996426] Call Trace:
Feb  5 14:38:27 tank kernel: [ 6267.996442]  [<ffffffff8024e92c>]  
warn_slowpath+
0xbc/0xf0
Feb  5 14:38:27 tank kernel: [ 6267.996452]  [<ffffffff802ddc69>] ?  
constant_tes
t_bit+0x9/0x40
Feb  5 14:38:27 tank kernel: [ 6267.996461]  [<ffffffff8050367e>] ?  
_spin_lock+0xe/0x20
Feb  5 14:38:27 tank kernel: [ 6267.996468]  [<ffffffff802de75e>] ?  
get_partial_node+0xae/0xc0
Feb  5 14:38:27 tank kernel: [ 6267.996474]  [<ffffffff802e1f10>] ?  
__slab_alloc+0xd0/0x260
Feb  5 14:38:27 tank kernel: [ 6267.996482]  [<ffffffff80301b21>] ?  
alloc_inode+0x1f1/0x220
Feb  5 14:38:27 tank kernel: [ 6267.996489]  [<ffffffff802ff9d6>] ?  
__d_lookup+0x16/0x150
Feb  5 14:38:27 tank kernel: [ 6267.996496]  [<ffffffff80363499>] ?  
cap_d_instantiate+0x9/0x10
Feb  5 14:38:27 tank kernel: [ 6267.996505]  [<ffffffff80362e29>] ?  
cap_inode_alloc_security+0x9/0x10
Feb  5 14:38:27 tank kernel: [ 6267.996523]  [<ffffffffa0402930>] ?  
iwl_mac_set_key+0x0/0x160 [iwlagn]
Feb  5 14:38:27 tank kernel: [ 6267.996531]  [<ffffffff8036268b>] ?  
security_d_instantiate+0x1b/0x30
Feb  5 14:38:27 tank kernel: [ 6267.996538]  [<ffffffff802ffe55>] ?  
d_instantiate+0x75/0x90
Feb  5 14:38:27 tank kernel: [ 6267.996545]  [<ffffffff8031fff6>] ?  
inotify_inode_queue_event+0x16/0x100
Feb  5 14:38:27 tank kernel: [ 6267.996554]  [<ffffffff80350e1a>] ?  
debugfs_mknod+0xda/0x140
Feb  5 14:38:27 tank kernel: [ 6267.996560]  [<ffffffff80300549>] ?  
dput+0xb9/0x190
Feb  5 14:38:27 tank kernel: [ 6267.996566]  [<ffffffff80502179>] ?  
mutex_unlock+0x9/0x20
Feb  5 14:38:27 tank kernel: [ 6267.996586]  [<ffffffffa03ed412>]  
iwl_set_dynamic_key+0x492/0x4e0 [iwlcore]
Feb  5 14:38:27 tank kernel: [ 6267.996599]  [<ffffffff80351122>] ?  
debugfs_create_file+0x82/0xe0
Feb  5 14:38:27 tank kernel: [ 6267.996620]  [<ffffffffa03efc9e>] ?  
iwl_scan_cancel+0xe/0x80 [iwlcore]
Feb  5 14:38:27 tank kernel: [ 6267.996635]  [<ffffffffa0402a5c>]  
iwl_mac_set_key+0x12c/0x160 [iwlagn]
Feb  5 14:38:27 tank kernel: [ 6267.996673]  [<ffffffffa033b067>]  
__ieee80211_key_todo+0x167/0x330 [mac80211]
Feb  5 14:38:27 tank kernel: [ 6267.996706]  [<ffffffffa033b3b0>] ?  
key_todo+0x0/0x10 [mac80211]
Feb  5 14:38:27 tank kernel: [ 6267.996734]  [<ffffffffa033b39a>]  
ieee80211_key_todo+0x1a/0x30 [mac80211]
Feb  5 14:38:27 tank kernel: [ 6267.996762]  [<ffffffffa033b3be>]  
key_todo+0xe/0x10 [mac80211]
Feb  5 14:38:27 tank kernel: [ 6267.996771]  [<ffffffff80262812>]  
run_workqueue+0xc2/0x1a0
Feb  5 14:38:27 tank kernel: [ 6267.996783]  [<ffffffff80262b1f>]  
worker_thread+0xaf/0x130
Feb  5 14:38:27 tank kernel: [ 6267.996791]  [<ffffffff80267060>] ?  
autoremove_wake_function+0x0/0x40
Feb  5 14:38:27 tank kernel: [ 6267.996798]  [<ffffffff80262a70>] ?  
worker_thread+0x0/0x130
Feb  5 14:38:27 tank kernel: [ 6267.996803]  [<ffffffff80266c2e>]  
kthread+0x4e/0x90
Feb  5 14:38:27 tank kernel: [ 6267.996810]  [<ffffffff80213c99>]  
child_rip+0xa/0x11
Feb  5 14:38:27 tank kernel: [ 6267.996816]  [<ffffffff80266be0>] ?  
kthread+0x0/0x90
Feb  5 14:38:27 tank kernel: [ 6267.996821]  [<ffffffff80213c8f>] ?  
child_rip+0x0/0x11
Feb  5 14:38:27 tank kernel: [ 6267.996825]
Feb  5 14:38:27 tank kernel: [ 6267.996828] ---[ end trace  
ec5f349ce4f550a2 ]---

This is an Intel 5300 inside a Dell Latitude. I *used* to have all  
kind of other issues that I can't reliably reproduce at the moment, so  
I thought I would start with this one, and see if it fixes other  
issues too.
This is compat-wireless-2009-01-30.

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

