Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33645 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756279AbXD1Nkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 09:40:52 -0400
Date: Sat, 28 Apr 2007 15:40:49 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jkm@devicescape.com>
Subject: Re: [PATCH] mac80211: optimise ieee80211_get_hdrlen
Message-ID: <20070428154049.313d5491@logostar.upir.cz>
In-Reply-To: <1177686617.3565.27.camel@johannes.berg>
References: <1175011305.9282.10.camel@johannes.berg>
	<20070328191116.GJ6036@devicescape.com>
	<1177686617.3565.27.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 17:10:17 +0200, Johannes Berg wrote:
> --- wireless-dev.orig/net/mac80211/ieee80211.c	2007-04-27 12:03:38.334987898 +0200
> +++ wireless-dev/net/mac80211/ieee80211.c	2007-04-27 12:03:43.034987898 +0200
> @@ -255,21 +255,32 @@ int ieee80211_get_hdrlen(u16 fc)
>  
>  	switch (fc & IEEE80211_FCTL_FTYPE) {
>  	case IEEE80211_FTYPE_DATA:
> -		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
> +		if (unlikely((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS)))

This is not unlikely if you have a WDS link set up. I wouldn't change the
condition.

 Jiri

-- 
Jiri Benc
SUSE Labs
