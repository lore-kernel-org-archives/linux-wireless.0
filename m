Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53218 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbZCXAc1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 20:32:27 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 17:32:26 -0700
Date: Mon, 23 Mar 2009 16:31:49 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH v2] ath9k: fix dma mapping leak of rx buffer upon rmmod
Message-ID: <20090323233149.GL5740@tesla> (sfid-20090324_013230_263453_97470AA9)
References: <1237847101-30199-1-git-send-email-lrodriguez@atheros.com> <20090324092128A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090324092128A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:21:28PM -0700, FUJITA Tomonori wrote:
> On Mon, 23 Mar 2009 18:25:01 -0400
> "Luis R. Rodriguez" <lrodriguez@atheros.com> wrote:
> 
> > We were claiming DMA buffers on the RX tasklet but never
> > upon a simple module removal.
> >
> > Cc: stable@kernel.org
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >
> > Sorry, forgot to CC stable
> >
> >  drivers/net/wireless/ath9k/recv.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
> > index 917bac7..71cb18d 100644
> > --- a/drivers/net/wireless/ath9k/recv.c
> > +++ b/drivers/net/wireless/ath9k/recv.c
> > @@ -344,8 +344,13 @@ void ath_rx_cleanup(struct ath_softc *sc)
> >
> >       list_for_each_entry(bf, &sc->rx.rxbuf, list) {
> >               skb = bf->bf_mpdu;
> > -             if (skb)
> > +             if (skb) {
> > +                     dma_unmap_single(sc->dev,
> > +                                      bf->bf_buf_addr,
> > +                                      sc->rx.bufsize,
> > +                                      DMA_FROM_DEVICE);
> >                       dev_kfree_skb(skb);
> > +             }
> >       }
> 
> ath9k uses pci_map/unmap_* families so using dma_map/unmap looks
> inconsistent. It works though.
> 
> I think that my original patch is fine:
> 
> http://marc.info/?l=linux-kernel&m=123725029228065&w=2

Noted -- the ported patch for 2.6.29 will use pci_unmap_single() however
this patch was for 2.6.30 where we now have bus-agnostic routines. To
get a better idea of how this looks feel free to check out ath9k from
the wireless-testing git tree.

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

  Luis
