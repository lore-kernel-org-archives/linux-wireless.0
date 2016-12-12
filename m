Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3091 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932269AbcLLQfQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 11:35:16 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k:  free host-mem with DMA_BIRECTIONAL flag.
Date: Mon, 12 Dec 2016 16:35:10 +0000
Message-ID: <87eg1d14xt.fsf@kamboji.qca.qualcomm.com> (sfid-20161212_173528_094827_410F4C26)
References: <1480962519-13027-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1480962519-13027-1-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Mon, 5 Dec 2016 10:28:39 -0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Hopefully this fixes the problem reported by Kalle:
>
> Noticed this in my log, but I don't have time to investigate this in
> detail right now:
>
> [  413.795346] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  414.158755] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  477.439659] ath10k_pci 0000:02:00.0: could not get mac80211 beacon
> [  481.666630] ------------[ cut here ]------------
> [  481.666669] WARNING: CPU: 0 PID: 1978 at lib/dma-debug.c:1155 check_un=
map+0x320/0x8e0
> [  481.666688] ath10k_pci 0000:02:00.0: DMA-API: device driver frees DMA =
memory with different direction [device address=3D0x000000002d130000] [size=
=3D63800 bytes] [mapped with DMA_BIDIRECTIONAL] [unmapped with DMA_TO_DEVIC=
E]
> [  481.666703] Modules linked in: ctr ccm ath10k_pci(E-) ath10k_core(E) a=
th(E) mac80211(E) cfg80211(E) snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_=
codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm sn=
d_seq_midi arc4 snd_rawmidi snd_seq_midi_event snd_seq btusb btintel snd_se=
q_device joydev coret
> [  481.671468] CPU: 0 PID: 1978 Comm: rmmod Tainted: G            E   4.9=
.0-rc7-wt+ #54
> [  481.671478] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS=
 68CDD Ver. F.04 01/27/2010
> [  481.671489]  ef49dcec c842ee92 c8b5830e ef49dd34 ef49dd20 c80850f5 c8b=
5a13c ef49dd50
> [  481.671560]  000007ba c8b5830e 00000483 c8461830 c8461830 00000483 ef4=
9ddcc f34e64b8
> [  481.671641]  c8b58360 ef49dd3c c80851bb 00000009 00000000 ef49dd34 c8b=
5a13c ef49dd50
> [  481.671716] Call Trace:
> [  481.671731]  [<c842ee92>] dump_stack+0x76/0xb4
> [  481.671745]  [<c80850f5>] __warn+0xe5/0x100
> [  481.671757]  [<c8461830>] ? check_unmap+0x320/0x8e0
> [  481.671769]  [<c8461830>] ? check_unmap+0x320/0x8e0
> [  481.671780]  [<c80851bb>] warn_slowpath_fmt+0x3b/0x40
> [  481.671791]  [<c8461830>] check_unmap+0x320/0x8e0
> [  481.671804]  [<c8462054>] debug_dma_unmap_page+0x84/0xa0
> [  481.671835]  [<f937cd7a>] ath10k_wmi_free_host_mem+0x9a/0xe0 [ath10k_c=
ore]
> [  481.671861]  [<f9363400>] ath10k_core_destroy+0x50/0x60 [ath10k_core]
> [  481.671875]  [<f8e13969>] ath10k_pci_remove+0x79/0xa0 [ath10k_pci]
> [  481.671889]  [<c848d8d8>] pci_device_remove+0x38/0xb0
> [  481.671901]  [<c859fe4b>] __device_release_driver+0x7b/0x110
> [  481.671913]  [<c85a00e7>] driver_detach+0x97/0xa0
> [  481.671923]  [<c859ef8b>] bus_remove_driver+0x4b/0xb0
> [  481.671934]  [<c85a0cda>] driver_unregister+0x2a/0x60
> [  481.671949]  [<c848c888>] pci_unregister_driver+0x18/0x70
> [  481.671965]  [<f8e14dae>] ath10k_pci_exit+0xd/0x25f [ath10k_pci]
> [  481.671979]  [<c812bb84>] SyS_delete_module+0xf4/0x180
> [  481.671995]  [<c81f801b>] ? __might_fault+0x8b/0xa0
> [  481.672009]  [<c80037d0>] do_fast_syscall_32+0xa0/0x1e0
> [  481.672025]  [<c88d4c88>] sysenter_past_esp+0x45/0x74
> [  481.672037] ---[ end trace 3fd23759e17e1622 ]---
> [  481.672049] Mapped at:
> [  481.672060]  [  481.672072] [<c846062c>] debug_dma_map_page.part.25+0x=
1c/0xf0
> [  481.672083]  [  481.672095] [<c8460799>] debug_dma_map_page+0x99/0xc0
> [  481.672106]  [  481.672132] [<f93745ec>] ath10k_wmi_alloc_chunk+0x12c/=
0x1f0 [ath10k_core]
> [  481.672142]  [  481.672168] [<f937d0c4>] ath10k_wmi_event_service_read=
y_work+0x304/0x540 [ath10k_core]
> [  481.672178]  [  481.672190] [<c80a3643>] process_one_work+0x1c3/0x670
> [  482.137134] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_m=
ode 0 reset_mode 0
> [  482.313144] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/p=
re-cal-pci-0000:02:00.0.bin failed with error -2
> [  482.313274] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/c=
al-pci-0000:02:00.0.bin failed with error -2
> [  482.313768] ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c c=
hip_id 0x043202ff sub 0000:0000
> [  482.313777] ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing=
 1 dfs 0 testmode 1
> [  482.313974] ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.59-2 api 5=
 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 4159f498
> [  482.369858] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/Q=
CA988X/hw2.0/board-2.bin failed with error -2
> [  482.370011] ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32=
 bebc7c08
> [  483.596770] ath10k_pci 0000:02:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal=
 otp max-sta 128 raw 0 hwcrypto 1
> [  483.701686] ath: EEPROM regdomain: 0x0
> [  483.701706] ath: EEPROM indicates default country code should be used
> [  483.701713] ath: doing EEPROM country->regdmn map search
> [  483.701721] ath: country maps to regdmn code: 0x3a
> [  483.701730] ath: Country alpha2 being used: US
> [  483.701737] ath: Regpair used: 0x3a
>
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, I don't see the warning anymore so this seems to be fixed. I'll
push this to 4.10.

--=20
Kalle Valo=
