Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:14473 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZFUOIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 10:08:46 -0400
Received: by fg-out-1718.google.com with SMTP id d23so378522fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2009 07:08:47 -0700 (PDT)
Date: Sun, 21 Jun 2009 15:49:54 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-wireless@vger.kernel.org, me@bobcopeland.com,
	linville@tuxdriver.com
Subject: kernel crashes, 2.6.30, rt2x00, ath5k, ieee80211_get_*_rate,
	automatic rate control
Message-ID: <20090621134954.GA31505@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am experiencing kernel crashes with a combination of ath5k and rt73usb 
wireless cards run as an adhoc network. While not entirely new in 2.6.30 these 
were rare enough in 2.6.29.* or earlier kernels that I was unable to look at 
it in detail earlier.

Submitting everything in one email because for me it is hard to tell appart
what the actual culprit is - appears like all the issues are very closely
related.

Crashes occur on 2 computers, with ath5k-pci and rt73usb cards respectively.
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
02:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
Bus 005 Device 002: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter

The good news - setting a fixed rate appears to prevent all crashes. This is perhaps
the reason why wireless developers never see this crashes?
Unfortunately the unsuspecting user not setting the bitrate manually will experience 
many mysterious freezes and crashes.

Depending on distance 11-24M fixed bitrates worked very well for me. Otoh a quick 
look at data transfer rates (4m direct view distance), with "auto" rate setting 
confirms that something is seriously hosed with automatic rate setting:

  transfer from rt73usb->ath5k go with approximately 50-100Kb/s
  transfer from ath5k->rt73usb go with approximately 500-800Kb/s.

Ping times did preiodically climb from severeal ms to apporximately 23seconds (!!)
at which point something occured (hw reset ?) and the whole repeated.

Debugging is a bit difficult, only one of the affected computers has a serial 
connection and so far all crashes appeard when I was not running with serial 
console connected. So I was able to partialy decode only 2 exemplary crashes, 
1 for each driver although I am convinced that several more variants occured.

Here is a partially decoded crash with the ath5k driver, I have only a photo 
of kernel panic screen so I am not sure if it is reliable. 
I have pinpointed the suspected crash point according to the "Code" line
appearing bellow the kernel panic.
I can transcribe part of the backtrace or email the picture for more info,
register values not available though.

EIP: f825cad1 SS:SSP 68:c0681d

4a 08 8b... ath5k/base.c : 0x2c24

static inline struct ieee80211_rate *
ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
                      const struct ieee80211_tx_info *c)
{
        if (WARN_ON(c->control.rates[0].idx < 0))
    2c0e:       8b 54 24 44             mov    0x44(%esp),%edx
    2c12:       8b 9b 70 0f 00 00       mov    0xf70(%ebx),%ebx
    2c18:       89 5c 24 58             mov    %ebx,0x58(%esp)
    2c1c:       0f b6 40 09             movzbl 0x9(%eax),%eax
    2c20:       88 44 24 57             mov    %al,0x57(%esp)
    2c24:       0f b6 4a 08             movzbl 0x8(%edx),%ecx   ************************
    2c28:       8b 85 18 01 00 00       mov    0x118(%ebp),%eax
    2c2e:       84 c9                   test   %cl,%cl
    2c30:       0f 88 2a 02 00 00       js     2e60 <ath5k_tx+0x3e0>
                return NULL;
        return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[0].idx];


Partially decoded crash on the rt2x00 side, again have a photo of that. Crash in
rt2x00_get_rate, ebx was zero.


/home/rz/rpmbuild/kernels/linux-2.6.30/drivers/net/wireless/rt2x00/rt2x00queue.c
:323
            !test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags)) {
                __set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags);
                txdesc->ifs = IFS_BACKOFF;
        } else
                txdesc->ifs = IFS_SIFS;
    1e18:       66 c7 46 16 01 00       movw   $0x1,0x16(%esi)
rt2x00_get_rate():
/home/rz/rpmbuild/kernels/linux-2.6.30/drivers/net/wireless/rt2x00/rt2x00lib.h:5
7
    1e1e:       0f b6 5b 06             movzbl 0x6(%ebx),%ebx   *********************
