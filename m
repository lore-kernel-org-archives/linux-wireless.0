Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbcARIq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 03:46:29 -0500
Date: Mon, 18 Jan 2016 09:45:00 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eli Cooper <elicooper@gmx.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: fix monitor mode regression
Message-ID: <20160118084500.GA3731@redhat.com> (sfid-20160118_094633_099445_5EB74B44)
References: <1452701232-12619-1-git-send-email-elicooper@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452701232-12619-1-git-send-email-elicooper@gmx.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 14, 2016 at 12:07:12AM +0800, Eli Cooper wrote:
> Since commit df1404650ccbfeb76a84f301f22316be0d00a864 monitor mode for rt2x00
> has been made effectively useless because the hardware filter is configured to
> drop packets whose intended recipient is not the device, regardless of the
> presence of monitor mode interfaces.
> 
> This patch fixes this regression by adding explicit monitor mode support, and
> configuring the hardware filter accordingly.
> 
> Signed-off-by: Eli Cooper <elicooper@gmx.com>
[snip]
>  	unsigned int intf_associated;
>  	unsigned int intf_beaconing;
> +	bool is_monitoring;

Could you change to use rt2x00dev->flags instead of new bool
variable i.e. introduce CONFIG_MONITORING in rt2x00_state_flags ?

> +	if (ieee80211_flags & IEEE80211_CONF_CHANGE_MONITOR) {
> +		if (conf->flags & IEEE80211_CONF_MONITOR) {
> +			rt2x00_dbg(rt2x00dev, "Monitor mode is enabled\n");

I don't think those debug messages are actually needed.

Thanks
Stanislaw
