Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab1AMJT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 04:19:58 -0500
Subject: Re: [PATCH v2] mwifiex: remove linked list implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1294895783-26539-1-git-send-email-bzhao@marvell.com>
References: <1294895783-26539-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 10:19:40 +0100
Message-ID: <1294910380.3725.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 21:16 -0800, Bing Zhao wrote:

Better,

> +	list_del((struct list_head *) tx_ba_tsr_tbl);

but you shouldn't be casting at all. Do list_del(&tx_ba_tsr_tbl->list);
or so instead, so that this works when the list_head isn't the first
item in the struct.
 
> -	mwifiex_util_init_list((struct mwifiex_linked_list *) &priv->
> -			       tx_ba_stream_tbl_ptr);
> +	INIT_LIST_HEAD((struct list_head *) &priv->tx_ba_stream_tbl_ptr);

Same here. Try to get rid of all casts. If you have any specific ones
that you don't know how to get rid of, feel free to ask.

> -	while (ra_list != (struct mwifiex_ra_list_tbl *) ra_list_hhead) {
> -		if (mwifiex_util_peek_list(&ra_list->buf_head, true))
> +	int is_list_empty;
> +	unsigned long flags;
> +
> +	list_for_each_entry(ra_list, ra_list_hhead, list) {
> +		spin_lock_irqsave(&ra_list->ra_list_tbl_lock, flags);
> +		is_list_empty = list_empty(&ra_list->buf_head);
> +		spin_unlock_irqrestore(&ra_list->ra_list_tbl_lock, flags);
> +		if (!is_list_empty)
>  			return false;
> -
> -		ra_list = (struct mwifiex_ra_list_tbl *) ra_list->next;
>  	}

This seems rather dubious. If the list is empty, the for_each_entry
won't do anything? Or is that some other list?

johannes

