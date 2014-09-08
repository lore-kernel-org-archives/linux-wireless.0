Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:48867 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaIHJ7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 05:59:40 -0400
Received: by mail-ig0-f180.google.com with SMTP id hn18so2426312igb.7
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 02:59:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140905214331.GE17986@wotan.suse.de>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
	<1398137975-14275-3-git-send-email-mcgrof@do-not-panic.com>
	<CAGXE3d8yq_-EwacqXi2fMHC=KLU-6n=11U2wrYvpfwd++WryCg@mail.gmail.com>
	<20140905214331.GE17986@wotan.suse.de>
Date: Mon, 8 Sep 2014 11:59:39 +0200
Message-ID: <CAGXE3d9pmP9kpO2B44p-tdwy4BLZQcWgfUvcyfkjtWWaBWHsCg@mail.gmail.com> (sfid-20140908_115945_866831_B55B0492)
Subject: Re: [PATCH 2/2] cfg80211: fix processing world regdomain when non modular
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lkml20140418@newton.leun.net, Arik Nemtsov <arik@wizery.com>,
	linux@eikelenboom.it
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Sep 5, 2014 at 11:43 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> Yeah this seems to be a corner case of the fact that we deal with
> locking for the last request only through RCU and we only annotate
> that the request was processed but don't add checks for when its
> about to be processed. At least that's what I gather could be
> the issue here given that if you see __reg_process_hint_driver()
> we already check for two driver hints matching and and just
> request the core to copy the existing regulatory domain onto
> the new device.
>
>         if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
>             !regdom_changes(driver_request->alpha2))
>                 return REG_REQ_ALREADY_SET;
>
>         return REG_REQ_INTERSECT;
>
> The intersection would happen otherwise and I think this is caused
> by a small race here. Can you try the following:

Just retried with your patch applied but I can still get an "98"
intersected regdomain :(

[    6.190000] ath: EEPROM regdomain: 0x0
[    6.190000] ath: EEPROM indicates default country code should be
used
[    6.190000] ath: doing EEPROM country->regdmn map search
[    6.190000] ath: country maps to regdmn code: 0x3a
[    6.190000] ath: Country alpha2 being used: US
[    6.190000] ath: Regpair used: 0x3a
[    6.200000] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    6.210000] ieee80211 phy0: Atheros AR9340 Rev:0 mem=0xb8100000, irq=47
[    6.210000] PCI: Enabling device 0000:00:00.0 (0000 -> 0002)
[    6.210000] ath: EEPROM regdomain: 0x0
[    6.210000] ath: EEPROM indicates default country code should be used
[    6.210000] ath: doing EEPROM country->regdmn map search
[    6.210000] ath: country maps to regdmn code: 0x3a
[    6.210000] ath: Country alpha2 being used: US
[    6.210000] ath: Regpair used: 0x3a
[    6.220000] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[    6.240000] cfg80211: Calling CRDA for country: US
[    6.240000] cfg80211: Calling CRDA for country: US
[    6.240000] cfg80211: Current regulatory domain intersected:
[    6.240000] cfg80211:  DFS Master region: unset
[    6.240000] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[    6.240000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (2457000 KHz - 2472000 KHz @ 15000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
(N/A, 1700 mBm), (N/A)
[    6.240000] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (0 s)
[    6.240000] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 0 mBm), (N/A)
[    6.240000] cfg80211: Calling CRDA for country: US
[    6.240000] ieee80211 phy1: Atheros AR9300 Rev:3 mem=0xb0000000, irq=40
[    6.240000] cfg80211: Current regulatory domain intersected:
[    6.240000] cfg80211:  DFS Master region: unset
[    6.240000] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[    6.240000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (2457000 KHz - 2472000 KHz @ 15000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
(N/A, 1700 mBm), (N/A)
[    6.240000] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (0 s)
[    6.240000] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 0 mBm), (N/A)

I'll try to dive deeper into the regulatory code ...
Helmut
