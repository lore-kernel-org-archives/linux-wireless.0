Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34146 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbcBPGgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 01:36:42 -0500
Received: by mail-ig0-f173.google.com with SMTP id g6so24452011igt.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 22:36:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160215190451.19883.12408.stgit@localhost.localdomain>
References: <20160215190451.19883.12408.stgit@localhost.localdomain>
Date: Tue, 16 Feb 2016 12:06:41 +0530
Message-ID: <CAFqt6zb6Qb46n=U=3owVrU+OfSL=qC_w0eQeSmJ91BfRBQkiSw@mail.gmail.com> (sfid-20160216_073646_416936_FD3244A3)
Subject: Re: [PATCH] rt2x00: unterminated strlen of user data
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2016 at 12:34 AM, Alan <gnomes@lxorguk.ukuu.org.uk> wrote:
> The buffer needs to be zero terminated in case the user data is not.
> Otherwise we run off the end of the buffer.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00debug.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
> index 25ee3cb..72ae530 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
> @@ -478,7 +478,7 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,        \
>  {                                                              \
>         struct rt2x00debug_intf *intf = file->private_data;     \
>         const struct rt2x00debug *debug = intf->debug;          \
> -       char line[16];                                          \
> +       char line[17];                                          \
>         size_t size;                                            \
>         unsigned int index = intf->offset_##__name;             \
>         __type value;                                           \
> @@ -494,7 +494,8 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,        \
>                                                                 \
>         if (copy_from_user(line, buf, length))                  \
>                 return -EFAULT;                                 \
> -                                                               \
> +       line[16] = 0;

            line[length] = '\0';
            correct me if I am wrong.                          \
> +                                               \
>         size = strlen(line);                                    \
>         value = simple_strtoul(line, NULL, 0);                  \
>                                                                 \
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-Souptick
