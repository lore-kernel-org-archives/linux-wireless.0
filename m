Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36131 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcFDRGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 13:06:10 -0400
Received: by mail-it0-f65.google.com with SMTP id i65so1075529ith.3
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jun 2016 10:06:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160603165144.17356-6-toke@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk> <20160603165144.17356-6-toke@toke.dk>
From: Adrian Chadd <adrian@freebsd.org>
Date: Sat, 4 Jun 2016 10:06:08 -0700
Message-ID: <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com> (sfid-20160604_190631_068563_90362BF3)
Subject: Re: [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

I've been working on something similar in freebsd, so cool to see this
happening here!

The only thing missing atm is STBC and LDPC. My RX airtime code looks
basically like this one too; but I have TODO items for ensuring
LDPC/STBC calculations are sane.



-adrian


On 3 June 2016 at 09:51, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> This adds RX airtime to the airtime deficit used in the scheduler. This
> is not a definite win, but I have only done very limited testing where
> it has been included. Feel free to skip this patch when testing.
>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c | 51 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 7eb8980..23d6ebe 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -991,6 +991,55 @@ static void ath9k_apply_ampdu_details(struct ath_softc *sc,
>         }
>  }
>
> +static void ath_rx_count_airtime(struct ath_softc *sc,
> +                                struct ath_rx_status *rs,
> +                                struct sk_buff *skb)
> +{
> +       struct ath_node *an;
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +       struct ath_hw *ah = sc->sc_ah;
> +       struct ath_common *common = ath9k_hw_common(ah);
> +       struct ieee80211_sta *sta;
> +       struct ieee80211_rx_status *rxs;
> +       const struct ieee80211_rate *rate;
> +       bool is_sgi, is_40, is_sp;
> +       int phy;
> +       u32 airtime = 0;
> +
> +       if (!ieee80211_is_data(hdr->frame_control))
> +               return;
> +
> +       rcu_read_lock();
> +
> +       sta = ieee80211_find_sta_by_ifaddr(sc->hw, hdr->addr2, NULL);
> +       if (!sta)
> +               goto exit;
> +       an = (struct ath_node *) sta->drv_priv;
> +       rxs = IEEE80211_SKB_RXCB(skb);
> +
> +       is_sgi = !!(rxs->flag & RX_FLAG_SHORT_GI);
> +       is_40 = !!(rxs->flag & RX_FLAG_40MHZ);
> +       is_sp = !!(rxs->flag & RX_FLAG_SHORTPRE);
> +
> +       if (!!(rxs->flag & RX_FLAG_HT)) {
> +               /* MCS rates */
> +
> +               airtime += ath_pkt_duration(sc, rxs->rate_idx, rs->rs_datalen,
> +                                       is_40, is_sgi, is_sp);
> +       } else {
> +
> +               phy = IS_CCK_RATE(rs->rs_rate) ? WLAN_RC_PHY_CCK : WLAN_RC_PHY_OFDM;
> +               rate = &common->sbands[rxs->band].bitrates[rxs->rate_idx];
> +               airtime += ath9k_hw_computetxtime(ah, phy, rate->bitrate * 100,
> +                                               rs->rs_datalen, rxs->rate_idx, is_sp);
> +       }
> +
> +       an->airtime_deficit -= airtime;
> +       ath_debug_airtime(sc, an, airtime, 0);
> +exit:
> +       rcu_read_unlock();
> +}
> +
>  int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>  {
>         struct ath_rxbuf *bf;
> @@ -1137,7 +1186,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>                 ath9k_antenna_check(sc, &rs);
>                 ath9k_apply_ampdu_details(sc, &rs, rxs);
>                 ath_debug_rate_stats(sc, &rs, skb);
> -               ath_debug_rx_airtime(sc, &rs, skb);
> +               ath_rx_count_airtime(sc, &rs, skb);
>
>                 hdr = (struct ieee80211_hdr *)skb->data;
>                 if (ieee80211_is_ack(hdr->frame_control))
> --
> 2.7.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
