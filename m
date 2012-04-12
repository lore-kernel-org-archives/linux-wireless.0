Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2DLE2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 00:28:17 -0400
Message-ID: <1334204861.3788.20.camel@jlt3.sipsolutions.net> (sfid-20120412_062819_720453_FE1ED9A5)
Subject: Re: [PATCH] cfg80211: fix interface combinations check.
From: Johannes Berg <johannes@sipsolutions.net>
To: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Apr 2012 06:27:41 +0200
In-Reply-To: <1334148910-25178-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1334148910-25178-1-git-send-email-lukasz.kucharczyk@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-11 at 14:55 +0200, Lukasz Kucharczyk wrote:
> Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>

Good catch, should this be Cc stable?

johannes


> ---
>  net/wireless/util.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 1b7a08d..957f256 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -989,7 +989,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
>  			if (rdev->wiphy.software_iftypes & BIT(iftype))
>  				continue;
>  			for (j = 0; j < c->n_limits; j++) {
> -				if (!(limits[j].types & iftype))
> +				if (!(limits[j].types & BIT(iftype)))
>  					continue;
>  				if (limits[j].max < num[iftype])
>  					goto cont;


