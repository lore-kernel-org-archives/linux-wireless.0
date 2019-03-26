Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C3AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 07:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C92620828
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 07:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfCZHyS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:54:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbfCZHyS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 03:54:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCD9EC057F4C;
        Tue, 26 Mar 2019 07:54:17 +0000 (UTC)
Received: from localhost (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D835C1001DE6;
        Tue, 26 Mar 2019 07:54:16 +0000 (UTC)
Date:   Tue, 26 Mar 2019 08:54:14 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     yhchuang@realtek.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, pkshih@realtek.com,
        tehuang@realtek.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20190326075414.GA8598@redhat.com>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <20190325143611.sjwwjqtrftxntwyk@penguin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190325143611.sjwwjqtrftxntwyk@penguin>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 26 Mar 2019 07:54:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On Mon, Mar 25, 2019 at 02:36:11PM +0000, Brian Norris wrote:
> On Wed, Mar 13, 2019 at 12:13:49PM +0800, yhchuang@realtek.com wrote:
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > 
> > This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> > rtw88 now supports RTL8822BE/RTL8822CE now, with basic station mode
> > functionalities. The firmware for both can be found at linux-firmware.
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> > For RTL8822BE: rtw88/rtw8822b_fw.bin
> > For RTL8822CE: rtw88/rtw8822c_fw.bin
<snip>
> I also gave 8822CE some moderate testing, and while I'm sure it's not
> perfect, it's at least stable, and it's in much better than when I
> tested approximately v2 (as Tony has rolled in a lot of fixes since
> then):
> 
> Tested-by: Brian Norris <briannorris@chromium.org>

I also tested on RTL8822CE we generously got from Tony. I replaced wifi
card on my laptop by the 8822CE device. I have warning on resume from
suspend (see below, it could be mac80211 issue though). But network
connection was established after the warning and in general device
works stable for 2 days now.

Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>

[16158.826873] rtw_pci 0000:02:00.0: start vif 00:e0:4c:09:94:0f on port 0
[16158.827693] ------------[ cut here ]------------
[16158.827694] wlan0: invalid CW_min/CW_max: 0/0
[16158.827722] WARNING: CPU: 0 PID: 8407 at net/mac80211/driver-ops.c:175 drv_conf_tx+0x188/0x190 [mac80211]
[16158.827723] Modules linked in: rtwpci rtw88 mac80211 cfg80211 tun ccm fuse bnep sunrpc arc4 snd_soc_skl snd_soc_core snd_soc_acpi_intel_match snd_hda_codec_hdmi snd_soc_acpi intel_rapl snd_soc_skl_ipc x86_pkg_temp_thermal snd_hda_codec_realtek mei_wdt snd_hda_codec_generic intel_powerclamp snd_soc_sst_ipc iTCO_wdt iTCO_vendor_support snd_soc_sst_dsp coretemp snd_hda_ext_core wmi_bmof intel_cstate uvcvideo intel_uncore btusb intel_wmi_thunderbolt videobuf2_vmalloc intel_rapl_perf snd_hda_intel btrtl videobuf2_memops btbcm btintel snd_hda_codec videobuf2_v4l2 bluetooth snd_hwdep videobuf2_common joydev snd_hda_core videodev media snd_seq snd_seq_device ecdh_generic snd_pcm mei_me mei ucsi_acpi idma64 typec_ucsi i2c_i801 typec intel_lpss_pci snd_timer intel_lpss intel_pch_thermal processor_thermal_device intel_soc_dts_iosf wmi thinkpad_acpi ledtrig_audio snd soundcore rfkill int3403_thermal int340x_thermal_zone acpi_pad int3400_thermal acpi_thermal_rel pcc_cpufreq uas usb_storage crc
 32c_intel
[16158.827744]  i915 nvme i2c_algo_bit drm_kms_helper serio_raw e1000e nvme_core drm video ipv6 [last unloaded: cfg80211]
[16158.827748] CPU: 0 PID: 8407 Comm: kworker/u16:34 Tainted: G        W         5.0.0-rc7+ #11
[16158.827749] Hardware name: LENOVO 20KGS23S0P/20KGS23S0P, BIOS N23ET55W (1.30 ) 08/31/2018
[16158.827752] Workqueue: events_unbound async_run_entry_fn
[16158.827762] RIP: 0010:drv_conf_tx+0x188/0x190 [mac80211]
[16158.827763] Code: ff ff ff e9 ea fe ff ff 41 0f b7 4e 04 0f b7 d0 48 8d b3 60 04 00 00 48 c7 c7 10 a6 e7 c0 c6 05 63 3e 0b 00 01 e8 92 30 2c f9 <0f> 0b e9 c1 fe ff ff 90 0f 1f 44 00 00 41 54 49 89 fc 55 53 48 89
[16158.827763] RSP: 0018:ffff8e4c8a643d48 EFLAGS: 00010296
[16158.827764] RAX: 0000000000000021 RBX: ffff8e4c8a1ce880 RCX: 0000000000000006
[16158.827765] RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff8e4c8e6168c0
[16158.827765] RBP: 00000000ffffffea R08: 0000000000000a15 R09: 0000000000000003
[16158.827766] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8e4c765e87c0
[16158.827766] R13: 0000000000000000 R14: ffff8e4c8a1cee10 R15: ffff8e4c765e8d78
[16158.827767] FS:  0000000000000000(0000) GS:ffff8e4c8e600000(0000) knlGS:0000000000000000
[16158.827768] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16158.827768] CR2: 00007fed80de2e38 CR3: 000000027320e002 CR4: 00000000003606f0
[16158.827769] Call Trace:
[16158.827782]  ieee80211_reconfig+0x58f/0x1420 [mac80211]
[16158.827784]  ? enqueue_entity+0xf6/0x660
[16158.827798]  wiphy_resume+0x7f/0x120 [cfg80211]
[16158.827805]  ? wiphy_suspend+0x270/0x270 [cfg80211]
[16158.827807]  dpm_run_callback+0x59/0x150
[16158.827809]  device_resume+0xac/0x1f0
[16158.827810]  async_resume+0x19/0x30
[16158.827811]  async_run_entry_fn+0x39/0x160
[16158.827813]  process_one_work+0x1a1/0x3a0
[16158.827814]  worker_thread+0x30/0x380
[16158.827815]  ? pwq_unbound_release_workfn+0xd0/0xd0
[16158.827816]  kthread+0x112/0x130
[16158.827818]  ? kthread_create_on_node+0x40/0x40
[16158.827820]  ret_from_fork+0x35/0x40
[16158.827821] ---[ end trace cc6c13e7f9e63472 ]---

Stanislaw
