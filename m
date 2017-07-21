Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33994 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754556AbdGUVTm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 17:19:42 -0400
Received: by mail-lf0-f65.google.com with SMTP id p11so3888041lfd.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jul 2017 14:19:41 -0700 (PDT)
From: Rafal <fatwildcat@gmail.com>
Date: Fri, 21 Jul 2017 23:19:29 +0200 (CEST)
To: Dan Williams <dcbw@redhat.com>
cc: Rafal <fatwildcat@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: brcfmac: add possibility to turn off powersave on wiphy
In-Reply-To: <1500655872.10725.1.camel@redhat.com>
Message-ID: <alpine.DEB.2.20.1707212252060.13284@wilk> (sfid-20170721_231946_398972_39D4202C)
References: <alpine.DEB.2.20.1707211652430.10663@wilk> <1500655872.10725.1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Jul 2017, Dan Williams wrote:

> On Fri, 2017-07-21 at 16:56 +0200, Rafal wrote:
>> I have a board with ap6212 chip and I have encountered two problems
>> with the brcmfmac driver operating with this device. First problem I
>> describe below, second one in separate mail.
>>
>>
>> Namely, I have noticed quite poor connection with the device despite
>> good signal strength. Ping to the device was very uneven, about 50 -
>> 100 ms in average, 10 - 20% of packets loss. After some
>> investigations I have found that problem is caused by powersave
>> feature on wiphy (BRCMF_C_SET_PM command). When the value is set to
>> PM_OFF, the problem does not appear - ping is quite stable, ~2ms.
>> When set to PM_FAST, the ping is bad.
>>
>> The brcmfmac driver currently does not have possibility to turn off
>> the powersave feature. I have added the possibility on 4.11.6 kernel
>
> I don't think that's true?  The driver implements the nl80211
> set_power_mgmt hook, which lets you turn off powersave with 'iw'.  That
> seems like a much better option than a module parameter.  I know other
> drivers have the module parameter, but I personally consider that
> legacy/holdover, given that we have runtime toggles for this kind of
> thing.
>
> brcmf_cfg80211_set_power_mgmt() should do what you need, right?

Yes, it does.

In fact, I needed only a parameter in OF database. This is a bug in the
device or firmware and I needed to disable the feature for this chip.
Many device drivers allow to specify in OF database that driver should
use a quirk. This is similar situation.

I have added the kernel parameter as an additional feature. I thought
that not all platforms are using devicetree database. But maybe it is a
bad idea.

Rafal

>
> Dan
>
