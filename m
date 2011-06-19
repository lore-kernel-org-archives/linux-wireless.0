Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52291 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab1FSUEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 16:04:14 -0400
To: Arik Nemtsov <arik@wizery.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix rx->key NULL dereference during mic failure
References: <1308422749-16939-1-git-send-email-arik@wizery.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 19 Jun 2011 23:04:12 +0300
In-Reply-To: <1308422749-16939-1-git-send-email-arik@wizery.com> (Arik Nemtsov's message of "Sat\, 18 Jun 2011 21\:45\:49 +0300")
Message-ID: <87ips11tc3.fsf@purkki.adurom.net> (sfid-20110619_220418_681360_4EF17055)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> Sometimes when reporting a MIC failure rx->key may be unset. This
> code path is hit when receiving a packet meant for a multicast
> address, and decryption is performed in HW.
>
> Fortunately, the failing key_idx is not used for anything up to
> (and including) usermode, so we allow ourselves to set a bogus one
> when a key cannot be retrieved.

[...]

> -	mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
> +	mac80211_ev_michael_mic_failure(rx->sdata,
> +					rx->key ? rx->key->conf.keyidx : -1,
>  					(void *) skb->data, NULL, GFP_ATOMIC);

In special cases like this a comment in the code would be nice.

-- 
Kalle Valo
