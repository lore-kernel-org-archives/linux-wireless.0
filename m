Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B7EC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F1FE21872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=agilox-net.20150623.gappssmtp.com header.i=@agilox-net.20150623.gappssmtp.com header.b="uotMNu7u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfBGO4x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:56:53 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45887 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfBGO4x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:56:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id q15so88347wro.12
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 06:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=agilox-net.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=OcGOP6Ujcg+HuZVZwsIuxopL/mezS9Z8j26Q7WvXOsA=;
        b=uotMNu7u0R63iFU0RxPbVritBOuZJpRDojIsHvy7v6T6wBWlZ+8ytez+6SQABc535v
         QxH+Nyd6vfseRdD/Mu8EfknCpEtpCGNRC0PpLKIe+2qeNI4jUnBlocARepkVk40Y5mtz
         tBEC3HdMu/eKNxsTq2mggvqnQZ/6nGmmPBqCA54C6SusGuSqiRJ8Q5GQP4BQ2HLt4F4t
         UAPDX085P/xQAsZ/4Bs2cMB5aiVP//I/oO8qGEFl/xP6vDixrPAm0OA0S80DXkClzrrW
         t6ts7wa3S97NoZlsaW0cQXV9EkxH5qqX2E+tnv85v8LC6IxOrKNjcEaIkE9rLkyAhGkk
         XHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=OcGOP6Ujcg+HuZVZwsIuxopL/mezS9Z8j26Q7WvXOsA=;
        b=dgUbCdNNmG4WUQJ9AuQdq80kTDgCMVw05gWoQx7kFiAnUiBx27XL74Ohc0bSR7Pu0H
         Q2VNUTR6c412hntyQCJ6sMn7NAl272szqtrrVYyDI0Qhi+DidiQ08jG8GjRWBvvHlGCe
         V1uHnWyb/dlkyfZXpqrUaUi6THZkiCqADmhFuWakP5gP6cPJxFRWsj2Nu30XT7Ybg7i4
         NGniSsiuu980IhuvgztLy1182LuvE/fhcMZpW2T1B+6restwCaicBPQljtR0xwZIEm3l
         1c4ToQcprr5gtbJ0K4RXFfuRusQEwbLJXYJ5CjVrvm5scigvrauC0C92pPZVCaSklORL
         J+zg==
X-Gm-Message-State: AHQUAubgr5VViOKiuV/hnMTvI5M6p9hsnmWLvmDI8Fg8ePZxOz6KU5TA
        HlLL+8hssQRiarAIWSBrGtvmMg6tUnA=
X-Google-Smtp-Source: AHgI3Ibo6P2oSh6kqh6Ies238MjtGh9gksNv7hlCyFvDDLKBdOh0jPLY2iOYaBaxbmy3PH+BedID0Q==
X-Received: by 2002:adf:db41:: with SMTP id f1mr13203836wrj.133.1549551409152;
        Thu, 07 Feb 2019 06:56:49 -0800 (PST)
Received: from [10.10.55.77] ([31.193.161.162])
        by smtp.gmail.com with ESMTPSA id x3sm33464601wrd.19.2019.02.07.06.56.48
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 06:56:48 -0800 (PST)
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Lukas Redlinger <lukas.redlinger@agilox.net>
Subject: [BUG] iwl_trans_pcie_send_hcmd: STATISTICS_CMD: a command is already
 active
Message-ID: <35c4e94c-4523-0a83-f71f-2e403caf2145@agilox.net>
Date:   Thu, 7 Feb 2019 15:56:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-AT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi there,

