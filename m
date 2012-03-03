Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56855 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2CCOq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:46:57 -0500
Received: by vbbff1 with SMTP id ff1so2298252vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 06:46:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330784226-65563-3-git-send-email-nbd@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
	<1330784226-65563-2-git-send-email-nbd@openwrt.org>
	<1330784226-65563-3-git-send-email-nbd@openwrt.org>
Date: Sat, 3 Mar 2012 20:16:56 +0530
Message-ID: <CAD2nsn2N2Ei2GTHc-_8hQ1h-jOy7jo3FM-Cn7i2T5t-eviCMZA@mail.gmail.com> (sfid-20120303_154701_154448_FCAB2CCB)
Subject: Re: [PATCH 3/5] ath9k: remove rssi/antenna information from recv
 debug stats
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 3, 2012 at 7:47 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> The way this is implemented (simply storing the last value) is absolutely
> worthless for debugging anything, and the same information is also available
> through the MAC sample feature, so there's no point in keeping this around.

:) :)  please keep this, we were debugging antenna diversity related
issues in AR9485 with this stats. the antenna switching never
happened, then with these stats we found that the rss1 seems to be
always negative, same result with the windows driver also, then later
found its a EEPROM related issue.

>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/debug.c |   31 -------------------------------
>  drivers/net/wireless/ath/ath9k/debug.h |    7 -------
>  2 files changed, 0 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 03a4740..c2edf68 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -944,27 +944,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
>        PHY_ERR("HT-RATE ERR", ATH9K_PHYERR_HT_RATE_ILLEGAL);
>
>        len += snprintf(buf + len, size - len,
> -                       "%22s : %10d\n", "RSSI-CTL0",
> -                       sc->debug.stats.rxstats.rs_rssi_ctl0);
> -       len += snprintf(buf + len, size - len,
> -                       "%22s : %10d\n", "RSSI-CTL1",
> -                       sc->debug.stats.rxstats.rs_rssi_ctl1);
> -       len += snprintf(buf + len, size - len,
> -                       "%22s : %10d\n", "RSSI-CTL2",
> -                       sc->debug.stats.rxstats.rs_rssi_ctl2);
> -       len += snprintf(buf + len, size - len,
> -                       "%22s : %10d\n", "RSSI-EXT0",
> -                       sc->debug.stats.rxstats.rs_rssi_ext0);
> -       len += snprintf(buf + len, size - len,
> -                       "%22s : %10d\n", "RSSI-EXT1",
> -                       sc->debug.stats.rxstats.rs_rssi_ext1);
> -       len += snprintf(buf + len, size - len,
> -                       "%22s : %10d\n", "RSSI-EXT2",
> -                       sc->debug.stats.rxstats.rs_rssi_ext2);
> -       len += snprintf(buf + len, size - len,
> -                       "%22s : %10d\n", "Rx Antenna",
> -                       sc->debug.stats.rxstats.rs_antenna);
> -       len += snprintf(buf + len, size - len,
>                        "%22s : %10u\n", "RX-Pkts-All",
>                        sc->debug.stats.rxstats.rx_pkts_all);
>        len += snprintf(buf + len, size - len,
> @@ -1011,16 +990,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
>                        RX_PHY_ERR_INC(rs->rs_phyerr);
>        }
>
> -       sc->debug.stats.rxstats.rs_rssi_ctl0 = rs->rs_rssi_ctl0;
> -       sc->debug.stats.rxstats.rs_rssi_ctl1 = rs->rs_rssi_ctl1;
> -       sc->debug.stats.rxstats.rs_rssi_ctl2 = rs->rs_rssi_ctl2;
> -
> -       sc->debug.stats.rxstats.rs_rssi_ext0 = rs->rs_rssi_ext0;
> -       sc->debug.stats.rxstats.rs_rssi_ext1 = rs->rs_rssi_ext1;
> -       sc->debug.stats.rxstats.rs_rssi_ext2 = rs->rs_rssi_ext2;
> -
> -       sc->debug.stats.rxstats.rs_antenna = rs->rs_antenna;
> -
>  #ifdef CONFIG_ATH9K_MAC_DEBUG
>        spin_lock(&sc->debug.samp_lock);
>        RX_SAMP_DBG(jiffies) = jiffies;
> diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
> index 7a51958..64fcfad 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.h
> +++ b/drivers/net/wireless/ath/ath9k/debug.h
> @@ -165,13 +165,6 @@ struct ath_rx_stats {
>        u32 post_delim_crc_err;
>        u32 decrypt_busy_err;
>        u32 phy_err_stats[ATH9K_PHYERR_MAX];
> -       int8_t rs_rssi_ctl0;
> -       int8_t rs_rssi_ctl1;
> -       int8_t rs_rssi_ctl2;
> -       int8_t rs_rssi_ext0;
> -       int8_t rs_rssi_ext1;
> -       int8_t rs_rssi_ext2;
> -       u8 rs_antenna;
>  };
>
>  enum ath_reset_type {
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
