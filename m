Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:53263 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab3ANP2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 10:28:55 -0500
Received: by mail-ie0-f176.google.com with SMTP id 13so5100084iea.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2013 07:28:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358157015-22982-1-git-send-email-nbd@openwrt.org>
References: <1358157015-22982-1-git-send-email-nbd@openwrt.org>
From: Robert Shade <robert.shade@gmail.com>
Date: Mon, 14 Jan 2013 10:28:34 -0500
Message-ID: <CAMgrJ3Z3nwrNGsqM3pYZ5bqpjhADJZo33wJmEoFfEpTj+Z5f4A@mail.gmail.com> (sfid-20130114_162859_760309_A5ECA144)
Subject: Re: [PATCH 3.8] ath9k: remove sc->rx.rxbuflock to fix a deadlock
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, c_manoha@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your work on this, Felix.  I'm still getting one of two soft lockups:

First:
BUG: soft lockup - CPU#0 stuck for 67s! [wpa_supplicant:1975]
BUG: soft lockup - CPU#1 stuck for 67s! [phy1:910]

BUG: scheduling while atomic: phy1/910/0x10010200
Modules linked in: deflate zlib_deflate ctr camellia cast5 rmd160
crypto_null ccm serpent blowfish twofish_x86_64 twofish_common ecb
xcbc cbc sha256_generic sha512_generic des_generic cryptd aes_x86_64
aes_generic ah6 ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4
xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport
xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6
xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 sunrpc 8021q garp tun
cpufreq_ondemand acpi_cpufreq freq_table mperf bridge stp llc
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter
ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables ipv6 xr17v35x(U) sierra(U)
usbserial arc4 ath9k(U) mac80211(U) ath9k_common(U) ath9k_hw(U) ath(U)
cfg80211(U) rfkill microcode i2c_i801 sg serio_raw qmi_wwan(U)
usbnet(U) mii cdc_wdm(U) compat(U) iTCO_wdt iTCO_vendor_support e1000e
shpchp ext4 mbcache jbd2 sd_mod crc_t10dif ahci i915 drm_kms_helper
drm i2c_algo_bit i2c_core video output dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: scsi_wait_scan]
CPU 1
Modules linked in: deflate zlib_deflate ctr camellia cast5 rmd160
crypto_null ccm serpent blowfish twofish_x86_64 twofish_common ecb
xcbc cbc sha256_generic sha512_generic des_generic cryptd aes_x86_64
aes_generic ah6 ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4
xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport
xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6
xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 sunrpc 8021q garp tun
cpufreq_ondemand acpi_cpufreq freq_table mperf bridge stp llc
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter
ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables ipv6 xr17v35x(U) sierra(U)
usbserial arc4 ath9k(U) mac80211(U) ath9k_common(U) ath9k_hw(U) ath(U)
cfg80211(U) rfkill microcode i2c_i801 sg serio_raw qmi_wwan(U)
usbnet(U) mii cdc_wdm(U) compat(U) iTCO_wdt iTCO_vendor_support e1000e
shpchp ext4 mbcache jbd2 sd_mod crc_t10dif ahci i915 drm_kms_helper
drm i2c_algo_bit i2c_core video output dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: scsi_wait_scan]

