Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppa01.Princeton.EDU ([128.112.128.213]:60790 "EHLO
	ppa01.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab2DYB6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 21:58:10 -0400
Received: from csgsmtp201l.Princeton.EDU (csgsmtp201l.Princeton.EDU [128.112.134.60])
	by ppa01.Princeton.EDU (8.14.4/8.14.4) with ESMTP id q3P1w9Qr012305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 21:58:09 -0400
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com [209.85.217.174])
	(authenticated bits=0)
	by csgsmtp201l.Princeton.EDU (8.13.8/8.12.9) with ESMTP id q3P1w8uX017112
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 21:58:09 -0400
Received: by lbbgf7 with SMTP id gf7so1172967lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 18:58:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dchyan@princeton.edu
Date: Tue, 24 Apr 2012 21:58:08 -0400
Message-ID: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com> (sfid-20120425_035847_191764_5CE7484F)
Subject: iwlwifi bug
From: Daniel Chyan <dchyan@princeton.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linux Wireless,

I believe there is a bug within iwlwifi aggregation. I am on the
latest build (2012-04-23). Here is the dmesg output:

[  272.093668] ------------[ cut here ]------------
[  272.093711] WARNING: at
/home/foo/bar/compat-wireless-2012-04-23/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:493
iwl_trans_pcie_tx_agg_disable+0x101/0x110 [iwlwifi]()
[  272.093719] Hardware name: 4177CTO
[  272.093722] queue 11 not used
[  272.093725] Modules linked in: parport_pc ppdev bnep rfcomm
bluetooth snd_hda_codec_hdmi snd_hda_codec_conexant speedstep_lib
binfmt_misc i915 uvcvideo psmouse snd_hda_intel snd_hda_codec arc4
snd_hwdep snd_pcm snd_seq_midi drm_kms_helper snd_rawmidi drm videodev
v4l2_compat_ioctl32 i2c_algo_bit serio_raw snd_seq_midi_event mei(C)
iwlwifi wmi snd_seq thinkpad_acpi snd_timer snd_seq_device tpm_tis
nvram lp video parport snd mac80211 cfg80211 compat soundcore
snd_page_alloc firewire_ohci sdhci_pci sdhci firewire_core crc_itu_t
ahci libahci e1000e
[  272.093803] Pid: 252, comm: kworker/u:4 Tainted: G         C
3.0.0-17-generic #30-Ubuntu
[  272.093808] Call Trace:
[  272.093823]  [<ffffffff8105e8ff>] warn_slowpath_common+0x7f/0xc0
[  272.093831]  [<ffffffff8105e9f6>] warn_slowpath_fmt+0x46/0x50
[  272.093855]  [<ffffffffa02127c1>]
iwl_trans_pcie_tx_agg_disable+0x101/0x110 [iwlwifi]
[  272.093874]  [<ffffffffa01f37a3>] iwlagn_tx_agg_stop+0x243/0x320 [iwlwifi]
[  272.093893]  [<ffffffffa01efd9b>]
iwlagn_mac_ampdu_action+0x15b/0x330 [iwlwifi]
[  272.093902]  [<ffffffff815f0f6d>] ? wait_for_completion+0x1d/0x20
[  272.093931]  [<ffffffffa00db31b>]
___ieee80211_stop_tx_ba_session+0x12b/0x2b0 [mac80211]
[  272.093956]  [<ffffffffa00da2bf>]
ieee80211_ba_session_work+0x10f/0x180 [mac80211]
[  272.093980]  [<ffffffffa00da1b0>] ?
ieee80211_sta_tear_down_BA_sessions+0x70/0x70 [mac80211]
[  272.093988]  [<ffffffff8107c10a>] process_one_work+0x11a/0x480
[  272.093995]  [<ffffffff8107ceb5>] worker_thread+0x165/0x370
[  272.094002]  [<ffffffff8107cd50>] ? manage_workers.isra.30+0x130/0x130
[  272.094010]  [<ffffffff8108135c>] kthread+0x8c/0xa0
[  272.094019]  [<ffffffff815fc464>] kernel_thread_helper+0x4/0x10
[  272.094027]  [<ffffffff810812d0>] ? flush_kthread_worker+0xa0/0xa0
[  272.094035]  [<ffffffff815fc460>] ? gs_change+0x13/0x13
[  272.094040] ---[ end trace 64687a3e121543d5 ]---

Thanks,
Daniel
