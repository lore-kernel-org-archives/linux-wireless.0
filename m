Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:25511 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0AXN76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 08:59:58 -0500
Received: by ey-out-2122.google.com with SMTP id d26so699330eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 05:59:56 -0800 (PST)
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix update_tkip_key() documentation about the context
References: <20100124125512.14746.63093.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 24 Jan 2010 15:59:54 +0200
In-Reply-To: <20100124125512.14746.63093.stgit@tikku> (Kalle Valo's message of "Sun\, 24 Jan 2010 14\:55\:12 +0200")
Message-ID: <87wrz7ob6t.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> Johannes noticed that I had incorrectly documented the context of
> update_tkip_key() driver operation. It must be atomic because all
> RX code is run inside rcu critical section.
>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>

John, I forgot to mention that this might fix some false warnings
caused by my patch "mac80211: annotate sleeping driver ops". I haven't
seen any reports, yet. Forturnately the patch is not in 2.6.33 AFAIK.

-- 
Kalle Valo
