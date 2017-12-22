Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:13202 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbdLVPGI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:06:08 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 01/11] ath10k: high_latency detection
Date: Fri, 22 Dec 2017 15:06:02 +0000
Message-ID: <871sjmby5h.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_160613_439621_A5618FF0)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-2-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-2-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:03 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> The setup of high latency chips (USB and SDIO) is
> sometimes different than for chips using low latency
> interfaces.
>
> The bus type is used to determine if the interface is
> a high latency interface.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 1 +
>  drivers/net/wireless/ath/ath10k/core.h | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index a4f635820f35..f1924c974a12 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2496,6 +2496,7 @@ struct ath10k *ath10k_core_create(size_t priv_size,=
 struct device *dev,
>  	ar->hw_rev =3D hw_rev;
>  	ar->hif.ops =3D hif_ops;
>  	ar->hif.bus =3D bus;
> +	ar->is_high_latency =3D ath10k_is_high_latency(bus);

I would prefer the bus driver to provide this via a parameter in
ath10k_core_register() call.

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -789,6 +789,8 @@ struct ath10k {
> =20
>  	bool p2p;
> =20
> +	bool is_high_latency;
> +
>  	struct {
>  		enum ath10k_bus bus;
>  		const struct ath10k_hif_ops *ops;
> @@ -1013,6 +1015,11 @@ static inline bool ath10k_peer_stats_enabled(struc=
t ath10k *ar)
>  	return false;
>  }
> =20
> +static inline bool ath10k_is_high_latency(enum ath10k_bus bus)
> +{
> +	return ((bus =3D=3D ATH10K_BUS_SDIO) || (bus =3D=3D ATH10K_BUS_USB));
> +}

That way this function is not needed.

Also I'm wondering should the parameter be actually 'struct
ath10k_bus_params' (or something like that) to make it easier to extend.

--=20
Kalle Valo=
