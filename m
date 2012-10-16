Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2JPTBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 15:01:12 -0400
Message-ID: <1350414099.10177.13.camel@jlt4.sipsolutions.net> (sfid-20121016_210115_752917_6A40DCA5)
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 16 Oct 2012 21:01:39 +0200
In-Reply-To: <1350226137-13704-2-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	 <1350226137-13704-2-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:

> + * @radar_detect_timeout: this timeout indicates the end of the channel
> + *	availability check for radar channels (in jiffies), only after this
> + *	period the user may initiate the tx on the channel.
> + * @cac_type: indicates that channel availability check is started for this
> + *	channel type.

You're missing docs for cac_started

I'll fix it if I don't have any comments on the other patches and the
answer to my question below doesn't mean a change:

> +++ b/net/wireless/nl80211.c
> @@ -1411,6 +1411,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
>  			result = -EINVAL;
>  			break;
>  		}
> +		channel->cac_started = false;

Why this? If the device supports channel contexts then maybe one vif
could set the channel and the other could be doing radar detection? But
anyway this only presets the channel, so nothing will happen until the
AP interface is started? So basically I don't understand this at all.

It also raises a question: can you do radar detection properly while
doing channel TDM (multi-channel)? I guess not?

johannes

