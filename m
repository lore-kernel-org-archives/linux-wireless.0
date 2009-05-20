Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49691 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbZETRpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 13:45:18 -0400
Date: Wed, 20 May 2009 13:35:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: split out and decrease probe wait time
Message-ID: <20090520173517.GC7604@tuxdriver.com>
References: <1242151393.11924.3.camel@johannes.local> <1242151886.11924.5.camel@johannes.local> <1242754648.4797.46.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242754648.4797.46.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 07:37:28PM +0200, Johannes Berg wrote:
> You know ... somehow I managed to send out v2 with a wrong interval.
> 
> This was supposed to be / 5 not / 20, should I send a separate patch or
> would you roll this into the original? The commit log says 200ms, but
> the code uses 50ms which is far too short.
> 
> johannes
> 
> ---
>  net/mac80211/mlme.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wireless-testing.orig/net/mac80211/mlme.c	2009-05-19 19:36:00.564057102 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2009-05-19 19:36:04.773067791 +0200
> @@ -33,7 +33,7 @@
>  #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
>  #define IEEE80211_ASSOC_MAX_TRIES 3
>  #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
> -#define IEEE80211_PROBE_WAIT (HZ / 20)
> +#define IEEE80211_PROBE_WAIT (HZ / 5)
>  #define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
>  #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)

Crud, I didn't realize I had already pushed that patch to Dave M.
Could you submit this as a separate patch?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
