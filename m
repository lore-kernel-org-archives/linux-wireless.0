Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17571 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbaEEPtX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 11:49:23 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
	Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 5 May 2014 08:49:08 -0700
Subject: RE: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59511A1FC9327@SC-VEXCH1.marvell.com> (sfid-20140505_174950_993698_CB359D60)
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
	 <87a9bb5c2c.fsf@purkki.adurom.net> <20140425013756.GA3410@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
	 <1398413370.4152.0.camel@jlt4.sipsolutions.net>
	 <8738gvp8md.fsf@qca.qualcomm.com>
	 <1398846593.5408.0.camel@jlt4.sipsolutions.net>
	 <20140430132246.GB3635@tuxdriver.com> <87y4ymn69s.fsf@qca.qualcomm.com>
	 <1399294659.22235.9.camel@jlt4.sipsolutions.net>
	 <5FF020A1CFFEEC49BD1E09530C4FF59511A1FC9324@SC-VEXCH1.marvell.com>
 <1399302291.22235.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399302291.22235.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > 3) Dump the info in ITCM.log file
> >
> > #ethtool --get-dump wlan0 data ITCM.log
> 
> This works, though I'd be worried about getting a consistent snapshot,
> no?

Actually we don't need consistent snapshots for firmware dump in mwifiex. 
When command/Tx data timeout occurs, one time firmware memory dump (total ~1.1Mb) is sufficient for debugging. 

> 
> > Common uevent through cfg80211 API to notify firmware dump is over would
> be useful for us.
> 
> That makes some sense.
> 
> 
> The way our code works is that it stores all the desired data on an
> error, triggers the event & restart, and then you can request the data
> later.
> 
> I'm not sure ethtool dump is appropriate for that - it seems to be more
> used for "get a dump right now during operation" type scenarios?
 
We are planning to use ethtool to selectively get required info when common cfg80211 API notifies that firmware dump is over. If the operation is 
in progress, we can return 0 to ethtool.

Thanks,
Amit
