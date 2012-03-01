Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031098Ab2CAOXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:23:54 -0500
Subject: Re: [PATCH v2] cfg80211: Add background scan period attribute.
From: Johannes Berg <johannes@sipsolutions.net>
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1330583965-8415-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120301_073937_156683_BFB54260)
References: <1330583965-8415-1-git-send-email-bkamatch@qca.qualcomm.com>
	 (sfid-20120301_073937_156683_BFB54260)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 15:23:49 +0100
Message-ID: <1330611829.3623.6.camel@jlt3.sipsolutions.net> (sfid-20120301_152357_488014_BAA8CC9D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-01 at 12:09 +0530, Bala Shanmugam wrote:
> Receive background scan period as part of connect
> command and pass the same to driver.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> ---
>  include/linux/nl80211.h |    9 +++++++++
>  include/net/cfg80211.h  |    3 +++
>  net/wireless/nl80211.c  |    7 +++++++
>  net/wireless/wext-sme.c |    3 +++
>  4 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index be35a68..e81d327 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -369,6 +369,10 @@
>   *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
>   *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
>   *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
> + *	Background scan period can optionally be
> + *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
> + *	if not specified default background scan configuration
> + *	in driver is used and if period value is 0, bg scan will be disabled.

Maybe this should also indicate that the value is ignored unless the
device advertises roaming support with NL80211_ATTR_ROAM_SUPPORT?

I'm not sure I like the whole default value thing since it's kinda
magic, but I guess I can live with it.

johannes

