Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47892 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbcA0MRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 07:17:23 -0500
Message-ID: <1453897040.2351.3.camel@sipsolutions.net> (sfid-20160127_131726_366051_5927EBBD)
Subject: Re: [PATCH] wext: fix message delay/ordering
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beniamino Galvani <bgalvani@redhat.com>
Date: Wed, 27 Jan 2016 13:17:20 +0100
In-Reply-To: <1453896850-22775-1-git-send-email-johannes@sipsolutions.net> (sfid-20160127_131419_031860_43892E09)
References: <1453896850-22775-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20160127_131419_031860_43892E09)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 13:14 +0100, Johannes Berg wrote:
> 
> +static int wext_netdev_notifier_call(struct notifier_block *nb,
> +				     unsigned long state, void *ptr)
> +{
> +	/*
> +	 * When a netdev is unregistered, flush all pending messages
> +	 * to avoid them going out after the RTM_DELLINK, which can
> +	 * happen due to the schedule_work().
> +	 */
> +	if (state == NETDEV_UNREGISTER)
> +		wireless_nlevent_flush();
> 
It could be argued that the state check isn't really necessary and
should be removed to avoid ordering issues with up/down vs. wext, but
this fixes the really strange issue where you get an RTM_NEWLINK after
RTM_DELLINK (with the same ifidx), and I don't see how any software
would care much about the ordering otherwise.

johannes
