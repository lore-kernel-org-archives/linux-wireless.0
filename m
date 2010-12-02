Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61720 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab0LBMW3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 07:22:29 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 04:22:14 -0800
Date: Thu, 2 Dec 2010 17:51:47 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 16/27] ath9k_hw: Read and configure antenna
	diversity control for AR9485
Message-ID: <20101202122147.GN12908@vasanth-laptop>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com> <1291288031-3409-17-git-send-email-vasanth@atheros.com> <AANLkTi=Fb0HA1DbaRp21kOS3x4-s_Oh+UZok2jNK3-PG@mail.gmail.com> <20101202120925.GM12908@vasanth-laptop> <AANLkTimmHLG8PU=1AweKqcPnyF4=6q3QNmA2nVeV00fh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTimmHLG8PU=1AweKqcPnyF4=6q3QNmA2nVeV00fh@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 02, 2010 at 05:46:05PM +0530, Julian Calaby wrote:
> On Thu, Dec 2, 2010 at 23:09, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > No, these are to separate things.
> 
> Are you sure? you seem to be doing:
> 
> if (!AR_SREV_9485(ah)) {
>     // CODE
> }
> 
> if (AR_SREV_9485(ah)) {
>     // MORE CODE
> }
> 
> which I'm certain can be simlified as:
> 
> if (!AR_SREV_9485(ah)) {
>     // CODE
> } else {
>     // MORE CODE
> }
> 
> unless you're telling me that the value of AR_SREV_9485(ah) can change
> in the course of the first statement.

I mean the register configuration. In one case, chain 1 and chain 2
are irrelevant for AR9485. The second is antenna diversity is
enabled only for AR9485. Putting them in if..else would be
misleading, though is can be in if..else.

Vasanth
