Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:32939 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab2L0Is0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 03:48:26 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Bartosz Markowski <markowski.bartosz@gmail.com>,
	linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: Re: [PATCH 06/17] cw1200: Mini-AP implementation
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
	<1356191120-5280-7-git-send-email-pizza@shaftnet.org>
	<50D61117.8020009@gmail.com>
	<CAM8CFPgJu5CR9tU_mMw1_0yDUEj-dLk2G+6W91W1-H4LMa+BUw@mail.gmail.com>
	<20121223124734.GB29607@shaftnet.org>
	<CAM8CFPj==UdTjCe0=hPRtT_BC1E4TvRFDjqBZUD4=c+PbkncVA@mail.gmail.com>
	<20121223164408.GA3624@shaftnet.org>
Date: Thu, 27 Dec 2012 10:48:24 +0200
In-Reply-To: <20121223164408.GA3624@shaftnet.org> (Solomon Peachy's message of
	"Sun, 23 Dec 2012 11:44:09 -0500")
Message-ID: <87r4mbubhj.fsf@purkki.adurom.net> (sfid-20121227_094836_677370_3AA555E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Solomon Peachy <pizza@shaftnet.org> writes:

> From my own investigations into the LMAC sources, that event is 
> triggered by an internal LMAC timer if it hasn't received a beacon at 
> all in that time.  Disabling powersave operation makes the problem go 
> away entirely, so I suspect what's happening is that the LMAC is 
> consistently waking up a little too late (or going back to sleep too 
> early) to hear the beacons.
>
> My guess is that the LMAC is pushing its powersaving margins too close.

Or synchronisation to TBTT is busted for some reason, like not
receiving a beacon before enabling power save etc. (just guessing here).

-- 
Kalle Valo
