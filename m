Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:39516 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbeCOK64 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 06:58:56 -0400
Received: by mail-wr0-f170.google.com with SMTP id k3so7789415wrg.6
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 03:58:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <874llk0zhb.fsf@purkki.adurom.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-7-git-send-email-amitkarwar@gmail.com> <874llk0zhb.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 15 Mar 2018 16:28:54 +0530
Message-ID: <CAEhWJFn0LaUKg3OmNFDNm=jbfTiBhGy0SgXDM8gPZ5pmtk-TfA@mail.gmail.com> (sfid-20180315_115906_156563_8744F086)
Subject: Re: [PATCH 06/10] rsi: add module parameter rsi_reg
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 8:55 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> For few regulatory customizations, we are taking rsi_reg
>> as module parameter.
>
> Why?

We have a custom power table and country to region mapping, This
setting will be used only for a special mode called 'dlcar'
We want to have an option to enable this mode through a module parameter.
This patch introduces a module parameter. Next patch makes use of it.
Let me know if you have any suggestions here.

>> +static u16 rsi_reg = RSI_REG_DEF;
>> +module_param(rsi_reg, ushort, 0444)
>> +MODULE_PARM_DESC(rsi_reg, "0 - RSI_REG_DEF, 1 - RSI_REG_DLCAR");
>
> The documentation tells nothing.
>

Below are the details. I will add include this info if the approach
and patches(6/10 and 7/10) look ok to you.
0 - RSI_REG_DEF
         Keep default regulatory configuration
1 - RSI_REG_DLCAR
         Enable custom settings for 'dlcar' mode

Regards,
Amitkumar
