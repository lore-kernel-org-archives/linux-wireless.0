Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052Ab2KNLXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 06:23:21 -0500
Message-ID: <1352892233.9510.26.camel@jlt4.sipsolutions.net> (sfid-20121114_122324_825323_0E6564B7)
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 14 Nov 2012 12:23:53 +0100
In-Reply-To: <50A2617B.3060807@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	    <1350226137-13704-7-git-send-email-victorg@ti.com>
	   <1350414472.10177.17.camel@jlt4.sipsolutions.net>
	  <50842563.4010201@ti.com> <1350910599.10166.4.camel@jlt4.sipsolutions.net>
	  <50922AA9.4030509@ti.com> <1352128994.9466.19.camel@jlt4.sipsolutions.net>
	 <50A2617B.3060807@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 17:04 +0200, Victor Goldenshtein wrote:

> > No ... channel contexts are in the kernel now, so you do have to think
> > about it now.
> 
> Well thinking is one thing implementing is another ;)

Well ... :)

> This whole DFS implementation initially intended for a single channel 
> mac. I don't might to deal with the channel context stuff but not sure 
> how much available time I"ll have for it, so it might take awhile.
> I know there are people waiting for this, so I'm thinking would you 
> consider to go first with this single channel DFS support and later to 
> extend it to work with channel context stuff ?

Fair enough, but like I've been telling you, the current code doesn't
even match the current APIs.

Initially, I thought that for radar detection, you need to reserve the
channel context (in mac80211), make sure it's the only channel context
and prohibit other channel contexts from being added, until radar
detection is done.

However, then I realised that that still doesn't work -- once initial
radar detection is done, it needs to continue while the AP is active. If
the channel context was going to be relinquished, or even just the
channel changed for a few seconds, it would be unsafe. So as a result,
the radar detect operation has to somehow be coupled to the start AP
operation and prohibit channel changes and additional channel contexts
during the entire operation time.

I definitely think this needs some work, because the APIs and cfg80211
code have to be correct for multi-channel operation even if you don't
support it.

johannes

