Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3APXds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 18:33:48 -0500
Message-ID: <1358379254.15012.70.camel@jlt4.sipsolutions.net> (sfid-20130117_003351_083714_C9B581FA)
Subject: Re: [RFC 1/3] mac80211: Add flushes to ensure off-channel PS is
 enabled during sw scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 00:34:14 +0100
In-Reply-To: <1357668645-5101-2-git-send-email-seth.forshee@canonical.com>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
	 <1357668645-5101-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 12:10 -0600, Seth Forshee wrote:

> +++ b/net/mac80211/offchannel.c
> @@ -136,8 +136,23 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
>  			netif_tx_stop_all_queues(sdata->dev);
>  			if (offchannel_ps_enable &&
>  			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
> -			    sdata->u.mgd.associated)
> +			    sdata->u.mgd.associated) {
> +				/*
> +				 * Need to flush frames in driver queues
> +				 * before sending nullfunc. Otherwise
> +				 * devices which support QoS may send the
> +				 * nullfunc before these queued frames, and
> +				 * those frames may not have PM set.
> +				 *
> +				 * XXX: Would be nice to not flush for each
> +				 * vif, however I don't see that there's any
> +				 * protection to prevent frames being handed
> +				 * to the driver before stopping the netdev
> +				 * queue.
> +				 */
> +				drv_flush(local, false);
>  				ieee80211_offchannel_ps_enable(sdata);

Could we split the loop, and send the frames in a second loop, to
combine the flushes into a single one?

johannes

