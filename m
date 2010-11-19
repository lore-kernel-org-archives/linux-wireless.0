Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59773 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0KSM3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 07:29:09 -0500
Received: by qyk7 with SMTP id 7so202020qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 04:29:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101019075654.19979.9679.stgit@localhost6.localdomain6>
References: <20101019075648.19979.42181.stgit@localhost6.localdomain6> <20101019075654.19979.9679.stgit@localhost6.localdomain6>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Fri, 19 Nov 2010 22:28:52 +1000
Message-ID: <AANLkTimPEAXpvdp2-MMA65=dO_-YZzcS9VbWCNOhVO1q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath5k: Add channel time to survey data
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure if I'm understanding the way the data is represented. I'm
pulling it via nl80211 (or even if just using iw to poll the values
regularly). They just appear to go back and forwards in time, as well
as being very large values. Am I missing something? Is the count not
supposed to be the amount of time for the measure since the card was
brought up?

Also, what does the 'channel time' value actually mean by 'time the
station spent on this channel'? How is this different to the 'Channel
busy time'? If it's not just busy time, but time the station was
locked on this channel, why is the value FAR smaller than the channel
busy time...?

Thanks,

--
Jonathan Guerin



On Tue, Oct 19, 2010 at 5:56 PM, Bruno Randolf <br1@einfach.org> wrote:
> Include the channel utilization (busy, rx, tx) in the survey results.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   20 +++++++++++++++++++-
>  1 files changed, 19 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 8251946..484aad5 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -3206,14 +3206,32 @@ static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
>  {
>        struct ath5k_softc *sc = hw->priv;
>        struct ieee80211_conf *conf = &hw->conf;
> +       struct ath_common *common = ath5k_hw_common(sc->ah);
> +       struct ath_cycle_counters *cc = &common->cc_survey;
> +       unsigned int div = common->clockrate * 1000;
>
> -        if (idx != 0)
> +       if (idx != 0)
>                return -ENOENT;
>
>        survey->channel = conf->channel;
>        survey->filled = SURVEY_INFO_NOISE_DBM;
>        survey->noise = sc->ah->ah_noise_floor;
>
> +       spin_lock_bh(&common->cc_lock);
> +       ath_hw_cycle_counters_update(common);
> +       if (cc->cycles > 0) {
> +               survey->filled |= SURVEY_INFO_CHANNEL_TIME |
> +                       SURVEY_INFO_CHANNEL_TIME_BUSY |
> +                       SURVEY_INFO_CHANNEL_TIME_RX |
> +                       SURVEY_INFO_CHANNEL_TIME_TX;
> +               survey->channel_time += cc->cycles / div;
> +               survey->channel_time_busy += cc->rx_busy / div;
> +               survey->channel_time_rx += cc->rx_frame / div;
> +               survey->channel_time_tx += cc->tx_frame / div;
> +       }
> +       memset(cc, 0, sizeof(*cc));
> +       spin_unlock_bh(&common->cc_lock);
> +
>        return 0;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
