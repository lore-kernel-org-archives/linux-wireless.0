Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:38684 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdGYL62 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 07:58:28 -0400
Received: by mail-wr0-f178.google.com with SMTP id f21so61541095wrf.5
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2017 04:58:27 -0700 (PDT)
Message-ID: <59773261.5030100@broadcom.com> (sfid-20170725_135832_673227_ECA5697B)
Date: Tue, 25 Jul 2017 13:58:25 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Rafal <fatwildcat@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: brcfmac: add possibility to turn off powersave on wiphy
References: <alpine.DEB.2.20.1707211652430.10663@wilk> <1500655872.10725.1.camel@redhat.com> <alpine.DEB.2.20.1707212252060.13284@wilk>
In-Reply-To: <alpine.DEB.2.20.1707212252060.13284@wilk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/21/2017 11:19 PM, Rafal wrote:
> On Fri, 21 Jul 2017, Dan Williams wrote:
>
>> On Fri, 2017-07-21 at 16:56 +0200, Rafal wrote:
>>> I have a board with ap6212 chip and I have encountered two problems
>>> with the brcmfmac driver operating with this device. First problem I
>>> describe below, second one in separate mail.
>>>
>>>
>>> Namely, I have noticed quite poor connection with the device despite
>>> good signal strength. Ping to the device was very uneven, about 50 -
>>> 100 ms in average, 10 - 20% of packets loss. After some
>>> investigations I have found that problem is caused by powersave
>>> feature on wiphy (BRCMF_C_SET_PM command). When the value is set to
>>> PM_OFF, the problem does not appear - ping is quite stable, ~2ms.
>>> When set to PM_FAST, the ping is bad.
>>>
>>> The brcmfmac driver currently does not have possibility to turn off
>>> the powersave feature. I have added the possibility on 4.11.6 kernel
>>
>> I don't think that's true?  The driver implements the nl80211
>> set_power_mgmt hook, which lets you turn off powersave with 'iw'.  That
>> seems like a much better option than a module parameter.  I know other
>> drivers have the module parameter, but I personally consider that
>> legacy/holdover, given that we have runtime toggles for this kind of
>> thing.
>>
>> brcmf_cfg80211_set_power_mgmt() should do what you need, right?
>
> Yes, it does.
>
> In fact, I needed only a parameter in OF database. This is a bug in the
> device or firmware and I needed to disable the feature for this chip.
> Many device drivers allow to specify in OF database that driver should
> use a quirk. This is similar situation.
>
> I have added the kernel parameter as an additional feature. I thought
> that not all platforms are using devicetree database. But maybe it is a
> bad idea.

I was going to make the same remark as Dan. Anyway, the ping times are 
not really unexpected. It depends on your beacon period and dtim 
setting. However, the packet loss is not expected and will require 
analyzing a sniff capture.

Regards,
Arend
