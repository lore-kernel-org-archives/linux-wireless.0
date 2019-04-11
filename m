Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0CFC10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 21:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E197C20850
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 21:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555016849;
	bh=1WxsmPxgYFxfxyDeHj3NXLYPUnp1vIsLPqrhQYu2efI=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=PBcw7H/WC6VDnVt7kjjIcRxj+ltWPZ17h4kOL0xMFHJRO57dB/JB2H5Tm4JKe0e/7
	 RG6DvvlIioRpf2BTT1EQC+a8EokiIjrujbJ1yO0/kGbvpHZE0kfn3/uh9dWnsME55H
	 rg/xVey0j+k2eTEc8BktWoHNjYNlx6zWEA1XxhLc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfDKVHY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 17:07:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:52414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726664AbfDKVHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 17:07:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7481ACC6;
        Thu, 11 Apr 2019 21:07:21 +0000 (UTC)
Date:   Thu, 11 Apr 2019 23:07:20 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>
Subject: iwlwifi: BUG: unable to handle kernel paging request at
 ffffc90000e1c808
Message-ID: <20190411210404.GC4743@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
I have just encountered the following splat with 5.1-rc4. Is this a
known problem? Greping throug older logs show that "Error sending SCAN_CFG_CMD"
is not new. In older kernels it was followed by "Start IWL Error Log Dump:"
but it oopsed now. I was running 5.0 previously. Let me know if you need
more information.

