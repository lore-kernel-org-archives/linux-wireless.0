Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F7CC43444
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C8C20651
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfAONrz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:47:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57278 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbfAONry (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:47:54 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjP4J-0008Fj-JI; Tue, 15 Jan 2019 14:47:51 +0100
Message-ID: <aa88411f96a96a8d7ec576b9ab4bdf4d6847bfeb.camel@sipsolutions.net>
Subject: Re: Can't connect to WPA(2)-EAP network (eduroam / TTLS) with
 iwlwifi (9260 - and some others) ~90% of the time with 4.17.16 through
 4.19.7 at least
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ferry <freaky@bananateam.nl>, linux-wireless@vger.kernel.org
Date:   Tue, 15 Jan 2019 14:47:49 +0100
In-Reply-To: <d6628e5f-f71c-7fb7-d127-334bbea66953@bananatem.nl> (sfid-20181207_133537_505579_E96A63E6)
References: <d6628e5f-f71c-7fb7-d127-334bbea66953@bananatem.nl>
         (sfid-20181207_133537_505579_E96A63E6)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Sorry for the top-post, wanted to push this to the top but also:

If you haven't already, please file a bug on bugzilla.kernel.org and
assign to/CC linuxwifi@intel.com

johannes

On Fri, 2018-12-07 at 13:29 +0100, Ferry wrote:
> Hi,
> 
> I have a Dell XPS 15 9550 in which I replaced the wireless Broadcom
> adapter with an Intel 9260.
> 
> So far I have not encountered any issues whatsoever with WPA(2)-PSK
> networks, but I do have issues connecting to WPA(2)-EAP networks (at
> least eduroam here, which uses TTLS / MSCHAPv2), which I did not have
> with the Broadcom 43602 originally in the system).
> 
> On this machine I run gentoo linux (~amd64) with KDE/plasma. That said,
> we've seen similar issues (they appear identical even though other model
> Intel AC adapters) with several other machines containing Intel AC
> adapters on Fedora 28 with various kernel releases as well when trying
> to connect to the same network / with same credentials. Unfortunately I
> don't have the modelnumbers at hand. The issues seem to have been around
> for a while. On one of the other machines the issues did not occur with
> a 4.16 kernel (think I tested with 4.16.16 then).
> 
> The issue is not consistent. That is, every 1 or 2 out of 10 boots,
> it'll will just work. This does seem to be somewhat hardware related, on
> my machine it mostly does not work, on some others we see different
> numbers, some mostly work but show the same behavious on occasion. The
> messages below don't appear in the logs when it does work.
> 
> In both cases (gentoo / fedora) NetworkManager is used to connect to the
> network.
> 
> Hope someone can help resolve this. I can build kernels / apply patches
> / aid with debugging, but I'm not a developer.
> 
> Attached is dmesg from clean boot after several connection attempts.
> Basically repeats the following quite a few times:
> 
> [   82.169103] BUG: scheduling while atomic: irq/124-iwlwifi/266/0x00000400
> [   82.169106] Modules linked in: dm_crypt algif_skcipher
> x86_pkg_temp_thermal uvcvideo kvm_intel videobuf2_vmalloc
> videobuf2_memops iwlmvm videobuf2_v4l2 kvm irqbypass crc32_pclmul
> dell_smbios ghash_clmulni_intel intel_wmi_thunderbolt
> dell_wmi_descriptor videodev hid_multitouch btusb btrtl iwlwifi
> snd_hda_codec_hdmi videobuf2_common snd_hda_codec_realtek btbcm btintel
> bluetooth intel_hid
> [   82.169120] CPU: 2 PID: 266 Comm: irq/124-iwlwifi Tainted: G       
> W         4.19.7-gentoo #1
> [   82.169121] Hardware name: Dell Inc. XPS 15 9550/0N7TVV, BIOS 1.9.0
> 10/11/2018
> [   82.169123] Call Trace:
> [   82.169144]  dump_stack+0x46/0x60
> [   82.169147]  __schedule_bug.cold.97+0x5/0x1d
> [   82.169149]  __schedule+0x4f6/0x730
> [   82.169151]  schedule+0x23/0x70
> [   82.169153]  schedule_timeout+0x179/0x370
> [   82.169156]  ? __next_timer_interrupt+0xc0/0xc0
> [   82.169161]  iwl_trans_pcie_send_hcmd+0x316/0x550 [iwlwifi]
> [   82.169163]  ? wait_woken+0x80/0x80
> [   82.169166]  iwl_trans_send_cmd+0x59/0xc0 [iwlwifi]
> [   82.169171]  iwl_mvm_send_cmd+0x1e/0x70 [iwlmvm]
> [   82.169174]  ? rs_fill_lq_cmd+0x24b/0x3d0 [iwlmvm]
> [   82.169177]  iwl_mvm_send_lq_cmd+0x6e/0x90 [iwlmvm]
> [   82.169181]  iwl_mvm_rs_rate_init+0x913/0xcb0 [iwlmvm]
> [   82.169184]  iwl_mvm_rs_tx_status+0x39d/0x1f80 [iwlmvm]
> [   82.169186]  ? enqueue_task_fair+0x3fa/0xfb0
> [   82.169188]  ? enqueue_task_fair+0x3fa/0xfb0
> [   82.169190]  rate_control_tx_status+0x99/0xa0
> [   82.169193]  __ieee80211_tx_status+0x3b5/0x7b0
> [   82.169196]  ? iwl_trans_pcie_set_pmi+0x20/0x20 [iwlwifi]
> [   82.169198]  ? sta_info_hash_lookup+0xe1/0x120
> [   82.169200]  ieee80211_tx_status+0x7c/0xb0
> [   82.169203]  iwl_mvm_rx_tx_cmd+0x2da/0x710 [iwlmvm]
> [   82.169206]  ? iwl_pcie_gen2_tx_init+0x130/0x130 [iwlwifi]
> [   82.169209]  iwl_pcie_rx_handle+0x276/0x9f0 [iwlwifi]
> [   82.169211]  ? irq_forced_thread_fn+0x70/0x70
> [   82.169213]  iwl_pcie_irq_rx_msix_handler+0x52/0xf0 [iwlwifi]
> [   82.169215]  ? irq_forced_thread_fn+0x70/0x70
> [   82.169216]  irq_thread_fn+0x1c/0x60
> [   82.169218]  irq_thread+0xe2/0x160
> [   82.169219]  ? wake_threads_waitq+0x30/0x30
> [   82.169221]  ? irq_thread_dtor+0x80/0x80
> [   82.169223]  kthread+0x10e/0x130
> [   82.169225]  ? kthread_create_worker_on_cpu+0x60/0x60
> [   82.169226]  ret_from_fork+0x35/0x40
> [   84.175959] iwlwifi 0000:02:00.0: Error sending LQ_CMD: time out
> after 2000ms.
> [   84.175963] iwlwifi 0000:02:00.0: Current CMD queue read_ptr 146
> write_ptr 147
> [   84.176074] iwlwifi 0000:02:00.0: Microcode SW error detected.
> Restarting 0x1.
> [   84.176102] iwlwifi 0000:02:00.0: Loaded firmware version: 38.755cfdd8.0
> [   84.176103] iwlwifi 0000:02:00.0: 0x00000000 |
> ADVANCED_SYSASSERT         
> [   84.176105] iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status0
> [   84.176106] iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status1
> [   84.176120] iwlwifi 0000:02:00.0: 0x00000000 | branchlink2
> [   84.176121] iwlwifi 0000:02:00.0: 0x0045E90E | interruptlink1
> [   84.176123] iwlwifi 0000:02:00.0: 0x00000A42 | interruptlink2
> [   84.176124] iwlwifi 0000:02:00.0: 0x00000000 | data1
> [   84.176125] iwlwifi 0000:02:00.0: 0xFF000000 | data2
> [   84.176126] iwlwifi 0000:02:00.0: 0xF0000008 | data3
> [   84.176127] iwlwifi 0000:02:00.0: 0x2241419C | beacon time
> [   84.176128] iwlwifi 0000:02:00.0: 0xB2A1AA66 | tsf low
> [   84.176130] iwlwifi 0000:02:00.0: 0x0000047D | tsf hi
> [   84.176131] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
> [   84.176132] iwlwifi 0000:02:00.0: 0x018424AE | time gp2
> [   84.176133] iwlwifi 0000:02:00.0: 0x00000001 | uCode revision type
> [   84.176134] iwlwifi 0000:02:00.0: 0x00000026 | uCode version major
> [   84.176136] iwlwifi 0000:02:00.0: 0x755CFDD8 | uCode version minor
> [   84.176137] iwlwifi 0000:02:00.0: 0x00000321 | hw version
> [   84.176138] iwlwifi 0000:02:00.0: 0x00C89004 | board version
> [   84.176139] iwlwifi 0000:02:00.0: 0x0092014E | hcmd
> [   84.176140] iwlwifi 0000:02:00.0: 0x24022000 | isr0
> [   84.176141] iwlwifi 0000:02:00.0: 0x11800000 | isr1
> [   84.176142] iwlwifi 0000:02:00.0: 0x08001802 | isr2
> [   84.176144] iwlwifi 0000:02:00.0: 0x00417CC0 | isr3
> [   84.176145] iwlwifi 0000:02:00.0: 0x00000000 | isr4
> [   84.176146] iwlwifi 0000:02:00.0: 0x0092014E | last cmd Id
> [   84.176147] iwlwifi 0000:02:00.0: 0x00000000 | wait_event
> [   84.176148] iwlwifi 0000:02:00.0: 0x00000080 | l2p_control
> [   84.176149] iwlwifi 0000:02:00.0: 0x00010034 | l2p_duration
> [   84.176151] iwlwifi 0000:02:00.0: 0x0000003F | l2p_mhvalid
> [   84.176152] iwlwifi 0000:02:00.0: 0x000000CE | l2p_addr_match
> [   84.176153] iwlwifi 0000:02:00.0: 0x0000000D | lmpm_pmg_sel
> [   84.176154] iwlwifi 0000:02:00.0: 0x04071046 | timestamp
> [   84.176155] iwlwifi 0000:02:00.0: 0x00340038 | flow_handler
> [   84.176194] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
> [   84.176195] iwlwifi 0000:02:00.0: Status: 0x00000100, count: 7
> [   84.176197] iwlwifi 0000:02:00.0: 0x00000066 | NMI_INTERRUPT_HOST
> [   84.176198] iwlwifi 0000:02:00.0: 0x00000000 | umac branchlink1
> [   84.176199] iwlwifi 0000:02:00.0: 0xC0087CB8 | umac branchlink2
> [   84.176200] iwlwifi 0000:02:00.0: 0xC0083A20 | umac interruptlink1
> [   84.176202] iwlwifi 0000:02:00.0: 0xC0083A20 | umac interruptlink2
> [   84.176203] iwlwifi 0000:02:00.0: 0x01000000 | umac data1
> [   84.176204] iwlwifi 0000:02:00.0: 0xC0083A20 | umac data2
> [   84.176205] iwlwifi 0000:02:00.0: 0xDEADBEEF | umac data3
> [   84.176206] iwlwifi 0000:02:00.0: 0x00000026 | umac major
> [   84.176207] iwlwifi 0000:02:00.0: 0x755CFDD8 | umac minor
> [   84.176209] iwlwifi 0000:02:00.0: 0xC0886298 | frame pointer
> [   84.176210] iwlwifi 0000:02:00.0: 0xC0886298 | stack pointer
> [   84.176211] iwlwifi 0000:02:00.0: 0x0092014E | last host cmd
> [   84.176212] iwlwifi 0000:02:00.0: 0x00000000 | isr status reg
> [   84.176214] ieee80211 phy0: Hardware restart was requested
> 
> 

