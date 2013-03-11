Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41254 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3CKSLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 14:11:51 -0400
Received: by mail-oa0-f41.google.com with SMTP id i10so4814449oag.28
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 11:11:50 -0700 (PDT)
Message-ID: <513E1E63.8040107@lwfinger.net> (sfid-20130311_191200_405857_818F0946)
Date: Mon, 11 Mar 2013 13:11:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: qca_vkondrat@qca.qualcomm.com, linville@tuxdriver.com,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com
Subject: Re: [PATCH -next] wireless: remove unused including <linux/version.h>
References: <CAPgLHd-Pn9c_FL7v1FYCb8NCP4GdJPuEB-eMSWXiWK5bd8dwVQ@mail.gmail.com>
In-Reply-To: <CAPgLHd-Pn9c_FL7v1FYCb8NCP4GdJPuEB-eMSWXiWK5bd8dwVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2013 09:46 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove including <linux/version.h> that don't need it.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/net/wireless/ath/wil6210/cfg80211.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
> index 116f4e8..58ce52c 100644
> --- a/drivers/net/wireless/ath/wil6210/cfg80211.c
> +++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
> @@ -21,7 +21,6 @@
>   #include <linux/wireless.h>
>   #include <linux/ieee80211.h>
>   #include <linux/slab.h>
> -#include <linux/version.h>
>   #include <net/cfg80211.h>
>
>   #include "wil6210.h"

Your patch should be OK. No built-in driver ever needs to check the kernel version.

Your subject is not very good. Usually, the subject starts with the driver name, 
not the subsystem. Thus if should have been "[PATCH ...] wil6210: ...." or 
"[PATCH ...] ath: wil6210: ....". With this change, a search using 'git log' 
will find that wil6210 was modified here. In your version, that info is missing.

Larry


