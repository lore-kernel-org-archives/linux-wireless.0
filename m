Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2DRCCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 22:02:52 -0400
Message-ID: <1334714536.3725.33.camel@jlt3.sipsolutions.net> (sfid-20120418_040256_304427_BAA29319)
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	javier@cozybit.com, linux-wireless@vger.kernel.org,
	henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>
Date: Tue, 17 Apr 2012 19:02:16 -0700
In-Reply-To: <4F868732.1030401@etit.tu-chemnitz.de>
References: <4F630AEA.10703@etit.tu-chemnitz.de>
	  <20120316204547.GG18861@tux> <4F63BA31.1080608@etit.tu-chemnitz.de>
	  <4F856449.3000804@etit.tu-chemnitz.de>
	 <1334203508.3788.12.camel@jlt3.sipsolutions.net>
	 <4F868732.1030401@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-12 at 09:41 +0200, Marco Porsch wrote:

> > What time units would that be in, and how could you correlate them?
> 
> I did not take an exhaustive overview over all possible drivers.
> But as the current mac80211<->driver interface carries only beacon 
> interval (in TU) and DTIM period, that should be a good starting point.

Those aren't really useful at all? You need to define wakeups in
absolute terms I'd think? And you could have the TSF from the beacon,
but that itself is also useless since you need the offset.

> ath9k additionally relies on the neighbors address to check whether it 
> can resume sleep after receiving an expected beacon (see setting of 
> 'is_mybeacon' in ath_rx_tasklet).

That's IBSS only I'd think?

> Concerning correlation, in mesh mode we recently have t_offset (in TSF 
> increments) stored in sta_info and in client mode the drivers' 
> synchronised TSF should be the reference (but I am not quite sure what 
> happens when one client is associated to multiple AP).

That's starting to sound more like a solution, but even then you have a
lot of issues to resolve like when exactly is the timestamp hitting.
Keep in mind that TSF == start of TSF field, while rx_status->timestamp
== start of first symbol, which I didn't even remember when you guys did
all the Toffset things, I'm guessing they're all wrong :-)

johannes

