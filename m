Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1DRM0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 08:26:52 -0400
Subject: Re: [PATCH 1/2] mac80211: allow low level drivers to report packet
 loss
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1303125749-31967-1-git-send-email-arik@wizery.com>
References: <1303125749-31967-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 14:26:50 +0200
Message-ID: <1303129610.3588.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-18 at 14:22 +0300, Arik Nemtsov wrote:
> Add API that allows low level drivers to notify mac80211 about TX
> packet loss. This is useful when there are FW triggers to notify the
> low level driver about these events.

> +void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
> +{
> +	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
> +	cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
> +				    num_packets, GFP_ATOMIC);

I think it would make more sense to add num_packets to sta->lost_packets
and invoke it only when over the threshold as done in
ieee80211_tx_status(), as then we can share any threshold calculation
improvements.

Also, are you sure? Do you really not get _any_ TX status?

johannes

