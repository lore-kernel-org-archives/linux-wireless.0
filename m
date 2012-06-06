Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFJL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:11:57 -0400
Message-ID: <1338973916.4513.44.camel@jlt3.sipsolutions.net> (sfid-20120606_111208_494044_BA4E6D70)
Subject: Re: [RFC 09/14] cfg80211: refuse to .set_monitor_channel when
 non-monitors are present
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 11:11:56 +0200
In-Reply-To: <1338203942-5667-10-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-10-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> Having .set_monitor_channel work with non-monitor
> interfaces running would make interface
> combinations accounting ambiguous.
> 
> Change-Id: I2d579b483fe3c2998c50dcf89600740188f79733
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/wireless/chan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 45b28ab..4d71b38 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -85,6 +85,8 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
>  
>  	if (!rdev->ops->set_monitor_channel)
>  		return -EOPNOTSUPP;
> +	if (!cfg80211_has_monitors_only(rdev))
> +		return -EBUSY;

Makes sense.

johannes

