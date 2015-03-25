Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34378 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbbCYM6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 08:58:34 -0400
Received: by iedfl3 with SMTP id fl3so23759147ied.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2015 05:58:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5512A9BC.5010902@pengutronix.de>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
	<1419834253-18331-6-git-send-email-eliad@wizery.com>
	<5512A9BC.5010902@pengutronix.de>
Date: Wed, 25 Mar 2015 14:58:34 +0200
Message-ID: <CAB3XZEfw5EurqA2jZypAj4LkQwwAiVeKd5wKKsxpOAh-RrCq0w@mail.gmail.com> (sfid-20150325_135840_915446_1D2309B6)
Subject: Re: [PATCH 06/13] wlcore: enable sleep during AP mode operation
From: Eliad Peller <eliad@wizery.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kobi Leibovitch <kobi.lev100@gmail.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Marc,

On Wed, Mar 25, 2015 at 2:27 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 12/29/2014 07:24 AM, Eliad Peller wrote:
>> From: Kobi L <kobi.lev100@gmail.com>
>>
>> Enable ELP authorization in AP mode and enable the use
>> of the wakeup bit in the ELP register.
>>
>> Introduce AP role sleep configuration which is disabled
>> by default. When configured, it allows the AP to sleep
>> when ELP is authorized for it.
>>
>> Signed-off-by: Kobi Leibovitch <kobi.lev100@gmail.com>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>
> [...]
>
>
> This patch requires a new firmware, loading of "wl18xx-conf.bin" from
> [1] fails with:
>
>> wlcore: ERROR configuration binary file size is wrong, expected 1226 got 1221
>
thanks. seems you're right.

anyway, note that this file is not actual fw, but only the default
configuration params.
you can just delete it, and the driver will load just fine.
you can then recreate it with something like:
cat /sys/kernel/debug/ieee80211/phy0/wlcore/wl18xx/conf >
/lib/firmware/ti-connectivity/wl18xx-conf.bin

actually, i don't think it makes much sense to have this file in the
linux-firmware git at all.
i'll try handling it.

Eliad.
