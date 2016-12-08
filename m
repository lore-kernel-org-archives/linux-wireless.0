Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36677 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbcLHKa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 05:30:57 -0500
Received: by mail-wm0-f47.google.com with SMTP id g23so210544262wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2016 02:30:56 -0800 (PST)
Subject: Re: [PATCH 1/1] orinoco: fix improper return value
To: Pan Bian <bianpan2016@163.com>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <1481157602-4011-1-git-send-email-bianpan2016@163.com>
Cc: linux-kernel@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ba836a62-d200-e1b0-f046-5604ef8b97dc@broadcom.com> (sfid-20161208_113155_017833_227A0ABF)
Date: Thu, 8 Dec 2016 11:30:53 +0100
MIME-Version: 1.0
In-Reply-To: <1481157602-4011-1-git-send-email-bianpan2016@163.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8-12-2016 1:40, Pan Bian wrote:
> Function orinoco_ioctl_commit() returns 0 (indicates success) when the
> call to orinoco_lock() fails. Thus, the return value is inconsistent with
> the execution status. It may be better to return "-EBUSY" when the call 
> to orinoco_lock() fails.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188671
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/net/wireless/intersil/orinoco/wext.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/orinoco/wext.c b/drivers/net/wireless/intersil/orinoco/wext.c
> index 1d4dae4..fee57ea 100644
> --- a/drivers/net/wireless/intersil/orinoco/wext.c
> +++ b/drivers/net/wireless/intersil/orinoco/wext.c
> @@ -1314,7 +1314,7 @@ static int orinoco_ioctl_commit(struct net_device *dev,
>  		return 0;
>  
>  	if (orinoco_lock(priv, &flags) != 0)
> -		return err;
> +		return -EBUSY;

Actually, orinoco_lock will return either -EBUSY or 0 so maybe better to
just do:

	err = orinoco_lock(priv, &flags);
	if (err < 0)
		return err;

Regards,
Arend

>  	err = orinoco_commit(priv);
>  
> 
