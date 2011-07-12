Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33578 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1GLJ5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 05:57:25 -0400
Date: Tue, 12 Jul 2011 15:27:33 +0530
From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath9k: improve reliability of MIC error detection
Message-ID: <20110712095732.GA5132@senthil-lnx.users.atheros.com> (sfid-20110712_115728_934345_71BF3472)
References: <1310435333-70700-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1310435333-70700-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2011 at 09:48:53AM +0800, Felix Fietkau wrote:
> For unicast the hardware sometimes reports MIC errors even though the
> frame that it received actually contains a valid MIC - on some chips this
> can happen frequently enough to trigger TKIP countermeasures.
> Fix this issue by not reporting MIC errors for unicast frames with a
> valid key, letting mac80211 validate the MIC instead.
> 
> Additionally, strip the MIC for all frames that the hardware considers
> valid to avoid wasting CPU cycles re-validating it.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |   44 +++++++++++++++++---------------
>  1 files changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 80bb04f..3d9359a 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -814,16 +814,19 @@ static bool ath9k_rx_accept(struct ath_common *common,
>  			    struct ath_rx_status *rx_stats,
>  			    bool *decrypt_error)
>  {
> -#define is_mc_or_valid_tkip_keyix ((is_mc ||			\
> -		(rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID && \
> -		test_bit(rx_stats->rs_keyix, common->tkip_keymap))))
> -
> +	bool is_mc, is_valid_tkip, strip_mic, mic_error = false;
>  	struct ath_hw *ah = common->ah;
>  	__le16 fc;
>  	u8 rx_status_len = ah->caps.rx_status_len;
>  
>  	fc = hdr->frame_control;
>  
> +	is_mc = !!is_multicast_ether_addr(hdr->addr1);
> +	is_valid_tkip = rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID &&
> +		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
> +	strip_mic = is_valid_tkip && !(rx_stats->rs_status &
> +		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC));
> +
[...]
>  	if (!rx_stats->rs_datalen)
>  		return false;
>          /*
> @@ -850,25 +853,9 @@ static bool ath9k_rx_accept(struct ath_common *common,
>  		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
>  			return false;
>  
> -		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
> +		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT)
>  			*decrypt_error = true;
> -		} else if (rx_stats->rs_status & ATH9K_RXERR_MIC) {
> -			bool is_mc;
> -			/*
> -			 * The MIC error bit is only valid if the frame
> -			 * is not a control frame or fragment, and it was
> -			 * decrypted using a valid TKIP key.
> -			 */
> -			is_mc = !!is_multicast_ether_addr(hdr->addr1);
>  
> -			if (!ieee80211_is_ctl(fc) &&
> -			    !ieee80211_has_morefrags(fc) &&
> -			    !(le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG) &&
How are we going to handle the above conditions?
> -			    is_mc_or_valid_tkip_keyix)
> -				rxs->flag |= RX_FLAG_MMIC_ERROR;
> -			else
> -				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
> -		}
>  		/*
>  		 * Reject error frames with the exception of
>  		 * decryption and MIC failures. For monitor mode,
> @@ -886,6 +873,18 @@ static bool ath9k_rx_accept(struct ath_common *common,
>  			}
>  		}
>  	}
> +
> +	/*
> +	 * For unicast frames the MIC error bit can have false positives,
> +	 * so all MIC error reports need to be validated in software.
> +	 * False negatives are not common, so skip software verification
> +	 * if the hardware considers the MIC valid.
> +	 */
> +	if (strip_mic)
> +		rxs->flag |= RX_FLAG_MMIC_STRIPPED;
> +	else if (is_mc && mic_error)
mic_error is always false here. I believe you wanted to set it
based on MIC failure in rx status and may be missed out...

> +		rxs->flag |= RX_FLAG_MMIC_ERROR;
> +
>  	return true;
>  }
>  
> @@ -1938,6 +1937,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>  			sc->rx.rxotherant = 0;
>  		}
>  
> +		if (rxs->flag & RX_FLAG_MMIC_STRIPPED)
> +			skb_trim(skb, skb->len - 8);
> +
>  		spin_lock_irqsave(&sc->sc_pm_lock, flags);
>  
>  		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
