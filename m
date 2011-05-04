Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:34248 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab1EDUIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 16:08:50 -0400
Received: by mail-ey0-f172.google.com with SMTP id 13so527530eye.31
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 13:08:48 -0700 (PDT)
Subject: Re: [PATCH] mac80211: don't start the dynamic ps timer if not
 associated
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	ido@wizery.com
In-Reply-To: <1304448008-7816-1-git-send-email-coelho@ti.com>
References: <1304448008-7816-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 23:08:45 +0300
Message-ID: <1304539725.12586.382.camel@cumari> (sfid-20110504_220853_401768_BC55EA50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 21:40 +0300, Luciano Coelho wrote:
> When we are disconnecting, we set PS off, but this happens before we
> send the deauth/disassoc request.  When the deauth/disassoc frames are
> sent, we trigger the dynamic ps timer, which then times out and turns
> PS back on.  Thus, PS remains on after disconnecting, causing problems
> when associating again.
> 
> This can be fixed by preventing the timer to start when we're not
> associated anymore.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  net/mac80211/tx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index e3e3aa1..21accf8 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -237,6 +237,10 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
>  				     &local->dynamic_ps_disable_work);
>  	}
>  
> +	/* Don't restart the timer if we're not disassociated */
> +	if (!ifmgd->associated)
> +		return TX_CONTINUE;
> +
>  	mod_timer(&local->dynamic_ps_timer, jiffies +
>  		  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>  

Do you people think this should go into 2.6.39?

-- 
Cheers,
Luca.

