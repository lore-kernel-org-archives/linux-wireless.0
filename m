Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:33761 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaCCHfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 02:35:50 -0500
Received: by mail-we0-f171.google.com with SMTP id t61so223106wes.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Mar 2014 23:35:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5310CB75.9030706@candelatech.com>
References: <1393571908-23734-1-git-send-email-marek.kwaczynski@tieto.com>
	<5310CB75.9030706@candelatech.com>
Date: Mon, 3 Mar 2014 08:35:49 +0100
Message-ID: <CACKGw+EQ4xS6DTbM_FjMitvyQs9=uL5OFzPkc6HNuzu8tSdeUQ@mail.gmail.com> (sfid-20140303_083554_590162_28A26519)
Subject: Re: [PATCH] ath10k: add recalc RTS/CTS protection method
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2014 18:46, Ben Greear <greearb@candelatech.com> wrote:
> On 02/27/2014 11:18 PM, bartosz.markowski@tieto.com wrote:
>> From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
>>
>> Add recalculation of RTS/CTS protection when one or more legacy
>> stations are connected to ath10k. In this case enable RTS/CTS
>> protection and set sw retry profile are needed in the FW.
>> Without this change legacy station is starved and has very low
>> throughput.
>
>> -                     ath10k_warn("Failed to set CTS prot for VDEV: %d\n",
>> -                                 arvif->vdev_id);
>> +                     ath10k_warn("failed to recalc RTS/CTS prot %d\n",
>> +                                 ret);
>
> Did you remove the vdev ID from the logging message on purpose?
>
> I find having vdev ID in logging messages helps, especially when
> trying to compare firmware logs with the driver logs...

Not on purpose. Thanks for pointing it out.
Kalle, please ignore this patch, there'll be v2.

-- 
Bartosz
