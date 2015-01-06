Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58612 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbbAFKnq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:43:46 -0500
Message-ID: <1420541023.1966.14.camel@sipsolutions.net> (sfid-20150106_114349_968706_9FD6D0C1)
Subject: Re: [PATCH] mac80211: add TDLS supported channels correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Jan 2015 11:43:43 +0100
In-Reply-To: <1419847143-25447-1-git-send-email-arik@wizery.com> (sfid-20141229_105906_832362_49F83F92)
References: <1419847143-25447-1-git-send-email-arik@wizery.com>
	 (sfid-20141229_105906_832362_49F83F92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-29 at 11:59 +0200, Arik Nemtsov wrote:
> The function adding the supported channels IE during a TDLS connection had
> several issues:
> 1. If the entire subband is usable, the function exitted the loop without
> adding it
> 2. The function only checked chandef_usable, ignoring flags like RADAR
> which would prevent TDLS off-channel communcation.
> 3. HT20 was explicitly required in the chandef, while not a requirement
> for TDLS off-channel.


That's a strangely formatted commit message ... :)


> +			if (cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
> +						    &chandef,
> +						    sdata->wdev.iftype)) {
>  				ch_cnt++;
>  				continue;

With some thinking, I can understand it - but that means you need a
comment here.

johannes

