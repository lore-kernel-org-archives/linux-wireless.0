Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbaIHW1g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 18:27:36 -0400
Date: Tue, 9 Sep 2014 00:27:33 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lkml20140418@newton.leun.net, Arik Nemtsov <arik@wizery.com>,
	linux@eikelenboom.it
Subject: Re: [PATCH 2/2] cfg80211: fix processing world regdomain when non
	modular
Message-ID: <20140908222733.GF965@wotan.suse.de> (sfid-20140909_002739_250448_EC4D3F9C)
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com> <1398137975-14275-3-git-send-email-mcgrof@do-not-panic.com> <CAGXE3d8yq_-EwacqXi2fMHC=KLU-6n=11U2wrYvpfwd++WryCg@mail.gmail.com> <20140905214331.GE17986@wotan.suse.de> <CAGXE3d9pmP9kpO2B44p-tdwy4BLZQcWgfUvcyfkjtWWaBWHsCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d9pmP9kpO2B44p-tdwy4BLZQcWgfUvcyfkjtWWaBWHsCg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2014 at 11:59:39AM +0200, Helmut Schaa wrote:
> Hi,
> 
> On Fri, Sep 5, 2014 at 11:43 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > Yeah this seems to be a corner case of the fact that we deal with
> > locking for the last request only through RCU and we only annotate
> > that the request was processed but don't add checks for when its
> > about to be processed. At least that's what I gather could be
> > the issue here given that if you see __reg_process_hint_driver()
> > we already check for two driver hints matching and and just
> > request the core to copy the existing regulatory domain onto
> > the new device.
> >
> >         if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
> >             !regdom_changes(driver_request->alpha2))
> >                 return REG_REQ_ALREADY_SET;
> >
> >         return REG_REQ_INTERSECT;
> >
> > The intersection would happen otherwise and I think this is caused
> > by a small race here. Can you try the following:
> 
> Just retried with your patch applied but I can still get an "98"
> intersected regdomain :(
> 
> [    6.190000] ath: EEPROM regdomain: 0x0
> [    6.190000] ath: EEPROM indicates default country code should be
> used
> [    6.190000] ath: doing EEPROM country->regdmn map search
> [    6.190000] ath: country maps to regdmn code: 0x3a
> [    6.190000] ath: Country alpha2 being used: US
> [    6.190000] ath: Regpair used: 0x3a
> [    6.200000] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [    6.210000] ieee80211 phy0: Atheros AR9340 Rev:0 mem=0xb8100000, irq=47
> [    6.210000] PCI: Enabling device 0000:00:00.0 (0000 -> 0002)
> [    6.210000] ath: EEPROM regdomain: 0x0
> [    6.210000] ath: EEPROM indicates default country code should be used
> [    6.210000] ath: doing EEPROM country->regdmn map search
> [    6.210000] ath: country maps to regdmn code: 0x3a
> [    6.210000] ath: Country alpha2 being used: US
> [    6.210000] ath: Regpair used: 0x3a
> [    6.220000] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
> [    6.240000] cfg80211: Calling CRDA for country: US
> [    6.240000] cfg80211: Calling CRDA for country: US
> [    6.240000] cfg80211: Current regulatory domain intersected:
> [    6.240000] cfg80211:  DFS Master region: unset
> [    6.240000] cfg80211:   (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp), (dfs_cac_time)
> [    6.240000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (2457000 KHz - 2472000 KHz @ 15000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
> (N/A, 1700 mBm), (N/A)
> [    6.240000] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz),
> (N/A, 2000 mBm), (0 s)
> [    6.240000] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
> KHz), (N/A, 0 mBm), (N/A)
> [    6.240000] cfg80211: Calling CRDA for country: US
> [    6.240000] ieee80211 phy1: Atheros AR9300 Rev:3 mem=0xb0000000, irq=40
> [    6.240000] cfg80211: Current regulatory domain intersected:
> [    6.240000] cfg80211:  DFS Master region: unset
> [    6.240000] cfg80211:   (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp), (dfs_cac_time)
> [    6.240000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (2457000 KHz - 2472000 KHz @ 15000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
> (N/A, 1700 mBm), (N/A)
> [    6.240000] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz),
> (N/A, 2000 mBm), (0 s)
> [    6.240000] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
> KHz), (N/A, 0 mBm), (N/A)
> 
> I'll try to dive deeper into the regulatory code ...

OK thanks I appreciate that, it will take me a bit to get back to this
as this week and the next few weeks will be really busy and I will
be traveling.

  Luis
