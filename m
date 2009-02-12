Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:35163 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZBLCEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 21:04:16 -0500
Received: by wa-out-1112.google.com with SMTP id v33so236979wah.21
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 18:04:15 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 18:04:15 -0800
Message-ID: <8f3763990902111804i173e3871o86fd849d706f6399@mail.gmail.com> (sfid-20090212_030421_094779_47CA893E)
Subject: mac80211: minstrel_get_rate trace (ath5k / today's kernel / ubuntu
	8.10)
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

below a trace I get a couple of times per hour.

System:
- ubuntu 8.10
- ath5k
- ibm t43
- today's kernel:
Linux darkslate 2.6.29-rc4-wl-felix_three #12 SMP Wed Feb 11 09:25:18
PST 2009 i686 GNU/Linux

Best regards,
Felix
--
Feb 11 10:10:15 darkslate kernel: [   86.029406] cfg80211: Calling
CRDA for country: US
Feb 11 10:10:16 darkslate kernel: [   87.096958] padlock: VIA PadLock
not detected.
Feb 11 10:10:19 darkslate kernel: [   90.626848] NET: Registered
protocol family 10
Feb 11 10:10:19 darkslate kernel: [   90.627940] lo: Disabled Privacy Extensions
Feb 11 10:10:19 darkslate kernel: [   90.631256] ADDRCONF(NETDEV_UP):
eth0: link is not ready
Feb 11 10:10:44 darkslate kernel: [  115.009798] process `skype' is
using obsolete setsockopt SO_BSDCOMPAT
Feb 11 10:29:09 darkslate -- MARK --
Feb 11 10:45:33 darkslate kernel: [ 2204.213266] ------------[ cut
here ]------------
Feb 11 10:45:33 darkslate kernel: [ 2204.213274] WARNING: at
include/net/mac80211.h:2050 minstrel_get_rate+0x9c/0x660 [mac80211]()
Feb 11 10:45:33 darkslate kernel: [ 2204.213280] Hardware name: 1875DLU
Feb 11 10:45:33 darkslate kernel: [ 2204.213283] Modules linked in:
ipv6 aes_i586 aes_generic af_packet i915 fb drm i2c_algo_bit
cfbcopyarea i2c_core cfbimgblt cfbfillrect binfmt_misc bridge stp
rfcomm llc bnep sco l2cap bluetooth ppdev acpi_cpufreq
cpufreq_powersave cpufreq_conservative cpufreq_ondemand
cpufreq_userspace cpufreq_stats freq_table sbs sbshc pci_slot
container iptable_filter ip_tables x_tables lp joydev pcmcia
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss arc4 ecb ath5k snd_seq_midi thinkpad_acpi
evdev snd_rawmidi rfkill mac80211 snd_seq_midi_event nvram led_class
snd_seq psmouse serio_raw pcspkr snd_timer snd_seq_device cfg80211
yenta_socket rsrc_nonstatic pcmcia_core snd soundcore snd_page_alloc
iTCO_wdt iTCO_vendor_support battery ac video output parport_pc
parport nsc_ircc irda crc_ccitt button intel_agp agpgart shpchp
pci_hotplug ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif sg
pata_acpi ahci ata_generic ata_piix libata scsi_mod ehci_hcd uhci
Feb 11 10:45:33 darkslate kernel: hcd usbcore tg3 libphy thermal
processor fan fuse
Feb 11 10:45:33 darkslate kernel: [ 2204.213452] Pid: 4929, comm:
wpa_supplicant Not tainted 2.6.29-rc4-wl-felix_three #12
Feb 11 10:45:33 darkslate kernel: [ 2204.213457] Call Trace:
Feb 11 10:45:33 darkslate kernel: [ 2204.213470]  [<c03780d5>] ?
printk+0x18/0x1b
Feb 11 10:45:33 darkslate kernel: [ 2204.213480]  [<c01334e3>]
warn_slowpath+0x73/0xd0
Feb 11 10:45:33 darkslate kernel: [ 2204.213489]  [<c01243b9>] ?
check_preempt_wakeup+0xa9/0x1d0
Feb 11 10:45:33 darkslate kernel: [ 2204.213497]  [<c012c656>] ?
try_to_wake_up+0x136/0x390
Feb 11 10:45:33 darkslate kernel: [ 2204.213533]  [<f86667fc>]
minstrel_get_rate+0x9c/0x660 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213556]  [<c012c8b0>] ?
default_wake_function+0x0/0x10
Feb 11 10:45:33 darkslate kernel: [ 2204.213565]  [<c0122720>] ?
__wake_up_common+0x40/0x70
Feb 11 10:45:33 darkslate kernel: [ 2204.213606]  [<f8652c75>]
rate_control_get_rate+0xb5/0xc0 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213649]  [<f865b29e>]
invoke_tx_handlers+0x60e/0xf70 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213658]  [<c02edc88>] ?
skb_release_data+0x68/0xa0
Feb 11 10:45:33 darkslate kernel: [ 2204.213693]  [<f865954d>] ?
__ieee80211_tx_prepare+0x18d/0x310 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213728]  [<f865bf8e>]
ieee80211_master_start_xmit+0x23e/0x560 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213748]  [<c0300ed1>] ?
rtnl_setlink+0xf1/0x130
Feb 11 10:45:33 darkslate kernel: [ 2204.213757]  [<c02f72bb>]
dev_hard_start_xmit+0x25b/0x2f0
Feb 11 10:45:33 darkslate kernel: [ 2204.213772]  [<c030702d>]
__qdisc_run+0x1dd/0x230
Feb 11 10:45:33 darkslate kernel: [ 2204.213779]  [<c0123c80>] ?
__wake_up+0x40/0x50
Feb 11 10:45:33 darkslate kernel: [ 2204.213787]  [<c02f83c7>]
dev_queue_xmit+0x327/0x590
Feb 11 10:45:33 darkslate kernel: [ 2204.213822]  [<f865da02>]
ieee80211_tx_skb+0x52/0x60 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213855]  [<f864da81>]
ieee80211_send_deauth_disassoc+0x101/0x150 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213887]  [<f864dc52>]
ieee80211_set_disassoc+0x182/0x220 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213920]  [<f864de6b>]
ieee80211_sta_req_auth+0x8b/0x90 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213950]  [<f864769d>]
ieee80211_ioctl_siwgenie+0x7d/0x90 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.213960]  [<c0364039>]
ioctl_standard_call+0x199/0x380
Feb 11 10:45:33 darkslate kernel: [ 2204.213969]  [<c02f73cd>] ?
__dev_get_by_name+0x7d/0xa0
Feb 11 10:45:33 darkslate kernel: [ 2204.213977]  [<c02f73cd>] ?
__dev_get_by_name+0x7d/0xa0
Feb 11 10:45:33 darkslate kernel: [ 2204.213985]  [<c0363b4f>]
wext_handle_ioctl+0x14f/0x220
Feb 11 10:45:33 darkslate kernel: [ 2204.214016]  [<f8647620>] ?
ieee80211_ioctl_siwgenie+0x0/0x90 [mac80211]
Feb 11 10:45:33 darkslate kernel: [ 2204.214024]  [<c02f7f44>]
dev_ioctl+0x474/0x550
Feb 11 10:45:33 darkslate kernel: [ 2204.214033]  [<c02e9455>] ?
sys_sendto+0xa5/0xd0
Feb 11 10:45:33 darkslate kernel: [ 2204.214043]  [<c0260705>] ?
copy_from_user+0x35/0x130
Feb 11 10:45:33 darkslate kernel: [ 2204.214050]  [<c02e7840>] ?
sock_ioctl+0x0/0x260
Feb 11 10:45:33 darkslate kernel: [ 2204.214057]  [<c02e792d>]
sock_ioctl+0xed/0x260
Feb 11 10:45:33 darkslate kernel: [ 2204.214064]  [<c02e7840>] ?
sock_ioctl+0x0/0x260
Feb 11 10:45:33 darkslate kernel: [ 2204.214071]  [<c01c53c8>]
vfs_ioctl+0x28/0x80
Feb 11 10:45:33 darkslate kernel: [ 2204.214078]  [<c01c58c2>]
do_vfs_ioctl+0x72/0x5b0
Feb 11 10:45:33 darkslate kernel: [ 2204.214086]  [<c02e94b6>] ?
sys_send+0x36/0x40
Feb 11 10:45:33 darkslate kernel: [ 2204.214093]  [<c02e9acd>] ?
sys_socketcall+0x1cd/0x2a0
Feb 11 10:45:33 darkslate kernel: [ 2204.214100]  [<c01c5e63>]
sys_ioctl+0x63/0x70
Feb 11 10:45:33 darkslate kernel: [ 2204.214108]  [<c010365b>]
sysenter_do_call+0x12/0x2f
Feb 11 10:45:33 darkslate kernel: [ 2204.214113] ---[ end trace
4c5df776bd5adfaa ]---
Feb 11 10:47:33 darkslate kernel: [ 2324.073322] ------------[ cut
here ]------------
