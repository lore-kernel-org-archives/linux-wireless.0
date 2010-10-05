Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab0JEH4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 03:56:10 -0400
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAA5861.4020503@candelatech.com>
References: <4CAA2247.50402@candelatech.com>
	 <1286218879.3620.55.camel@jlt3.sipsolutions.net>
	 <4CAA252F.9090102@candelatech.com>
	 <1286219405.3620.56.camel@jlt3.sipsolutions.net>
	 <AANLkTi=Ya6RuCdVYLYi3Mk5EKSP6czOfTh7TRKqB0GPU@mail.gmail.com>
	 <AANLkTinGaCAEqGRt_X6hsO8sQx4kKEdNqU8pfi00_1-r@mail.gmail.com>
	 <4CAA494B.5000500@candelatech.com>  <4CAA5861.4020503@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 09:56:06 +0200
Message-ID: <1286265366.3641.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 15:42 -0700, Ben Greear wrote:

> I did find a similar crash while debugging a kernel with just symbols
> compiled in (not kgdb) though:

Doesn't seem all that similar...

> The interesting thing to me is that the 00100104 address is the same in
> both crashes, though this one is in a different method.

except for that maybe. But this is LIST_POISON1, and with seemingly
different lists. It may be faster to reproduce if you enable slab/slub
debugging.

> Also, this is with power-save NOT disabled (I was hoping to
> hit some debugging code I put in for the other crash..hit this instead.)
> 
> Oct  4 15:26:15 localhost kernel: BUG: unable to handle kernel paging request at 00100104
> Oct  4 15:26:15 localhost kernel: IP: [<fc77e038>] cfg80211_unlink_bss+0x4d/0x8d [cfg80211]

Looks like a mac80211 bug, but you snipped the stack trace.

johannes

