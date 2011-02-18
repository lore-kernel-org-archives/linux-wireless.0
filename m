Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63990 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1BRWkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 17:40:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 14:39:53 -0800
Date: Fri, 18 Feb 2011 14:40:13 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: Joe Perches <joe@perches.com>
CC: Greg KH <greg@kroah.com>, Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 01/15] staging: ath6kl: Fixing a NULL pointer exception
Message-ID: <20110218224013.GA2439@vmehta-desktop>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
 <20110218212938.GA21986@kroah.com>
 <1298066200.7179.12.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1298066200.7179.12.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 01:56:40PM -0800, Joe Perches wrote:
> On Fri, 2011-02-18 at 13:29 -0800, Greg KH wrote:
> > On Fri, Feb 18, 2011 at 01:13:02PM -0800, Vipin Mehta wrote:
> > > The driver was dereferencing a NULL pointer because of the device instance
> > > being registered via the set_wiphy_dev() function. The function
> > > ar6000_avail_ev() was passing the argument as NULL instead of using the one
> > > returned by the MMC stack through the probe callback.
> > I've applied all of these, but note that some of them add whitespace
> > warnings.  In the future, I'll reject those that do this, please always
> > run your patches through scripts/checkpatch.pl to not have this happen.
> 
> Vipin,
> 
> A good test is to generate the patches using git format-patch
> then apply them to a new, separate branch using git am.
> Whitespace problems will cause rejects.
> 
> You can use git am --whitespace=fix on each patch if necessary,
> then regenerate the git format-patch set from that new branch.
> 
> cheers, Joe
> 
Got it. Shall do that for subsequent patches.
