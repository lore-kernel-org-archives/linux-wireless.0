Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbaEEPFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 11:05:11 -0400
Message-ID: <1399302291.22235.22.camel@jlt4.sipsolutions.net> (sfid-20140505_170521_233933_CF060714)
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
	Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 05 May 2014 17:04:51 +0200
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF59511A1FC9324@SC-VEXCH1.marvell.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-05 at 07:19 -0700, Amitkumar Karwar wrote:

> In mwifiex, we are interested in providing separate firmware dump file to user for each memory segment. Ex. ITCM, DTCM, SQRAM etc.

We have multiple things as well, firmware memory, last driver
commands, ...

> It looks simpler with ethtool ops instead of creating multiple debugfs files.

What we decided to do is encode the file with an IE-like structure so we
can extend the format in the future.
 
> 1) User can set index for required memory segment.
> 
> #ethtool --set-dump wlan0 3
> 
> 2) Get the details
> 
> #ethtool --get-dump wlan0
> flag: 3, version:xyz, length:13450
> 
> 3) Dump the info in ITCM.log file
> 
> #ethtool --get-dump wlan0 data ITCM.log

This works, though I'd be worried about getting a consistent snapshot,
no?

> Common uevent through cfg80211 API to notify firmware dump is over would be useful for us.

That makes some sense.


The way our code works is that it stores all the desired data on an
error, triggers the event & restart, and then you can request the data
later.

I'm not sure ethtool dump is appropriate for that - it seems to be more
used for "get a dump right now during operation" type scenarios?

johannes

