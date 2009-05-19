Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3081 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZESMfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 08:35:15 -0400
Date: Tue, 19 May 2009 08:34:22 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath5k: prevent infinite loop
Message-ID: <20090519123422.GE2580@hash.localnet>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com> <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com> <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com> <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com> <20090519114240.GA13934@hash.localnet> <alpine.DEB.2.00.0905190751200.1767@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.00.0905190751200.1767@gandalf.stny.rr.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 07:54:23AM -0400, Steven Rostedt wrote:
> > Do these patches need to go to 2.6.30?
> 
> Considering that it locked up my box, I would think that it should. Well, 
> at least the change that checks for the infinite loop.

Yeah, I just wasn't sure if you were using that or -next (which should be
fixed, I guess.)  I mistakenly thought Nick posted commit ishs but they
were blobs, the actual commit was:

e5f1d7f3c192c8ebeb492427bab84611ed5568eb "ath5k: fix interpolation with
equal power levels" in wireless-testing.

Those loops really want a helper function...

Hmm, not too familiar with this particular code but getting back -32768
in the degenerate case seems wrong so I'd be inclined towards a hybrid
version of the two that also sanity checks the steps (corrupt eeproms
are bad, but one rather likely corruption is a big block of ones or 
zeroes).

-- 
Bob Copeland %% www.bobcopeland.com

