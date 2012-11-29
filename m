Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2K2Odu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 09:33:50 -0500
Message-ID: <1354199652.879.2.camel@jlt4.sipsolutions.net> (sfid-20121129_153403_356267_A9B5C1D7)
Subject: Re: [PATCH] mac80211: add debugfs file for last rx rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 29 Nov 2012 15:34:12 +0100
In-Reply-To: <50B77013.6040508@posedge.com>
References: <50B77013.6040508@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 19:54 +0530, Saravana wrote:
> Add a debugfs file showing the rate at which
> the last packet is received.

Applied, but:

> +static ssize_t sta_last_rx_rate_read(struct file *file, char __user *userbuf,
> +				      size_t count, loff_t *ppos)

fixed indentation here


> +	return mac80211_format_buffer(userbuf, count, ppos, "%d.%d MBit/s\n",
> +					rate/10, rate%10);

and here

(and also a bunch of whitespace changes in the other patches)

johannes

