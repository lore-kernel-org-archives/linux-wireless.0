Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:51124 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0ENWN2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 18:13:28 -0400
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] ath5k: consistently use rx_bufsize for RX DMA
Date: Sat, 15 May 2010 07:05:22 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	bob@bobcopeland.com, ath5k-devel@lists.ath5k.org
References: <20100514074833.10333.81592.stgit@tt-desk> <AANLkTik2XPwhtUkDo7gfJTVI401HG6qU_mYvGmKfEbG5@mail.gmail.com>
In-Reply-To: <AANLkTik2XPwhtUkDo7gfJTVI401HG6qU_mYvGmKfEbG5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005150705.22887.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 15 May 2010 01:04:34 Luis R. Rodriguez wrote:
> On Fri, May 14, 2010 at 12:50 AM, Bruno Randolf <br1@einfach.org> wrote:
> > We should use the same buffer size we set up for DMA also in the hardware
> > descriptor. Previously we used common->rx_bufsize for setting up the DMA
> > mapping, but skb_tailroom(skb) for the size we tell to the hardware in
> > the descriptor itself. The problem is that skb_tailroom(skb) can give us
> > a larger value than the size we set up for DMA before: In my case
> > rx_bufsize is 2528, and we allocated an skb of 2559 bytes length,
> > including padding for cache alignment, but sbk_tailroom() was 2592. Just
> > consistently use rx_bufsize for all RX DMA memory sizes.
> > 
> > Also check the return value of setup function.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> 
> Cc: stable?

might be useful. i just would like some review before that.

> Is that other bug reproducible, can the user test this to cure it?

not sure. seems like he can with running kismet for a few hours (i'm doing the 
same over the weekend). i doubt that this is "the" bug though... a) because 
the bug on ath5k and ath9k are so similar and b) because we see the beginning 
of packets. rather looks like the next pointer of the descriptor is pointing 
to somewhere it shouldnt, sometimes? (guessing)

bruno
