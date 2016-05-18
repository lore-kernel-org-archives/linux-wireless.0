Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:35338 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbcERQML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 12:12:11 -0400
Received: by mail-yw0-f178.google.com with SMTP id g133so52867468ywb.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2016 09:12:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com>
References: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com>
From: Aurimas Liutikas <aurimas@google.com>
Date: Wed, 18 May 2016 09:12:09 -0700
Message-ID: <CAFiGRCH9LE+7vkkQonJ4YfvbitxWT+OJfFWrV1hZ5ZE_5-j-tQ@mail.gmail.com> (sfid-20160518_181217_921161_58FFB4BD)
Subject: Re: [PATCH] iw: Fix -Wabsolute-value compiler warning in iw.c
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey there! Any thoughts on this patch?

Aurimas

On Thu, May 12, 2016 at 9:16 AM, Aurimas Liutikas <aurimas@google.com> wrote:
> Signed-off-by: Aurimas Liutikas <aurimas@google.com>
>
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



-- 

 Aurimas Liutikas | Software Engineer | Chrome / Google
