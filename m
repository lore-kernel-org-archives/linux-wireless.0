Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380Ab0DHHQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 03:16:18 -0400
Subject: Re: [PATCH] mac80211: fix paged RX crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1270710896.10745.15.camel@debian>
References: <1270632416.3858.6.camel@jlt3.sipsolutions.net>
	 <1270696951.10745.11.camel@debian>  <1270697769.10745.12.camel@debian>
	 <1270707285.3977.5.camel@jlt3.sipsolutions.net>
	 <1270710896.10745.15.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 09:16:13 +0200
Message-ID: <1270710973.3977.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 15:14 +0800, Zhu Yi wrote:
> On Thu, 2010-04-08 at 14:14 +0800, Johannes Berg wrote:
> > On Thu, 2010-04-08 at 11:36 +0800, Zhu Yi wrote:
> > 
> > > > I thought it over. We don't need to handle nonlinear skb in
> > > > ieee80211_get_mmie_keyidx(), because we only need to touch fields out of
> > > > 802.11 header for management frames, and we have already skb_linearize
> > > > all management frames before. 
> > 
> > Good point, forgot about that.
> > 
> > > > Now we just need to handle WEP IV
> > > > correctly. How about this patch?
> > 
> > Yeah, seems like it should work, did you test with WEP?
> 
> Yes, it works for me. Since john has already merged yours, I'll send a
> incremental one.

Great. Yeah I noticed that too later, thanks.

johannes

