Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaCELCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 06:02:53 -0500
Message-ID: <1394017368.5275.17.camel@jlt4.sipsolutions.net> (sfid-20140305_120256_593995_83662D3E)
Subject: Re: [PATCH 3.14.0-rc5 v3 3/10] rsi: Adding core and main files
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fatima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 12:02:48 +0100
In-Reply-To: <53143A80.5010907@redpinesignals.com> (sfid-20140303_091846_012550_AEC79CCE)
References: <53143A80.5010907@redpinesignals.com>
	 (sfid-20140303_091846_012550_AEC79CCE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 13:47 +0530, Fariya Fatima wrote:

> + * @return 0 on success, -1 on failure.

The function should be void, you don't use its return value, nor would
that make sense.

> +xmit_fail:
> +	rsi_dbg(ERR_ZONE, "%s: Failed to queue packet\n", __func__);
> +	if (skb)
> +		dev_kfree_skb(skb);

You need to use the mac80211 free function for xmit skbs.

johannes


