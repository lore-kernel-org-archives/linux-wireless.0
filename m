Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0137.hostedemail.com ([216.40.44.137]:50551 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966120AbbLQBQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 20:16:15 -0500
Message-ID: <1450314972.5661.2.camel@perches.com> (sfid-20151217_021622_618001_1BEBA566)
Subject: Re: [PATCH] Print warnings for missing cfg80211_ops implementations
From: Joe Perches <joe@perches.com>
To: Ola Olsson <ola1olsson@gmail.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Wed, 16 Dec 2015 17:16:12 -0800
In-Reply-To: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
References: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-12-16 at 22:43 +0100, Ola Olsson wrote:
> Print a warning whenever an expected callback function
> lacks implementation.
> 
> Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
> ---
>  net/wireless/core.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index b091551..3a9c41b 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -352,6 +352,16 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
>  	WARN_ON(ops->add_station && !ops->del_station);
>  	WARN_ON(ops->add_mpath && !ops->del_mpath);
>  	WARN_ON(ops->join_mesh && !ops->leave_mesh);
> +	WARN_ON(ops->start_p2p_device && !ops->stop_p2p_device);
> +	WARN_ON(ops->start_ap && !ops->stop_ap);
> +	WARN_ON(ops->join_ocb && !ops->leave_ocb);
> +	WARN_ON(ops->suspend && !ops->resume);
> +	WARN_ON(ops->sched_scan_start && !ops->sched_scan_stop);
> +	WARN_ON(ops->remain_on_channel && !ops->cancel_remain_on_channel);
> +	WARN_ON(ops->tdls_channel_switch && !ops->tdls_cancel_channel_switch);
> +	WARN_ON(ops->add_tx_ts && !ops->del_tx_ts);
> +	WARN_ON(ops->set_tx_power && !ops->get_tx_power);
> +	WARN_ON(ops->set_antenna && !ops->get_antenna);

maybe all of these should be a nand b?

