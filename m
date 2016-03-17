Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983AbcCQNsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:48:43 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Eva Rachel Retuya <eraretuya@gmail.com>,
	"outreachy-kernel@googlegroups.com"
	<outreachy-kernel@googlegroups.com>,
	linuxwifi <linuxwifi@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: dvm: convert create_singlethread_workqueue()
 to alloc_workqueue()
Date: Thu, 17 Mar 2016 13:48:36 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA7CBB1@hasmsx107.ger.corp.intel.com> (sfid-20160317_144908_323410_7DE7A48F)
References: <1458218246-18807-1-git-send-email-eraretuya@gmail.com>
 <1458218602.2158.17.camel@sipsolutions.net>
 <20160317132110.GP21104@mtj.duckdns.org>
In-Reply-To: <20160317132110.GP21104@mtj.duckdns.org>
Content-Type: text/plain; charset="windows-1255"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hello,
> 
> On Thu, Mar 17, 2016 at 01:43:22PM +0100, Johannes Berg wrote:
> > On Thu, 2016-03-17 at 20:37 +0800, Eva Rachel Retuya wrote:
> > > Use alloc_workqueue() to allocate the workqueue instead of
> > > create_singlethread_workqueue() since the latter is deprecated and
> > > is scheduled for removal.
> >
> > Scheduled where?
> 
> They've been deprecated for years now.  I should note that in the header.
> 
> > >  static void iwl_setup_deferred_work(struct iwl_priv *priv)
> > >  {
> > > -	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
> > > +	priv->workqueue = alloc_workqueue(DRV_NAME, WQ_HIGHPRI |
> > > WQ_UNBOUND |
> > > +					  WQ_MEM_RECLAIM, 1);
> >
> > Seems like you should use alloc_ordered_workqueue() though? That also
> > gets you UNBOUND immediately, and the "1".
> 
> Right, this one should have been alloc_ordered_workqueue().
> 
> > I'm not really sure HIGHPRI is needed either.
> 
> So, no WQ_MEM_RECLAIM either then, I suppose?  What are the latency
> requirements here - what happens if a thermal management work gets
> delayed?
> 

This worker is not supposed to free memory, so no WQ_MEM_RECLAIM needed. The latency is not critical.