rt2x00queue_create_tx_descriptor():
/home/rz/rpmbuild/kernels/linux-2.6.30/drivers/net/wireless/rt2x00/rt2x00queue.c
:330
        /*
         * Determine rate modulation.
         */

        hwrate = rt2x00_get_rate(rate->hw_value);
        txdesc->rate_mode = RATE_MODE_CCK;
    1e22:       66 c7 46 10 00 00       movw   $0x0,0x10(%esi)
rt2x00_get_rate():
/home/rz/rpmbuild/kernels/linux-2.6.30/drivers/net/wireless/rt2x00/rt2x00lib.h:5
7
    1e28:       89 5d d4                mov    %ebx,-0x2c(%ebp)


Both ieee80211_get_tx_rate() and ieee80211_get_rts_cts_rate() can return NULL instead of
a valid pointer and that is what appears to happen here.


On the ath5k side I also got a bunch  of these WARNINGs:

Jun 11 19:44:48 richard kernel: [ 3759.874096] ------------[ cut here ]------------
Jun 11 19:44:48 richard kernel: [ 3759.874113] WARNING: at /home/rz/rpmbuild/kernels/linux-2.6.29.4/net/mac80211/tx.c:567 invoke_tx_handlers+0xcf5/0xd70 [mac80211]()
Jun 11 19:44:48 richard kernel: [ 3759.874127] Hardware name: NB81005
Jun 11 19:44:48 richard kernel: [ 3759.874134] Modules linked in: i915 i2c_algo_bit rfcomm l2cap bluetooth ppdev parport_pc lp parport autofs4 acpi_cpufreq cpufreq_userspace cpufreq_conservative cpufreq_powersave cpufreq_stats pci_slot drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss arc4 snd_pcm ecb uvcvideo videodev v4l1_compat snd_seq_dummy rtc_cmos rtc_core rtc_lib ath5k r8169 mac80211 led_class cfg80211 serio_raw snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse snd iTCO_wdt iTCO_vendor_support intel_agp shpchp pci_hotplug agpgart soundcore snd_page_alloc xt_multiport nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables fuse ahci squashfs ehci_hcd isofs zlib_inflate
Jun 11 19:44:48 richard kernel: [ 3759.874402] Pid: 0, comm: swapper Not tainted 2.6.29.4nb-fc2 #2
Jun 11 19:44:48 richard kernel: [ 3759.874411] Call Trace:
Jun 11 19:44:48 richard kernel: [ 3759.874433]  [<c012cc67>] warn_slowpath+0x87/0xe0
Jun 11 19:44:48 richard kernel: [ 3759.874451]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 19:44:48 richard kernel: [ 3759.874518]  [<f823f386>] rate_control_get_rate+0xb6/0xc0 [mac80211]
Jun 11 19:44:48 richard kernel: [ 3759.874586]  [<f8246665>] invoke_tx_handlers+0xcf5/0xd70 [mac80211]
Jun 11 19:44:48 richard kernel: [ 3759.874621]  [<c0152ace>] trace_hardirqs_on_caller+0x5e/0x1b0
Jun 11 19:44:48 richard kernel: [ 3759.874675]  [<f824540a>] __ieee80211_tx_prepare+0x16a/0x2e0 [mac80211]
Jun 11 19:44:48 richard kernel: [ 3759.874732]  [<f8247cf0>] ieee80211_master_start_xmit+0x210/0x5a0 [mac80211]
Jun 11 19:44:48 richard kernel: [ 3759.874789]  [<f8247c92>] ieee80211_master_start_xmit+0x1b2/0x5a0 [mac80211]
Jun 11 19:44:48 richard kernel: [ 3759.874807]  [<c01328f3>] local_bh_enable_ip+0x93/0x110
Jun 11 19:44:48 richard kernel: [ 3759.874824]  [<c03f3bc3>] dev_hard_start_xmit+0x2a3/0x330
Jun 11 19:44:48 richard kernel: [ 3759.874838]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 19:44:48 richard kernel: [ 3759.874853]  [<c0404a07>] __qdisc_run+0x1c7/0x230
Jun 11 19:44:48 richard kernel: [ 3759.874867]  [<c0404a1d>] __qdisc_run+0x1dd/0x230
Jun 11 19:44:48 richard kernel: [ 3759.874880]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 19:44:48 richard kernel: [ 3759.874894]  [<c03f3e27>] dev_queue_xmit+0xc7/0x600
Jun 11 19:44:48 richard kernel: [ 3759.874908]  [<c03f40d7>] dev_queue_xmit+0x377/0x600
Jun 11 19:44:48 richard kernel: [ 3759.874921]  [<c03f3d97>] dev_queue_xmit+0x37/0x600
Jun 11 19:44:48 richard kernel: [ 3759.874978]  [<f8247686>] ieee80211_subif_start_xmit+0x466/0x8c0 [mac80211]
Jun 11 19:44:48 richard kernel: [ 3759.875060]  [<f8247726>] ieee80211_subif_start_xmit+0x506/0x8c0 [mac80211]
Jun 11 19:44:48 richard kernel: [ 3759.875078]  [<c0132a05>] local_bh_enable+0x95/0x110
Jun 11 19:44:48 richard kernel: [ 3759.875093]  [<c03f3bc3>] dev_hard_start_xmit+0x2a3/0x330
Jun 11 19:44:48 richard kernel: [ 3759.875106]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 19:44:48 richard kernel: [ 3759.875121]  [<c0404a07>] __qdisc_run+0x1c7/0x230
Jun 11 19:44:48 richard kernel: [ 3759.875135]  [<c0404a1d>] __qdisc_run+0x1dd/0x230
Jun 11 19:44:48 richard kernel: [ 3759.875148]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 19:44:48 richard kernel: [ 3759.875161]  [<c03f3e27>] dev_queue_xmit+0xc7/0x600
Jun 11 19:44:48 richard kernel: [ 3759.875175]  [<c03f40d7>] dev_queue_xmit+0x377/0x600
Jun 11 19:44:48 richard kernel: [ 3759.875188]  [<c03f3d97>] dev_queue_xmit+0x37/0x600
Jun 11 19:44:48 richard kernel: [ 3759.875204]  [<c041b6bd>] ip_finish_output+0x1fd/0x2b0
Jun 11 19:44:48 richard kernel: [ 3759.875219]  [<c041a755>] ip_local_out+0x15/0x20
Jun 11 19:44:48 richard kernel: [ 3759.875233]  [<c041af20>] ip_queue_xmit+0x1a0/0x380
Jun 11 19:44:48 richard kernel: [ 3759.875251]  [<c01a6d49>] add_partial+0x19/0x60
Jun 11 19:44:48 richard kernel: [ 3759.875264]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 19:44:48 richard kernel: [ 3759.875278]  [<c0432754>] tcp_v4_send_check+0x44/0xf0
Jun 11 19:44:48 richard kernel: [ 3759.875293]  [<c042e404>] tcp_transmit_skb+0x494/0x6e0
Jun 11 19:44:48 richard kernel: [ 3759.875307]  [<c0152ace>] trace_hardirqs_on_caller+0x5e/0x1b0
Jun 11 19:44:48 richard kernel: [ 3759.875323]  [<c04306ca>] tcp_write_xmit+0x21a/0xa20
Jun 11 19:44:48 richard kernel: [ 3759.875337]  [<c0152981>] mark_held_locks+0x41/0x80
Jun 11 19:44:48 richard kernel: [ 3759.875351]  [<c0152981>] mark_held_locks+0x41/0x80
Jun 11 19:44:48 richard kernel: [ 3759.875365]  [<c042d60a>] tcp_established_options+0x2a/0xa0
Jun 11 19:44:48 richard kernel: [ 3759.875381]  [<c0430f4d>] __tcp_push_pending_frames+0x3d/0x110
Jun 11 19:44:48 richard kernel: [ 3759.875396]  [<c042c12b>] tcp_rcv_established+0x3fb/0xa20
Jun 11 19:44:48 richard kernel: [ 3759.875411]  [<c0434415>] tcp_v4_do_rcv+0x225/0x380
Jun 11 19:44:48 richard kernel: [ 3759.875426]  [<c0152ace>] trace_hardirqs_on_caller+0x5e/0x1b0
Jun 11 19:44:48 richard kernel: [ 3759.875441]  [<c0434b26>] tcp_v4_rcv+0x5b6/0x760
Jun 11 19:44:48 richard kernel: [ 3759.875457]  [<c04b323f>] _spin_lock_nested+0x2f/0x40
Jun 11 19:44:48 richard kernel: [ 3759.875471]  [<c0434b40>] tcp_v4_rcv+0x5d0/0x760
Jun 11 19:44:48 richard kernel: [ 3759.875486]  [<c041675f>] ip_local_deliver_finish+0xcf/0x230
Jun 11 19:44:48 richard kernel: [ 3759.875501]  [<c04166c0>] ip_local_deliver_finish+0x30/0x230
Jun 11 19:44:48 richard kernel: [ 3759.875516]  [<c041619e>] ip_rcv_finish+0xfe/0x370
Jun 11 19:44:48 richard kernel: [ 3759.875530]  [<c04160a0>] ip_rcv_finish+0x0/0x370
Jun 11 19:44:48 richard kernel: [ 3759.875544]  [<c03f2c69>] netif_receive_skb+0x2b9/0x560
Jun 11 19:44:48 richard kernel: [ 3759.875558]  [<c03f2aa8>] netif_receive_skb+0xf8/0x560
Jun 11 19:44:48 richard kernel: [ 3759.875572]  [<c03f2f88>] process_backlog+0x78/0xd0
Jun 11 19:44:48 richard kernel: [ 3759.875586]  [<c03f12f3>] net_rx_action+0x163/0x230
Jun 11 19:44:48 richard kernel: [ 3759.875599]  [<c03f1276>] net_rx_action+0xe6/0x230
Jun 11 19:44:48 richard kernel: [ 3759.875613]  [<c0132547>] __do_softirq+0xa7/0x160
Jun 11 19:44:48 richard kernel: [ 3759.875628]  [<c0172f1a>] handle_fasteoi_irq+0x7a/0xe0
Jun 11 19:44:48 richard kernel: [ 3759.875643]  [<c01162b3>] ack_apic_level+0x73/0x270
Jun 11 19:44:48 richard kernel: [ 3759.875657]  [<c0132685>] do_softirq+0x85/0x90
Jun 11 19:44:48 richard kernel: [ 3759.875670]  [<c013283d>] irq_exit+0x6d/0x90
Jun 11 19:44:48 richard kernel: [ 3759.875685]  [<c0105b8d>] do_IRQ+0x5d/0xc0
Jun 11 19:44:48 richard kernel: [ 3759.875699]  [<c010452c>] common_interrupt+0x2c/0x40
Jun 11 19:44:48 richard kernel: [ 3759.875713]  [<c015007b>] lockdep_reset_lock+0x1cb/0x2b0
Jun 11 19:44:48 richard kernel: [ 3759.875729]  [<c02fd72b>] acpi_idle_enter_bm+0x287/0x310
Jun 11 19:44:48 richard kernel: [ 3759.875746]  [<c03c488f>] cpuidle_idle_call+0x6f/0xc0
Jun 11 19:44:48 richard kernel: [ 3759.875760]  [<c0102d0b>] cpu_idle+0x6b/0xa0
Jun 11 19:44:48 richard kernel: [ 3759.875770] ---[ end trace 5d9979cba48023b9 ]---


