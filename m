Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60951 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIXRph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 13:45:37 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 031A8409E87
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 10:45:36 -0700 (PDT)
Message-ID: <54230340.8090604@candelatech.com> (sfid-20140924_194540_684579_52868058)
Date: Wed, 24 Sep 2014 10:45:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: What does it take to enable channel 100?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My system should be doing DFS properly, but channel 100 (5500 Mhz) and nearby are still not
enabled.  What extra do I need to do?

I have some hacks to enable DFS-FCC, which fixes at least some of the DFS
problems in upstream kernels, and regulatory.bin is only a few months old.

[root@ath10k-2220 wifi]# iw reg get
country US: DFS-FCC
	(2402 - 2472 @ 40), (N/A, 30)
	(5170 - 5250 @ 80), (N/A, 17)
	(5250 - 5330 @ 80), (N/A, 23), DFS
	(5735 - 5835 @ 80), (N/A, 30)
	(57240 - 63720 @ 2160), (N/A, 40)

Sep 24 09:19:35 localhost kernel: cfg80211: set-regdom, lr->initiator: 0 domain: 00
Sep 24 09:19:35 localhost kernel: cfg80211: Regulatory domain (set-regdom): 00  DFS: unset
Sep 24 09:19:35 localhost kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Sep 24 09:19:35 localhost kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211: Done with reg domain
Sep 24 09:19:35 localhost kernel:
Sep 24 09:19:35 localhost kernel: cfg80211: World regulatory domain updated:
Sep 24 09:19:35 localhost kernel: cfg80211:  DFS Master region: unset
Sep 24 09:19:35 localhost kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Sep 24 09:19:35 localhost kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Sep 24 09:19:35 localhost kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Sep 24 09:19:35 localhost kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)

....

Sep 24 09:19:36 localhost kernel: cfg80211: Calling CRDA for country: US
Sep 24 09:19:36 localhost kernel: cfg80211: set-regdom, lr->initiator: 2 domain: US
Sep 24 09:19:36 localhost kernel: cfg80211: Forcing US to DFS-FCC (was: unset).
Sep 24 09:19:36 localhost kernel: cfg80211: Regulatory domain (set-regdom): US  DFS: FCC
Sep 24 09:19:36 localhost kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Sep 24 09:19:36 localhost kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
Sep 24 09:19:36 localhost kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm), (N/A)
Sep 24 09:19:36 localhost kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2300 mBm), (0 s)
Sep 24 09:19:36 localhost kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)
Sep 24 09:19:36 localhost kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
Sep 24 09:19:36 localhost kernel: cfg80211: Done with reg domain
Sep 24 09:19:36 localhost kernel:
Sep 24 09:19:36 localhost kernel: cfg80211: set-rd-driver, no intersect requested.
Sep 24 09:19:36 localhost kernel: cfg80211: Setting DFS Master region in update_regulatory, was: unset, new: FCC  lr: ffff880037913000  regdom: ffff8800c72a6300
Sep 24 09:19:36 localhost kernel: cfg80211: Regulatory domain changed to country: US
Sep 24 09:19:36 localhost kernel: cfg80211:  DFS Master region: FCC
Sep 24 09:19:36 localhost kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Sep 24 09:19:36 localhost kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
Sep 24 09:19:36 localhost kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm), (N/A)
Sep 24 09:19:36 localhost kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2300 mBm), (0 s)
Sep 24 09:19:36 localhost kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)
Sep 24 09:19:36 localhost kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
Sep 24 09:19:37 localhost kernel: cfg80211: Setting DFS Master region in update_regulatory, was: FCC, new: FCC  lr: ffff880037913000  regdom: ffff8800c72a6300
Sep 24 09:19:37 localhost kernel: cfg80211: Setting DFS Master region in update_regulatory, was: unset, new: FCC  lr: ffff8802208ba280  regdom: ffff8800c72a6300


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

