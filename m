Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37900 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab0K2MGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 07:06:25 -0500
Received: by iwn5 with SMTP id 5so73652iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 04:06:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290794073-5309-2-git-send-email-rmanoharan@atheros.com>
References: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
	<1290794073-5309-2-git-send-email-rmanoharan@atheros.com>
Date: Mon, 29 Nov 2010 13:06:23 +0100
Message-ID: <AANLkTikdE_L+4Zxv7qT32P_AmzJ1RHRLRQjftUVpwOUk@mail.gmail.com>
Subject: Re: [PATCH 2/3] ath9k: Add change_interface callback
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 26, 2010 at 6:54 PM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> Add support to change interface type
> without bringing down the interface.
>
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
[snip]
> +static int ath9k_change_interface(struct ieee80211_hw *hw,
> +                                 struct ieee80211_vif *vif,
> +                                 enum nl80211_iftype new_type,
> +                                 bool p2p)
> +{
> +       struct ath_wiphy *aphy = hw->priv;
> +       struct ath_softc *sc = aphy->sc;
> +       struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +
> +       ath_print(common, ATH_DBG_CONFIG, "Change Interface\n");
> +       mutex_lock(&sc->mutex);
> +
> +       new_type = ieee80211_iftype_p2p(new_type, p2p);
> +
> +       switch (new_type) {
> +       case NL80211_IFTYPE_AP:
> +       case NL80211_IFTYPE_ADHOC:
> +               break;

If you have to reclaim beacon in the case where you go from AP -> STA
(replicate remove_interface), don't you have to replicate what
add_interface does in this case, e.g. the check below etc?

                if (sc->nbcnvifs >= ATH_BCBUF) {
                        ret = -ENOBUFS;
                        goto out;
                }

> +       case NL80211_IFTYPE_STATION:
> +               /* Stop ANI */
> +               sc->sc_flags &= ~SC_OP_ANI_RUN;
> +               del_timer_sync(&common->ani.timer);
> +               if ((vif->type == NL80211_IFTYPE_AP) ||
> +                   (vif->type == NL80211_IFTYPE_ADHOC))
> +                       ath9k_reclaim_beacon(sc, vif);
> +               break;
> +       default:
> +               ath_print(common, ATH_DBG_FATAL,
> +                       "Interface type %d not yet supported\n", vif->type);
> +               mutex_unlock(&sc->mutex);
> +               return -ENOTSUPP;
> +       }
> +       vif->type = new_type;
> +
> +       mutex_unlock(&sc->mutex);
> +       return 0;
> +}

Also, doesn't this patch introduce yet another race condition between
configuration change in process context and bcn_tasklet?

/Björn
