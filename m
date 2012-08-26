Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HZIjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 04:39:53 -0400
Message-ID: <1345970386.3622.5.camel@jlt4.sipsolutions.net> (sfid-20120826_103959_519003_C33E2C7C)
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Sun, 26 Aug 2012 10:39:46 +0200
In-Reply-To: <50377CD9.3090204@posedge.com>
References: <502E85D9.5050301@posedge.com>
	  <1345480718.4459.37.camel@jlt3.sipsolutions.net>
	  <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>
	  <50338E84.3050709@posedge.com>
	  <1345564421.10280.9.camel@jlt3.sipsolutions.net>
	  <5033CE76.6040306@posedge.com>
	  <1345619008.4635.3.camel@jlt3.sipsolutions.net>
	  <20120822090104.GA4959@redhat.com>
	  <1345626282.4635.8.camel@jlt3.sipsolutions.net>
	  <20120822101252.GA6082@redhat.com> <50376671.7080007@posedge.com>
	 <1345809927.6991.0.camel@jlt3.sipsolutions.net>
	 <50377CD9.3090204@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-24 at 18:38 +0530, Mahesh Palivela wrote:

> > We might need 20MHZ_NOHT or something?
> 
> Yes, I missed that.
> 20MHZ_NOHT in 5G band and legacy operation 2.4G band may be 5MHZ.

We don't support 5/10 MHz (yet anyway), so we don't have to worry about
that.

> > Those shouldn't be necessary, I think? The secondary 80 MHz channel
> > can't have a control channel, it seems, and the width should be the same
> > as well? Plus this is only allowed in 80+80 anyway.

> 11ac d3.0 spec section 8.4.2.10 says
> 
> An operating class for an 80+80 MHz channel bandwidth is expressed by 
> two consecutive Operating/Sub-
> band Sequences, where the first Operating/Subband Sequence field 
> contains an Operating Triplet for an
> 80 MHz Channel Spacing with an 80+ Behavior Limit and the second 
> Operating/Subband Sequence field
> contains an Operating Triplet for an 80 MHz Channel Spacing without an 
> 80+ Behavior Limit.
> 
> so country might allow primary chan to fall in other frequency segment?

Yes, but how's that related to how you specify the channel?

joahnnes

