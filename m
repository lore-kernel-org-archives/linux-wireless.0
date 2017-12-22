Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:49913 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755458AbdLVPcO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:32:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 06/11] ath10k: htt: High latency RX support
Date: Fri, 22 Dec 2017 15:32:09 +0000
Message-ID: <87k1xeaidi.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_163218_995087_5D848D75)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-7-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-7-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:08 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Special HTT RX handling for high latency interfaces.
>
> Since no DMA physical addresses are used in the RX ring
> config message (this is not supported by the high latency
> devices), no RX ring is allocated.
> All RX skb's are allocated by the driver and passed directly
> to mac80211 in the HTT RX indication handler.
>
> A nice side effect of this is that no huge buffer will be
> allocated with dma_alloc_coherent. On embedded systems with
> limited memory resources, the allocation of the RX ring is
> prone to fail.
>
> Some tweaks made to "make it work":
>
> Removal of protected bit in 802.11 header frame control field.
> The chipset seems to do hw decryption but the frame_control
> protected bit is still set.
>
> This is necessary for mac80211 not to drop the frame.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c    |  27 ++++---
>  drivers/net/wireless/ath/ath10k/htt.h     |  47 ++++++++++++
>  drivers/net/wireless/ath/ath10k/htt_rx.c  | 119 ++++++++++++++++++++++++=
+++++-
>  drivers/net/wireless/ath/ath10k/rx_desc.h |  15 ++++
>  4 files changed, 195 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index c21227a74996..1880570989ae 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2083,10 +2083,12 @@ int ath10k_core_start(struct ath10k *ar, enum ath=
10k_firmware_mode mode,
>  	ar->htt.rx_ring.in_ord_rx =3D !!(test_bit(WMI_SERVICE_RX_FULL_REORDER,
>  						ar->wmi.svc_map));
> =20
> -	status =3D ath10k_htt_rx_alloc(&ar->htt);
> -	if (status) {
> -		ath10k_err(ar, "failed to alloc htt rx: %d\n", status);
> -		goto err_htt_tx_detach;
> +	if (!ar->is_high_latency) {
> +		status =3D ath10k_htt_rx_alloc(&ar->htt);
> +		if (status) {
> +			ath10k_err(ar, "failed to alloc htt rx: %d\n", status);
> +			goto err_htt_tx_detach;
> +		}
>  	}

Wouldn't it be cleaner code to have the is_high_latency check within
ath10k_htt_rx_alloc() call?

> @@ -2203,10 +2205,13 @@ int ath10k_core_start(struct ath10k *ar, enum ath=
10k_firmware_mode mode,
>  		}
>  	}
> =20
> -	status =3D ath10k_htt_rx_ring_refill(ar);
> -	if (status) {
> -		ath10k_err(ar, "failed to refill htt rx ring: %d\n", status);
> -		goto err_hif_stop;
> +	if (!ar->is_high_latency) {
> +		status =3D ath10k_htt_rx_ring_refill(ar);
> +		if (status) {
> +			ath10k_err(ar, "failed to refill htt rx ring: %d\n",
> +				   status);
> +			goto err_hif_stop;
> +		}
>  	}

Ditto.

> @@ -2235,7 +2240,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10=
k_firmware_mode mode,
>  err_hif_stop:
>  	ath10k_hif_stop(ar);
>  err_htt_rx_detach:
> -	ath10k_htt_rx_free(&ar->htt);
> +	if (!ar->is_high_latency)
> +		ath10k_htt_rx_free(&ar->htt);
>  err_htt_tx_detach:
>  	ath10k_htt_tx_free(&ar->htt);
>  err_wmi_detach:

Ditto.

> @@ -2280,7 +2286,8 @@ void ath10k_core_stop(struct ath10k *ar)
> =20
>  	ath10k_hif_stop(ar);
>  	ath10k_htt_tx_stop(&ar->htt);
> -	ath10k_htt_rx_free(&ar->htt);
> +	if (!ar->is_high_latency)
> +		ath10k_htt_rx_free(&ar->htt);
>  	ath10k_wmi_detach(ar);
>  	ar->is_started =3D false;
>  }

Ditto.

> +	/* Not entirely sure about this, but all frames from the chipset has
> +	 * the protected flag set even though they have already been decrypted.
> +	 * Unmasking this flag is necessary in order for mac80211 not to drop
> +	 * the frame.
> +	 * TODO: Verify this is always the case or find out a way to check
> +	 * if there has been hw decryption.
> +	 */
> +	if (ieee80211_has_protected(hdr->frame_control)) {
> +		hdr->frame_control &=3D ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
> +		rx_status->flag |=3D RX_FLAG_DECRYPTED |
> +				   RX_FLAG_IV_STRIPPED |
> +				   RX_FLAG_MMIC_STRIPPED;
> +	}
> +
> +	local_bh_disable();
> +	ieee80211_rx(ar->hw, skb);
> +	local_bh_enable();

ieee80211_rx_ni()?

--=20
Kalle Valo=
