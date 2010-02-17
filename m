Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f180.google.com ([209.85.210.180]:56464 "EHLO
	mail-yx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0BQSaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:30:46 -0500
Received: by yxe10 with SMTP id 10so215485yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 10:30:44 -0800 (PST)
Message-ID: <4B7C35C9.30607@lwfinger.net>
Date: Wed, 17 Feb 2010 12:30:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: okias <d.okias@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	herton@mandriva.com.br, htl10@users.sourceforge.net
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
In-Reply-To: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2010 12:15 PM, okias wrote:
>>From 3f02b3ec0c3e6d7fa0599de12af0b76150854b94 Mon Sep 17 00:00:00 2001
> From: David Heidelberger <d.okias@gmail.com>
> Date: Wed, 17 Feb 2010 19:13:46 +0100
> Subject: [PATCH] rtl8187: micro cleanup
> 
> ---
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index 7ba3052..2fe0c84 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -1175,8 +1175,6 @@ static void rtl8187_bss_info_changed(struct
> ieee80211_hw *dev,
> 
>  		if (priv->is_rtl8187b)
>  			reg = RTL818X_MSR_ENEDCA;
> -		else
> -			reg = 0;
> 
>  		if (is_valid_ether_addr(info->bssid)) {
>  			reg |= RTL818X_MSR_INFRA;

Did you forget the initialization to 0 when you declare the variable? It was in
the first version. This change will cause the RTL8187L to fail.

Larry
