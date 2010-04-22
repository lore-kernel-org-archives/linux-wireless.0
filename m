Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48136 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0DVQeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 12:34:06 -0400
Received: by pvh1 with SMTP id 1so534784pvh.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 09:34:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271944442-9214-1-git-send-email-notasas@gmail.com>
References: <1271944442-9214-1-git-send-email-notasas@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 22 Apr 2010 09:33:40 -0700
Message-ID: <g2o43e72e891004220933i5faec995qae1b358ce66ed2d@mail.gmail.com>
Subject: Re: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 22, 2010 at 6:54 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> Missing uevent_suppress is causing two uevents instead of one, which is
> confusing udev and sometimes causing firmware load to fail due to race
> condition, so let's add it.
>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
>  compat/compat_firmware_class.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
> index ce937a3..54ee8b9 100644
> --- a/compat/compat_firmware_class.c
> +++ b/compat/compat_firmware_class.c
> @@ -432,6 +432,8 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
>        dev_set_drvdata(f_dev, fw_priv);
>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>        dev_set_uevent_suppress(f_dev, 1);
> +#else
> +       f_dev->uevent_suppress = 1;
>  #endif

How was this compiling for older kernels before then?

  Luis
