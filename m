Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42313 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab1FXTCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:02:00 -0400
Message-ID: <4E04DF26.6060300@openwrt.org> (sfid-20110624_210212_573716_0CDCE144)
Date: Fri, 24 Jun 2011 21:01:58 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Alexander Simon <alexander.simon@saxnet.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 1/3] mac80211: add some helper functions
References: <1308671129.2656.4.camel@alex-2>
In-Reply-To: <1308671129.2656.4.camel@alex-2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-21 5:45 PM, Alexander Simon wrote:
> Add helper functions cfg80211_get_bss_ht, ieee80211_ie_build_ht_cap
> and ieee80211_ie_build_ht_info.
> These are needed for my IBSS HT patch but are also used to clean up some
> multiple code.
>
> Signed-off-by: Alexander Simon<alexander.simon@saxnet.de>
> ---
>   include/net/cfg80211.h     |    6 ++
>   net/mac80211/ieee80211_i.h |    8 +++
>   net/mac80211/util.c        |  116 ++++++++++++++++++++++++++++++++++++++-------
>   net/mac80211/work.c        |   29 -----------
>   net/wireless/scan.c        |   36 +++++++++++++
>   5 files changed, 148 insertions(+), 47 deletions(-)
>
> diff -Nrup a/net/wireless/scan.c b/net/wireless/scan.c
> --- a/net/wireless/scan.c	2011-06-01 21:04:32.000000000 +0200
> +++ b/net/wireless/scan.c	2011-06-21 13:21:38.000000000 +0200
> @@ -370,7 +401,8 @@ struct cfg80211_bss *cfg80211_get_bss(st
>   		return NULL;
>   	return&res->pub;
>   }
>   EXPORT_SYMBOL(cfg80211_get_bss);
> +EXPORT_SYMBOL(cfg80211_get_bss_ht);
Duplicate export of cfg80211_get_bss

- Felix
