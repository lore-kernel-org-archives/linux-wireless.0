Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:34906 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753953AbdIDUk0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 16:40:26 -0400
Received: by mail-qt0-f178.google.com with SMTP id k2so5708519qte.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Sep 2017 13:40:26 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: Correctly fail to suspend when SDIO does not
 support power on suspend
To: Steve deRosier <derosier@gmail.com>
Cc: Eric Bentley <Eric.Bentley@lairdtech.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <AC37C967-209B-4BC3-9AF2-9CC4C27391C0@lairdtech.com>
 <eacde476-6130-6ab1-ea09-ceb2d3a58aaa@broadcom.com>
 <CALupW3Ck8ELx89DnZ+z1v7igxX6Zgek8pHHeCfSxuN4wCr0mxA@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <da1ce4f2-3d1d-e8c0-36ef-94f8af76c33a@broadcom.com> (sfid-20170904_224030_593316_B6095EAF)
Date: Mon, 4 Sep 2017 22:40:23 +0200
MIME-Version: 1.0
In-Reply-To: <CALupW3Ck8ELx89DnZ+z1v7igxX6Zgek8pHHeCfSxuN4wCr0mxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04-09-17 21:33, Steve deRosier wrote:
> On Fri, Sep 1, 2017 at 1:02 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> Also note that the wifi chip (the term "radio" does not quite cover it) has
>> not really lost power. It is quite common that it is not powered through the
>> SDIO bus. With the power-sequence support in the MMC stack these days the
>> suspend may result in loss of power. Otherwise, it is just the bus that
>> loses power (and clock) and the flags affect what tricks the MMC stack tries
>> to pull to get the device accessible again upon resume.
>>
> Arend,
> 
> Indeed - I'm familiar with the platform that Eric is using and it is
> exactly as you say: the chip is powered externally. There's some
> platform issues here that need to be resolved in addition, but the
> change to brcmfmac stands alone OK.

Sure thing. I was not arguing the fix itself. Just wanted to clarify the 
terms used in the commit message.

Regards,
Arend
