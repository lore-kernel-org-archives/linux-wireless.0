Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60899 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932538AbaEEOTz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 10:19:55 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Mon, 5 May 2014 07:19:44 -0700
Subject: RE: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59511A1FC9324@SC-VEXCH1.marvell.com> (sfid-20140505_161958_361110_5EB19FA1)
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
	 <87a9bb5c2c.fsf@purkki.adurom.net> <20140425013756.GA3410@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
	 <1398413370.4152.0.camel@jlt4.sipsolutions.net>
	 <8738gvp8md.fsf@qca.qualcomm.com>
	 <1398846593.5408.0.camel@jlt4.sipsolutions.net>
	 <20140430132246.GB3635@tuxdriver.com> <87y4ymn69s.fsf@qca.qualcomm.com>
 <1399294659.22235.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399294659.22235.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> >
> > 	int	(*get_dump_flag)(struct net_device *, struct ethtool_dump *);
> > 	int	(*get_dump_data)(struct net_device *,
> > 				 struct ethtool_dump *, void *);
> > 	int	(*set_dump)(struct net_device *, struct ethtool_dump *);
> >
> > Yeah, maybe we could use that in wireless as well.
> 
> What was the intended use case for this though?

In mwifiex, we are interested in providing separate firmware dump file to user for each memory segment. Ex. ITCM, DTCM, SQRAM etc.

It looks simpler with ethtool ops instead of creating multiple debugfs files.
 
1) User can set index for required memory segment.

#ethtool --set-dump wlan0 3

2) Get the details

#ethtool --get-dump wlan0
flag: 3, version:xyz, length:13450

3) Dump the info in ITCM.log file

#ethtool --get-dump wlan0 data ITCM.log


Common uevent through cfg80211 API to notify firmware dump is over would be useful for us.

Thanks,
Amitkumar Karwar
