Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3AIMh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 07:37:56 -0500
Message-ID: <1357735100.9757.9.camel@jlt4.sipsolutions.net> (sfid-20130109_133800_451892_90E0471E)
Subject: Re: [PATCH] mac80211: fix delayed ADDBA response
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 13:38:20 +0100
In-Reply-To: <1357654597-8493-1-git-send-email-victorg@ti.com>
References: <1357654597-8493-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 16:16 +0200, Victor Goldenshtein wrote:
> Block frame processing during scan might delay the
> ADDBA response, which eventually timeouts and
> significantly reduces the device throughput.
> Remove this constrain as it's not required for the
> HW scan.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  net/mac80211/iface.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 06fac29..a26ee36 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1063,7 +1063,7 @@ static void ieee80211_iface_work(struct work_struct *work)
>  	if (!ieee80211_sdata_running(sdata))
>  		return;
>  
> -	if (local->scanning)
> +	if (local->scanning && !local->ops->hw_scan)
>  		return;

Regardless of whether it should check the HW scan flag (I think that'd
be better), this doesn't seem right.

Do we really want to allow arbitrary changes to the interfaces while
scanning? This could process a deauth frame for example, I'm worried
that might break things.

johannes

