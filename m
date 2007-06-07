Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50823 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761588AbXFGUTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:19:33 -0400
Date: Thu, 7 Jun 2007 22:19:39 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
Message-ID: <20070607221939.444e9d74@griffin.suse.cz>
In-Reply-To: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 02 Jun 2007 13:51:59 -0500, Larry Finger wrote:
> The initial rate for STA's using rc80211_simple is set to the last
> rate in the rate table. This is too fast for the bcm43xx-mac80211
> driver. To correct this situation without affecting any other driver,
> an initial_rate parameter is added to the rc80211_simple module. This
> parameter is set to 10 times the desired initial rate. If the parameter
> is zero or not set, the original behavior is kept. If the parameter
> does not match a valid rate, the first rate in the table will be set.

Don't misuse module parameters, please. If you have more devices, this
single parameter will affect all of them. That's not a good approach,
especially when the value you are trying to change can be changed on
the fly.

I understand the problems you have with tx power control, but modifying
a stack because of a buggy driver (I know it's not your nor anyone
else's fault and nothing can be done with this now) isn't a right way
to go.

The correct approach is to write a new rate control module. Note that
this should be still understood as a temporary solution, as you have no
factual reason for depending on a specific rate control module.

See the following patches.

However, I'm not against setting the initial value to the lowest rate
available. As Johannes pointed out, if the rate control algorithm isn't
able to quickly migrate to higher rates, it's a good candidate for
rewrite.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
