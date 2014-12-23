Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38027 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaLWKhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 05:37:18 -0500
Message-ID: <1419331030.6091.3.camel@sipsolutions.net> (sfid-20141223_113722_691556_00EFDA27)
Subject: Re: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: "janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 23 Dec 2014 11:37:10 +0100
In-Reply-To: <1419330994.6091.2.camel@sipsolutions.net> (sfid-20141223_113642_547667_1737F2DD)
References: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
	 <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com>
	 ,<5FF020A1CFFEEC49BD1E09530C4FF5951B160B81A7@SC-VEXCH1.marvell.com>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A37@SC-VEXCH2.marvell.com>
	 ,<1419330394.6091.0.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A38@SC-VEXCH2.marvell.com>
	 <1419330994.6091.2.camel@sipsolutions.net>
	 (sfid-20141223_113642_547667_1737F2DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

