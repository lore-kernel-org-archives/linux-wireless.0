Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:34079 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbH1M4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 08:56:08 -0400
Received: by ykba134 with SMTP id a134so888448ykb.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2015 05:56:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
References: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 28 Aug 2015 14:56:07 +0200
Message-ID: <CACKGw+FU0tQ4HZ0O=AB8uo-HyNshr0zjd-Hb+4NytpzsOH4TdQ@mail.gmail.com> (sfid-20150828_145613_566720_0098B671)
Subject: Re: [PATCH 1/2] ath10k: change beamformee VHT STS capability
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2015 at 14:47, Michal Kazior <michal.kazior@tieto.com> wrote:
> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> All beamformee supporting chips have the ability to support
> VHT NDP in up to 4 STSs. Change the published beamformee
> STS cap accordingly to 3 as it should be Nsts-1.
>
> This makes it possible to actually make full use
> of. e.g. a 4SS MU-MIMO capable AP.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Kalle, please drop this one for now. It looks like we need to discuss
about this a bit more still.

>  drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 64674c955d44..54ced30f5364 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4074,7 +4074,7 @@ static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
>
>         if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
>                                 IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE))
> -               value |= SM((ar->num_rf_chains - 1), WMI_TXBF_STS_CAP_OFFSET);
> +               value |= SM(3, WMI_TXBF_STS_CAP_OFFSET);
>
>         if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
>                                 IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE))
> @@ -6804,7 +6804,7 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
>
>         if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
>                                 IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)) {
> -               val = ar->num_rf_chains - 1;
> +               val = 3;
>                 val <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
>                 val &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
>
> --
> 2.1.4
>



-- 
Bartosz
