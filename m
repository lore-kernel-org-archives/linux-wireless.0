Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A55C07E85
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D32302081C
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D32302081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bananateam.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbeLGMff (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:35:35 -0500
Received: from mail.bananateam.nl ([213.125.76.250]:33522 "EHLO
        mail.bananateam.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGMfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 07:35:34 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2018 07:35:32 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.bananateam.nl (Postfix) with ESMTP id 07C5A3373EDD
        for <linux-wireless@vger.kernel.org>; Fri,  7 Dec 2018 13:29:24 +0100 (CET)
X-Virus-Scanned: amavisd-new at bananateam.nl
Received: from mail.bananateam.nl ([127.0.0.1])
        by localhost (mail.bananateam.nl [127.0.0.1]) (amavisd-new, port 59111)
        with ESMTP id HjPqG-rmPDN0 for <linux-wireless@vger.kernel.org>;
        Fri,  7 Dec 2018 13:29:03 +0100 (CET)
Received: from [192.168.1.35] (unknown [171.33.224.230])
        by mail.bananateam.nl (Postfix) with ESMTPSA id C4BD73373EC6
        for <linux-wireless@vger.kernel.org>; Fri,  7 Dec 2018 13:29:02 +0100 (CET)
From:   Ferry <freaky@bananateam.nl>
Subject: Can't connect to WPA(2)-EAP network (eduroam / TTLS) with iwlwifi
 (9260 - and some others) ~90% of the time with 4.17.16 through 4.19.7 at
 least
To:     linux-wireless@vger.kernel.org
Message-ID: <d6628e5f-f71c-7fb7-d127-334bbea66953@bananatem.nl>
Date:   Fri, 7 Dec 2018 13:29:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------63BCA7162D36CFCBA06ED317"
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------63BCA7162D36CFCBA06ED317
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi,

I have a Dell XPS 15 9550 in which I replaced the wireless Broadcom
adapter with an Intel 9260.

So far I have not encountered any issues whatsoever with WPA(2)-PSK
networks, but I do have issues connecting to WPA(2)-EAP networks (at
least eduroam here, which uses TTLS / MSCHAPv2), which I did not have
with the Broadcom 43602 originally in the system).

On this machine I run gentoo linux (~amd64) with KDE/plasma. That said,
we've seen similar issues (they appear identical even though other model
Intel AC adapters) with several other machines containing Intel AC
adapters on Fedora 28 with various kernel releases as well when trying
to connect to the same network / with same credentials. Unfortunately I
don't have the modelnumbers at hand. The issues seem to have been around
for a while. On one of the other machines the issues did not occur with
a 4.16 kernel (think I tested with 4.16.16 then).

The issue is not consistent. That is, every 1 or 2 out of 10 boots,
it'll will just work. This does seem to be somewhat hardware related, on
my machine it mostly does not work, on some others we see different
numbers, some mostly work but show the same behavious on occasion. The
messages below don't appear in the logs when it does work.

In both cases (gentoo / fedora) NetworkManager is used to connect to the
network.

Hope someone can help resolve this. I can build kernels / apply patches
/ aid with debugging, but I'm not a developer.

Attached is dmesg from clean boot after several connection attempts.
Basically repeats the following quite a few times:

