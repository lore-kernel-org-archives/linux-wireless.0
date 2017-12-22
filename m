Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:65469 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753347AbdLVPZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:25:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 04/11] ath10k: add start_once support
Date: Fri, 22 Dec 2017 15:25:08 +0000
Message-ID: <87shc2aip8.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_162518_202851_1A50152D)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-5-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-5-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:06 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Add possibility to configure the driver to only start target once.
> This can reduce startup time of SDIO devices significantly since
> loading the firmware can take a substantial amount of time.

But it also makes it impossible to restart the firmware if it crashes,
right? Good to mention that in the commit log.

> The patch is also necessary for high latency devices in general since
> it does not seem to be possible to rerun the BMI phase (fw upload)
> without power-cycling the device.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -784,6 +784,8 @@ struct ath10k {
> =20
>  	bool is_high_latency;
> =20
> +	bool is_started;

Is a separate boolean really needed? State management becomes really
difficult if an enum ath10k_state and this boolean to define the state
of the device. Can't you use ar->state?

> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -569,6 +569,12 @@ struct ath10k_hw_params {
>  	bool is_high_latency;
> =20
>  	enum ath10k_bus bus;
> +
> +	/* Specifies whether or not the device should be started once.
> +	 * If set, the device will be started once by the early fw probe
> +	 * and it will not be terminated afterwards.
> +	 */
> +	bool start_once;
>  };

I would actually prefer that the bus driver (eg. usb.c) decides this and
provides it though ath10k_core_register(). It might be that some SDIO
devices have a GPIO line to reset the device etc.

The struct ath10k_bus_params I mentioned earlier might be handy also
here.

--=20
Kalle Valo=
