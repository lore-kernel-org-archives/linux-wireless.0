Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36042 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbcARJId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 04:08:33 -0500
Received: by mail-io0-f172.google.com with SMTP id g73so350960702ioe.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 01:08:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8737tv7198.fsf@kamboji.qca.qualcomm.com>
References: <1452958753-12307-1-git-send-email-aspriel@gmail.com>
	<8737tv7198.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 18 Jan 2016 10:08:32 +0100
Message-ID: <CAMuHMdVq58-v4OED_A2X7c1f+C=h8H=en_maxHq9A+H_cHYXWA@mail.gmail.com> (sfid-20160118_100846_895723_6C5D7363)
Subject: Re: [PATCH] brcmfmac: fix BRCMF_FW_NVRAM_DEF macro for older gcc compilers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <aspriel@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2016 at 9:14 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arend van Spriel <aspriel@gmail.com> writes:
>
>> With gcc < 4.3 __UNIQUE_ID does not create unique ids with the macro
>> BRCMF_FW_NVRAM_DEF. Fix this by removing the MODULE_FIRMWARE instance
>> for the nvram file. This file is not in linux-firmware repo so it may
>> not be needed anyway. Otherwise consider this as a temporary fix.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Arend van Spriel <aspriel@gmail.com>
>
> Thanks. Geert, it would be great if you could test this.

Thanks, this fixes this build failure, so

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

(unfortunately) now up to the next one...

> Dave, if Geert says the patch is ok do you mind taking this directly? I
> would like to fix this build breakage quickly.
>
> https://patchwork.kernel.org/patch/8049181/
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
