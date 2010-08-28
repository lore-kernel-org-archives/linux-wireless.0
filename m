Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35245 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab0H1GWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 02:22:09 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3/3] wl12xx: remove unneeded locking
References: <20100826113024.738612439@sipsolutions.net>
	<20100826113438.826909320@sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 28 Aug 2010 09:22:01 +0300
In-Reply-To: <20100826113438.826909320@sipsolutions.net> (Johannes Berg's message of "Thu\, 26 Aug 2010 13\:30\:27 +0200")
Message-ID: <87fwxz8dfa.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> With the scan callback now being callable from
> any context, these unlocks/locks can go away.
> This makes the code easier to understand, since
> callers of these functions must no longer be
> aware that the mutex may be dropped.
>
> As Stanislaw is working on iwlwifi scanning, I
> didn't change it to take advantage of the new
> mac80211 semantics.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/wl12xx/wl1251_event.c |    2 --
>  drivers/net/wireless/wl12xx/wl1251_main.c  |    2 --

Thanks, wl1251 part looks good. I didn't test them yet, but will do
soon.

-- 
Kalle Valo
