Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589AbaDIMrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 08:47:49 -0400
Message-ID: <1397047651.4964.15.camel@jlt4.sipsolutions.net> (sfid-20140409_144753_647092_05CBDAF8)
Subject: Re: [PATCH 3/8] mac80211: fix possible compile warning in michael.h
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Apr 2014 14:47:31 +0200
In-Reply-To: <0c2fa5b7a8724d0ee405afd05f393af95e65116c.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032855_945110_A8572F5D)
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	 <0c2fa5b7a8724d0ee405afd05f393af95e65116c.1397006688.git.gamerh2o@gmail.com>
	 (sfid-20140409_032855_945110_A8572F5D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 09:28 +0800, Zhao, Gang wrote:
> The warning doesn't show up due to duplicate including, but it's worth
> fixing it.
> 
> net/mac80211//michael.h:22:4: warning: ‘struct ieee80211_hdr’ declared inside parameter list [enabled by default]
>     const u8 *data, size_t data_len, u8 *mic);
>     ^
> net/mac80211//michael.h:22:4: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> 
> Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
> ---
>  net/mac80211/michael.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/michael.h b/net/mac80211/michael.h
> index 3b848da..b259547 100644
> --- a/net/mac80211/michael.h
> +++ b/net/mac80211/michael.h
> @@ -10,7 +10,7 @@
>  #ifndef MICHAEL_H
>  #define MICHAEL_H
>  
> -#include <linux/types.h>
> +#include <linux/ieee80211.h>

This should probably include both now though.

johannes

