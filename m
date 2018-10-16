Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D73C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16BEA20881
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+5B/JTL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16BEA20881
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbeJPS1Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 14:27:24 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:39660 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbeJPS1Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 14:27:24 -0400
Received: by mail-ed1-f53.google.com with SMTP id d15-v6so20801221edq.6
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 03:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=u8XGvCqdPmgrgiw7Swsfqx9rMSlynWM/GezjI+hjxOk=;
        b=Z+5B/JTLgOp0bmlme5LOerthRZc+Y3K0BOFogydsGECBcMMgUBUkdFQ7Smamz6tMT/
         qk0QmVDtUEq+2pGBe2D6we0Wo9lBaH3k/30wt+SU4wEf/jQA7g3yZSHjXgqqNjXDbHxV
         E/KhFyP9vC/hw5apBcRd1BJcKNAoo9Dv7sDRHy8AYjFNGpPC4OZh5s/9OnEzm0LVEw3Z
         AnkT/E408c6DuSmMzPg7ly13YxevVg60I3iEsLXBPiew1zm2ZUWHpVzm925n3vPJCDVi
         i9HfpBUtzwlBcjlrhqRw0FSKP+Tp5QCAl0fewSG9ZVD4PoadBne9dLq+VovmuuIH8DIm
         Xx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=u8XGvCqdPmgrgiw7Swsfqx9rMSlynWM/GezjI+hjxOk=;
        b=izQtRLwgMq6nSAsOQ+nKcEMOPSiy2729pteIrwNMphSmBNRfDZZFXBJX4t6NCdoY4z
         95AqbitD+63uiesecmAQyFzJv5jOPitvGMQ6EqPZqxQYZV9rLazHcREtKSN/Jb1uOUat
         h0jtf4tBdH2z0pCI9liH5pE7z/r9NDoVsvdRj1P2xapcONqOCb9/X6wK82H6D7QQ4fiw
         iS0qb7nUp/tQIRPIOl+Vm/Co6FUXHY4FEK0WnstMJ2GrELGI0rOp4V5p+aXu0nS6JJH8
         +DenaVDIroqrZrKrwQZOf5nVWvFYXZ8YXojURNwjp6ZMawTz9BSEXB/E/tQku+8YIh24
         V8AQ==
X-Gm-Message-State: ABuFfoj/LH+ahOFDgCwXBdMnrC6RTglC8T3mUZrxrH3NSojY+n+Ntkld
        wODzsMCOEBus6cST9lPA9RjJEkrNdSNFTE4pw37qXMl3
X-Google-Smtp-Source: ACcGV63rg/7FmVts70v9ar+kRgAWfvxuYe/OWmvkJyNmaB3X5teT6U57yLZCIqBXk0ZiixT/IFf9m9ShrOwwdsU5AaI=
X-Received: by 2002:a17:906:7103:: with SMTP id x3-v6mr22755900ejj.72.1539686253814;
 Tue, 16 Oct 2018 03:37:33 -0700 (PDT)
MIME-Version: 1.0
From:   Damjan Georgievski <gdamjan@gmail.com>
Date:   Tue, 16 Oct 2018 12:37:22 +0200
Message-ID: <CAEk1YH7KJcobRz1+arZv2sjtMD-XxdCxPp5QqEJR=G+TQ66b2g@mail.gmail.com>
Subject: iwlmvm crashes when connecting to a WPA-Enterprise network
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

each time I connect to the corporate wpa-enterprise network, iwlmvm crashes

distro is ArchLinux
- kernel is 4.19.0-rc8+
- networkmanager 1.14.1dev+13+g0d3234478-1
- wpa_supplicant 1:2.6-12



