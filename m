Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:37178 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXCEDdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 22:33:39 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HO3vY-0003la-NK
	for linux-wireless@vger.kernel.org; Sun, 04 Mar 2007 22:31:56 -0500
Subject: Re: [patch] at76_usb wireless driver
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Guido Guenther <agx@sigxcpu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1173052343.6131.24.camel@johannes.berg>
References: <20070110145724.GA4171@bogon.ms20.nix>
	 <20070223221230.GA9965@bogon.ms20.nix>
	 <20070303150029.GA19940@bogon.ms20.nix>
	 <1172934588.4966.46.camel@johannes.berg>
	 <1172939037.4966.97.camel@johannes.berg>
	 <20070304020920.b5lej3sw0oogwg4w@webmail.spamcop.net>
	 <1173052343.6131.24.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 22:33:34 -0500
Message-Id: <1173065614.2670.20.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-03-05 at 00:52 +0100, Johannes Berg wrote:
> Wouldn't you just always have prism headers in monitor mode? All cards I
> know do that iirc. Or well, radiotap seems to be the format of fashion
> these days. I don't particularly like either :)

Sounds good.  Radiotap is more flexible and better defined, but just
leaving prism headers for now would be fine.

> Not sure. I find that it messes up some things too. Maybe run Lindent,
> diff the original vs. the result and take the hunks you like.

Yes, something like that.

> > * istate should be accessed using atomic_set/atomic_read; locking is overkill
> 
> atomic operations can be quite expensive too, but you probably know
> better if you need it or not.

Actually, it looks like we don't need them either.  Atomic operations
are useful for counters or generally when data is read and written at
once.  Simply reading and writing integers is atomic by design of any
sane and supported CPU.

The istate locks were causing complains from the lock checkers, and my
attempt to replace them with atomic operations silenced those
complaints.  But It looks like we just need to drop those locks.  They
were put there in a hurry without due checking, they don't address any
problem, but they may create one.

-- 
Regards,
Pavel Roskin

