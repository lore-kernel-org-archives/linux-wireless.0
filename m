Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:26315 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbaE2JcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 05:32:24 -0400
Date: Thu, 29 May 2014 15:03:03 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix interface combinations for multi-channel
 concurrency
Message-ID: <20140529093301.GA13680@qca.qualcomm.com> (sfid-20140529_113228_164992_8E5D1222)
References: <1401346141-9888-1-git-send-email-rmanohar@qti.qualcomm.com>
 <CAGRGNgWo8AvT=hUmhR2AKr6xksw5CFFApj3eEX1nd+J=RrENpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAGRGNgWo8AvT=hUmhR2AKr6xksw5CFFApj3eEX1nd+J=RrENpw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2014 at 05:18:54PM +1000, Julian Calaby wrote:
> Hi Rajkumar,
> 
> On Thu, May 29, 2014 at 4:49 PM, Rajkumar Manoharan
> <rmanohar@qti.qualcomm.com> wrote:
> > Currently mac80211 does not support WDS and DFS with channel context
> > drivers. So advertise these features only when the driver is not
> > supporting channel context and modparam "use_chanctx" is introduced
> > for preparing channel context support in ath9k.
> >
> > @@ -722,12 +736,15 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
> >                         BIT(NL80211_IFTYPE_P2P_GO) |
> >                         BIT(NL80211_IFTYPE_P2P_CLIENT) |
> >                         BIT(NL80211_IFTYPE_AP) |
> > -                       BIT(NL80211_IFTYPE_WDS) |
> >                         BIT(NL80211_IFTYPE_STATION) |
> >                         BIT(NL80211_IFTYPE_ADHOC) |
> >                         BIT(NL80211_IFTYPE_MESH_POINT);
> >                 hw->wiphy->iface_combinations = if_comb;
> > -               hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
> > +               if (!ath9k_use_chanctx) {
> > +                       hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
> > +                       hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_WDS);
> > +               } else
> > +                       hw->wiphy->n_iface_combinations = 1;
> 
> Is that right?
> 
Julian,

Right now mcc support is not implemented in ath9k and am working on that.
Once all channel context callbacks are added, iface_combinations will
refer to right interface set.

-Rajkumar
