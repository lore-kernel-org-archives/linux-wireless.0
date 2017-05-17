Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:33940 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbdEQKGF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 06:06:05 -0400
Received: by mail-wr0-f172.google.com with SMTP id l9so5296305wre.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 May 2017 03:06:04 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: Adrian Chadd <adrian@freebsd.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>,
        simon.wunderlich@openmesh.com
Subject: Re: [PATCH] [ath10k] go back to using dma_alloc_coherent() for firmware scratch memory.
Date: Wed, 17 May 2017 12:06:01 +0200
Message-ID: <2107639.cIofNFgAHq@bentobox> (sfid-20170517_120613_650866_73B520DB)
In-Reply-To: <20170501214327.5621-1-adrian@freebsd.org>
References: <20170501214327.5621-1-adrian@freebsd.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1548018.VmSduaC9nQ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1548018.VmSduaC9nQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 1. Mai 2017 14:43:27 CEST Adrian Chadd wrote:
> This reverts b057886524be060021e3cfad0ba8458c850330cd in 2015
> which converted this allocation from dma_map_coherent() to
> kzalloc() / dma_map_single().
> 
> The current problem manifests when using later model NICs with larger
> (>700KiB) scratch spaces in memory.  Although the kzalloc call
> succeeds, the software IOMMU TLB code (via dma_map_single()) panics
> because it can't find 700KiB of linear physmem bounce buffers for DMA.
> Now, this is a bit of a silly failure mode for the dma map API,
> but it's what we currently have to play with.
[....]
> 
> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 35 ++++++++++-------------------------
>  1 file changed, 10 insertions(+), 25 deletions(-)

