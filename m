Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13B8C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575BF217D6
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="q0iATTRW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfBEOY0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 09:24:26 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:17403 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbfBEOY0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 09:24:26 -0500
Date:   Tue, 05 Feb 2019 14:24:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1549376661;
        bh=ixwI8U9iFQVplkoyoqBbTP1dQ1+lxrpCCVj4uRSxT+4=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=q0iATTRWzvKvaN9Js+Vi1WG2BmR9Mf6RTp5lKjs5IJhfN2kUQr6NxKhmY91veZKkr
         AZzjAspcCLm8XyEzJkEz4DMJrqvlD6iRIxNFARTCUeyNm26uwsJaZRihlq451YgNOp
         7hTWrpkm4OthWJ2TRhSXdGLf0oK6F9BF+ZCWwPZg=
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: [BUG] Microcode SW error detected
Message-ID: <CsFdFFRzbpRX_m4C5xfEsE9P5-uv6mNwOUyPl734lLQreQIV9__vxr1NWPkf5oltyFjTZ--34SLql_9ywXamnmw1B7K8lWFzU9kwzWJTdRI=@protonmail.ch>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

For a couple of weeks I see following errors printed in
dmesg from time to time:

iwlwifi 0000:04:00.0: Queue 4 is active on fifo 1 and stuck for 10000 ms. S=
W [189, 201] HW [189, 201] FH TRB=3D0x0c01040c8
iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
iwlwifi 0000:04:00.0: Loaded firmware version: 36.9f0a2d68.0
iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
iwlwifi 0000:04:00.0: 0x200002B0 | trm_hw_status0
iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
iwlwifi 0000:04:00.0: 0x0002485C | branchlink2
iwlwifi 0000:04:00.0: 0x0003A7CA | interruptlink1
iwlwifi 0000:04:00.0: 0x0003E6A4 | interruptlink2
iwlwifi 0000:04:00.0: 0x00000000 | data1
iwlwifi 0000:04:00.0: 0x00000080 | data2
iwlwifi 0000:04:00.0: 0x07830000 | data3
iwlwifi 0000:04:00.0: 0x82818D06 | beacon time
iwlwifi 0000:04:00.0: 0x4E60EC46 | tsf low
iwlwifi 0000:04:00.0: 0x00000257 | tsf hi
iwlwifi 0000:04:00.0: 0x00000000 | time gp1
iwlwifi 0000:04:00.0: 0xBF706F42 | time gp2
iwlwifi 0000:04:00.0: 0x00000001 | uCode revision type
iwlwifi 0000:04:00.0: 0x00000024 | uCode version major
iwlwifi 0000:04:00.0: 0x9F0A2D68 | uCode version minor
iwlwifi 0000:04:00.0: 0x00000230 | hw version
iwlwifi 0000:04:00.0: 0x00489000 | board version
iwlwifi 0000:04:00.0: 0x0000001C | hcmd
iwlwifi 0000:04:00.0: 0x0222204A | isr0
iwlwifi 0000:04:00.0: 0x00800000 | isr1
iwlwifi 0000:04:00.0: 0x0800180A | isr2
iwlwifi 0000:04:00.0: 0x004000C0 | isr3
iwlwifi 0000:04:00.0: 0x00000000 | isr4
iwlwifi 0000:04:00.0: 0xA138009D | last cmd Id
iwlwifi 0000:04:00.0: 0x00000000 | wait_event
iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
iwlwifi 0000:04:00.0: 0x00011420 | l2p_duration
iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
iwlwifi 0000:04:00.0: 0x000000CE | l2p_addr_match
iwlwifi 0000:04:00.0: 0x0000000D | lmpm_pmg_sel
iwlwifi 0000:04:00.0: 0x04120134 | timestamp
iwlwifi 0000:04:00.0: 0x0034B0C8 | flow_handler
iwlwifi 0000:04:00.0: 0x00000000 | ADVANCED_SYSASSERT
iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink1
iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink2
iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink1
iwlwifi 0000:04:00.0: 0x00000000 | umac interruptlink2
iwlwifi 0000:04:00.0: 0x00000000 | umac data1
iwlwifi 0000:04:00.0: 0x00000000 | umac data2
iwlwifi 0000:04:00.0: 0x00000000 | umac data3
iwlwifi 0000:04:00.0: 0x00000000 | umac major
iwlwifi 0000:04:00.0: 0x00000000 | umac minor
iwlwifi 0000:04:00.0: 0x00000000 | frame pointer
iwlwifi 0000:04:00.0: 0x00000000 | stack pointer
iwlwifi 0000:04:00.0: 0x00000000 | last host cmd
iwlwifi 0000:04:00.0: 0x00000000 | isr status reg
iwlwifi 0000:04:00.0: mcast filter cmd error. ret=3D-5

