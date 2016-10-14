Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34687 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbcJNPij (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 11:38:39 -0400
Received: by mail-lf0-f42.google.com with SMTP id b81so197911156lfe.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2016 08:38:38 -0700 (PDT)
Subject: Re: [RFC 0/5] ath6kl: non WMI data service support
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        Steve deRosier <derosier@gmail.com>
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
 <CALupW3CrY5sZYBcx5Bd3E_M_Kx2sx8_N9h_uexvg_DSO0c-tJA@mail.gmail.com>
 <87y41rbleo.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <656f8674-64b9-0440-f8ae-28177c300b1c@gmail.com> (sfid-20161014_173843_680576_C95C49AA)
Date: Fri, 14 Oct 2016 17:38:35 +0200
MIME-Version: 1.0
In-Reply-To: <87y41rbleo.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/14/2016 06:32 AM, Valo, Kalle wrote:
> Steve deRosier <derosier@gmail.com> writes:
> 
>> Hi Eric,
>>
>> On Thu, Oct 13, 2016 at 9:39 AM, Erik Stromdahl
>> <erik.stromdahl@gmail.com> wrote:
>>> This patch series is intended to prepare the ath6kl driver
>>> for newer chipsets that doesn't use the current WMI data
>>> endpoints for data traffic.
>>>
>>> The chipset I have been working with (and used for testing)
>>> is QCA6584. It is SDIO based (at least the variant I have
>>> been using) with 802.11p WAVE DSRC capabilities.
>>>
>>> This chipset is different from the AR600X family in that
>>> it does not use the WMI data services (service id's 0x101
>>> to 0x104 ) for data traffic.
>>> Instead it uses the HTT data service for data and wmi unified
>>> for control messages.
>>> It is also different when it comes to mailbox addresses
>>> and HTC header format as well, but these differences are not
>>> part of this patch series.
>>>
>>
>> I've only taken a quick look and I'll make specific comments to
>> specific patches later, but I've got to ask the question, should these
>> changes go into ath6kl or be a new driver?
>>
>> Just because the number starts with 6000 doesn't mean it's a ath6kl
>> chip. The 10k series chips all start with 9000 for example, but they
>> rate their own driver.
>>
>> You state that all of the underpinnings of the communication with the
>> chip are totally different:
>> * Doesn't use WMI
>> * Different mailboxing
>> * Different HTC layer
>>
>> If all of the commands and all of the communication layers to the chip
>> are totally different, then perhaps it isn't an ath6kl chip. So if
>> it's largely similar, then OK, but seems to me with the changes you're
>> saying above, it's mostly different.
>>
>> I'm saying all that without any knowledge of this chip. My experience
>> is limited to various versions of the 6003 and 6004 chips.
> 
> Exactly what I was thinking. When I saw terms like "HTT" and "unified
> WMI" my first thought was that is this actually an ath10k based design?
> The product numbers really don't give any indication what driver
> supports, the division goes something like this:
> 
> * ath9k: "non-mobile" 11n chips
> * ath6k: mobile 11n chips
> * ath10k: mobile and "non-mobile" 11ac chips
> 
> For example QCA6174 is an 11ac mobile chip supported by ath10k. ath10k
> only supports PCI bus at the moment, but I'm hoping someone would add
> USB and SDIO support. Patches are very welcome.
> 
> I'm starting to suspect that QCA6584 is actually based on the same
> design as QCA6174. If that's the case when we should also think if
> instead we should add SDIO support to ath10k, maybe by taking relevant
> parts from ath6kl?
> 
> I'll investigate more what this QCA6584 is, I haven't heard about it
> before.
> 

The reason I have patched to ath6kl driver was that it is the
only driver with sdio/mbox support.

I was actually thinking of writing a new driver from scratch, but I
thought that it was less work to modify the existing ath6kl driver.

I just haven't considered the option to add sdio/mbox support to ath10k.
This is definitely something I will have a look at.

I should mention that I have been using the qcacld2.0 driver as
"documentation" of the chipset.

The qcacld driver identifies the chipset as AR6320

>From the qcacld2.0 driver bmi_msg.h:

#define TARGET_TYPE_AR6320    8

Perhaps this can shed some light on what kind of chip this is?
