Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:58280 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756359Ab2JJOBQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 10:01:16 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Johannes Berg' <johannes@sipsolutions.net>,
	Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 10 Oct 2012 06:56:50 -0700
Subject: RE: [PATCH v3 0/5] add scan flags support
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59506A25A0CDE@SC-VEXCH1.marvell.com> (sfid-20121010_160120_411495_C9D79668)
In-Reply-To: <1349857087.4683.32.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> 
> I think this is good, but needs the userspace advertisement.
> 
> We can either advertise the scan flags word to userspace and set the
> supported flags, but then I'm not sure how to handle scheduled vs.
> regular scan. Alternatively we could use nl80211 feature flags (instead
> of wiphy flags) which get advertised directly... I'm not really sure
> what's better.

Ok. We will make use of nl80211 feature flags in updated version so that these capabilities will be advertised to userspace as well.

> 
> What would be the behaviour of flush in a scheduled scan?

As per our understanding, scheduled scan is triggered from application. Driver/hardware will keep on scanning the network periodically using specified time interval and provide scan results to cfg80211.

We have added code (v3 patch 4/5) to flush older scan entries whenever new results are available. scan_start time is used for this. Everytime it's getting modified to "jiffies + interval" for future use.

Please let's know your comments.

Thanks,
Amitkumar Karwar