Pid: 910, comm: phy1 Not tainted 2.6.32-279.5.2.el6.x86_64 #1 OEM OEM/Cantiga
RIP: 0010:[<ffffffffa03b65a0>]  [<ffffffffa03b65a0>]
ath_prepare_reset+0x60/0xb0 [ath9k]
RSP: 0018:ffff88013b2d5c80  EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffff88013b2d5ca0 RCX: 0000000000004aef
RDX: ffff880139292e6c RSI: 0000000000000246 RDI: 0000000000000246
RBP: ffffffff8100ba4e R08: dead000000200200 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88013b2d5c30
R13: 0000000000000246 R14: ffff88013b2d5c20 R15: 0000000000000246
FS:  0000000000000000(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000481046 CR3: 0000000135780000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process phy1 (pid: 910, threadinfo ffff88013b2d4000, task ffff8801381dc040)
Stack:
 ffff88013b2d5ca0 ffff8801392925a0 ffff8801392e0230 ffff8801392e0018
<d> ffff88013b2d5d00 ffffffffa03b6846 0000000000000000 ffff8801392e0058
<d> 00ff88013b2d5d00 ffff880139293f58 ffff88013b2d5d00 ffff8801392925a0
Call Trace:
 [<ffffffffa03b6846>] ? ath_reset_internal+0x86/0x180 [ath9k]
 [<ffffffffa03b8521>] ? ath9k_config+0x1f1/0x5c0 [ath9k]
 [<ffffffffa033f68a>] ? ieee80211_hw_config+0xea/0x190 [mac80211]
 [<ffffffffa03468eb>] ? ieee80211_scan_work+0x1ab/0x540 [mac80211]
 [<ffffffffa0346740>] ? ieee80211_scan_work+0x0/0x540 [mac80211]
 [<ffffffff8108c760>] ? worker_thread+0x170/0x2a0
 [<ffffffff810920d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8108c5f0>] ? worker_thread+0x0/0x2a0
 [<ffffffff81091d66>] ? kthread+0x96/0xa0
 [<ffffffff8100c14a>] ? child_rip+0xa/0x20
 [<ffffffff81091cd0>] ? kthread+0x0/0xa0
 [<ffffffff8100c140>] ? child_rip+0x0/0x20
Code: 87 a4 00 00 48 8d bb 28 3f 00 00 e8 9b 85 cc e0 48 89 df e8 53
18 01 00 4c 89 e7 e8 9b 5d f2 ff f0 ff 83 78 08 00 00 0f 1f 40 00 <f6>
83 70 08 00 00 02 75 f7 0f ae f0 48 89 df e8 8c 55 00 00 41
Call Trace:
 [<ffffffffa03b6846>] ? ath_reset_internal+0x86/0x180 [ath9k]
 [<ffffffffa03b8521>] ? ath9k_config+0x1f1/0x5c0 [ath9k]
 [<ffffffffa033f68a>] ? ieee80211_hw_config+0xea/0x190 [mac80211]
 [<ffffffffa03468eb>] ? ieee80211_scan_work+0x1ab/0x540 [mac80211]
 [<ffffffffa0346740>] ? ieee80211_scan_work+0x0/0x540 [mac80211]
 [<ffffffff8108c760>] ? worker_thread+0x170/0x2a0
 [<ffffffff810920d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8108c5f0>] ? worker_thread+0x0/0x2a0
 [<ffffffff81091d66>] ? kthread+0x96/0xa0
 [<ffffffff8100c14a>] ? child_rip+0xa/0x20
 [<ffffffff81091cd0>] ? kthread+0x0/0xa0
 [<ffffffff8100c140>] ? child_rip+0x0/0x20

Second:
BUG: soft lockup - CPU#1 stuck for 67s! [phy1:887]
BUG: scheduling while atomic: wpa_supplicant/1959/0x10010100
Modules linked in: deflate zlib_deflate ctr camellia cast5 rmd160
crypto_null ccm serpent blowfish twofish_x86_64 twofish_common ecb
xcbc cbc sha256_generic sha512_generic des_generic cryptd aes_x86_64
aes_generic ah6 ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4
xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport
xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6
xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 sunrpc 8021q garp tun
cpufreq_ondemand acpi_cpufreq freq_table mperf bridge stp llc
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter
ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables ipv6 xr17v35x(U) sierra(U)
usbserial arc4 ath9k(U) mac80211(U) ath9k_common(U) ath9k_hw(U) ath(U)
cfg80211(U) rfkill qmi_wwan(U) usbnet(U) mii cdc_wdm(U) compat(U)
microcode serio_raw i2c_i801 sg iTCO_wdt iTCO_vendor_support shpchp
e1000e ext4 mbcache jbd2 sd_mod crc_t10dif ahci i915 drm_kms_helper
drm i2c_algo_bit i2c_core video output dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: scsi_wait_scan]
CPU 0
Modules linked in: deflate zlib_deflate ctr camellia cast5 rmd160
crypto_null ccm serpent blowfish twofish_x86_64 twofish_common ecb
xcbc cbc sha256_generic sha512_generic des_generic cryptd aes_x86_64
aes_generic ah6 ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4
xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport
xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6
xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 sunrpc 8021q garp tun
cpufreq_ondemand acpi_cpufreq freq_table mperf bridge stp llc
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter
ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables ipv6 xr17v35x(U) sierra(U)
usbserial arc4 ath9k(U) mac80211(U) ath9k_common(U) ath9k_hw(U) ath(U)
cfg80211(U) rfkill qmi_wwan(U) usbnet(U) mii cdc_wdm(U) compat(U)
microcode serio_raw i2c_i801 sg iTCO_wdt iTCO_vendor_support shpchp
e1000e ext4 mbcache jbd2 sd_mod crc_t10dif ahci i915 drm_kms_helper
drm i2c_algo_bit i2c_core video output dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: scsi_wait_scan]

