Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200Ab1IIOXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 10:23:11 -0400
Subject: Re: [FYI] iwlagn: fix command queue timeout
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <1315570879.17050.11.camel@jlt3.sipsolutions.net>
References: <1315570496.17050.7.camel@jlt3.sipsolutions.net>
	 (sfid-20110909_141507_339473_273626F4) <1315570755.17050.9.camel@jlt3.sipsolutions.net>
	 (sfid-20110909_141921_054876_98578A48)  <1315570879.17050.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 07:18:01 -0700
Message-ID: <1315577881.19667.16.camel@wwguy-ubuntu> (sfid-20110909_162314_285287_5CBEC2DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-09 at 05:21 -0700, Johannes Berg wrote:
> On Fri, 2011-09-09 at 14:19 +0200, Johannes Berg wrote:
> 
> > Fix this by setting the timestamp when
> > a command completes.
> 
> FWIW, I don't think this is a really good fix, I think it should have a
> timer per queue that never fires, and when it fires the queue is stuck
> -- i.e. mod the timer into the future whenever a command/tx frame
> completes and cancel the timer when the queue goes empty (and start it
> if it's pending when we enqueue something)
> 
Agree, we need better fix, I saw this happen number of times on my
system which does not have P2P and no traffic. One time even just
loading the iwlagn module; not sure it is the same case.

Thanks
Wey
> 


