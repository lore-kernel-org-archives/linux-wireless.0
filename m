Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2FFIwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:52:54 -0400
Message-ID: <1338972772.4513.25.camel@jlt3.sipsolutions.net> (sfid-20120606_105257_432031_3CBE2EE1)
Subject: Re: [RFC 02/14] cfg80211: check iface combinations only when intf
 is running
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:52:52 +0200
In-Reply-To: <1338203942-5667-3-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-3-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> Don't validate interface combinations on a stopped
> interface. Otherwise we might end up being able to
> create a new interface with a certain type, but
> won't be able to change an existing interface
> type.
> 
> This also skips some other functions when
> interface is stopped when changing interface type.
> 
> Change-Id: I02af110905184c8182aa30dc9054a2c53f0238d0
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/wireless/util.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 147f283..eb7ca3c 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -805,7 +805,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
>  	     ntype == NL80211_IFTYPE_P2P_CLIENT))
>  		return -EBUSY;
>  
> -	if (ntype != otype) {
> +	if (ntype != otype && netif_running(dev)) {

Yeah, makes sense, can you send it separately for 3.5?

johannes

