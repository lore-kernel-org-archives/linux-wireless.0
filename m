Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35481 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbLKS7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 13:59:37 -0500
Received: by qkfb125 with SMTP id b125so52417165qkf.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 10:59:36 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 11 Dec 2015 10:59:17 -0800
Message-ID: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com> (sfid-20151211_195941_590902_53A49FE8)
Subject: iwlwifi - L1 Enabled - LTR Enabled loop
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using 4.4-rc4 and today's wireless-testing (master-2015-12-10), and
the latest firmware on linux-firmware, my wireless driver runs into a
non-functional loop rambling about "L1 Enabled - LTR Enabled loop".
Reverting back to an older kernel works. I could bisect *if this issue
is not known*, but it may take a while... If you are already
suspicious of a commit lemme know, and I can try to revert. Otherwise
if there's a firmware version that is supposed to work I'm happy to
try that.

Device: Intel dual band wireless AC 7260, REV=0x144
Firmware version: 16.242414.0 (linux-firmware upstream)

I also tried:

Firmware version: 17.246894.0 op_mode iwlmvm (latest on
iwlwifi/linux-firmware.git)

I run into the same issue with this version as well though.

The log:

[   18.914370] cfg80211: World regulatory domain updated:
[   18.915114] cfg80211:  DFS Master region: unset
[   18.915127] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   18.916599] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[   18.917351] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[   18.918082] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(N/A, 2000 mBm), (N/A)
[   18.918805] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[   18.919530] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[   18.920247] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz),
(N/A, 2000 mBm), (0 s)
[   18.920965] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[   18.921692] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 0 mBm), (N/A)
[   19.059414] Intel(R) Wireless WiFi driver for Linux
[   19.060123] Copyright(c) 2003- 2015 Intel Corporation
[   19.061091] iwlwifi 0000:03:00.0: Direct firmware load for
iwlwifi-7260-19.ucode failed with error -2
[   19.061792] iwlwifi 0000:03:00.0: Direct firmware load for
iwlwifi-7260-18.ucode failed with error -2
[   19.062414] iwlwifi 0000:03:00.0: Direct firmware load for
iwlwifi-7260-17.ucode failed with error -2
[   19.590098] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b39a)
[   19.673094] iwlwifi 0000:03:00.0: loaded firmware version
16.242414.0 op_mode iwlmvm
[   22.439870] iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band
Wireless AC 7260, REV=0x144
[   22.440809] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[   22.442616] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[   22.645773] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[   22.737314] iwlwifi 0000:03:00.0 wlp3s0: renamed from wlan0
[   33.288237] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[   33.288489] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[   33.477404] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled

[ etc ]

[  100.421430] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[  100.421686] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[  100.604345] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[  100.604633] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled

[ it goes on forever ]

  Luis
