Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:14039 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdKMIs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 03:48:27 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Daniel Drake <drake@endlessm.com>
CC: Russell Hu <rhu@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Robert Chang <rwchang@qti.qualcomm.com>,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "andy@infradead.org" <andy@infradead.org>
Subject: Re: [v2] ath9k: add MSI support
Date: Mon, 13 Nov 2017 08:48:23 +0000
Message-ID: <87y3na7eei.fsf@qca.qualcomm.com> (sfid-20171113_094831_317623_DAC9DAEA)
References: <20171110025415.7854-1-drake@endlessm.com>
In-Reply-To: <20171110025415.7854-1-drake@endlessm.com> (Daniel Drake's
        message of "Fri, 10 Nov 2017 10:54:15 +0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake <drake@endlessm.com> writes:

>> On new Intel platforms like ApolloLake, legacy interrupt mechanism
>> (INTx) is not supported
>
> Could you please share the background on what you are claiming here.
> I have multiple ApolloLake laptops here with many legacy interrupts
> being used in /proc/interrupts.
>
> I do see this ath9k problem on multiple Acer ApolloLake laptops, however
> I also have an Asus E402NA ApolloLake laptop on hand where the exact same
> ath9k miniPCIe card is working fine with legacy interrupts.
>
>> With module paremeter "use_msi=3D1", ath9k driver would try to
>> use MSI instead of INTx.
>
> In the previous patch review it was suggested that MSI should become
> the default - not a quirk or parameter.
> https://lkml.org/lkml/2017/9/26/64

Enabling MSI by default is just too invasive, ath9k is used in so many
different enviroments that risk of regressions is high. MSI needs a lot
of testing before we can even consider enabling it by default.

> I have tested your patch on Acer Aspire ES1-432. It does not work -
> I still can't connect to wifi.
> /proc/interrupts shows that no MSI interrupts are delivered, the
> counters are 0.
>
> lspci -vv shows:
>         Capabilities: [50] MSI: Enable+ Count=3D1/4 Maskable+ 64bit+
>                 Address: 00000000fee0f00c  Data: 4142
>                 Masking: 0000000e  Pending: 00000000
>
> So MSI is enabled and the vector number is 0x42 (decimal 66).
> However my kernel log is now totally spammed with:
>   do_IRQ: 0.64 No irq handler for vector
>
> My assumption here is that the ath9k hardware implementation of
> MSI is buggy, and it is therefore corrupting the MSI vector number
> by zeroing out the lower 2 bits (e.g. 66 -> 64).
>
> It would be very useful if Qualcomm could confirm if this behaviour
> is really true and if it could potentially be fixed with a new ath9k
> firmware version.

ath9k does not have firmware.

--=20
Kalle Valo=
