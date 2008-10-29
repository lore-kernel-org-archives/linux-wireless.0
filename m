Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:17066 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYJ2JL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 05:11:27 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3197738rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 02:11:26 -0700 (PDT)
Message-ID: <1ba2fa240810290211s16f5506cgf7c828b5c3d8aea9@mail.gmail.com> (sfid-20081029_101145_640033_AD995EBB)
Date: Wed, 29 Oct 2008 11:11:26 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 16/16] mac80211: Add a new event in ieee80211_ampdu_mlme_action
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com,
	johannes@sipsolutions.net
In-Reply-To: <18695.60248.383916.563413@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18695.60248.383916.563413@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 6:49 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Send a notification to the driver on succesful
> reception of an ADDBA response, add IEEE80211_AMPDU_TX_RESUME
> for this purpose.

What what is wrong with IEEE80211_AMPDU_TX_START ? I don' t understand
why this is needed?
Tomas
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath9k/core.h |    1 +
>  drivers/net/wireless/ath9k/main.c |    3 +++
>  drivers/net/wireless/ath9k/xmit.c |   19 +++++++++++++++++++
>  include/net/mac80211.h            |    2 ++
>  net/mac80211/ht.c                 |   10 +++++++++-
>  5 files changed, 34 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
> index 5b17e88..69e8d3e 100644
> --- a/drivers/net/wireless/ath9k/core.h
> +++ b/drivers/net/wireless/ath9k/core.h
> @@ -581,6 +581,7 @@ void ath_tx_aggr_teardown(struct ath_softc *sc,
>  int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
>                      u16 tid, u16 *ssn);
>  int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
> +void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
>  void ath_newassoc(struct ath_softc *sc,
>        struct ath_node *node, int isnew, int isuapsd);
>  void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta);
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index 376c530..5d07952 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -1484,6 +1484,9 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
>
>                ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
>                break;
> +       case IEEE80211_AMPDU_TX_RESUME:
> +               ath_tx_aggr_resume(sc, sta, tid);
> +               break;
>        default:
>                DPRINTF(sc, ATH_DBG_FATAL,
>                        "%s: Unknown AMPDU action\n", __func__);
> diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
> index 7e6f4e5..fe386b6 100644
> --- a/drivers/net/wireless/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath9k/xmit.c
> @@ -2371,6 +2371,25 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
>        return 0;
>  }
>
> +/* Resume tx aggregation */
> +
> +void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
> +{
> +       struct ath_atx_tid *txtid;
> +       struct ath_node *an;
> +
> +       an = (struct ath_node *)sta->drv_priv;
> +
> +       if (sc->sc_flags & SC_OP_TXAGGR) {
> +               txtid = ATH_AN_2_TID(an, tid);
> +               txtid->baw_size =
> +                       IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
> +               txtid->state |= AGGR_ADDBA_COMPLETE;
> +               txtid->state &= ~AGGR_ADDBA_PROGRESS;
> +               ath_tx_resume_tid(sc, txtid);
> +       }
> +}
> +
>  /*
>  * Performs transmit side cleanup when TID changes from aggregated to
>  * unaggregated.
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 0b983be..4051f0a 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1136,12 +1136,14 @@ enum ieee80211_filter_flags {
>  * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
>  * @IEEE80211_AMPDU_TX_START: start Tx aggregation
>  * @IEEE80211_AMPDU_TX_STOP: stop Tx aggregation
> + * @IEEE80211_AMPDU_TX_RESUME: resume TX aggregation
>  */
>  enum ieee80211_ampdu_mlme_action {
>        IEEE80211_AMPDU_RX_START,
>        IEEE80211_AMPDU_RX_STOP,
>        IEEE80211_AMPDU_TX_START,
>        IEEE80211_AMPDU_TX_STOP,
> +       IEEE80211_AMPDU_TX_RESUME,
>  };
>
>  /**
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index 1453cb5..0ffbe12 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -995,7 +995,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>  {
>        struct ieee80211_hw *hw = &local->hw;
>        u16 capab;
> -       u16 tid;
> +       u16 tid, start_seq_num;
>        u8 *state;
>
>        capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
> @@ -1032,6 +1032,14 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>                    local->hw.ampdu_queues)
>                        ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
>
> +               if (local->ops->ampdu_action) {
> +                       (void)local->ops->ampdu_action(hw,
> +                                              IEEE80211_AMPDU_TX_RESUME,
> +                                              &sta->sta, tid, &start_seq_num);
> +               }
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +               printk(KERN_DEBUG "Resuming TX aggregation for tid %d\n", tid);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
>                spin_unlock_bh(&sta->lock);
>        } else {
>                sta->ampdu_mlme.addba_req_num[tid]++;
> --
> 1.6.0.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