Pid: 1959, comm: wpa_supplicant Not tainted 2.6.32-279.5.2.el6.x86_64
#1 OEM OEM/Cantiga
RIP: 0010:[<ffffffff81500398>]  [<ffffffff81500398>] _spin_lock+0x18/0x30
RSP: 0018:ffff880028203e40  EFLAGS: 00000297
RAX: 0000000000000906 RBX: ffff880028203e40 RCX: 00000000000024ba
RDX: 0000000000000905 RSI: 0000000000000282 RDI: ffff88013be72e74
RBP: ffffffff8100ba53 R08: 0000000000000000 R09: ffff880139a51b78
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880028203dc0
R13: ffff88013be78018 R14: ffff88013be72e74 R15: 0000000000000040
FS:  00007f4baef8e7c0(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fde46a8ef40 CR3: 0000000139a5b000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process wpa_supplicant (pid: 1959, threadinfo ffff880139a50000, task
ffff880138354aa0)
Stack:
 ffff880028203e90 ffffffffa03bc966 ffffffffa02df2f3 ffff88013be78018
<d> ffff88013be725a0 00000000000114b0 0000000000000000 ffff88013be72e10
<d> 0000000000000100 0000000000000006 ffff880028203ec0 ffffffff810742d5
Call Trace:
 <IRQ>
 [<ffffffffa03bc966>] ? ath9k_tasklet+0x46/0x190 [ath9k]
 [<ffffffffa02df2f3>] ? ath9k_hw_kill_interrupts+0xb3/0xf0 [ath9k_hw]
 [<ffffffff810742d5>] ? tasklet_action+0xe5/0x120
 [<ffffffff81073ec1>] ? __do_softirq+0xc1/0x1e0
 [<ffffffff8100c24c>] ? call_softirq+0x1c/0x30
 [<ffffffff8100de85>] ? do_softirq+0x65/0xa0
 [<ffffffff81073ca5>] ? irq_exit+0x85/0x90
 [<ffffffff81505d75>] ? do_IRQ+0x75/0xf0
 [<ffffffff8100ba53>] ? ret_from_intr+0x0/0x11
 <EOI>
 [<ffffffff815003e7>] ? _spin_unlock_irqrestore+0x17/0x20
 [<ffffffff8105335e>] ? __wake_up_sync_key+0x5e/0x80
 [<ffffffff8142bb34>] ? sock_def_readable+0x44/0x80
 [<ffffffff814cd913>] ? unix_dgram_sendmsg+0x5e3/0x6b0
 [<ffffffff81428283>] ? sock_sendmsg+0x123/0x150
 [<ffffffff810920d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81427b33>] ? move_addr_to_user+0x93/0xb0
 [<ffffffff81427cbe>] ? __sys_recvmsg+0x16e/0x2f0
 [<ffffffff81428759>] ? sys_sendto+0x139/0x190
 [<ffffffff810d6c62>] ? audit_syscall_entry+0x272/0x2a0
 [<ffffffff8100b0f2>] ? system_call_fastpath+0x16/0x1b
Code: 44 00 00 f0 81 2f 00 00 00 01 74 05 e8 b2 e3 d7 ff c9 c3 55 48
89 e5 0f 1f 44 00 00 b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8 10 <39>
c2 74 0e f3 90 0f b7 17 eb f5 83 3f 00 75 f4 eb df c9 c3 0f
Call Trace:
 <IRQ>  [<ffffffffa03bc966>] ? ath9k_tasklet+0x46/0x190 [ath9k]
 [<ffffffffa02df2f3>] ? ath9k_hw_kill_interrupts+0xb3/0xf0 [ath9k_hw]
 [<ffffffff810742d5>] ? tasklet_action+0xe5/0x120
 [<ffffffff81073ec1>] ? __do_softirq+0xc1/0x1e0
 [<ffffffff8100c24c>] ? call_softirq+0x1c/0x30
 [<ffffffff8100de85>] ? do_softirq+0x65/0xa0
 [<ffffffff81073ca5>] ? irq_exit+0x85/0x90
 [<ffffffff81505d75>] ? do_IRQ+0x75/0xf0
 [<ffffffff8100ba53>] ? ret_from_intr+0x0/0x11
 <EOI>  [<ffffffff815003e7>] ? _spin_unlock_irqrestore+0x17/0x20
 [<ffffffff8105335e>] ? __wake_up_sync_key+0x5e/0x80
 [<ffffffff8142bb34>] ? sock_def_readable+0x44/0x80
 [<ffffffff814cd913>] ? unix_dgram_sendmsg+0x5e3/0x6b0
 [<ffffffff81428283>] ? sock_sendmsg+0x123/0x150
 [<ffffffff810920d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81427b33>] ? move_addr_to_user+0x93/0xb0
 [<ffffffff81427cbe>] ? __sys_recvmsg+0x16e/0x2f0
 [<ffffffff81428759>] ? sys_sendto+0x139/0x190
 [<ffffffff810d6c62>] ? audit_syscall_entry+0x272/0x2a0
 [<ffffffff8100b0f2>] ? system_call_fastpath+0x16/0x1b

lspci:
17:00.0 Network controller: Atheros Communications Inc. AR9160
Wireless Network Adapter [AR9001 802.11(a)bgn] (rev 01)
        Subsystem: Ubiquiti Networks, Inc. SR71-A 802.11abgn Wireless
Mini PCI Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fd5f0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=100mA
PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel modules: ath9k
17:01.0 Network controller: Atheros Communications Inc. AR9160
Wireless Network Adapter [AR9001 802.11(a)bgn] (rev 01)
        Subsystem: Ubiquiti Networks, Inc. SR71-A 802.11abgn Wireless
Mini PCI Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at fd5e0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=100mA
PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel modules: ath9k

Please let me know if you need further info/testing.

On Mon, Jan 14, 2013 at 4:50 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> The commit "ath9k: fix rx flush handling" added a deadlock that happens
> because ath_rx_tasklet is called in a section that has already taken the
> rx buffer lock.
>
> It seems that the only purpose of the rxbuflock was a band-aid fix to the
> reset vs rx tasklet race, which has been properly fixed in the commit
> "ath9k: add a better fix for the rx tasklet vs rx flush race".
>
> Now that the fix is in, we can safely remove the lock to avoid such issues.
>
> Cc: stable@vger.kernel.org
> Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
>  drivers/net/wireless/ath/ath9k/recv.c  | 13 -------------
>  2 files changed, 14 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index feab50e..8250330 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -314,7 +314,6 @@ struct ath_rx {
>         u32 *rxlink;
>         u32 num_pkts;
>         unsigned int rxfilter;
> -       spinlock_t rxbuflock;
>         struct list_head rxbuf;
>         struct ath_descdma rxdma;
>         struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index ada9d87..d7c129b 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -249,8 +249,6 @@ rx_init_fail:
>
>  static void ath_edma_start_recv(struct ath_softc *sc)
>  {
> -       spin_lock_bh(&sc->rx.rxbuflock);
> -
>         ath9k_hw_rxena(sc->sc_ah);
>
>         ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP,
> @@ -262,8 +260,6 @@ static void ath_edma_start_recv(struct ath_softc *sc)
>         ath_opmode_init(sc);
>
>         ath9k_hw_startpcureceive(sc->sc_ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
> -
> -       spin_unlock_bh(&sc->rx.rxbuflock);
>  }
>
>  static void ath_edma_stop_recv(struct ath_softc *sc)
> @@ -280,7 +276,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
>         int error = 0;
>
>         spin_lock_init(&sc->sc_pcu_lock);
> -       spin_lock_init(&sc->rx.rxbuflock);
>
>         common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
>                              sc->sc_ah->caps.rx_status_len;
> @@ -438,7 +433,6 @@ int ath_startrecv(struct ath_softc *sc)
>                 return 0;
>         }
>
> -       spin_lock_bh(&sc->rx.rxbuflock);
>         if (list_empty(&sc->rx.rxbuf))
>                 goto start_recv;
>
> @@ -459,8 +453,6 @@ start_recv:
>         ath_opmode_init(sc);
>         ath9k_hw_startpcureceive(ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
>
> -       spin_unlock_bh(&sc->rx.rxbuflock);
> -
>         return 0;
>  }
>
> @@ -476,7 +468,6 @@ bool ath_stoprecv(struct ath_softc *sc)
>         struct ath_hw *ah = sc->sc_ah;
>         bool stopped, reset = false;
>
> -       spin_lock_bh(&sc->rx.rxbuflock);
>         ath9k_hw_abortpcurecv(ah);
>         ath9k_hw_setrxfilter(ah, 0);
>         stopped = ath9k_hw_stopdmarecv(ah, &reset);
> @@ -487,7 +478,6 @@ bool ath_stoprecv(struct ath_softc *sc)
>                 ath_edma_stop_recv(sc);
>         else
>                 sc->rx.rxlink = NULL;
> -       spin_unlock_bh(&sc->rx.rxbuflock);
>
>         if (!(ah->ah_flags & AH_UNPLUGGED) &&
>             unlikely(!stopped)) {
> @@ -1153,7 +1143,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>                 dma_type = DMA_FROM_DEVICE;
>
>         qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
> -       spin_lock_bh(&sc->rx.rxbuflock);
>
>         tsf = ath9k_hw_gettsf64(ah);
>         tsf_lower = tsf & 0xffffffff;
> @@ -1351,8 +1340,6 @@ requeue:
>                 }
>         } while (1);
>
> -       spin_unlock_bh(&sc->rx.rxbuflock);
> -
>         if (!(ah->imask & ATH9K_INT_RXEOL)) {
>                 ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
>                 ath9k_hw_set_interrupts(ah);
> --
> 1.8.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
