Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37819 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab1JCS17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 14:27:59 -0400
Received: by qadb15 with SMTP id b15so1790110qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 11:27:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317637758-11907-6-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <1317637758-11907-6-git-send-email-zefir.kurtisi@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 3 Oct 2011 11:27:39 -0700
Message-ID: <CAB=NE6VO4W=ZJcgb3G5Gh=YM-jdkJ3ey5Ppka2Rn0XGmpx8=Gg@mail.gmail.com> (sfid-20111003_202808_974636_5AE91ECE)
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index e8aeb98..5defebe 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>                        "Unable to reset channel, reset status %d\n", r);
>                goto out;
>        }
> +#ifdef CONFIG_ATH9K_DFS
> +       /**
> +        * enable radar pulse detection
> +        *
> +        * TODO: do this only for DFS channels
> +        */
> +       ah->private_ops.set_radar_params(ah, &ah->radar_conf);
> +       ath9k_hw_setrxfilter(ah,
> +                       ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
> +       ath_dbg(common, ATH_DBG_DFS,
> +               "DFS enabled for channel %d\n", hchan->chan->center_freq);
> +#endif

Please spare the #ifdef and just call something within dfs.c, then
dfs.h would wrap it to nothing if DFS is disabled.

  Luis