[   82.169103] BUG: scheduling while atomic: irq/124-iwlwifi/266/0x00000400
[   82.169106] Modules linked in: dm_crypt algif_skcipher
x86_pkg_temp_thermal uvcvideo kvm_intel videobuf2_vmalloc
videobuf2_memops iwlmvm videobuf2_v4l2 kvm irqbypass crc32_pclmul
dell_smbios ghash_clmulni_intel intel_wmi_thunderbolt
dell_wmi_descriptor videodev hid_multitouch btusb btrtl iwlwifi
snd_hda_codec_hdmi videobuf2_common snd_hda_codec_realtek btbcm btintel
bluetooth intel_hid
[   82.169120] CPU: 2 PID: 266 Comm: irq/124-iwlwifi Tainted: G       
W         4.19.7-gentoo #1
[   82.169121] Hardware name: Dell Inc. XPS 15 9550/0N7TVV, BIOS 1.9.0
10/11/2018
[   82.169123] Call Trace:
[   82.169144]  dump_stack+0x46/0x60
[   82.169147]  __schedule_bug.cold.97+0x5/0x1d
[   82.169149]  __schedule+0x4f6/0x730
[   82.169151]  schedule+0x23/0x70
[   82.169153]  schedule_timeout+0x179/0x370
[   82.169156]  ? __next_timer_interrupt+0xc0/0xc0
[   82.169161]  iwl_trans_pcie_send_hcmd+0x316/0x550 [iwlwifi]
[   82.169163]  ? wait_woken+0x80/0x80
[   82.169166]  iwl_trans_send_cmd+0x59/0xc0 [iwlwifi]
[   82.169171]  iwl_mvm_send_cmd+0x1e/0x70 [iwlmvm]
[   82.169174]  ? rs_fill_lq_cmd+0x24b/0x3d0 [iwlmvm]
[   82.169177]  iwl_mvm_send_lq_cmd+0x6e/0x90 [iwlmvm]
[   82.169181]  iwl_mvm_rs_rate_init+0x913/0xcb0 [iwlmvm]
[   82.169184]  iwl_mvm_rs_tx_status+0x39d/0x1f80 [iwlmvm]
[   82.169186]  ? enqueue_task_fair+0x3fa/0xfb0
[   82.169188]  ? enqueue_task_fair+0x3fa/0xfb0
[   82.169190]  rate_control_tx_status+0x99/0xa0
[   82.169193]  __ieee80211_tx_status+0x3b5/0x7b0
[   82.169196]  ? iwl_trans_pcie_set_pmi+0x20/0x20 [iwlwifi]
[   82.169198]  ? sta_info_hash_lookup+0xe1/0x120
[   82.169200]  ieee80211_tx_status+0x7c/0xb0
[   82.169203]  iwl_mvm_rx_tx_cmd+0x2da/0x710 [iwlmvm]
[   82.169206]  ? iwl_pcie_gen2_tx_init+0x130/0x130 [iwlwifi]
[   82.169209]  iwl_pcie_rx_handle+0x276/0x9f0 [iwlwifi]
[   82.169211]  ? irq_forced_thread_fn+0x70/0x70
[   82.169213]  iwl_pcie_irq_rx_msix_handler+0x52/0xf0 [iwlwifi]
[   82.169215]  ? irq_forced_thread_fn+0x70/0x70
[   82.169216]  irq_thread_fn+0x1c/0x60
[   82.169218]  irq_thread+0xe2/0x160
[   82.169219]  ? wake_threads_waitq+0x30/0x30
[   82.169221]  ? irq_thread_dtor+0x80/0x80
[   82.169223]  kthread+0x10e/0x130
[   82.169225]  ? kthread_create_worker_on_cpu+0x60/0x60
[   82.169226]  ret_from_fork+0x35/0x40
[   84.175959] iwlwifi 0000:02:00.0: Error sending LQ_CMD: time out
after 2000ms.
[   84.175963] iwlwifi 0000:02:00.0: Current CMD queue read_ptr 146
write_ptr 147
[   84.176074] iwlwifi 0000:02:00.0: Microcode SW error detected.
Restarting 0x1.
[   84.176102] iwlwifi 0000:02:00.0: Loaded firmware version: 38.755cfdd8.0
[   84.176103] iwlwifi 0000:02:00.0: 0x00000000 |
ADVANCED_SYSASSERT         
[   84.176105] iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status0
[   84.176106] iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status1
[   84.176120] iwlwifi 0000:02:00.0: 0x00000000 | branchlink2
[   84.176121] iwlwifi 0000:02:00.0: 0x0045E90E | interruptlink1
[   84.176123] iwlwifi 0000:02:00.0: 0x00000A42 | interruptlink2
[   84.176124] iwlwifi 0000:02:00.0: 0x00000000 | data1
[   84.176125] iwlwifi 0000:02:00.0: 0xFF000000 | data2
[   84.176126] iwlwifi 0000:02:00.0: 0xF0000008 | data3
[   84.176127] iwlwifi 0000:02:00.0: 0x2241419C | beacon time
[   84.176128] iwlwifi 0000:02:00.0: 0xB2A1AA66 | tsf low
[   84.176130] iwlwifi 0000:02:00.0: 0x0000047D | tsf hi
[   84.176131] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
[   84.176132] iwlwifi 0000:02:00.0: 0x018424AE | time gp2
[   84.176133] iwlwifi 0000:02:00.0: 0x00000001 | uCode revision type
[   84.176134] iwlwifi 0000:02:00.0: 0x00000026 | uCode version major
[   84.176136] iwlwifi 0000:02:00.0: 0x755CFDD8 | uCode version minor
[   84.176137] iwlwifi 0000:02:00.0: 0x00000321 | hw version
[   84.176138] iwlwifi 0000:02:00.0: 0x00C89004 | board version
[   84.176139] iwlwifi 0000:02:00.0: 0x0092014E | hcmd
[   84.176140] iwlwifi 0000:02:00.0: 0x24022000 | isr0
[   84.176141] iwlwifi 0000:02:00.0: 0x11800000 | isr1
[   84.176142] iwlwifi 0000:02:00.0: 0x08001802 | isr2
[   84.176144] iwlwifi 0000:02:00.0: 0x00417CC0 | isr3
[   84.176145] iwlwifi 0000:02:00.0: 0x00000000 | isr4
[   84.176146] iwlwifi 0000:02:00.0: 0x0092014E | last cmd Id
[   84.176147] iwlwifi 0000:02:00.0: 0x00000000 | wait_event
[   84.176148] iwlwifi 0000:02:00.0: 0x00000080 | l2p_control
[   84.176149] iwlwifi 0000:02:00.0: 0x00010034 | l2p_duration
[   84.176151] iwlwifi 0000:02:00.0: 0x0000003F | l2p_mhvalid
[   84.176152] iwlwifi 0000:02:00.0: 0x000000CE | l2p_addr_match
[   84.176153] iwlwifi 0000:02:00.0: 0x0000000D | lmpm_pmg_sel
[   84.176154] iwlwifi 0000:02:00.0: 0x04071046 | timestamp
[   84.176155] iwlwifi 0000:02:00.0: 0x00340038 | flow_handler
[   84.176194] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
[   84.176195] iwlwifi 0000:02:00.0: Status: 0x00000100, count: 7
[   84.176197] iwlwifi 0000:02:00.0: 0x00000066 | NMI_INTERRUPT_HOST
[   84.176198] iwlwifi 0000:02:00.0: 0x00000000 | umac branchlink1
[   84.176199] iwlwifi 0000:02:00.0: 0xC0087CB8 | umac branchlink2
[   84.176200] iwlwifi 0000:02:00.0: 0xC0083A20 | umac interruptlink1
[   84.176202] iwlwifi 0000:02:00.0: 0xC0083A20 | umac interruptlink2
[   84.176203] iwlwifi 0000:02:00.0: 0x01000000 | umac data1
[   84.176204] iwlwifi 0000:02:00.0: 0xC0083A20 | umac data2
[   84.176205] iwlwifi 0000:02:00.0: 0xDEADBEEF | umac data3
[   84.176206] iwlwifi 0000:02:00.0: 0x00000026 | umac major
[   84.176207] iwlwifi 0000:02:00.0: 0x755CFDD8 | umac minor
[   84.176209] iwlwifi 0000:02:00.0: 0xC0886298 | frame pointer
[   84.176210] iwlwifi 0000:02:00.0: 0xC0886298 | stack pointer
[   84.176211] iwlwifi 0000:02:00.0: 0x0092014E | last host cmd
[   84.176212] iwlwifi 0000:02:00.0: 0x00000000 | isr status reg
[   84.176214] ieee80211 phy0: Hardware restart was requested



--------------63BCA7162D36CFCBA06ED317
Content-Type: application/x-xz;
 name="dmesg.xz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.xz"

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
CJiWBwABopUB/JcGYZhmXbHEZ/sCAAAAAARZWg==
--------------63BCA7162D36CFCBA06ED317--
