Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab0IUTbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:31:02 -0400
Subject: Re: [RFC] mac80211: Deny new BA sessions from being started during
 offchannel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, srinivasa.duvvuri@atheros.com,
	matt.smith@atheros.com, bennyam.malavazi@atheros.com
In-Reply-To: <1285097222-10286-1-git-send-email-lrodriguez@atheros.com>
References: <1285097222-10286-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 21:31:00 +0200
Message-ID: <1285097460.12764.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 15:27 -0400, Luis R. Rodriguez wrote:

> +	mutex_lock(&local->sta_mtx);
> +	list_for_each_entry(sta, &local->sta_list, list)
> +		if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
> +			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
> +	mutex_unlock(&local->sta_mtx);
> +

This is really expensive, I don't think we should do it this way.
Wouldn't it be possible to put a check into place wherever the flag is
checked too?

johannes

