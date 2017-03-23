Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22630 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbdCWPXR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 11:23:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6 10/10] ath10k: sdio support
Date: Thu, 23 Mar 2017 15:23:11 +0000
Message-ID: <87r31oyq3l.fsf@kamboji.qca.qualcomm.com> (sfid-20170323_162331_110588_B102912C)
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
        <148959281831.31432.17236410281378572164.stgit@potku.adurom.net>
In-Reply-To: <148959281831.31432.17236410281378572164.stgit@potku.adurom.net>
        (Kalle Valo's message of "Wed, 15 Mar 2017 17:46:58 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Erik Stromdahl <erik.stromdahl@gmail.com>
>
> sdio/mailbox HIF implementation.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

> +static int ath10k_sdio_mbox_proc_cpu_intr(struct ath10k *ar)
> +{
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +	struct ath10k_sdio_irq_data *irq_data =3D &ar_sdio->irq_data;
> +	u8 cpu_int_status, *reg_buf;
> +	int ret;
> +
> +	mutex_lock(&irq_data->mtx);
> +	cpu_int_status =3D irq_data->irq_proc_reg->cpu_int_status &
> +			 irq_data->irq_en_reg->cpu_int_status_en;
> +	if (!cpu_int_status) {
> +		ath10k_warn(ar, "CPU interrupt status is zero\n");
> +		return -EIO;
> +	}
> +
> +	/* Clear the interrupt */
> +	irq_data->irq_proc_reg->cpu_int_status &=3D ~cpu_int_status;
> +
> +	/* Set up the register transfer buffer to hit the register 4 times ,
> +	 * this is done to make the access 4-byte aligned to mitigate issues
> +	 * with host bus interconnects that restrict bus transfer lengths to
> +	 * be a multiple of 4-bytes.
> +	 */
> +	reg_buf =3D kzalloc(4, GFP_KERNEL);
> +	if (!reg_buf)
> +		return -ENOMEM;

kbuild bot reported that I failed to release the mutex in these two
return cases above, I'll fix that in v7.

--=20
Kalle Valo=
