Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:51319 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0LVVTl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 16:19:41 -0500
Subject: Re: [PATCH v2 05/18] wl1271: AP mode - workaround for FW bug on
 station remove
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-6-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-6-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 23:19:38 +0200
Message-ID: <1293052778.14423.43.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Sometimes an event indicating station removal is not sent up by
> firmware. We work around this by always indicating success in when
> a wait for the event timeouts.
> 
> Temporary workaround until a FW fix is introduced.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> @@ -1108,9 +1122,11 @@ int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid)
>  		goto out_free;
>  	}
>  
> -	ret = wl1271_cmd_wait_for_event(wl, STA_REMOVE_COMPLETE_EVENT_ID);
> -	if (ret < 0)
> -		wl1271_error("cmd remove sta event completion error");
> +	/*
> +	 * We are ok with a timeout here. The event is sometimes not sent
> +	 * due to a firmware bug.
> +	 */
> +	wl1271_cmd_wait_for_event_or_timeout(wl, STA_REMOVE_COMPLETE_EVENT_ID);

Why wait for the event at all then?


-- 
Cheers,
Luca.

