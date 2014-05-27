Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34900 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaE0Rzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 13:55:44 -0400
Message-ID: <1401213335.8146.11.camel@jlt4.sipsolutions.net> (sfid-20140527_195548_014216_B05579A9)
Subject: Re: [PATCH] mac80211: fix a memory leak on sta rate selection table
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, cprevotaux@nltinc.com
Date: Tue, 27 May 2014 19:55:35 +0200
In-Reply-To: <1400866194-62234-1-git-send-email-nbd@openwrt.org>
References: <1400866194-62234-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 19:29 +0200, Felix Fietkau wrote:
> Cc: stable@vger.kernel.org
> Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

As Ben said, a Fixes: line would be good - probably also needs Cc
stable.


> +	rates = rcu_dereference_protected(sta->sta.rates, true);
> +	if (rates)
> +		kfree(rates);

That seems like it should just be rcu_dereference_raw()? That's really
the same (it's a macro), but less verbose.

johannes

