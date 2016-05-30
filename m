Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34641 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbcE3An6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 20:43:58 -0400
Received: by mail-oi0-f67.google.com with SMTP id r64so22736061oie.1
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2016 17:43:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com>
References: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 30 May 2016 10:43:37 +1000
Message-ID: <CAGRGNgXO-XyS4B7XpXgbjGzHL28vK2Bux2d+s7Kzb0VuwiBG=w@mail.gmail.com> (sfid-20160530_024401_710694_9A095F0F)
Subject: Re: [PATCH] iw: Fix -Wabsolute-value compiler warning in iw.c
To: Aurimas Liutikas <aurimas@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aurimas,

On Fri, May 13, 2016 at 2:16 AM, Aurimas Liutikas <aurimas@google.com> wrote:

You really should add a little more explanation here and include the
exact compiler output you're fixing and mention that this option is
only available with Clang.

> Signed-off-by: Aurimas Liutikas <aurimas@google.com>

Other than that, it looks good to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

One final note, any patch you send to linux-wireless gets entered into
patchwork, so there's no need to keep asking for a review, people are
busy and will get to it eventually.

Thanks,

Julian Calaby

> diff --git a/iw.c b/iw.c
> index 2aabddb..a6efe5b 100644
> --- a/iw.c
> +++ b/iw.c
> @@ -516,7 +516,7 @@ int main(int argc, char **argv)
>         const struct cmd *cmd = NULL;
>
>         /* calculate command size including padding */
> -       cmd_size = abs((long)&__section_set - (long)&__section_get);
> +       cmd_size = labs((long)&__section_set - (long)&__section_get);
>         /* strip off self */
>         argc--;
>         argv0 = *argv++;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
