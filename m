Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:50124 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbYC1TPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 15:15:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JfK2Y-0007Gc-Dw
	for linux-wireless@vger.kernel.org; Fri, 28 Mar 2008 19:15:02 +0000
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 19:15:02 +0000
Received: from tobutaz+kernel by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 19:15:02 +0000
To: linux-wireless@vger.kernel.org
From: TK <tobutaz+kernel@gmail.com>
Subject: 2.6.24 panic in rt2x00lib_txdone / ieee80211_tx_status_irqsafe
Date: Fri, 28 Mar 2008 19:09:56 +0000 (UTC)
Message-ID: <fsjfq1$vl8$1@ger.gmane.org> (sfid-20080328_191526_646591_B5775166)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get this panic with rt2x00 2.0.10 (2.6.24-12-server kernel
shipped by ubuntu). It can crash quite regularly given the
right amount of wireless activity and system load.

The instruction that crashes seems to be the assignment to
skb->dev when skb is null (in ieee80211_tx_status_irqsafe);
skb can be set to null in the caller, rt2x00lib_txdone.

I'm not really sure what is the right fix, but I can try a patch.

Logs:

[  655.701275] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
[  655.701369] printing eip: d0b96c72 *pdpt = 000000000ed22001 *pde = 0000000000000000 
[  655.701444] Oops: 0002 [#1] SMP 
[  655.701485] Modules linked in: aes_i586 geode_aes aes_generic nls_iso8859_1 nls_cp437 vfat fat loop netconsole configfs ip6table_filter iptable_raw ipt_ULOG ipt_TTL ipt_ttl ipt_TOS ipt_tos ipt_SAME ipt_REJECT ipt_REDIRECT ipt_recent ipt_owner ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_iprange ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev xt_NFQUEUE xt_NFLOG xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_helper xt_hashlimit ip6_tables xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp af_packet ipv6 evdev snd_via82xx snd_cmipci snd_ac97_codec gameport ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_opl3_lib snd_hwdep snd_page_alloc snd_mpu401_uart arc4 ecb blkcipher snd_seq_dummy psmouse serio_raw rt2x00lib snd_rawmidi snd_seq_midi_event snd_timer snd_seq_device shpchp snd via_agp agpgart pci_hotplug via686a parport_pc parport soundcore reiserfs sg r8169 raid10 raid456 md_mod tileblit bitblit softcursor fuse
[  655.703375] 
[  655.703400] Pid: 0, comm: swapper Not tainted (2.6.24-12-server #1)
[  655.703436] EIP: 0060:[<d0b96c72>] EFLAGS: 00010086 CPU: 0
[  655.703545] EIP is at ieee80211_tx_status_irqsafe+0x12/0x120 [mac80211]
[  655.703581] EAX: ce945000 EBX: cf543a58 ECX: cf543a58 EDX: 00000000
[  655.703616] ESI: cd485e80 EDI: 00000000 EBP: cd485180 ESP: c0439e00
[  655.703651]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  655.703684] Process swapper (pid: 0, ti=c0438000 task=c04043a0 task.ti=c0438000)
[  655.703719] Stack: c1207240 c12071b8 00000000 ce088280 cf543a4c cd485e80 00000000 00000801 
[  655.703812]        d0b843f4 ce8cb438 cf543aa0 006c000a d0b8e41f 00000000 00000000 cd485e80 
[  655.703902]        00000000 ced10200 ccccc4a0 00000000 00000000 0000000a c016da50 c042d380 
[  655.703994] Call Trace:
[  655.704082]  [<d0b843f4>] rt2x00lib_txdone+0x84/0xb0 [rt2x00lib]
[  655.704164]  [<d0b8e41f>] rt61pci_interrupt+0x13f/0x220 [rt61pci]
[  655.704349]  [<c016da50>] handle_IRQ_event+0x30/0x60
[  655.704414]  [<c016f3ec>] handle_level_irq+0x7c/0xf0
[  655.704473]  [<c010a93b>] do_IRQ+0x3b/0x70
[  655.704545]  [<c0108dff>] common_interrupt+0x23/0x28
[  655.704648]  [<c033041d>] _spin_unlock_irqrestore+0xd/0x20
[  655.704706]  [<d0958f18>] ata_interrupt+0xe8/0x200 [libata]
[  655.704902]  [<c016da50>] handle_IRQ_event+0x30/0x60
[  655.704959]  [<c016f3ec>] handle_level_irq+0x7c/0xf0
[  655.705016]  [<c010a93b>] do_IRQ+0x3b/0x70
[  655.705086]  [<c0108dff>] common_interrupt+0x23/0x28
[  655.705184]  [<d08595b0>] acpi_idle_enter_simple+0x159/0x1c5 [processor]
[  655.705291]  [<c02a4afc>] cpuidle_idle_call+0x7c/0xb0
[  655.705351]  [<c01066c3>] cpu_idle+0x73/0xd0
[  655.705404]  [<c043ea8f>] start_kernel+0x31f/0x3b0
[  655.705451]  [<c043e150>] unknown_bootoption+0x0/0x1f0
[  655.705539]  =======================
[  655.705566] Code: fe 0f 0b eb fe 8d 74 26 00 0f 0b eb fe 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 c5 57 56 53 89 cb 83 ec 10 89 54 24 08 8b 40 58 <89> 42 

objdump disassembly:
00000c60 <ieee80211_tx_status_irqsafe>:
     c60:       55                      push   %ebp
     c61:       89 c5                   mov    %eax,%ebp
     c63:       57                      push   %edi
     c64:       56                      push   %esi
     c65:       53                      push   %ebx
     c66:       89 cb                   mov    %ecx,%ebx
     c68:       83 ec 10                sub    $0x10,%esp
call convention boilerplate
     c6b:       89 54 24 08             mov    %edx,0x8(%esp)
struct ieee80211_local *local = hw_to_local(hw);
     c6f:       8b 40 58                mov    0x58(%eax),%eax
x = local->mdev;
     c72:       89 42 14                mov    %eax,0x14(%edx)
skb->dev = x;

Source:
void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
                                 struct sk_buff *skb,
                                 struct ieee80211_tx_status *status)
{
        struct ieee80211_local *local = hw_to_local(hw);
        struct ieee80211_tx_status *saved;
        int tmp;

        skb->dev = local->mdev;
        saved = kmalloc(sizeof(struct ieee80211_tx_status), GFP_ATOMIC);


