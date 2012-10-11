Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2JKMOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 08:14:03 -0400
Message-ID: <1349957673.13097.6.camel@jlt4.sipsolutions.net> (sfid-20121011_141408_300475_0B784A1A)
Subject: Re: [PATCH v3 0/5] add scan flags support
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 11 Oct 2012 14:14:33 +0200
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF59506A25A0CDE@SC-VEXCH1.marvell.com>
References: <5FF020A1CFFEEC49BD1E09530C4FF59506A25A0CDE@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > What would be the behaviour of flush in a scheduled scan?
> 
> As per our understanding, scheduled scan is triggered from
> application. Driver/hardware will keep on scanning the network
> periodically using specified time interval and provide scan results to
> cfg80211.

Right.

> We have added code (v3 patch 4/5) to flush older scan entries whenever
> new results are available. scan_start time is used for this. Everytime
> it's getting modified to "jiffies + interval" for future use.

Ah. But that's in the wrong units (jiffies vs. ms).

johannes

