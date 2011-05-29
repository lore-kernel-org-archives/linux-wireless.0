Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:4212 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356Ab1E2QsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 12:48:16 -0400
Message-ID: <4DE278CD.3030708@gmail.com> (sfid-20110529_184819_716892_DF8071D3)
Date: Sun, 29 May 2011 18:48:13 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] rt2x00: fix rmmod crash
References: <20110529104529.GA2769@localhost.localdomain>
In-Reply-To: <20110529104529.GA2769@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/11 12:45, Stanislaw Gruszka wrote:
> Do not destroy workqueue, which still can be used by autowakeup_work,
> before ieee80211_unregister_hw() is called.
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Could you add some details of the crash here, e.g. the stack trace of when this occurs, so that
we can understand what is exactly happening that is causing the crash, for our education.

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index c018d67..2f2627b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1165,7 +1165,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  		cancel_work_sync(&rt2x00dev->rxdone_work);
>  		cancel_work_sync(&rt2x00dev->txdone_work);
>  	}
> -	destroy_workqueue(rt2x00dev->workqueue);
>  
>  	/*
>  	 * Free the tx status fifo.
> @@ -1198,6 +1197,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	rt2x00lib_remove_hw(rt2x00dev);
>  
>  	/*
> +	 * Now nobody use workqueue anymore.
> +	 */
> +	destroy_workqueue(rt2x00dev->workqueue);
> +
> +	/*
>  	 * Free firmware image.
>  	 */
>  	rt2x00lib_free_firmware(rt2x00dev);


-- 
---
Gertjan
