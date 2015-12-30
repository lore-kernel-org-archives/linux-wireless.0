Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35025 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbbL3OKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 09:10:18 -0500
Received: by mail-ig0-f178.google.com with SMTP id to4so179773253igc.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 06:10:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451477744-11975-17-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
	<1451477744-11975-17-git-send-email-chaehyun.lim@gmail.com>
Date: Wed, 30 Dec 2015 19:40:18 +0530
Message-ID: <CAFqt6zbZoZAoNrD0LwAxKwtxQT3Yf4=PsyW+mYaYuEf+Bd2j-Q@mail.gmail.com> (sfid-20151230_151022_284711_28C086F4)
Subject: Re: [PATCH 17/20] staging: wilc1000: fix return type of host_int_get_ipaddress
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lim,

On Wed, Dec 30, 2015 at 5:45 PM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> This patch changes return type of host_int_get_ipaddress from s32 to
> int. The result variable gets return value from wilc_mq_send that has
> data type of int. It should be changed return type of this function as
> well as data type of result variable.
>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 90fdbdd..a203647 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -362,7 +362,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
>         return result;
>  }
>
> -static s32 host_int_get_ipaddress(struct wilc_vif *vif,
> +static int host_int_get_ipaddress(struct wilc_vif *vif,
>                                   struct host_if_drv *hif_drv,
>                                   u8 *u16ipadd, u8 idx);
>
    s32 and int both are same. isn't it ?

> @@ -4664,11 +4664,11 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
>         return result;
>  }
>
> -static s32 host_int_get_ipaddress(struct wilc_vif *vif,
> +static int host_int_get_ipaddress(struct wilc_vif *vif,
>                                   struct host_if_drv *hif_drv,
>                                   u8 *u16ipadd, u8 idx)
>  {
> -       s32 result = 0;
> +       int result = 0;
>         struct host_if_msg msg;
>
>         if (!hif_drv) {
> --
> 2.6.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-Souptick
