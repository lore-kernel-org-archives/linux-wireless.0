Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15510 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdCOMJo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 08:09:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v4 06/21] ath10k: sdio support
Date: Wed, 15 Mar 2017 12:09:31 +0000
Message-ID: <877f3qyc5g.fsf@kamboji.qca.qualcomm.com> (sfid-20170315_131028_848860_6298B9F9)
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
        <1487693741-10042-7-git-send-email-erik.stromdahl@gmail.com>
        <8760jh2uy8.fsf@kamboji.qca.qualcomm.com>
        <871su52th2.fsf@kamboji.qca.qualcomm.com>
        <2528f323-6ec7-915c-d98b-615db04510e9@gmail.com>
In-Reply-To: <2528f323-6ec7-915c-d98b-615db04510e9@gmail.com> (Erik
        Stromdahl's message of "Fri, 10 Mar 2017 17:29:38 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 2017-03-10 13:43, Valo, Kalle wrote:
>> "Valo, Kalle" <kvalo@qca.qualcomm.com> writes:
>>
>>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>>
>>>> sdio/mailbox HIF implementation.
>>>>
>>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>>
>>> I'm looking at this more carefully now and noticed this:
>>>
>>>> +static int ath10k_sdio_bmi_credits(struct ath10k *ar)
>>>> +{
>>>> +	int ret;
>>>> +	u32 addr, *cmd_credits;
>>>> +	unsigned long timeout;
>>>> +
>>>> +	cmd_credits =3D kzalloc(sizeof(*cmd_credits), GFP_KERNEL);
>>>> +	if (!cmd_credits) {
>>>> +		ret =3D -ENOMEM;
>>>> +		goto err;
>>>> +	}
>>>> +
>>>> +	/* Read the counter register to get the command credits */
>>>> +	addr =3D MBOX_COUNT_DEC_ADDRESS + ATH10K_HIF_MBOX_NUM_MAX * 4;
>>>> +
>>>> +	timeout =3D jiffies + BMI_COMMUNICATION_TIMEOUT_HZ;
>>>> +	while (time_before(jiffies, timeout) && !*cmd_credits) {
>>>> +		/* Hit the credit counter with a 4-byte access, the first byte
>>>> +		 * read will hit the counter and cause a decrement, while the
>>>> +		 * remaining 3 bytes has no effect. The rationale behind this
>>>> +		 * is to make all HIF accesses 4-byte aligned.
>>>> +		 */
>>>> +		ret =3D ath10k_sdio_read_write_sync(ar, addr,
>>>> +						  (u8 *)cmd_credits,
>>>> +						  sizeof(*cmd_credits),
>>>> +						  HIF_RD_SYNC_BYTE_INC);
>>>> +		if (ret) {
>>>> +			ath10k_warn(ar,
>>>> + "Unable to decrement the command credit count register: %d\n",
>>>> +				    ret);
>>>> +			goto err_free;
>>>> +		}
>>>> +
>>>> +		/* The counter is only 8 bits.
>>>> +		 * Ignore anything in the upper 3 bytes
>>>> +		 */
>>>> +		*cmd_credits &=3D 0xFF;
>>>> +	}
>>>> +
>>>> +	if (!*cmd_credits) {
>>>> +		ath10k_warn(ar, "bmi communication timeout\n");
>>>> +		ret =3D -ETIMEDOUT;
>>>> +		goto err_free;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +err_free:
>>>> +	kfree(cmd_credits);
>>>> +err:
>>>> +	return ret;
>>>> +}
>>>
>>> AFAICS we are leaking cmd_credits if there's no error. Or is the buffer
>>> freed somewhere within the mmc stack or something? The reason why I ask
>>> is that I saw the same pattern in multiple functions so I'm curious.
>>
>> Also I'm worried about endianness. We are reading from the device
>> directly to an u32 variable and not converting the bytes. Is the MMC
>> subsystem doing the conversion, I guess not?
>>
> You are right, there is definitely a memory leak (and there are similar p=
roblems
> in a couple of other functions as well as you have pointed out).
>
> This was introduced in version 3 of the
> RFC when I removed the bounce buffer from ath6kl. Instead I introduced a =
bunch of
> local "bounce" buffers in order to make sure that the buffers passed to t=
he sdio
> subsystem is dma-able (malloc'ed buffer instead of stack allocated).
>
> Regarding endianess: That particular code construct is an artifact from a=
th6kl.
> I am not sure it makes any sense to use a u32 in that particular case.
> A u8 array is most likely more convenient.

There seems to be same pattern for reading four bytes, what if we should
add a helper for that? Something like ath10k_sdio_read32()? It could
handle the kmalloc and switch endianess also.

But please don't make any chances to sdio.c for the moment, let me
submit v5 first.

--=20
Kalle Valo=
