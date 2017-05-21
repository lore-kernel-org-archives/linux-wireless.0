Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33984 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756994AbdEUUBZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 16:01:25 -0400
Received: by mail-lf0-f65.google.com with SMTP id q24so3696070lfb.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 May 2017 13:01:24 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 0/9] ath10k high latency
Date: Sun, 21 May 2017 21:59:02 +0200
Message-Id: <1495396751-4805-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20170521_220217_692382_965D83C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds the common functionality needed by both USB and SDIO
(referred to as high latency devices). These patches were previously part
of the USB RFC, but was separated  in order to reduce the size of the
patchset.

The status is the same as for the previous USB patch when running
Linux 4.11.0 (ath-201705041301):

- connection to an 802.11ac AP with WPA2 PSK security.
- dhcp lease of ipv4 address
- pinging of access point and a few other devices on my home network
- TX/RX of TCP and UDP messages using netcat

UDP and TCP RX/TX is unfortunately not stable.
Currently I am only capable of receiving ~2.7 Mbytes over TCP before
the device stops receiving.

Unfortunately there is a problem with Linux 4.12-rc1 (ath-201705171256)

When using the patches with kernel version 4.12-rc1 I get an error
when initiating a scan (iw dev wlan0 scan).
The dmesg log is included at end of this mail.

I am running an ARCH system using the default ARCH kernel config (that I
have been using previously with older kernels) on two different machines,
and both machines triggers the error.

I have tried to reproduce the problem with QEMU running a very stripped
down buildroot system, but so far I have failed (in reproducing the problem
in my QEMU environment).

Error log:

[  111.707812] BUG: unable to handle kernel paging request at ffffffffa04ba83e
[  111.707868] IP: report_bug+0x94/0x120
[  111.709664] PGD 1a0c067 
[  111.709665] P4D 1a0c067 
[  111.711479] PUD 1a0d063 
[  111.713231] PMD 213f3b067 
[  111.714926] PTE 800000021042a161

