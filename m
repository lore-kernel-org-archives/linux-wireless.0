Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57914 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2IZIID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 04:08:03 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20578.47013.636428.710724@gargle.gargle.HOWL> (sfid-20120926_100811_977344_ACDBCB20)
Date: Wed, 26 Sep 2012 13:37:01 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <c_manoha@qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Notify new IBSS network creation
In-Reply-To: <1348645070.10548.5.camel@jlt4.sipsolutions.net>
References: <20578.31128.207010.660580@gargle.gargle.HOWL>
	<1348643666.10548.2.camel@jlt4.sipsolutions.net>
	<20578.44784.141822.850065@gargle.gargle.HOWL>
	<1348645070.10548.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> That looks a bit different from what I thought though? Not really sure I
> understand that though :-)

The basic issue was that we were not initializing the timers based on
the sync'd TSF.

> What I'm thinking is that if you always just start beaconing, wouldn't
> you just reset the beacon whenever you notice a higher TSF show up in
> the network?
> 
> Actually I think we call reset_tsf() or something like that? But all of
> that has always seemed very quirky to me.

Currently, I don't think we reset the beacon/timers for IBSS mode.

For station mode, all of this is handled in ath9k using the 
PS_WAIT_FOR_BEACON/PS_BEACON_SYNC flags. For IBSS creator mode, there is
no problem because mac80211 calls reset_tsf() in __ieee80211_sta_join_ibss().
For joiner mode, drivers like ath9k need to do a beacon-sync (like station),
before starting to pollute the environment with beacons, but there is no way to know
if an existing IBSS network is being joined.

Sujith
