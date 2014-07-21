Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45159 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbaGUKDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:03:16 -0400
Message-ID: <1405936987.32255.9.camel@jlt4.sipsolutions.net> (sfid-20140721_120318_614623_1CCA3133)
Subject: Re: [PATCH] mac80211: avoid warning when CONFIG_LOCKDEP is not
 enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com
Date: Mon, 21 Jul 2014 12:03:07 +0200
In-Reply-To: <1403793976-9542-1-git-send-email-luca@coelho.fi>
References: <1403793976-9542-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-26 at 17:46 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> After commit 5bcae31d9 (mac80211: implement multi-vif in-place
> reservations) we get a warning when CONFIG_LOCKDEP is not enabled:
> 
> net/mac80211/chan.c: In function 'ieee80211_vif_get_chanctx':
> net/mac80211/chan.c:69:26: warning: unused variable 'local' [-Wunused-variable]
>   struct ieee80211_local *local = sdata->local;
>                           ^
> Fix this by removing the separate declaration for local and accessing
> it directly in the lockdep_is_held() call.

Huh, sorry, I just fixed this the other day by adding __maybe_unused.

johannes

