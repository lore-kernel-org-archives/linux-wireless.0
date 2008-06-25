Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62159 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYFYP6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 11:58:49 -0400
Subject: Re: [PATCH 3/4 V2] mac80211: add last beacon time in scan list
From: Pavel Roskin <proski@gnu.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com>
References: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 11:58:47 -0400
Message-Id: <1214409527.5881.21.camel@dv> (sfid-20080625_175852_594095_A7F88457)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-25 at 15:17 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This patch adds the interval between the scan results and the last time a
> beacon was received in the result of the scan.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/mlme.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7b930d1..e76e62a 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -4658,12 +4658,26 @@ ieee80211_sta_scan_result(struct net_device *dev,
>  		char *buf;
>  		buf = kmalloc(30, GFP_ATOMIC);
>  		if (buf) {
> +			unsigned long mid_range = (-1) / 2 + 1;

What is that?  I guess that's where Riemann's zeta function has its
non-trivial roots :-)

> +			time_diff = jiffies - bss->last_update > mid_range ?
> +				jiffies - bss->last_update :
> +				bss->last_update - jiffies;

That's pretty hairy.  Do we really lack a function to calculate time
difference?

> +			sprintf(buf, "Last beacon:%dms ago",
> +				jiffies_to_msecs(time_diff));

You lost space after the colon for some reason.

-- 
Regards,
Pavel Roskin
