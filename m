Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58708 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753602AbeDMLTO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 07:19:14 -0400
Received: from mail-lf0-f72.google.com ([209.85.215.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <alfonso.sanchez-beato@canonical.com>)
        id 1f6wjZ-000594-5A
        for linux-wireless@vger.kernel.org; Fri, 13 Apr 2018 11:19:13 +0000
Received: by mail-lf0-f72.google.com with SMTP id h22-v6so1868070lfj.21
        for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2018 04:19:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zi27s7pj.fsf@kamboji.qca.qualcomm.com>
References: <20180412154159.13934-1-alfonso.sanchez-beato@canonical.com> <87zi27s7pj.fsf@kamboji.qca.qualcomm.com>
From: Alfonso Sanchez-Beato <alfonso.sanchez-beato@canonical.com>
Date: Fri, 13 Apr 2018 13:19:11 +0200
Message-ID: <CACM4vuDrEu0fz_hqh17kzuaQ8F8TCCr-uqt1rZttk1m8_fPTaA@mail.gmail.com> (sfid-20180413_131917_357391_F8E68E81)
Subject: Re: [PATCH] ath6kl: use WMI to set RSN capabilities
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 13, 2018 at 12:48 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
> Alfonso Sánchez-Beato <alfonso.sanchez-beato@canonical.com> writes:
>
> > This fixes AP mode when the ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE flag
> > is not present in the FW. The id of some WMI commands is also fixed
> > (there was an error in the enum order), and a function to set RSN caps
> > is added.
> >
> > Signed-off-by: Alfonso Sánchez-Beato <alfonso.sanchez-beato@canonical.com>
>
> What hardware and firmware version? Do note that ids can change between
> ath6kl firmware branches so even if it works for you it might break some
> other branch. That's why it's good to document the setup in the commit
> log.

I have tested this in an Atheros QCA6234. kmsg shows this about the fw:

ath6kl: ar6004 hw 3.0 sdio fw 3.5.0.604 api 1
ath6kl: firmware supports: 64bit-rates,ap-inactivity-mins

The fw file is AR6004/hw3.0/fw.ram.bin

>
> --
> Kalle Valo
