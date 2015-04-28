Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53481 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965902AbbD1P6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 11:58:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH 1/2] mwifiex: sdio: create global list of adapters
References: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
Date: Tue, 28 Apr 2015 18:58:15 +0300
In-Reply-To: <1428916704-9635-1-git-send-email-afenkart@gmail.com> (Andreas
	Fenkart's message of "Mon, 13 Apr 2015 11:18:23 +0200")
Message-ID: <87mw1s5joo.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_175825_861454_85AA7C51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Fenkart <afenkart@gmail.com> writes:

> we need to verify that a an adapter pointer, still points to a
> valid adapter. this is not possible through other global structures,
> such as net_namespace_list. the problem with the net_namespace_list
> is that an adapter can have multiple interfaces, hence we had to
> de-reference the maybe invalid pointer to get the interface struct.
>
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/sdio.c | 14 ++++++++++++++
>  drivers/net/wireless/mwifiex/sdio.h |  1 +
>  2 files changed, 15 insertions(+)
>
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index 91e36cd..a70e114 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -69,6 +69,12 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
>  };
>  
>  /*
> + * list of active cards
> + */
> +static LIST_HEAD(cards);
> +static DEFINE_MUTEX(cards_mutex);
> +
> +/*
>   * SDIO probe.
>   *
>   * This function probes an mwifiex device and registers it. It allocates
> @@ -130,6 +136,10 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
>  		ret = -1;
>  	}
>  
> +	mutex_lock(&cards_mutex);
> +	list_add(&card->next, &cards);
> +	mutex_unlock(&cards_mutex);
> +
>  	return ret;
>  }
>  
> @@ -196,6 +206,10 @@ mwifiex_sdio_remove(struct sdio_func *func)
>  	if (!card)
>  		return;
>  
> +	mutex_lock(&cards_mutex);
> +	list_del(&card->next);
> +	mutex_unlock(&cards_mutex);

This is extremely ugly and the commit log doesn't even tell anything
about the issue you trying to fix so it's difficult to even suggest
anything else. For starters can you provide more information, please?
There has to be a better way to solve it.

-- 
Kalle Valo
