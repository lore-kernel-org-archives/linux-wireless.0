Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab2LKToV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:44:21 -0500
Message-ID: <1355255084.9819.12.camel@jlt4.sipsolutions.net> (sfid-20121211_204424_633539_836664E4)
Subject: Re: [PATCH 2/2] mac80211: fix AP_VLAN channel context handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Dec 2012 20:44:44 +0100
In-Reply-To: <1355254666.9819.11.camel@jlt4.sipsolutions.net> (sfid-20121211_203729_024742_AB210C1B)
References: <1355162256-34131-1-git-send-email-nbd@openwrt.org>
	 <1355162256-34131-2-git-send-email-nbd@openwrt.org>
	 <1355254666.9819.11.camel@jlt4.sipsolutions.net>
	 (sfid-20121211_203729_024742_AB210C1B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 20:37 +0100, Johannes Berg wrote:
> I still don't like the lock-free stuff, I'll apply the patch below
> instead.

Well, modulo the bugs:


> +	conf = rcu_dereference_protected(ap->vif.chanctx_conf,
> +					 lockdep_is_held(&local->chanctx_mtx));
> +	if (WARN_ON(!conf))
> +		goto unlock;

get rid of this


> -		else
> -			netif_carrier_off(dev);
> +		} else {
> +			netif_carrier_on(dev);

and don't mess up this

johannes

