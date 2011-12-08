Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25669 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1LHGCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 01:02:38 -0500
Date: Thu, 8 Dec 2011 11:32:01 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath9k: Restore EEPROM regulatory upon STA disconnect
Message-ID: <20111208060159.GA18304@vmraj-lnx.users.atheros.com> (sfid-20111208_070250_189623_36D348C1)
References: <1323266001-12912-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1323266001-12912-3-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB=NE6XJMvmcgcz_whsVFbe+T1k_KEnW-ZOrC1K-1bZU+R_shg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAB=NE6XJMvmcgcz_whsVFbe+T1k_KEnW-ZOrC1K-1bZU+R_shg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 01:37:49PM -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 7, 2011 at 5:53 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > The current regulatory for world roaming mode cards might be
> > overriden by country IE from the assiciated AP. But these
> > regulatory values are failed to be restored on disconnection.
> > This patch ensures to resotre regulatry values at driver side.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/main.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index 424289f..a4dbb7b 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -2046,6 +2046,14 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
> >                sc->sc_flags &= ~SC_OP_ANI_RUN;
> >                del_timer_sync(&common->ani.timer);
> >                memset(&sc->caldata, 0, sizeof(sc->caldata));
> > +               /*
> > +                * Restore regulatory values that might be updated
> > +                * by country IEs.
> > +                */
> > +               if (!ath_is_world_regd(&common->regulatory) &&
> > +                   ath_is_world_regd(&common->reg_world_copy))
> > +                       memcpy(&common->regulatory, &common->reg_world_copy,
> > +                              sizeof(struct ath_regulatory));
> >        }
> 
> NACK, this patch should not be required given that patch [2/4] in this
> series restores this on the reg_notifier() for the
> NL80211_REGDOM_SET_BY_CORE case -- the trick is that when cfg80211
> detects not only a disconnect, but any regulatory restore, it will
> *always* send a reg core hint! Again the hunk from patch [2/4] was:
> 
> @@ -363,14 +381,37 @@ int ath_reg_notifier_apply(struct wiphy *wiphy,
>                return 0;
> 
>        switch (request->initiator) {
> -       case NL80211_REGDOM_SET_BY_DRIVER:
>        case NL80211_REGDOM_SET_BY_CORE:
> +               /*
> +                * If common->reg_world_copy is world roaming it means we *were*
> +                * world roaming... so we now have to restore that data.
> +                */
> +               if (!ath_is_world_regd(&common->reg_world_copy))
> +                       break;
> +
> +               memcpy(reg, &common->reg_world_copy,
> +                      sizeof(struct ath_regulatory));
> +               break;
> +       case NL80211_REGDOM_SET_BY_DRIVER:
>        case NL80211_REGDOM_SET_BY_USER:
>                break;
> 
> Can you please test without this patch and ensure you get the data
> properly restored?
> 
But the regulatory updates are ignored for CUSTOM_REGULATORY cards
at wiphy_update_regulatory. Isn't it?

        if (initiator == NL80211_REGDOM_SET_BY_CORE &&
            wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
                REG_DBG_PRINT("Ignoring regulatory request %s "
                              "since the driver uses its own custom "
                              "regulatory domain\n",
                              reg_initiator_name(initiator));
                return true;

To ensure that the regulatory is restored always, I did it at bss_info_change.

--
Rajkumar