Jun 11 20:25:16 richard kernel: [  147.867299] ------------[ cut here ]------------
Jun 11 20:25:16 richard kernel: [  147.867316] WARNING: at /home/rz/rpmbuild/kernels/linux-2.6.29.4/net/mac80211/tx.c:567 invoke_tx_handlers+0xcf5/0xd70 [mac80211]()
Jun 11 20:25:16 richard kernel: [  147.867330] Hardware name: NB81005
Jun 11 20:25:16 richard kernel: [  147.867337] Modules linked in: i915 i2c_algo_bit rfcomm l2cap bluetooth ppdev parport_pc lp parport autofs4 acpi_cpufreq cpufreq_userspace cpufreq_conservative cpufreq_powersave cpufreq_stats pci_slot drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss arc4 snd_pcm uvcvideo videodev ecb v4l1_compat snd_seq_dummy rtc_cmos rtc_core rtc_lib ath5k mac80211 led_class serio_raw cfg80211 r8169 snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event psmouse snd_seq snd_timer snd_seq_device intel_agp iTCO_wdt iTCO_vendor_support shpchp agpgart snd pci_hotplug soundcore snd_page_alloc xt_multiport nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables fuse ahci squashfs ehci_hcd isofs zlib_inflate
Jun 11 20:25:16 richard kernel: [  147.867604] Pid: 0, comm: swapper Not tainted 2.6.29.4nb-fc2 #2
Jun 11 20:25:16 richard kernel: [  147.867613] Call Trace:
Jun 11 20:25:16 richard kernel: [  147.867635]  [<c012cc67>] warn_slowpath+0x87/0xe0
Jun 11 20:25:16 richard kernel: [  147.867704]  [<f8226386>] rate_control_get_rate+0xb6/0xc0 [mac80211]
Jun 11 20:25:16 richard kernel: [  147.867772]  [<f822d665>] invoke_tx_handlers+0xcf5/0xd70 [mac80211]
Jun 11 20:25:16 richard kernel: [  147.867808]  [<c0152ace>] trace_hardirqs_on_caller+0x5e/0x1b0
Jun 11 20:25:16 richard kernel: [  147.867861]  [<f822c40a>] __ieee80211_tx_prepare+0x16a/0x2e0 [mac80211]
Jun 11 20:25:16 richard kernel: [  147.867919]  [<f822ecf0>] ieee80211_master_start_xmit+0x210/0x5a0 [mac80211]
Jun 11 20:25:16 richard kernel: [  147.867976]  [<f822ec92>] ieee80211_master_start_xmit+0x1b2/0x5a0 [mac80211]
Jun 11 20:25:16 richard kernel: [  147.867995]  [<c03f3bc3>] dev_hard_start_xmit+0x2a3/0x330
Jun 11 20:25:16 richard kernel: [  147.868011]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 20:25:16 richard kernel: [  147.868026]  [<c0404a07>] __qdisc_run+0x1c7/0x230
Jun 11 20:25:16 richard kernel: [  147.868040]  [<c0404a1d>] __qdisc_run+0x1dd/0x230
Jun 11 20:25:16 richard kernel: [  147.868053]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 20:25:16 richard kernel: [  147.868067]  [<c03f3e27>] dev_queue_xmit+0xc7/0x600
Jun 11 20:25:16 richard kernel: [  147.868081]  [<c03f40d7>] dev_queue_xmit+0x377/0x600
Jun 11 20:25:16 richard kernel: [  147.868095]  [<c03f3d97>] dev_queue_xmit+0x37/0x600
Jun 11 20:25:16 richard kernel: [  147.868151]  [<f822e686>] ieee80211_subif_start_xmit+0x466/0x8c0 [mac80211]
Jun 11 20:25:16 richard kernel: [  147.868207]  [<f822e726>] ieee80211_subif_start_xmit+0x506/0x8c0 [mac80211]
Jun 11 20:25:16 richard kernel: [  147.868263]  [<f827315a>] nf_conntrack_in+0x45a/0x8f0 [nf_conntrack]
Jun 11 20:25:16 richard kernel: [  147.868281]  [<c0132a05>] local_bh_enable+0x95/0x110
Jun 11 20:25:16 richard kernel: [  147.868295]  [<c03f3bc3>] dev_hard_start_xmit+0x2a3/0x330
Jun 11 20:25:16 richard kernel: [  147.868309]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 20:25:16 richard kernel: [  147.868323]  [<c0404a07>] __qdisc_run+0x1c7/0x230
Jun 11 20:25:16 richard kernel: [  147.868337]  [<c0404a1d>] __qdisc_run+0x1dd/0x230
Jun 11 20:25:16 richard kernel: [  147.868350]  [<c02b5f25>] _raw_spin_lock+0x45/0x120
Jun 11 20:25:16 richard kernel: [  147.868364]  [<c03f3e27>] dev_queue_xmit+0xc7/0x600
Jun 11 20:25:16 richard kernel: [  147.868378]  [<c03f40d7>] dev_queue_xmit+0x377/0x600
Jun 11 20:25:16 richard kernel: [  147.868391]  [<c03f3d97>] dev_queue_xmit+0x37/0x600
Jun 11 20:25:16 richard kernel: [  147.868407]  [<c041b6bd>] ip_finish_output+0x1fd/0x2b0
Jun 11 20:25:16 richard kernel: [  147.868422]  [<c041a755>] ip_local_out+0x15/0x20
Jun 11 20:25:16 richard kernel: [  147.868437]  [<c041a9e2>] ip_push_pending_frames+0x282/0x3a0
Jun 11 20:25:16 richard kernel: [  147.868452]  [<c043e307>] icmp_reply+0x137/0x1e0
Jun 11 20:25:16 richard kernel: [  147.868466]  [<c043e4e9>] icmp_echo+0x49/0x50
Jun 11 20:25:16 richard kernel: [  147.868497]  [<c043eac4>] icmp_rcv+0x254/0x2a0
Jun 11 20:25:16 richard kernel: [  147.868512]  [<c041675f>] ip_local_deliver_finish+0xcf/0x230
Jun 11 20:25:16 richard kernel: [  147.868527]  [<c04166c0>] ip_local_deliver_finish+0x30/0x230
Jun 11 20:25:16 richard kernel: [  147.868542]  [<c041619e>] ip_rcv_finish+0xfe/0x370
Jun 11 20:25:16 richard kernel: [  147.868556]  [<c04160a0>] ip_rcv_finish+0x0/0x370
Jun 11 20:25:16 richard kernel: [  147.868570]  [<c03f2c69>] netif_receive_skb+0x2b9/0x560
Jun 11 20:25:16 richard kernel: [  147.868584]  [<c03f2aa8>] netif_receive_skb+0xf8/0x560
Jun 11 20:25:16 richard kernel: [  147.868599]  [<c03f2f88>] process_backlog+0x78/0xd0
Jun 11 20:25:16 richard kernel: [  147.868613]  [<c03f12f3>] net_rx_action+0x163/0x230
Jun 11 20:25:16 richard kernel: [  147.868626]  [<c03f1276>] net_rx_action+0xe6/0x230
Jun 11 20:25:16 richard kernel: [  147.868640]  [<c0132547>] __do_softirq+0xa7/0x160
Jun 11 20:25:16 richard kernel: [  147.868655]  [<c0172f1a>] handle_fasteoi_irq+0x7a/0xe0
Jun 11 20:25:16 richard kernel: [  147.868671]  [<c01162b3>] ack_apic_level+0x73/0x270
Jun 11 20:25:16 richard kernel: [  147.868684]  [<c0132685>] do_softirq+0x85/0x90
Jun 11 20:25:16 richard kernel: [  147.868697]  [<c013283d>] irq_exit+0x6d/0x90
Jun 11 20:25:16 richard kernel: [  147.868712]  [<c0105b8d>] do_IRQ+0x5d/0xc0
Jun 11 20:25:16 richard kernel: [  147.868726]  [<c010452c>] common_interrupt+0x2c/0x40
Jun 11 20:25:16 richard kernel: [  147.868741]  [<c015007b>] lockdep_reset_lock+0x1cb/0x2b0
Jun 11 20:25:16 richard kernel: [  147.868756]  [<c02fd72b>] acpi_idle_enter_bm+0x287/0x310
Jun 11 20:25:16 richard kernel: [  147.868773]  [<c03c488f>] cpuidle_idle_call+0x6f/0xc0
Jun 11 20:25:16 richard kernel: [  147.868787]  [<c0102d0b>] cpu_idle+0x6b/0xa0
Jun 11 20:25:16 richard kernel: [  147.868797] ---[ end trace 04f25978ef36fa0b ]---


Regards
Richard
