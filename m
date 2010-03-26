Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11957 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab0CZAoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 20:44:32 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 17:44:32 -0700
Date: Thu, 25 Mar 2010 17:44:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Message-ID: <20100326004431.GA2385@tux>
References: <20100325054603.10697.48915.stgit@tt-desk>
 <alpine.DEB.2.00.1003261001530.24989@kauri.acheron.indranet.co.nz>
 <20100325211311.GG7651@tux>
 <201003260927.57491.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201003260927.57491.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 05:27:57PM -0700, Bruno Randolf wrote:
> On Friday 26 March 2010 06:13:11 Luis R. Rodriguez wrote:
> > > > - Improve beacon averaging algorithm for IBSS: Maybe we should keep
> > > > track of
> > > > 
> > > >  the average RSSI on a per-node basis and use the minimum of those in
> > > >  order not to loose far away nodes? The other option would be to limit
> > > >  the parameters we control similar to AP mode.
> > > 
> > > We have talked about this before. I thought that we agreed
> > > that adhoc nodes may
> > > 
> > >    a)be activated at any time
> > >    b)be positioned at an unknown distance apart
> > > 
> > > it therefore makes no sense to average the RSSI over the current nodes.
> > > If all the current nodes in the network are close by, the ani algorithm
> > > will wind the sensitivity down. Consequently, if a remote node is
> > > started, it will not be able to connect. Yet, the remote node should
> > > have been able to connect as the slot times etc were long enough,
> > > and the link budget is fine...
> 
> i'm not sure how big the effect of ANI is - would it really shut the remote 
> node out completely? or would just performance degrade? also beacons are sent 
> at the lowest rate, so they will travel far. this needs to be tested! it 
> doesnt make sense to discuss this based on hypothetical assumptions.
> 
> > > So yes, the only way to
> > > 
> > > > - Improve beacon averaging algorithm for IBSS:
> > > is to turn ani off. which means the issue you raised else where of
> > > providing reasonable userland controls (not via debugfs) becomes
> > > important.
> > 
> > If ANI helps IBSS so much then why not just default to turning it
> > off within the driver?
> 
> i would say in most standard cases, IBSS nodes are close together or at a 
> similar distance, so it does make sense to use ANI by default.
> 
> as well, we all agree that there should be userland controls. the questions is 
> just about the interface to use.

ANI is specific to Atheros cards so debugfs would do it. If we want to
have a more rigit API we could use a configfs entry for ath9k.

  Luis
