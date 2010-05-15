Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44447 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0EOAeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 20:34:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 17:34:11 -0700
Date: Fri, 14 May 2010 17:34:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"bob@bobcopeland.com" <bob@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
Subject: Re: [PATCH] ath5k: consistently use rx_bufsize for RX DMA
Message-ID: <20100515003408.GG28198@tux>
References: <20100514074833.10333.81592.stgit@tt-desk>
 <AANLkTik2XPwhtUkDo7gfJTVI401HG6qU_mYvGmKfEbG5@mail.gmail.com>
 <201005150705.22887.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201005150705.22887.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 14, 2010 at 03:05:22PM -0700, Bruno Randolf wrote:
> On Saturday 15 May 2010 01:04:34 Luis R. Rodriguez wrote:
> > On Fri, May 14, 2010 at 12:50 AM, Bruno Randolf <br1@einfach.org> wrote:
> > > We should use the same buffer size we set up for DMA also in the hardware
> > > descriptor. Previously we used common->rx_bufsize for setting up the DMA
> > > mapping, but skb_tailroom(skb) for the size we tell to the hardware in
> > > the descriptor itself. The problem is that skb_tailroom(skb) can give us
> > > a larger value than the size we set up for DMA before: In my case
> > > rx_bufsize is 2528, and we allocated an skb of 2559 bytes length,
> > > including padding for cache alignment, but sbk_tailroom() was 2592. Just
> > > consistently use rx_bufsize for all RX DMA memory sizes.
> > > 
> > > Also check the return value of setup function.
> > > 
> > > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > Cc: stable?
> 
> might be useful. i just would like some review before that.

FWIW

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

> > Is that other bug reproducible, can the user test this to cure it?
> 
> not sure. seems like he can with running kismet for a few hours (i'm doing the 
> same over the weekend). i doubt that this is "the" bug though... 

Oh I'm not assuming it is, but it still looks like a valid stable bug fix to me.

  Luis
