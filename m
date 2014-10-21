Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37089 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJUDza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 23:55:30 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21573.55666.43231.68176@gargle.gargle.HOWL> (sfid-20141021_055533_973683_70E9A3A4)
Date: Tue, 21 Oct 2014 09:26:34 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
In-Reply-To: <1413809136.24269.0.camel@jlt4.sipsolutions.net>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	<21568.29077.518022.812356@gargle.gargle.HOWL>
	<1413797588.10246.3.camel@jlt4.sipsolutions.net>
	<21572.55536.308167.684155@gargle.gargle.HOWL>
	<1413798712.10246.14.camel@jlt4.sipsolutions.net>
	<21572.58249.490532.207564@gargle.gargle.HOWL>
	<1413801423.10246.16.camel@jlt4.sipsolutions.net>
	<21572.60015.349942.74265@gargle.gargle.HOWL>
	<1413806542.10246.21.camel@jlt4.sipsolutions.net>
	<1413809136.24269.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Maybe we need something like this:
> 
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index af0d094b2f2f..45b74ab1c59d 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -985,7 +985,6 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
>  			drv_cancel_hw_scan(local,
>  				rcu_dereference_protected(local->scan_sdata,
>  						lockdep_is_held(&local->mtx)));
> -		goto out;
>  	}

Is the big comment at the beginning of ieee80211_scan_cancel()
outdated ? It does seem valid to me, at least the point about
not cancelling scan_work for HW scan.

Sujith
