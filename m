Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59203 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab0GXFdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jul 2010 01:33:13 -0400
Date: Fri, 23 Jul 2010 22:33:01 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: simplify key locking
Message-ID: <20100724053301.GA6773@jm.kir.nu>
References: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 01, 2010 at 10:19:19AM +0200, Johannes Berg wrote:

> net/mac80211/key.c
commit ad0e2b5a00dbec303e4682b403bb6703d11dcdb2

>  void ieee80211_key_free(struct ieee80211_key *key)

> -	if (!key->sdata) {
> -		/* The key has not been linked yet, simply free it
> -		 * and don't Oops */

It looks like this function can still be called with key->sdata == NULL
in some cases and that does indeed result in an oops below:

> +	local = key->sdata->local;


I've seen this issue pop up in FT testing and based on a quick code
review, at least ieee80211_add_key() calls ieee80211_key_free() in an
error case (sta not found) without having first called
ieee80211_key_link(). Which one is wrong - the caller or the freeing
function? Should we just restore the previous key->sdata == NULL handler
here?

I'd guess that the sta-not-found part is caused by FT trying to
configure PTK before association in the FT protocol roaming case
(wpa_supplicant tries to do this as soon as it knows the key because
that works with some drivers and is needed to avoid race condition with
encrypted frames; as a workaround, it will do this again after
association if the previous attempt failed).

-- 
Jouni Malinen                                            PGP id EFC895FA
