Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52748 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaK3NOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 08:14:17 -0500
Message-ID: <1417353252.2156.4.camel@sipsolutions.net> (sfid-20141130_141420_785214_6D01E099)
Subject: Re: [RFC] mac80211: update the channel context after channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com
Date: Sun, 30 Nov 2014 14:14:12 +0100
In-Reply-To: <1417095717-23017-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141127_144646_275597_38604860)
References: <1417095717-23017-1-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20141127_144646_275597_38604860)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-27 at 15:41 +0200, Emmanuel Grumbach wrote:
> When the channel switch has been made, a vif is now using
> the channel context which was reserved. When that happens,
> we need to update the channel context since its parameters
> may change.
> 
> I hit a case in which I switched to a 40Mhz channel but the
> reserved channel context was still on 20Mhz. The rate control
> would try to send 40Mhz packets on a 20Mhz channel context and
> that made iwlwifi's firmware unhappy.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> This is a second version of the patch I sent earlier.
> I think the first version is more generic.

I prefer this version

1) if there really is a chanctx that can be in use and reserved at the
same time, it seems strange to mix the two concepts for the actual
operation of the chanctx

2) semantically, the reservation is so that nothing can steal the
chanctx, we don't really care much about the contents until we need it.

Please resend with [PATCH] and I'll merge it.

johannes

