Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1C0JQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 05:16:51 -0400
Subject: Re: [PATCH] mac80211: fix NULL pointer dereference in
 ieee80211_key_alloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Petr =?UTF-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301160762-8409-1-git-send-email-ynezz@true.cz>
References: <1301160762-8409-1-git-send-email-ynezz@true.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 11:16:48 +0200
Message-ID: <1301217408.3826.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Petr,

On Sat, 2011-03-26 at 18:32 +0100, Petr Štetiar wrote:
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

Thanks for the patch, good find.

> @@ -364,8 +364,11 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
>  		}
>  		break;
>  	}
> -	memcpy(key->conf.key, key_data, key_len);
> -	INIT_LIST_HEAD(&key->list);
> +
> +	if (!IS_ERR(key)) {
> +		memcpy(key->conf.key, key_data, key_len);
> +		INIT_LIST_HEAD(&key->list);
> +	}

I think instead we should change the two IS_ERR(tfm) places to:

	if (IS_ERR(key->u.xxx.tfm)) {
		err = PTR_ERR(...);
		kfree(key);
		return ERR_PTR(err);
	}

Do you want to submit a patch for that, or would you prefer me to handle
it?

johannes

