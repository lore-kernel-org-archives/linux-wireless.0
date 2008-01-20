Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw.indranet.co.nz ([203.167.203.10]:3590 "EHLO
	enso.acheron.indranet.co.nz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754057AbYATCWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 21:22:39 -0500
Date: Sun, 20 Jan 2008 15:12:11 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
cc: Bruno Randolf <bruno@thinktube.com>, jirislaby@gmail.com,
	Michael Wu <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: always extend rx timestamp	with
 tsf
In-Reply-To: <43e72e890801191420p5c25e32aid790748a982bd54d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801201508190.12028@kauri.acheron.indranet.co.nz> (sfid-20080120_022250_359821_9F324922)
References: <20080118125018.6342.94435.stgit@one> <20080118125059.6342.18514.stgit@one>
 <43e72e890801191420p5c25e32aid790748a982bd54d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, 19 Jan 2008, Luis R. Rodriguez wrote:

> On Jan 18, 2008 7:50 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> > +                * always extend the mac timestamp, since this information is
> > +                * also needed for proper IBSS merging.
> > +                *
> > +                * XXX: it might be too late to do it here, since rs_tstamp is
> > +                * 15bit only. that means TSF extension has to be done within
> > +                * 32.768usec = 32ms. it might be necessary to move this to the
> > +                * interrupt handler, like it is done in madwifi.
> > +                */
> 
> I'm trying to understand this a bit more and am confused. The TSF
> timer is based on 1MHz clock so it has a resolution of 1 microsecond
> (us). For 15 bits that would mean 32768 us so don't you mean it should
> be done within 32.768 ms instead of usec (or us)?
> 
Hi,
 it is a typo.

You are correct. It should be done within 32.768 ms. On a high end laptop, 
it is almost guaranteed that the bottom half will process the packet 
within 32 ms. However, on an embedded box (low spec cpu) that has a 
temporarily high load, 32 ms is a short time, and the timestamp may have 
wrapped around. this is unfortunate.

Derek.
-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
Email: derek@indranet.co.nz
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/
