Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42284 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbcAFKcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 05:32:08 -0500
Message-ID: <1452076319.2541.3.camel@sipsolutions.net> (sfid-20160106_113312_282636_C479BEC1)
Subject: Re: [PATCH] net/rfkill: Create "airplane mode" LED trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Wed, 06 Jan 2016 11:31:59 +0100
In-Reply-To: <6DC3AA8C-DDE9-44B8-91C5-94B1EB0DBE9A@holtmann.org>
References: <1451142303-1872-1-git-send-email-jprvita@endlessm.com>
	 <1451142303-1872-2-git-send-email-jprvita@endlessm.com>
	 <6DC3AA8C-DDE9-44B8-91C5-94B1EB0DBE9A@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 22:55 -0800, Marcel Holtmann wrote:
> 
> so I am not convinced the kernel should have the concept of airplane
> mode at all.

[snip long story]

This is true, but that doesn't mean the patch is bad, just the naming
could be different.

I think the patch could name this "rfkill-all" (or so) instead, and
replace all the "airplane_mode" identifiers as well.

Then the driver can still default to "rfkill-all" trigger, or a
suitably interested userspace could remove the trigger and manage the
LED state itself.

Then again - if I think about that more - perhaps the kernel *should*
have a concept of airplane mode, just one that's not necessarily tied
to the "rfkill_all" setting, but could be controlled by userspace. That
way, userspace wouldn't have to know about the LED, just about the
airplane mode indicator (for which rfkill would probably be an
appropriate place)

Two comments on the patch itself:

> +#ifdef CONFIG_RFKILL_LEDS
> +       led_trigger_register(&amp;airplane_mode_led_trigger);
> +#endif

Everything else uses inlines to avoid ifdefs, you can do the same here.
Also, error handling seems necessary.

johannes

