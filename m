Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1BYPjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 10:39:53 -0500
Subject: Re: [PATCH 2/2] iwlagn: fix iwlagn_check_needed_chains
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Swati Rallapalli <swati@cs.utexas.edu>
In-Reply-To: <1298648166.2603.11.camel@wwguy-ubuntu>
References: <20110225112409.977212647@sipsolutions.net>
	 <20110225112620.515442527@sipsolutions.net>
	 <1298648166.2603.11.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 16:39:46 +0100
Message-ID: <1298648386.4329.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 07:36 -0800, wwguy wrote:

> > @@ -503,7 +488,46 @@ static void iwlagn_check_needed_chains(s
> >  			 * will soon tell us about that.
> >  			 */
> >  			need_multiple = false;
> > +			rcu_read_unlock();
> > +			break;
> 
> why unlock and break here instead stay do it later like before?

Only because the indentation there was getting so deep it was annoying
to fit into 80 cols :-)

johannes