Thanks for investigating this. This partial revert fixes following crash for
me with QCA99X0 on amd64 with SWIOMMU:

    [    9.167281] DMA: Out of SW-IOMMU space for 689816 bytes at device 0000:02:00.0
    [    9.174719] Kernel panic - not syncing: DMA: Random memory could be DMA read
    [    9.174719] 
    [    9.183560] CPU: 0 PID: 133 Comm: kworker/u32:6 Tainted: P           OE   4.9.0-0.bpo.2-amd64 #1 Debian 4.9.13-1~bpo8+1
    [    9.194666] Hardware name: Intel Corporation SandyBridge Platform/ETXe-SC T2 i3-2310E, BIOS CHR2R110 05/12/2011
    [    9.205033] Workqueue: ath10k_aux_wq ath10k_wmi_event_service_ready_work [ath10k_core]
    [    9.213151]  0000000000000000 ffffffffbd329cd5 0000000000000200 ffffa7b5c1247cb8
    [    9.220827]  ffffffffbd17bc24 0000000000000008 ffffa7b5c1247cc8 ffffa7b5c1247c60
    [    9.228523]  000000006036bf02 0000000200000018 ffff91fde700dfc8 0000000000000000
    [    9.236177] Call Trace:
    [    9.238692]  [<ffffffffbd329cd5>] ? dump_stack+0x5c/0x77
    [    9.244165]  [<ffffffffbd17bc24>] ? panic+0xe8/0x236
    [    9.251161]  [<ffffffffbd354ffc>] ? swiotlb_map_page+0x16c/0x190
    [    9.259219]  [<ffffffffc0c1d3e5>] ? ath10k_wmi_event_service_ready_work+0x4d5/0x680 [ath10k_core]
    [    9.272150]  [<ffffffffbd09171b>] ? process_one_work+0x14b/0x410
    [    9.280190]  [<ffffffffbd0921d5>] ? worker_thread+0x65/0x4a0
    [    9.287869]  [<ffffffffbd092170>] ? rescuer_thread+0x340/0x340
    [    9.295689]  [<ffffffffbd0974c0>] ? kthread+0xe0/0x100
    [    9.302742]  [<ffffffffbd02476b>] ? __switch_to+0x2bb/0x700
    [    9.310213]  [<ffffffffbd0973e0>] ? kthread_park+0x60/0x60
    [    9.317556]  [<ffffffffbd5fb675>] ? ret_from_fork+0x25/0x30
    [    9.324992] Kernel Offset: 0x3c000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
    [    9.339429] ---[ end Kernel panic - not syncing: DMA: Random memory could be DMA read
    [    9.339429] 
    [    9.353900] ------------[ cut here ]------------
    [    9.360274] WARNING: CPU: 0 PID: 133 at /home/zumbi/linux-4.9.13/arch/x86/kernel/smp.c:127 update_process_times+0x40/0x50
    [    9.374724] Modules linked in: tpm_infineon iTCO_wdt iTCO_vendor_support ppdev wl(POE) evdev intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd intel_cstate intel_uncore ath10k_pci ath10k_core intel_rapl_perf ath mac80211 i2c_kempld btusb btrtl btbcm btintel pcspkr bluetooth cfg80211 serio_raw rfkill snd_hda_codec_realtek snd_hda_codec_generic battery snd_hda_intel parport_pc parport snd_hda_codec i915 snd_hda_core snd_hwdep shpchp video drm_kms_helper snd_pcm snd_timer snd drm soundcore mei_me button mei i2c_i801 i2c_smbus lpc_ich tpm_tis tpm_tis_core ac tpm autofs4 ext4 crc16 jbd2 fscrypto mbcache sg sd_mod ata_generic ahci pata_jmicron libahci kempld_core mfd_core libata ehci_pci ehci_hcd scsi_mod crc32c_intel usbcore psmouse e1000e usb_common igb i2c_algo_bit dca ptp pps_core fan thermal fjes
    [    9.476736] CPU: 0 PID: 133 Comm: kworker/u32:6 Tainted: P           OE   4.9.0-0.bpo.2-amd64 #1 Debian 4.9.13-1~bpo8+1
    [    9.491320] Hardware name: Intel Corporation SandyBridge Platform/ETXe-SC T2 i3-2310E, BIOS CHR2R110 05/12/2011
    [    9.505260] Workqueue: ath10k_aux_wq ath10k_wmi_event_service_ready_work [ath10k_core]
    [    9.517103]  0000000000000000 ffffffffbd329cd5 0000000000000000 0000000000000000
    [    9.528682]  ffffffffbd0778a4 ffff91fde101a140 0000000000000000 ffffa7b5c1247b98
    [    9.540304]  ffffffffbd0f7270 0000000000000003 ffff91fde7012580 ffffffffbd0e7dc0
    [    9.551962] Call Trace:
    [    9.556381]  <IRQ> [    9.558370]  [<ffffffffbd329cd5>] ? dump_stack+0x5c/0x77
    [    9.567776]  [<ffffffffbd0778a4>] ? __warn+0xc4/0xe0
    [    9.574863]  [<ffffffffbd0f7270>] ? tick_sched_do_timer+0x30/0x30
    [    9.583059]  [<ffffffffbd0e7dc0>] ? update_process_times+0x40/0x50
    [    9.591302]  [<ffffffffbd0f6c80>] ? tick_sched_handle.isra.13+0x20/0x50
    [    9.600021]  [<ffffffffbd0f72a8>] ? tick_sched_timer+0x38/0x70
    [    9.607872]  [<ffffffffbd0e8a5c>] ? __hrtimer_run_queues+0xdc/0x250
    [    9.616158]  [<ffffffffbd0e8ea9>] ? hrtimer_interrupt+0x99/0x190
    [    9.624100]  [<ffffffffbd5fdd29>] ? smp_apic_timer_interrupt+0x39/0x50
    [    9.632618]  [<ffffffffbd5fd042>] ? apic_timer_interrupt+0x82/0x90
    [    9.640700]  <EOI> [    9.642681]  [<ffffffffbd17bd2e>] ? panic+0x1f2/0x236
    [    9.649615]  [<ffffffffbd354ffc>] ? swiotlb_map_page+0x16c/0x190
    [    9.657526]  [<ffffffffc0c1d3e5>] ? ath10k_wmi_event_service_ready_work+0x4d5/0x680 [ath10k_core]
    [    9.670007]  [<ffffffffbd09171b>] ? process_one_work+0x14b/0x410
    [    9.677874]  [<ffffffffbd0921d5>] ? worker_thread+0x65/0x4a0
    [    9.685388]  [<ffffffffbd092170>] ? rescuer_thread+0x340/0x340
    [    9.693016]  [<ffffffffbd0974c0>] ? kthread+0xe0/0x100
    [    9.699914]  [<ffffffffbd02476b>] ? __switch_to+0x2bb/0x700
    [    9.707224]  [<ffffffffbd0973e0>] ? kthread_park+0x60/0x60
    [    9.714363]  [<ffffffffbd5fb675>] ? ret_from_fork+0x25/0x30
    [    9.721589] ---[ end trace 6814c79dfe2a14da ]---

Tested-by: Sven Eckelmann <sven.eckelmann@openmesh.com>

Kind regards,
	Sven
--nextPart1548018.VmSduaC9nQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlkcIIkACgkQXYcKB8Em
e0blfxAAsoxWL4okN9ILld4frcAEtFdg15AT2Lam7JQnxyiEy/Ix8VbbJEEKgCXw
Tr6/mu3qkKnAh4DPVGuYC7NpCEVIhqQCw6+ooUOQy/371j/bR76Z4R6zL33TvBPx
eXyDOWiU1K6dESGz7E7SbGv9oB2dav9yRcByBIsVUcgb9DXA8FSfIJBjI7eghfTh
nL8wH+ZMcV1a/b4zi0LvvwLTrm6B3qo398q0pBMINtGCDYiQDrzBQpocyuI+3CIT
xxvzucIyX810plyDT7kaBTWdKruVEONsQ+YpsOahWG36BeoBK3cfBGo79RhGg0Wu
qXpykFtjyRGGQmlAqt1kyctZ/sAyB8na60TJLgucbXxh5skGMzSzEWAuws4JFaGf
EX/OPOw2cNu7Ij4qGPG2ga93UU44WFyhcU9X/+K06UYhJU0ro6+HfgXycqFK/14F
IIX53i4suTG9RDTwAitdlI2VxUoA125sdG6/x0W8pB40miavUy7tRyuTJa0FZYBp
RcmfzzB9mPnQEPX6uPr9kggNDOAaSMOClsqWJ8pfChWrplltOO++oSXeO7Zx0Wwg
duuVmtP38YJrxlZyIqqSLQhKuDjWSDN1zVffjz32qm0uz4olgJBTJUsT+/PSBEkm
TxStzz3isJ0ku6lw5vtW1yCA6U77NzTwaq2oAS3ZAyOBQF2BfSo=
=1zQR
-----END PGP SIGNATURE-----

--nextPart1548018.VmSduaC9nQ--
