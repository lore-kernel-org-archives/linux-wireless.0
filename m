Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58737 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab2DDMBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 08:01:05 -0400
Message-ID: <4F7C3815.8060902@openwrt.org> (sfid-20120404_140109_886510_501F61B6)
Date: Wed, 04 Apr 2012 14:01:25 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 2/2] ath9k:  Add more recv stats.
References: <1333469939-26213-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1333469939-26213-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-03 6:18 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This adds counters in various places that can drop packets on
> rx without otherwise incrementing a counter.  It also counts
> some non-error cases, such as becons and fragments received.
> 
> Should help with figuring out where packets are (and are not)
> dropped.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 9078279... 244723a... M	drivers/net/wireless/ath/ath9k/debug.c
> :100644 100644 d1c132f... 56a7053... M	drivers/net/wireless/ath/ath9k/debug.h
> :100644 100644 1c4583c... ad2b2b6... M	drivers/net/wireless/ath/ath9k/recv.c
>  drivers/net/wireless/ath/ath9k/debug.c |   23 +++++++++++++++++++-
>  drivers/net/wireless/ath/ath9k/debug.h |   18 ++++++++++++++++
>  drivers/net/wireless/ath/ath9k/recv.c  |   35 +++++++++++++++++++++++--------
>  3 files changed, 65 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 9078279..244723a 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -916,6 +916,21 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
>  	len += snprintf(buf + len, size - len,
>  			"%22s : %10u\n", "DECRYPT BUSY ERR",
>  			sc->debug.stats.rxstats.decrypt_busy_err);
> +	len += snprintf(buf + len, size - len,
> +			"%22s : %10u\n", "RX-LENGTH-ERR",
> +			sc->debug.stats.rxstats.rx_len_err);
> +	len += snprintf(buf + len, size - len,
> +			"%22s : %10u\n", "RX-OOM-ERR",
> +			sc->debug.stats.rxstats.rx_oom_err);
> +	len += snprintf(buf + len, size - len,
> +			"%22s : %10u\n", "RX-RATE-ERR",
> +			sc->debug.stats.rxstats.rx_rate_err);
> +	len += snprintf(buf + len, size - len,
> +			"%22s : %10u\n", "RX-DROP-RXFLUSH",
> +			sc->debug.stats.rxstats.rx_drop_rxflush);
> +	len += snprintf(buf + len, size - len,
> +			"%22s : %10u\n", "RX-TOO-MANY-FRAGS",
> +			sc->debug.stats.rxstats.rx_too_many_frags_err);
>  
>  	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
>  	PHY_ERR("TIMING ERR", ATH9K_PHYERR_TIMING);
> @@ -950,6 +965,12 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
>  	len += snprintf(buf + len, size - len,
>  			"%22s : %10u\n", "RX-Bytes-All",
>  			sc->debug.stats.rxstats.rx_bytes_all);
> +	len += snprintf(buf + len, size - len,
> +			"%22s : %10u\n", "RX-Beacons",
> +			sc->debug.stats.rxstats.rx_beacons);
> +	len += snprintf(buf + len, size - len,
> +			"%22s : %10u\n", "RX-Frags",
> +			sc->debug.stats.rxstats.rx_frags);
>  
>  	if (len > size)
>  		len = size;
> @@ -964,7 +985,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
>  
>  void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
>  {
> -#define RX_STAT_INC(c) sc->debug.stats.rxstats.c++
>  #define RX_PHY_ERR_INC(c) sc->debug.stats.rxstats.phy_err_stats[c]++
>  #define RX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].rs\
>  			[sc->debug.rsidx].c)
> @@ -1010,7 +1030,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
>  
>  #endif
>  
> -#undef RX_STAT_INC
>  #undef RX_PHY_ERR_INC
>  #undef RX_SAMP_DBG
>  }
> diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
> index d1c132f..56a7053 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.h
> +++ b/drivers/net/wireless/ath/ath9k/debug.h
> @@ -139,6 +139,8 @@ struct ath_tx_stats {
>  	u32 txfailed;
>  };
>  
> +#define RX_STAT_INC(c) (sc->debug.stats.rxstats.c++)
> +
>  /**
>   * struct ath_rx_stats - RX Statistics
>   * @rx_pkts_all:  No. of total frames received, including ones that
> @@ -155,6 +157,13 @@ struct ath_tx_stats {
>   * @post_delim_crc_err: Post-Frame delimiter CRC error detections
>   * @decrypt_busy_err: Decryption interruptions counter
>   * @phy_err_stats: Individual PHY error statistics
> + * @rx_len_err:  No. of frames discarded due to bad length.
> + * @rx_oom_err:  No. of frames dropped due to OOM issues.
> + * @rx_rate_err:  No. of frames dropped due to rate errors.
> + * @rx_too_many_frags_err:  Frames dropped due to too-many-frags received.
> + * @rx_drop_rxflush: No. of frames dropped due to RX-FLUSH.
> + * @rx_beacons:  No. of beacons received.
> + * @rx_frags:  No. of rx-fragements received.
Why should the driver keep track of those last two?

- Felix
