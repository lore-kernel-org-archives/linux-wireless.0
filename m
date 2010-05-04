Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50485 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0EDTzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 15:55:01 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 12:55:01 -0700
Date: Tue, 4 May 2010 12:55:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix another source of corrupt frames
Message-ID: <20100504195500.GH2624@tux>
References: <4BDFD3C1.4000209@openwrt.org>
 <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
 <4BE0773A.8090009@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4BE0773A.8090009@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 04, 2010 at 12:36:26PM -0700, Felix Fietkau wrote:
> On 2010-05-04 8:09 PM, Luis R. Rodriguez wrote:
> > On Tue, May 4, 2010 at 12:58 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> >> Atheros hardware supports receiving frames that span multiple
> >> descriptors and buffers. In this case, the rx status of every
> >> descriptor except for the last one is invalid and may contain random
> >> data. Because the driver does not support this, it needs to drop such
> >> frames.
> >>
> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >> ---
> >> --- a/drivers/net/wireless/ath/ath9k/common.c
> >> +++ b/drivers/net/wireless/ath/ath9k/common.c
> >> @@ -57,13 +57,19 @@ static bool ath9k_rx_accept(struct ath_c
> >>         * rs_more indicates chained descriptors which can be used
> >>         * to link buffers together for a sort of scatter-gather
> >>         * operation.
> >> -        *
> >> +        * reject the frame, we don't support scatter-gather yet and
> >> +        * the frame is probably corrupt anyway
> >> +        */
> >> +       if (rx_stats->rs_more)
> >> +               return false;
> > 
> > Actually this is required by ath9k_htc, it does process these, but
> > ath9k doesn't so this could be done within ath9k itself.
> I don't see any place in ath9k_htc that processes rs_more.

Odd, when I worked on it, I had to use this, let me check with today's
code and get back to this thread.

> And even if
> it did, processing the rx status of a frame that has more descriptors
> chained after it would be wrong, since the rx status is only valid for
> the last frame of the descriptor chain.

This is true.

> I think my patch would work fine for ath9k_htc as well.

We should test just to be sure. Would hate to request for a revert
for something we could have just prevented with proper testing/review.
I can test this in a bit I think.

  Luis
