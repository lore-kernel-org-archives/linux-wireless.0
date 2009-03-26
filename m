Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbZCZTdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 15:33:43 -0400
Subject: Re: iwl3945: Don't queue rfkill_poll work when module is exiting
From: reinette chatre <reinette.chatre@intel.com>
To: TJ <ubuntu@tjworld.net>
Cc: Huaxu Wan <huaxu.wan@linux.intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1237955476.4388.6.camel@hephaestion>
References: <1237909459.5365.16.camel@hephaestion>
	 <200903241851.11949.helmut.schaa@gmail.com>
	 <1237929739.5365.21.camel@hephaestion>  <20090325034121.GA4792@owl>
	 <1237955476.4388.6.camel@hephaestion>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 12:39:03 -0700
Message-Id: <1238096343.25000.57.camel@rc-desk> (sfid-20090326_203346_102601_969B30F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-03-24 at 21:31 -0700, TJ wrote:
> On Wed, 2009-03-25 at 11:41 +0800, Huaxu Wan wrote:
> > Hi,
> > 
> > This issue is confirmed here too. But during compile, there is warning about
> > cancel_work_sync(), cancel_delayed_work_sync() should be used instead.
> > 
> > And, without the modification in iwl3945_rfkill_poll() and 
> > iwl3945_mac_stop(), just with one line cancel_delayed_work_sync(), this issue
> > is also fixed in my testing.
> 
> Originally I did try adding just cancel_delayed_work_sync() although I
> put it immediately following:
> 
>         iwl3945_rfkill_unregister(priv);
>         cancel_delayed_work(&priv->rfkill_poll);
> 
> Wondered why that didn't work and hunted down the unnecessary calls to
> queue_delayed_work() that were causing the issue and made them
> conditional on STATUS_EXIT_PENDING.
> 
> Then I decided to be absolutely sure and moved cancel_delayed_work()
> further down and for some reason mis-used cancel_work_sync() instead of
> cancel_delayed_work_sync() - not paying attention I guess!

Sounds like this can be done in one line ... could you please resubmit?

Thanks

Reinette

