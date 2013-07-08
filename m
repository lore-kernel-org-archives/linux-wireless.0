Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3GHLPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 07:15:37 -0400
Message-ID: <1373282132.8312.9.camel@jlt4.sipsolutions.net> (sfid-20130708_131600_590226_AA2142E6)
Subject: Re: [PATCH v5] cfg80211/nl80211: Add packet coalesce support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 08 Jul 2013 13:15:32 +0200
In-Reply-To: <1372445486-10466-1-git-send-email-bzhao@marvell.com>
References: <1372445486-10466-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-06-28 at 11:51 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> In most cases, host that receives IPv4 and IPv6 multicast/broadcast
> packets does not do anything with these packets. Therefore the
> reception of these unwanted packets causes unnecessary processing
> and power consumption.
> 
> Packet coalesce feature helps to reduce number of received
> interrupts to host by buffering these packets in firmware/hardware
> for some predefined time. Received interrupt will be generated when
> one of the following events occur.
> a) Expiration of hardware timer whose expiration time is set to
> maximum coalescing delay of matching coalesce rule.
> b) Coalescing buffer in hardware reaches it's limit.
> c) Packet doesn't match any of the configured coalesce rules.
> 
> This patch adds set/get configuration support for packet coalesce.
> User needs to configure following parameters for creating a coalesce
> rule.
> a) Maximum coalescing delay
> b) List of packet patterns which needs to be matched
> c) Condition for coalescence. pattern 'match' or 'no match'
> Multiple such rules can be created.
> 
> This feature needs to be advertised during driver initialization.
> Drivers are supposed to do required firmware/hardware settings based
> on user configuration.

Applied.

johannes

