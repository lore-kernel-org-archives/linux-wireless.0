Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:15911 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3ATJat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 04:30:49 -0500
Message-ID: <50FBB977.7080805@asianux.com> (sfid-20130120_103100_902994_9C461EC9)
Date: Sun, 20 Jan 2013 17:31:35 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: sgruszka@redhat.com, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wireless/iwlegacy: use strlcpy instead of
 strncpy
References: <50EA5246.8060206@asianux.com>
In-Reply-To: <50EA5246.8060206@asianux.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all:

  sorry, after checking the details:
    I think this patch is incorrect.
      we can not assume that the parameter "char *buf" is terminated by '\0'
      so we should only use strlcpy instead of strncpy, without touching 'min(...'

  since it is already integrated into main branch (at least, in next-20130118).
    I should send additional patch to fix it.

  please help to check, thanks.


gchen.


于 2013年01月07日 12:42, Chen Gang 写道:
> 
>   The fields must be null-terminated, or simple_strtoul will cause issue.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/net/wireless/iwlegacy/3945-mac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
> index d604b40..3726cd6 100644
> --- a/drivers/net/wireless/iwlegacy/3945-mac.c
> +++ b/drivers/net/wireless/iwlegacy/3945-mac.c
> @@ -3273,7 +3273,7 @@ il3945_store_measurement(struct device *d, struct device_attribute *attr,
>  
>  	if (count) {
>  		char *p = buffer;
> -		strncpy(buffer, buf, min(sizeof(buffer), count));
> +		strlcpy(buffer, buf, sizeof(buffer));
>  		channel = simple_strtoul(p, NULL, 0);
>  		if (channel)
>  			params.channel = channel;
> 


-- 
Chen Gang

Asianux Corporation
