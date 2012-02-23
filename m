Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56308 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2BWKlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:41:36 -0500
Received: by vbjk17 with SMTP id k17so719496vbj.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 02:41:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329992887-4442-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1329992887-4442-1-git-send-email-zefir.kurtisi@neratec.com>
Date: Thu, 23 Feb 2012 16:11:35 +0530
Message-ID: <CAD2nsn0_PwPLSQfVizz6CBkBGag7T__eynbG=bvwAdJjSLfLow@mail.gmail.com> (sfid-20120223_114139_443895_DD8D2E4C)
Subject: Re: [PATCH] ath9k: fix PHY error accounting in debugfs
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Zefir,

On Thu, Feb 23, 2012 at 3:58 PM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> ath9k_phyerr are defined as index but have been treated as bitmask
> (with an outdated mask used) for counting PHY errors in debugfs.
> ---
>  drivers/net/wireless/ath/ath9k/debug.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 68d972b..3be5b83 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -1049,8 +1049,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
>  #define RX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].rs\
>                        [sc->debug.rsidx].c)
>
> -       u32 phyerr;
> -
>        RX_STAT_INC(rx_pkts_all);
>        sc->debug.stats.rxstats.rx_bytes_all += rs->rs_datalen;
>
> @@ -1068,9 +1066,11 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
>                RX_STAT_INC(decrypt_busy_err);
>
>        if (rs->rs_status & ATH9K_RXERR_PHY) {
> +               u32 phyerr;
>                RX_STAT_INC(phy_err);
> -               phyerr = rs->rs_phyerr & 0x24;
> -               RX_PHY_ERR_INC(phyerr);
> +               phyerr = rs->rs_phyerr;
> +               if (phyerr < ATH9K_PHYERR_MAX)
> +                       RX_PHY_ERR_INC(phyerr);
>        }
>
>        sc->debug.stats.rxstats.rs_rssi_ctl0 = rs->rs_rssi_ctl0;
> --


very recently fixed by
http://www.spinics.net/lists/linux-wireless/msg85034.html

-- 
thanks,
shafi
