Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:45402 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZFRMRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 08:17:54 -0400
Received: by fxm8 with SMTP id 8so990966fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 05:17:56 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: push rx status into skb->cb
References: <1245237180.20613.4.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 18 Jun 2009 15:17:53 +0300
In-Reply-To: <1245237180.20613.4.camel@johannes.local> (Johannes Berg's message of "Wed\, 17 Jun 2009 13\:13\:00 +0200")
Message-ID: <87d491n3bi.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From:	Johannes Berg <johannes@sipsolutions.net>
> Subject: [PATCH] mac80211: push rx status into skb->cb
> To:	John Linville <linville@tuxdriver.com>
> Cc:	linux-wireless <linux-wireless@vger.kernel.org>
> Date:	Wed, 17 Jun 2009 13:13:00 +0200
>
> Within mac80211, we often need to copy the rx status into
> skb->cb. This is wasteful, as drivers could be building it
> in there to start with. This patch changes the API so that
> drivers are expected to pass the RX status in skb->cb, now
> accessible as IEEE80211_SKB_RXCB(skb). It also updates all
> drivers to pass the rx status in there, but only by making
> them memcpy() it into place before the call to the receive
> function (ieee80211_rx(_irqsafe)). Each driver can now be
> optimised on its own schedule.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

[...]

>  drivers/net/wireless/wl12xx/rx.c           |    3 -

Last night John applied a patch which renamed this to wl1251_rx.c.

>  drivers/staging/agnx/xmit.c                |    3 -
>  drivers/staging/stlc45xx/stlc45xx.c        |    3 -
>  drivers/staging/winbond/wb35rx.c           |    3 -

John takes staging patches now? And stlc45xx won't even compile right
now :(

-- 
Kalle Valo
