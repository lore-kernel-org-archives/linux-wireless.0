Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:25680 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbYHCHla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 03:41:30 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1998200ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 00:41:27 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/8] rfkill: detect bogus double-registering (v2)
Date: Sun, 3 Aug 2008 10:04:50 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217700664-20792-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808031004.50634.IvDoorn@gmail.com> (sfid-20080803_094133_755246_246A614D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> Detect and abort with -EEXIST if rfkill_register is called twice on the
> same rfkill struct.  And WARN_ON(it) for good measure.
> 
> While at it, flag when we are adding the first switch of a type, we will
> need that information later.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |   29 ++++++++++++++++++++++++++++-
>  1 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 2ec6312..297bfd5 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -533,17 +533,44 @@ static struct class rfkill_class = {
>  	.dev_uevent	= rfkill_dev_uevent,
>  };
>  
> +static int rfkill_check_duplicity(const struct rfkill *rfkill)
> +{
> +	struct rfkill *p;
> +	unsigned long seen[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
> +
> +	memset(seen, 0, sizeof(seen));
> +
> +	list_for_each_entry(p, &rfkill_list, node) {
> +		if (p == rfkill) {
> +			WARN_ON(1);
> +			return -EEXIST;
> +		}
> +		set_bit(p->type, seen);
> +	}
> +
> +	/* 0: first switch of its kind */
> +	return test_bit(rfkill->type, seen);
> +}
> +
>  static int rfkill_add_switch(struct rfkill *rfkill)
>  {
> +	int error;
> +
>  	mutex_lock(&rfkill_mutex);
>  
> +	error = rfkill_check_duplicity(rfkill);
> +	if (error < 0)
> +		goto unlock_out;
> +
>  	rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type], 0);
>  
>  	list_add_tail(&rfkill->node, &rfkill_list);
>  
> +	error = 0;
> +unlock_out:
>  	mutex_unlock(&rfkill_mutex);
>  
> -	return 0;
> +	return error;
>  }
>  
>  static void rfkill_remove_switch(struct rfkill *rfkill)


