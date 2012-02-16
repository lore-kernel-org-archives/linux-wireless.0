Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39017 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2BPT77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 14:59:59 -0500
Received: by eekc14 with SMTP id c14so1053331eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2012 11:59:57 -0800 (PST)
References: <1329421499-10237-1-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1329421499-10237-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <124406DA-F46F-4641-9BAE-7FAE7388C1C1@gmail.com> (sfid-20120216_210002_598485_DB0A428F)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2x00: fix a possible NULL pointer dereference
Date: Thu, 16 Feb 2012 20:59:53 +0100
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 16 feb. 2012, at 20:44, Gabor Juhos <juhosg@openwrt.org> wrote:

> The 'rt2x00lib_probe_dev' function tries to
> allocate the workqueue. If the allocation
> fails, 'rt2x00_lib_remove_dev' is called on
> the error path. Because 'rt2x00dev->workqueue'
> is NULL in this case, the 'destroy_workqueue'
> call will cause a NULL pointer dereference.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Good catch.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index bae5b01..d62e64f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1232,7 +1232,8 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>        cancel_work_sync(&rt2x00dev->rxdone_work);
>        cancel_work_sync(&rt2x00dev->txdone_work);
>    }
> -    destroy_workqueue(rt2x00dev->workqueue);
> +    if (rt2x00dev->workqueue)
> +        destroy_workqueue(rt2x00dev->workqueue);
> 
>    /*
>     * Free the tx status fifo.
> -- 
> 1.7.2.1
> 
> 
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
