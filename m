Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab1BYPt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 10:49:26 -0500
Subject: Re: [PATCH 2/2] iwlagn: fix iwlagn_check_needed_chains
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Swati Rallapalli <swati@cs.utexas.edu>
In-Reply-To: <1298647873.28351.10.camel@wwguy-huron>
References: <20110225112409.977212647@sipsolutions.net>
	 <20110225112620.515442527@sipsolutions.net>
	 <1298648166.2603.11.camel@wwguy-ubuntu>
	 <1298648386.4329.18.camel@jlt3.sipsolutions.net>
	 <1298647873.28351.10.camel@wwguy-huron>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 16:49:21 +0100
Message-ID: <1298648961.4329.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 07:31 -0800, Guy, Wey-Yi wrote:
> On Fri, 2011-02-25 at 07:39 -0800, Johannes Berg wrote:
> > On Fri, 2011-02-25 at 07:36 -0800, wwguy wrote:
> > 
> > > > @@ -503,7 +488,46 @@ static void iwlagn_check_needed_chains(s
> > > >  			 * will soon tell us about that.
> > > >  			 */
> > > >  			need_multiple = false;
> > > > +			rcu_read_unlock();
> > > > +			break;
> > > 
> > > why unlock and break here instead stay do it later like before?
> > 
> > Only because the indentation there was getting so deep it was annoying
> > to fit into 80 cols :-)
> 
> how you want to submit this patch? through iwlagn, or yo uwill send it
> along with mac80211 to John?

Don't really care. I just sent them both here to keep them together and
for Daniel and Swati ... First though, I'd like them to test it maybe.

johannes

