Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40603 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaFFGKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 02:10:33 -0400
Message-ID: <1402035030.4158.2.camel@jlt4.sipsolutions.net> (sfid-20140606_081043_149213_38543E7A)
Subject: Re: [PATCH] cfg80211: make ethtool the driver's responsibility
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 06 Jun 2014 08:10:30 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F70430FE1BF2FB7@SC-VEXCH1.marvell.com>
References: <1401896290-12942-1-git-send-email-johannes@sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430FE1BF2FB7@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-05 at 16:16 -0700, Bing Zhao wrote:
> Hi Johannes,

> Amitkumar found that set_ringparam and get_ringparam are forgotten to be removed from cfg80211_ops.
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index dc93c6b..29cb4b2 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2266,10 +2266,6 @@ struct cfg80211_qos_map {
>   *
>   * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
>   *
> - * @set_ringparam: Set tx and rx ring sizes.

Oops, good catch, thanks!

johannes

