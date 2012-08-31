Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63535 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2HaFpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 01:45:36 -0400
Received: by obbuo13 with SMTP id uo13so4837529obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2012 22:45:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345728238-5313-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1345728238-5313-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Fri, 31 Aug 2012 11:15:36 +0530
Message-ID: <CAD2nsn1SJOtfr8SFE8OP+4d==K9gp_EHWH+8kKquvxoa1paTRg@mail.gmail.com> (sfid-20120831_074540_415881_AF1EB69D)
Subject: Re: [PATCH 1/6] ath9k: Cleanup add/change_interface callbacks
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Thu, Aug 23, 2012 at 6:53 PM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> *Remove all the checks that will be handled by cfg80211
> based on the interface combination advertised. For instance,
> driver supports at the maximum 8 beaconing interface, while
> we advertise maximum 8 beaconing interface in the interface
> combination support.
>
> *cfg80211 will take care of not allowing
> us to add an interface that is not supported by the
> driver, further if the change_interface changes the
> old interface to a beaconing interface while we had
> reached the max limit of 8 beaconing interface, again
> cfg80211 takes care of this stuff!
> So remove all these checks.
>
> *Beautify placing PS wrappers in the appropriate
> position.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |   57 ++++++---------------------------
>  1 files changed, 10 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 8a2b04d..d308b44 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -986,47 +986,21 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
>         struct ath_softc *sc = hw->priv;
>         struct ath_hw *ah = sc->sc_ah;
>         struct ath_common *common = ath9k_hw_common(ah);
> -       int ret = 0;
>
> -       ath9k_ps_wakeup(sc);
>         mutex_lock(&sc->mutex);
>
> -       switch (vif->type) {
> -       case NL80211_IFTYPE_STATION:
> -       case NL80211_IFTYPE_WDS:
> -       case NL80211_IFTYPE_ADHOC:
> -       case NL80211_IFTYPE_AP:
> -       case NL80211_IFTYPE_MESH_POINT:
> -               break;
> -       default:
> -               ath_err(common, "Interface type %d not yet supported\n",
> -                       vif->type);
> -               ret = -EOPNOTSUPP;
> -               goto out;
> -       }
> -
> -       if (ath9k_uses_beacons(vif->type)) {
> -               if (sc->nbcnvifs >= ATH_BCBUF) {
> -                       ath_err(common, "Not enough beacon buffers when adding"
> -                               " new interface of type: %i\n",
> -                               vif->type);
> -                       ret = -ENOBUFS;
> -                       goto out;
> -               }
> -       }
> -
>         ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
> -
>         sc->nvifs++;
>
> +       ath9k_ps_wakeup(sc);
>         ath9k_calculate_summary_state(hw, vif);
> +       ath9k_ps_restore(sc);
> +
>         if (ath9k_uses_beacons(vif->type))
>                 ath9k_beacon_assign_slot(sc, vif);
>
> -out:
>         mutex_unlock(&sc->mutex);
> -       ath9k_ps_restore(sc);
> -       return ret;
> +       return 0;
>  }
>
>  static int ath9k_change_interface(struct ieee80211_hw *hw,
> @@ -1036,21 +1010,9 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
>  {
>         struct ath_softc *sc = hw->priv;
>         struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> -       int ret = 0;
>
>         ath_dbg(common, CONFIG, "Change Interface\n");
> -
>         mutex_lock(&sc->mutex);
> -       ath9k_ps_wakeup(sc);
> -
> -       if (ath9k_uses_beacons(new_type) &&
> -           !ath9k_uses_beacons(vif->type)) {
> -               if (sc->nbcnvifs >= ATH_BCBUF) {
> -                       ath_err(common, "No beacon slot available\n");
> -                       ret = -ENOBUFS;
> -                       goto out;
> -               }
> -       }
>
>         if (ath9k_uses_beacons(vif->type))
>                 ath9k_beacon_remove_slot(sc, vif);
> @@ -1058,14 +1020,15 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
>         vif->type = new_type;
>         vif->p2p = p2p;
>
> +       ath9k_ps_wakeup(sc);
>         ath9k_calculate_summary_state(hw, vif);
> +       ath9k_ps_restore(sc);
> +
>         if (ath9k_uses_beacons(vif->type))
>                 ath9k_beacon_assign_slot(sc, vif);
>
> -out:
> -       ath9k_ps_restore(sc);
>         mutex_unlock(&sc->mutex);
> -       return ret;
> +       return 0;
>  }
>
>  static void ath9k_remove_interface(struct ieee80211_hw *hw,
> @@ -1076,7 +1039,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
>
>         ath_dbg(common, CONFIG, "Detach Interface\n");
>
> -       ath9k_ps_wakeup(sc);
>         mutex_lock(&sc->mutex);
>
>         sc->nvifs--;
> @@ -1084,10 +1046,11 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
>         if (ath9k_uses_beacons(vif->type))
>                 ath9k_beacon_remove_slot(sc, vif);
>
> +       ath9k_ps_wakeup(sc);
>         ath9k_calculate_summary_state(hw, NULL);
> +       ath9k_ps_restore(sc);
>
>         mutex_unlock(&sc->mutex);
> -       ath9k_ps_restore(sc);
>  }
>
>  static void ath9k_enable_ps(struct ath_softc *sc)


please wait, will send a v2 version for patches 1 to 6 (including
Antonio's ath9k_htc change
for coexisting IBSS interface change( need to verify that there are no issues)).

> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
