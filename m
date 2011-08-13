Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31561 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1HMSIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:08:49 -0400
Date: Sat, 13 Aug 2011 23:39:10 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/11] ath9k: Re-enable RXOEL interrupt after processing
 rx buffers
Message-ID: <20110813180910.GB16149@vmraj-lnx.users.atheros.com> (sfid-20110813_200851_862630_552D12A4)
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1313211498-14442-3-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmo=dzs4ZsmXq2C6gCsy+vAgdKAAQ1ZjC2VSPTtfw-aexuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAJ-Vmo=dzs4ZsmXq2C6gCsy+vAgdKAAQ1ZjC2VSPTtfw-aexuA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 13, 2011 at 06:53:12PM +0800, Adrian Chadd wrote:
> .. again, I'll just point out that because I was seeing this when the
> PCU honestly had hit the end of the RX descriptor list (lots of radar
> phyerr frames), I needed to kick the PCU to start again.
> 
so without PCU restart you are still getting rxeol. am i right?
> Are you not seeing this? if not, why are you receiving the interrupt? :-)
>
Under heavy bidi traffic test, RXEOL was observed. But it never be enabled
again after processing rx bufs.
> 
> Adrian
> 
> On 13 August 2011 12:58, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> > Once RXEOL was disabled, it never be enabled again. This patch
> > re-enables rxeol at the end of rx tasklet.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/recv.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> > index 7409402..c0c66e0 100644
> > --- a/drivers/net/wireless/ath/ath9k/recv.c
> > +++ b/drivers/net/wireless/ath/ath9k/recv.c
> > @@ -1978,5 +1978,10 @@ requeue:
> >
> >        spin_unlock_bh(&sc->rx.rxbuflock);
> >
> > +       if (!(ah->imask & ATH9K_INT_RXEOL)) {
> > +               ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
> > +               ath9k_hw_set_interrupts(ah, ah->imask);
> > +       }
> > +
> >        return 0;
> >  }
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
