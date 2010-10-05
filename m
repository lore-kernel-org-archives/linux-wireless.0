Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51860 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab0JEWi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 18:38:56 -0400
Received: by iwn5 with SMTP id 5so8873353iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 15:38:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101005095531.3083.39403.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095531.3083.39403.stgit@tt-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Oct 2010 15:38:34 -0700
Message-ID: <AANLkTimP=R4hsCWU+wP1aemHn1awzNQVWMa-_7OJEQLG@mail.gmail.com>
Subject: Re: [PATCH 5/5] ath5k: Add busy ratios to survey data
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	adrian@freebsd.org, vasanth@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 2:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> Include the channel utilization (busy, rx, tx) in the survey results.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index c158f2e..a33d9f2 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -3008,6 +3008,7 @@ static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
>  {
>        struct ath5k_softc *sc = hw->priv;
>        struct ieee80211_conf *conf = &hw->conf;
> +       struct ath_common *common = ath5k_hw_common(sc->ah);
>
>         if (idx != 0)
>                return -ENOENT;
> @@ -3016,6 +3017,22 @@ static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
>        survey->filled = SURVEY_INFO_NOISE_DBM;
>        survey->noise = sc->ah->ah_noise_floor;
>
> +       ath_hw_cycle_counters_lock(common);
> +       ath_hw_cycle_counters_update(common);
> +       if (common->cc_survey.cycles > 0) {
> +               survey->filled |= SURVEY_INFO_BUSY |
> +                               SURVEY_INFO_BUSY_TX | SURVEY_INFO_BUSY_RX;
> +               survey->busy = common->cc_survey.rx_busy * 255 /
> +                                       common->cc_survey.cycles;
> +               survey->busy_tx = common->cc_survey.tx_frame * 255 /
> +                                       common->cc_survey.cycles;
> +               survey->busy_rx = common->cc_survey.rx_frame * 255 /
> +                                       common->cc_survey.cycles;
> +       }
> +
> +       memset(&common->cc_survey, 0, sizeof(struct ath_cycle_counters));
> +       ath_hw_cycle_counters_unlock(common);
> +

This is all being sucked out of common, so can we just share the
filler for the survey between ath5k and ath9k? Note we should split up
hw code and core driver code on the ath module by file.

  Luis
