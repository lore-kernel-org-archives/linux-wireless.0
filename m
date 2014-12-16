Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43895 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaLPHpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 02:45:40 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <backports@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: Re: [PATCH 3/5] ath10k: add thermal cooling device support
References: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1418620274-3081-4-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 16 Dec 2014 09:45:32 +0200
In-Reply-To: <1418620274-3081-4-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 15 Dec 2014 10:41:12 +0530")
Message-ID: <87bnn4t4v7.fsf@kamboji.qca.qualcomm.com> (sfid-20141216_084544_601212_B53CF4A0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A heads up for the backports project:

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Thermal cooling device support is added to control the temperature
> by throttling the data transmission for the given duration. Throttling
> is done using hw MAC quiet time setting. Period, duration and offset
> from TBTT can be set up to quiet the MAC transmits for the required duty
> cycle (% of quiet duration). The thermal device allows user to configure
> duty cycle.
>
> The quiet params are derived as follows.
> 	period = max(25TU, beacon interval / number of bss)
> 	duration = period * duty cycle / 100
>
> Quiet mode can be disabled by setting the duty cycle to 0. The cooling
> device can be found under /sys/class/thermal/cooling_deviceX/.
> Corresponding soft link to this device can be found under phy folder.
>
> /sys/class/ieee80211/phy*/device/cooling_device.
>
> To set duty cycle as 40%,
>
> echo 40 >/sys/class/ieee80211/phy*/device/cooling_device/cur_state
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> +int ath10k_thermal_register(struct ath10k *ar)
> +{
> +	struct thermal_cooling_device *cdev;
> +	int ret;
> +
> +	cdev = thermal_cooling_device_register("ath10k_thermal", ar,
> +					       &ath10k_thermal_ops);
> +
> +	if (IS_ERR(cdev)) {
> +		ath10k_err(ar, "failed to setup thermal device result: %ld\n",
> +			   PTR_ERR(cdev));
> +		return -EINVAL;
> +	}

Will this break the backports build? We have the below in Makefile, is
it enough or what's the best way to handle this?

+ath10k_core-$(CONFIG_THERMAL) += thermal.o


-- 
Kalle Valo
