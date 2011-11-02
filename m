Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:53336 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1KBLpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 07:45:25 -0400
Received: from [192.168.4.203] (unknown [193.140.74.51])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ozan)
	by lider.pardus.org.tr (Postfix) with ESMTPSA id 36EABA7AAF8
	for <linux-wireless@vger.kernel.org>; Wed,  2 Nov 2011 13:28:06 +0200 (EET)
Message-ID: <4EB12B1A.90806@pardus.org.tr> (sfid-20111102_124529_681738_3774D237)
Date: Wed, 02 Nov 2011 13:35:54 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat: add pm_runtime_enabled() for kver < 2.6.38
References: <1316670659-4785-1-git-send-email-ozan@pardus.org.tr>
In-Reply-To: <1316670659-4785-1-git-send-email-ozan@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

22-09-2011 08:50 tarihinde, Ozan Çağlayan yazdı:
> Without this, the build of wl12xx/sdio.c fails.
>
> Signed-off-by: Ozan Çağlayan<ozan@pardus.org.tr>
> ---
>   include/linux/compat-2.6.38.h |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
> index 1f9ab52..d6da16e 100644
> --- a/include/linux/compat-2.6.38.h
> +++ b/include/linux/compat-2.6.38.h
> @@ -11,6 +11,10 @@
>   /* rename member in struct mmc_host in include/linux/mmc/host.h */
>   #define max_segs	max_hw_segs
>
> +static inline bool pm_runtime_enabled(struct device *dev)
> +{
> +	return !dev->power.disable_depth;
> +}
>
>   /* Exponentially weighted moving average (EWMA) */
>
Any comments?

