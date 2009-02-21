Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42961 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZBUWE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 17:04:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [PATCH] mac80211: Give it some time to do the TSF sync
Date: Sat, 21 Feb 2009 23:02:14 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
References: <20090221215202.227310@gmx.net>
In-Reply-To: <20090221215202.227310@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902212302.15056.mb@bu3sch.de> (sfid-20090221_230432_873756_6487D815)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 February 2009 22:52:02 Alina Friedrichsen wrote:
> Give slow hardware some time to do the TSF sync, to not run into an IBSS merging endless loop in some rarely situations. 

It would be great to put this into a source code comment.
Without this knowledge one immediately gets a WTF-lookalike face when seeing this code.

> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 1bbfc70..896e45c 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -332,7 +332,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>  	       jiffies);
>  #endif
>  
> -	if (beacon_timestamp > rx_timestamp) {
> +	if (beacon_timestamp > rx_timestamp && rx_timestamp > 0x400000) {
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
>  		printk(KERN_DEBUG "%s: beacon TSF higher than "
>  		       "local TSF - IBSS merge with BSSID %pM\n",
> 



-- 
Greetings, Michael.
