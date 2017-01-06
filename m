Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33992 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965426AbdAFWjV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 17:39:21 -0500
MIME-Version: 1.0
In-Reply-To: <20170106152043.GA6383@rahul>
References: <20170106152043.GA6383@rahul>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 6 Jan 2017 23:39:20 +0100
Message-ID: <CACna6ryhvkSaHgU9igshnMjNg=wgeXd3p57VXxbr0ykoEtLH_g@mail.gmail.com> (sfid-20170106_234002_718723_9C20558F)
Subject: Re: [PATCH] ssb: main.c: This patch removes unnecessary return
 statement using spatch tool
To: Rahul Krishnan <mrahul.krishnan@gmail.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rahul,

On 6 January 2017 at 16:20, Rahul Krishnan <mrahul.krishnan@gmail.com> wrot=
e:
> This patch removes unnecessary return statement using spatch.
> Signed-off-by: Rahul Krishnan <mrahul.krishnan@gmail.com>

Please work on simplifying & making topic more accurate.

You can drop "main.c:" and "This patch".

I don't think this patch really "removes unnecessary return". It looks
like you just dropped assignment/calculation done just before
returning value. That "using spatch tool" part is also misleading. You
don't really use that tool for removing it. More likely it was
noticed/suggested that that tool you use.

Please use commit message for describing your change and don't just
copy & paste topic. You can e.g. put into about "spatch" there
(instead of the topic).


> @@ -1,4 +1,4 @@
> -/*
> + patch /home/rahul/git/kernels/staging/drivers//*
>   * Sonics Silicon Backplane
>   * Subsystem core
>   *

Huh? Looks definitely wrong and I don't think it even compiles
anymore! Make sure to compile code after your change, to make sure it
does & there isn't any new warning.


> @@ -1272,9 +1272,7 @@ u32 ssb_admatch_size(u32 adm)
>         default:
>                 SSB_WARN_ON(1);
>         }
> -       size =3D (1 << (size + 1));
> -
> -       return size;
> +       return (1 << (size + 1));
>  }
>  EXPORT_SYMBOL(ssb_admatch_size);

Please rework your patch, *test it* and resend V2.

--=20
Rafa=C5=82
