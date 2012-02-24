Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2BXHTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 02:19:17 -0500
Subject: Re: [PATCH] {nl,cfg,mac}80211: Enable control quality monitoring
 for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <1330050621-8955-1-git-send-email-ashok@cozybit.com> (sfid-20120224_033027_978577_9073776C)
References: <1330050621-8955-1-git-send-email-ashok@cozybit.com>
	 (sfid-20120224_033027_978577_9073776C)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 08:19:15 +0100
Message-ID: <1330067955.3426.3.camel@jlt3.sipsolutions.net> (sfid-20120224_081920_829476_AE012642)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 18:30 -0800, Ashok Nagarajan wrote:

> +/*
> + * NOTE: Mesh peer links are established only if average rssi of the peer
> + * candidate satisfies the threshold. sta_meets_rssi_treshold doesn't use
> + * hysteresis as fluctuations around threshold have no adverse effects.
> + */
> +
> +#define sta_meets_rssi_threshold(sta, sdata) \
> +		(sdata->vif.bss_conf.cqm_rssi_thold == 0 || \
> +		((s8) -ewma_read(&sta->avg_signal)) > \
> +		 sdata->vif.bss_conf.cqm_rssi_thold)

This also isn't right, you're using a value (bss_conf.cqm_rssi_thold)
intended for *signalling* for actual *decision making*.

johannes

