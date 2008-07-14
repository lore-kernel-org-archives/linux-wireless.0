Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:40440 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYGNQOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 12:14:33 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1376366rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 09:14:32 -0700 (PDT)
Message-ID: <fce2a370807140914k153cc12ai1fd741f4ba84d2e1@mail.gmail.com> (sfid-20080714_181437_225335_B20A3035)
Date: Mon, 14 Jul 2008 19:14:32 +0300
From: "Ihar Hrachyshka" <ihar.hrachyshka@gmail.com>
Subject: Re: [PATCH] rtl8187: Fixed section mismatch in rtl8187_dev.c
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it
In-Reply-To: <20080709011159.5b11550b@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080709011159.5b11550b@promwad.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's the status of the patch?

On 7/9/08, Ihar Hrachyshka <ihar.hrachyshka@promwad.com> wrote:
> When CONFIG_HOTPLUG=n the following error occures on vmlinux linkage:
>
> `.exit.text' referenced in section `.data' of drivers/built-in.o:
> defined in discarded section `.exit.text' of drivers/built-in.o
>
> 'rtl8187_disconnect' function marked as __devexit isn't compiled with no
> hotplug support. Added __devexit_p macros to fix the problem.
>
> Signed-off-by: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
>
> ---
>
>  drivers/net/wireless/rtl8187_dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl8187_dev.c
> b/drivers/net/wireless/rtl8187_dev.c index bec96d7..b70cc5d 100644
> --- a/drivers/net/wireless/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl8187_dev.c
> @@ -836,7 +836,7 @@ static struct usb_driver rtl8187_driver = {
>        .name           = KBUILD_MODNAME,
>        .id_table       = rtl8187_table,
>        .probe          = rtl8187_probe,
> -       .disconnect     = rtl8187_disconnect,
> +       .disconnect     = __devexit_p(rtl8187_disconnect),
>  };
>
>  static int __init rtl8187_init(void)
>
> --
> Ihar Hrachyshka
> Software Developer
> Promwad Innovation Company
> 19, Sharangovicha Str.
> 220018, Minsk, Belarus
> Phone/Fax: +375 (17) 211-5826
> Web: www.promwad.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
