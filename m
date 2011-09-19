Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42358 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068Ab1ISFJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 01:09:34 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so4942062fxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 22:09:33 -0700 (PDT)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1316347394-21276-1-git-send-email-eliad@wizery.com>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 08:09:30 +0300
Message-ID: <1316408970.2157.9.camel@cumari> (sfid-20110919_070937_698812_DFC8111D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-18 at 15:03 +0300, Eliad Peller wrote: 
> In some cases the driver might want to change the
> default dynamic ps timeout (e.g. coex activity adds
> latency to the rx/tx path, which might result in
> redundant psm entrance).
> 
> Introduce a new ieee80211_set_dyn_ps_timeout() function
> to let low-level drivers change the default timeout.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---


Let's see what Johannes is going to say about this change in mac80211,
but IIRC this timeout used to exist with WEXT, but it was not
implemented in nl80211.  We (at Nokia, probably Juuso) tried to
implement it a long time ago, but after some discussions with Johannes,
it was decided that this value wouldn't be settable from userspace at
least.  I don't know if it was considered setting it from the driver
side, though.

-- 
Cheers,
Luca.

