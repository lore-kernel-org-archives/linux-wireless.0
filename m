Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:51533 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753735AbdLVPT2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:19:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 03/11] ath10k: per target configurablity of various items
Date: Fri, 22 Dec 2017 15:19:15 +0000
Message-ID: <87wp1eaiz0.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_161944_095631_51759BCC)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-4-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-4-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:05 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Added ability to set bus type and configure the max number of
> peers in the ath10k_hw_params struct.
>
> With this functionality it is possible to have a different
> hw configuration depending on bus type for the same radio
> chipset.
>
> E.g. SDIO and USB devices using the same chipset as PCIe
> devices will potentially use different board files and perhaps
> other configuration parameters.
>
> One such parameter is the max number of peers.
> Instead of using a default value (suitable for PCIe devices)
> derived from the WMI op version, a per target value can be
> used instead.
>
> This is needed by the QCA9377 USB device in order to prevent
> the target fw to crash after HTT RX ring cfg is issued.
>
> Apparently, the QCA9377 HL device does not seem to handle the
> same amount of peers as the LL devices.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

I was a bit torn about this, I definitely see the need for this but on
the other hand it creates duplicate data (for example two entries for
QCA9377 chip). I guess this is the right approach, at least I cannot
come up anything better.

But this patch should be split into two:

1) add bus field to struct ath10k_hw_params

2) add max_num_peers field to struct ath10k_hw_params

And it seems 2) is already implemented in commit 9f2992fea580 ("ath10k:
wmi: get wmi init parameter values from hw params"), so hopefully we
only need 1) anymore.

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1663,9 +1663,19 @@ static int ath10k_init_hw_params(struct ath10k *ar=
)
>  	for (i =3D 0; i < ARRAY_SIZE(ath10k_hw_params_list); i++) {
>  		hw_params =3D &ath10k_hw_params_list[i];
> =20
> -		if (hw_params->id =3D=3D ar->target_version &&
> -		    hw_params->dev_id =3D=3D ar->dev_id)
> -			break;
> +		if (ar->is_high_latency) {
> +			/* High latency devices will use different fw depending
> +			 * on if it is a USB or SDIO device.
> +			 */
> +			if (hw_params->bus =3D=3D ar->hif.bus &&
> +			    hw_params->id =3D=3D ar->target_version &&
> +			    hw_params->dev_id =3D=3D ar->dev_id)
> +				break;
> +		} else {
> +			if (hw_params->id =3D=3D ar->target_version &&
> +			    hw_params->dev_id =3D=3D ar->dev_id)
> +				break;
> +		}

I don't like the is_high_latency test here at all. The bus field should
be checked with all entries, not just high latency ones. And because of
this even most of the hw_param bus field entries were not initialised.

So only thing to do is to initialise the bus field for all the entries
and the ugly test here can be removed. Just remember that QCA4019 uses
AHB, I think all the rest is PCI. Or do we have AHB devices supported?

> @@ -550,6 +557,18 @@ struct ath10k_hw_params {
>  	 */
>  	int vht160_mcs_rx_highest;
>  	int vht160_mcs_tx_highest;
> +
> +	/* max_num_peers can be used to override the setting derived from
> +	 * the WMI op version. If this value is non-zero, it will always
> +	 * be used instead of the default value derived from the WMI op
> +	 * version.
> +	 */
> +	int max_num_peers;
> +
> +	/* Specifies whether or not the device is a high latency device */
> +	bool is_high_latency;
> +
> +	enum ath10k_bus bus;
>  };

Please move the bus field between dev_id and name fields. It's so
important that it should not be in the end.

--=20
Kalle Valo=
