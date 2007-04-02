Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:54584 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965606AbXDBSBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 14:01:05 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HYQnq-0001Vz-BC
	for linux-wireless@vger.kernel.org; Mon, 02 Apr 2007 13:58:50 -0400
Subject: Re: cfg80211 wext compat w/o wext code changes, rtnl locking
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <1175251051.19085.2.camel@johannes.berg>
References: <1175122815.8807.21.camel@johannes.berg>
	 <200703301211.05261.mb@bu3sch.de>  <1175251051.19085.2.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:00:59 -0400
Message-Id: <1175536859.25048.6.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-03-30 at 12:37 +0200, Johannes Berg wrote:
> On Fri, 2007-03-30 at 12:11 +0200, Michael Buesch wrote:
> > On Thursday 29 March 2007 01:00, Johannes Berg wrote:
> > > -			if(handler != NULL) {
> > > +			if (handler) {
> > > +				if (!dev->wireless_handlers->no_locking)
> > > +					rtnl_lock();
> > 
> > Is sparse OK with this conditional locking?
> 
> I also thought it wasn't but it didn't complain. The only reason why I
> didn't just duplicate the code was the deep indentation here...

Just for your information, rtnl_lock() is actually a mutex.  Neither
rtnl_lock() nor any mutex operation are annotated to give sparse any
idea of what they are doing.

If sparse learns about mutexes, expect it to give a warning.  Please
consider if the code between rtnl_lock() and rtnl_unlock() could be
moved to a separate function so that locking and unlocking would happen
in the same basic block.

-- 
Regards,
Pavel Roskin

