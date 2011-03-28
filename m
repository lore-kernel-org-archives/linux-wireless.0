Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1C1K5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 06:57:12 -0400
Subject: Re: [PATCH] cfg80211: fix BSS double-unlinking (continued)
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1301296295-3082-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1301296295-3082-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 12:57:05 +0200
Message-ID: <1301309825.3850.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-28 at 10:11 +0300, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> This patch adds to the fix "fix BSS double-unlinking"
> (commit 3207390a8b58bfc1335750f91cf6783c48ca19ca) by Johannes Berg.
> 
> It turns out, that the double-unlinking scenario can also occur if expired
> BSS elements are removed whilst an interface is performing association.

Ack,

> To work around that, replace list_del with list_del_init also in the
> "cfg80211_bss_expire" function, so that the check for whether the BSS still is
> in the list works correctly in cfg80211_bss_expire.

but I think you mean cfg80211_unlink_bss there at the end.

Might be worthwhile to create a new static function that rolls up this
code (list_del_init, rb_erase, kref_put) between the two functions?

johannes

