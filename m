Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56807.mail.re3.yahoo.com ([66.196.97.81]:39780 "HELO
	web56807.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754701Ab0DVPRz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 11:17:55 -0400
Message-ID: <235843.31139.qm@web56807.mail.re3.yahoo.com>
Date: Thu, 22 Apr 2010 08:17:52 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1271944442-9214-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I reported this nearly a month ago here: http://comments.gmane.org/gmane.linux.kernel.wireless.general/48401

Had a chance to test your patch and everything's fine now. This bug has been existent since January. Great job!


Walter.

--- On Thu, 4/22/10, Grazvydas Ignotas <notasas@gmail.com> wrote:

> From: Grazvydas Ignotas <notasas@gmail.com>
> Subject: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
> To: "Luis R. Rodriguez" <mcgrof@gmail.com>
> Cc: linux-wireless@vger.kernel.org, "Grazvydas Ignotas" <notasas@gmail.com>
> Date: Thursday, April 22, 2010, 9:54 AM
> Missing uevent_suppress is causing
> two uevents instead of one, which is
> confusing udev and sometimes causing firmware load to fail
> due to race
> condition, so let's add it.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
>  compat/compat_firmware_class.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/compat/compat_firmware_class.c
> b/compat/compat_firmware_class.c
> index ce937a3..54ee8b9 100644
> --- a/compat/compat_firmware_class.c
> +++ b/compat/compat_firmware_class.c
> @@ -432,6 +432,8 @@ static int fw_register_device(struct
> device **dev_p, const char *fw_name,
>      dev_set_drvdata(f_dev, fw_priv);
>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>      dev_set_uevent_suppress(f_dev, 1);
> +#else
> +    f_dev->uevent_suppress = 1;
>  #endif
>      retval = device_register(f_dev);
>      if (retval) {
> @@ -479,9 +481,11 @@ static int fw_setup_device(struct
> firmware *fw, struct device **dev_p,
>          goto error_unreg;
>      }
>  
> -#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>      if (uevent)
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>         
> dev_set_uevent_suppress(f_dev, 0);
> +#else
> +       
> f_dev->uevent_suppress = 0;
>  #endif
>      *dev_p = f_dev;
>      goto out;
> -- 
> 1.7.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
