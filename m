Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48927 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932909AbdCJMoG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 07:44:06 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v4 06/21] ath10k: sdio support
Date: Fri, 10 Mar 2017 12:43:34 +0000
Message-ID: <871su52th2.fsf@kamboji.qca.qualcomm.com> (sfid-20170310_134427_377815_9C5456D6)
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
        <1487693741-10042-7-git-send-email-erik.stromdahl@gmail.com>
        <8760jh2uy8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760jh2uy8.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Fri, 10 Mar 2017 12:11:40 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Valo, Kalle" <kvalo@qca.qualcomm.com> writes:

> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>
>> sdio/mailbox HIF implementation.
>>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>
> I'm looking at this more carefully now and noticed this:
>
>> +static int ath10k_sdio_bmi_credits(struct ath10k *ar)
>> +{
>> +	int ret;
>> +	u32 addr, *cmd_credits;
>> +	unsigned long timeout;
>> +
>> +	cmd_credits =3D kzalloc(sizeof(*cmd_credits), GFP_KERNEL);
>> +	if (!cmd_credits) {
>> +		ret =3D -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	/* Read the counter register to get the command credits */
>> +	addr =3D MBOX_COUNT_DEC_ADDRESS + ATH10K_HIF_MBOX_NUM_MAX * 4;
>> +
>> +	timeout =3D jiffies + BMI_COMMUNICATION_TIMEOUT_HZ;
>> +	while (time_before(jiffies, timeout) && !*cmd_credits) {
>> +		/* Hit the credit counter with a 4-byte access, the first byte
>> +		 * read will hit the counter and cause a decrement, while the
>> +		 * remaining 3 bytes has no effect. The rationale behind this
>> +		 * is to make all HIF accesses 4-byte aligned.
>> +		 */
>> +		ret =3D ath10k_sdio_read_write_sync(ar, addr,
>> +						  (u8 *)cmd_credits,
>> +						  sizeof(*cmd_credits),
>> +						  HIF_RD_SYNC_BYTE_INC);
>> +		if (ret) {
>> +			ath10k_warn(ar,
>> + "Unable to decrement the command credit count register: %d\n",
>> +				    ret);
>> +			goto err_free;
>> +		}
>> +
>> +		/* The counter is only 8 bits.
>> +		 * Ignore anything in the upper 3 bytes
>> +		 */
>> +		*cmd_credits &=3D 0xFF;
>> +	}
>> +
>> +	if (!*cmd_credits) {
>> +		ath10k_warn(ar, "bmi communication timeout\n");
>> +		ret =3D -ETIMEDOUT;
>> +		goto err_free;
>> +	}
>> +
>> +	return 0;
>> +err_free:
>> +	kfree(cmd_credits);
>> +err:
>> +	return ret;
>> +}
>
> AFAICS we are leaking cmd_credits if there's no error. Or is the buffer
> freed somewhere within the mmc stack or something? The reason why I ask
> is that I saw the same pattern in multiple functions so I'm curious.

Also I'm worried about endianness. We are reading from the device
directly to an u32 variable and not converting the bytes. Is the MMC
subsystem doing the conversion, I guess not?

--=20
Kalle Valo=
