Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47434 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0CHJGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 04:06:10 -0500
Subject: Re: [PATCH] libipw: split ieee->networks into small pieces
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268035309.3819.14.camel@jlt3.sipsolutions.net>
References: <1268025483-9267-1-git-send-email-yi.zhu@intel.com>
	 <1268035309.3819.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 17:07:11 +0800
Message-ID: <1268039231.2774.93.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-08 at 16:01 +0800, Johannes Berg wrote:
> On Mon, 2010-03-08 at 13:18 +0800, Zhu Yi wrote:
> > The ieee->networks consists of 128 struct libipw_network entries. If
> > we allocate this chunk of memory altogether, it ends up with an
> > order 4 page allocation. High order page allocation is likely to
> fail
> > on system high load. This patch splits the big chunk memory
> allocation
> > into small pieces, each is 344 bytes, allocates them with 128 times.
> > 
> > The patch fixed bug http://bugzilla.kernel.org/show_bug.cgi?id=14989
> 
> Could it use cfg80211's scan list stuff and the wext handlers for
> scanning there? 

Probably yes. It all depends on how we organize the network list
internally. The ipw firmware sends raw management frames (assoc, beacon,
etc) to driver directly. So We can use cfg80211_bss to track beacons.
But it can require some effort since libipw_network is used throughout
libipw.

Thanks,
-yi

