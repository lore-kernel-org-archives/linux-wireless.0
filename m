Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab1ELSN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 14:13:26 -0400
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTin2ZxDhZ+aotC=HDz9Fc==tf2gsgQ@mail.gmail.com> (sfid-20110512_200918_382044_0D97DD34)
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	 <4DC81A61.9080101@candelatech.com>
	 <1304959783.12202.7.camel@jlt3.sipsolutions.net>
	 <BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com>
	 <1305132500.17892.1.camel@jlt3.sipsolutions.net>
	 <BANLkTikL0iLEWcseFdq572rZcVxVkKg8Hg@mail.gmail.com>
	 <1305188063.3461.3.camel@jlt3.sipsolutions.net>
	 <BANLkTin2ZxDhZ+aotC=HDz9Fc==tf2gsgQ@mail.gmail.com>
	 (sfid-20110512_200918_382044_0D97DD34)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 20:13:22 +0200
Message-ID: <1305224002.3461.34.camel@jlt3.sipsolutions.net> (sfid-20110512_201329_669142_60126847)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-12 at 20:08 +0200, Björn Smedman wrote:

> > That has a failure path, and recently I posted a patch to advertise the
> > interface type combinations. I don't think MAC addresses impose any sort
> > of restriction.
> 
> I think at least some rt2x00 hw may not be able to handle all
> combinations of multi-vif MAC addresses.
> 
> If I understand correctly ath9k will happily configure the hardware to
> ack all BSSIDs if multi-vif MAC addresses are poorly chosen. I don't
> know if that's a reason to fail but it wouldn't be good, right?

That'd be possible I guess if you configure them so their XOR is all
ones, but it doesn't matter -- you can fail that right now. Also, if the
user configures it like that maybe that's their fault?

> Another case where cross-vif constraints are difficult to handle is
> BSS_CHANGED_ERP_SLOT / BSS_CHANGED_ERP_PREAMBLE. Again, I'm not sure
> failing is the right way to handle this but at least ath9k seems
> incapable of having separate slot times / preambles for separate
> vifs...

That's hard to believe since it's rate control stuff?

johannes

