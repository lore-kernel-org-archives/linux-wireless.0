Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0DHHOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 03:14:32 -0400
Subject: Re: [PATCH] mac80211: fix paged RX crypto
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1270707285.3977.5.camel@jlt3.sipsolutions.net>
References: <1270632416.3858.6.camel@jlt3.sipsolutions.net>
	 <1270696951.10745.11.camel@debian>  <1270697769.10745.12.camel@debian>
	 <1270707285.3977.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 15:14:56 +0800
Message-ID: <1270710896.10745.15.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 14:14 +0800, Johannes Berg wrote:
> On Thu, 2010-04-08 at 11:36 +0800, Zhu Yi wrote:
> 
> > > I thought it over. We don't need to handle nonlinear skb in
> > > ieee80211_get_mmie_keyidx(), because we only need to touch fields out of
> > > 802.11 header for management frames, and we have already skb_linearize
> > > all management frames before. 
> 
> Good point, forgot about that.
> 
> > > Now we just need to handle WEP IV
> > > correctly. How about this patch?
> 
> Yeah, seems like it should work, did you test with WEP?

Yes, it works for me. Since john has already merged yours, I'll send a
incremental one.

Thanks,
-yi

