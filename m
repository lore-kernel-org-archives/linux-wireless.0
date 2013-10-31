Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3JaQrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 12:47:02 -0400
Message-ID: <1383238019.14302.8.camel@jlt4.sipsolutions.net> (sfid-20131031_174706_465342_6052D9F3)
Subject: Re: [PATCH 5/5] cfg80211: fix dfs channel state after stopping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Date: Thu, 31 Oct 2013 17:46:59 +0100
In-Reply-To: <1382984824-3729-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131028_192723_623319_18641FCD)
References: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1382984824-3729-5-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131028_192723_623319_18641FCD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 19:27 +0100, Janusz Dziedzic wrote:

> +	} else if (sdata->radar_required) {
> +		/*
> +		 * AP stopped on DFS channel so change that channel state
> +		 * to NL80211_DFS_USABLE again.
> +		 */
> +		cfg80211_leave_dfs_channel(wiphy, &sdata->vif.bss_conf.chandef);

Would it make sense to just do this in cfg80211?

johannes

