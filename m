Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40284 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0EWGsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 02:48:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 22 May 2010 23:48:36 -0700
Date: Sat, 22 May 2010 23:48:15 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Kalle Valo <kvalo@adurom.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix rx of mcast/bcast frames in PS mode with
 auto sleep
Message-ID: <20100523064814.GB21298@vasanth-laptop>
References: <1274229062-10412-1-git-send-email-vasanth@atheros.com>
 <8739xjiwjj.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <8739xjiwjj.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 23, 2010 at 12:38:48AM +0530, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vasanth@atheros.com> writes:
> 
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> Please describe more, this isn't very informative (if any). Especially
> try to answer in the commit log:
> 
> o What was the original bug? How and why did it happen?
> o How was it visible to the user?
> o How does the fix actually fix the issue?

Sure.
> o In what version was the bug introduced? This helps backporters.

This patch is only for ar9003 and its support is added only
recently. No released kernel has the support for this chip.
> 
> > +#define ATH9K_CHECK_AUTO_SLEEP(__sc) \
> > +	(__sc->ps_enabled && \
> > +	(__sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
> 
> Like Andrew Morton says: use C instead of CPP. Meaning that this can
> be an inline function instead of a macro.

will do, thanks.

Vasanth
