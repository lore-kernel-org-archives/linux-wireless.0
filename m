Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab2FUPGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 11:06:24 -0400
Message-ID: <1340291183.4489.39.camel@jlt3.sipsolutions.net> (sfid-20120621_170626_592484_14113ABE)
Subject: Re: [RFCv2 13/13] cfg80211: respect iface combinations when
 starting operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 17:06:23 +0200
In-Reply-To: <1340172859-18146-14-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	 <1340172859-18146-14-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:

> +++ b/net/wireless/mlme.c
> @@ -302,8 +302,14 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
>  	if (!req.bss)
>  		return -ENOENT;
>  
> +	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
> +				    CHAN_MODE_SHARED);
> +	if (err)
> +		goto end;

I think you need it in assoc too?


looks good!

johannes

