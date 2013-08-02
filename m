Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40006 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3HBIAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 04:00:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix device teardown
References: <1374129572-6079-1-git-send-email-michal.kazior@tieto.com>
	<1375427747-9539-1-git-send-email-michal.kazior@tieto.com>
	<87bo5gpmij.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQktaDtp=fc3C_u4geA6vK72B1X4QnsD_GqrzU9NXEmBrA@mail.gmail.com>
Date: Fri, 2 Aug 2013 11:00:08 +0300
In-Reply-To: <CA+BoTQktaDtp=fc3C_u4geA6vK72B1X4QnsD_GqrzU9NXEmBrA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 2 Aug 2013 09:51:28 +0200")
Message-ID: <8738qsplo7.fsf@kamboji.qca.qualcomm.com> (sfid-20130802_100040_966192_546782FD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 2 August 2013 09:41, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> @@ -1742,6 +1761,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>>>  {
>>>       int ret;
>>>
>>> +     ret = ath10k_pci_start_intr(ar);
>>> +     if (ret) {
>>> +             ath10k_err("could not start interrupt handling (%d)\n", ret);
>>> +             goto err;
>>> +     }
>>
>> So now we call start_intr() during power_up(), which means that we do
>> the request_irq() calls during every interface up event. Does that cause
>> any meaningful overhead?
>
> I don't think so.

Good.

>> For me it looks better to do all resource allocation in
>> ath10k_pci_probe(), like request_irq(), and free the resources in
>> ath10k_pci_remove(). But then we would need to immeadiately call
>> disable_irq() and then enable_irq() from power_up() so I'm not sure if
>> that's any better.
>
> Not only that. Since disable/enable_irq must be balanced we'd need
> some way to track whether we have irqs enabled/disabled - either with
> an extra bool variable, additional ath10k_states or new pci-specific
> states.
>
> The patch assumes disable_irq is followed by free_irq (which it is)
> and possibly request_irq later on.

Yeah, your v2 sounds much better. And if there's overhead or something
else we can always change this later.

I'll wait for comments from others and if I don't get any, I'll apply
this.

-- 
Kalle Valo
