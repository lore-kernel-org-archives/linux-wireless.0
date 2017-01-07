Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34347 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030413AbdAGAw4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 19:52:56 -0500
MIME-Version: 1.0
In-Reply-To: <20170106152043.GA6383@rahul>
References: <20170106152043.GA6383@rahul>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 7 Jan 2017 11:52:35 +1100
Message-ID: <CAGRGNgW8cA_AA0Kgyq--RgkJ4x3=4h-0B-iKRGJNoYTfuG4O5Q@mail.gmail.com> (sfid-20170107_015303_920804_36F91379)
Subject: Re: [PATCH] ssb: main.c: This patch removes unnecessary return
 statement using spatch tool
To: Rahul Krishnan <mrahul.krishnan@gmail.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rahul,

On Sat, Jan 7, 2017 at 2:20 AM, Rahul Krishnan
<mrahul.krishnan@gmail.com> wrote:
> This patch removes unnecessary return statement using spatch.

This doesn't describe the patch.

> Signed-off-by: Rahul Krishnan <mrahul.krishnan@gmail.com>
> ---
>  drivers/ssb/main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index d1a7507..ae3b7fe 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -1,4 +1,4 @@
> -/*
> + patch /home/rahul/git/kernels/staging/drivers//*

What is the purpose of this change, won't this cause the file to fail
to compile?

>   * Sonics Silicon Backplane
>   * Subsystem core
>   *
> @@ -1272,9 +1272,7 @@ u32 ssb_admatch_size(u32 adm)
>         default:
>                 SSB_WARN_ON(1);
>         }
> -       size = (1 << (size + 1));
> -
> -       return size;
> +       return (1 << (size + 1));

Is the size variable used elsewhere? If not, it's declaration should
probably be removed.

Also, there should be a blank line before the return statement.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
