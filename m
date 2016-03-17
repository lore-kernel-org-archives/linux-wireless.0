Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33438 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614AbcCQNVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:21:12 -0400
Date: Thu, 17 Mar 2016 06:21:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eva Rachel Retuya <eraretuya@gmail.com>,
	outreachy-kernel@googlegroups.com, emmanuel.grumbach@intel.com,
	linuxwifi@intel.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: dvm: convert create_singlethread_workqueue() to
 alloc_workqueue()
Message-ID: <20160317132110.GP21104@mtj.duckdns.org> (sfid-20160317_142117_625130_27CC45AE)
References: <1458218246-18807-1-git-send-email-eraretuya@gmail.com>
 <1458218602.2158.17.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1458218602.2158.17.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Thu, Mar 17, 2016 at 01:43:22PM +0100, Johannes Berg wrote:
> On Thu, 2016-03-17 at 20:37 +0800, Eva Rachel Retuya wrote:
> > Use alloc_workqueue() to allocate the workqueue instead of
> > create_singlethread_workqueue() since the latter is deprecated and is
> > scheduled for removal.
> 
> Scheduled where?

They've been deprecated for years now.  I should note that in the
header.

> >  static void iwl_setup_deferred_work(struct iwl_priv *priv)
> >  {
> > -	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
> > +	priv->workqueue = alloc_workqueue(DRV_NAME, WQ_HIGHPRI |
> > WQ_UNBOUND |
> > +					  WQ_MEM_RECLAIM, 1);
> 
> Seems like you should use alloc_ordered_workqueue() though? That also
> gets you UNBOUND immediately, and the "1".

Right, this one should have been alloc_ordered_workqueue().

> I'm not really sure HIGHPRI is needed either.

So, no WQ_MEM_RECLAIM either then, I suppose?  What are the latency
requirements here - what happens if a thermal management work gets
delayed?

Thanks.

-- 
tejun
