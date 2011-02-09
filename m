Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1BIG2O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 01:28:14 -0500
Date: Wed, 9 Feb 2011 07:28:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] iwlwifi: avoid too frequent recover from statistics
Message-ID: <20110209062815.GC2184@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
 <1297153919-18766-5-git-send-email-sgruszka@redhat.com>
 <1297179953.20613.38.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297179953.20613.38.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 08, 2011 at 07:45:53AM -0800, wwguy wrote:
> > -	priv->plcp_jiffies = stamp;
> > -
> > -	if (msecs == 0)
> > -		return true;
> > +	BUG_ON(msecs == 0);
> 
> why not just return? I understand it should not be "0", but really need
> BUG_ON?
>  
> >  
> > -	stamp = jiffies;
> > -	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
> > -	priv->plcp_jiffies = stamp;
> > -
> > -	if (msecs == 0)
> > -		return true;
> > +	BUG_ON(msecs == 0);
> Same above
> 
> 
> Similar question, we are very close to finish driver split, when is the
> best time for this patch?

The same aswer :-) I will respin, when your patches will land in John tree.

Stanislaw