[  111.719836] Oops: 0003 [#1] PREEMPT SMP
[  111.721482] Modules linked in: arc4 ath10k_usb snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc i915 aesni_intel drm_kms_helper ath10k_pci joydev evdev mousedev aes_x86_64 ath10k_core eeepc_wmi input_leds mac_hid drm crypto_simd glue_helper asus_wmi sparse_keymap led_class r8169 iTCO_wdt iTCO_vendor_support ftdi_sio usbserial mii cryptd ath mac80211 intel_cstate intel_gtt snd_hda_codec_realtek intel_rapl_perf snd_hda_codec_generic pcspkr syscopyarea i2c_i801 cfg80211 rfkill wmi battery thermal fan sysfillrect snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep mei_me snd_pcm sysimgblt snd_timer snd fb_sys_fops soundcore tpm_infineon video button mei shpchp i2c_algo_bit lpc_ich tpm_tis tpm_tis_core
[  111.729211]  tpm sch_fq_codel ip_tables x_tables ext4 crc16 jbd2 fscrypto mbcache hid_generic usbhid hid uas usb_storage sd_mod ahci libahci libata scsi_mod xhci_pci ehci_pci xhci_hcd ehci_hcd usbcore usb_common serio
[  111.733409] CPU: 2 PID: 145 Comm: kworker/2:2 Not tainted 4.12.0-rc1-wt-ath-ARCH-195101-gd9e013889878 #17
[  111.735551] Hardware name: ASUS All Series/H81I-PLUS, BIOS 2305 06/04/2015
[  111.737694] Workqueue: events ath10k_usb_io_comp_work [ath10k_usb]
[  111.739837] task: ffff880213c91c80 task.stack: ffffc90001124000
[  111.741971] RIP: 0010:report_bug+0x94/0x120
[  111.744095] RSP: 0018:ffffc90001127a68 EFLAGS: 00010202
[  111.746224] RAX: 0000000000000907 RBX: ffffc90001127bb8 RCX: ffffffffa04ba834
[  111.748374] RDX: 0000000000000001 RSI: 000000000000109d RDI: 0000000000000001
[  111.750519] RBP: ffffc90001127a88 R08: ffffc90001128000 R09: 00000000000002c4
[  111.752667] R10: ffffffff81a06a80 R11: 0000000000000080 R12: ffffffffa04643e8
[  111.754817] R13: ffffffffa04b7a26 R14: 0000000000000006 R15: 0000000000000004
[  111.756966] FS:  0000000000000000(0000) GS:ffff88021fb00000(0000) knlGS:0000000000000000
[  111.759132] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.761304] CR2: ffffffffa04ba83e CR3: 0000000001a09000 CR4: 00000000001406e0
[  111.763491] Call Trace:
[  111.765673]  do_trap+0x16c/0x190
[  111.767853]  do_error_trap+0x89/0x110
[  111.770036]  ? ieee80211_rx_napi+0x598/0xa30 [mac80211]
[  111.772216]  ? __update_load_avg_cfs_rq.isra.6+0x17a/0x180
[  111.774391]  ? __update_load_avg_cfs_rq.isra.6+0x17a/0x180
[  111.776549]  ? __enqueue_entity+0x6c/0x70
[  111.778715]  ? enqueue_entity+0x401/0xb40
[  111.780839]  do_invalid_op+0x20/0x30
[  111.782942]  invalid_op+0x1e/0x30
[  111.785044] RIP: 0010:ieee80211_rx_napi+0x598/0xa30 [mac80211]
[  111.787142] RSP: 0018:ffffc90001127c68 EFLAGS: 00010246
[  111.789234] RAX: 0000000080000000 RBX: ffff88021465b100 RCX: 0000000000000000
[  111.791344] RDX: ffff88021465b100 RSI: 0000000000000000 RDI: ffff88020ca20780
[  111.793460] RBP: ffffc90001127d38 R08: 0000000000000000 R09: 00000000fffffff3
[  111.795575] R10: ffffea0008327800 R11: 0000000000000080 R12: 0000000000000000
[  111.797708] R13: ffff88020ca21560 R14: 0000000000000080 R15: ffff88020ca20780
[  111.799815]  ? __slab_free+0x2fe/0x420
[  111.801925]  ? __iterate_interfaces+0xa6/0x100 [mac80211]
[  111.804041]  ath10k_wmi_event_mgmt_rx+0x233/0x430 [ath10k_core]
[  111.806164]  ath10k_wmi_tlv_op_rx+0x2fb/0x7b0 [ath10k_core]
[  111.808287]  ath10k_wmi_process_rx+0x1a/0x40 [ath10k_core]
[  111.810405]  ath10k_usb_io_comp_work+0x13e/0x1a0 [ath10k_usb]
[  111.812527]  ? __schedule+0x2e3/0x840
[  111.814639]  process_one_work+0x1e0/0x420
[  111.816745]  worker_thread+0x48/0x3f0
[  111.818838]  kthread+0x109/0x140
[  111.820920]  ? process_one_work+0x420/0x420
[  111.822997]  ? kthread_create_on_node+0x70/0x70
[  111.825072]  ret_from_fork+0x2c/0x40
[  111.827141] Code: 74 59 0f b7 41 0a 4c 63 69 04 0f b7 71 08 89 c7 49 01 cd 83 e7 01 a8 02 74 15 66 85 ff 74 10 a8 04 ba 01 00 00 00 75 26 83 c8 04 <66> 89 41 0a 66 85 ff 74 49 0f b6 49 0b 4c 89 e2 45 31 c9 49 89 
[  111.831620] RIP: report_bug+0x94/0x120 RSP: ffffc90001127a68
[  111.833863] CR2: ffffffffa04ba83e
[  111.836095] ---[ end trace 887d2ccc4510936b ]---

Erik Stromdahl (9):
  ath10k: high_latency detection
  ath10k: htt: RX ring config HL support
  ath10k: per target configurablity of various items
  ath10k: add start_once support
  ath10k: htt: High latency TX support
  ath10k: htt: High latency RX support
  ath10k: dma fixes for high latency devices
  ath10k: add QCA9377 usb hw_param item
  ath10k: add QCA9377 sdio hw_param item

 drivers/net/wireless/ath/ath10k/core.c    | 139 ++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/core.h    |  16 ++--
 drivers/net/wireless/ath/ath10k/htc.c     |  13 +--
 drivers/net/wireless/ath/ath10k/htt.c     |   5 +-
 drivers/net/wireless/ath/ath10k/htt.h     |  57 +++++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  98 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  | 126 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h      |  30 +++++++
 drivers/net/wireless/ath/ath10k/mac.c     |   5 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h |  15 ++++
 drivers/net/wireless/ath/ath10k/txrx.c    |   5 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   4 +-
 12 files changed, 459 insertions(+), 54 deletions(-)

-- 
2.7.4
