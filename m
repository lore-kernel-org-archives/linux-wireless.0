Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22814 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542AbaLWLdg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 06:33:36 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 23 Dec 2014 03:32:14 -0800
Subject: RE: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A39@SC-VEXCH2.marvell.com> (sfid-20141223_123339_129608_A4DDBCE7)
References: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
	 <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com>
	 ,<5FF020A1CFFEEC49BD1E09530C4FF5951B160B81A7@SC-VEXCH1.marvell.com>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A37@SC-VEXCH2.marvell.com>
	 ,<1419330394.6091.0.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A38@SC-VEXCH2.marvell.com>
	 <1419330994.6091.2.camel@sipsolutions.net>
	 (sfid-20141223_113642_547667_1737F2DD),<1419331030.6091.3.camel@sipsolutions.net>
In-Reply-To: <1419331030.6091.3.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

How about having a flag for offchannel CAC capability and check for netdev carrier state only when this capability is supported?

Thanks,
Avinash
________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Tuesday, December 23, 2014 4:07 PM
To: Avinash Patil
Cc: janusz.dziedzic@tieto.com; linux-wireless@vger.kernel.org; Cathy Luo; Amitkumar Karwar
Subject: Re: [PATCH] cfg80211: do not check for carrier during start_radar_detect

On Tue, 2014-12-23 at 11:36 +0100, Johannes Berg wrote:
> On Tue, 2014-12-23 at 02:30 -0800, Avinash Patil wrote:
> > Oops..
> >
> > Are you talking about this?
> > >>So, at least we should move if (netif_carrier_ok(dev)) check to mac80211 otherwise we might change channel of the running interface (via vif_use_channel).
> >
> > I can move this check to ieee80211_start_radar_detection but I dont have any hardware to test these modifications.
>
> That should be ok - however maybe you don't need those modifications at
> all?
>
> Frankly I'm not even sure how off-channel CAC stuff would work but
> Janusz probably knows what he's talking about :)

Also - maybe we need some sort of capability flag for this, and then the
check doesn't have to move but just be made conditional on not having
the feature?

johannes
