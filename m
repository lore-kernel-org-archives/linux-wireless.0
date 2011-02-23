Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46378 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1BWPdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 10:33:44 -0500
Subject: Re: [PATCH 1/4] iwlwifi: Limit number of firmware reload
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20110223105720.GA11916@redhat.com>
References: <1298317536-5071-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1298317536-5071-2-git-send-email-wey-yi.w.guy@intel.com>
	 <20110223105720.GA11916@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 07:18:57 -0800
Message-ID: <1298474337.5138.33.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, 2011-02-23 at 02:57 -0800, Stanislaw Gruszka wrote:
> Hi Wey
> 
> On Mon, Feb 21, 2011 at 11:45:33AM -0800, Wey-Yi Guy wrote:
> > If device has serious problem and cause firmware can not recover itself.
> > Keep reloading firmware will not help, it can only fill up the syslog and
> > lock up the system because busy reloading.
> Filling up logs could be simply avoided by limiting number of prints.
> 
> > Introduce the limit reload counter, if the reload reach the maximum within
> > the pre-defined duration;stop the reload operation.
> We have already one mechanism for limit too frequent firmware reload,
> way not reuse it?
> 
> > +	reload_msec = jiffies_to_msecs((long) reload_jiffies -
> > +				(long) priv->reload_jiffies);
> What for are these (long) casts?
> 
> > +	/* firmware reload counter and timestamp */
> > +	unsigned long reload_jiffies;
> You do not initialize it, first reload_msec will have untrue value.
> 
I am assuming it will initialized to zero at load time, but you are
right, I still should initialize it, I will submit separated patch to
initialize it.

> Beside, all these reload firmware mechanism are just crappy workarounds
> for real firmware and/or driver bugs. Instead of creating such patches,
> Intel should fix real problems in firmware and driver in first place,
> such reloading will be not needed.
> 
I am also wish we can root cause the firmware problem and fix, but it
take time and if we logging continuous crash and it will fill the log
very fast, the side issue also cause system become un-usable because the
continuous reload. 


Wey 


