Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2ECTAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:00:18 -0400
Message-ID: <1336071617.5167.9.camel@jlt3.sipsolutions.net> (sfid-20120503_210022_470470_1DA3BBFB)
Subject: Re: [PATCH] cfg80211: Remove compile warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 May 2012 21:00:17 +0200
In-Reply-To: <1335357955-28089-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120425_144514_783980_CE23A8CA)
References: <1335357955-28089-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 (sfid-20120425_144514_783980_CE23A8CA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-25 at 15:45 +0300, Andrei Emeltchenko wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> 
> Use default key to handle similar iface types. This removes compile warnings:
> 
> net/wireless/util.c: In function ‘cfg80211_change_iface’:
> net/wireless/util.c:846:3: warning: enumeration value ‘NL80211_IFTYPE_MAX’
> 	not handled in switch [-Wswitch]
> 
> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> ---
>  net/wireless/util.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 1b7a08d..468dc8b 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -862,8 +862,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
>  		case NL80211_IFTYPE_MONITOR:
>  			/* monitor can't bridge anyway */
>  			break;
> -		case NL80211_IFTYPE_UNSPECIFIED:
> -		case NUM_NL80211_IFTYPES:
> +		default:

When did this warning start occurring? I was pretty sure it didn't use
to? I think we should explicitly list the cases here though because we
want the compiler to warn here when we add something to the interface
type list so we catch this place that may have to be modified.

johannes

