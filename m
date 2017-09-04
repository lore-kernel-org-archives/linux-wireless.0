Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:33734 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753994AbdIDTdb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 15:33:31 -0400
Received: by mail-ua0-f171.google.com with SMTP id g47so3583553uad.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Sep 2017 12:33:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eacde476-6130-6ab1-ea09-ceb2d3a58aaa@broadcom.com>
References: <AC37C967-209B-4BC3-9AF2-9CC4C27391C0@lairdtech.com> <eacde476-6130-6ab1-ea09-ceb2d3a58aaa@broadcom.com>
From: Steve deRosier <derosier@gmail.com>
Date: Mon, 4 Sep 2017 12:33:30 -0700
Message-ID: <CALupW3Ck8ELx89DnZ+z1v7igxX6Zgek8pHHeCfSxuN4wCr0mxA@mail.gmail.com> (sfid-20170904_213334_838322_DFE1131F)
Subject: Re: [PATCH v2] brcmfmac: Correctly fail to suspend when SDIO does not
 support power on suspend
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Eric Bentley <Eric.Bentley@lairdtech.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 1, 2017 at 1:02 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> Also note that the wifi chip (the term "radio" does not quite cover it) has
> not really lost power. It is quite common that it is not powered through the
> SDIO bus. With the power-sequence support in the MMC stack these days the
> suspend may result in loss of power. Otherwise, it is just the bus that
> loses power (and clock) and the flags affect what tricks the MMC stack tries
> to pull to get the device accessible again upon resume.
>
Arend,

Indeed - I'm familiar with the platform that Eric is using and it is
exactly as you say: the chip is powered externally. There's some
platform issues here that need to be resolved in addition, but the
change to brcmfmac stands alone OK.

> Maybe you can incorporate some of this in the commit message, but you should
> at least add:
>
> Fixes: 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
> Fixes: bdf1340cf20f ("brcmfmac: fix sdio suspend and resume")
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
>> Signed-off-by: Eric Bentley eric.bentley@lairdtech.com

I've tested the patch on my platforms and works as expected. Eric,
please add my:

Tested-by: Steve deRosier <derosier@gmail.com>

Thanks,
- Steve
