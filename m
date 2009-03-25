Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tjworld.net ([67.18.187.6]:59717 "EHLO tjworld.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753260AbZCYEbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 00:31:22 -0400
Subject: Re: iwl3945: Don't queue rfkill_poll work when module is exiting
From: TJ <ubuntu@tjworld.net>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090325034121.GA4792@owl>
References: <1237909459.5365.16.camel@hephaestion>
	 <200903241851.11949.helmut.schaa@gmail.com>
	 <1237929739.5365.21.camel@hephaestion>  <20090325034121.GA4792@owl>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 04:31:16 +0000
Message-Id: <1237955476.4388.6.camel@hephaestion> (sfid-20090325_053125_508113_E371F697)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-25 at 11:41 +0800, Huaxu Wan wrote:
> Hi,
> 
> This issue is confirmed here too. But during compile, there is warning about
> cancel_work_sync(), cancel_delayed_work_sync() should be used instead.
> 
> And, without the modification in iwl3945_rfkill_poll() and 
> iwl3945_mac_stop(), just with one line cancel_delayed_work_sync(), this issue
> is also fixed in my testing.

Originally I did try adding just cancel_delayed_work_sync() although I
put it immediately following:

        iwl3945_rfkill_unregister(priv);
        cancel_delayed_work(&priv->rfkill_poll);

Wondered why that didn't work and hunted down the unnecessary calls to
queue_delayed_work() that were causing the issue and made them
conditional on STATUS_EXIT_PENDING.

Then I decided to be absolutely sure and moved cancel_delayed_work()
further down and for some reason mis-used cancel_work_sync() instead of
cancel_delayed_work_sync() - not paying attention I guess!



