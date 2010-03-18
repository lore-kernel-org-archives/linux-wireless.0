Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31655 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0CRQxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 12:53:38 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 09:53:38 -0700
Date: Thu, 18 Mar 2010 09:53:36 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: selvam <sathakselva@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vipin M <vipintm@gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: 4ms frame length table update
Message-ID: <20100318165335.GA4011@vasanth-laptop>
References: <1aee2dca1003172337g5d66a03ex20ebab74707a6c56@mail.gmail.com>
 <20100318160034.GC2269@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100318160034.GC2269@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 18, 2010 at 09:30:34PM +0530, Luis R. Rodriguez wrote:
> On Wed, Mar 17, 2010 at 11:37:29PM -0700, selvam wrote:
> > Hi,
> > 
> > The 4 ms frame length table is updated to support up to MCS 31.
> > 
> > These values are calculated based on the equation 9.1 from the IEEE 802.11n standard.
> > These values are rounded off to multiple of 4 bytes. If the final value is greater than 65535 then it is changed to 65532, since the maximum A-MPDU length is 65535 bytes.
> 
> Thanks for this patch, but can you elaborate on what your patch does other
> than the above. For example, you may want to mention that although the current
> ath9k driver does not support up to MCS31 your patch would enable such support
> for future chipsets which could be supported. You also forgot to Signed-off-by
> it, and provide a clearer commit log entry. Check git log for examples on
> wireless-testing, also read:
> 

Also, rate control component of ath9k is not generic, it is specific
to ath9k. So this sort of patches make sense only when ath9k supports hw with
three chains, currently ath9k does not have support for those hw.

Vasanth