Intel 8265 connected to a 5GHz 80MHz channel with 2 spatial streams.
Sometimes an additional virtual interface acting as access point on 
2.4GHz (maybe that's part of the problem...).

On debian buster with Linux 4.19.0-2-amd64 #1 SMP Debian 4.19.16-1 I 
see  this in dmesg output on a regular basis:


[Thu Feb  7 15:24:40 2019] ------------[ cut here ]------------
[Thu Feb  7 15:24:40 2019] Command STATISTICS_CMD: a command is already 
active!
[Thu Feb  7 15:24:40 2019] WARNING: CPU: 3 PID: 27043 at 
drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1865 
iwl_trans_pcie_send_hcmd+0x3e8/0x4b0 [iwlwifi]
[Thu Feb  7 15:24:40 2019] Modules linked in: ctr ccm cmac xt_state 
xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c 
xt_tcpudp nft_compat nft_counter nf_tables nfnetlink snd_hda_codec_hdmi 
snd_hda_codec_realtek bnep snd_hda_codec_generic btusb btrtl btbcm arc4 
btintel rtl8192cu bluetooth rtl_usb iwlmvm rtl8192c_common intel_rapl 
rtlwifi x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
jitterentropy_rng i915 snd_soc_skl_ipc coretemp snd_soc_sst_ipc 
snd_soc_sst_dsp snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi 
kvm_intel snd_soc_core mac80211 drbg iwlwifi kvm snd_compress evdev 
snd_hda_intel ansi_cprng irqbypass snd_hda_codec intel_cstate 
drm_kms_helper qmi_wwan intel_uncore cdc_wdm cfg80211 usbnet 
snd_hda_core intel_rapl_perf qcserial snd_hwdep ftdi_sio pcspkr snd_pcm 
mii usb_wwan snd_timer
[Thu Feb  7 15:24:40 2019]  drm usbserial ecdh_generic sg mei_me mei snd 
rfkill iTCO_wdt idma64 iTCO_vendor_support soundcore intel_pch_thermal 
wmi video acpi_pad button pcc_cpufreq ip_tables x_tables autofs4 ext4 
crc16 mbcache jbd2 crc32c_generic fscrypto ecb algif_skcipher af_alg 
dm_crypt dm_mod sd_mod crct10dif_pclmul crc32_pclmul crc32c_intel 
ghash_clmulni_intel pcbc xhci_pci ahci libahci xhci_hcd usbcore e1000e 
aesni_intel aes_x86_64 crypto_simd cryptd glue_helper usb_common libata 
i2c_i801 igb scsi_mod i2c_algo_bit dca intel_lpss_pci intel_lpss thermal fan
[Thu Feb  7 15:24:40 2019] CPU: 3 PID: 27043 Comm: wavemon Tainted: 
G        W         4.19.0-2-amd64 #1 Debian 4.19.16-1
[Thu Feb  7 15:24:40 2019] Hardware name: CINCOZE DI-1000/DI-1000, BIOS 
5.11 01/23/2018
[Thu Feb  7 15:24:40 2019] RIP: 
0010:iwl_trans_pcie_send_hcmd+0x3e8/0x4b0 [iwlwifi]
[Thu Feb  7 15:24:40 2019] Code: 8b 40 48 e8 8a c7 18 c8 8b 45 24 41 bc 
92 ff ff ff e9 0d fd ff ff e8 47 aa 00 00 48 c7 c7 08 1e a9 c0 48 89 c6 
e8 b2 56 80 c7 <0f> 0b 41 bc fb ff ff ff e9 c8 fd ff ff 41 bc 7c ff ff 
ff e9 bd fd
[Thu Feb  7 15:24:40 2019] RSP: 0018:ffffb0c4c49cf868 EFLAGS: 00010286
[Thu Feb  7 15:24:40 2019] RAX: 0000000000000000 RBX: ffff894b628a0018 
RCX: 0000000000000006
[Thu Feb  7 15:24:40 2019] RDX: 0000000000000007 RSI: 0000000000000086 
RDI: ffff894b65b966a0
[Thu Feb  7 15:24:40 2019] RBP: ffffb0c4c49cf920 R08: 00000000000010fe 
R09: 0000000000000004
[Thu Feb  7 15:24:40 2019] R10: 0000000000000000 R11: 0000000000000001 
R12: 0000000000000000
[Thu Feb  7 15:24:40 2019] R13: ffff894b6003d548 R14: ffff894b6003c2e0 
R15: ffff894b60234000
[Thu Feb  7 15:24:40 2019] FS:  00007f9219448700(0000) 
GS:ffff894b65b80000(0000) knlGS:0000000000000000
[Thu Feb  7 15:24:40 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Feb  7 15:24:40 2019] CR2: 00007f66fc9d00e0 CR3: 00000002415ce004 
CR4: 00000000003606e0
[Thu Feb  7 15:24:40 2019] DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
[Thu Feb  7 15:24:40 2019] DR3: 0000000000000000 DR6: 00000000fffe0ff0 
DR7: 0000000000000400
[Thu Feb  7 15:24:40 2019] Call Trace:
[Thu Feb  7 15:24:40 2019]  iwl_trans_send_cmd+0x61/0xd0 [iwlwifi]
[Thu Feb  7 15:24:40 2019]  iwl_mvm_send_cmd+0x23/0x80 [iwlmvm]
[Thu Feb  7 15:24:40 2019]  iwl_mvm_request_statistics+0x71/0xd0 [iwlmvm]
[Thu Feb  7 15:24:40 2019]  iwl_mvm_mac_get_survey+0x128/0x140 [iwlmvm]
[Thu Feb  7 15:24:40 2019]  ieee80211_dump_survey+0x5e/0x110 [mac80211]
[Thu Feb  7 15:24:40 2019]  nl80211_dump_survey+0x126/0x270 [cfg80211]
[Thu Feb  7 15:24:40 2019]  genl_lock_dumpit+0x2f/0x50
[Thu Feb  7 15:24:40 2019]  netlink_dump+0x11c/0x2b0
[Thu Feb  7 15:24:40 2019]  __netlink_dump_start+0x18c/0x200
[Thu Feb  7 15:24:40 2019]  genl_family_rcv_msg+0x270/0x3a0
[Thu Feb  7 15:24:40 2019]  ? genl_lock_dumpit+0x50/0x50
[Thu Feb  7 15:24:40 2019]  ? genl_lock_done+0x50/0x50
[Thu Feb  7 15:24:40 2019]  ? genl_unlock+0x20/0x20
[Thu Feb  7 15:24:40 2019]  ? netlink_unicast+0x1cd/0x260
[Thu Feb  7 15:24:40 2019]  ? refcount_inc_checked+0x5/0x30
[Thu Feb  7 15:24:40 2019]  ? __skb_try_recv_from_queue+0x87/0x1a0
[Thu Feb  7 15:24:40 2019]  genl_rcv_msg+0x47/0x8c
[Thu Feb  7 15:24:40 2019]  ? _cond_resched+0x15/0x30
[Thu Feb  7 15:24:40 2019]  ? genl_family_rcv_msg+0x3a0/0x3a0
[Thu Feb  7 15:24:40 2019]  netlink_rcv_skb+0x4c/0x120
[Thu Feb  7 15:24:40 2019]  genl_rcv+0x24/0x40
[Thu Feb  7 15:24:40 2019]  netlink_unicast+0x1bd/0x260
[Thu Feb  7 15:24:40 2019]  netlink_sendmsg+0x1ff/0x3b0
[Thu Feb  7 15:24:40 2019]  sock_sendmsg+0x36/0x40
[Thu Feb  7 15:24:40 2019]  ___sys_sendmsg+0x295/0x2f0
[Thu Feb  7 15:24:40 2019]  ? ___sys_recvmsg+0x15e/0x1e0
[Thu Feb  7 15:24:40 2019]  ? __inode_wait_for_writeback+0x7f/0xf0
[Thu Feb  7 15:24:40 2019]  ? fsnotify_destroy_marks+0x22/0xe0
[Thu Feb  7 15:24:40 2019]  ? __dentry_kill+0x121/0x170
[Thu Feb  7 15:24:40 2019]  ? _cond_resched+0x15/0x30
[Thu Feb  7 15:24:40 2019]  ? dentry_kill+0x4d/0x190
[Thu Feb  7 15:24:40 2019]  __sys_sendmsg+0x57/0xa0
[Thu Feb  7 15:24:40 2019]  do_syscall_64+0x53/0x100
[Thu Feb  7 15:24:40 2019] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[Thu Feb  7 15:24:40 2019] RIP: 0033:0x7f921990a3a7
[Thu Feb  7 15:24:40 2019] Code: 44 00 00 41 54 41 89 d4 55 48 89 f5 53 
89 fb 48 83 ec 10 e8 3b ed ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2e 
00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 74 
ed ff ff 48
[Thu Feb  7 15:24:40 2019] RSP: 002b:00007f9219447ca0 EFLAGS: 00000293 
ORIG_RAX: 000000000000002e
[Thu Feb  7 15:24:40 2019] RAX: ffffffffffffffda RBX: 0000000000000007 
RCX: 00007f921990a3a7
[Thu Feb  7 15:24:40 2019] RDX: 0000000000000000 RSI: 00007f9219447d00 
RDI: 0000000000000007
[Thu Feb  7 15:24:40 2019] RBP: 00007f9219447d00 R08: 0000000000000000 
R09: 00007f9214001f50
[Thu Feb  7 15:24:40 2019] R10: 00007f92140008d0 R11: 0000000000000293 
R12: 0000000000000000
[Thu Feb  7 15:24:40 2019] R13: 00007f9219447d00 R14: 00007f9219448700 
R15: 0000000000000000
[Thu Feb  7 15:24:40 2019] ---[ end trace 41b31fad40da3784 ]---
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Error sending LQ_CMD: 
time out after 2000ms.
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Current CMD queue 
read_ptr 189 write_ptr 191
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Status: 0x00000100, 
count: 6
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Loaded firmware 
version: 36.9f0a2d68.0
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000084 | 
NMI_INTERRUPT_UNKNOWN
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000230 | trm_hw_status0
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | trm_hw_status1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x0002485C | branchlink2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x0003A7CA | interruptlink1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00026F18 | interruptlink2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | data1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000080 | data2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x07830000 | data3
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x53C02392 | beacon time
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x70643C45 | tsf low
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x0000053E | tsf hi
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x020BE3BA | time gp2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000001 | uCode 
revision type
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000024 | uCode 
version major
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x9F0A2D68 | uCode 
version minor
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000230 | hw version
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00489000 | board version
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00BE011C | hcmd
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x24022000 | isr0
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | isr1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x0800180A | isr2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00416CC0 | isr3
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | isr4
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00BE0191 | last cmd Id
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | wait_event
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x000000E4 | l2p_control
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00010030 | l2p_duration
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x0000000F | l2p_mhvalid
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00800000 | l2p_addr_match
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x0000000F | lmpm_pmg_sel
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x04120134 | timestamp
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x0000E8D0 | flow_handler
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Status: 0x00000100, 
count: 7
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000070 | 
ADVANCED_SYSASSERT
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | umac 
branchlink1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0xC00868A4 | umac 
branchlink2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0xC0083A94 | umac 
interruptlink1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0xC0083A94 | umac 
interruptlink2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000800 | umac data1
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0xC0083A94 | umac data2
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0xDEADBEEF | umac data3
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000024 | umac major
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x9F0A2D68 | umac minor
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0xC088628C | frame pointer
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0xC088628C | stack pointer
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00BE0191 | last host cmd
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: 0x00000000 | isr status reg
[Thu Feb  7 15:24:40 2019] ieee80211 phy0: Hardware restart was requested
[Thu Feb  7 15:24:40 2019] BUG: scheduling while atomic: 
irq/132-iwlwifi/419/0x7ffffc00
[Thu Feb  7 15:24:40 2019] Modules linked in: ctr ccm cmac xt_state 
xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c 
xt_tcpudp nft_compat nft_counter nf_tables nfnetlink snd_hda_codec_hdmi 
snd_hda_codec_realtek bnep snd_hda_codec_generic btusb btrtl btbcm arc4 
btintel rtl8192cu bluetooth rtl_usb iwlmvm rtl8192c_common intel_rapl 
rtlwifi x86_pkg_temp_thermal snd_soc_skl intel_powerclamp 
jitterentropy_rng i915 snd_soc_skl_ipc coretemp snd_soc_sst_ipc 
snd_soc_sst_dsp snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi 
kvm_intel snd_soc_core mac80211 drbg iwlwifi kvm snd_compress evdev 
snd_hda_intel ansi_cprng irqbypass snd_hda_codec intel_cstate 
drm_kms_helper qmi_wwan intel_uncore cdc_wdm cfg80211 usbnet 
snd_hda_core intel_rapl_perf qcserial snd_hwdep ftdi_sio pcspkr snd_pcm 
mii usb_wwan snd_timer
[Thu Feb  7 15:24:40 2019]  drm usbserial ecdh_generic sg mei_me mei snd 
rfkill iTCO_wdt idma64 iTCO_vendor_support soundcore intel_pch_thermal 
wmi video acpi_pad button pcc_cpufreq ip_tables x_tables autofs4 ext4 
crc16 mbcache jbd2 crc32c_generic fscrypto ecb algif_skcipher af_alg 
dm_crypt dm_mod sd_mod crct10dif_pclmul crc32_pclmul crc32c_intel 
ghash_clmulni_intel pcbc xhci_pci ahci libahci xhci_hcd usbcore e1000e 
aesni_intel aes_x86_64 crypto_simd cryptd glue_helper usb_common libata 
i2c_i801 igb scsi_mod i2c_algo_bit dca intel_lpss_pci intel_lpss thermal fan
[Thu Feb  7 15:24:40 2019] CPU: 1 PID: 419 Comm: irq/132-iwlwifi 
Tainted: G        W         4.19.0-2-amd64 #1 Debian 4.19.16-1
[Thu Feb  7 15:24:40 2019] Hardware name: CINCOZE DI-1000/DI-1000, BIOS 
5.11 01/23/2018
[Thu Feb  7 15:24:40 2019] Call Trace:
[Thu Feb  7 15:24:40 2019]  dump_stack+0x5c/0x80
[Thu Feb  7 15:24:40 2019]  __schedule_bug.cold.84+0x5/0x1d
[Thu Feb  7 15:24:40 2019]  __schedule+0x69f/0x870
[Thu Feb  7 15:24:40 2019]  ? __wake_up_common_lock+0x89/0xc0
[Thu Feb  7 15:24:40 2019]  ? irq_finalize_oneshot.part.43+0x100/0x100
[Thu Feb  7 15:24:40 2019]  schedule+0x28/0x80
[Thu Feb  7 15:24:40 2019]  irq_thread+0x97/0x170
[Thu Feb  7 15:24:40 2019]  ? irq_forced_thread_fn+0x70/0x70
[Thu Feb  7 15:24:40 2019]  ? irq_thread_check_affinity+0xd0/0xd0
[Thu Feb  7 15:24:40 2019]  kthread+0x112/0x130
[Thu Feb  7 15:24:40 2019]  ? kthread_bind+0x30/0x30
[Thu Feb  7 15:24:40 2019]  ret_from_fork+0x35/0x40
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: Microcode SW error 
detected.  Restarting 0x92000000.
[Thu Feb  7 15:24:40 2019] iwlwifi 0000:01:00.0: HCMD_ACTIVE already 
clear for command LQ_CMD


