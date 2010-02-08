Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46888 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0BHJXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 04:23:52 -0500
Received: by wwi18 with SMTP id 18so1625914wwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 01:23:51 -0800 (PST)
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl algorithm
References: <20100207214837.027dfd3d@mycelium.queued.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 08 Feb 2010 11:23:47 +0200
In-Reply-To: <20100207214837.027dfd3d@mycelium.queued.net> (Andres Salomon's message of "Sun\, 7 Feb 2010 21\:48\:37 -0500")
Message-ID: <87vde8gjx8.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andres Salomon <dilinger@collabora.co.uk> writes:

> I discovered that if EMBEDDED=y, one can accidentally build a
> mac80211 stack w/ no rate control algorithm. When RC_MINISTREL and
> RC_PID are both disabled, the RC_DEFAULT string (which rate.c uses
> as the fallback algorithm) will be "". That'll cause the
> rate_control_alloc to fail, which will in turn cause
> ieee80211_register_hw to fail. IOW, no driver will load.

There are devices that don't need rate control algorithm, for example
wl1271 (see IEEE80211_HW_HAS_RATE_CONTROL). A better solution is
instead to fix rate_control_alloc() to handle this, or something
similar.

-- 
Kalle Valo
