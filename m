Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36482 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbbKLWTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 17:19:54 -0500
Received: by obdgf3 with SMTP id gf3so59552610obd.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 14:19:52 -0800 (PST)
Received: from linux.site (cpe-24-31-249-175.kc.res.rr.com. [24.31.249.175])
        by smtp.gmail.com with ESMTPSA id ta5sm4898015obc.13.2015.11.12.14.19.50
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2015 14:19:50 -0800 (PST)
To: linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: DFS Master Region
Message-ID: <56451085.2070301@lwfinger.net> (sfid-20151112_232002_047292_DD525C8E)
Date: Thu, 12 Nov 2015 16:19:49 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to understand a problem that some users are having with the 5G band 
when using rtl8821ae. One of them sees the following output from cfg80211:

cfg80211: World regulatory domain updated:
cfg80211:  DFS Master region: unset
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), 
(dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 
mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 
mBm), (0 s)
cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
cfg80211: Regulatory domain changed to country: CA
cfg80211:  DFS Master region: FCC
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), 
(dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 1700 
mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2400 
mBm), (0 s)
cfg80211:   (5490000 KHz - 5600000 KHz @ 80000 KHz), (N/A, 2400 mBm), (0 s)
cfg80211:   (5650000 KHz - 5730000 KHz @ 80000 KHz), (N/A, 2400 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)
cfg80211: Regulatory domain changed to country: CA
cfg80211:  DFS Master region: FCC
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), 
(dfs_cac_time)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 1700 
mBm), (N/A)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2400 
mBm), (0 s)
cfg80211:   (5490000 KHz - 5600000 KHz @ 80000 KHz), (N/A, 2400 mBm), (0 s)
cfg80211:   (5650000 KHz - 5730000 KHz @ 80000 KHz), (N/A, 2400 mBm), (0 s)
cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)

The change from the "world regulatory domain" to CA should not cause any 
problems. I do not understand why it switches to CA a second time, but I'm 
confused as to why the "DFS Master Region" for CA is "FCC". On my system, when I 
load cfg80211 using the option to set the regulatory domain to CA, my master 
region is still unset.

Is this the source of the problem? On the above system, all 5G channels are 
disabled. On my system, I get the expected passive scanning on channels 52-140, 
but all 5G channels are enabled.

One other possible difference. My openSUSE system uses CRDA 1.1.3. The other box 
runs Fedora 23 with an unknown version of CRDA.

Thanks,

Larry
