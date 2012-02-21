Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53289 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2BUKgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 05:36:36 -0500
Received: by vcge1 with SMTP id e1so4143415vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 02:36:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20291.25164.964886.579625@gargle.gargle.HOWL>
References: <20291.25164.964886.579625@gargle.gargle.HOWL>
Date: Tue, 21 Feb 2012 16:06:35 +0530
Message-ID: <CAD2nsn0CUfp8OJSGGS=f+7N-RpemawgJxRhmv_aDMkVBxi9ZHQ@mail.gmail.com> (sfid-20120221_113640_495348_451F9772)
Subject: Re: [RFC/WIP 03/22] ath9k: Initialize MCI params using a helper
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,
On Tue, Feb 21, 2012 at 2:52 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/btcoex.c |   24 ++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/btcoex.h |    1 +
>  drivers/net/wireless/ath/ath9k/init.c   |   23 ++---------------------
>  3 files changed, 27 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
> index a6712a9..6566952 100644
> --- a/drivers/net/wireless/ath/ath9k/btcoex.c
> +++ b/drivers/net/wireless/ath/ath9k/btcoex.c
> @@ -152,6 +152,30 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
>  }
>  EXPORT_SYMBOL(ath9k_hw_btcoex_init_3wire);
>
> +void ath9k_hw_btcoex_init_mci(struct ath_hw *ah)
> +{
> +       ah->btcoex_hw.mci.ready = false;
> +       ah->btcoex_hw.mci.bt_state = 0;
> +       ah->btcoex_hw.mci.bt_ver_major = 3;
> +       ah->btcoex_hw.mci.bt_ver_minor = 0;
> +       ah->btcoex_hw.mci.bt_version_known = false;
> +       ah->btcoex_hw.mci.update_2g5g = true;
> +       ah->btcoex_hw.mci.is_2g = true;
> +       ah->btcoex_hw.mci.wlan_channels_update = false;
> +       ah->btcoex_hw.mci.wlan_channels[0] = 0x00000000;
> +       ah->btcoex_hw.mci.wlan_channels[1] = 0xffffffff;
> +       ah->btcoex_hw.mci.wlan_channels[2] = 0xffffffff;
> +       ah->btcoex_hw.mci.wlan_channels[3] = 0x7fffffff;
> +       ah->btcoex_hw.mci.query_bt = true;
> +       ah->btcoex_hw.mci.unhalt_bt_gpm = true;
> +       ah->btcoex_hw.mci.halted_bt_gpm = false;
> +       ah->btcoex_hw.mci.need_flush_btinfo = false;
> +       ah->btcoex_hw.mci.wlan_cal_seq = 0;
> +       ah->btcoex_hw.mci.wlan_cal_done = 0;
> +       ah->btcoex_hw.mci.config = 0x2201;
> +}
> +EXPORT_SYMBOL(ath9k_hw_btcoex_init_mci);
> +
>  static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
>  {
>        struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
> diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
> index 0cb7ce9..0cb15cd 100644
> --- a/drivers/net/wireless/ath/ath9k/btcoex.h
> +++ b/drivers/net/wireless/ath/ath9k/btcoex.h
> @@ -99,6 +99,7 @@ struct ath_btcoex_hw {
>
>  void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
>  void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
> +void ath9k_hw_btcoex_init_mci(struct ath_hw *ah);
>  void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
>  void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
>                                u32 bt_weight,
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 53a005d..a944fc9 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -449,27 +449,8 @@ static int ath9k_init_btcoex(struct ath_softc *sc)
>                if (r)
>                        return r;
>
> -               if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
> -                       ah->btcoex_hw.mci.ready = false;
> -                       ah->btcoex_hw.mci.bt_state = 0;
> -                       ah->btcoex_hw.mci.bt_ver_major = 3;
> -                       ah->btcoex_hw.mci.bt_ver_minor = 0;
> -                       ah->btcoex_hw.mci.bt_version_known = false;
> -                       ah->btcoex_hw.mci.update_2g5g = true;
> -                       ah->btcoex_hw.mci.is_2g = true;
> -                       ah->btcoex_hw.mci.wlan_channels_update = false;
> -                       ah->btcoex_hw.mci.wlan_channels[0] = 0x00000000;
> -                       ah->btcoex_hw.mci.wlan_channels[1] = 0xffffffff;
> -                       ah->btcoex_hw.mci.wlan_channels[2] = 0xffffffff;
> -                       ah->btcoex_hw.mci.wlan_channels[3] = 0x7fffffff;
> -                       ah->btcoex_hw.mci.query_bt = true;
> -                       ah->btcoex_hw.mci.unhalt_bt_gpm = true;
> -                       ah->btcoex_hw.mci.halted_bt_gpm = false;
> -                       ah->btcoex_hw.mci.need_flush_btinfo = false;
> -                       ah->btcoex_hw.mci.wlan_cal_seq = 0;
> -                       ah->btcoex_hw.mci.wlan_cal_done = 0;
> -                       ah->btcoex_hw.mci.config = 0x2201;
> -               }
> +               ath9k_hw_btcoex_init_mci(ah);
> +
>                break;
>        default:
>                WARN_ON(1);
> --
> 1.7.9.1

thanks, could not remember why we kept it here itself.

-- 
thanks,
shafi
