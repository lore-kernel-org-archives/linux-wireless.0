Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56366 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbcCCOzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 09:55:53 -0500
Message-ID: <1457016949.2044.12.camel@sipsolutions.net> (sfid-20160303_155555_946132_06EB622B)
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: set A-MSDU tx limits
 based on selected max_prob_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: egrumbach@gmail.com
Date: Thu, 03 Mar 2016 15:55:49 +0100
In-Reply-To: <1456306140-78485-2-git-send-email-nbd@openwrt.org>
References: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
	 <1456306140-78485-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-24 at 10:29 +0100, Felix Fietkau wrote:

> +	/*
> +	 * If the rate is slower than single-stream MCS4, limit A-MSDU to usual
> +	 * data packet size
> +	 */
> +	if (g->duration[rate] > MCS_DURATION(1, 0, 104))
> +		return 1500;
> +
> +	/*
> +	 * If the rate is slower than single-stream MCS7, limit A-MSDU to twice
> +	 * the usual data packet size
> +	 */
> +	if (g->duration[rate] > MCS_DURATION(1, 0, 260))
> +		return 3000;

This isn't *quite* right, since you have to take an 802.11 header (vs.
an ethernet header) into account, I think?

johannes
