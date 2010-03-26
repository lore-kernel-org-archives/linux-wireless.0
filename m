Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:46711 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751981Ab0CZBqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 21:46:19 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0647077977
	for <linux-wireless@vger.kernel.org>; Fri, 26 Mar 2010 10:46:18 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Derek Smithies <derek@indranet.co.nz>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Date: Fri, 26 Mar 2010 10:46:10 +0900
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20100325054603.10697.48915.stgit@tt-desk> <201003260927.57491.br1@einfach.org> <alpine.DEB.2.00.1003261416120.24989@kauri.acheron.indranet.co.nz>
In-Reply-To: <alpine.DEB.2.00.1003261416120.24989@kauri.acheron.indranet.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003261046.10755.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 March 2010 10:21:50 Derek Smithies wrote:
> On Fri, 26 Mar 2010, Bruno Randolf wrote:
> >>>> - Improve beacon averaging algorithm for IBSS:
> >>> is to turn ani off. which means the issue you raised else where of
> >>> providing reasonable userland controls (not via debugfs) becomes
> >>> important.
> >> 
> >> If ANI helps IBSS so much then why not just default to turning it
> >> off within the driver?
> > 
> > i would say in most standard cases, IBSS nodes are close together or at a
> > similar distance, so it does make sense to use ANI by default.
> 
> Nope - I disagree. You have made a dangerous assumption, to asume
> that
>    IBSS node are close together or at a similar distance
>
> if you have a network of ibss nodes, and then look at the rate tables of
> the different nodes (minstrel is great here - it gives a fair and accurte
> represetation of the best rate possible to other nodes) 

yeah, we all know how great minstrel is... really.

> you see there is
> some variation in the optimal rates between nodes.Which suggests that
> using some automatic ani algorithm in an ibss network will foreever lower
> performance for those nodes at the edge of the network.
> 
> > as well, we all agree that there should be userland controls. the
> > questions is just about the interface to use.
> 
> Definately - need userland controls. The default for IBSS should have
> ANI off. If the user wants to "futz" with it, they can. With ANI off for
> IBSS, you ensure that on startup, the network has the greatest chance of
> working.

i said in most *standard* cases - the standard case for IBSS is still 3 or 5 
guys sitting in a room, or close by, wanting to exchange some data. we should 
have good performance for that, therefore ANI on by default.

in larger IBSS mesh networks or outdoor deployments you will want to tune ANI 
manually anyhow, then you can turn it off.

again - i'm not willing to discuss this based on guesses and assumptions. 
looking at the rate tables will not tell you if using ANI will shut a node out 
or not. if you have test results showing that a specific ANI setting actually 
prevented a node from joining an IBSS, i'm happy to resume this discussion.

bruno
