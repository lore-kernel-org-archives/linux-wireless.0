Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8358 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbcJOF2F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Oct 2016 01:28:05 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 0/5] ath6kl: non WMI data service support
Date: Sat, 15 Oct 2016 05:24:42 +0000
Message-ID: <87funy9obq.fsf@kamboji.qca.qualcomm.com> (sfid-20161015_072811_187517_4B89701D)
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
        <CALupW3CrY5sZYBcx5Bd3E_M_Kx2sx8_N9h_uexvg_DSO0c-tJA@mail.gmail.com>
        <87y41rbleo.fsf@kamboji.qca.qualcomm.com>
        <656f8674-64b9-0440-f8ae-28177c300b1c@gmail.com>
In-Reply-To: <656f8674-64b9-0440-f8ae-28177c300b1c@gmail.com> (Erik
        Stromdahl's message of "Fri, 14 Oct 2016 17:38:35 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding ath10k list to CC)

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

>> Exactly what I was thinking. When I saw terms like "HTT" and "unified
>> WMI" my first thought was that is this actually an ath10k based design?
>> The product numbers really don't give any indication what driver
>> supports, the division goes something like this:
>>=20
>> * ath9k: "non-mobile" 11n chips
>> * ath6k: mobile 11n chips
>> * ath10k: mobile and "non-mobile" 11ac chips
>>=20
>> For example QCA6174 is an 11ac mobile chip supported by ath10k. ath10k
>> only supports PCI bus at the moment, but I'm hoping someone would add
>> USB and SDIO support. Patches are very welcome.
>>=20
>> I'm starting to suspect that QCA6584 is actually based on the same
>> design as QCA6174. If that's the case when we should also think if
>> instead we should add SDIO support to ath10k, maybe by taking relevant
>> parts from ath6kl?
>>=20
>> I'll investigate more what this QCA6584 is, I haven't heard about it
>> before.
>>=20
>
> The reason I have patched to ath6kl driver was that it is the
> only driver with sdio/mbox support.
>
> I was actually thinking of writing a new driver from scratch, but I
> thought that it was less work to modify the existing ath6kl driver.

Ok.

> I just haven't considered the option to add sdio/mbox support to ath10k.
> This is definitely something I will have a look at.
>
> I should mention that I have been using the qcacld2.0 driver as
> "documentation" of the chipset.
>
> The qcacld driver identifies the chipset as AR6320
>
> From the qcacld2.0 driver bmi_msg.h:
>
> #define TARGET_TYPE_AR6320    8
>
> Perhaps this can shed some light on what kind of chip this is?

I'm pretty sure that this is QCA6174 based design which is already
supported by ath10k. So my suggestion is to first look at adding SDIO
support to ath10k and see if that's feasible. We already have PCI code
split from the core code (ath10k_core.ko and ath10k_pci.ko) just because
I was expecting that we would add SDIO and USB support later. That has
just never happened due to lack of time, hopefully you can fix that now
;)

I haven't studied SDIO support at all yet but hopefully WMI, core.c and
mac.c won't need that much modifications. HTT and HTC most likely need
bigger changes. And then you would need to add sdio.c, similarly like we
have pci.c now. Keep in mind that later we might want to add USB support
also so if there's something which both SDIO and USB need to that would
need to be easily sharable. Actually after adding SDIO I hope USB would
be easier to add.

--=20
Kalle Valo=