[ 1257.940526] BUG: scheduling while atomic: irq/133-iwlwifi/388/0x00000403
[ 1257.940535] Modules linked in: ccm cmac rfcomm joydev mousedev
rmi_smbus bnep rmi_core arc4 iTCO_wdt iTCO_vendor_support wmi_bmof
intel_wmi_thunderbolt iwlmvm snd_soc_skl snd_soc_skl_ipc
snd_soc_sst_ipc mac80211 snd_soc_sst_dsp snd_hda_ext_core btusb
snd_soc_acpi_intel_match snd_soc_acpi uvcvideo intel_rapl snd_soc_core
snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp btrtl
snd_hda_codec_conexant snd_hda_codec_generic snd_compress
videobuf2_vmalloc btbcm videobuf2_memops ac97_bus btintel
videobuf2_v4l2 coretemp snd_pcm_dmaengine iwlwifi videobuf2_common
psmouse snd_hda_intel kvm_intel bluetooth videodev snd_hda_codec
e1000e intel_cstate qcserial intel_uncore intel_rapl_perf usb_wwan
cdc_mbim cdc_wdm input_leds snd_hda_core pcspkr media cdc_ncm
usbserial usbnet mii cfg80211 snd_hwdep ecdh_generic
[ 1257.940645]  snd_pcm ptp pps_core i2c_i801 snd_timer rtsx_pci_ms
thinkpad_acpi memstick mei_me mei intel_pch_thermal nvram ucsi_acpi
typec_ucsi rfkill tpm_crb typec wmi snd soundcore led_class i2c_hid
battery ac tpm_tis rtc_cmos hid tpm_tis_core evdev tpm mac_hid
rng_core pcc_cpufreq usbip_host usbip_core sg scsi_mod crypto_user
ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 fscrypto
algif_skcipher af_alg dm_crypt dm_mod rtsx_pci_sdmmc crct10dif_pclmul
crc32_pclmul serio_raw crc32c_intel ghash_clmulni_intel atkbd mmc_core
pcbc libps2 aesni_intel xhci_pci aes_x86_64 crypto_simd xhci_hcd
cryptd glue_helper usbcore rtsx_pci usb_common i8042 serio
nls_iso8859_1 nls_cp437 vfat fat i915 intel_gtt i2c_algo_bit
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm
agpgart kvmgt vfio_mdev
[ 1257.940816]  mdev vfio_iommu_type1 vfio kvm irqbypass
[ 1257.940833] Preemption disabled at:
[ 1257.940865] [<ffffffffc0f4a705>] iwl_pcie_irq_handler+0x6f5/0xbc0 [iwlwifi]
[ 1257.940882] CPU: 2 PID: 388 Comm: irq/133-iwlwifi Tainted: G
W         4.19.0-rc8+ #14
[ 1257.940887] Hardware name: LENOVO 20HQS0LV00/20HQS0LV00, BIOS
N1MET49W (1.34 ) 07/02/2018
[ 1257.940892] Call Trace:
[ 1257.940912]  dump_stack+0x5c/0x80
[ 1257.940938]  ? iwl_pcie_irq_handler+0x6f5/0xbc0 [iwlwifi]
[ 1257.940950]  __schedule_bug.cold.14+0x82/0x9b
[ 1257.940960]  __schedule+0x6fd/0x8b0
[ 1257.940971]  schedule+0x32/0x90
[ 1257.940981]  schedule_timeout+0x1d1/0x4a0
[ 1257.940995]  ? collect_expired_timers+0xa0/0xa0
[ 1257.941025]  iwl_trans_pcie_send_hcmd+0x2a4/0x520 [iwlwifi]
[ 1257.941039]  ? wait_woken+0x80/0x80
[ 1257.941075]  iwl_trans_send_cmd+0x61/0xd0 [iwlwifi]
[ 1257.941099]  iwl_mvm_send_cmd+0x2c/0x90 [iwlmvm]
[ 1257.941125]  ? rs_fill_lq_cmd+0x267/0x4e0 [iwlmvm]
[ 1257.941145]  iwl_mvm_send_lq_cmd+0x73/0xa0 [iwlmvm]
[ 1257.941168]  iwl_mvm_rs_rate_init+0x952/0xd10 [iwlmvm]
[ 1257.941192]  iwl_mvm_rs_tx_status+0x66c/0x21c0 [iwlmvm]
[ 1257.941247]  ? ieee80211_prepare_and_rx_handle+0xbe7/0x1250 [mac80211]
[ 1257.941288]  rate_control_tx_status+0x9e/0xb0 [mac80211]
[ 1257.941320]  __ieee80211_tx_status+0x449/0x8e0 [mac80211]
[ 1257.941355]  ? sta_info_hash_lookup+0xe3/0x120 [mac80211]
[ 1257.941384]  ieee80211_tx_status+0x89/0xc0 [mac80211]
[ 1257.941406]  iwl_mvm_rx_tx_cmd+0x447/0x8b0 [iwlmvm]
[ 1257.941432]  ? iwl_pcie_gen2_tx_init+0x140/0x140 [iwlwifi]
[ 1257.941451]  iwl_pcie_rx_handle+0x252/0x9e0 [iwlwifi]
[ 1257.941472]  iwl_pcie_irq_handler+0x6ff/0xbc0 [iwlwifi]
[ 1257.941484]  ? irq_forced_thread_fn+0x70/0x70
[ 1257.941492]  irq_thread_fn+0x1f/0x50
[ 1257.941501]  irq_thread+0xe7/0x170
[ 1257.941510]  ? wake_threads_waitq+0x30/0x30
[ 1257.941522]  ? irq_thread_dtor+0x80/0x80
[ 1257.941529]  kthread+0x112/0x130
[ 1257.941536]  ? kthread_park+0x80/0x80
[ 1257.941545]  ret_from_fork+0x35/0x40
[ 1259.948869] iwlwifi 0000:04:00.0: Error sending LQ_CMD: time out
after 2000ms.
[ 1259.948880] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 99 write_ptr 100
[ 1259.949046] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[ 1259.949052] iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
[ 1259.949057] iwlwifi 0000:04:00.0: Loaded firmware version: 36.e91976c0.0
[ 1259.949063] iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
[ 1259.949068] iwlwifi 0000:04:00.0: 0x00A00220 | trm_hw_status0
[ 1259.949073] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[ 1259.949078] iwlwifi 0000:04:00.0: 0x000248DC | branchlink2
[ 1259.949083] iwlwifi 0000:04:00.0: 0x0003A7DA | interruptlink1
[ 1259.949088] iwlwifi 0000:04:00.0: 0x0003A7DA | interruptlink2
[ 1259.949093] iwlwifi 0000:04:00.0: 0x00000000 | data1
[ 1259.949097] iwlwifi 0000:04:00.0: 0x00000080 | data2
[ 1259.949102] iwlwifi 0000:04:00.0: 0x07830000 | data3
[ 1259.949107] iwlwifi 0000:04:00.0: 0x14C01989 | beacon time
[ 1259.949112] iwlwifi 0000:04:00.0: 0xD0D7A45A | tsf low
[ 1259.949117] iwlwifi 0000:04:00.0: 0x0000009B | tsf hi
[ 1259.949122] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[ 1259.949126] iwlwifi 0000:04:00.0: 0x124A14A7 | time gp2
[ 1259.949131] iwlwifi 0000:04:00.0: 0x00000001 | uCode revision type
[ 1259.949136] iwlwifi 0000:04:00.0: 0x00000024 | uCode version major
[ 1259.949141] iwlwifi 0000:04:00.0: 0xE91976C0 | uCode version minor
[ 1259.949146] iwlwifi 0000:04:00.0: 0x00000230 | hw version
[ 1259.949151] iwlwifi 0000:04:00.0: 0x00C89000 | board version
[ 1259.949156] iwlwifi 0000:04:00.0: 0x8070F500 | hcmd
[ 1259.949160] iwlwifi 0000:04:00.0: 0x24022000 | isr0
[ 1259.949165] iwlwifi 0000:04:00.0: 0x01800000 | isr1
[ 1259.949170] iwlwifi 0000:04:00.0: 0x08001802 | isr2
[ 1259.949175] iwlwifi 0000:04:00.0: 0x004174C0 | isr3
[ 1259.949179] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[ 1259.949184] iwlwifi 0000:04:00.0: 0x0063014E | last cmd Id
[ 1259.949189] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[ 1259.949194] iwlwifi 0000:04:00.0: 0x00000288 | l2p_control
[ 1259.949198] iwlwifi 0000:04:00.0: 0x00018030 | l2p_duration
[ 1259.949203] iwlwifi 0000:04:00.0: 0x000000BF | l2p_mhvalid
[ 1259.949208] iwlwifi 0000:04:00.0: 0x000000EF | l2p_addr_match
[ 1259.949213] iwlwifi 0000:04:00.0: 0x0000000D | lmpm_pmg_sel
[ 1259.949218] iwlwifi 0000:04:00.0: 0x28031619 | timestamp
[ 1259.949223] iwlwifi 0000:04:00.0: 0x0034C8F0 | flow_handler
[ 1259.949297] iwlwifi 0000:04:00.0: 0x00000000 | ADVANCED_SYSASSERT
[ 1259.949302] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink1
[ 1259.949307] iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink2
[ 1259.949312] iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink1
[ 1259.949316] iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink2
[ 1259.949321] iwlwifi 0000:04:00.0: 0x00000000 | umac data1
[ 1259.949326] iwlwifi 0000:04:00.0: 0x00000000 | umac data2
[ 1259.949330] iwlwifi 0000:04:00.0: 0x00000000 | umac data3
[ 1259.949335] iwlwifi 0000:04:00.0: 0x00000000 | umac major
[ 1259.949340] iwlwifi 0000:04:00.0: 0x00000000 | umac minor
[ 1259.949345] iwlwifi 0000:04:00.0: 0x00000000 | frame pointer
[ 1259.949349] iwlwifi 0000:04:00.0: 0x00000000 | stack pointer
[ 1259.949354] iwlwifi 0000:04:00.0: 0x00000000 | last host cmd
[ 1259.949359] iwlwifi 0000:04:00.0: 0x00000000 | isr status reg
[ 1259.949368] ieee80211 phy0: Hardware restart was requested
[ 1259.949449] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x92000000.
[ 1259.949464] iwlwifi 0000:04:00.0: HCMD_ACTIVE already clear for
command LQ_CMD


-- 
damjan