Recently I also saw following warning in Linux 5.0rc5 which
happened just after above:

WARNING: CPU: 0 PID: 8802 at net/mac80211/offchannel.c:158 ieee80211_offcha=
nnel_return+0x18f/0x1a0 [mac80211]
Modules linked in: ccm algif_aead cbc des_generic ecb cmac md4 algif_hash h=
id_sensor_rotation hid_sensor_accel_3d nf_log_ipv4 hid_sensor_als nf_log_co=
mmon hid_sensor_gyro_3d hid_sensor_magn_3d wacom nft_counter hid_sensor_tri=
gger hid_sensor_iio_common xt_mark industrialio_triggered_buffer ipt_REJECT=
 nf_reject_ipv4 kfifo_buf xt_LOG industrialio xt_addrtype xt_tcpudp snd_soc=
_skl xt_conntrack nf_conntrack snd_soc_hdac_hda arc4 snd_hda_ext_core nf_de=
frag_ipv4 snd_soc_acpi_intel_match libcrc32c hid_sensor_hub joydev snd_soc_=
acpi iwlmvm snd_soc_skl_ipc mousedev nft_compat intel_ishtp_hid snd_soc_sst=
_ipc intel_rapl intel_wmi_thunderbolt wmi_bmof snd_soc_sst_dsp mac80211 nf_=
tables x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi nfnetlink s=
nd_soc_core coretemp snd_hda_codec_conexant snd_hda_codec_generic nls_iso88=
59_1 nls_cp437 kvm_intel snd_hda_intel vfat iwlwifi fat snd_hda_codec intel=
_cstate snd_hwdep intel_uncore snd_hda_core psmouse intel_rapl_perf snd_pcm=
 input_leds
 cfg80211 snd_timer rtsx_pci_ms memstick mei_me mei intel_pch_thermal intel=
_ish_ipc ucsi_acpi intel_ishtp typec_ucsi typec thinkpad_acpi wmi ledtrig_a=
udio nvram snd soundcore rfkill battery tpm_crb ac i2c_hid evdev tpm_tis tp=
m_tis_core mac_hid tpm rng_core pcc_cpufreq ip_tables x_tables ext4 crc32c_=
generic crc16 mbcache jbd2 fscrypto algif_skcipher af_alg hid_logitech_hidp=
p hid_logitech_dj hid_generic usbhid hid dm_crypt dm_mod crct10dif_pclmul c=
rc32_pclmul crc32c_intel ghash_clmulni_intel rtsx_pci_sdmmc serio_raw mmc_c=
ore atkbd aesni_intel libps2 aes_x86_64 crypto_simd cryptd glue_helper xhci=
_pci rtsx_pci i8042 serio xhci_hcd i915 intel_gtt i2c_algo_bit drm_kms_help=
er syscopyarea sysfillrect sysimgblt fb_sys_fops drm agpgart kvmgt vfio_mde=
v mdev vfio_iommu_type1 vfio kvm irqbypass
CPU: 0 PID: 8802 Comm: kworker/0:0 Tainted: G                T 5.0.0-rc5 #1
Workqueue: events_freezable ieee80211_restart_work [mac80211]
RIP: 0010:ieee80211_offchannel_return+0x18f/0x1a0 [mac80211]
Code: eb 98 41 83 0f 02 be 10 00 00 00 4c 89 ff e8 d8 22 ff ff e9 69 ff ff =
ff 31 d2 48 89 de 4c 89 ff e8 76 f6 04 00 e9 57 ff ff ff <0f> 0b 5b 5d 41 5=
c 41 5d 41 5e 41 5f c3 0f 1f 40 00 0f 1f 44 00 00
RSP: 0018:ffff99350967fde0 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8c63172b9f80 RSI: 0000000000000000 RDI: ffff8c6307d907a0
RBP: ffff8c6307d907a0 R08: 0000000000000001 R09: 000000000000038d
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8c63075a28a0
R13: ffff8c6307d907a0 R14: 0000000000000000 R15: ffff8c6307d91438
FS:  0000000000000000(0000) GS:ffff8c6319400000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00006d1f075aa000 CR3: 000000020900c006 CR4: 00000000003606f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __ieee80211_scan_completed+0x1b7/0x3f0 [mac80211]
 ieee80211_scan_cancel+0xd1/0x1f0 [mac80211]
 ieee80211_restart_work+0x99/0xf0 [mac80211]
 process_one_work+0x19b/0x3c0
 worker_thread+0x30/0x380
 ? process_one_work+0x3c0/0x3c0
 kthread+0x113/0x130
 ? kthread_park+0x80/0x80
 ret_from_fork+0x35/0x40
---[ end trace 1ba7bbe576255260 ]---


Jordan
