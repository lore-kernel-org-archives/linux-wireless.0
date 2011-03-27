Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab1C0Ld4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 07:33:56 -0400
Subject: Re: [PATCH v2] mac80211: fix NULL pointer dereference in
 ieee80211_key_alloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Petr =?UTF-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301225486-23597-1-git-send-email-ynezz@true.cz>
References: <1301217408.3826.2.camel@jlt3.sipsolutions.net>
	 <1301225486-23597-1-git-send-email-ynezz@true.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 13:33:53 +0200
Message-ID: <1301225633.3826.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-03-27 at 13:31 +0200, Petr Štetiar wrote:
> The ieee80211_key struct can be kfree()d several times in the function, for
> example if some of the key setup functions fails beforehand, but there's no
> check if the struct is still valid before we call memcpy() and INIT_LIST_HEAD()
> on it.  In some cases (like it was in my case), if there's missing aes-generic
> module it could lead to the following kernel OOPS:
> 
> 	Unable to handle kernel NULL pointer dereference at virtual address 0000018c
> 	....
> 	PC is at memcpy+0x80/0x29c
> 	...
> 	Backtrace:
> 	[<bf11c5e4>] (ieee80211_key_alloc+0x0/0x234 [mac80211]) from [<bf1148b4>] (ieee80211_add_key+0x70/0x12c [mac80211])
> 	[<bf114844>] (ieee80211_add_key+0x0/0x12c [mac80211]) from [<bf070cc0>] (__cfg80211_set_encryption+0x2a8/0x464 [cfg80211])
> 
> Signed-off-by: Petr Štetiar <ynezz@true.cz>
> CC: Johannes Berg <johannes@sipsolutions.net>

Thanks!

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/key.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index 8c02469..09cf1f2 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -342,7 +342,7 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
>  		if (IS_ERR(key->u.ccmp.tfm)) {
>  			err = PTR_ERR(key->u.ccmp.tfm);
>  			kfree(key);
> -			key = ERR_PTR(err);
> +			return ERR_PTR(err);
>  		}
>  		break;
>  	case WLAN_CIPHER_SUITE_AES_CMAC:
> @@ -360,7 +360,7 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
>  		if (IS_ERR(key->u.aes_cmac.tfm)) {
>  			err = PTR_ERR(key->u.aes_cmac.tfm);
>  			kfree(key);
> -			key = ERR_PTR(err);
> +			return ERR_PTR(err);
>  		}
>  		break;
>  	}


