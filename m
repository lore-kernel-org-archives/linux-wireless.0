Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab0EYP0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 11:26:03 -0400
Subject: Re: WLAN Regulatory Domain Germany
From: Johannes Berg <johannes@sipsolutions.net>
To: Kurt Garloff <garloff@suse.de>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20100525151429.GC6342@tpkurt2.garloff.de>
References: <20100519172944.GB32757@tpkurt2.garloff.de>
	 <1274690246.3743.20.camel@jlt3.sipsolutions.net>
	 <20100525151429.GC6342@tpkurt2.garloff.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 17:26:19 +0200
Message-ID: <1274801179.3635.44.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-25 at 17:14 +0200, Kurt Garloff wrote:
>                                                                                               
> OK, new suggestion.
> 
> 8<------------------------------------------------------------------------                    
> 
> # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
> # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
> # For the 5GHz range also see
> # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
> # The values have been reduced by a factor of 2 (3db) for non TPC devices
> # (in other words: devices with TPC can use twice the tx power of this table).
> # Note that the docs do not require TPC for 5150--5250; the reduction to
> # 100mW thus is not strictly required -- however the conservative 100mW
> # limit is used here as the non-interference with radar and satellite
> # apps relies on the attenuation by the building walls only in the
> # absence of DFS; the neighbour countries have 100mW limit here as well.
> 
> country DE:
> 	# entries 279004 and 280006
>        (2400 - 2483.5 @ 40), (N/A, 100 mW)
>        # entry 303005
>        (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
>        # entries 304002 and 305002
>        (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>        # entries 308002, 309001 and 310003
>        (5470 - 5725 @ 40), (N/A, 500 mW), DFS

Ok, that looks fine to me.

> Can we actually put several entries covering the same frequency range?
> Then we could put 200mW for DFS and 100mW for non-DFS.
> This would also address the next issue you raise ...

I think you're confusing DFS and TPC requirements? Anyway, no, we can't
right now.

> > Also note that there are different requirements depending on the channel
> > bandwidth, which will eventually come up in Linux too. But I think for
> > that we need the new database format for that ... yet another thing to
> > do before we can support 5/10 MHz channels.
> 
> Indeed. For 5150 -- 5350, the spectral power density may not exceed
> 10mW/MHz (and overall emitted power in the range per device not 200mW);
> this gives a limit of 200mW for 20MHz channels or 100mW if no TPC is 
> used for 5250 -- 5350. (For 5470--5725 use 5x those values.)
> I'm not aware of WLAN devices with narrower channels yet, but if they 
> come into existence, we'd have to reflect it somehow ...

They exist, we just don't support them right now ... I put it on the
todo list for now.

johannes

