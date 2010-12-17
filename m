Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0LQJu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 04:50:59 -0500
Subject: Re: [RFC 3/8] cfg80211: pass DFS region to drivers through
 reg_notifier()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292556197-4820-4-git-send-email-lrodriguez@atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
	 <1292556197-4820-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 10:50:57 +0100
Message-ID: <1292579457.3715.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 19:23 -0800, Luis R. Rodriguez wrote:

>  	/* Lets us get back the wiphy on the callback */
>  	int (*reg_notifier)(struct wiphy *wiphy,
> -			    struct regulatory_request *request);
> +			    struct regulatory_request *request,
> +			    u8 dfs_region);

So does that mean we need to implement a reg_notifier if we want to have
radar detection? Doesn't an empty reg_notifier already alter behaviour
somewhere which would make this not feasible?

johannes

