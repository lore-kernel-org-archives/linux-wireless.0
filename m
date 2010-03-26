Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:5940 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751981Ab0CZA2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 20:28:07 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0564913283
	for <linux-wireless@vger.kernel.org>; Fri, 26 Mar 2010 09:28:04 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Date: Fri, 26 Mar 2010 09:27:57 +0900
Cc: Derek Smithies <derek@indranet.co.nz>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20100325054603.10697.48915.stgit@tt-desk> <alpine.DEB.2.00.1003261001530.24989@kauri.acheron.indranet.co.nz> <20100325211311.GG7651@tux>
In-Reply-To: <20100325211311.GG7651@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003260927.57491.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 March 2010 06:13:11 Luis R. Rodriguez wrote:
> > > - Improve beacon averaging algorithm for IBSS: Maybe we should keep
> > > track of
> > > 
> > >  the average RSSI on a per-node basis and use the minimum of those in
> > >  order not to loose far away nodes? The other option would be to limit
> > >  the parameters we control similar to AP mode.
> > 
> > We have talked about this before. I thought that we agreed
> > that adhoc nodes may
> > 
> >    a)be activated at any time
> >    b)be positioned at an unknown distance apart
> > 
> > it therefore makes no sense to average the RSSI over the current nodes.
> > If all the current nodes in the network are close by, the ani algorithm
> > will wind the sensitivity down. Consequently, if a remote node is
> > started, it will not be able to connect. Yet, the remote node should
> > have been able to connect as the slot times etc were long enough,
> > and the link budget is fine...

i'm not sure how big the effect of ANI is - would it really shut the remote 
node out completely? or would just performance degrade? also beacons are sent 
at the lowest rate, so they will travel far. this needs to be tested! it 
doesnt make sense to discuss this based on hypothetical assumptions.

> > So yes, the only way to
> > 
> > > - Improve beacon averaging algorithm for IBSS:
> > is to turn ani off. which means the issue you raised else where of
> > providing reasonable userland controls (not via debugfs) becomes
> > important.
> 
> If ANI helps IBSS so much then why not just default to turning it
> off within the driver?

i would say in most standard cases, IBSS nodes are close together or at a 
similar distance, so it does make sense to use ANI by default.

as well, we all agree that there should be userland controls. the questions is 
just about the interface to use.

bruno
