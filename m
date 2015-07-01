Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40794 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbbGAO5S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 10:57:18 -0400
Message-ID: <1435762626.2168.1.camel@sipsolutions.net> (sfid-20150701_165721_325691_E2386591)
Subject: Re: [PATCH v4] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>,
	"quozl@laptop.org" <quozl@laptop.org>,
	Dan Williams <dcbw@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Wed, 01 Jul 2015 16:57:06 +0200
In-Reply-To: <019032ba6cc14a4293b670496dd2bb1e@SC-EXCH02.marvell.com>
References: <cf8d3fa226704acea770a987100f4d4e@SC-EXCH02.marvell.com>
	 <1435652491.2082.5.camel@sipsolutions.net>
	 <1435673924.9390.4.camel@redhat.com> <20150630222610.GB30901@us.netrek.org>
	 <019032ba6cc14a4293b670496dd2bb1e@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-07-01 at 14:42 +0000, David Lin wrote:
> > We can leave both selectable by developer testing as per your
> suggestion, and assume users/integrators will know how to put the 
> driver they want in their system. We were warned about causing 
> confusion hence the conditioning in CONFIG. Do you feel there's no 
> concern leaving both driver in, not checking each other's presence? 
> We can comply either way.

I think you should just leave both selectable.

> > > > This looks OK, though I get a very strange dependency loop 
> > > > warning
> > > > from Kconfig here.
> 
> For the next patch, we will modify the code to still work even though 
> the target does not support DTS. So we can remove "select OF" from 
> Kconfig file.

If the driver needs OF don't bother - the dependency loop is very long
and the warning is rather strange.

> > > > > writew(0x00, (void __iomem *)&priv->pcmd_buf[1]);
> > > > 
> > > > cannot be right. This memory isn't __iomem, it's 
> > > > dma_alloc_coherent,
> > > > so a simple write should be done.
> > > > 
> 
> Without this casting, C=2 will cause a warning message like this: 
> "Warning: incorrect type in argument 2 (different address spaces)"

Yes, but the warning is correct and the cast is wrong. This isn't
__iomem, it's simply mapped, so you should just do a
	(u32 *)pcmd_buf[1] = 0;

or something like that. The writev() to such a pointer cannot be right.

> johannes
