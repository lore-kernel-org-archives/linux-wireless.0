Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2IEN5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 09:57:47 -0400
Message-ID: <1346853503.4364.16.camel@jlt4.sipsolutions.net> (sfid-20120905_155750_731060_FC91BD36)
Subject: Re: [PATCH 2/2] mac80211: reply to AUTH frame with a DEAUTH if sta
 allocation fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Sep 2012 15:58:23 +0200
In-Reply-To: <1345995273-27358-2-git-send-email-ordex@autistici.org>
References: <1345995273-27358-1-git-send-email-ordex@autistici.org>
	 <1345995273-27358-2-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-08-26 at 17:34 +0200, Antonio Quartulli wrote:
> Whenever a host gets an AUTH frame it first allocates a new station and then
> replies with another AUTH frame. However, if sta allocations fails the host
> should send a DEAUTH frame instead to tell the other end that something went
> wrong

Well, ok, but...

>  	/*
> +	 * if we have any problem in allocating the new station, we reply with a
> +	 * DEAUTH frame to tell the other end that we had a problem
> +	 */
> +	if (!sta) {
> +		ieee80211_send_deauth_disassoc(sdata, sdata->u.ibss.bssid,
> +					       IEEE80211_STYPE_DEAUTH,
> +					       WLAN_REASON_UNSPECIFIED, true,
> +					       deauth_frame_buf);

You can't call the function in IBSS mode, it accesses sdata->u.mgd. You
should probably fix that in the first patch and make it conditional on
the sdata->vif.type actually being station mode.

johannes

