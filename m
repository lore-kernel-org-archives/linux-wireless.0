Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbXJVPrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 11:47:39 -0400
Subject: Re: [PATCH] ipw2200: batch non-user-requested scan result
	notifications
From: Dan Williams <dcbw@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
In-Reply-To: <1193042719.3069.166.camel@debian.sh.intel.com>
References: <1191952524.617.7.camel@localhost.localdomain>
	 <1193042719.3069.166.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 11:47:18 -0400
Message-Id: <1193068039.30205.13.camel@localhost.localdomain> (sfid-20071022_164741_089796_86530030)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-22 at 16:45 +0800, Zhu Yi wrote:
> On Tue, 2007-10-09 at 13:55 -0400, Dan Williams wrote:
> > ipw2200 makes extensive use of background scanning when unassociated
> > or
> > down.  Unfortunately, the firmware sends scan completed events many
> > times per second, which the driver pushes directly up to userspace.
> > This needlessly wakes up processes listening for wireless events many
> > times per second.  Batch together scan completed events for
> > non-user-requested scans and send them up to userspace every 4
> > seconds.
> > Scan completed events resulting from an SIOCSIWSCAN call are pushed up
> > without delay.
> > 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> I'm OK with this one except the round_jiffies part.

I think that it got fixed upstream when the round_jiffies_relative()
patch went it, is that what you mean?  If not, I'm not sure what you
mean by "except the round_jiffies part".

Dan

> Thanks,
> -yi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

