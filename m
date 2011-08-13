Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1HMSlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:41:52 -0400
Date: Sun, 14 Aug 2011 00:12:13 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] ath9k_hw: Fix exceed transmission burst-time of
 5GHz
Message-ID: <20110813184140.GC16149@vmraj-lnx.users.atheros.com> (sfid-20110813_204156_569446_572BECAE)
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmo=yP7q33FBwDCCnu3f+=E6ONuLK+xj6ye-26bSW_kgtdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAJ-Vmo=yP7q33FBwDCCnu3f+=E6ONuLK+xj6ye-26bSW_kgtdQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 13, 2011 at 06:41:03PM +0800, Adrian Chadd wrote:
> Does ath9k enable the relevant config bit that enforces the TXOP burst
> time on transmissions?
> 
> ie, bit 12 (TXOP_TBTT_LIMIT_ ENABLE) of 0x8120 (MAC_PCU_MISC_MODE).
> 
> FreeBSD doesn't (yet) enable that bit. ath9k doesn't seem to enable
> that bit, either in code or in the ar5008/ar9001/ar9002/ar9003
> initvals.
>
Correct. So the frames that are exceeding txop limit are not filtered.
The issue was originally observed while measuring XPABIAS5 signal of
AR9380 at 5GHz HT20 MCS0. It exceeds the 4ms limit due to WAR delimits.
> What's the hardware doing when that bit isn't enabled? Is it still
> enforcing TXOP limits on TXed frames? I've not (yet) seen it do so.
> 
> I came across this as a "thing to look at" after I finish off 11n TX,
> as I'd like to make sure that both legacy and A-MPDU operation doesn't
> exceed burst TXOP. (It's going to be important not only for QOS
> compliance, but likely for correct/stable TDMA support.)
> 
> Thanks,
> 
> 
> 
> Adrian
> 
> On 13 August 2011 12:58, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> > The WAR which adds extra delimiters when using RTS/CTS
> > with aggregation and non-enterprise AR9003 chips.
> > This extra padding is done after doing all the 4ms limit
> > checks and hence the total aggregate sizes are exceeding
> > the allowed duration. This patch limits the aggregate
> > sizes appropriately after including these extra delimiters.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_mac.c |   28 +-------------------------
> >  drivers/net/wireless/ath/ath9k/xmit.c       |   16 ++++++++++++--
> >  2 files changed, 15 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> > index 1aadc47..81ccce1 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> > @@ -415,36 +415,12 @@ static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
> >  static void ar9003_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
> >                                        u32 aggrLen)
> >  {
> > -#define FIRST_DESC_NDELIMS 60
> >        struct ar9003_txc *ads = (struct ar9003_txc *) ds;
> >
> >        ads->ctl12 |= (AR_IsAggr | AR_MoreAggr);
> >
> > -       if (ah->ent_mode & AR_ENT_OTP_MPSD) {
> > -               u32 ctl17, ndelim;
> > -               /*
> > -                * Add delimiter when using RTS/CTS with aggregation
> > -                * and non enterprise AR9003 card
> > -                */
> > -               ctl17 = ads->ctl17;
> > -               ndelim = MS(ctl17, AR_PadDelim);
> > -
> > -               if (ndelim < FIRST_DESC_NDELIMS) {
> > -                       aggrLen += (FIRST_DESC_NDELIMS - ndelim) * 4;
> > -                       ndelim = FIRST_DESC_NDELIMS;
> > -               }
> > -
> > -               ctl17 &= ~AR_AggrLen;
> > -               ctl17 |= SM(aggrLen, AR_AggrLen);
> > -
> > -               ctl17 &= ~AR_PadDelim;
> > -               ctl17 |= SM(ndelim, AR_PadDelim);
> > -
> > -               ads->ctl17 = ctl17;
> > -       } else {
> > -               ads->ctl17 &= ~AR_AggrLen;
> > -               ads->ctl17 |= SM(aggrLen, AR_AggrLen);
> > -       }
> > +       ads->ctl17 &= ~AR_AggrLen;
> > +       ads->ctl17 |= SM(aggrLen, AR_AggrLen);
> >  }
> >
> >  static void ar9003_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
> > diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> > index e1d1e90..feef013 100644
> > --- a/drivers/net/wireless/ath/ath9k/xmit.c
> > +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> > @@ -644,8 +644,10 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
> >  * meet the minimum required mpdudensity.
> >  */
> >  static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
> > -                                 struct ath_buf *bf, u16 frmlen)
> > +                                 struct ath_buf *bf, u16 frmlen,
> > +                                 bool first_subfrm)
> >  {
> > +#define FIRST_DESC_NDELIMS 60
> >        struct sk_buff *skb = bf->bf_mpdu;
> >        struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
> >        u32 nsymbits, nsymbols;
> > @@ -668,6 +670,13 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
> >                ndelim += ATH_AGGR_ENCRYPTDELIM;
> >
> >        /*
> > +        * Add delimiter when using RTS/CTS with aggregation
> > +        * and non enterprise AR9003 card
> > +        */
> > +       if (first_subfrm)
> > +               ndelim = max(ndelim, FIRST_DESC_NDELIMS);
> > +
> > +       /*
> >         * Convert desired mpdu density from microeconds to bytes based
> >         * on highest rate in rate series (i.e. first rate) to determine
> >         * required minimum length for subframe. Take into account
> > @@ -756,7 +765,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
> >                        status = ATH_AGGR_LIMITED;
> >                        break;
> >                }
> > -               nframes++;
> >
> >                /* add padding for previous frame to aggregation length */
> >                al += bpad + al_delta;
> > @@ -765,9 +773,11 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
> >                 * Get the delimiters needed to meet the MPDU
> >                 * density for this node.
> >                 */
> > -               ndelim = ath_compute_num_delims(sc, tid, bf_first, fi->framelen);
> > +               ndelim = ath_compute_num_delims(sc, tid, bf_first, fi->framelen,
> > +                                               !nframes);
> >                bpad = PADBYTES(al_delta) + (ndelim << 2);
> >
> > +               nframes++;
> >                bf->bf_next = NULL;
> >                ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, 0);
> >
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
