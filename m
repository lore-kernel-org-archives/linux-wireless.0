Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab2B2MjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 07:39:22 -0500
Subject: Re: [PATCH] cfg80211: Add background scan period attribute.
From: Johannes Berg <johannes@sipsolutions.net>
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1330518896-15230-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120229_133516_521752_BEEDD972)
References: <1330518896-15230-1-git-send-email-bkamatch@qca.qualcomm.com>
	 (sfid-20120229_133516_521752_BEEDD972)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Feb 2012 13:39:14 +0100
Message-ID: <1330519154.4714.6.camel@jlt3.sipsolutions.net> (sfid-20120229_133927_045740_0B5B94C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 18:04 +0530, Bala Shanmugam wrote:
> Receive background scan period as part of connect
> command and pass the same to driver.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> ---
>  include/linux/nl80211.h |    8 ++++++++
>  include/net/cfg80211.h  |    2 ++
>  net/wireless/nl80211.c  |    7 +++++++
>  net/wireless/wext-sme.c |    5 +++++
>  4 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index ad56e21..7cef223 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -367,6 +367,9 @@
>   *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
>   *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
>   *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
> + *	Background scan period can also be
> + *	optionally specified in %NL80211_ATTR_BG_SCAN_PERIOD.
> + *	If period value is 0, bg scan will be disabled.

Nack. We leave out the attribute in those cases and make 0 an invalid
value.

Also please have this reviewed internally first. I'm tired of pointing
out all the whitespace, code formatting, etc. issues from QCA folks.

johannes

