Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:45688 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2G0LmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:42:03 -0400
Message-ID: <50127E88.6020109@tieto.com> (sfid-20120727_134208_368687_F55F4AE4)
Date: Fri, 27 Jul 2012 13:42:00 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC 18/20] mac80211: allow drv_add_chanctx to fail
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net> <1343387816-9414-19-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1343387816-9414-19-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/07/12 13:16, Johannes Berg wrote:
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -237,7 +237,10 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
>
>   	list_add(&ctx->list, &local->chanctx_list);
>
> -	drv_add_chanctx(local, ctx);
> +	if (drv_add_chanctx(local, ctx)) {
> +		kfree(ctx);

We should also do a list_del() here.


> +		return NULL;
> +	}
>
>   	return ctx;
>   }


-- Pozdrawiam / Best regards, Michal Kazior.
