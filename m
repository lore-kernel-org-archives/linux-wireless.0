Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58255 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2D2DvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 23:51:16 -0400
Received: by iadi9 with SMTP id i9so2728922iad.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Apr 2012 20:51:15 -0700 (PDT)
Date: Sat, 28 Apr 2012 23:49:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 12/21] cw1200: sta.*, mac80211 STA callbacks.
Message-ID: <20120429034951.GA32368@localhost> (sfid-20120429_055120_234052_BEF46462)
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <1330720003-15866-13-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330720003-15866-13-git-send-email-dmitry.tarnyagin@stericsson.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

A couple of other quick notes as I read this code:

On Fri, Mar 02, 2012 at 09:26:34PM +0100, Dmitry Tarnyagin wrote:
> +static inline void __cw1200_free_event_queue(struct list_head *list)
> +{
> +	while (!list_empty(list)) {
> +		struct cw1200_wsm_event *event =
> +			list_first_entry(list, struct cw1200_wsm_event,
> +			link);
> +		list_del(&event->link);
> +		kfree(event);
> +	}

I think perhaps you can use list_for_each_entry_safe() here...

> +	LIST_HEAD(list);
[...]
> +	spin_lock(&priv->event_queue_lock);
> +	list_splice_init(&priv->event_queue, &list);
> +	spin_unlock(&priv->event_queue_lock);
> +	__cw1200_free_event_queue(&list);

...and then you won't need to do the above?

> +	if (priv->listening ^ listening) {

That's a unusual (to me anyway) way to spell "a != b".  On my
version of gcc, generated code is exactly the same.

-- 
Bob Copeland %% www.bobcopeland.com
