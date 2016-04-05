Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55265 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758411AbcDENkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:40:25 -0400
Message-ID: <1459863619.18188.50.camel@sipsolutions.net> (sfid-20160405_154028_688735_AFFE1B54)
Subject: Re: [PATCH] mac80211: fix "warning:
 =?UTF-8?Q?=E2=80=98target=5Fmetric=E2=80=99?= may be used uninitialized"
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Mahoney <jeffm@suse.com>, linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 15:40:19 +0200
In-Reply-To: <5703BEA7.3040406@suse.com>
References: <5702AF3B.1070507@suse.com>
	 <1459849388.18188.28.camel@sipsolutions.net> <5703BEA7.3040406@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-05 at 09:33 -0400, Jeff Mahoney wrote:
> On 4/5/16 5:43 AM, Johannes Berg wrote:
> > 
> > On Mon, 2016-04-04 at 14:15 -0400, Jeff Mahoney wrote:
> > > 
> > > This fixes:
> > > 
> > > net/mac80211/mesh_hwmp.c:603:26: warning: ‘target_metric’ may be
> > > used
> > > uninitialized in this function
> > > 
> > > target_metric is only consumed when reply = true so no bug exists
> > > here,
> > > but gcc doesn't notice that.  Initializing to 0 clears the
> > > warning.
> > > 
> > What gcc version are you using? Mine doesn't seem to have a problem
> > following the logic here.
> gcc version 4.8.5 (SUSE Linux)

Ok, mine's significantly newer:

gcc (Debian 5.3.1-10) 5.3.1 20160224

I do wonder though if we really should do this? It might hide errors
later on?

johannes
