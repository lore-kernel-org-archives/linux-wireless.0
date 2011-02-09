Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1BIRHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 12:07:01 -0500
Subject: Re: [PATCH 5/5] iwlwifi: avoid too frequent recover from statistics
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110209062815.GC2184@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
	 <1297153919-18766-5-git-send-email-sgruszka@redhat.com>
	 <1297179953.20613.38.camel@wwguy-ubuntu> <20110209062815.GC2184@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 09:05:15 -0800
Message-ID: <1297271115.20613.64.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 22:28 -0800, Stanislaw Gruszka wrote:
> On Tue, Feb 08, 2011 at 07:45:53AM -0800, wwguy wrote:
> > > -	priv->plcp_jiffies = stamp;
> > > -
> > > -	if (msecs == 0)
> > > -		return true;
> > > +	BUG_ON(msecs == 0);
> > 
> > why not just return? I understand it should not be "0", but really need
> > BUG_ON?
> >  
> > >  
> > > -	stamp = jiffies;
> > > -	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
> > > -	priv->plcp_jiffies = stamp;
> > > -
> > > -	if (msecs == 0)
> > > -		return true;
> > > +	BUG_ON(msecs == 0);
> > Same above
> > 
> > 
> > Similar question, we are very close to finish driver split, when is the
> > best time for this patch?
> 
> The same aswer :-) I will respin, when your patches will land in John tree.
> 
Thank you

Wey


