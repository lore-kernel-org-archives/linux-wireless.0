Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:50399 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXGTFEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 01:04:32 -0400
Received: from mail2.sony.co.jp (localhost [127.0.0.1])
	by mail2.sony.co.jp (R8/Sony) with ESMTP id l6K54Tn1014038
	for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2007 14:04:29 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
	by mail2.sony.co.jp (R8/Sony) with ESMTP id l6K54Tg6014025
	for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2007 14:04:29 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id l6K54TQ14158 for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2007 14:04:29 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id l6K54QRM000945
	for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2007 14:04:27 +0900 (JST)
Date: Fri, 20 Jul 2007 14:04:29 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: Re: remove duplicated ioctl entries in compat_ioctl.c
In-Reply-To: <20070709193744.D021.MOKUNO@sm.sony.co.jp>
References: <20070709193744.D021.MOKUNO@sm.sony.co.jp>
Message-Id: <20070720140020.6773.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

This patch does not look to be applied.  Is it better that I would submit
to other place?

regards

On Mon, 09 Jul 2007 19:54:39 +0900
Masakazu Mokuno <mokuno@sm.sony.co.jp> wrote:

> This patch removes some duplicated wireless ioctl entries in the array
> 'struct ioctl_trans ioctl_start[]' of fs/compat_ioctl.c
> 
> These entries are registered twice like:
> 
> 	COMPATIBLE_IOCTL(SIOCGIWPRIV)
> 
> and
> 
> 	HANDLE_IOCTL(SIOCGIWPRIV, do_wireless_ioctl)
> 
> 
> Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> ---
>  fs/compat_ioctl.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -3156,12 +3156,9 @@ COMPATIBLE_IOCTL(SIOCSIWSENS)
>  COMPATIBLE_IOCTL(SIOCGIWSENS)
>  COMPATIBLE_IOCTL(SIOCSIWRANGE)
>  COMPATIBLE_IOCTL(SIOCSIWPRIV)
> -COMPATIBLE_IOCTL(SIOCGIWPRIV)
>  COMPATIBLE_IOCTL(SIOCSIWSTATS)
> -COMPATIBLE_IOCTL(SIOCGIWSTATS)
>  COMPATIBLE_IOCTL(SIOCSIWAP)
>  COMPATIBLE_IOCTL(SIOCGIWAP)
> -COMPATIBLE_IOCTL(SIOCSIWSCAN)
>  COMPATIBLE_IOCTL(SIOCSIWRATE)
>  COMPATIBLE_IOCTL(SIOCGIWRATE)
>  COMPATIBLE_IOCTL(SIOCSIWRTS)
> 
> 
> --
> Masakazu MOKUNO
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Masakazu MOKUNO