[ 3076.724445] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
[ 3076.724449] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 38 write_ptr 39
[ 3076.724468] BUG: unable to handle kernel paging request at ffffc90000e1c808
[ 3076.724469] #PF error: [normal kernel read fault]
[ 3076.724470] PGD 245924067 P4D 245924067 PUD 245925067 PMD 24441e067 PTE 0
[ 3076.724473] Oops: 0000 [#1] PREEMPT SMP PTI
[ 3076.724475] CPU: 2 PID: 10490 Comm: kworker/2:0 Not tainted 5.1.0-rc4-00003-gfd008d1a7a20 #50
[ 3076.724476] Hardware name: Dell Inc. Latitude E7470/0T6HHJ, BIOS 1.5.3 04/18/2016
[ 3076.724500] Workqueue: events iwl_mvm_tcm_work [iwlmvm]
[ 3076.724506] RIP: 0010:iwl_trans_pcie_read32+0xe/0x11 [iwlwifi]
[ 3076.724508] Code: f6 48 03 b7 28 a2 00 00 88 16 c3 0f 1f 44 00 00 89 f6 48 03 b7 28 a2 00 00 89 16 c3 0f 1f 44 00 00 89 f6 48 03 b7 28 a2 00 00 <8b> 06 c3 0f 1f 44 00 00 48 8b 47 10 83 78 48 13 19 c0 25 00 00 10
[ 3076.724509] RSP: 0000:ffffc9000622fcb0 EFLAGS: 00010282
[ 3076.724510] RAX: ffffffffa024ce32 RBX: ffff888243000018 RCX: 0000000000000003
[ 3076.724512] RDX: 0000000008000005 RSI: ffffc90000e1c808 RDI: ffff888243000018
[ 3076.724513] RBP: ffff888243009154 R08: 0000000000000001 R09: ffffffff824e062f
[ 3076.724514] R10: 0000000000000000 R11: ffffc9000622f9e7 R12: 00000001000a97a6
[ 3076.724514] R13: 0000000000000006 R14: ffff888242af4000 R15: ffff88824300a268
[ 3076.724516] FS:  0000000000000000(0000) GS:ffff888245f00000(0000) knlGS:0000000000000000
[ 3076.724517] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3076.724518] CR2: ffffc90000e1c808 CR3: 000000010131c003 CR4: 00000000003606e0
[ 3076.724519] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3076.724520] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 3076.724521] Call Trace:
[ 3076.724527]  iwl_trans_sync_nmi+0xac/0x18a [iwlwifi]
[ 3076.724533]  iwl_trans_pcie_send_hcmd+0x2e1/0x3b2 [iwlwifi]
[ 3076.724536]  ? wait_woken+0x6d/0x6d
[ 3076.724542]  iwl_trans_send_cmd+0x99/0xb4 [iwlwifi]
[ 3076.724547]  iwl_mvm_send_cmd+0x2a/0x5c [iwlmvm]
[ 3076.724554]  iwl_mvm_config_scan+0x38b/0x3c2 [iwlmvm]
[ 3076.724560]  ? iwl_mvm_update_low_latency+0xbb/0xbb [iwlmvm]
[ 3076.724565]  iwl_mvm_recalc_tcm+0x473/0x48c [iwlmvm]
[ 3076.724569]  process_one_work+0x1e2/0x32b
[ 3076.724571]  ? pwq_unbound_release_workfn+0xc9/0xc9
[ 3076.724573]  worker_thread+0x1d8/0x2a3
[ 3076.724574]  kthread+0x114/0x11c
[ 3076.724576]  ? kthread_park+0x76/0x76
[ 3076.724579]  ret_from_fork+0x3a/0x50
[ 3076.724581] Modules linked in: tun ctr ccm binfmt_misc snd_hda_codec_hdmi arc4 snd_hda_codec_realtek snd_hda_codec_generic i915 i2c_algo_bit iosf_mbi snd_hda_intel iwlmvm drm_kms_helper uvcvideo snd_hda_codec videobuf2_vmalloc cfbfillrect mac80211 videobuf2_memops videobuf2_v4l2 snd_hda_core syscopyarea videobuf2_common cfbimgblt sysfillrect snd_pcm_oss videodev snd_mixer_oss sysimgblt coretemp iwlwifi fb_sys_fops hwmon cfbcopyarea x86_pkg_temp_thermal fb snd_pcm fbdev kvm_intel media drm kvm drm_panel_orientation_quirks snd_timer irqbypass i2c_i801 cfg80211 snd i2c_core video backlight
[ 3076.724596] CR2: ffffc90000e1c808
[ 3076.724598] ---[ end trace da5234017dd6ffd3 ]---
[ 3076.724603] RIP: 0010:iwl_trans_pcie_read32+0xe/0x11 [iwlwifi]
[ 3076.724605] Code: f6 48 03 b7 28 a2 00 00 88 16 c3 0f 1f 44 00 00 89 f6 48 03 b7 28 a2 00 00 89 16 c3 0f 1f 44 00 00 89 f6 48 03 b7 28 a2 00 00 <8b> 06 c3 0f 1f 44 00 00 48 8b 47 10 83 78 48 13 19 c0 25 00 00 10
[ 3076.724606] RSP: 0000:ffffc9000622fcb0 EFLAGS: 00010282
[ 3076.724607] RAX: ffffffffa024ce32 RBX: ffff888243000018 RCX: 0000000000000003
[ 3076.724608] RDX: 0000000008000005 RSI: ffffc90000e1c808 RDI: ffff888243000018
[ 3076.724609] RBP: ffff888243009154 R08: 0000000000000001 R09: ffffffff824e062f
[ 3076.724610] R10: 0000000000000000 R11: ffffc9000622f9e7 R12: 00000001000a97a6
[ 3076.724611] R13: 0000000000000006 R14: ffff888242af4000 R15: ffff88824300a268
[ 3076.724612] FS:  0000000000000000(0000) GS:ffff888245f00000(0000) knlGS:0000000000000000
[ 3076.724613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3076.724614] CR2: ffffc90000e1c808 CR3: 000000010131c003 CR4: 00000000003606e0
[ 3076.724615] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3076.724616] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 3077.332767] iwlwifi 0000:01:00.0: Queue 0 is inactive on fifo 2 and stuck for 2500 ms. SW [38, 39] HW [162, 162] FH TRB=0x0a5a5a5a2
[ 3084.756712] iwlwifi 0000:01:00.0: Queue 10 is inactive on fifo 2 and stuck for 10000 ms. SW [81, 89] HW [162, 162] FH TRB=0x0a5a5a5a2
[ 3097.044641] iwlwifi 0000:01:00.0: Queue 11 is inactive on fifo 2 and stuck for 10000 ms. SW [203, 204] HW [162, 162] FH TRB=0x0a5a5a5a2

-- 
Michal Hocko
SUSE Labs
