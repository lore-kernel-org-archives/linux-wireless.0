Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16647 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZHLMpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 08:45:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 05:45:06 -0700
Date: Wed, 12 Aug 2009 18:12:50 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: roel kluin <roel.kluin@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Prevent read buffer overflow
Message-ID: <20090812124250.GB4876@vasanth-laptop>
References: <4A81BB1E.6040904@gmail.com> <20090812115803.GA4876@vasanth-laptop> <25e057c00908120535p1135be7ak399599fdca6b636f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <25e057c00908120535p1135be7ak399599fdca6b636f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 06:05:55PM +0530, roel kluin wrote:
> On Wed, Aug 12, 2009 at 1:58 PM, Vasanthakumar
> Thiagarajan<vasanth@atheros.com> wrote:
> > On Wed, Aug 12, 2009 at 12:10:30AM +0530, Roel Kluin wrote:
> >> Prevent a read from valid_rate_index[] with a negative index
> >>
> >> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> >> ---
> >> Maybe we should add this?
> >>
> >> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> >> index ba06e78..a67b7f6 100644
> >> --- a/drivers/net/wireless/ath/ath9k/rc.c
> >> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> >> @@ -1458,7 +1458,7 @@ static void ath_rc_init(struct ath_softc *sc,
> >>                 ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
> >>         }
> >>         ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
> >> -       ASSERT(k <= RATE_TABLE_SIZE);
> >> +       ASSERT(k <= RATE_TABLE_SIZE && k >= 4);
> >
> >
> > NACK, k is initialized to 0 in the for loop few lines above this
> > ASSERT.
> >
> > Vasanth
> 
> but where is this rate_cnt initialized?

from the static rate table for the respective mode. You can find
these tables in the begining of rc.c.


Vasanth

