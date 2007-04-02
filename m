Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:49611 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965654AbXDBSXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 14:23:08 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HYR9B-00021s-9d
	for linux-wireless@vger.kernel.org; Mon, 02 Apr 2007 14:20:53 -0400
Subject: Re: cfg80211 wext compat w/o wext code changes, rtnl locking
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <1175537741.16379.1.camel@johannes.berg>
References: <1175122815.8807.21.camel@johannes.berg>
	 <200703301211.05261.mb@bu3sch.de>  <1175251051.19085.2.camel@johannes.berg>
	 <1175536859.25048.6.camel@dv>  <1175537741.16379.1.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:23:05 -0400
Message-Id: <1175538185.25048.10.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-04-02 at 20:15 +0200, Johannes Berg wrote:
> On Mon, 2007-04-02 at 14:00 -0400, Pavel Roskin wrote:
> 
> > Just for your information, rtnl_lock() is actually a mutex. Neither
> > rtnl_lock() nor any mutex operation are annotated to give sparse any
> > idea of what they are doing.
> 
> Oh. And I guess rtnl_lock/unlock would need to be annotated and not just
> the mutex operations (or are they inlines? I forgot)

They are not inlines.  Either way, sparse would require annotating them
if mutexes are to be tracked the way it's done for spinlocks.

-- 
Regards,
Pavel Roskin

